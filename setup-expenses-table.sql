-- =====================================================
-- TABELA DE DESPESAS - NEXUS GESTÃO FINANCEIRA
-- =====================================================
-- Execute este script no SQL Editor do Supabase para criar
-- a estrutura completa da tabela de despesas
-- =====================================================

-- Habilitar extensões necessárias (caso não estejam habilitadas)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABELA DE CATEGORIAS DE DESPESAS
-- =====================================================
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

-- Comentários da tabela de categorias
COMMENT ON TABLE expense_categories IS 'Tabela para armazenar categorias de despesas';
COMMENT ON COLUMN expense_categories.id IS 'Identificador único da categoria';
COMMENT ON COLUMN expense_categories.name IS 'Nome da categoria';
COMMENT ON COLUMN expense_categories.description IS 'Descrição da categoria';
COMMENT ON COLUMN expense_categories.color IS 'Cor da categoria em hexadecimal';
COMMENT ON COLUMN expense_categories.icon IS 'Nome do ícone da categoria';
COMMENT ON COLUMN expense_categories.is_active IS 'Status ativo/inativo da categoria';
COMMENT ON COLUMN expense_categories.created_at IS 'Data de criação da categoria';
COMMENT ON COLUMN expense_categories.updated_at IS 'Data da última atualização';

-- =====================================================
-- TABELA DE DESPESAS
-- =====================================================
CREATE TABLE IF NOT EXISTS expenses (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    category_id UUID REFERENCES expense_categories(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    description TEXT,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
    payment_method TEXT DEFAULT 'cash' CHECK (payment_method IN ('cash', 'card', 'pix', 'transfer', 'check', 'other')),
    receipt_url TEXT, -- URL do comprovante (Uploadcare ou similar)
    signature TEXT, -- Base64 da assinatura digital
    tags TEXT[], -- Array de tags para filtros adicionais
    is_recurring BOOLEAN DEFAULT false,
    recurring_frequency TEXT CHECK (recurring_frequency IN ('daily', 'weekly', 'monthly', 'yearly') OR recurring_frequency IS NULL),
    parent_expense_id UUID REFERENCES expenses(id) ON DELETE SET NULL, -- Para despesas recorrentes
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'paid', 'cancelled')),
    notes TEXT,
    created_by UUID REFERENCES users(id),
    approved_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela de despesas
COMMENT ON TABLE expenses IS 'Tabela para armazenar despesas do sistema';
COMMENT ON COLUMN expenses.id IS 'Identificador único da despesa';
COMMENT ON COLUMN expenses.user_id IS 'Usuário responsável pela despesa';
COMMENT ON COLUMN expenses.category_id IS 'Categoria da despesa';
COMMENT ON COLUMN expenses.title IS 'Título/nome da despesa';
COMMENT ON COLUMN expenses.description IS 'Descrição detalhada da despesa';
COMMENT ON COLUMN expenses.amount IS 'Valor da despesa';
COMMENT ON COLUMN expenses.expense_date IS 'Data em que a despesa foi realizada';
COMMENT ON COLUMN expenses.payment_method IS 'Método de pagamento utilizado';
COMMENT ON COLUMN expenses.receipt_url IS 'URL do comprovante da despesa';
COMMENT ON COLUMN expenses.signature IS 'Assinatura digital em base64';
COMMENT ON COLUMN expenses.tags IS 'Tags para categorização adicional';
COMMENT ON COLUMN expenses.is_recurring IS 'Indica se a despesa é recorrente';
COMMENT ON COLUMN expenses.recurring_frequency IS 'Frequência da recorrência';
COMMENT ON COLUMN expenses.parent_expense_id IS 'ID da despesa pai (para recorrentes)';
COMMENT ON COLUMN expenses.status IS 'Status da despesa (pendente, aprovada, paga, cancelada)';
COMMENT ON COLUMN expenses.notes IS 'Observações adicionais';
COMMENT ON COLUMN expenses.created_by IS 'Usuário que criou a despesa';
COMMENT ON COLUMN expenses.approved_by IS 'Usuário que aprovou a despesa';
COMMENT ON COLUMN expenses.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN expenses.updated_at IS 'Data da última atualização';

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================

-- Índices para categorias de despesas
CREATE INDEX IF NOT EXISTS idx_expense_categories_name ON expense_categories(name);
CREATE INDEX IF NOT EXISTS idx_expense_categories_is_active ON expense_categories(is_active);

-- Índices para despesas
CREATE INDEX IF NOT EXISTS idx_expenses_user_id ON expenses(user_id);
CREATE INDEX IF NOT EXISTS idx_expenses_category_id ON expenses(category_id);
CREATE INDEX IF NOT EXISTS idx_expenses_expense_date ON expenses(expense_date);
CREATE INDEX IF NOT EXISTS idx_expenses_payment_method ON expenses(payment_method);
CREATE INDEX IF NOT EXISTS idx_expenses_status ON expenses(status);
CREATE INDEX IF NOT EXISTS idx_expenses_is_recurring ON expenses(is_recurring);
CREATE INDEX IF NOT EXISTS idx_expenses_parent_expense_id ON expenses(parent_expense_id);
CREATE INDEX IF NOT EXISTS idx_expenses_created_by ON expenses(created_by);
CREATE INDEX IF NOT EXISTS idx_expenses_created_at ON expenses(created_at);
CREATE INDEX IF NOT EXISTS idx_expenses_amount ON expenses(amount);

-- Índice composto para consultas frequentes
CREATE INDEX IF NOT EXISTS idx_expenses_user_date ON expenses(user_id, expense_date DESC);
CREATE INDEX IF NOT EXISTS idx_expenses_category_date ON expenses(category_id, expense_date DESC);

-- =====================================================
-- TRIGGERS PARA UPDATED_AT
-- =====================================================

-- Trigger para categorias de despesas
CREATE TRIGGER update_expense_categories_updated_at 
    BEFORE UPDATE ON expense_categories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger para despesas
CREATE TRIGGER update_expenses_updated_at 
    BEFORE UPDATE ON expenses 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- POLÍTICAS DE SEGURANÇA (RLS)
-- =====================================================

-- Habilitar RLS nas tabelas
ALTER TABLE expense_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

-- Políticas para categorias de despesas (todos podem visualizar categorias ativas)
CREATE POLICY "Everyone can view active expense categories" ON expense_categories
    FOR SELECT USING (is_active = true AND auth.role() = 'authenticated');

CREATE POLICY "Admins can manage expense categories" ON expense_categories
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- Políticas para despesas
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

-- =====================================================
-- VIEWS ÚTEIS PARA RELATÓRIOS
-- =====================================================

-- View para despesas com detalhes completos
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

-- View para resumo de despesas por categoria
CREATE OR REPLACE VIEW expenses_summary_by_category AS
SELECT 
    ec.id as category_id,
    ec.name as category_name,
    ec.color as category_color,
    ec.icon as category_icon,
    COUNT(e.id) as total_expenses,
    COALESCE(SUM(e.amount), 0) as total_amount,
    COALESCE(AVG(e.amount), 0) as average_amount,
    MIN(e.expense_date) as first_expense_date,
    MAX(e.expense_date) as last_expense_date
FROM expense_categories ec
LEFT JOIN expenses e ON ec.id = e.category_id
WHERE ec.is_active = true
GROUP BY ec.id, ec.name, ec.color, ec.icon
ORDER BY total_amount DESC;

-- View para despesas do mês atual
CREATE OR REPLACE VIEW current_month_expenses AS
SELECT 
    e.*,
    ec.name as category_name,
    ec.color as category_color,
    u.full_name as user_name
FROM expenses e
LEFT JOIN expense_categories ec ON e.category_id = ec.id
LEFT JOIN users u ON e.user_id = u.id
WHERE EXTRACT(YEAR FROM e.expense_date) = EXTRACT(YEAR FROM CURRENT_DATE)
AND EXTRACT(MONTH FROM e.expense_date) = EXTRACT(MONTH FROM CURRENT_DATE)
ORDER BY e.expense_date DESC;

-- View para despesas pendentes de aprovação
CREATE OR REPLACE VIEW pending_approval_expenses AS
SELECT 
    e.*,
    ec.name as category_name,
    ec.color as category_color,
    u.full_name as user_name,
    cb.full_name as created_by_name
FROM expenses e
LEFT JOIN expense_categories ec ON e.category_id = ec.id
LEFT JOIN users u ON e.user_id = u.id
LEFT JOIN users cb ON e.created_by = cb.id
WHERE e.status = 'pending'
ORDER BY e.created_at ASC;

-- =====================================================
-- FUNÇÕES AUXILIARES
-- =====================================================

-- Função para calcular total de despesas por período
CREATE OR REPLACE FUNCTION calculate_expenses_total(
    start_date DATE DEFAULT CURRENT_DATE - INTERVAL '30 days',
    end_date DATE DEFAULT CURRENT_DATE,
    user_filter UUID DEFAULT NULL,
    category_filter UUID DEFAULT NULL
)
RETURNS TABLE (
    total_amount DECIMAL(10,2),
    total_count BIGINT,
    average_amount DECIMAL(10,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(SUM(e.amount), 0)::DECIMAL(10,2) as total_amount,
        COUNT(e.id) as total_count,
        COALESCE(AVG(e.amount), 0)::DECIMAL(10,2) as average_amount
    FROM expenses e
    WHERE e.expense_date BETWEEN start_date AND end_date
    AND (user_filter IS NULL OR e.user_id = user_filter)
    AND (category_filter IS NULL OR e.category_id = category_filter)
    AND e.status != 'cancelled';
END;
$$ LANGUAGE plpgsql;

-- Função para aprovar despesa
CREATE OR REPLACE FUNCTION approve_expense(expense_id UUID, approver_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE expenses 
    SET 
        status = 'approved',
        approved_by = approver_id,
        updated_at = NOW()
    WHERE id = expense_id 
    AND status = 'pending';
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- INSERIR CATEGORIAS PADRÃO
-- =====================================================
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

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar se as tabelas foram criadas
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('expense_categories', 'expenses')
ORDER BY table_name;

-- Verificar se as views foram criadas
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name LIKE '%expense%'
AND table_type = 'VIEW'
ORDER BY table_name;

-- Verificar categorias inseridas
SELECT id, name, description, color, icon, is_active 
FROM expense_categories 
ORDER BY name;

-- =====================================================
-- FIM DA CONFIGURAÇÃO DA TABELA DE DESPESAS
-- =====================================================
-- 
-- Para executar este script:
-- 1. Acesse o SQL Editor no Supabase
-- 2. Cole todo o conteúdo deste arquivo
-- 3. Clique em "Run" para executar
-- 4. Verifique se não há erros na execução
-- 5. Confirme que as tabelas e views foram criadas
--
-- FUNCIONALIDADES INCLUÍDAS:
-- ✓ Tabela de categorias de despesas
-- ✓ Tabela de despesas com campos completos
-- ✓ Políticas de segurança (RLS)
-- ✓ Índices para performance
-- ✓ Views para relatórios
-- ✓ Funções auxiliares
-- ✓ Categorias padrão pré-cadastradas
-- ✓ Suporte a despesas recorrentes
-- ✓ Sistema de aprovação
-- ✓ Upload de comprovantes
-- ✓ Assinatura digital
-- =====================================================