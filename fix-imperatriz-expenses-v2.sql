-- =====================================================
-- CORREÇÃO DA TABELA EXPENSES - IMPERATRIZ CRED (V2)
-- =====================================================
-- Versão corrigida que lida com índices já existentes
-- =====================================================

-- PASSO 1: Renomear a coluna se necessário
DO $$ 
BEGIN
    -- Verificar se a coluna 'expense_date' existe
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'expenses' 
        AND table_schema = 'public'
        AND column_name = 'expense_date'
    ) THEN
        -- Renomear a coluna de expense_date para date
        ALTER TABLE expenses RENAME COLUMN expense_date TO date;
        RAISE NOTICE '✓ Coluna expense_date renomeada para date com sucesso';
    ELSIF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'expenses' 
        AND table_schema = 'public'
        AND column_name = 'date'
    ) THEN
        RAISE NOTICE '✓ A coluna date já existe. Nenhuma alteração necessária.';
    ELSE
        RAISE EXCEPTION '✗ Erro: Nenhuma coluna de data encontrada na tabela expenses';
    END IF;
END $$;

-- PASSO 2: Atualizar índices (removendo duplicados)
DO $$
BEGIN
    -- Remover índices antigos que podem ter nome com expense_date
    DROP INDEX IF EXISTS idx_expenses_expense_date;
    DROP INDEX IF EXISTS idx_expenses_user_expense_date;
    DROP INDEX IF EXISTS idx_expenses_category_expense_date;

    -- Criar ou recriar índices com nome correto
    -- Se já existirem, não faz nada
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_expenses_date' AND tablename = 'expenses') THEN
        CREATE INDEX idx_expenses_date ON expenses(date);
        RAISE NOTICE '✓ Criado índice idx_expenses_date';
    ELSE
        RAISE NOTICE '✓ Índice idx_expenses_date já existe';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_expenses_user_date' AND tablename = 'expenses') THEN
        CREATE INDEX idx_expenses_user_date ON expenses(user_id, date DESC);
        RAISE NOTICE '✓ Criado índice idx_expenses_user_date';
    ELSE
        RAISE NOTICE '✓ Índice idx_expenses_user_date já existe';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_expenses_category_date' AND tablename = 'expenses') THEN
        CREATE INDEX idx_expenses_category_date ON expenses(category_id, date DESC);
        RAISE NOTICE '✓ Criado índice idx_expenses_category_date';
    ELSE
        RAISE NOTICE '✓ Índice idx_expenses_category_date já existe';
    END IF;

    RAISE NOTICE '✓ Todos os índices estão corretos';
END $$;

-- PASSO 3: Verificação final
SELECT 
    '=== COLUNA DE DATA ===' as verificacao,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'expenses' 
AND table_schema = 'public'
AND column_name = 'date';

-- PASSO 4: Verificar os índices
SELECT 
    '=== ÍNDICES ===' as verificacao,
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'expenses'
AND indexname LIKE '%date%'
ORDER BY indexname;

-- =====================================================
-- SUCESSO!
-- =====================================================
-- Se você viu as mensagens de sucesso acima,
-- a correção foi aplicada com sucesso.
-- 
-- Agora você pode:
-- 1. Recarregar a aplicação Nexus
-- 2. Fazer login na Imperatriz Cred
-- 3. Acessar a aba Despesas
-- 4. Tudo deve funcionar normalmente! 🎉
-- =====================================================
