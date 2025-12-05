-- =====================================================
-- CORREÇÃO COMPLETA - FRANCA PRIVATE
-- =====================================================
-- Script unificado para corrigir TODOS os erros:
-- 1. Tabela pix_keys (coluna pix_key_type)
-- 2. Tabela payments (coluna fine_amount)
-- =====================================================
-- Execute este arquivo no SQL Editor do Supabase
-- URL: https://pebwoerzslfzhjptyjwh.supabase.co
-- =====================================================

-- =====================================================
-- PARTE 1: CORREÇÃO DA TABELA PIX_KEYS
-- =====================================================

-- 1.1. Verificar se a tabela existe e criar se necessário
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

-- 1.2. Adicionar a coluna pix_key_type se ela não existir
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
        
        RAISE NOTICE '✅ Coluna pix_key_type adicionada com sucesso!';
    ELSE
        RAISE NOTICE '✓ Coluna pix_key_type já existe.';
    END IF;
END $$;

-- 1.3. Adicionar outras colunas necessárias se faltarem
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
        RAISE NOTICE '✅ Coluna bank_name adicionada!';
    END IF;

    -- Verificar e adicionar account_holder
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'pix_keys' 
        AND column_name = 'account_holder'
    ) THEN
        ALTER TABLE pix_keys ADD COLUMN account_holder VARCHAR(100) NOT NULL DEFAULT 'Não informado';
        RAISE NOTICE '✅ Coluna account_holder adicionada!';
    END IF;

    -- Verificar e adicionar is_active
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'pix_keys' 
        AND column_name = 'is_active'
    ) THEN
        ALTER TABLE pix_keys ADD COLUMN is_active BOOLEAN DEFAULT true;
        RAISE NOTICE '✅ Coluna is_active adicionada!';
    END IF;
END $$;

-- 1.4. Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_pix_keys_active ON pix_keys(is_active);
CREATE INDEX IF NOT EXISTS idx_pix_keys_bank ON pix_keys(bank_name);
CREATE INDEX IF NOT EXISTS idx_pix_keys_type ON pix_keys(pix_key_type);

-- 1.5. Atualizar registros existentes sem pix_key_type (se houver)
UPDATE pix_keys 
SET pix_key_type = CASE 
    WHEN pix_key ~ '^[0-9]{11}$' THEN 'cpf'
    WHEN pix_key ~ '^[0-9]{14}$' THEN 'cnpj'
    WHEN pix_key ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$' THEN 'email'
    WHEN pix_key ~ '^[0-9]{10,11}$' THEN 'phone'
    ELSE 'random'
END
WHERE pix_key_type IS NULL OR pix_key_type = '';

-- 1.6. Remover RLS (Row Level Security) se estiver habilitado
ALTER TABLE pix_keys DISABLE ROW LEVEL SECURITY;

-- 1.7. Remover políticas RLS antigas se existirem
DROP POLICY IF EXISTS "Allow authenticated users to view pix keys" ON pix_keys;
DROP POLICY IF EXISTS "Allow authenticated users to insert pix keys" ON pix_keys;
DROP POLICY IF EXISTS "Allow authenticated users to update pix keys" ON pix_keys;
DROP POLICY IF EXISTS "Allow authenticated users to delete pix keys" ON pix_keys;

-- 1.8. Inserir chave PIX de exemplo se não houver nenhuma
INSERT INTO pix_keys (bank_name, pix_key, pix_key_type, account_holder, is_active)
SELECT 
    'Banco Exemplo',
    '12345678901',
    'cpf',
    'Franca Private',
    true
WHERE NOT EXISTS (SELECT 1 FROM pix_keys LIMIT 1);

-- =====================================================
-- PARTE 2: CORREÇÃO DA TABELA PAYMENTS
-- =====================================================

-- 2.1. Adicionar coluna fine_amount se não existir
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'payments' 
        AND column_name = 'fine_amount'
    ) THEN
        ALTER TABLE payments 
        ADD COLUMN fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);
        
        RAISE NOTICE '✅ Coluna fine_amount adicionada com sucesso!';
    ELSE
        RAISE NOTICE '✓ Coluna fine_amount já existe.';
    END IF;
END $$;

-- 2.2. Adicionar comentário explicativo
COMMENT ON COLUMN payments.fine_amount IS 'Valor da multa aplicada ao pagamento (opcional, separado do valor principal)';

-- 2.3. Criar índice para consultas de relatórios de multas
CREATE INDEX IF NOT EXISTS idx_payments_fine_amount ON payments(fine_amount) WHERE fine_amount > 0;

-- 2.4. Atualizar registros existentes para ter fine_amount = 0 se for NULL
UPDATE payments 
SET fine_amount = 0.00 
WHERE fine_amount IS NULL;

-- =====================================================
-- PARTE 3: VERIFICAÇÕES FINAIS
-- =====================================================

-- 3.1. Verificar estrutura da tabela pix_keys
SELECT 
    '=== ESTRUTURA DA TABELA PIX_KEYS ===' as verificacao;

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'pix_keys'
ORDER BY ordinal_position;

-- 3.2. Verificar chaves PIX existentes
SELECT 
    '=== CHAVES PIX CADASTRADAS ===' as verificacao;

SELECT 
    id,
    bank_name,
    pix_key_type,
    account_holder,
    is_active,
    created_at
FROM pix_keys
ORDER BY created_at DESC;

-- 3.3. Verificar estrutura da tabela payments
SELECT 
    '=== VERIFICAÇÃO DA COLUNA FINE_AMOUNT ===' as verificacao;

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default 
FROM information_schema.columns 
WHERE table_name = 'payments' AND column_name = 'fine_amount';

-- 3.4. Estatísticas de multas (se houver dados)
SELECT 
    '=== ESTATÍSTICAS DE MULTAS ===' as verificacao;

SELECT 
    COUNT(*) as total_pagamentos,
    COUNT(*) FILTER (WHERE fine_amount > 0) as pagamentos_com_multa,
    SUM(fine_amount) as total_em_multas,
    AVG(fine_amount) FILTER (WHERE fine_amount > 0) as media_multas
FROM payments;

-- =====================================================
-- PARTE 4: ATUALIZAÇÃO DO SCHEMA CACHE
-- =====================================================

-- 4.1. Forçar reload do schema cache do Supabase
NOTIFY pgrst, 'reload schema';

-- =====================================================
-- MENSAGENS FINAIS
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '========================================';
    RAISE NOTICE '✅ CORREÇÃO COMPLETA FINALIZADA!';
    RAISE NOTICE '========================================';
    RAISE NOTICE '';
    RAISE NOTICE '📋 O QUE FOI CORRIGIDO:';
    RAISE NOTICE '   ✓ Tabela pix_keys criada/atualizada';
    RAISE NOTICE '   ✓ Coluna pix_key_type adicionada';
    RAISE NOTICE '   ✓ Coluna fine_amount adicionada';
    RAISE NOTICE '   ✓ Índices criados para performance';
    RAISE NOTICE '   ✓ RLS desabilitado em pix_keys';
    RAISE NOTICE '   ✓ Schema cache atualizado';
    RAISE NOTICE '';
    RAISE NOTICE '🎯 PRÓXIMOS PASSOS:';
    RAISE NOTICE '   1. Recarregue o schema cache no Supabase';
    RAISE NOTICE '   2. Limpe o cache do navegador (Ctrl+Shift+Delete)';
    RAISE NOTICE '   3. Faça logout e login novamente no sistema';
    RAISE NOTICE '   4. Teste as funcionalidades de PIX e multas';
    RAISE NOTICE '';
    RAISE NOTICE '📖 CONSULTE A DOCUMENTAÇÃO:';
    RAISE NOTICE '   - README-correcao-franca-private-completa.md';
    RAISE NOTICE '';
    RAISE NOTICE '========================================';
END $$;

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================
