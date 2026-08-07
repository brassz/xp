-- =====================================================
-- VERIFICAÇÃO: CAMPO FINE_AMOUNT NA TABELA PAYMENTS
-- =====================================================
-- Este script verifica se o campo fine_amount existe e está configurado corretamente

-- Passo 1: Verificar estrutura da tabela payments
SELECT 
    '=== ESTRUTURA DA TABELA PAYMENTS ===' as verificacao;

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns 
WHERE table_name = 'payments'
ORDER BY ordinal_position;

-- Passo 2: Verificar especificamente o campo fine_amount
SELECT 
    '=== DETALHES DO CAMPO FINE_AMOUNT ===' as verificacao;

SELECT 
    column_name,
    data_type,
    numeric_precision,
    numeric_scale,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'payments' 
AND column_name = 'fine_amount';

-- Passo 3: Se o campo não existir, este retornará vazio
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM information_schema.columns 
            WHERE table_name = 'payments' 
            AND column_name = 'fine_amount'
        )
        THEN '✅ Campo fine_amount EXISTE'
        ELSE '❌ Campo fine_amount NÃO EXISTE - Execute o script fix-multas-display-issue.sql'
    END as status;

-- Passo 4: Verificar constraints
SELECT 
    '=== CONSTRAINTS DO CAMPO FINE_AMOUNT ===' as verificacao;

SELECT 
    tc.constraint_name,
    tc.constraint_type,
    cc.check_clause
FROM information_schema.table_constraints tc
LEFT JOIN information_schema.check_constraints cc 
    ON tc.constraint_name = cc.constraint_name
WHERE tc.table_name = 'payments'
AND (
    tc.constraint_name LIKE '%fine%'
    OR cc.check_clause LIKE '%fine%'
);

-- Passo 5: Verificar índices
SELECT 
    '=== ÍNDICES RELACIONADOS A FINE_AMOUNT ===' as verificacao;

SELECT 
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'payments'
AND indexdef LIKE '%fine%';

-- Passo 6: Contar pagamentos com e sem multa
SELECT 
    '=== ESTATÍSTICAS DE PAGAMENTOS ===' as verificacao;

SELECT 
    COUNT(*) as total_pagamentos,
    COUNT(*) FILTER (WHERE fine_amount IS NULL) as pagamentos_fine_null,
    COUNT(*) FILTER (WHERE fine_amount = 0) as pagamentos_fine_zero,
    COUNT(*) FILTER (WHERE fine_amount > 0) as pagamentos_com_multa,
    SUM(fine_amount) as total_em_multas,
    AVG(fine_amount) FILTER (WHERE fine_amount > 0) as media_multas,
    MAX(fine_amount) as maior_multa
FROM payments;

-- Passo 7: Listar últimos 10 pagamentos com detalhes de multa
SELECT 
    '=== ÚLTIMOS 10 PAGAMENTOS (COM DETALHES DE MULTA) ===' as verificacao;

SELECT 
    id,
    loan_id,
    amount,
    fine_amount,
    CASE 
        WHEN fine_amount IS NULL THEN 'NULL'
        WHEN fine_amount = 0 THEN 'ZERO'
        ELSE 'COM VALOR'
    END as status_fine,
    payment_date,
    payment_type,
    created_at
FROM payments
ORDER BY created_at DESC
LIMIT 10;

-- Passo 8: Se houver pagamentos com multa, mostrar exemplos
SELECT 
    '=== PAGAMENTOS COM MULTA (SE HOUVER) ===' as verificacao;

SELECT 
    id,
    loan_id,
    amount as valor_pagamento,
    fine_amount as valor_multa,
    (amount + COALESCE(fine_amount, 0)) as total,
    payment_date,
    payment_type
FROM payments
WHERE fine_amount > 0
ORDER BY created_at DESC
LIMIT 5;

-- =====================================================
-- INSTRUÇÕES
-- =====================================================
/*
Execute este script no Supabase SQL Editor para diagnosticar o problema.

RESULTADOS ESPERADOS:
1. O campo fine_amount deve aparecer na lista de colunas
2. O tipo deve ser numeric ou decimal(10,2)
3. O padrão deve ser 0.00
4. Deve haver um constraint CHECK (fine_amount >= 0)

SE O CAMPO NÃO EXISTIR:
Execute o script: fix-multas-display-issue.sql

APÓS EXECUTAR:
1. Vá no navegador e abra o Console (F12)
2. Vá na aba Empréstimos
3. Adicione um pagamento com multa
4. Verifique os logs no console que começam com 🔍 [DEBUG]
5. Os logs mostrarão se o valor está sendo capturado e salvo
*/
