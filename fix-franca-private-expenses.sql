-- =====================================================
-- CORREÇÃO DA RELAÇÃO EXPENSES -> USERS
-- FRANCA PRIVATE SYSTEM
-- =====================================================

-- Verificar se a tabela expenses existe
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'expenses') THEN
        RAISE NOTICE 'Tabela expenses não existe. Criando...';
        
        -- Criar tabela expenses
        CREATE TABLE expenses (
            id BIGSERIAL PRIMARY KEY,
            user_id UUID REFERENCES users(id) ON DELETE CASCADE,
            description TEXT NOT NULL,
            category VARCHAR(50) NOT NULL,
            amount DECIMAL(10, 2) NOT NULL,
            date DATE NOT NULL,
            notes TEXT,
            signature TEXT,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
        );
    ELSE
        RAISE NOTICE 'Tabela expenses já existe.';
    END IF;
END $$;

-- Remover constraint existente se houver problema
DO $$ 
BEGIN
    -- Tentar remover constraint antiga se existir
    IF EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'expenses_user_id_fkey' 
        AND table_name = 'expenses'
    ) THEN
        ALTER TABLE expenses DROP CONSTRAINT expenses_user_id_fkey;
        RAISE NOTICE 'Constraint antiga removida.';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Nenhuma constraint antiga para remover.';
END $$;

-- Verificar se a coluna user_id existe, se não, adicionar
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'expenses' 
        AND column_name = 'user_id'
    ) THEN
        ALTER TABLE expenses ADD COLUMN user_id UUID;
        RAISE NOTICE 'Coluna user_id adicionada.';
    ELSE
        RAISE NOTICE 'Coluna user_id já existe.';
    END IF;
END $$;

-- Adicionar constraint de foreign key
DO $$ 
BEGIN
    ALTER TABLE expenses 
    ADD CONSTRAINT expenses_user_id_fkey 
    FOREIGN KEY (user_id) 
    REFERENCES users(id) 
    ON DELETE CASCADE;
    
    RAISE NOTICE 'Foreign key constraint criada com sucesso.';
EXCEPTION
    WHEN duplicate_object THEN
        RAISE NOTICE 'Foreign key constraint já existe.';
    WHEN OTHERS THEN
        RAISE NOTICE 'Erro ao criar constraint: %', SQLERRM;
END $$;

-- Criar índice para performance
CREATE INDEX IF NOT EXISTS idx_expenses_user_id ON expenses(user_id);
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date);
CREATE INDEX IF NOT EXISTS idx_expenses_category ON expenses(category);

-- Desabilitar RLS (Row Level Security)
ALTER TABLE expenses DISABLE ROW LEVEL SECURITY;

-- Remover todas as políticas RLS existentes
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT policyname 
        FROM pg_policies 
        WHERE tablename = 'expenses'
    ) LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON expenses';
        RAISE NOTICE 'Política % removida.', r.policyname;
    END LOOP;
END $$;

-- Garantir que a tabela expense_categories existe
CREATE TABLE IF NOT EXISTS expense_categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    color TEXT,
    icon TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Desabilitar RLS para expense_categories também
ALTER TABLE expense_categories DISABLE ROW LEVEL SECURITY;

-- Remover políticas RLS de expense_categories
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT policyname 
        FROM pg_policies 
        WHERE tablename = 'expense_categories'
    ) LOOP
        EXECUTE 'DROP POLICY IF EXISTS ' || quote_ident(r.policyname) || ' ON expense_categories';
    END LOOP;
END $$;

-- Inserir categorias padrão se não existirem
INSERT INTO expense_categories (name, description, color, icon) VALUES
('Aluguel', 'Pagamento de aluguel', '#3b82f6', '🏢'),
('Salários', 'Pagamento de salários', '#10b981', '💰'),
('Marketing', 'Despesas com marketing', '#f59e0b', '📢'),
('Tecnologia', 'Despesas com tecnologia e software', '#8b5cf6', '💻'),
('Transporte', 'Despesas com transporte', '#ef4444', '🚗'),
('Alimentação', 'Despesas com alimentação', '#06b6d4', '🍽️'),
('Equipamentos', 'Compra de equipamentos', '#ec4899', '🔧'),
('Outros', 'Outras despesas', '#6b7280', '📋')
ON CONFLICT (name) DO NOTHING;

-- Criar trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_expenses_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Remover trigger antigo se existir
DROP TRIGGER IF EXISTS update_expenses_updated_at_trigger ON expenses;

-- Criar novo trigger
CREATE TRIGGER update_expenses_updated_at_trigger
    BEFORE UPDATE ON expenses
    FOR EACH ROW
    EXECUTE FUNCTION update_expenses_updated_at();

-- Verificação final
SELECT 
    'expenses' as tabela,
    COUNT(*) as total_registros,
    (SELECT COUNT(*) FROM information_schema.table_constraints 
     WHERE table_name = 'expenses' AND constraint_type = 'FOREIGN KEY') as foreign_keys,
    (SELECT COUNT(*) FROM pg_policies WHERE tablename = 'expenses') as politicas_rls
FROM expenses;

SELECT 
    'expense_categories' as tabela,
    COUNT(*) as total_categorias
FROM expense_categories;

-- Mostrar informações sobre a constraint
SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name = 'expenses';

-- =====================================================
-- FIM DA CORREÇÃO
-- =====================================================

SELECT 'Correção da tabela expenses concluída com sucesso!' as resultado;
