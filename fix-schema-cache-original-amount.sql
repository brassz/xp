-- =====================================================
-- FIX: ADICIONAR COLUNA original_amount E ATUALIZAR SCHEMA CACHE
-- =====================================================
-- Este script resolve o erro: "Could not find the 'original_amount' 
-- column of 'loans' in the schema cache"
--
-- IMPORTANTE: Após executar este script, você DEVE recarregar o 
-- schema cache do Supabase!
-- =====================================================

-- 1. Adicionar coluna original_amount à tabela loans (se não existir)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'loans' 
        AND column_name = 'original_amount'
    ) THEN
        -- Adicionar a coluna como nullable primeiro
        ALTER TABLE loans ADD COLUMN original_amount DECIMAL(10,2);
        
        -- Preencher com os valores atuais de amount
        UPDATE loans SET original_amount = amount WHERE original_amount IS NULL;
        
        -- Tornar a coluna obrigatória
        ALTER TABLE loans ALTER COLUMN original_amount SET NOT NULL;
        
        RAISE NOTICE 'Coluna original_amount adicionada com sucesso!';
    ELSE
        RAISE NOTICE 'Coluna original_amount já existe!';
    END IF;
END $$;

-- 2. Adicionar comentários explicativos
COMMENT ON COLUMN loans.amount IS 'Valor atual do empréstimo (pode ser reduzido por pagamentos de capital)';
COMMENT ON COLUMN loans.original_amount IS 'Valor original do empréstimo (NUNCA deve ser alterado após criação)';

-- 3. Criar índice para melhorar performance
CREATE INDEX IF NOT EXISTS idx_loans_original_amount ON loans(original_amount);

-- 4. Verificar a estrutura da tabela
SELECT 
    column_name AS "Coluna", 
    data_type AS "Tipo", 
    is_nullable AS "Nullable",
    column_default AS "Padrão"
FROM information_schema.columns 
WHERE table_name = 'loans' 
AND column_name IN ('amount', 'original_amount', 'total_amount')
ORDER BY ordinal_position;

-- 5. Verificar dados de exemplo
SELECT 
    id,
    client_id,
    original_amount AS "Valor Original",
    amount AS "Valor Atual",
    (original_amount - amount) AS "Diferença",
    status,
    created_at
FROM loans 
ORDER BY created_at DESC 
LIMIT 5;

-- =====================================================
-- PRÓXIMOS PASSOS APÓS EXECUTAR ESTE SCRIPT:
-- =====================================================
-- 
-- 1. RECARREGAR O SCHEMA CACHE DO SUPABASE:
--    No Supabase Dashboard, vá para:
--    Settings > API > Schema Cache > Clique em "Reload schema"
--
--    OU execute via SQL:
--    NOTIFY pgrst, 'reload schema';
--
-- 2. Se o problema persistir, reinicie a API do Supabase:
--    Settings > API > clique em "Restart API"
--
-- 3. Aguarde 10-30 segundos para o cache ser atualizado
--
-- 4. Teste criar um novo empréstimo
--
-- =====================================================
