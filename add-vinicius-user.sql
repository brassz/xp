-- =====================================================
-- ADICIONAR USUÁRIO VINICIUS@NEXUS.COM PARA AS 3 EMPRESAS
-- =====================================================
-- Execute este script no SQL Editor do Supabase para 
-- cada uma das 3 empresas separadamente
-- =====================================================

-- =====================================================
-- SCRIPT PARA EMPRESA 1 - NEXUS (Principal)
-- URL: https://mhtxyxizfnxupwmilith.supabase.co
-- =====================================================

-- Inserir usuário vinicius@nexus.com na EMPRESA 1
INSERT INTO users (email, password_hash, full_name, role, is_active)
VALUES (
    'vinicius@nexus.com',
    '1020',
    'Vinicius Nexus',
    'user',
    true
)
ON CONFLICT (email) DO UPDATE SET
    is_active = true,
    updated_at = NOW();

-- Verificar se o usuário foi criado
SELECT 
    id,
    email, 
    full_name, 
    role, 
    is_active,
    created_at
FROM users 
WHERE email = 'vinicius@nexus.com';

-- =====================================================
-- SCRIPT PARA EMPRESA 2 - LITORAL CRED
-- URL: https://dtifsfzmnjnllzzlndxv.supabase.co
-- =====================================================

-- Inserir usuário vinicius@nexus.com na EMPRESA 2
INSERT INTO users (email, password_hash, full_name, role, is_active)
VALUES (
    'vinicius@nexus.com',
    '1020',
    'Vinicius Litoral Cred',
    'user',
    true
)
ON CONFLICT (email) DO UPDATE SET
    is_active = true,
    updated_at = NOW();

-- Verificar se o usuário foi criado
SELECT 
    id,
    email, 
    full_name, 
    role, 
    is_active,
    created_at
FROM users 
WHERE email = 'vinicius@nexus.com';

-- =====================================================
-- SCRIPT PARA EMPRESA 3 - MOGIANA CRED
-- URL: https://eemfnpefgojllvzzaimu.supabase.co
-- =====================================================

-- Inserir usuário vinicius@nexus.com na EMPRESA 3
INSERT INTO users (email, password_hash, full_name, role, is_active)
VALUES (
    'vinicius@nexus.com',
    '1020',
    'Vinicius Mogiana Cred',
    'user',
    true
)
ON CONFLICT (email) DO UPDATE SET
    is_active = true,
    updated_at = NOW();

-- Verificar se o usuário foi criado
SELECT 
    id,
    email, 
    full_name, 
    role, 
    is_active,
    created_at
FROM users 
WHERE email = 'vinicius@nexus.com';

-- =====================================================
-- INSTRUÇÕES DE EXECUÇÃO
-- =====================================================
-- 
-- Para adicionar o usuário vinicius@nexus.com nas 3 empresas:
-- 
-- 1. EMPRESA 1 - NEXUS (Principal):
--    - Acesse: https://supabase.com/dashboard/project/mhtxyxizfnxupwmilith/sql/new
--    - Cole e execute a seção da EMPRESA 1
-- 
-- 2. EMPRESA 2 - LITORAL CRED:
--    - Acesse: https://supabase.com/dashboard/project/dtifsfzmnjnllzzlndxv/sql/new
--    - Cole e execute a seção da EMPRESA 2
-- 
-- 3. EMPRESA 3 - MOGIANA CRED:
--    - Acesse: https://supabase.com/dashboard/project/eemfnpefgojllvzzaimu/sql/new
--    - Cole e execute a seção da EMPRESA 3
-- 
-- OU execute cada seção separadamente no SQL Editor de cada empresa.
-- 
-- Após a execução:
-- - O usuário vinicius@nexus.com poderá fazer login em qualquer uma das 3 empresas
-- - Senha: 1020
-- - Role: user (usuário normal)
-- - Status: ativo
-- 
-- =====================================================
-- RESUMO DAS EMPRESAS
-- =====================================================
-- 
-- EMPRESA 1 - NEXUS (Principal)
-- - Nome: NEXUS
-- - URL: https://mhtxyxizfnxupwmilith.supabase.co
-- - Usuário: vinicius@nexus.com
-- - Nome completo: Vinicius Nexus
-- 
-- EMPRESA 2 - LITORAL CRED
-- - Nome: LITORAL CRED
-- - URL: https://dtifsfzmnjnllzzlndxv.supabase.co
-- - Usuário: vinicius@nexus.com
-- - Nome completo: Vinicius Litoral Cred
-- 
-- EMPRESA 3 - MOGIANA CRED
-- - Nome: MOGIANA CRED
-- - URL: https://eemfnpefgojllvzzaimu.supabase.co
-- - Usuário: vinicius@nexus.com
-- - Nome completo: Vinicius Mogiana Cred
-- 
-- =====================================================