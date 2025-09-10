-- =====================================================
-- SOLUÇÃO PARA ERRO DE CONSTRAINT created_by_fkey
-- =====================================================
-- Este script corrige os erros:
-- - "insert or update on table "clients" violates foreign key constraint "clients_created_by_fkey""
-- - "insert or update on table "loans" violates foreign key constraint "loans_created_by_fkey""
-- =====================================================

-- 1. Verificar usuários existentes
SELECT 'Usuários existentes:' as info;
SELECT id, email, full_name, role, is_active FROM users ORDER BY created_at;

-- 2. Criar usuário admin padrão se não existir
INSERT INTO users (id, email, password_hash, full_name, role, is_active, created_at, updated_at)
VALUES (
    '00000000-0000-0000-0000-000000000001'::uuid,
    'admin@nexus.com',
    '1020',
    'Administrador Nexus',
    'admin',
    true,
    NOW(),
    NOW()
)
ON CONFLICT (email) DO UPDATE SET
    id = EXCLUDED.id,
    password_hash = EXCLUDED.password_hash,
    full_name = EXCLUDED.full_name,
    role = EXCLUDED.role,
    is_active = EXCLUDED.is_active,
    updated_at = NOW();

-- 3. Verificar se o usuário foi criado
SELECT 'Usuário admin após inserção:' as info;
SELECT id, email, full_name, role, is_active FROM users WHERE email = 'admin@nexus.com';

-- 4. Tornar o campo created_by opcional temporariamente (se necessário)
-- Verificar se existem registros com created_by NULL
SELECT 'Clientes com created_by NULL:' as info;
SELECT COUNT(*) as count FROM clients WHERE created_by IS NULL;

SELECT 'Empréstimos com created_by NULL:' as info;
SELECT COUNT(*) as count FROM loans WHERE created_by IS NULL;

-- 5. Atualizar registros com created_by NULL para usar o admin
UPDATE clients 
SET created_by = '00000000-0000-0000-0000-000000000001'::uuid
WHERE created_by IS NULL;

UPDATE loans 
SET created_by = '00000000-0000-0000-0000-000000000001'::uuid
WHERE created_by IS NULL;

-- 6. Verificar se ainda há registros problemáticos
SELECT 'Verificação final - Clientes:' as info;
SELECT COUNT(*) as total_clients, 
       COUNT(created_by) as clients_with_created_by,
       COUNT(*) - COUNT(created_by) as clients_without_created_by
FROM clients;

SELECT 'Verificação final - Empréstimos:' as info;
SELECT COUNT(*) as total_loans, 
       COUNT(created_by) as loans_with_created_by,
       COUNT(*) - COUNT(created_by) as loans_without_created_by
FROM loans;

-- 7. Verificar se todas as referências de created_by existem na tabela users
SELECT 'Clientes com created_by inválido:' as info;
SELECT c.id, c.name, c.created_by
FROM clients c
LEFT JOIN users u ON c.created_by = u.id
WHERE c.created_by IS NOT NULL AND u.id IS NULL;

SELECT 'Empréstimos com created_by inválido:' as info;
SELECT l.id, l.client_id, l.created_by
FROM loans l
LEFT JOIN users u ON l.created_by = u.id
WHERE l.created_by IS NOT NULL AND u.id IS NULL;

-- 8. Corrigir referências inválidas
UPDATE clients 
SET created_by = '00000000-0000-0000-0000-000000000001'::uuid
WHERE created_by IS NOT NULL 
AND NOT EXISTS (SELECT 1 FROM users WHERE id = clients.created_by);

UPDATE loans 
SET created_by = '00000000-0000-0000-0000-000000000001'::uuid
WHERE created_by IS NOT NULL 
AND NOT EXISTS (SELECT 1 FROM users WHERE id = loans.created_by);

-- 9. Verificação final
SELECT 'Status final:' as info;
SELECT 
    'Todos os registros agora têm created_by válido' as message,
    (SELECT COUNT(*) FROM clients WHERE created_by IS NOT NULL) as clients_with_valid_created_by,
    (SELECT COUNT(*) FROM loans WHERE created_by IS NOT NULL) as loans_with_valid_created_by;

-- 10. Mostrar o ID do usuário admin para usar no JavaScript
SELECT 'ID do usuário admin para usar no código:' as info;
SELECT id as admin_user_id FROM users WHERE email = 'admin@nexus.com';

COMMIT;