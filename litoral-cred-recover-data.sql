-- =====================================================
-- RECUPERAÇÃO DE DADOS DE EMPRÉSTIMOS QUITADOS - LITORAL CRED
-- =====================================================
-- Execute este script DEPOIS de executar litoral-cred-restore-paid-loans.sql
-- URL: https://dtifsfzmnjnllzzlndxv.supabase.co
-- =====================================================

-- ⚠️ IMPORTANTE: Este script tentará recuperar empréstimos quitados de várias fontes

-- =====================================================
-- MÉTODO 1: MOVER EMPRÉSTIMOS COM STATUS 'PAID' DA TABELA LOANS
-- =====================================================

DO $$
DECLARE
    v_moved_count INTEGER := 0;
BEGIN
    -- Inserir empréstimos com status 'paid' na tabela paid_loans
    INSERT INTO paid_loans (
        loan_id, 
        client_id, 
        original_amount, 
        interest_rate, 
        total_with_interest,
        loan_date, 
        due_date, 
        paid_date,
        total_paid,
        payment_method,
        notes,
        created_by,
        created_at
    )
    SELECT 
        l.id as loan_id,
        l.client_id,
        l.amount as original_amount,
        l.interest_rate,
        l.amount + (l.amount * l.interest_rate / 100) as total_with_interest,
        l.loan_date,
        l.due_date,
        COALESCE(
            (SELECT MAX(payment_date) FROM payments WHERE loan_id = l.id),
            CURRENT_DATE
        ) as paid_date,
        COALESCE(
            (SELECT SUM(amount) FROM payments WHERE loan_id = l.id),
            l.amount + (l.amount * l.interest_rate / 100)
        ) as total_paid,
        'Recuperado' as payment_method,
        'Recuperado do status paid na tabela loans' as notes,
        l.created_by,
        l.created_at
    FROM loans l
    WHERE l.status = 'paid'
    ON CONFLICT (loan_id) DO NOTHING;
    
    GET DIAGNOSTICS v_moved_count = ROW_COUNT;
    
    RAISE NOTICE '📊 Método 1: % empréstimos recuperados da tabela loans com status paid', v_moved_count;
    
    -- Deletar da tabela loans (opcional - comente se não quiser deletar)
    -- DELETE FROM loans WHERE status = 'paid';
END $$;

-- =====================================================
-- MÉTODO 2: RECUPERAR EMPRÉSTIMOS COMPLETAMENTE PAGOS MAS SEM STATUS 'PAID'
-- =====================================================

DO $$
DECLARE
    v_recovered_count INTEGER := 0;
BEGIN
    -- Inserir empréstimos que foram completamente pagos mas não têm status 'paid'
    INSERT INTO paid_loans (
        loan_id, 
        client_id, 
        original_amount, 
        interest_rate, 
        total_with_interest,
        loan_date, 
        due_date, 
        paid_date,
        total_paid,
        payment_method,
        notes,
        created_by,
        created_at
    )
    SELECT 
        l.id as loan_id,
        l.client_id,
        l.amount as original_amount,
        l.interest_rate,
        l.amount + (l.amount * l.interest_rate / 100) as total_with_interest,
        l.loan_date,
        l.due_date,
        (SELECT MAX(payment_date) FROM payments WHERE loan_id = l.id) as paid_date,
        COALESCE(SUM(p.amount), 0) as total_paid,
        'Recuperado (Totalmente Pago)' as payment_method,
        'Recuperado: empréstimo estava totalmente pago mas status incorreto' as notes,
        l.created_by,
        l.created_at
    FROM loans l
    LEFT JOIN payments p ON l.id = p.loan_id
    WHERE l.status != 'paid'
    GROUP BY l.id, l.client_id, l.amount, l.interest_rate, l.loan_date, l.due_date, l.created_by, l.created_at
    HAVING COALESCE(SUM(p.amount), 0) >= (l.amount + (l.amount * l.interest_rate / 100))
    ON CONFLICT (loan_id) DO NOTHING;
    
    GET DIAGNOSTICS v_recovered_count = ROW_COUNT;
    
    RAISE NOTICE '📊 Método 2: % empréstimos recuperados (completamente pagos)', v_recovered_count;
    
    -- Atualizar status na tabela loans (opcional)
    -- UPDATE loans SET status = 'paid' 
    -- WHERE id IN (
    --     SELECT loan_id FROM paid_loans WHERE notes LIKE '%status incorreto%'
    -- );
END $$;

-- =====================================================
-- MÉTODO 3: RECONSTRUIR DE PAGAMENTOS ÓRFÃOS (empréstimos deletados)
-- =====================================================

DO $$
DECLARE
    v_reconstructed_count INTEGER := 0;
BEGIN
    -- Criar empréstimos na tabela paid_loans baseado em pagamentos órfãos
    -- (pagamentos de empréstimos que não existem mais na tabela loans)
    INSERT INTO paid_loans (
        loan_id,
        client_id,
        original_amount,
        interest_rate,
        total_with_interest,
        loan_date,
        due_date,
        paid_date,
        total_paid,
        payment_method,
        notes,
        created_by,
        created_at
    )
    SELECT 
        p.loan_id,
        COALESCE(
            (SELECT client_id FROM clients LIMIT 1), -- Fallback para primeiro cliente
            '00000000-0000-0000-0000-000000000000'::uuid
        ) as client_id,
        SUM(p.amount) * 0.9 as original_amount, -- Estimativa: 90% do total pago
        10.00 as interest_rate, -- Taxa estimada de 10%
        SUM(p.amount) as total_with_interest,
        MIN(p.payment_date) as loan_date, -- Primeira data de pagamento
        MAX(p.payment_date) as due_date, -- Última data de pagamento
        MAX(p.payment_date) as paid_date,
        SUM(p.amount) as total_paid,
        'Reconstruído' as payment_method,
        'RECONSTRUÍDO: Empréstimo foi deletado mas havia pagamentos. Valores são estimados.' as notes,
        p.created_by,
        MIN(p.created_at) as created_at
    FROM payments p
    LEFT JOIN loans l ON p.loan_id = l.id
    WHERE l.id IS NULL  -- Pagamentos órfãos (empréstimos deletados)
    GROUP BY p.loan_id, p.created_by
    HAVING COUNT(*) > 0
    ON CONFLICT (loan_id) DO NOTHING;
    
    GET DIAGNOSTICS v_reconstructed_count = ROW_COUNT;
    
    RAISE NOTICE '📊 Método 3: % empréstimos reconstruídos de pagamentos órfãos', v_reconstructed_count;
    RAISE NOTICE '⚠️  ATENÇÃO: Estes empréstimos têm valores ESTIMADOS (client_id, valores, taxas)';
END $$;

-- =====================================================
-- MÉTODO 4: VERIFICAR E CORRIGIR CLIENT_ID AUSENTE
-- =====================================================

DO $$
DECLARE
    v_fixed_count INTEGER := 0;
BEGIN
    -- Tentar corrigir client_id com base em outros empréstimos do mesmo cliente
    UPDATE paid_loans pl
    SET client_id = (
        SELECT l.client_id 
        FROM loans l 
        WHERE l.id = pl.loan_id 
        LIMIT 1
    )
    WHERE pl.client_id = '00000000-0000-0000-0000-000000000000'::uuid
    AND EXISTS (
        SELECT 1 FROM loans l WHERE l.id = pl.loan_id
    );
    
    GET DIAGNOSTICS v_fixed_count = ROW_COUNT;
    
    RAISE NOTICE '📊 Método 4: % registros tiveram client_id corrigido', v_fixed_count;
END $$;

-- =====================================================
-- RELATÓRIO FINAL DE RECUPERAÇÃO
-- =====================================================

DO $$
DECLARE
    v_total_paid_loans INTEGER;
    v_total_loans INTEGER;
    v_total_payments INTEGER;
    v_total_orphan_payments INTEGER;
BEGIN
    -- Contar totais
    SELECT COUNT(*) INTO v_total_paid_loans FROM paid_loans;
    SELECT COUNT(*) INTO v_total_loans FROM loans;
    SELECT COUNT(*) INTO v_total_payments FROM payments;
    SELECT COUNT(DISTINCT loan_id) INTO v_total_orphan_payments 
    FROM payments p 
    LEFT JOIN loans l ON p.loan_id = l.id 
    WHERE l.id IS NULL;
    
    RAISE NOTICE '';
    RAISE NOTICE '========================================';
    RAISE NOTICE '   RELATÓRIO DE RECUPERAÇÃO - LITORAL CRED';
    RAISE NOTICE '========================================';
    RAISE NOTICE '';
    RAISE NOTICE '📊 Total de empréstimos quitados recuperados: %', v_total_paid_loans;
    RAISE NOTICE '📋 Total de empréstimos ativos restantes: %', v_total_loans;
    RAISE NOTICE '💰 Total de registros de pagamentos: %', v_total_payments;
    RAISE NOTICE '⚠️  Pagamentos órfãos (empréstimos deletados): %', v_total_orphan_payments;
    RAISE NOTICE '';
    RAISE NOTICE '========================================';
END $$;

-- =====================================================
-- CONSULTA: VER EMPRÉSTIMOS RECUPERADOS
-- =====================================================

SELECT 
    pl.id,
    pl.loan_id,
    c.name as cliente,
    c.cpf,
    pl.original_amount as valor_original,
    pl.interest_rate as taxa_juros,
    pl.total_with_interest as total_com_juros,
    pl.total_paid as total_pago,
    pl.loan_date as data_emprestimo,
    pl.paid_date as data_quitacao,
    pl.payment_method as metodo,
    pl.notes as observacoes
FROM paid_loans pl
LEFT JOIN clients c ON pl.client_id = c.id
ORDER BY pl.paid_date DESC
LIMIT 50;

-- =====================================================
-- CONSULTA: IDENTIFICAR PROBLEMAS
-- =====================================================

-- Empréstimos quitados sem cliente
SELECT 
    COUNT(*) as sem_cliente,
    'Empréstimos sem cliente válido' as problema
FROM paid_loans 
WHERE client_id = '00000000-0000-0000-0000-000000000000'::uuid
    OR client_id NOT IN (SELECT id FROM clients);

-- Empréstimos com valores suspeitos
SELECT 
    COUNT(*) as valores_suspeitos,
    'Empréstimos com valores muito baixos' as problema
FROM paid_loans 
WHERE original_amount < 10;

-- =====================================================
-- ESTATÍSTICAS FINANCEIRAS
-- =====================================================

SELECT 
    COUNT(*) as total_emprestimos_quitados,
    SUM(original_amount) as total_emprestado,
    SUM(total_with_interest) as total_com_juros,
    SUM(total_paid) as total_recebido,
    AVG(interest_rate) as taxa_media,
    MIN(paid_date) as primeiro_quitacao,
    MAX(paid_date) as ultima_quitacao
FROM paid_loans;

-- =====================================================
-- FIM DA RECUPERAÇÃO
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '✅ Processo de recuperação concluído!';
    RAISE NOTICE '';
    RAISE NOTICE '📝 Próximos passos:';
    RAISE NOTICE '1. Revisar os empréstimos recuperados';
    RAISE NOTICE '2. Corrigir client_id de registros reconstruídos (se houver)';
    RAISE NOTICE '3. Validar valores e datas';
    RAISE NOTICE '4. Atualizar a interface da aplicação se necessário';
    RAISE NOTICE '';
END $$;
