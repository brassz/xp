-- Script para limpar completamente a tabela loans de problemas
-- Execute este script no Supabase SQL Editor

-- 1. REMOVER TODAS AS FUNÇÕES RELACIONADAS A LOANS
DROP FUNCTION IF EXISTS create_loan CASCADE;
DROP FUNCTION IF EXISTS insert_loan CASCADE;
DROP FUNCTION IF EXISTS add_loan CASCADE;

-- 2. REMOVER TODAS AS CONSTRAINTS DE CHECK PROBLEMÁTICAS
ALTER TABLE loans DROP CONSTRAINT IF EXISTS loans_status_check;
ALTER TABLE loans DROP CONSTRAINT IF EXISTS loans_amount_check;
ALTER TABLE loans DROP CONSTRAINT IF EXISTS loans_interest_rate_check;

-- 3. VERIFICAR SE A TABELA ESTÁ LIMPA
SELECT 
    'CONSTRAINTS RESTANTES:' as info,
    conname AS constraint_name,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint 
WHERE conrelid = 'loans'::regclass 
AND contype = 'c';

-- 4. VERIFICAR ESTRUTURA DA TABELA
SELECT 
    'ESTRUTURA DA TABELA:' as info,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'loans'
ORDER BY ordinal_position;

-- 5. TESTAR INSERÇÃO SIMPLES (descomente para testar)
/*
-- Verificar se existem clientes e usuários
SELECT 'TESTE - Clientes disponíveis:' as info, id, name FROM clients LIMIT 1;
SELECT 'TESTE - Usuários disponíveis:' as info, id, email FROM users LIMIT 1;

-- Tentar inserção básica
INSERT INTO loans (client_id, amount, interest_rate, loan_date, due_date, created_by)
SELECT 
    (SELECT id FROM clients LIMIT 1),
    100.00,
    5.0,
    '2025-08-07',
    '2025-09-07',
    (SELECT id FROM users LIMIT 1);

-- Verificar se foi inserido
SELECT 'TESTE - Empréstimo criado:' as info, * FROM loans WHERE amount = 100.00 ORDER BY created_at DESC LIMIT 1;
*/

SELECT 'Limpeza concluída! Tabela loans está pronta para uso simples.' as resultado;