-- Script para testar inserção direta na tabela loans
-- Execute este script no Supabase SQL Editor

-- 1. VERIFICAR ESTRUTURA EXATA DA TABELA
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns 
WHERE table_name = 'loans'
ORDER BY ordinal_position;

-- 2. VERIFICAR SE A TABELA EXISTE E ESTÁ ACESSÍVEL
SELECT COUNT(*) as total_loans FROM loans;

-- 3. VERIFICAR CLIENTES E USUÁRIOS DISPONÍVEIS
SELECT 'CLIENTES DISPONÍVEIS:' as info;
SELECT id, name FROM clients LIMIT 3;

SELECT 'USUÁRIOS DISPONÍVEIS:' as info;
SELECT id, email FROM users LIMIT 3;

-- 4. TENTAR INSERÇÃO MANUAL SIMPLES
-- (Descomente e substitua os UUIDs pelos valores reais)
/*
INSERT INTO loans (
    client_id,
    amount,
    interest_rate,
    loan_date,
    due_date,
    created_by
) VALUES (
    (SELECT id FROM clients LIMIT 1),  -- UUID do cliente
    1000.00,                           -- valor
    5.0,                              -- taxa de juros
    '2025-08-07',                     -- data do empréstimo
    '2025-09-07',                     -- data de vencimento
    (SELECT id FROM users LIMIT 1)    -- UUID do usuário
);

-- Verificar se foi inserido
SELECT * FROM loans WHERE amount = 1000.00 ORDER BY created_at DESC LIMIT 1;
*/

-- 5. VERIFICAR POLÍTICAS RLS QUE PODEM ESTAR BLOQUEANDO
SELECT 
    'POLÍTICAS RLS:' as info,
    policyname,
    cmd,
    roles,
    qual
FROM pg_policies 
WHERE tablename = 'loans';

SELECT 'Diagnóstico da tabela loans concluído!' as resultado;