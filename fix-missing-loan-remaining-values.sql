-- =====================================================
-- CORREÇÃO: VALORES RESTANTES DOS EMPRÉSTIMOS PERDIDOS
-- =====================================================
-- Este script corrige o problema onde os valores restantes dos empréstimos
-- sumiram nas empresas MOGIANA e LITORAL. O problema pode estar relacionado
-- aos triggers automáticos ou ao campo remaining_amount nas tabelas de status.
-- =====================================================

-- =====================================================
-- 1. DIAGNÓSTICO DO PROBLEMA
-- =====================================================

-- Verificar se o campo original_amount existe na tabela loans
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'loans' AND column_name = 'original_amount'
    ) THEN
        RAISE NOTICE '❌ PROBLEMA IDENTIFICADO: Campo original_amount não existe na tabela loans';
        RAISE NOTICE '🔧 APLICANDO CORREÇÃO: Adicionando campo original_amount...';
        
        -- Adicionar campo original_amount se não existir
        ALTER TABLE loans ADD COLUMN original_amount DECIMAL(10,2);
        
        -- Preencher com valores atuais
        UPDATE loans SET original_amount = amount WHERE original_amount IS NULL;
        
        -- Tornar obrigatório
        ALTER TABLE loans ALTER COLUMN original_amount SET NOT NULL;
        
        RAISE NOTICE '✅ Campo original_amount adicionado e preenchido';
    ELSE
        RAISE NOTICE '✅ Campo original_amount já existe';
    END IF;
END $$;

-- =====================================================
-- 2. VERIFICAR ESTADO ATUAL DOS EMPRÉSTIMOS
-- =====================================================

-- Mostrar estatísticas gerais
SELECT 
    'DIAGNÓSTICO GERAL' as tipo,
    COUNT(*) as total_emprestimos,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as ativos,
    COUNT(CASE WHEN status = 'overdue' THEN 1 END) as vencidos,
    COUNT(CASE WHEN status = 'paid' THEN 1 END) as quitados,
    COUNT(CASE WHEN status = 'partial_paid' THEN 1 END) as parciais,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelados
FROM loans;

-- Verificar empréstimos com problemas de valor
SELECT 
    'EMPRÉSTIMOS COM PROBLEMAS' as tipo,
    COUNT(*) as total,
    COUNT(CASE WHEN amount = 0 THEN 1 END) as valor_zero,
    COUNT(CASE WHEN original_amount IS NULL THEN 1 END) as sem_valor_original,
    COUNT(CASE WHEN amount != original_amount THEN 1 END) as valores_diferentes
FROM loans
WHERE amount = 0 OR original_amount IS NULL OR amount != original_amount;

-- =====================================================
-- 3. RECALCULAR VALORES RESTANTES NAS TABELAS DE STATUS
-- =====================================================

-- Função para recalcular remaining_amount baseado no valor original
CREATE OR REPLACE FUNCTION recalculate_remaining_amounts()
RETURNS void AS $$
DECLARE
    loan_record RECORD;
    total_paid DECIMAL(10,2);
    original_total DECIMAL(10,2);
    remaining_amount DECIMAL(10,2);
BEGIN
    RAISE NOTICE '🔄 Iniciando recálculo de valores restantes...';
    
    -- Para cada empréstimo ativo ou vencido
    FOR loan_record IN 
        SELECT l.*, COALESCE(l.original_amount, l.amount) as valor_original
        FROM loans l 
        WHERE l.status IN ('active', 'overdue', 'partial_paid')
    LOOP
        -- Calcular total pago
        SELECT COALESCE(SUM(p.amount), 0) INTO total_paid
        FROM payments p 
        WHERE p.loan_id = loan_record.id;
        
        -- Calcular valor total original com juros
        original_total := loan_record.valor_original + (loan_record.valor_original * loan_record.interest_rate / 100);
        
        -- Calcular valor restante
        remaining_amount := GREATEST(0, original_total - total_paid);
        
        -- Atualizar tabela overdue_loans se existir
        UPDATE overdue_loans 
        SET 
            remaining_amount = remaining_amount,
            total_paid = total_paid,
            original_amount = loan_record.valor_original,
            total_with_interest = original_total,
            updated_at = NOW()
        WHERE loan_id = loan_record.id;
        
        -- Atualizar tabela partial_paid_loans se existir
        UPDATE partial_paid_loans 
        SET 
            remaining_amount = remaining_amount,
            total_paid = total_paid,
            original_amount = loan_record.valor_original,
            total_with_interest = original_total,
            updated_at = NOW()
        WHERE loan_id = loan_record.id;
        
        -- Se o empréstimo principal tem valor zero, restaurar
        IF loan_record.amount = 0 AND loan_record.valor_original > 0 THEN
            UPDATE loans 
            SET amount = loan_record.valor_original
            WHERE id = loan_record.id;
            
            RAISE NOTICE '🔧 Restaurado valor do empréstimo ID: % - Valor: %', 
                loan_record.id, loan_record.valor_original;
        END IF;
    END LOOP;
    
    RAISE NOTICE '✅ Recálculo concluído!';
END;
$$ LANGUAGE plpgsql;

-- Executar a função de recálculo
SELECT recalculate_remaining_amounts();

-- =====================================================
-- 4. CORRIGIR TRIGGERS PARA USAR VALOR ORIGINAL
-- =====================================================

-- Recriar trigger para empréstimos vencidos com valor original
CREATE OR REPLACE FUNCTION insert_overdue_loan()
RETURNS TRIGGER AS $$
DECLARE
    original_amount_value DECIMAL(10,2);
    total_paid_amount DECIMAL(10,2);
    total_with_interest DECIMAL(10,2);
    remaining_amount DECIMAL(10,2);
BEGIN
    IF NEW.due_date < CURRENT_DATE AND NEW.status NOT IN ('paid', 'cancelled') THEN
        -- Usar original_amount se disponível, senão amount
        original_amount_value := COALESCE(NEW.original_amount, NEW.amount);
        
        -- Calcular total pago
        SELECT COALESCE(SUM(amount), 0) INTO total_paid_amount
        FROM payments WHERE loan_id = NEW.id;
        
        -- Calcular total com juros baseado no valor original
        total_with_interest := original_amount_value + (original_amount_value * NEW.interest_rate / 100);
        
        -- Calcular valor restante
        remaining_amount := GREATEST(0, total_with_interest - total_paid_amount);
        
        INSERT INTO overdue_loans (
            loan_id, client_id, original_amount, interest_rate,
            total_with_interest, loan_date, due_date, days_overdue,
            remaining_amount, total_paid, created_by
        ) VALUES (
            NEW.id, NEW.client_id, original_amount_value, NEW.interest_rate,
            total_with_interest, NEW.loan_date, NEW.due_date,
            CURRENT_DATE - NEW.due_date,
            remaining_amount, total_paid_amount, NEW.created_by
        )
        ON CONFLICT (loan_id) DO UPDATE SET
            days_overdue = CURRENT_DATE - NEW.due_date,
            remaining_amount = remaining_amount,
            total_paid = total_paid_amount,
            original_amount = original_amount_value,
            total_with_interest = total_with_interest,
            updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Recriar trigger para empréstimos parciais com valor original
CREATE OR REPLACE FUNCTION insert_partial_paid_loan()
RETURNS TRIGGER AS $$
DECLARE
    original_amount_value DECIMAL(10,2);
    total_paid_amount DECIMAL(10,2);
    total_with_interest DECIMAL(10,2);
    remaining_amount DECIMAL(10,2);
BEGIN
    IF NEW.status = 'partial_paid' AND (OLD IS NULL OR OLD.status != 'partial_paid') THEN
        -- Usar original_amount se disponível, senão amount
        original_amount_value := COALESCE(NEW.original_amount, NEW.amount);
        
        -- Calcular total pago
        SELECT COALESCE(SUM(amount), 0) INTO total_paid_amount
        FROM payments WHERE loan_id = NEW.id;
        
        -- Calcular total com juros baseado no valor original
        total_with_interest := original_amount_value + (original_amount_value * NEW.interest_rate / 100);
        
        -- Calcular valor restante
        remaining_amount := GREATEST(0, total_with_interest - total_paid_amount);
        
        INSERT INTO partial_paid_loans (
            loan_id, client_id, original_amount, interest_rate,
            total_with_interest, loan_date, due_date, total_paid,
            remaining_amount, payment_count, last_payment_date, created_by
        ) VALUES (
            NEW.id, NEW.client_id, original_amount_value, NEW.interest_rate,
            total_with_interest, NEW.loan_date, NEW.due_date, total_paid_amount,
            remaining_amount,
            (SELECT COUNT(*) FROM payments WHERE loan_id = NEW.id),
            (SELECT MAX(payment_date) FROM payments WHERE loan_id = NEW.id),
            NEW.created_by
        )
        ON CONFLICT (loan_id) DO UPDATE SET
            total_paid = total_paid_amount,
            remaining_amount = remaining_amount,
            original_amount = original_amount_value,
            total_with_interest = total_with_interest,
            payment_count = (SELECT COUNT(*) FROM payments WHERE loan_id = NEW.id),
            last_payment_date = (SELECT MAX(payment_date) FROM payments WHERE loan_id = NEW.id),
            updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 5. VERIFICAÇÃO FINAL E RELATÓRIO
-- =====================================================

-- Relatório de empréstimos corrigidos
SELECT 
    'RELATÓRIO FINAL' as tipo,
    l.id,
    c.name as cliente,
    l.original_amount as valor_original,
    l.amount as valor_atual,
    l.interest_rate as taxa_juros,
    (l.original_amount * l.interest_rate / 100) as juros_originais,
    (l.original_amount + (l.original_amount * l.interest_rate / 100)) as total_com_juros,
    COALESCE(p.total_pago, 0) as total_pago,
    GREATEST(0, (l.original_amount + (l.original_amount * l.interest_rate / 100)) - COALESCE(p.total_pago, 0)) as valor_restante,
    l.status,
    l.due_date as vencimento
FROM loans l
LEFT JOIN clients c ON l.client_id = c.id
LEFT JOIN (
    SELECT loan_id, SUM(amount) as total_pago
    FROM payments 
    GROUP BY loan_id
) p ON l.id = p.loan_id
WHERE l.status IN ('active', 'overdue', 'partial_paid')
ORDER BY l.created_at DESC;

-- Verificar se as tabelas de status foram atualizadas
SELECT 
    'TABELAS DE STATUS ATUALIZADAS' as tipo,
    (SELECT COUNT(*) FROM overdue_loans WHERE remaining_amount > 0) as vencidos_com_valor,
    (SELECT COUNT(*) FROM partial_paid_loans WHERE remaining_amount > 0) as parciais_com_valor,
    (SELECT COUNT(*) FROM overdue_loans WHERE remaining_amount = 0) as vencidos_sem_valor,
    (SELECT COUNT(*) FROM partial_paid_loans WHERE remaining_amount = 0) as parciais_sem_valor;

-- =====================================================
-- MENSAGEM FINAL
-- =====================================================
DO $$
BEGIN
    RAISE NOTICE '🎉 CORREÇÃO CONCLUÍDA!';
    RAISE NOTICE '✅ Valores originais preservados';
    RAISE NOTICE '✅ Valores restantes recalculados';
    RAISE NOTICE '✅ Triggers atualizados';
    RAISE NOTICE '📊 Execute as consultas acima para verificar os resultados';
    RAISE NOTICE '';
    RAISE NOTICE '🔍 PRÓXIMOS PASSOS:';
    RAISE NOTICE '1. Execute este script nas empresas MOGIANA e LITORAL';
    RAISE NOTICE '2. Verifique os relatórios gerados';
    RAISE NOTICE '3. Teste a criação de novos empréstimos';
    RAISE NOTICE '4. Verifique se os valores restantes aparecem corretamente na interface';
END $$;

-- =====================================================
-- INSTRUÇÕES DE USO
-- =====================================================
/*
COMO USAR ESTE SCRIPT:

1. PARA EMPRESA MOGIANA:
   - Acesse o SQL Editor do Supabase da MOGIANA
   - Cole e execute todo este script
   - Verifique os relatórios gerados

2. PARA EMPRESA LITORAL:
   - Acesse o SQL Editor do Supabase da LITORAL
   - Cole e execute todo este script
   - Verifique os relatórios gerados

3. VERIFICAÇÃO:
   - Os valores restantes devem aparecer corretamente
   - Novos empréstimos devem funcionar normalmente
   - Interface deve mostrar valores corretos

4. MONITORAMENTO:
   - Acompanhe se o problema se repete
   - Verifique logs de erro na aplicação
   - Monitore a integridade dos dados

O script é seguro e pode ser executado múltiplas vezes.
*/