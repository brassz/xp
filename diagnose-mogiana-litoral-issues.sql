-- =====================================================
-- DIAGNÓSTICO ESPECÍFICO: MOGIANA E LITORAL
-- =====================================================
-- Script para diagnosticar problemas específicos nos valores
-- restantes dos empréstimos nas empresas MOGIANA e LITORAL
-- =====================================================

-- =====================================================
-- 1. VERIFICAÇÃO DA ESTRUTURA DAS TABELAS
-- =====================================================

-- Verificar se todas as tabelas necessárias existem
SELECT 'VERIFICAÇÃO DE TABELAS' as tipo;

SELECT 
    table_name,
    CASE 
        WHEN table_name IN (
            'loans', 'payments', 'clients', 'users',
            'overdue_loans', 'partial_paid_loans', 'paid_loans', 'cancelled_loans'
        ) THEN '✅ EXISTE'
        ELSE '❌ FALTANDO'
    END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN (
    'loans', 'payments', 'clients', 'users',
    'overdue_loans', 'partial_paid_loans', 'paid_loans', 'cancelled_loans'
)
ORDER BY table_name;

-- =====================================================
-- 2. VERIFICAÇÃO DOS CAMPOS CRÍTICOS
-- =====================================================

-- Verificar campos na tabela loans
SELECT 'CAMPOS DA TABELA LOANS' as tipo;

SELECT 
    column_name,
    data_type,
    is_nullable,
    CASE 
        WHEN column_name = 'original_amount' AND is_nullable = 'YES' THEN '⚠️ DEVERIA SER NOT NULL'
        WHEN column_name = 'original_amount' AND is_nullable = 'NO' THEN '✅ CONFIGURADO CORRETAMENTE'
        WHEN column_name = 'original_amount' THEN '✅ EXISTE'
        WHEN column_name IN ('amount', 'interest_rate', 'status') THEN '✅ CAMPO ESSENCIAL'
        ELSE '📝 CAMPO NORMAL'
    END as status
FROM information_schema.columns 
WHERE table_name = 'loans' 
AND column_name IN ('id', 'amount', 'original_amount', 'interest_rate', 'status', 'client_id')
ORDER BY column_name;

-- =====================================================
-- 3. DIAGNÓSTICO DOS EMPRÉSTIMOS PROBLEMÁTICOS
-- =====================================================

-- Empréstimos com valores zerados ou problemáticos
SELECT 'EMPRÉSTIMOS COM PROBLEMAS' as tipo;

SELECT 
    l.id,
    c.name as cliente,
    l.amount as valor_atual,
    l.original_amount as valor_original,
    l.interest_rate as taxa_juros,
    l.status,
    l.due_date,
    CASE 
        WHEN l.amount = 0 THEN '❌ VALOR ZERADO'
        WHEN l.original_amount IS NULL THEN '❌ SEM VALOR ORIGINAL'
        WHEN l.original_amount = 0 THEN '❌ VALOR ORIGINAL ZERADO'
        WHEN l.amount != l.original_amount THEN '⚠️ VALORES DIFERENTES'
        ELSE '✅ OK'
    END as problema
FROM loans l
LEFT JOIN clients c ON l.client_id = c.id
WHERE l.amount = 0 
   OR l.original_amount IS NULL 
   OR l.original_amount = 0 
   OR l.amount != l.original_amount
ORDER BY l.created_at DESC;

-- =====================================================
-- 4. VERIFICAÇÃO DOS PAGAMENTOS
-- =====================================================

-- Empréstimos com pagamentos mas sem valor restante
SELECT 'EMPRÉSTIMOS COM PAGAMENTOS MAS SEM VALOR' as tipo;

SELECT 
    l.id,
    c.name as cliente,
    l.amount as valor_emprestimo,
    l.original_amount as valor_original,
    l.interest_rate as taxa_juros,
    COALESCE(p.total_pago, 0) as total_pago,
    (COALESCE(l.original_amount, l.amount) + (COALESCE(l.original_amount, l.amount) * l.interest_rate / 100)) as total_com_juros,
    GREATEST(0, (COALESCE(l.original_amount, l.amount) + (COALESCE(l.original_amount, l.amount) * l.interest_rate / 100)) - COALESCE(p.total_pago, 0)) as valor_restante_calculado,
    l.status
FROM loans l
LEFT JOIN clients c ON l.client_id = c.id
LEFT JOIN (
    SELECT loan_id, SUM(amount) as total_pago, COUNT(*) as num_pagamentos
    FROM payments 
    GROUP BY loan_id
) p ON l.id = p.loan_id
WHERE p.total_pago > 0 
  AND l.status IN ('active', 'overdue', 'partial_paid')
  AND (l.amount = 0 OR l.original_amount = 0)
ORDER BY l.created_at DESC;

-- =====================================================
-- 5. VERIFICAÇÃO DAS TABELAS DE STATUS
-- =====================================================

-- Verificar se as tabelas de status têm dados inconsistentes
SELECT 'TABELAS DE STATUS - OVERDUE_LOANS' as tipo;

SELECT 
    ol.loan_id,
    c.name as cliente,
    ol.original_amount,
    ol.remaining_amount,
    ol.total_paid,
    ol.days_overdue,
    CASE 
        WHEN ol.remaining_amount = 0 THEN '❌ SEM VALOR RESTANTE'
        WHEN ol.original_amount = 0 THEN '❌ SEM VALOR ORIGINAL'
        WHEN ol.remaining_amount > ol.original_amount THEN '⚠️ VALOR RESTANTE MAIOR QUE ORIGINAL'
        ELSE '✅ OK'
    END as status
FROM overdue_loans ol
LEFT JOIN clients c ON ol.client_id = c.id
WHERE ol.remaining_amount = 0 OR ol.original_amount = 0
ORDER BY ol.created_at DESC;

SELECT 'TABELAS DE STATUS - PARTIAL_PAID_LOANS' as tipo;

SELECT 
    ppl.loan_id,
    c.name as cliente,
    ppl.original_amount,
    ppl.remaining_amount,
    ppl.total_paid,
    ppl.payment_count,
    CASE 
        WHEN ppl.remaining_amount = 0 THEN '❌ SEM VALOR RESTANTE'
        WHEN ppl.original_amount = 0 THEN '❌ SEM VALOR ORIGINAL'
        WHEN ppl.remaining_amount > ppl.original_amount THEN '⚠️ VALOR RESTANTE MAIOR QUE ORIGINAL'
        ELSE '✅ OK'
    END as status
FROM partial_paid_loans ppl
LEFT JOIN clients c ON ppl.client_id = c.id
WHERE ppl.remaining_amount = 0 OR ppl.original_amount = 0
ORDER BY ppl.created_at DESC;

-- =====================================================
-- 6. ESTATÍSTICAS GERAIS
-- =====================================================

SELECT 'ESTATÍSTICAS GERAIS' as tipo;

SELECT 
    COUNT(*) as total_emprestimos,
    COUNT(CASE WHEN amount = 0 THEN 1 END) as emprestimos_valor_zero,
    COUNT(CASE WHEN original_amount IS NULL THEN 1 END) as sem_valor_original,
    COUNT(CASE WHEN original_amount = 0 THEN 1 END) as valor_original_zero,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as ativos,
    COUNT(CASE WHEN status = 'overdue' THEN 1 END) as vencidos,
    COUNT(CASE WHEN status = 'partial_paid' THEN 1 END) as parciais,
    COUNT(CASE WHEN status = 'paid' THEN 1 END) as quitados,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelados
FROM loans;

-- =====================================================
-- 7. VERIFICAÇÃO DE TRIGGERS
-- =====================================================

-- Verificar se os triggers existem
SELECT 'TRIGGERS EXISTENTES' as tipo;

SELECT 
    trigger_name,
    event_manipulation,
    event_object_table,
    action_timing,
    CASE 
        WHEN trigger_name LIKE '%overdue%' THEN '📊 TRIGGER DE VENCIDOS'
        WHEN trigger_name LIKE '%partial%' THEN '📊 TRIGGER DE PARCIAIS'
        WHEN trigger_name LIKE '%paid%' THEN '📊 TRIGGER DE QUITADOS'
        WHEN trigger_name LIKE '%cancelled%' THEN '📊 TRIGGER DE CANCELADOS'
        ELSE '📝 OUTRO TRIGGER'
    END as tipo_trigger
FROM information_schema.triggers 
WHERE event_object_table = 'loans'
ORDER BY trigger_name;

-- =====================================================
-- 8. RECOMENDAÇÕES BASEADAS NO DIAGNÓSTICO
-- =====================================================

DO $$
DECLARE
    problemas_encontrados INTEGER;
    emprestimos_sem_valor INTEGER;
    tabelas_status_problemas INTEGER;
BEGIN
    -- Contar problemas
    SELECT COUNT(*) INTO problemas_encontrados
    FROM loans 
    WHERE amount = 0 OR original_amount IS NULL OR original_amount = 0;
    
    SELECT COUNT(*) INTO emprestimos_sem_valor
    FROM loans 
    WHERE amount = 0 AND status IN ('active', 'overdue', 'partial_paid');
    
    SELECT COUNT(*) INTO tabelas_status_problemas
    FROM overdue_loans 
    WHERE remaining_amount = 0 OR original_amount = 0;
    
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'DIAGNÓSTICO CONCLUÍDO';
    RAISE NOTICE '==========================================';
    RAISE NOTICE '';
    
    IF problemas_encontrados > 0 THEN
        RAISE NOTICE '❌ PROBLEMAS ENCONTRADOS: % empréstimos com valores problemáticos', problemas_encontrados;
    ELSE
        RAISE NOTICE '✅ Nenhum problema encontrado na tabela principal';
    END IF;
    
    IF emprestimos_sem_valor > 0 THEN
        RAISE NOTICE '🚨 CRÍTICO: % empréstimos ativos sem valor', emprestimos_sem_valor;
    END IF;
    
    IF tabelas_status_problemas > 0 THEN
        RAISE NOTICE '⚠️ ATENÇÃO: % registros problemáticos nas tabelas de status', tabelas_status_problemas;
    END IF;
    
    RAISE NOTICE '';
    RAISE NOTICE '📋 PRÓXIMAS AÇÕES RECOMENDADAS:';
    
    IF problemas_encontrados > 0 THEN
        RAISE NOTICE '1. Execute o script fix-missing-loan-remaining-values.sql';
        RAISE NOTICE '2. Verifique se o campo original_amount foi preenchido';
        RAISE NOTICE '3. Recalcule os valores restantes';
    END IF;
    
    RAISE NOTICE '4. Monitore novos empréstimos para garantir que não há regressão';
    RAISE NOTICE '5. Verifique a interface para confirmar que os valores aparecem';
    
    RAISE NOTICE '';
    RAISE NOTICE '==========================================';
END $$;

-- =====================================================
-- INSTRUÇÕES DE USO
-- =====================================================
/*
COMO USAR ESTE SCRIPT DE DIAGNÓSTICO:

1. EXECUTE NAS DUAS EMPRESAS:
   - MOGIANA: https://eemfnpefgojllvzzaimu.supabase.co
   - LITORAL: https://dtifsfzmnjnllzzlndxv.supabase.co

2. ANALISE OS RESULTADOS:
   - Verifique as seções marcadas com ❌ ou ⚠️
   - Anote os IDs dos empréstimos problemáticos
   - Verifique se há padrões nos problemas

3. APÓS O DIAGNÓSTICO:
   - Se problemas forem encontrados, execute fix-missing-loan-remaining-values.sql
   - Teste a interface para confirmar a correção
   - Monitore para evitar regressão

4. RELATÓRIO:
   - Documente os problemas encontrados
   - Mantenha registro das correções aplicadas
*/