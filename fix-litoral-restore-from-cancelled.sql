-- =============================================================================
-- SOLUÇÃO 2: RESTAURAR EMPRÉSTIMOS DE CANCELLED_LOANS
-- =============================================================================
-- Este script identifica e permite restaurar empréstimos que foram
-- incorretamente movidos para a tabela cancelled_loans
-- =============================================================================

-- PASSO 1: Identificar empréstimos que estão em cancelled_loans mas não em loans
SELECT 
    '=== EMPRÉSTIMOS DELETADOS DA TABELA LOANS ===' as titulo;

SELECT 
    cl.loan_id,
    c.name as cliente,
    cl.original_amount as valor,
    cl.loan_date,
    cl.cancelled_at as cancelado_em,
    cl.cancellation_reason as motivo
FROM cancelled_loans cl
LEFT JOIN clients c ON c.id = cl.client_id
WHERE NOT EXISTS (SELECT 1 FROM loans WHERE id = cl.loan_id)
ORDER BY cl.cancelled_at DESC;

-- PASSO 2: Contar quantos empréstimos foram perdidos
SELECT 
    'Total de empréstimos em cancelled_loans que não existem em loans:' as descricao,
    COUNT(*) as quantidade
FROM cancelled_loans cl
WHERE NOT EXISTS (SELECT 1 FROM loans WHERE id = cl.loan_id);

-- =============================================================================
-- ATENÇÃO: Execute os comandos abaixo APENAS se quiser restaurar os empréstimos!
-- =============================================================================

-- DESCOMENTE AS LINHAS ABAIXO PARA RESTAURAR:
/*

-- PASSO 3: Restaurar empréstimos de volta para a tabela loans
INSERT INTO loans (
    id,
    client_id,
    amount,
    interest_rate,
    loan_date,
    due_date,
    status,
    total_amount,
    created_by,
    created_at,
    updated_at
)
SELECT 
    cl.loan_id as id,
    cl.client_id,
    cl.original_amount as amount,
    cl.interest_rate,
    cl.loan_date,
    cl.due_date,
    'cancelled' as status, -- Mantém como cancelado, mas agora visível
    cl.total_with_interest as total_amount,
    cl.created_by,
    cl.created_at,
    cl.cancelled_at as updated_at
FROM cancelled_loans cl
WHERE NOT EXISTS (SELECT 1 FROM loans WHERE id = cl.loan_id)
ON CONFLICT (id) DO NOTHING;

-- PASSO 4: Verificar quantos foram restaurados
SELECT 
    '✅ Empréstimos restaurados!' as status,
    'Total restaurado:' as descricao,
    COUNT(*) as quantidade
FROM loans l
WHERE EXISTS (SELECT 1 FROM cancelled_loans WHERE loan_id = l.id);

*/

-- =============================================================================
-- ALTERNATIVA: Restaurar E mudar status para 'active'
-- =============================================================================

-- DESCOMENTE AS LINHAS ABAIXO PARA RESTAURAR COMO ATIVOS:
/*

INSERT INTO loans (
    id,
    client_id,
    amount,
    interest_rate,
    loan_date,
    due_date,
    status,
    total_amount,
    created_by,
    created_at,
    updated_at
)
SELECT 
    cl.loan_id as id,
    cl.client_id,
    cl.original_amount as amount,
    cl.interest_rate,
    cl.loan_date,
    cl.due_date,
    CASE 
        WHEN cl.due_date < CURRENT_DATE THEN 'overdue'
        ELSE 'active'
    END as status,
    cl.total_with_interest as total_amount,
    cl.created_by,
    cl.created_at,
    NOW() as updated_at
FROM cancelled_loans cl
WHERE NOT EXISTS (SELECT 1 FROM loans WHERE id = cl.loan_id)
    AND cl.cancelled_at >= CURRENT_DATE - INTERVAL '30 days' -- Apenas dos últimos 30 dias
ON CONFLICT (id) DO NOTHING;

*/

-- =============================================================================
-- MENSAGEM FINAL
-- =============================================================================
SELECT 
    '⚠️ INSTRUÇÕES' as tipo,
    'Analise os resultados acima antes de executar os comandos de restauração.' as mensagem_1,
    'Os comandos de restauração estão comentados por segurança.' as mensagem_2,
    'Descomente apenas o bloco que você deseja executar.' as mensagem_3;
