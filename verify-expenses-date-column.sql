-- =====================================================
-- VERIFICAÇÃO E CORREÇÃO DA COLUNA DE DATA EM EXPENSES
-- =====================================================
-- Este script verifica e corrige a coluna de data na tabela expenses
-- para garantir que está usando o nome correto: 'date'
-- =====================================================

-- PASSO 1: Verificar a estrutura atual da tabela expenses
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'expenses' 
AND table_schema = 'public'
AND column_name IN ('date', 'expense_date')
ORDER BY column_name;

-- PASSO 2: Se a coluna for 'expense_date', renomeie para 'date'
DO $$ 
BEGIN
    -- Verificar se a coluna 'expense_date' existe
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'expenses' 
        AND column_name = 'expense_date'
    ) THEN
        -- Renomear a coluna
        ALTER TABLE expenses RENAME COLUMN expense_date TO date;
        RAISE NOTICE 'Coluna expense_date renomeada para date com sucesso';
    ELSIF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'expenses' 
        AND column_name = 'date'
    ) THEN
        RAISE NOTICE 'A coluna date já existe. Nenhuma alteração necessária.';
    ELSE
        RAISE EXCEPTION 'Nenhuma coluna de data encontrada na tabela expenses';
    END IF;
END $$;

-- PASSO 3: Verificar e recriar índices se necessário
DROP INDEX IF EXISTS idx_expenses_expense_date;
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date);
DROP INDEX IF EXISTS idx_expenses_user_expense_date;
CREATE INDEX IF NOT EXISTS idx_expenses_user_date ON expenses(user_id, date DESC);
DROP INDEX IF EXISTS idx_expenses_category_expense_date;
CREATE INDEX IF NOT EXISTS idx_expenses_category_date ON expenses(category_id, date DESC);

-- PASSO 4: Verificação final
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'expenses' 
AND table_schema = 'public'
AND column_name = 'date';

-- PASSO 5: Verificar os índices
SELECT 
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'expenses'
AND indexname LIKE '%date%'
ORDER BY indexname;

-- =====================================================
-- RESULTADO ESPERADO
-- =====================================================
-- A tabela expenses deve ter:
-- - Uma coluna chamada 'date' (tipo DATE)
-- - Índices corretos criados para performance
-- =====================================================
