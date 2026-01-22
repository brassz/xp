-- =====================================================
-- CONFIGURAÇÃO DE ACESSO LIMITADO PARA USUÁRIOS
-- =====================================================
-- Este script atualiza a tabela de usuários para suportar
-- o role 'limited' que permite acesso apenas às abas de
-- Empréstimos e Parcelamento
-- =====================================================

-- Atualizar constraint da coluna role para incluir 'limited' e 'viewer'
ALTER TABLE users 
DROP CONSTRAINT IF EXISTS users_role_check;

ALTER TABLE users 
ADD CONSTRAINT users_role_check 
CHECK (role IN ('admin', 'user', 'manager', 'limited', 'viewer'));

-- Comentário atualizado
COMMENT ON COLUMN users.role IS 'Papel do usuário no sistema (admin, user, manager, limited, viewer). Usuários com role "limited" ou "viewer" têm acesso apenas às abas de Empréstimos e Parcelamento.';

-- Exemplo: Criar um usuário com acesso limitado
-- Descomente e ajuste os valores conforme necessário:
/*
INSERT INTO users (email, password_hash, full_name, role, is_active)
VALUES (
    'usuario.limitado@exemplo.com',
    'senha123', -- IMPORTANTE: Em produção, use hash de senha (bcrypt)
    'Usuário com Acesso Limitado',
    'limited',
    true
);
*/

-- Exemplo: Atualizar um usuário existente para ter acesso limitado
-- Descomente e ajuste o email conforme necessário:
/*
UPDATE users 
SET role = 'limited'
WHERE email = 'usuario.existente@exemplo.com';
*/

-- Verificar usuários com acesso limitado
SELECT 
    id,
    email,
    full_name,
    role,
    is_active,
    last_login,
    created_at
FROM users
WHERE role IN ('limited', 'viewer')
ORDER BY created_at DESC;

