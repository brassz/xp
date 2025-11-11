-- =====================================================
-- TROCAR SENHA DO USUÁRIO ADMIN VINICIUS@NEXUS.COM
-- =====================================================
-- Execute este script no SQL Editor do Supabase para 
-- atualizar a senha do usuário vinicius@nexus.com
-- =====================================================

DO $$
BEGIN
    -- Verificar se o usuário existe
    IF EXISTS (SELECT 1 FROM users WHERE email = 'vinicius@nexus.com') THEN
        -- Atualizar senha do usuário existente
        UPDATE users 
        SET 
            password_hash = '36996352123',
            updated_at = NOW()
        WHERE email = 'vinicius@nexus.com';
        
        RAISE NOTICE 'Senha do usuário vinicius@nexus.com atualizada com sucesso!';
    ELSE
        -- Criar usuário se não existir com role admin
        INSERT INTO users (email, password_hash, full_name, role, is_active)
        VALUES (
            'vinicius@nexus.com',
            '36996352123',
            'Vinicius Admin',
            'admin',
            true
        );
        
        RAISE NOTICE 'Usuário vinicius@nexus.com criado com sucesso!';
    END IF;
END $$;

-- Verificar usuário atualizado
SELECT 
    id,
    email, 
    full_name, 
    role, 
    is_active,
    created_at,
    updated_at
FROM users 
WHERE email = 'vinicius@nexus.com';

-- =====================================================
-- INFORMAÇÕES DE LOGIN
-- =====================================================
SELECT 
    'Login atualizado com sucesso!' as status,
    'vinicius@nexus.com' as email,
    '36996352123' as senha,
    'admin' as role
;

-- =====================================================
-- INSTRUÇÕES
-- =====================================================
-- 
-- Após executar este script:
-- 1. O usuário vinicius@nexus.com terá a senha alterada para '36996352123'
-- 2. Se o usuário não existir, será criado com role 'admin'
-- 3. O usuário poderá fazer login com as novas credenciais
-- 4. Como admin, terá acesso total ao sistema
--
-- =====================================================
