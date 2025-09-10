-- =====================================================
-- CORREÇÃO DA COLUNA DE DATA NA TABELA EXPENSES
-- =====================================================
-- Este script corrige o nome da coluna de data na tabela expenses
-- de 'expense_date' para 'date' para compatibilidade com a aplicação
-- =====================================================

-- Verificar se a coluna expense_date existe
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'expenses' 
        AND column_name = 'expense_date'
        AND table_schema = 'public'
    ) THEN
        -- Renomear a coluna de expense_date para date
        ALTER TABLE expenses RENAME COLUMN expense_date TO date;
        RAISE NOTICE 'Coluna expense_date renomeada para date com sucesso';
        
        -- Atualizar o índice se existir
        IF EXISTS (
            SELECT 1 
            FROM pg_indexes 
            WHERE tablename = 'expenses' 
            AND indexname = 'idx_expenses_expense_date'
        ) THEN
            DROP INDEX IF EXISTS idx_expenses_expense_date;
            CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date);
            RAISE NOTICE 'Índice atualizado de idx_expenses_expense_date para idx_expenses_date';
        END IF;
        
    ELSIF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'expenses' 
        AND column_name = 'date'
        AND table_schema = 'public'
    ) THEN
        RAISE NOTICE 'Coluna date já existe na tabela expenses. Nenhuma alteração necessária.';
    ELSE
        RAISE EXCEPTION 'Nem expense_date nem date foram encontradas na tabela expenses. Verifique a estrutura da tabela.';
    END IF;
END $$;

-- Verificar a estrutura final da tabela
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'expenses' 
AND column_name IN ('date', 'expense_date')
ORDER BY column_name;

-- =====================================================
-- INSTRUÇÕES DE USO
-- =====================================================
-- 
-- 1. Execute este script no SQL Editor do Supabase
-- 2. Verifique se não há erros na execução
-- 3. Confirme que a coluna foi renomeada corretamente
-- 4. Teste o carregamento de despesas no aplicativo
--
-- NOTA: Este script é seguro para executar múltiplas vezes
-- pois verifica a existência das colunas antes de fazer alterações
-- 
-- =====================================================