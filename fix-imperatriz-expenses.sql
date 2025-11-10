-- =====================================================
-- CORREÇÃO DA TABELA EXPENSES - IMPERATRIZ CRED
-- =====================================================
-- Este script corrige a coluna de data na tabela expenses
-- para garantir compatibilidade com o sistema
-- =====================================================

-- PASSO 1: Verificar a estrutura atual da tabela expenses
SELECT 
    'Estrutura atual da tabela expenses:' as info,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'expenses' 
AND table_schema = 'public'
AND column_name IN ('date', 'expense_date')
ORDER BY column_name;

-- PASSO 2: Renomear a coluna se necessário
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

-- PASSO 3: Verificar e recriar índices com os nomes corretos
-- Remover índices antigos (se existirem)
DROP INDEX IF EXISTS idx_expenses_expense_date;
DROP INDEX IF EXISTS idx_expenses_user_expense_date;
DROP INDEX IF EXISTS idx_expenses_category_expense_date;

-- Criar índices novos com nome correto
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date);
CREATE INDEX IF NOT EXISTS idx_expenses_user_date ON expenses(user_id, date DESC);
CREATE INDEX IF NOT EXISTS idx_expenses_category_date ON expenses(category_id, date DESC);

RAISE NOTICE '✓ Índices atualizados com sucesso';

-- PASSO 4: Verificação final
SELECT 
    '=== VERIFICAÇÃO FINAL ===' as info,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'expenses' 
AND table_schema = 'public'
AND column_name = 'date';

-- PASSO 5: Verificar os índices criados
SELECT 
    '=== ÍNDICES CRIADOS ===' as info,
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
-- - Índices: idx_expenses_date, idx_expenses_user_date, idx_expenses_category_date
-- =====================================================
-- 
-- COMO EXECUTAR:
-- 1. Acesse: https://eppzphzwwpvpoocospxy.supabase.co
-- 2. Vá para SQL Editor
-- 3. Cole este script completo
-- 4. Clique em "Run" para executar
-- 5. Verifique se aparece "✓ Coluna expense_date renomeada para date com sucesso"
-- 6. Recarregue a aplicação e teste a aba de Despesas
-- 
-- =====================================================
