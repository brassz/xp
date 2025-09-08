-- Script para verificar e corrigir a constraint de status na tabela loans
-- Execute este script no Supabase SQL Editor

-- 1. Verificar a constraint atual
SELECT 
    conname AS constraint_name,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint 
WHERE conrelid = 'loans'::regclass 
AND contype = 'c'
AND conname LIKE '%status%';

-- 2. Verificar todos os valores de status existentes na tabela
SELECT DISTINCT status, COUNT(*) as count
FROM loans
GROUP BY status
ORDER BY status;

-- 3. Se necessário, remover a constraint antiga e criar uma nova
-- (Execute apenas se a constraint estiver com problema)

-- Remover constraint antiga se existir
ALTER TABLE loans DROP CONSTRAINT IF EXISTS loans_status_check;

-- Criar nova constraint com os valores corretos
ALTER TABLE loans 
ADD CONSTRAINT loans_status_check 
CHECK (status IN ('active', 'overdue', 'paid', 'partial_paid', 'cancelled'));

-- 4. Verificar se a constraint foi criada corretamente
SELECT 
    conname AS constraint_name,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint 
WHERE conrelid = 'loans'::regclass 
AND contype = 'c'
AND conname = 'loans_status_check';

-- 5. Testar inserção com status 'active'
-- (Descomente para testar, mas substitua pelos valores reais)
/*
INSERT INTO loans (client_id, amount, interest_rate, loan_date, due_date, status, created_by)
VALUES (
    'uuid-do-cliente-existente',  -- Substitua por um UUID real
    1000.00,
    5.0,
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '30 days',
    'active',
    'uuid-do-usuario-logado'  -- Substitua por um UUID real
);
*/