-- =====================================================
-- DIAGNÓSTICO RÁPIDO - LITORAL CRED
-- =====================================================
-- Execute este script PRIMEIRO para identificar o problema
-- URL: https://dtifsfzmnjnllzzlndxv.supabase.co
-- =====================================================

\echo '========================================='
\echo 'DIAGNÓSTICO - EMPRÉSTIMOS QUITADOS'
\echo 'Empresa: LITORAL CRED'
\echo '========================================='
\echo ''

-- =====================================================
-- 1. VERIFICAR SE A TABELA PAID_LOANS EXISTE
-- =====================================================

\echo '1️⃣ Verificando se a tabela paid_loans existe...'
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name = 'paid_loans'
        ) THEN '✅ SIM - Tabela paid_loans existe'
        ELSE '❌ NÃO - Tabela paid_loans NÃO existe (precisa ser criada)'
    END as resultado;

\echo ''

-- =====================================================
-- 2. CONTAR EMPRÉSTIMOS POR STATUS
-- =====================================================

\echo '2️⃣ Contando empréstimos por status na tabela loans...'
SELECT 
    COALESCE(status, 'NULL') as status,
    COUNT(*) as quantidade,
    CONCAT('R$ ', TO_CHAR(SUM(amount), '999,999,990.00')) as total_valor
FROM loans
GROUP BY status
ORDER BY 
    CASE status
        WHEN 'active' THEN 1
        WHEN 'overdue' THEN 2
        WHEN 'partial_paid' THEN 3
        WHEN 'paid' THEN 4
        WHEN 'cancelled' THEN 5
        ELSE 6
    END;

\echo ''

-- =====================================================
-- 3. VERIFICAR REGISTROS EM PAID_LOANS (SE EXISTIR)
-- =====================================================

\echo '3️⃣ Verificando registros em paid_loans (se a tabela existir)...'
DO $$
DECLARE
    v_count INTEGER;
    v_table_exists BOOLEAN;
BEGIN
    -- Verificar se a tabela existe
    SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans'
    ) INTO v_table_exists;
    
    IF v_table_exists THEN
        EXECUTE 'SELECT COUNT(*) FROM paid_loans' INTO v_count;
        RAISE NOTICE '✅ Tabela paid_loans tem % registros', v_count;
        
        IF v_count = 0 THEN
            RAISE NOTICE '⚠️  PROBLEMA: Tabela existe mas está VAZIA';
        END IF;
    ELSE
        RAISE NOTICE '❌ Tabela paid_loans NÃO EXISTE';
    END IF;
END $$;

\echo ''

-- =====================================================
-- 4. IDENTIFICAR EMPRÉSTIMOS COMPLETAMENTE PAGOS
-- =====================================================

\echo '4️⃣ Identificando empréstimos completamente pagos mas não marcados como quitados...'
SELECT 
    COUNT(*) as quantidade,
    CONCAT('R$ ', TO_CHAR(SUM(l.amount), '999,999,990.00')) as valor_total,
    CASE 
        WHEN COUNT(*) > 0 THEN '⚠️  ATENÇÃO: Há empréstimos pagos que não estão marcados como quitados'
        ELSE '✅ OK: Não há empréstimos pagos sem marcação correta'
    END as situacao
FROM loans l
LEFT JOIN payments p ON l.id = p.loan_id
WHERE l.status != 'paid'
GROUP BY l.id, l.amount, l.interest_rate
HAVING COALESCE(SUM(p.amount), 0) >= (l.amount + (l.amount * l.interest_rate / 100));

\echo ''

-- =====================================================
-- 5. DETECTAR PAGAMENTOS ÓRFÃOS (EMPRÉSTIMOS DELETADOS)
-- =====================================================

\echo '5️⃣ Detectando pagamentos órfãos (de empréstimos que foram deletados)...'
SELECT 
    COUNT(DISTINCT p.loan_id) as emprestimos_deletados,
    COUNT(p.id) as total_pagamentos_orfaos,
    CONCAT('R$ ', TO_CHAR(SUM(p.amount), '999,999,990.00')) as valor_total_pago,
    CASE 
        WHEN COUNT(DISTINCT p.loan_id) > 0 THEN '🚨 CRÍTICO: Há empréstimos que foram DELETADOS mas tinham pagamentos'
        ELSE '✅ OK: Não há pagamentos órfãos'
    END as situacao
FROM payments p
LEFT JOIN loans l ON p.loan_id = l.id
WHERE l.id IS NULL;

\echo ''

-- =====================================================
-- 6. LISTAR EMPRÉSTIMOS ÓRFÃOS DETALHADOS
-- =====================================================

\echo '6️⃣ Detalhes dos empréstimos órfãos (se houver)...'
SELECT 
    p.loan_id as emprestimo_deletado,
    COUNT(p.id) as num_pagamentos,
    CONCAT('R$ ', TO_CHAR(SUM(p.amount), '999,999,990.00')) as total_pago,
    TO_CHAR(MIN(p.payment_date), 'DD/MM/YYYY') as primeiro_pagamento,
    TO_CHAR(MAX(p.payment_date), 'DD/MM/YYYY') as ultimo_pagamento,
    '🔥 DELETADO - Pode ser recuperado' as status
FROM payments p
LEFT JOIN loans l ON p.loan_id = l.id
WHERE l.id IS NULL
GROUP BY p.loan_id
ORDER BY MAX(p.payment_date) DESC
LIMIT 10;

\echo ''

-- =====================================================
-- 7. VERIFICAR TRIGGERS EXISTENTES
-- =====================================================

\echo '7️⃣ Verificando triggers na tabela loans...'
SELECT 
    trigger_name,
    event_manipulation as evento,
    CASE 
        WHEN trigger_name LIKE '%paid%' THEN '✅ Trigger relacionado a paid_loans'
        ELSE '📋 Outro trigger'
    END as tipo
FROM information_schema.triggers
WHERE event_object_table = 'loans'
ORDER BY trigger_name;

\echo ''

-- =====================================================
-- 8. ESTATÍSTICAS GERAIS
-- =====================================================

\echo '8️⃣ Estatísticas gerais do sistema...'
SELECT 
    'Total de Clientes' as metrica,
    COUNT(*)::text as valor
FROM clients

UNION ALL

SELECT 
    'Total de Empréstimos Ativos' as metrica,
    COUNT(*)::text as valor
FROM loans

UNION ALL

SELECT 
    'Total de Pagamentos Registrados' as metrica,
    COUNT(*)::text as valor
FROM payments

UNION ALL

SELECT 
    'Valor Total Emprestado (Ativos)' as metrica,
    CONCAT('R$ ', TO_CHAR(SUM(amount), '999,999,990.00')) as valor
FROM loans;

\echo ''

-- =====================================================
-- 9. RESUMO E RECOMENDAÇÕES
-- =====================================================

\echo '========================================='
\echo 'RESUMO DO DIAGNÓSTICO'
\echo '========================================='

DO $$
DECLARE
    v_table_exists BOOLEAN;
    v_paid_loans_count INTEGER := 0;
    v_status_paid_count INTEGER;
    v_fully_paid_count INTEGER;
    v_orphan_count INTEGER;
BEGIN
    -- Verificar se tabela existe
    SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans'
    ) INTO v_table_exists;
    
    -- Contar empréstimos com status paid
    SELECT COUNT(*) INTO v_status_paid_count
    FROM loans 
    WHERE status = 'paid';
    
    -- Contar empréstimos órfãos
    SELECT COUNT(DISTINCT p.loan_id) INTO v_orphan_count
    FROM payments p
    LEFT JOIN loans l ON p.loan_id = l.id
    WHERE l.id IS NULL;
    
    -- Contar empréstimos totalmente pagos
    SELECT COUNT(*) INTO v_fully_paid_count
    FROM (
        SELECT l.id
        FROM loans l
        LEFT JOIN payments p ON l.id = p.loan_id
        WHERE l.status != 'paid'
        GROUP BY l.id, l.amount, l.interest_rate
        HAVING COALESCE(SUM(p.amount), 0) >= (l.amount + (l.amount * l.interest_rate / 100))
    ) sub;
    
    -- Contar registros em paid_loans se existe
    IF v_table_exists THEN
        EXECUTE 'SELECT COUNT(*) FROM paid_loans' INTO v_paid_loans_count;
    END IF;
    
    RAISE NOTICE '';
    RAISE NOTICE '📊 SITUAÇÃO ATUAL:';
    RAISE NOTICE '-------------------------------------------';
    
    IF NOT v_table_exists THEN
        RAISE NOTICE '❌ Tabela paid_loans: NÃO EXISTE';
        RAISE NOTICE '   ➡️  Ação: Execute o script litoral-cred-restore-paid-loans.sql';
    ELSIF v_paid_loans_count = 0 THEN
        RAISE NOTICE '⚠️  Tabela paid_loans: VAZIA (% registros)', v_paid_loans_count;
        RAISE NOTICE '   ➡️  Ação: Execute o script litoral-cred-recover-data.sql';
    ELSE
        RAISE NOTICE '✅ Tabela paid_loans: OK (% registros)', v_paid_loans_count;
    END IF;
    
    IF v_status_paid_count > 0 THEN
        RAISE NOTICE '⚠️  Empréstimos com status "paid" na tabela loans: %', v_status_paid_count;
        RAISE NOTICE '   ➡️  Ação: Estes devem ser movidos para paid_loans';
    END IF;
    
    IF v_fully_paid_count > 0 THEN
        RAISE NOTICE '⚠️  Empréstimos totalmente pagos (status errado): %', v_fully_paid_count;
        RAISE NOTICE '   ➡️  Ação: Corrigir status e mover para paid_loans';
    END IF;
    
    IF v_orphan_count > 0 THEN
        RAISE NOTICE '🚨 Empréstimos DELETADOS com pagamentos: %', v_orphan_count;
        RAISE NOTICE '   ➡️  Ação: CRÍTICO - Podem ser reconstruídos com valores estimados';
    END IF;
    
    RAISE NOTICE '';
    RAISE NOTICE '📋 PRÓXIMOS PASSOS:';
    RAISE NOTICE '-------------------------------------------';
    RAISE NOTICE '1. Execute: litoral-cred-restore-paid-loans.sql (criar estrutura)';
    RAISE NOTICE '2. Execute: litoral-cred-recover-data.sql (recuperar dados)';
    RAISE NOTICE '3. Revise os dados recuperados';
    RAISE NOTICE '4. Atualize a aplicação se necessário';
    RAISE NOTICE '';
END $$;

\echo '========================================='
\echo 'FIM DO DIAGNÓSTICO'
\echo '========================================='
