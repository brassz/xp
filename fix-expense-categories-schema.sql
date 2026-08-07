-- =====================================================
-- CORREÇÃO COMPLETA DO SCHEMA DE DESPESAS E CATEGORIAS
-- =====================================================
-- Este script resolve o erro: "Could not find the table 'public.expense_categories' in the schema cache"
-- Execute este script no SQL Editor do Supabase
-- =====================================================

-- PASSO 1: Verificar se as extensões necessárias estão habilitadas
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- PASSO 2: Criar função para trigger updated_at (se não existir)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- PASSO 3: Fazer backup da tabela expenses atual (se existir)
DO $$
BEGIN
    -- Verificar se a tabela expenses existe
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'expenses') THEN
        -- Criar backup apenas se ainda não existe
        IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'expenses_backup') THEN
            CREATE TABLE expenses_backup AS SELECT * FROM expenses;
            RAISE NOTICE 'Backup da tabela expenses criado com sucesso';
        END IF;
    END IF;
END $$;

-- PASSO 4: Criar tabela expense_categories (se não existir)
CREATE TABLE IF NOT EXISTS expense_categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    color TEXT DEFAULT '#6B7280', -- Cor em hexadecimal para a interface
    icon TEXT DEFAULT 'receipt', -- Nome do ícone para a interface
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- PASSO 5: Inserir categorias padrão (se não existirem)
INSERT INTO expense_categories (name, description, color, icon) VALUES
('Alimentação', 'Despesas com comida e bebidas', '#EF4444', 'utensils'),
('Transporte', 'Despesas com locomoção', '#3B82F6', 'car'),
('Escritório', 'Material de escritório e equipamentos', '#8B5CF6', 'briefcase'),
('Marketing', 'Despesas com publicidade e marketing', '#F59E0B', 'megaphone'),
('Tecnologia', 'Equipamentos e software', '#10B981', 'laptop'),
('Saúde', 'Despesas médicas e farmácia', '#EC4899', 'heart'),
('Educação', 'Cursos, livros e treinamentos', '#6366F1', 'book'),
('Limpeza', 'Produtos de limpeza e higiene', '#14B8A6', 'spray'),
('Manutenção', 'Reparos e manutenções', '#F97316', 'wrench'),
('Outros', 'Despesas diversas', '#6B7280', 'folder')
ON CONFLICT (name) DO NOTHING;

-- PASSO 6: Recriar tabela expenses com estrutura correta
DO $$
DECLARE
    outros_category_id UUID;
BEGIN
    -- Buscar o ID da categoria "Outros"
    SELECT id INTO outros_category_id FROM expense_categories WHERE name = 'Outros';
    
    -- Remover tabela expenses atual
    DROP TABLE IF EXISTS expenses CASCADE;
    
    -- Criar nova tabela expenses com estrutura correta
    CREATE TABLE expenses (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        user_id UUID REFERENCES users(id) ON DELETE CASCADE,
        category_id UUID REFERENCES expense_categories(id) ON DELETE SET NULL,
        title TEXT NOT NULL,
        description TEXT,
        amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
        date DATE NOT NULL DEFAULT CURRENT_DATE,
        payment_method TEXT DEFAULT 'cash' CHECK (payment_method IN ('cash', 'card', 'pix', 'transfer', 'check', 'other')),
        receipt_url TEXT,
        signature TEXT,
        tags TEXT[],
        is_recurring BOOLEAN DEFAULT false,
        recurring_frequency TEXT CHECK (recurring_frequency IN ('daily', 'weekly', 'monthly', 'yearly') OR recurring_frequency IS NULL),
        parent_expense_id UUID REFERENCES expenses(id) ON DELETE SET NULL,
        status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'paid', 'cancelled')),
        notes TEXT,
        created_by UUID REFERENCES users(id),
        approved_by UUID REFERENCES users(id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );
    
    -- Migrar dados do backup (se existir)
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'expenses_backup') THEN
        INSERT INTO expenses (
            user_id, 
            category_id, 
            title, 
            description, 
            amount, 
            date, 
            notes, 
            signature, 
            created_at, 
            updated_at,
            status,
            created_by
        )
        SELECT 
            user_id,
            outros_category_id, -- Mapear todas as categorias antigas para "Outros"
            COALESCE(description, 'Despesa migrada'), -- usar description como title
            description,
            amount,
            date,
            notes,
            signature,
            created_at,
            updated_at,
            'pending', -- status padrão
            user_id -- created_by = user_id
        FROM expenses_backup;
        
        RAISE NOTICE 'Dados migrados com sucesso da tabela de backup';
    END IF;
END $$;

-- PASSO 7: Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_expense_categories_name ON expense_categories(name);
CREATE INDEX IF NOT EXISTS idx_expense_categories_is_active ON expense_categories(is_active);

CREATE INDEX IF NOT EXISTS idx_expenses_user_id ON expenses(user_id);
CREATE INDEX IF NOT EXISTS idx_expenses_category_id ON expenses(category_id);
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date);
CREATE INDEX IF NOT EXISTS idx_expenses_payment_method ON expenses(payment_method);
CREATE INDEX IF NOT EXISTS idx_expenses_status ON expenses(status);
CREATE INDEX IF NOT EXISTS idx_expenses_is_recurring ON expenses(is_recurring);
CREATE INDEX IF NOT EXISTS idx_expenses_parent_expense_id ON expenses(parent_expense_id);
CREATE INDEX IF NOT EXISTS idx_expenses_created_by ON expenses(created_by);
CREATE INDEX IF NOT EXISTS idx_expenses_created_at ON expenses(created_at);
CREATE INDEX IF NOT EXISTS idx_expenses_amount ON expenses(amount);

-- Índices compostos para consultas frequentes
CREATE INDEX IF NOT EXISTS idx_expenses_user_date ON expenses(user_id, date DESC);
CREATE INDEX IF NOT EXISTS idx_expenses_category_date ON expenses(category_id, date DESC);

-- PASSO 8: Configurar RLS (Row Level Security)
ALTER TABLE expense_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

-- Políticas para expense_categories
DROP POLICY IF EXISTS "Everyone can view active expense categories" ON expense_categories;
CREATE POLICY "Everyone can view active expense categories" ON expense_categories
    FOR SELECT USING (is_active = true AND auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Admins can manage expense categories" ON expense_categories;
CREATE POLICY "Admins can manage expense categories" ON expense_categories
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- Políticas para expenses
DROP POLICY IF EXISTS "Users can view own expenses" ON expenses;
CREATE POLICY "Users can view own expenses" ON expenses
    FOR SELECT USING (
        user_id::text = auth.uid()::text OR
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role IN ('admin', 'manager')
        )
    );

DROP POLICY IF EXISTS "Users can insert own expenses" ON expenses;
CREATE POLICY "Users can insert own expenses" ON expenses
    FOR INSERT WITH CHECK (
        user_id::text = auth.uid()::text OR
        created_by::text = auth.uid()::text
    );

DROP POLICY IF EXISTS "Users can update own expenses or admins can update all" ON expenses;
CREATE POLICY "Users can update own expenses or admins can update all" ON expenses
    FOR UPDATE USING (
        user_id::text = auth.uid()::text OR
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role IN ('admin', 'manager')
        )
    );

DROP POLICY IF EXISTS "Users can delete own expenses or admins can delete all" ON expenses;
CREATE POLICY "Users can delete own expenses or admins can delete all" ON expenses
    FOR DELETE USING (
        user_id::text = auth.uid()::text OR
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- PASSO 9: Criar triggers para updated_at
DROP TRIGGER IF EXISTS update_expense_categories_updated_at ON expense_categories;
CREATE TRIGGER update_expense_categories_updated_at 
    BEFORE UPDATE ON expense_categories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_expenses_updated_at ON expenses;
CREATE TRIGGER update_expenses_updated_at 
    BEFORE UPDATE ON expenses 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- PASSO 10: Criar views úteis para o aplicativo
CREATE OR REPLACE VIEW expenses_with_details AS
SELECT 
    e.*,
    ec.name as category_name,
    ec.color as category_color,
    ec.icon as category_icon,
    u.full_name as user_name,
    u.email as user_email,
    cb.full_name as created_by_name,
    ab.full_name as approved_by_name
FROM expenses e
LEFT JOIN expense_categories ec ON e.category_id = ec.id
LEFT JOIN users u ON e.user_id = u.id
LEFT JOIN users cb ON e.created_by = cb.id
LEFT JOIN users ab ON e.approved_by = ab.id;

-- PASSO 11: Atualizar schema cache do Supabase
-- Força o Supabase a atualizar o cache do schema
SELECT pg_notify('pgrst', 'reload schema');

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar se as tabelas foram criadas corretamente
SELECT 
    'Tabelas criadas:' as status,
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('expense_categories', 'expenses')
ORDER BY table_name;

-- Verificar se as colunas estão corretas
SELECT 
    'Estrutura da tabela expense_categories:' as status,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'expense_categories'
ORDER BY ordinal_position;

SELECT 
    'Estrutura da tabela expenses:' as status,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'expenses'
ORDER BY ordinal_position;

-- Verificar se as categorias foram inseridas
SELECT 
    'Categorias inseridas:' as status,
    count(*) as total_categorias
FROM expense_categories;

SELECT 
    'Lista de categorias:' as status,
    id, 
    name, 
    color, 
    icon, 
    is_active 
FROM expense_categories 
ORDER BY name;

-- Verificar se as políticas RLS estão ativas
SELECT 
    'Políticas RLS:' as status,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('expense_categories', 'expenses');

-- =====================================================
-- INSTRUÇÕES PÓS-EXECUÇÃO
-- =====================================================

-- AVISO: Execute este script completo no SQL Editor do Supabase
-- 
-- Após a execução:
-- 1. ✅ A tabela expense_categories será criada
-- 2. ✅ A tabela expenses será recriada com estrutura correta
-- 3. ✅ Os dados existentes serão migrados (se houver)
-- 4. ✅ As políticas RLS serão configuradas
-- 5. ✅ O cache do schema será atualizado
-- 6. ✅ O erro "Could not find the table 'public.expense_categories'" será resolvido
--
-- Para testar se funcionou:
-- 1. Recarregue o aplicativo
-- 2. Tente acessar a seção de despesas
-- 3. O erro não deve mais aparecer
--
-- Se ainda houver problemas, verifique:
-- 1. Se o script foi executado completamente sem erros
-- 2. Se o usuário tem as permissões corretas no banco
-- 3. Se a conexão com Supabase está funcionando
-- 
-- =====================================================