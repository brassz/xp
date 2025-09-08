-- Script para diagnosticar e corrigir a constraint de status na tabela loans
-- Execute este script no Supabase SQL Editor

-- 1. DIAGNÓSTICO COMPLETO
-- Verificar se a tabela loans existe
SELECT 
    schemaname, 
    tablename, 
    tableowner 
FROM pg_tables 
WHERE tablename = 'loans';

-- 2. Verificar TODAS as constraints da tabela loans
SELECT 
    conname AS constraint_name,
    contype AS constraint_type,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint 
WHERE conrelid = 'loans'::regclass 
ORDER BY conname;

-- 3. Verificar especificamente constraints de CHECK
SELECT 
    conname AS constraint_name,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint 
WHERE conrelid = 'loans'::regclass 
AND contype = 'c';

-- 4. Verificar estrutura da coluna status
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'loans' 
AND column_name = 'status';

-- 5. Verificar valores existentes na tabela (se houver dados)
SELECT DISTINCT status, COUNT(*) as count
FROM loans
GROUP BY status
ORDER BY status;

-- 6. CORREÇÃO - Execute apenas se necessário
-- Primeiro, vamos remover TODAS as constraints de status que possam existir
DO $$
DECLARE
    constraint_record RECORD;
BEGIN
    FOR constraint_record IN 
        SELECT conname 
        FROM pg_constraint 
        WHERE conrelid = 'loans'::regclass 
        AND contype = 'c'
        AND pg_get_constraintdef(oid) LIKE '%status%'
    LOOP
        EXECUTE 'ALTER TABLE loans DROP CONSTRAINT IF EXISTS ' || constraint_record.conname;
        RAISE NOTICE 'Removida constraint: %', constraint_record.conname;
    END LOOP;
END $$;

-- 7. Criar nova constraint limpa
ALTER TABLE loans 
ADD CONSTRAINT loans_status_check 
CHECK (status IN ('active', 'overdue', 'paid', 'partial_paid', 'cancelled'));

-- 8. Verificar se a nova constraint foi criada
SELECT 
    conname AS constraint_name,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint 
WHERE conrelid = 'loans'::regclass 
AND contype = 'c'
AND conname = 'loans_status_check';

-- 9. Testar se 'active' é aceito
-- (Este SELECT deve retornar TRUE se a constraint estiver funcionando)
SELECT 
    'active' IN ('active', 'overdue', 'paid', 'partial_paid', 'cancelled') AS status_active_valid,
    'invalid' IN ('active', 'overdue', 'paid', 'partial_paid', 'cancelled') AS status_invalid_valid;

-- 10. TESTE FINAL - Tentar inserção de teste (descomente se necessário)
/*
-- Primeiro, vamos buscar um client_id e user_id válidos
SELECT 'Clientes disponíveis:' as info;
SELECT id, name FROM clients LIMIT 5;

SELECT 'Usuários disponíveis:' as info;
SELECT id, email FROM users LIMIT 5;

-- Exemplo de inserção (substitua os UUIDs pelos valores reais)
INSERT INTO loans (client_id, amount, interest_rate, loan_date, due_date, status, created_by)
VALUES (
    (SELECT id FROM clients LIMIT 1),  -- Pega o primeiro cliente
    100.00,
    5.0,
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '30 days',
    'active',
    (SELECT id FROM users LIMIT 1)  -- Pega o primeiro usuário
);

-- Verificar se foi inserido
SELECT * FROM loans WHERE amount = 100.00 ORDER BY created_at DESC LIMIT 1;
*/