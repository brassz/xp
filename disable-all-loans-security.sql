-- Script para desabilitar COMPLETAMENTE toda segurança da tabela loans
-- Execute este script no Supabase SQL Editor

-- 1. DESABILITAR RLS COMPLETAMENTE
ALTER TABLE loans DISABLE ROW LEVEL SECURITY;

-- 2. REMOVER TODAS AS POLÍTICAS RLS
DO $$
DECLARE
    policy_record RECORD;
BEGIN
    FOR policy_record IN 
        SELECT policyname 
        FROM pg_policies 
        WHERE tablename = 'loans'
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || policy_record.policyname || ' ON loans';
        RAISE NOTICE 'Removida política: %', policy_record.policyname;
    END LOOP;
END $$;

-- 3. REMOVER TODOS OS TRIGGERS
DO $$
DECLARE
    trigger_record RECORD;
BEGIN
    FOR trigger_record IN 
        SELECT trigger_name 
        FROM information_schema.triggers 
        WHERE event_object_table = 'loans'
    LOOP
        EXECUTE 'DROP TRIGGER IF EXISTS ' || trigger_record.trigger_name || ' ON loans';
        RAISE NOTICE 'Removido trigger: %', trigger_record.trigger_name;
    END LOOP;
END $$;

-- 4. REMOVER TODAS AS CONSTRAINTS DE CHECK
DO $$
DECLARE
    constraint_record RECORD;
BEGIN
    FOR constraint_record IN 
        SELECT conname 
        FROM pg_constraint 
        WHERE conrelid = 'loans'::regclass 
        AND contype = 'c'
    LOOP
        EXECUTE 'ALTER TABLE loans DROP CONSTRAINT IF EXISTS ' || constraint_record.conname;
        RAISE NOTICE 'Removida constraint: %', constraint_record.conname;
    END LOOP;
END $$;

-- 5. REMOVER TODAS AS FUNÇÕES RELACIONADAS
DROP FUNCTION IF EXISTS create_loan CASCADE;
DROP FUNCTION IF EXISTS insert_loan CASCADE;
DROP FUNCTION IF EXISTS add_loan CASCADE;
DROP FUNCTION IF EXISTS update_loan CASCADE;
DROP FUNCTION IF EXISTS handle_loan CASCADE;

-- 6. VERIFICAR SE TUDO FOI REMOVIDO
SELECT 'VERIFICAÇÃO FINAL:' as info;

SELECT 'RLS Status:' as tipo, 
       CASE WHEN rowsecurity THEN 'HABILITADO' ELSE 'DESABILITADO' END as status
FROM pg_tables 
WHERE tablename = 'loans';

SELECT 'Políticas restantes:' as tipo, COUNT(*) as quantidade
FROM pg_policies 
WHERE tablename = 'loans';

SELECT 'Triggers restantes:' as tipo, COUNT(*) as quantidade
FROM information_schema.triggers 
WHERE event_object_table = 'loans';

SELECT 'Constraints CHECK restantes:' as tipo, COUNT(*) as quantidade
FROM pg_constraint 
WHERE conrelid = 'loans'::regclass 
AND contype = 'c';

-- 7. TESTAR INSERÇÃO DIRETA
SELECT 'TESTE DE INSERÇÃO:' as info;

-- Verificar clientes e usuários disponíveis
SELECT 'Clientes disponíveis:' as info, id, name FROM clients LIMIT 1;
SELECT 'Usuários disponíveis:' as info, id, email FROM users LIMIT 1;

-- TESTE FINAL (descomente para executar)
/*
INSERT INTO loans (client_id, amount, interest_rate, loan_date, due_date, created_by)
VALUES (
    (SELECT id FROM clients LIMIT 1),
    500.00,
    3.0,
    '2025-08-07',
    '2025-09-07',
    (SELECT id FROM users LIMIT 1)
);

SELECT 'SUCESSO! Empréstimo criado:' as resultado, * 
FROM loans 
WHERE amount = 500.00 
ORDER BY created_at DESC 
LIMIT 1;
*/

SELECT 'Script executado com sucesso! Tabela loans está completamente "nua".' as resultado;