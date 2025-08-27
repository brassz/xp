-- =====================================================
-- CORREÇÃO DO SCHEMA DA TABELA DE DESPESAS
-- =====================================================
-- Este script corrige as incompatibilidades entre o schema
-- atual da tabela expenses e o que o aplicativo espera
-- =====================================================

-- PASSO 1: Backup dos dados existentes (se houver)
-- Criar tabela temporária para backup
CREATE TABLE IF NOT EXISTS expenses_backup AS 
SELECT * FROM expenses;

-- PASSO 2: Remover a tabela atual
DROP TABLE IF EXISTS expenses CASCADE;

-- PASSO 3: Criar a estrutura de categorias (se não existir)
CREATE TABLE IF NOT EXISTS expense_categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    color TEXT DEFAULT '#6B7280',
    icon TEXT DEFAULT 'receipt',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- PASSO 4: Recriar a tabela expenses com o schema correto
CREATE TABLE expenses (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    category_id UUID REFERENCES expense_categories(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    description TEXT,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    date DATE NOT NULL DEFAULT CURRENT_DATE,  -- Usando 'date' em vez de 'expense_date'
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

-- PASSO 5: Recriar índices
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

-- PASSO 6: Recriar políticas RLS
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

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

CREATE POLICY "Users can insert own expenses" ON expenses
    FOR INSERT WITH CHECK (
        user_id::text = auth.uid()::text OR
        created_by::text = auth.uid()::text
    );

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

-- PASSO 7: Inserir categorias padrão
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

-- PASSO 8: Migrar dados existentes (se houver no backup)
-- Esta seção tentará migrar os dados da tabela de backup para o novo formato
-- NOTA: Ajuste conforme necessário baseado nos dados existentes

DO $$
DECLARE
    outros_category_id UUID;
BEGIN
    -- Buscar o ID da categoria "Outros"
    SELECT id INTO outros_category_id FROM expense_categories WHERE name = 'Outros';
    
    -- Inserir dados do backup (se a tabela existir e tiver dados)
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'expenses_backup') THEN
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
            outros_category_id, -- Mapear categoria string para UUID da categoria "Outros"
            description, -- usar description como title
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

-- PASSO 9: Criar triggers para updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_expense_categories_updated_at 
    BEFORE UPDATE ON expense_categories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_expenses_updated_at 
    BEFORE UPDATE ON expenses 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- PASSO 10: Limpeza (opcional - remover backup após confirmação)
-- DROP TABLE IF EXISTS expenses_backup;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar estrutura das tabelas
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name IN ('expenses', 'expense_categories')
ORDER BY table_name, ordinal_position;

-- Verificar categorias criadas
SELECT id, name, color, icon, is_active FROM expense_categories ORDER BY name;

-- =====================================================
-- INSTRUÇÕES DE USO
-- =====================================================
-- 
-- 1. Execute este script no SQL Editor do Supabase
-- 2. Verifique se não há erros na execução
-- 3. Confirme que as tabelas foram criadas com a estrutura correta
-- 4. Teste o carregamento de despesas no aplicativo
-- 5. Se tudo estiver funcionando, remova a tabela de backup
--
-- NOTA IMPORTANTE:
-- - Este script fará backup dos dados existentes antes da migração
-- - Os dados serão migrados para o novo formato
-- - Categorias antigas (string) serão mapeadas para "Outros"
-- - Títulos serão preenchidos com o campo description
-- 
-- =====================================================