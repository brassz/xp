-- =====================================================
-- DIAGNÓSTICO DE EMPRÉSTIMOS QUITADOS - LITORAL CRED
-- =====================================================
-- Execute este script no SQL Editor do Supabase da LITORAL CRED
-- URL: https://dtifsfzmnjnllzzlndxv.supabase.co
-- =====================================================

-- 1. VERIFICAR SE A TABELA PAID_LOANS EXISTE
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'paid_loans';

-- 2. CONTAR REGISTROS NA TABELA PAID_LOANS
SELECT COUNT(*) as total_paid_loans FROM paid_loans;

-- 3. LISTAR TODOS OS EMPRÉSTIMOS QUITADOS (se existirem)
SELECT 
    id,
    loan_id,
    client_id,
    original_amount,
    interest_rate,
    paid_date,
    total_paid,
    notes,
    created_at
FROM paid_loans
ORDER BY paid_date DESC
LIMIT 100;

-- 4. VERIFICAR SE A TABELA TEM A ESTRUTURA CORRETA
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name = 'paid_loans'
ORDER BY ordinal_position;

-- 5. VERIFICAR POLÍTICAS RLS (Row Level Security)
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'paid_loans'
ORDER BY policyname;

-- 6. VERIFICAR SE RLS ESTÁ HABILITADO
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
AND tablename = 'paid_loans';

-- 7. BUSCAR EMPRÉSTIMOS QUE DEVERIAM ESTAR EM PAID_LOANS
-- (Empréstimos com status 'paid' na tabela loans)
SELECT 
    id,
    client_id,
    amount,
    interest_rate,
    loan_date,
    due_date,
    status,
    created_at
FROM loans
WHERE status = 'paid'
ORDER BY created_at DESC
LIMIT 50;

-- 8. VERIFICAR SE HÁ REGISTROS DE PAYMENTS QUE INDICAM QUITAÇÃO
SELECT 
    p.id,
    p.loan_id,
    p.client_id,
    p.amount,
    p.payment_date,
    p.is_final_payment,
    COUNT(p.id) as total_payments,
    SUM(p.amount) as total_paid
FROM payments p
WHERE p.is_final_payment = true
GROUP BY p.id, p.loan_id, p.client_id, p.amount, p.payment_date, p.is_final_payment
ORDER BY p.payment_date DESC
LIMIT 50;

-- =====================================================
-- DIAGNÓSTICO DE POSSÍVEIS PROBLEMAS
-- =====================================================

-- 9. VERIFICAR SE USUÁRIOS TÊM PERMISSÃO PARA VER PAID_LOANS
-- Execute esta query como o usuário atual
SELECT current_user, session_user;

-- 10. TESTAR SELECT DIRETO NA TABELA
-- Se retornar erro, há problema de permissão ou RLS
SELECT * FROM paid_loans LIMIT 1;

-- =====================================================
-- POSSÍVEIS CAUSAS E SOLUÇÕES
-- =====================================================

/*
CAUSA 1: Tabela paid_loans não existe
SOLUÇÃO: Executar o script setup-paid-loans.sql

CAUSA 2: RLS bloqueando acesso
SOLUÇÃO: Verificar políticas RLS e ajustar conforme necessário

CAUSA 3: Dados foram deletados acidentalmente
SOLUÇÃO: Restaurar do backup ou recriar a partir de logs de payments

CAUSA 4: Empréstimos marcados como 'paid' mas não movidos para paid_loans
SOLUÇÃO: Migrar empréstimos com status 'paid' para a tabela paid_loans

CAUSA 5: Problema de autenticação/permissões
SOLUÇÃO: Verificar se usuário está autenticado e tem role correto
*/

-- =====================================================
-- FIM DO DIAGNÓSTICO
-- ===================================================== 
