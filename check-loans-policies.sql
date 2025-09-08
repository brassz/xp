-- Script para verificar políticas RLS e triggers na tabela loans
-- Execute este script no Supabase SQL Editor para diagnosticar

-- 1. VERIFICAR SE RLS ESTÁ HABILITADO
SELECT 
    schemaname,
    tablename,
    rowsecurity,
    forcerowsecurity
FROM pg_tables 
WHERE tablename = 'loans';

-- 2. VERIFICAR POLÍTICAS RLS
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
WHERE tablename = 'loans';

-- 3. VERIFICAR TRIGGERS
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'loans';

-- 4. VERIFICAR ÍNDICES ÚNICOS
SELECT 
    indexname,
    indexdef
FROM pg_indexes 
WHERE tablename = 'loans'
AND indexdef LIKE '%UNIQUE%';

-- 5. VERIFICAR CHAVES PRIMÁRIAS E ÚNICAS
SELECT 
    conname AS constraint_name,
    contype AS constraint_type,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint 
WHERE conrelid = 'loans'::regclass 
AND contype IN ('p', 'u');  -- primary key e unique

SELECT 'Diagnóstico completo da tabela loans concluído!' as resultado;