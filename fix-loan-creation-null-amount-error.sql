-- =====================================================
-- CORREÇÃO: ERRO DE VALOR NULL EM original_amount
-- =====================================================
-- Este script corrige o erro "null value in column original_amount 
-- of relation loans violates not-null constraint" que ocorre ao 
-- criar novos empréstimos.

-- 1. Verificar se a coluna original_amount existe
DO $$
BEGIN
    -- Verificar se a coluna original_amount existe
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'loans' 
        AND column_name = 'original_amount'
    ) THEN
        -- Adicionar a coluna original_amount se não existir
        ALTER TABLE loans ADD COLUMN original_amount DECIMAL(10,2);
        RAISE NOTICE 'Coluna original_amount adicionada à tabela loans';
    ELSE
        RAISE NOTICE 'Coluna original_amount já existe na tabela loans';
    END IF;
END $$;

-- 2. Preencher valores NULL na coluna original_amount com o valor atual de amount
-- (para empréstimos existentes que podem ter original_amount NULL)
UPDATE loans 
SET original_amount = amount 
WHERE original_amount IS NULL;

-- 3. Tornar a coluna obrigatória (NOT NULL)
ALTER TABLE loans 
ALTER COLUMN original_amount SET NOT NULL;

-- 4. Adicionar comentário explicativo
COMMENT ON COLUMN loans.original_amount IS 'Valor original do empréstimo (NUNCA deve ser alterado após criação)';

-- 5. Criar índice para melhorar performance em consultas
CREATE INDEX IF NOT EXISTS idx_loans_original_amount ON loans(original_amount);

-- 6. Verificar a estrutura final da tabela
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default,
    col_description(pgc.oid, a.attnum) as comment
FROM information_schema.columns a
JOIN pg_class pgc ON pgc.relname = a.table_name
WHERE a.table_name = 'loans' 
AND a.column_name IN ('amount', 'original_amount')
ORDER BY a.column_name;

-- 7. Mostrar estatísticas dos empréstimos após a correção
SELECT 
    COUNT(*) as total_loans,
    COUNT(CASE WHEN original_amount IS NOT NULL THEN 1 END) as loans_with_original_amount,
    COUNT(CASE WHEN original_amount IS NULL THEN 1 END) as loans_without_original_amount
FROM loans;

RAISE NOTICE 'Correção do erro original_amount concluída com sucesso!';
RAISE NOTICE 'Agora novos empréstimos podem ser criados normalmente.';