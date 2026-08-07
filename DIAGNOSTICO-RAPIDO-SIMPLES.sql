-- =====================================================
-- DIAGNÓSTICO ULTRA-RÁPIDO - LITORAL CRED
-- =====================================================
-- Copie e cole TUDO de uma vez
-- =====================================================

-- 1. Verificar quantos pagamentos existem
SELECT 
    '1. PAGAMENTOS' as verificacao,
    COUNT(*) as quantidade,
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ HÁ DADOS! Pode recuperar!'
        ELSE '❌ Vazio - Dados podem estar perdidos'
    END as situacao
FROM payments;

-- 2. Verificar quantos empréstimos existem
SELECT 
    '2. EMPRÉSTIMOS' as verificacao,
    COUNT(*) as quantidade,
    CASE 
        WHEN COUNT(*) > 0 THEN '✅ Há empréstimos na tabela'
        ELSE '⚠️ Tabela vazia'
    END as situacao
FROM loans;

-- 3. Verificar empréstimos por status
SELECT 
    '3. STATUS' as verificacao,
    status,
    COUNT(*) as quantidade
FROM loans
GROUP BY status
ORDER BY COUNT(*) DESC;

-- 4. Verificar se paid_loans existe
SELECT 
    '4. PAID_LOANS' as verificacao,
    CASE 
        WHEN EXISTS (
            SELECT FROM information_schema.tables 
            WHERE table_name = 'paid_loans'
        ) THEN 'Tabela JÁ EXISTE'
        ELSE 'Tabela NÃO EXISTE (precisa criar)'
    END as situacao;

-- 5. Verificar pagamentos órfãos (CRÍTICO!)
SELECT 
    '5. ÓRFÃOS' as verificacao,
    COUNT(DISTINCT p.loan_id) as emprestimos_deletados,
    CASE 
        WHEN COUNT(DISTINCT p.loan_id) > 0 
        THEN '🚨 HÁ EMPRÉSTIMOS DELETADOS! Pode recuperar!'
        ELSE '✅ Sem órfãos'
    END as situacao
FROM payments p
LEFT JOIN loans l ON p.loan_id = l.id
WHERE l.id IS NULL;

-- 6. Ver exemplo de pagamento
SELECT 
    '6. EXEMPLO' as info,
    p.*
FROM payments p
LIMIT 1;

-- 7. Calcular potencial de recuperação
WITH stats AS (
    SELECT 
        (SELECT COUNT(*) FROM payments) as total_payments,
        (SELECT COUNT(*) FROM loans WHERE status = 'paid') as loans_paid,
        (SELECT COUNT(DISTINCT loan_id) FROM payments p 
         LEFT JOIN loans l ON p.loan_id = l.id 
         WHERE l.id IS NULL) as orphans
)
SELECT 
    '7. POTENCIAL RECUPERAÇÃO' as analise,
    total_payments as pagamentos_disponiveis,
    loans_paid as emprestimos_com_status_paid,
    orphans as emprestimos_deletados,
    (loans_paid + orphans) as total_recuperavel_estimado,
    CASE 
        WHEN total_payments = 0 THEN '❌ SEM DADOS - Impossível recuperar'
        WHEN (loans_paid + orphans) = 0 THEN '⚠️ Pode haver dados mas status errado'
        ELSE '✅ PODE RECUPERAR ' || (loans_paid + orphans)::text || ' empréstimos!'
    END as diagnostico
FROM stats;

-- =====================================================
-- INTERPRETAÇÃO DOS RESULTADOS
-- =====================================================

DO $$
DECLARE
    v_payments INTEGER;
    v_loans INTEGER;
    v_orphans INTEGER;
    v_paid_status INTEGER;
BEGIN
    -- Contar dados
    SELECT COUNT(*) INTO v_payments FROM payments;
    SELECT COUNT(*) INTO v_loans FROM loans;
    SELECT COUNT(*) INTO v_paid_status FROM loans WHERE status = 'paid';
    
    SELECT COUNT(DISTINCT p.loan_id) INTO v_orphans
    FROM payments p
    LEFT JOIN loans l ON p.loan_id = l.id
    WHERE l.id IS NULL;
    
    RAISE NOTICE '';
    RAISE NOTICE '=========================================';
    RAISE NOTICE 'DIAGNÓSTICO - LITORAL CRED';
    RAISE NOTICE '=========================================';
    RAISE NOTICE '';
    
    -- Análise de payments
    IF v_payments = 0 THEN
        RAISE NOTICE '❌ CRÍTICO: Tabela payments está VAZIA!';
        RAISE NOTICE '   Não há como recuperar sem dados de pagamento.';
        RAISE NOTICE '   Ações:';
        RAISE NOTICE '   1. Verificar backup do Supabase';
        RAISE NOTICE '   2. Verificar logs de quando foi deletado';
        RAISE NOTICE '   3. Procurar backup externo';
    ELSE
        RAISE NOTICE '✅ BOM: Há % registros de pagamentos!', v_payments;
        RAISE NOTICE '   Isso significa que podemos recuperar dados!';
    END IF;
    
    RAISE NOTICE '';
    
    -- Análise de loans
    IF v_loans = 0 THEN
        RAISE NOTICE '⚠️ ATENÇÃO: Tabela loans está VAZIA!';
        RAISE NOTICE '   Todos os empréstimos foram deletados.';
    ELSE
        RAISE NOTICE '📊 Tabela loans tem % registros', v_loans;
    END IF;
    
    RAISE NOTICE '';
    
    -- Análise de empréstimos com status paid
    IF v_paid_status > 0 THEN
        RAISE NOTICE '✅ EXCELENTE: % empréstimos com status PAID', v_paid_status;
        RAISE NOTICE '   Estes podem ser movidos para paid_loans!';
    END IF;
    
    RAISE NOTICE '';
    
    -- Análise de órfãos (CRÍTICO!)
    IF v_orphans > 0 THEN
        RAISE NOTICE '🚨 IMPORTANTE: % empréstimos foram DELETADOS', v_orphans;
        RAISE NOTICE '   mas seus pagamentos ainda existem!';
        RAISE NOTICE '   Podemos RECONSTRUÍ-LOS!';
    END IF;
    
    RAISE NOTICE '';
    RAISE NOTICE '=========================================';
    RAISE NOTICE 'CONCLUSÃO';
    RAISE NOTICE '=========================================';
    RAISE NOTICE '';
    
    IF v_payments = 0 AND v_loans = 0 THEN
        RAISE NOTICE '❌ DADOS PERDIDOS: Sem registros para recuperar';
        RAISE NOTICE '   Última esperança: Backup do Supabase';
    ELSIF v_payments > 0 THEN
        RAISE NOTICE '✅ RECUPERAÇÃO POSSÍVEL!';
        RAISE NOTICE '';
        RAISE NOTICE 'Estimativa de recuperação:';
        RAISE NOTICE '  - Status paid: % empréstimos', v_paid_status;
        RAISE NOTICE '  - Deletados: % empréstimos', v_orphans;
        RAISE NOTICE '  - TOTAL: % empréstimos', (v_paid_status + v_orphans);
        RAISE NOTICE '';
        RAISE NOTICE 'PRÓXIMO PASSO:';
        RAISE NOTICE '  Execute: RECUPERACAO-SIMPLES-LITORAL-CRED.sql';
    ELSE
        RAISE NOTICE '⚠️ SITUAÇÃO INCERTA';
        RAISE NOTICE '   Há empréstimos mas sem pagamentos';
        RAISE NOTICE '   Verificar estrutura dos dados';
    END IF;
    
    RAISE NOTICE '';
    RAISE NOTICE '=========================================';
END $$;
