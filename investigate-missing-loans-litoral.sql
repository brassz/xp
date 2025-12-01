-- =============================================================================
-- SCRIPT DE DIAGNÓSTICO: INVESTIGAÇÃO DE EMPRÉSTIMOS SUMIDOS - LITORAL CRED
-- =============================================================================
-- Data: 1 de Dezembro de 2025
-- Empresa: LITORAL CRED
-- Problema: Empréstimos estão desaparecendo da empresa Litoral
-- =============================================================================

-- =============================================================================
-- PARTE 1: CONTAGEM GERAL DE EMPRÉSTIMOS
-- =============================================================================
SELECT 
    '=== CONTAGEM GERAL DE EMPRÉSTIMOS ===' as secao,
    '' as info;

SELECT 
    'Total de empréstimos na tabela loans' as descricao,
    COUNT(*) as quantidade
FROM loans;

SELECT 
    'Empréstimos por status' as descricao,
    status,
    COUNT(*) as quantidade
FROM loans
GROUP BY status
ORDER BY quantidade DESC;

-- =============================================================================
-- PARTE 2: EMPRÉSTIMOS CANCELADOS
-- =============================================================================
SELECT 
    '' as separador,
    '=== EMPRÉSTIMOS CANCELADOS ===' as secao,
    '' as info;

SELECT 
    'Total de empréstimos cancelados' as descricao,
    COUNT(*) as quantidade
FROM cancelled_loans;

SELECT 
    'Empréstimos cancelados recentemente (últimos 30 dias)' as descricao,
    COUNT(*) as quantidade
FROM cancelled_loans
WHERE cancelled_at >= CURRENT_DATE - INTERVAL '30 days';

-- Detalhes dos empréstimos cancelados recentemente
SELECT 
    'Detalhes dos 20 empréstimos cancelados mais recentes' as titulo,
    '' as info;

SELECT 
    cl.cancelled_at::date as data_cancelamento,
    c.name as cliente,
    cl.original_amount as valor_original,
    cl.total_with_interest as valor_total,
    cl.loan_date as data_emprestimo,
    cl.cancellation_reason as motivo,
    CASE 
        WHEN EXISTS (SELECT 1 FROM loans WHERE id = cl.loan_id) 
        THEN 'SIM - Ainda existe na tabela loans'
        ELSE 'NÃO - Foi removido da tabela loans'
    END as emprestimo_existe
FROM cancelled_loans cl
LEFT JOIN clients c ON c.id = cl.client_id
ORDER BY cl.cancelled_at DESC
LIMIT 20;

-- =============================================================================
-- PARTE 3: VERIFICAR SE HÁ EMPRÉSTIMOS SEM CLIENTE
-- =============================================================================
SELECT 
    '' as separador,
    '=== VERIFICAÇÃO DE INTEGRIDADE ===' as secao,
    '' as info;

SELECT 
    'Empréstimos órfãos (sem cliente vinculado)' as descricao,
    COUNT(*) as quantidade
FROM loans l
WHERE NOT EXISTS (SELECT 1 FROM clients c WHERE c.id = l.client_id);

-- Listar empréstimos órfãos se existirem
SELECT 
    'Detalhes dos empréstimos órfãos' as titulo,
    l.id as loan_id,
    l.client_id,
    l.amount,
    l.status,
    l.loan_date,
    l.created_at
FROM loans l
WHERE NOT EXISTS (SELECT 1 FROM clients c WHERE c.id = l.client_id)
LIMIT 10;

-- =============================================================================
-- PARTE 4: VERIFICAR POLÍTICAS RLS
-- =============================================================================
SELECT 
    '' as separador,
    '=== POLÍTICAS DE SEGURANÇA (RLS) ===' as secao,
    '' as info;

SELECT 
    'Status do RLS na tabela loans' as descricao,
    CASE 
        WHEN rowsecurity THEN 'HABILITADO - Pode estar filtrando dados'
        ELSE 'DESABILITADO - Não está filtrando dados'
    END as status
FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'loans';

-- Listar todas as políticas ativas na tabela loans
SELECT 
    'Políticas RLS ativas na tabela loans' as titulo,
    policyname as nome_politica,
    CASE cmd
        WHEN 'r' THEN 'SELECT'
        WHEN 'a' THEN 'INSERT'
        WHEN 'w' THEN 'UPDATE'
        WHEN 'd' THEN 'DELETE'
        WHEN '*' THEN 'ALL'
    END as tipo_comando,
    qual as condicao
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'loans';

-- =============================================================================
-- PARTE 5: VERIFICAR TRIGGERS
-- =============================================================================
SELECT 
    '' as separador,
    '=== TRIGGERS NA TABELA LOANS ===' as secao,
    '' as info;

SELECT 
    'Triggers ativos na tabela loans' as titulo,
    trigger_name as nome_trigger,
    event_manipulation as evento,
    action_timing as timing,
    action_statement as acao
FROM information_schema.triggers
WHERE event_object_table = 'loans'
ORDER BY trigger_name;

-- =============================================================================
-- PARTE 6: HISTÓRICO DE CRIAÇÃO DE EMPRÉSTIMOS
-- =============================================================================
SELECT 
    '' as separador,
    '=== HISTÓRICO DE CRIAÇÃO DE EMPRÉSTIMOS ===' as secao,
    '' as info;

SELECT 
    'Empréstimos criados nos últimos 30 dias' as descricao,
    COUNT(*) as quantidade
FROM loans
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days';

SELECT 
    'Empréstimos criados por semana (últimas 8 semanas)' as titulo,
    date_trunc('week', created_at)::date as semana,
    COUNT(*) as quantidade_criada
FROM loans
WHERE created_at >= CURRENT_DATE - INTERVAL '8 weeks'
GROUP BY date_trunc('week', created_at)
ORDER BY semana DESC;

-- =============================================================================
-- PARTE 7: VERIFICAR SE HÁ EMPRÉSTIMOS DUPLICADOS
-- =============================================================================
SELECT 
    '' as separador,
    '=== VERIFICAÇÃO DE DUPLICAÇÕES ===' as secao,
    '' as info;

SELECT 
    'Empréstimos potencialmente duplicados (mesmo cliente, valor e data)' as titulo,
    client_id,
    amount,
    loan_date,
    COUNT(*) as quantidade
FROM loans
GROUP BY client_id, amount, loan_date
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC
LIMIT 10;

-- =============================================================================
-- PARTE 8: EMPRÉSTIMOS RECENTES E SEUS STATUS
-- =============================================================================
SELECT 
    '' as separador,
    '=== ÚLTIMOS 50 EMPRÉSTIMOS ===' as secao,
    '' as info;

SELECT 
    'Últimos 50 empréstimos criados' as titulo,
    l.created_at::timestamp(0) as criado_em,
    c.name as cliente,
    l.amount as valor,
    l.status as status,
    l.loan_date as data_emprestimo,
    l.due_date as vencimento,
    CASE 
        WHEN EXISTS (SELECT 1 FROM cancelled_loans WHERE loan_id = l.id) 
        THEN 'SIM'
        ELSE 'NÃO'
    END as esta_em_cancelled_loans
FROM loans l
LEFT JOIN clients c ON c.id = l.client_id
ORDER BY l.created_at DESC
LIMIT 50;

-- =============================================================================
-- PARTE 9: VERIFICAR SE HÁ CASCADE DELETE CONFIGURADO
-- =============================================================================
SELECT 
    '' as separador,
    '=== FOREIGN KEYS COM DELETE CASCADE ===' as secao,
    '' as info;

SELECT 
    'Foreign keys que podem deletar empréstimos em cascata' as titulo,
    tc.table_name as tabela_origem,
    kcu.column_name as coluna,
    ccu.table_name as tabela_referenciada,
    ccu.column_name as coluna_referenciada,
    rc.delete_rule as regra_delete
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu 
    ON ccu.constraint_name = tc.constraint_name
JOIN information_schema.referential_constraints rc 
    ON rc.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND ccu.table_name = 'loans'
    AND rc.delete_rule = 'CASCADE';

-- =============================================================================
-- PARTE 10: ANÁLISE FINAL
-- =============================================================================
SELECT 
    '' as separador,
    '=== RESUMO FINAL ===' as secao,
    '' as info;

SELECT 
    'Resumo de todas as tabelas de empréstimos' as titulo,
    '' as info;

SELECT 'loans (principal)' as tabela, COUNT(*) as quantidade FROM loans
UNION ALL
SELECT 'cancelled_loans' as tabela, COUNT(*) as quantidade FROM cancelled_loans
UNION ALL
SELECT 'paid_loans' as tabela, COUNT(*) as quantidade FROM paid_loans
UNION ALL
SELECT 'overdue_loans' as tabela, COUNT(*) as quantidade FROM overdue_loans
UNION ALL
SELECT 'partial_paid_loans' as tabela, COUNT(*) as quantidade FROM partial_paid_loans
ORDER BY tabela;

-- =============================================================================
-- RECOMENDAÇÕES
-- =============================================================================
SELECT 
    '' as separador,
    '=== RECOMENDAÇÕES ===' as secao,
    '' as info;

SELECT 
    'Análise concluída!' as status,
    'Verifique os resultados acima para identificar:' as recomendacao_1,
    '1. Se há muitos empréstimos cancelados recentemente' as recomendacao_2,
    '2. Se o RLS está habilitado e filtrando dados' as recomendacao_3,
    '3. Se há triggers que podem estar movendo/deletando empréstimos' as recomendacao_4,
    '4. Se há problemas de integridade (empréstimos órfãos)' as recomendacao_5;

-- =============================================================================
-- FIM DO DIAGNÓSTICO
-- =============================================================================
