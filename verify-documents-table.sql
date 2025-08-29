-- Script para verificar se a tabela client_documents existe e está configurada corretamente
-- Execute este script no seu banco de dados Supabase

-- 1. Verificar se a tabela existe
SELECT 
    schemaname,
    tablename,
    tableowner,
    hasindexes,
    hasrules,
    hastriggers
FROM pg_tables 
WHERE tablename = 'client_documents';

-- 2. Verificar estrutura da tabela
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'client_documents'
ORDER BY ordinal_position;

-- 3. Verificar constraints (chaves estrangeiras, checks, etc.)
SELECT
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
LEFT JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.table_name = 'client_documents';

-- 4. Verificar índices
SELECT 
    i.relname as index_name,
    a.attname as column_name
FROM pg_class t,
     pg_class i,
     pg_index ix,
     pg_attribute a
WHERE t.oid = ix.indrelid
    AND i.oid = ix.indexrelid
    AND a.attrelid = t.oid
    AND a.attnum = ANY(ix.indkey)
    AND t.relkind = 'r'
    AND t.relname = 'client_documents'
ORDER BY t.relname, i.relname;

-- 5. Verificar políticas RLS
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'client_documents';

-- 6. Verificar se RLS está habilitado
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables 
WHERE tablename = 'client_documents';

-- 7. Testar inserção de dados (remova os comentários para testar)
-- IMPORTANTE: Substitua 'SEU_CLIENT_ID_AQUI' por um ID de cliente válido

/*
-- Teste de inserção
INSERT INTO client_documents (
    client_id,
    name,
    category,
    file_path,
    file_type,
    file_size,
    notes
) VALUES (
    'SEU_CLIENT_ID_AQUI',  -- Substitua por um UUID de cliente válido
    'Documento de Teste',
    'outros',
    'https://ucarecdn.com/test-file/',
    'application/pdf',
    1024,
    'Teste de inserção'
);

-- Verificar se foi inserido
SELECT * FROM client_documents 
WHERE name = 'Documento de Teste'
ORDER BY created_at DESC 
LIMIT 1;

-- Remover teste
DELETE FROM client_documents 
WHERE name = 'Documento de Teste' 
AND notes = 'Teste de inserção';
*/

-- 8. Verificar se existem clientes para testar
SELECT 
    id,
    name,
    cpf
FROM clients 
ORDER BY created_at DESC 
LIMIT 5;

-- 9. Contar documentos existentes por cliente
SELECT 
    c.name as client_name,
    COUNT(cd.id) as document_count
FROM clients c
LEFT JOIN client_documents cd ON c.id = cd.client_id
GROUP BY c.id, c.name
HAVING COUNT(cd.id) > 0
ORDER BY document_count DESC;

-- 10. Verificar últimos documentos inseridos
SELECT 
    cd.id,
    c.name as client_name,
    cd.name as document_name,
    cd.category,
    cd.file_type,
    cd.file_size,
    cd.created_at
FROM client_documents cd
JOIN clients c ON cd.client_id = c.id
ORDER BY cd.created_at DESC
LIMIT 10;