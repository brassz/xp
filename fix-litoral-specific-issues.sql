-- =====================================================
-- CORREÇÃO ESPECÍFICA: EMPRESA LITORAL
-- =====================================================
-- Script específico para corrigir problemas na empresa LITORAL
-- que não foram resolvidos pela correção geral
-- =====================================================

-- =====================================================
-- 1. DIAGNÓSTICO ESPECÍFICO LITORAL
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE '🔍 INICIANDO DIAGNÓSTICO ESPECÍFICO - EMPRESA LITORAL';
    RAISE NOTICE '================================================';
END $$;

-- Verificar versão do PostgreSQL e extensões
SELECT 
    'INFORMAÇÕES DO SISTEMA' as tipo,
    version() as versao_postgresql,
    current_database() as database_atual,
    current_user as usuario_atual;

-- Verificar se todas as tabelas existem
SELECT 'VERIFICAÇÃO DE TABELAS CRÍTICAS' as tipo;

DO $$
DECLARE
    tabela_faltando TEXT := '';
BEGIN
    -- Verificar tabelas essenciais
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'loans') THEN
        tabela_faltando := tabela_faltando || 'loans, ';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'payments') THEN
        tabela_faltando := tabela_faltando || 'payments, ';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'overdue_loans') THEN
        tabela_faltando := tabela_faltando || 'overdue_loans, ';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'partial_paid_loans') THEN
        tabela_faltando := tabela_faltando || 'partial_paid_loans, ';
    END IF;
    
    IF tabela_faltando != '' THEN
        RAISE NOTICE '❌ TABELAS FALTANDO: %', tabela_faltando;
    ELSE
        RAISE NOTICE '✅ Todas as tabelas essenciais existem';
    END IF;
END $$;

-- =====================================================
-- 2. VERIFICAÇÃO DETALHADA DA ESTRUTURA
-- =====================================================

-- Verificar estrutura da tabela loans
SELECT 'ESTRUTURA TABELA LOANS' as tipo;

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    CASE 
        WHEN column_name = 'original_amount' AND is_nullable = 'NO' THEN '✅ CAMPO CORRETO'
        WHEN column_name = 'original_amount' AND is_nullable = 'YES' THEN '⚠️ CAMPO PERMITE NULL'
        WHEN column_name = 'original_amount' THEN '❓ VERIFICAR CAMPO'
        WHEN column_name IN ('amount', 'interest_rate', 'status') THEN '📋 CAMPO ESSENCIAL'
        ELSE '📝 CAMPO NORMAL'
    END as status
FROM information_schema.columns 
WHERE table_name = 'loans'
ORDER BY ordinal_position;

-- =====================================================
-- 3. ANÁLISE DOS DADOS PROBLEMÁTICOS
-- =====================================================

-- Contar empréstimos por status
SELECT 'DISTRIBUIÇÃO POR STATUS' as tipo;

SELECT 
    status,
    COUNT(*) as quantidade,
    COUNT(CASE WHEN amount = 0 THEN 1 END) as com_valor_zero,
    COUNT(CASE WHEN original_amount IS NULL THEN 1 END) as sem_original_amount,
    COUNT(CASE WHEN original_amount = 0 THEN 1 END) as original_amount_zero
FROM loans 
GROUP BY status
ORDER BY quantidade DESC;

-- Empréstimos ativos/vencidos com problemas
SELECT 'EMPRÉSTIMOS ATIVOS/VENCIDOS COM PROBLEMAS' as tipo;

SELECT 
    l.id,
    c.name as cliente,
    l.amount,
    l.original_amount,
    l.interest_rate,
    l.status,
    l.due_date,
    l.created_at,
    COALESCE(p.total_pago, 0) as total_pago,
    CASE 
        WHEN l.amount = 0 AND l.original_amount IS NULL THEN '❌ SEM VALORES'
        WHEN l.amount = 0 AND l.original_amount > 0 THEN '⚠️ VALOR ATUAL ZERADO'
        WHEN l.original_amount IS NULL THEN '❌ SEM VALOR ORIGINAL'
        WHEN l.original_amount = 0 THEN '❌ VALOR ORIGINAL ZERADO'
        ELSE '❓ OUTRO PROBLEMA'
    END as tipo_problema
FROM loans l
LEFT JOIN clients c ON l.client_id = c.id
LEFT JOIN (
    SELECT loan_id, SUM(amount) as total_pago
    FROM payments 
    GROUP BY loan_id
) p ON l.id = p.loan_id
WHERE l.status IN ('active', 'overdue', 'partial_paid')
  AND (l.amount = 0 OR l.original_amount IS NULL OR l.original_amount = 0)
ORDER BY l.created_at DESC;

-- =====================================================
-- 4. CORREÇÃO FORÇADA PARA LITORAL
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE '🔧 INICIANDO CORREÇÃO FORÇADA PARA LITORAL';
    RAISE NOTICE '==========================================';
END $$;

-- Passo 1: Garantir que o campo original_amount existe
DO $$
BEGIN
    -- Adicionar campo se não existir
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'loans' AND column_name = 'original_amount'
    ) THEN
        ALTER TABLE loans ADD COLUMN original_amount DECIMAL(10,2);
        RAISE NOTICE '✅ Campo original_amount adicionado';
    ELSE
        RAISE NOTICE '✅ Campo original_amount já existe';
    END IF;
END $$;

-- Passo 2: Correção agressiva dos valores
DO $$
DECLARE
    loan_record RECORD;
    valor_corrigido DECIMAL(10,2);
    emprestimos_corrigidos INTEGER := 0;
BEGIN
    RAISE NOTICE '🔄 Iniciando correção agressiva dos valores...';
    
    -- Para cada empréstimo com problema
    FOR loan_record IN 
        SELECT l.*, c.name as cliente_nome
        FROM loans l
        LEFT JOIN clients c ON l.client_id = c.id
        WHERE l.status IN ('active', 'overdue', 'partial_paid')
          AND (l.amount = 0 OR l.original_amount IS NULL OR l.original_amount = 0)
    LOOP
        -- Tentar recuperar valor original de várias fontes
        valor_corrigido := NULL;
        
        -- 1. Tentar usar original_amount se > 0
        IF loan_record.original_amount IS NOT NULL AND loan_record.original_amount > 0 THEN
            valor_corrigido := loan_record.original_amount;
        
        -- 2. Tentar usar amount se > 0
        ELSIF loan_record.amount > 0 THEN
            valor_corrigido := loan_record.amount;
        
        -- 3. Tentar calcular baseado nos pagamentos (assumindo que foi quitado)
        ELSE
            SELECT SUM(p.amount) INTO valor_corrigido
            FROM payments p 
            WHERE p.loan_id = loan_record.id;
            
            -- Se há pagamentos, assumir que o valor original era o total pago dividido por (1 + juros)
            IF valor_corrigido IS NOT NULL AND valor_corrigido > 0 THEN
                valor_corrigido := valor_corrigido / (1 + (loan_record.interest_rate / 100));
            END IF;
        END IF;
        
        -- Se conseguiu determinar um valor, aplicar correção
        IF valor_corrigido IS NOT NULL AND valor_corrigido > 0 THEN
            UPDATE loans 
            SET 
                amount = valor_corrigido,
                original_amount = valor_corrigido,
                updated_at = NOW()
            WHERE id = loan_record.id;
            
            emprestimos_corrigidos := emprestimos_corrigidos + 1;
            
            RAISE NOTICE '🔧 Corrigido empréstimo ID: % - Cliente: % - Valor: R$ %', 
                loan_record.id, 
                COALESCE(loan_record.cliente_nome, 'N/A'), 
                valor_corrigido;
        ELSE
            RAISE NOTICE '❌ Não foi possível corrigir empréstimo ID: % - Cliente: %', 
                loan_record.id, 
                COALESCE(loan_record.cliente_nome, 'N/A');
        END IF;
    END LOOP;
    
    RAISE NOTICE '✅ Correção concluída: % empréstimos corrigidos', emprestimos_corrigidos;
END $$;

-- Passo 3: Tornar original_amount obrigatório
DO $$
BEGIN
    -- Verificar se ainda há valores NULL
    IF EXISTS (SELECT 1 FROM loans WHERE original_amount IS NULL) THEN
        -- Preencher NULLs restantes com amount
        UPDATE loans 
        SET original_amount = COALESCE(amount, 0) 
        WHERE original_amount IS NULL;
        
        RAISE NOTICE '🔧 Preenchidos valores NULL restantes';
    END IF;
    
    -- Tornar campo obrigatório
    BEGIN
        ALTER TABLE loans ALTER COLUMN original_amount SET NOT NULL;
        RAISE NOTICE '✅ Campo original_amount agora é obrigatório';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '⚠️ Não foi possível tornar original_amount obrigatório: %', SQLERRM;
    END;
END $$;

-- =====================================================
-- 5. RECONSTRUIR TABELAS DE STATUS
-- =====================================================

-- Limpar e reconstruir tabelas de status
DO $$
DECLARE
    loan_record RECORD;
    total_paid DECIMAL(10,2);
    total_with_interest DECIMAL(10,2);
    remaining_amount DECIMAL(10,2);
    registros_atualizados INTEGER := 0;
BEGIN
    RAISE NOTICE '🔄 Reconstruindo tabelas de status...';
    
    -- Limpar tabelas de status existentes
    DELETE FROM overdue_loans;
    DELETE FROM partial_paid_loans;
    
    RAISE NOTICE '🧹 Tabelas de status limpas';
    
    -- Reconstruir para cada empréstimo ativo/vencido/parcial
    FOR loan_record IN 
        SELECT * FROM loans 
        WHERE status IN ('active', 'overdue', 'partial_paid')
          AND original_amount > 0
    LOOP
        -- Calcular valores
        SELECT COALESCE(SUM(amount), 0) INTO total_paid
        FROM payments WHERE loan_id = loan_record.id;
        
        total_with_interest := loan_record.original_amount + (loan_record.original_amount * loan_record.interest_rate / 100);
        remaining_amount := GREATEST(0, total_with_interest - total_paid);
        
        -- Inserir em overdue_loans se vencido
        IF loan_record.due_date < CURRENT_DATE AND loan_record.status != 'paid' THEN
            INSERT INTO overdue_loans (
                loan_id, client_id, original_amount, interest_rate,
                total_with_interest, loan_date, due_date, days_overdue,
                remaining_amount, total_paid, created_by
            ) VALUES (
                loan_record.id, loan_record.client_id, loan_record.original_amount, 
                loan_record.interest_rate, total_with_interest, loan_record.loan_date, 
                loan_record.due_date, CURRENT_DATE - loan_record.due_date,
                remaining_amount, total_paid, loan_record.created_by
            );
            
            registros_atualizados := registros_atualizados + 1;
        END IF;
        
        -- Inserir em partial_paid_loans se tem pagamentos parciais
        IF total_paid > 0 AND remaining_amount > 0 THEN
            INSERT INTO partial_paid_loans (
                loan_id, client_id, original_amount, interest_rate,
                total_with_interest, loan_date, due_date, total_paid,
                remaining_amount, payment_count, last_payment_date, created_by
            ) VALUES (
                loan_record.id, loan_record.client_id, loan_record.original_amount,
                loan_record.interest_rate, total_with_interest, loan_record.loan_date,
                loan_record.due_date, total_paid, remaining_amount,
                (SELECT COUNT(*) FROM payments WHERE loan_id = loan_record.id),
                (SELECT MAX(payment_date) FROM payments WHERE loan_id = loan_record.id),
                loan_record.created_by
            );
            
            registros_atualizados := registros_atualizados + 1;
        END IF;
    END LOOP;
    
    RAISE NOTICE '✅ Tabelas de status reconstruídas: % registros', registros_atualizados;
END $$;

-- =====================================================
-- 6. VERIFICAÇÃO FINAL ESPECÍFICA LITORAL
-- =====================================================

-- Relatório final
SELECT 'RELATÓRIO FINAL - LITORAL' as tipo;

SELECT 
    'ESTATÍSTICAS FINAIS' as categoria,
    COUNT(*) as total_emprestimos,
    COUNT(CASE WHEN amount > 0 THEN 1 END) as com_valor_atual,
    COUNT(CASE WHEN original_amount > 0 THEN 1 END) as com_valor_original,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as ativos,
    COUNT(CASE WHEN status = 'overdue' THEN 1 END) as vencidos,
    COUNT(CASE WHEN status = 'partial_paid' THEN 1 END) as parciais
FROM loans;

-- Empréstimos com valores restantes calculados
SELECT 
    'EMPRÉSTIMOS COM VALORES RESTANTES' as categoria,
    l.id,
    c.name as cliente,
    l.original_amount as valor_original,
    l.interest_rate as taxa_juros,
    (l.original_amount + (l.original_amount * l.interest_rate / 100)) as total_com_juros,
    COALESCE(p.total_pago, 0) as total_pago,
    GREATEST(0, (l.original_amount + (l.original_amount * l.interest_rate / 100)) - COALESCE(p.total_pago, 0)) as valor_restante,
    l.status
FROM loans l
LEFT JOIN clients c ON l.client_id = c.id
LEFT JOIN (
    SELECT loan_id, SUM(amount) as total_pago
    FROM payments GROUP BY loan_id
) p ON l.id = p.loan_id
WHERE l.status IN ('active', 'overdue', 'partial_paid')
  AND l.original_amount > 0
ORDER BY valor_restante DESC
LIMIT 10;

-- Verificar tabelas de status
SELECT 
    'TABELAS DE STATUS' as categoria,
    (SELECT COUNT(*) FROM overdue_loans WHERE remaining_amount > 0) as vencidos_com_valor,
    (SELECT COUNT(*) FROM partial_paid_loans WHERE remaining_amount > 0) as parciais_com_valor;

-- =====================================================
-- 7. MENSAGEM FINAL ESPECÍFICA LITORAL
-- =====================================================

DO $$
DECLARE
    problemas_restantes INTEGER;
    emprestimos_corrigidos INTEGER;
BEGIN
    -- Contar problemas restantes
    SELECT COUNT(*) INTO problemas_restantes
    FROM loans 
    WHERE status IN ('active', 'overdue', 'partial_paid')
      AND (amount = 0 OR original_amount IS NULL OR original_amount = 0);
    
    -- Contar empréstimos com valores corretos
    SELECT COUNT(*) INTO emprestimos_corrigidos
    FROM loans 
    WHERE status IN ('active', 'overdue', 'partial_paid')
      AND amount > 0 AND original_amount > 0;
    
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'CORREÇÃO ESPECÍFICA LITORAL - CONCLUÍDA';
    RAISE NOTICE '==========================================';
    RAISE NOTICE '';
    
    IF problemas_restantes = 0 THEN
        RAISE NOTICE '🎉 SUCESSO TOTAL: Todos os problemas foram corrigidos!';
        RAISE NOTICE '✅ % empréstimos com valores corretos', emprestimos_corrigidos;
    ELSE
        RAISE NOTICE '⚠️ ATENÇÃO: % problemas ainda restam', problemas_restantes;
        RAISE NOTICE '✅ % empréstimos corrigidos', emprestimos_corrigidos;
    END IF;
    
    RAISE NOTICE '';
    RAISE NOTICE '📋 PRÓXIMOS PASSOS:';
    RAISE NOTICE '1. Teste a interface da LITORAL';
    RAISE NOTICE '2. Verifique se os valores restantes aparecem';
    RAISE NOTICE '3. Teste criar um novo empréstimo';
    RAISE NOTICE '4. Teste fazer um pagamento';
    RAISE NOTICE '5. Compare com MOGIANA para confirmar funcionamento';
    
    RAISE NOTICE '';
    RAISE NOTICE '🔍 SE AINDA HOUVER PROBLEMAS:';
    RAISE NOTICE '1. Verifique se as credenciais da LITORAL estão corretas';
    RAISE NOTICE '2. Confirme se está acessando o banco correto';
    RAISE NOTICE '3. Verifique se há cache no navegador';
    RAISE NOTICE '4. Teste com outro navegador/aba privada';
    
    RAISE NOTICE '==========================================';
END $$;

-- =====================================================
-- INSTRUÇÕES ESPECÍFICAS PARA LITORAL
-- =====================================================
/*
INSTRUÇÕES ESPECÍFICAS PARA EMPRESA LITORAL:

1. ACESSO:
   - URL: https://dtifsfzmnjnllzzlndxv.supabase.co
   - Vá em SQL Editor
   - Cole e execute este script completo

2. APÓS EXECUÇÃO:
   - Limpe cache do navegador
   - Acesse a aplicação Nexus
   - Selecione "LITORAL CRED"
   - Faça login
   - Teste a aba Empréstimos

3. VERIFICAÇÕES:
   - Os valores restantes devem aparecer
   - Novos empréstimos devem funcionar
   - Pagamentos devem calcular corretamente

4. SE AINDA NÃO FUNCIONAR:
   - Verifique se está no banco correto
   - Confirme as credenciais no app.js
   - Teste com navegador diferente
   - Verifique console do navegador por erros

5. COMPARAÇÃO COM MOGIANA:
   - Teste as mesmas operações na MOGIANA
   - Compare os resultados
   - Identifique diferenças específicas

Este script é mais agressivo e deve resolver problemas específicos da LITORAL.
*/