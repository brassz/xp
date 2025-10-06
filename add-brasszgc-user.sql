-- =====================================================
-- ADICIONAR USUÁRIO BRASSZGC@GMAIL.COM
-- =====================================================
-- Execute este script no SQL Editor do Supabase para 
-- adicionar o usuário brasszgc@gmail.com
-- =====================================================

-- Verificar se o usuário já existe e criar/atualizar
DO $$
BEGIN
    -- Tentar inserir o usuário brasszgc@gmail.com se não existir
    INSERT INTO users (email, password_hash, full_name, role, is_active)
    VALUES (
        'brasszgc@gmail.com',
        '1020', -- Senha simples para demonstração (em produção usar hash)
        'Bruno Assoni',
        'admin', -- Role de administrador para acesso completo
        true
    )
    ON CONFLICT (email) DO UPDATE SET
        password_hash = '1020',
        full_name = 'Bruno Assoni',
        role = 'admin',
        is_active = true,
        updated_at = NOW();
    
    RAISE NOTICE 'Usuário brasszgc@gmail.com foi criado/atualizado com sucesso';
END $$;

-- Verificar usuários existentes
SELECT 
    id,
    email, 
    full_name, 
    role, 
    is_active,
    created_at,
    last_login
FROM users 
WHERE email IN ('admin@nexus.com', 'brasszgc@gmail.com', 'douglas@nexus.com')
ORDER BY email;

-- =====================================================
-- INFORMAÇÕES DO USUÁRIO CRIADO
-- =====================================================
-- 
-- Email: brasszgc@gmail.com
-- Senha: 1020
-- Nome: Bruno Assoni
-- Role: admin (acesso completo ao sistema)
-- Status: ativo
--
-- =====================================================
-- INSTRUÇÕES DE USO
-- =====================================================
-- 
-- Após executar este script:
-- 1. O usuário brasszgc@gmail.com será criado com role 'admin'
-- 2. Poderá fazer login com senha '1020'
-- 3. Terá acesso completo a todas as funcionalidades
-- 4. Receberá os códigos de acesso quando outros usuários fizerem login
-- 5. Poderá ver todos os dados de todas as empresas
--
-- =====================================================
-- TESTE DE LOGIN
-- =====================================================
-- 
-- Para testar o login:
-- 1. Acesse o sistema
-- 2. Selecione qualquer empresa (NEXUS, LITORAL CRED, MOGIANA CRED)
-- 3. Digite: brasszgc@gmail.com
-- 4. Senha: 1020
-- 5. O sistema gerará um código de acesso
-- 6. Use qualquer um dos métodos para ver o código:
--    - Console do navegador (F12)
--    - Página /codigos.html
--    - Discord (se configurado)
--    - Painel admin na tela de código
--
-- =====================================================