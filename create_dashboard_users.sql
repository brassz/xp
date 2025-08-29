-- =====================================================
-- CRIAÇÃO DOS USUÁRIOS PARA DASHBOARD NEXUS
-- =====================================================
-- Execute estes comandos no SQL Editor do Supabase
-- =====================================================

-- Inserir usuário Douglas
INSERT INTO users (email, password_hash, full_name, role, is_active)
VALUES (
    'douglas@nexus.com',
    'Nexus2025!',
    'Douglas',
    'admin',
    true
)
ON CONFLICT (email) DO NOTHING;

-- Inserir usuário Vinicius
INSERT INTO users (email, password_hash, full_name, role, is_active)
VALUES (
    'vinicius@nexus.com',
    'Nexus2025!',
    'Vinicius',
    'admin',
    true
)
ON CONFLICT (email) DO NOTHING;

-- Verificar se os usuários foram criados com sucesso
SELECT id, email, full_name, role, is_active, created_at 
FROM users 
WHERE email IN ('douglas@nexus.com', 'vinicius@nexus.com');

-- =====================================================
-- INFORMAÇÕES IMPORTANTES:
-- =====================================================
-- Email: douglas@nexus.com | Senha: Nexus2025!
-- Email: vinicius@nexus.com | Senha: Nexus2025!
-- 
-- NOTA: O sistema atual não usa hash de senhas por segurança.
-- Recomenda-se implementar bcrypt ou similar em produção.
-- =====================================================