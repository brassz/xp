-- =====================================================
-- FIX: Corrigir coluna de data na tabela expenses
-- =====================================================
-- Este script corrige o problema: "column expenses.date does not exist"
-- Execução: Cole este código no SQL Editor do Supabase
-- =====================================================

-- OPÇÃO 1: Se a tabela tem a coluna 'expense_date', renomear para 'date'
DO $$
BEGIN
    -- Verificar se a coluna 'expense_date' existe
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'expenses' 
        AND column_name = 'expense_date'
        AND table_schema = 'public'
    ) THEN
        -- Renomear a coluna de 'expense_date' para 'date'
        ALTER TABLE expenses RENAME COLUMN expense_date TO date;
        RAISE NOTICE 'Coluna expense_date renomeada para date com sucesso';
        
    -- OPÇÃO 2: Se a coluna 'date' não existe, criar ela
    ELSIF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'expenses' 
        AND column_name = 'date'
        AND table_schema = 'public'
    ) THEN
        -- Adicionar a coluna 'date' se ela não existir
        ALTER TABLE expenses ADD COLUMN date DATE NOT NULL DEFAULT CURRENT_DATE;
        RAISE NOTICE 'Coluna date adicionada com sucesso';
        
    ELSE
        RAISE NOTICE 'Coluna date já existe na tabela expenses';
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Erro ao processar: %', SQLERRM;
END $$;

-- Verificar o resultado final
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

-- Verificar se existem índices que precisam ser atualizados
SELECT 
    indexname,
    indexdef
FROM pg_indexes 
WHERE tablename = 'expenses' 
AND indexdef LIKE '%expense_date%';

-- Se houver índices com expense_date, recriar com date
DO $$
BEGIN
    -- Recriar índice se necessário
    IF EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE tablename = 'expenses' 
        AND indexname = 'idx_expenses_expense_date'
    ) THEN
        DROP INDEX IF EXISTS idx_expenses_expense_date;
        CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date);
        RAISE NOTICE 'Índice idx_expenses_date recriado com sucesso';
    END IF;
END $$;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================
SELECT 'Estrutura da tabela expenses:' as info;
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'expenses' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- =====================================================
-- INSTRUÇÕES
-- =====================================================
-- 1. Cole este script no SQL Editor do Supabase
-- 2. Execute o script
-- 3. Verifique se não há erros
-- 4. Teste o carregamento de despesas no aplicativo
-- 5. O erro "column expenses.date does not exist" deve ser resolvido
-- =====================================================