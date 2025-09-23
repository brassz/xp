-- =====================================================
-- ADICIONAR USUÁRIO BRUNA@NEXUS.COM
-- =====================================================
-- Execute este script no SQL Editor do Supabase para 
-- adicionar o usuário bruna@nexus.com
-- =====================================================

-- Verificar se o usuário já existe
DO $$
BEGIN
    -- Tentar inserir o usuário bruna@nexus.com se não existir
    INSERT INTO users (email, password_hash, full_name, role, is_active)
    VALUES (
        'bruna@nexus.com',
        '1020', -- Mesma senha simples para demonstração
        'Bruna Nexus',
        'user', -- Role de usuário normal (não admin)
        true
    )
    ON CONFLICT (email) DO UPDATE SET
        is_active = true,
        updated_at = NOW();
    
    RAISE NOTICE 'Usuário bruna@nexus.com foi criado/atualizado com sucesso';
END $$;

-- Verificar usuários existentes
SELECT 
    id,
    email, 
    full_name, 
    role, 
    is_active,
    created_at
FROM users 
WHERE email IN ('admin@nexus.com', 'bruna@nexus.com', 'douglas@nexus.com')
ORDER BY email;

-- =====================================================
-- INSTRUÇÕES
-- =====================================================
-- 
-- Após executar este script:
-- 1. O usuário bruna@nexus.com será criado com role 'user'
-- 2. Ela poderá fazer login com senha '1020'
-- 3. Ela só verá suas próprias despesas
-- 4. O admin@nexus.com poderá ver todas as despesas (incluindo as da bruna)
--
-- =====================================================