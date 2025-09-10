-- =====================================================
-- FIX: Resolver violação de constraint entre users e clients
-- =====================================================
-- Erro: update or delete on table "users" violates foreign key constraint "clients_created_by_fkey"
-- Este script oferece diferentes opções para resolver o problema
-- =====================================================

-- PASSO 1: Identificar os registros que estão causando o problema
SELECT 'Clientes criados pelo usuário que está causando o erro:' as info;

SELECT 
    c.id,
    c.name,
    c.cpf,
    c.email,
    c.created_by,
    c.created_at,
    u.full_name as created_by_name,
    u.email as created_by_email
FROM clients c
JOIN users u ON c.created_by = u.id
WHERE c.created_by = '6f7e6ef3-c485-4c1a-b33e-d4181de02d0b';

-- PASSO 2: Contar quantos registros são afetados
SELECT 
    COUNT(*) as total_clients_affected,
    'registros de clientes que referenciam este usuário' as description
FROM clients 
WHERE created_by = '6f7e6ef3-c485-4c1a-b33e-d4181de02d0b';

-- =====================================================
-- OPÇÕES DE SOLUÇÃO
-- =====================================================

-- OPÇÃO 1: Transferir a propriedade dos clientes para outro usuário
-- (Substitua 'NOVO_USER_ID' pelo ID do usuário que deve assumir os clientes)
/*
DO $$
DECLARE
    novo_usuario_id UUID := 'NOVO_USER_ID'; -- Substitua pelo ID do novo usuário
    registros_afetados INT;
BEGIN
    -- Verificar se o novo usuário existe
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = novo_usuario_id) THEN
        RAISE EXCEPTION 'Usuário de destino não encontrado: %', novo_usuario_id;
    END IF;
    
    -- Transferir os clientes
    UPDATE clients 
    SET created_by = novo_usuario_id,
        updated_at = NOW()
    WHERE created_by = '6f7e6ef3-c485-4c1a-b33e-d4181de02d0b';
    
    GET DIAGNOSTICS registros_afetados = ROW_COUNT;
    RAISE NOTICE 'Transferidos % clientes para o novo usuário', registros_afetados;
END $$;
*/

-- OPÇÃO 2: Definir created_by como NULL (permitir valores nulos)
-- Primeiro, alterar a constraint para permitir NULL
/*
ALTER TABLE clients ALTER COLUMN created_by DROP NOT NULL;

-- Depois, definir como NULL os registros problemáticos
UPDATE clients 
SET created_by = NULL,
    updated_at = NOW()
WHERE created_by = '6f7e6ef3-c485-4c1a-b33e-d4181de02d0b';
*/

-- OPÇÃO 3: Excluir os registros de clientes (CUIDADO: PERDA DE DADOS)
-- Use apenas se os registros não são importantes
/*
DELETE FROM clients 
WHERE created_by = '6f7e6ef3-c485-4c1a-b33e-d4181de02d0b';
*/

-- OPÇÃO 4: Modificar a constraint para CASCADE (exclusão em cascata)
-- Isso fará com que os clientes sejam excluídos automaticamente quando o usuário for excluído
/*
-- Primeiro, remover a constraint atual
ALTER TABLE clients DROP CONSTRAINT IF EXISTS clients_created_by_fkey;

-- Recriar com ON DELETE CASCADE
ALTER TABLE clients 
ADD CONSTRAINT clients_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE;
*/

-- OPÇÃO 5: Modificar a constraint para SET NULL
-- Isso fará com que o campo created_by seja definido como NULL quando o usuário for excluído
/*
-- Primeiro, permitir NULL na coluna
ALTER TABLE clients ALTER COLUMN created_by DROP NOT NULL;

-- Remover a constraint atual
ALTER TABLE clients DROP CONSTRAINT IF EXISTS clients_created_by_fkey;

-- Recriar com ON DELETE SET NULL
ALTER TABLE clients 
ADD CONSTRAINT clients_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL;
*/

-- =====================================================
-- SCRIPT PARA APLICAR A SOLUÇÃO RECOMENDADA (OPÇÃO 5)
-- =====================================================
-- Esta é geralmente a melhor opção pois preserva os dados dos clientes
-- mas remove a referência quando o usuário é excluído

DO $$
BEGIN
    -- Verificar se a constraint existe
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'clients_created_by_fkey'
        AND table_name = 'clients'
    ) THEN
        -- Permitir NULL na coluna created_by
        ALTER TABLE clients ALTER COLUMN created_by DROP NOT NULL;
        
        -- Remover a constraint atual
        ALTER TABLE clients DROP CONSTRAINT clients_created_by_fkey;
        
        -- Recriar com ON DELETE SET NULL
        ALTER TABLE clients 
        ADD CONSTRAINT clients_created_by_fkey 
        FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL;
        
        RAISE NOTICE 'Constraint atualizada com sucesso - agora permite ON DELETE SET NULL';
    ELSE
        RAISE NOTICE 'Constraint clients_created_by_fkey não encontrada';
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Erro ao atualizar constraint: %', SQLERRM;
END $$;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar a nova constraint
SELECT 
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    rc.delete_rule
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
LEFT JOIN information_schema.referential_constraints AS rc
    ON tc.constraint_name = rc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_name = 'clients'
AND tc.constraint_name = 'clients_created_by_fkey';

-- Testar se agora é possível excluir o usuário (remova os comentários para testar)
/*
DELETE FROM users WHERE id = '6f7e6ef3-c485-4c1a-b33e-d4181de02d0b';
*/

-- =====================================================
-- INSTRUÇÕES DE USO
-- =====================================================
-- 
-- 1. Execute primeiro a consulta do PASSO 1 para ver quais clientes serão afetados
-- 2. Escolha uma das opções de solução baseada na sua necessidade:
--    - OPÇÃO 1: Se quiser transferir os clientes para outro usuário
--    - OPÇÃO 2: Se quiser apenas definir created_by como NULL
--    - OPÇÃO 3: Se quiser excluir os clientes (CUIDADO!)
--    - OPÇÃO 4: Se quiser exclusão em cascata (exclui clientes automaticamente)
--    - OPÇÃO 5: Se quiser que o campo seja definido como NULL automaticamente (RECOMENDADO)
-- 3. Descomente e execute a opção escolhida
-- 4. Execute a verificação final
-- 5. Tente novamente a operação que estava falhando
-- 
-- RECOMENDAÇÃO: Use a OPÇÃO 5 (já aplicada automaticamente neste script)
-- pois preserva os dados dos clientes mas resolve a constraint violation
-- =====================================================