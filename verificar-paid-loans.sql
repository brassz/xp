-- =====================================================
-- SCRIPT DE VERIFICAÇÃO: Tabela paid_loans
-- =====================================================
-- Execute este script no SQL Editor do Supabase para
-- verificar se a tabela paid_loans está configurada
-- corretamente e se há dados nela.
-- =====================================================

-- 1. VERIFICAR SE A TABELA EXISTE
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'paid_loans';

-- Se retornar uma linha, a tabela existe ✅
-- Se retornar vazio, execute o script setup-paid-loans.sql ❌

-- =====================================================

-- 2. VERIFICAR ESTRUTURA DA TABELA
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'paid_loans'
ORDER BY ordinal_position;

-- Deve mostrar todas as colunas: id, loan_id, client_id, 
-- original_amount, interest_rate, total_with_interest,
-- loan_date, due_date, paid_date, total_paid, 
-- payment_method, notes, created_by, created_at, updated_at

-- =====================================================

-- 3. VERIFICAR SE HÁ DADOS NA TABELA
SELECT 
    COUNT(*) as total_emprestimos_quitados
FROM paid_loans;

-- Mostra quantos empréstimos quitados existem na tabela

-- =====================================================

-- 4. VERIFICAR ÚLTIMOS EMPRÉSTIMOS QUITADOS
SELECT 
    pl.id,
    pl.loan_id,
    c.name as cliente_nome,
    c.cpf as cliente_cpf,
    pl.original_amount as valor_original,
    pl.interest_rate as taxa_juros,
    pl.total_paid as total_pago,
    pl.loan_date as data_emprestimo,
    pl.due_date as data_vencimento,
    pl.paid_date as data_quitacao,
    pl.created_at as criado_em
FROM paid_loans pl
LEFT JOIN clients c ON c.id = pl.client_id
ORDER BY pl.paid_date DESC, pl.created_at DESC
LIMIT 10;

-- Mostra os últimos 10 empréstimos quitados

-- =====================================================

-- 5. VERIFICAR POLÍTICAS RLS
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'paid_loans'
ORDER BY policyname;

-- Deve mostrar 4 políticas:
-- - SELECT para authenticated
-- - INSERT para authenticated
-- - UPDATE para criadores/admins
-- - DELETE para criadores/admins

-- =====================================================

-- 6. VERIFICAR SE RLS ESTÁ HABILITADO
SELECT 
    tablename,
    rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
AND tablename = 'paid_loans';

-- rowsecurity deve ser 't' (true) ✅

-- =====================================================

-- 7. TESTE DE INSERÇÃO (OPCIONAL)
-- Descomente as linhas abaixo para testar se consegue inserir

/*
-- ATENÇÃO: Substitua os UUIDs pelos valores reais do seu banco
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
    created_by
) VALUES (
    gen_random_uuid(), -- loan_id (UUID fictício para teste)
    'SEU_CLIENT_ID_AQUI', -- Substitua por um client_id real
    1000.00,
    10.00,
    1100.00,
    CURRENT_DATE - INTERVAL '30 days',
    CURRENT_DATE - INTERVAL '1 day',
    CURRENT_DATE,
    1100.00,
    'Teste',
    'Teste de inserção manual',
    auth.uid() -- Seu user ID
);

-- Se inserir com sucesso, a tabela está funcionando ✅
-- Se der erro, veja a mensagem e corrija as políticas RLS
*/

-- =====================================================

-- 8. VERIFICAR EMPRÉSTIMOS QUE PODEM SER QUITADOS
-- (Empréstimos que estão marcados como paid mas não estão em paid_loans)

SELECT 
    l.id,
    c.name as cliente_nome,
    c.cpf as cliente_cpf,
    l.amount as valor,
    l.interest_rate as juros,
    l.status,
    l.loan_date,
    l.due_date
FROM loans l
LEFT JOIN clients c ON c.id = l.client_id
WHERE l.status = 'paid'
AND NOT EXISTS (
    SELECT 1 FROM paid_loans pl 
    WHERE pl.loan_id = l.id
);

-- Se retornar linhas, há empréstimos marcados como 'paid' 
-- na tabela loans que NÃO estão na tabela paid_loans
-- Isso indica que houve falha no processo de quitação

-- =====================================================

-- 9. RESUMO POR DATA DE QUITAÇÃO
SELECT 
    paid_date as data_quitacao,
    COUNT(*) as quantidade,
    SUM(original_amount) as valor_original_total,
    SUM(total_paid) as valor_pago_total
FROM paid_loans
WHERE paid_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY paid_date
ORDER BY paid_date DESC;

-- Mostra resumo dos últimos 30 dias

-- =====================================================

-- 10. VERIFICAR INTEGRIDADE DOS DADOS
SELECT 
    'Total de registros' as verificacao,
    COUNT(*) as resultado
FROM paid_loans

UNION ALL

SELECT 
    'Registros sem client_id',
    COUNT(*)
FROM paid_loans
WHERE client_id IS NULL

UNION ALL

SELECT 
    'Registros com valores zerados',
    COUNT(*)
FROM paid_loans
WHERE original_amount = 0 OR total_paid = 0

UNION ALL

SELECT 
    'Registros sem data de quitação',
    COUNT(*)
FROM paid_loans
WHERE paid_date IS NULL;

-- Todos os valores (exceto o primeiro) devem ser 0 ✅

-- =====================================================
-- FIM DA VERIFICAÇÃO
-- =====================================================

-- INTERPRETAÇÃO DOS RESULTADOS:
--
-- ✅ TUDO OK se:
-- - Tabela existe
-- - RLS está habilitado (rowsecurity = 't')
-- - Políticas estão configuradas (4 políticas)
-- - Consegue fazer SELECT dos dados
-- - Não há empréstimos 'paid' órfãos na tabela loans
--
-- ❌ PROBLEMA se:
-- - Tabela não existe → Execute setup-paid-loans.sql
-- - Não há políticas RLS → Execute setup-paid-loans.sql
-- - Erro ao fazer SELECT → Verifique políticas RLS
-- - Há empréstimos 'paid' órfãos → Sistema não salvou corretamente
--
-- =====================================================
