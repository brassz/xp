-- =====================================================
-- CORREÇÃO DA TABELA PIX_KEYS - FRANCA PRIVATE
-- =====================================================
-- Script para corrigir erros de chaves PIX
-- Execute este arquivo no SQL Editor do Supabase
-- URL: https://pebwoerzslfzhjptyjwh.supabase.co
-- =====================================================

-- 1. Verificar se a tabela existe e criar se necessário
CREATE TABLE IF NOT EXISTS pix_keys (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    bank_name VARCHAR(100) NOT NULL,
    pix_key VARCHAR(255) NOT NULL,
    pix_key_type VARCHAR(20) NOT NULL CHECK (pix_key_type IN ('cpf', 'cnpj', 'email', 'phone', 'random')),
    account_holder VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Adicionar a coluna pix_key_type se ela não existir
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'pix_keys' 
        AND column_name = 'pix_key_type'
    ) THEN
        ALTER TABLE pix_keys 
        ADD COLUMN pix_key_type VARCHAR(20) NOT NULL DEFAULT 'random' 
        CHECK (pix_key_type IN ('cpf', 'cnpj', 'email', 'phone', 'random'));
        
        RAISE NOTICE 'Coluna pix_key_type adicionada com sucesso!';
    ELSE
        RAISE NOTICE 'Coluna pix_key_type já existe.';
    END IF;
END $$;

-- 3. Adicionar outras colunas se necessário
DO $$ 
BEGIN
    -- Verificar e adicionar bank_name
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'pix_keys' 
        AND column_name = 'bank_name'
    ) THEN
        ALTER TABLE pix_keys ADD COLUMN bank_name VARCHAR(100) NOT NULL DEFAULT 'Não informado';
        RAISE NOTICE 'Coluna bank_name adicionada!';
    END IF;

    -- Verificar e adicionar account_holder
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'pix_keys' 
        AND column_name = 'account_holder'
    ) THEN
        ALTER TABLE pix_keys ADD COLUMN account_holder VARCHAR(100) NOT NULL DEFAULT 'Não informado';
        RAISE NOTICE 'Coluna account_holder adicionada!';
    END IF;

    -- Verificar e adicionar is_active
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'pix_keys' 
        AND column_name = 'is_active'
    ) THEN
        ALTER TABLE pix_keys ADD COLUMN is_active BOOLEAN DEFAULT true;
        RAISE NOTICE 'Coluna is_active adicionada!';
    END IF;
END $$;

-- 4. Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_pix_keys_active ON pix_keys(is_active);
CREATE INDEX IF NOT EXISTS idx_pix_keys_bank ON pix_keys(bank_name);
CREATE INDEX IF NOT EXISTS idx_pix_keys_type ON pix_keys(pix_key_type);

-- 5. Atualizar registros existentes sem pix_key_type (se houver)
UPDATE pix_keys 
SET pix_key_type = CASE 
    WHEN pix_key ~ '^[0-9]{11}$' THEN 'cpf'
    WHEN pix_key ~ '^[0-9]{14}$' THEN 'cnpj'
    WHEN pix_key ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$' THEN 'email'
    WHEN pix_key ~ '^[0-9]{10,11}$' THEN 'phone'
    ELSE 'random'
END
WHERE pix_key_type IS NULL OR pix_key_type = '';

-- 6. Remover RLS (Row Level Security) se estiver habilitado
ALTER TABLE pix_keys DISABLE ROW LEVEL SECURITY;

-- 7. Remover políticas RLS antigas se existirem
DROP POLICY IF EXISTS "Allow authenticated users to view pix keys" ON pix_keys;
DROP POLICY IF EXISTS "Allow authenticated users to insert pix keys" ON pix_keys;
DROP POLICY IF EXISTS "Allow authenticated users to update pix keys" ON pix_keys;
DROP POLICY IF EXISTS "Allow authenticated users to delete pix keys" ON pix_keys;

-- 8. Inserir chave PIX de exemplo se não houver nenhuma
INSERT INTO pix_keys (bank_name, pix_key, pix_key_type, account_holder, is_active)
SELECT 
    'Banco Exemplo',
    '12345678901',
    'cpf',
    'Franca Private',
    true
WHERE NOT EXISTS (SELECT 1 FROM pix_keys LIMIT 1);

-- 9. Verificar a estrutura final da tabela
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'pix_keys'
ORDER BY ordinal_position;

-- 10. Mostrar chaves PIX existentes
SELECT 
    id,
    bank_name,
    pix_key_type,
    account_holder,
    is_active,
    created_at
FROM pix_keys
ORDER BY created_at DESC;

-- =====================================================
-- IMPORTANTE: REFRESH DO SCHEMA CACHE
-- =====================================================
-- Após executar este script, é necessário atualizar
-- o cache do schema do Supabase:
--
-- 1. Vá para: Settings > API > Schema Cache
-- 2. Clique em "Reload schema"
--
-- OU execute este comando no SQL Editor:
NOTIFY pgrst, 'reload schema';

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================
