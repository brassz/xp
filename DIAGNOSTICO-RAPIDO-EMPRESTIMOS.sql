-- ============================================================================
-- DIAGNÓSTICO RÁPIDO: VERIFICAR SE EMPRÉSTIMOS ESTÃO SUMINDO
-- ============================================================================
-- Execute este script no SQL Editor do Supabase
-- Tempo estimado: 5-10 segundos
-- ============================================================================

-- 1. CONTAGEM TOTAL EM TODAS AS TABELAS
-- ============================================================================
SELECT 
    '=== CONTAGEM TOTAL DE EMPRÉSTIMOS ===' as titulo;

SELECT 
    'loans (ativos)' as tabela, 
    COUNT(*) as quantidade,
    COALESCE(SUM(amount), 0) as valor_total
FROM loans
UNION ALL
SELECT 
    'cancelled_loans' as tabela, 
    COUNT(*) as quantidade,
    COALESCE(SUM(original_amount), 0) as valor_total
FROM cancelled_loans
UNION ALL
SELECT 
    'paid_loans' as tabela, 
    COUNT(*) as quantidade,
    COALESCE(SUM(original_amount), 0) as valor_total
FROM paid_loans;

-- 2. EMPRÉSTIMOS MOVIDOS RECENTEMENTE (Últimos 7 dias)
-- ============================================================================
SELECT 
    '=== EMPRÉSTIMOS CANCELADOS NOS ÚLTIMOS 7 DIAS ===' as titulo;

SELECT 
    cl.cancelled_at::date as data,
    c.name as cliente,
    cl.original_amount as valor,
    cl.cancellation_reason as motivo,
    CASE 
        WHEN EXISTS (SELECT 1 FROM loans WHERE id = cl.loan_id) 
        THEN '⚠️ AINDA EXISTE EM LOANS'
        ELSE '✓ Removido corretamente'
    END as status
FROM cancelled_loans cl
LEFT JOIN clients c ON c.id = cl.client_id
WHERE cl.cancelled_at >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY cl.cancelled_at DESC;

-- 3. VERIFICAR STATUS DO RLS (Row Level Security)
-- ============================================================================
SELECT 
    '=== STATUS DO RLS (Pode esconder empréstimos) ===' as titulo;

SELECT 
    tablename as tabela,
    CASE 
        WHEN rowsecurity THEN '🔴 RLS HABILITADO - Pode esconder dados'
        ELSE '✅ RLS DESABILITADO - Mostra todos os dados'
    END as status,
    rowsecurity as rls_ativo
FROM pg_tables
WHERE schemaname = 'public' 
AND tablename IN ('loans', 'cancelled_loans', 'paid_loans')
ORDER BY tablename;

-- 4. POLÍTICAS RLS ATIVAS (Se houver)
-- ============================================================================
SELECT 
    '=== POLÍTICAS RLS NA TABELA LOANS ===' as titulo;

SELECT 
    policyname as politica,
    cmd as comando,
    'Se esta lista não está vazia, pode estar filtrando dados' as alerta
FROM pg_policies
WHERE schemaname = 'public' 
AND tablename = 'loans';

-- 5. VERIFICAR TRIGGERS ATIVOS
-- ============================================================================
SELECT 
    '=== TRIGGERS ATIVOS (Podem mover/deletar empréstimos) ===' as titulo;

SELECT 
    trigger_name as trigger,
    event_manipulation as evento,
    action_timing as quando,
    'Triggers podem mover empréstimos automaticamente' as alerta
FROM information_schema.triggers
WHERE event_object_table = 'loans'
AND event_object_schema = 'public';

-- 6. EMPRÉSTIMOS ÓRFÃOS (Sem cliente)
-- ============================================================================
SELECT 
    '=== EMPRÉSTIMOS ÓRFÃOS (Cliente não existe) ===' as titulo;

SELECT 
    COUNT(*) as quantidade,
    CASE 
        WHEN COUNT(*) > 0 THEN '⚠️ PROBLEMA: Há empréstimos sem cliente'
        ELSE '✅ OK: Todos os empréstimos têm cliente válido'
    END as status
FROM loans l
WHERE NOT EXISTS (SELECT 1 FROM clients c WHERE c.id = l.client_id);

-- 7. TENDÊNCIA DE CRIAÇÃO (Últimas 4 semanas)
-- ============================================================================
SELECT 
    '=== TENDÊNCIA DE CRIAÇÃO (Últimas 4 semanas) ===' as titulo;

SELECT 
    date_trunc('week', created_at)::date as semana,
    COUNT(*) as emprestimos_criados,
    CASE 
        WHEN COUNT(*) < 5 THEN '⚠️ Baixa atividade'
        ELSE '✅ Atividade normal'
    END as status
FROM loans
WHERE created_at >= CURRENT_DATE - INTERVAL '4 weeks'
GROUP BY date_trunc('week', created_at)
ORDER BY semana DESC;

-- 8. FOREIGN KEYS COM CASCADE DELETE
-- ============================================================================
SELECT 
    '=== FOREIGN KEYS PERIGOSAS (DELETE CASCADE) ===' as titulo;

SELECT 
    tc.table_name as tabela,
    kcu.column_name as coluna,
    ccu.table_name as referencia,
    rc.delete_rule as regra,
    'CASCADE significa: deletar cliente deleta empréstimos' as alerta
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu 
    ON ccu.constraint_name = tc.constraint_name
JOIN information_schema.referential_constraints rc 
    ON rc.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name = 'loans'
    AND rc.delete_rule = 'CASCADE';

-- 9. RESUMO FINAL E DIAGNÓSTICO
-- ============================================================================
SELECT 
    '=== DIAGNÓSTICO FINAL ===' as titulo;

WITH stats AS (
    SELECT 
        (SELECT COUNT(*) FROM loans) as total_loans,
        (SELECT COUNT(*) FROM cancelled_loans) as total_cancelled,
        (SELECT COUNT(*) FROM paid_loans) as total_paid,
        (SELECT COALESCE(MAX(rowsecurity), false) FROM pg_tables 
         WHERE schemaname = 'public' AND tablename = 'loans') as has_rls
)
SELECT 
    total_loans as emprestimos_ativos,
    total_cancelled as emprestimos_cancelados,
    total_paid as emprestimos_pagos,
    (total_loans + total_cancelled + total_paid) as total_geral,
    CASE 
        WHEN has_rls THEN '🔴 RLS ATIVO - RISCO ALTO'
        ELSE '🟢 RLS INATIVO - Risco Reduzido'
    END as status_rls,
    CASE 
        WHEN total_cancelled::float / NULLIF(total_loans, 0) > 0.1 
        THEN '⚠️ MUITOS CANCELAMENTOS (>10%)'
        ELSE '✅ Taxa de cancelamento normal'
    END as alerta_cancelamentos
FROM stats;

-- 10. RECOMENDAÇÕES BASEADAS NOS RESULTADOS
-- ============================================================================
SELECT 
    '=== RECOMENDAÇÕES ===' as titulo;

SELECT 
    'ATENÇÃO: Analise os resultados acima!' as recomendacao_1,
    '' as separador,
    '🔴 Se RLS está HABILITADO:' as item_1,
    '   → Empréstimos podem estar escondidos por políticas de segurança' as item_1_detalhe,
    '   → Execute: ALTER TABLE loans DISABLE ROW LEVEL SECURITY;' as item_1_solucao,
    '' as separador2,
    '⚠️ Se há MUITOS cancelamentos recentes:' as item_2,
    '   → Verifique se foram cancelamentos legítimos' as item_2_detalhe,
    '   → Considere restaurar de cancelled_loans se foram erros' as item_2_solucao,
    '' as separador3,
    '⚠️ Se há TRIGGERS ativos:' as item_3,
    '   → Eles podem estar movendo empréstimos automaticamente' as item_3_detalhe,
    '   → Revise a lógica de cada trigger' as item_3_solucao,
    '' as separador4,
    '⚠️ Se há DELETE CASCADE:' as item_4,
    '   → Deletar cliente deleta TODOS os empréstimos dele' as item_4_detalhe,
    '   → Implemente soft delete em vez de hard delete' as item_4_solucao;

-- ============================================================================
-- FIM DO DIAGNÓSTICO
-- ============================================================================

SELECT 
    'Diagnóstico concluído!' as status,
    'Analise os resultados acima para identificar problemas' as proximos_passos,
    'Se encontrar anomalias, consulte: ANALISE-PROBABILIDADE-EMPRESTIMOS-SUMINDO.md' as documentacao;
