-- =====================================================
-- CONTROLE FINANCEIRO - FRANCA PRIVATE
-- =====================================================
-- Sistema de Controle Financeiro com Caixa e Relatórios
-- Execute estes comandos no SQL Editor do Supabase
-- URL: https://pebwoerzslfzhjptyjwh.supabase.co
-- =====================================================

-- =====================================================
-- TABELA DE ENTRADAS DO CAIXA (COMISSÕES)
-- =====================================================
CREATE TABLE IF NOT EXISTS financial_control_entries (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    company_name TEXT NOT NULL,
    company_code TEXT NOT NULL,
    commission_amount DECIMAL(15,2) NOT NULL CHECK (commission_amount >= 0),
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    description TEXT,
    entry_date DATE DEFAULT CURRENT_DATE,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE financial_control_entries IS 'Tabela para registrar entradas de comissões de todas as empresas no caixa da Franca Private';
COMMENT ON COLUMN financial_control_entries.company_name IS 'Nome da empresa de origem das comissões';
COMMENT ON COLUMN financial_control_entries.company_code IS 'Código da empresa (erechim, imperatriz, brunoassoni, etc)';
COMMENT ON COLUMN financial_control_entries.commission_amount IS 'Valor total das comissões recebidas';
COMMENT ON COLUMN financial_control_entries.period_start IS 'Data inicial do período das comissões';
COMMENT ON COLUMN financial_control_entries.period_end IS 'Data final do período das comissões';
COMMENT ON COLUMN financial_control_entries.entry_date IS 'Data de entrada no caixa';

-- =====================================================
-- TABELA DE DESPESAS DO CONTROLE FINANCEIRO
-- =====================================================
CREATE TABLE IF NOT EXISTS financial_control_expenses (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    category TEXT NOT NULL,
    expense_date DATE DEFAULT CURRENT_DATE,
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE financial_control_expenses IS 'Tabela para registrar despesas do controle financeiro';
COMMENT ON COLUMN financial_control_expenses.description IS 'Descrição da despesa (ex: Água, Luz, etc)';
COMMENT ON COLUMN financial_control_expenses.amount IS 'Valor da despesa';
COMMENT ON COLUMN financial_control_expenses.category IS 'Categoria da despesa';
COMMENT ON COLUMN financial_control_expenses.expense_date IS 'Data da despesa';

-- =====================================================
-- TABELA DE REINVESTIMENTOS
-- =====================================================
CREATE TABLE IF NOT EXISTS financial_control_reinvestments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    percentage DECIMAL(5,2) NOT NULL DEFAULT 15.00,
    base_amount DECIMAL(15,2) NOT NULL,
    description TEXT,
    reinvestment_date DATE DEFAULT CURRENT_DATE,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'applied', 'cancelled')),
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE financial_control_reinvestments IS 'Tabela para registrar reinvestimentos calculados (15% do saldo restante)';
COMMENT ON COLUMN financial_control_reinvestments.amount IS 'Valor a reinvestir';
COMMENT ON COLUMN financial_control_reinvestments.percentage IS 'Percentual de reinvestimento (padrão 15%)';
COMMENT ON COLUMN financial_control_reinvestments.base_amount IS 'Valor base usado para calcular o reinvestimento';
COMMENT ON COLUMN financial_control_reinvestments.status IS 'Status do reinvestimento';

-- =====================================================
-- TABELA DE CONFIGURAÇÕES DO CONTROLE FINANCEIRO
-- =====================================================
CREATE TABLE IF NOT EXISTS financial_control_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    current_balance DECIMAL(15,2) DEFAULT 0 NOT NULL,
    total_entries DECIMAL(15,2) DEFAULT 0 NOT NULL,
    total_expenses DECIMAL(15,2) DEFAULT 0 NOT NULL,
    reinvestment_percentage DECIMAL(5,2) DEFAULT 15.00 NOT NULL,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_by UUID REFERENCES users(id)
);

COMMENT ON TABLE financial_control_settings IS 'Tabela para armazenar as configurações e saldos do controle financeiro';
COMMENT ON COLUMN financial_control_settings.current_balance IS 'Saldo atual do caixa (entradas - despesas)';
COMMENT ON COLUMN financial_control_settings.total_entries IS 'Total de entradas acumuladas';
COMMENT ON COLUMN financial_control_settings.total_expenses IS 'Total de despesas acumuladas';
COMMENT ON COLUMN financial_control_settings.reinvestment_percentage IS 'Percentual de reinvestimento padrão';

-- Inserir configuração inicial (caso não exista)
INSERT INTO financial_control_settings (current_balance, total_entries, total_expenses, reinvestment_percentage) 
SELECT 0, 0, 0, 15.00 
WHERE NOT EXISTS (SELECT 1 FROM financial_control_settings);

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_fc_entries_company ON financial_control_entries(company_code);
CREATE INDEX IF NOT EXISTS idx_fc_entries_date ON financial_control_entries(entry_date);
CREATE INDEX IF NOT EXISTS idx_fc_entries_period ON financial_control_entries(period_start, period_end);
CREATE INDEX IF NOT EXISTS idx_fc_expenses_date ON financial_control_expenses(expense_date);
CREATE INDEX IF NOT EXISTS idx_fc_expenses_category ON financial_control_expenses(category);
CREATE INDEX IF NOT EXISTS idx_fc_reinvestments_date ON financial_control_reinvestments(reinvestment_date);
CREATE INDEX IF NOT EXISTS idx_fc_reinvestments_status ON financial_control_reinvestments(status);

-- =====================================================
-- TRIGGERS PARA ATUALIZAÇÃO AUTOMÁTICA
-- =====================================================

-- Função para atualizar timestamp
CREATE OR REPLACE FUNCTION update_financial_control_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para updated_at
CREATE TRIGGER update_fc_entries_timestamp
    BEFORE UPDATE ON financial_control_entries
    FOR EACH ROW
    EXECUTE FUNCTION update_financial_control_timestamp();

CREATE TRIGGER update_fc_expenses_timestamp
    BEFORE UPDATE ON financial_control_expenses
    FOR EACH ROW
    EXECUTE FUNCTION update_financial_control_timestamp();

CREATE TRIGGER update_fc_reinvestments_timestamp
    BEFORE UPDATE ON financial_control_reinvestments
    FOR EACH ROW
    EXECUTE FUNCTION update_financial_control_timestamp();

CREATE TRIGGER update_fc_settings_timestamp
    BEFORE UPDATE ON financial_control_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_financial_control_timestamp();

-- =====================================================
-- VIEWS PARA RELATÓRIOS
-- =====================================================

-- View para resumo do controle financeiro
CREATE OR REPLACE VIEW financial_control_summary AS
SELECT
    (SELECT COALESCE(SUM(commission_amount), 0) FROM financial_control_entries) as total_entries,
    (SELECT COALESCE(SUM(amount), 0) FROM financial_control_expenses) as total_expenses,
    (SELECT COALESCE(SUM(commission_amount), 0) FROM financial_control_entries) -
    (SELECT COALESCE(SUM(amount), 0) FROM financial_control_expenses) as current_balance,
    ((SELECT COALESCE(SUM(commission_amount), 0) FROM financial_control_entries) -
    (SELECT COALESCE(SUM(amount), 0) FROM financial_control_expenses)) * 0.15 as reinvestment_amount;

-- View para despesas por categoria
CREATE OR REPLACE VIEW expenses_by_category AS
SELECT
    category,
    COUNT(*) as expense_count,
    SUM(amount) as total_amount,
    AVG(amount) as average_amount,
    MIN(expense_date) as first_expense,
    MAX(expense_date) as last_expense
FROM financial_control_expenses
GROUP BY category
ORDER BY total_amount DESC;

-- View para entradas por empresa
CREATE OR REPLACE VIEW entries_by_company AS
SELECT
    company_name,
    company_code,
    COUNT(*) as entry_count,
    SUM(commission_amount) as total_commissions,
    AVG(commission_amount) as average_commission,
    MIN(entry_date) as first_entry,
    MAX(entry_date) as last_entry
FROM financial_control_entries
GROUP BY company_name, company_code
ORDER BY total_commissions DESC;

-- View para relatório mensal
CREATE OR REPLACE VIEW monthly_financial_report AS
SELECT
    TO_CHAR(COALESCE(e.entry_date, ex.expense_date), 'YYYY-MM') as month_year,
    COALESCE(SUM(e.commission_amount), 0) as total_entries,
    COALESCE(SUM(ex.amount), 0) as total_expenses,
    COALESCE(SUM(e.commission_amount), 0) - COALESCE(SUM(ex.amount), 0) as net_balance
FROM financial_control_entries e
FULL OUTER JOIN financial_control_expenses ex ON 
    TO_CHAR(e.entry_date, 'YYYY-MM') = TO_CHAR(ex.expense_date, 'YYYY-MM')
GROUP BY TO_CHAR(COALESCE(e.entry_date, ex.expense_date), 'YYYY-MM')
ORDER BY month_year DESC;

-- =====================================================
-- POLÍTICAS DE SEGURANÇA (RLS) - DESABILITADAS
-- =====================================================
-- Para simplificar, desabilitamos RLS como no resto do sistema Franca Private
ALTER TABLE financial_control_entries DISABLE ROW LEVEL SECURITY;
ALTER TABLE financial_control_expenses DISABLE ROW LEVEL SECURITY;
ALTER TABLE financial_control_reinvestments DISABLE ROW LEVEL SECURITY;
ALTER TABLE financial_control_settings DISABLE ROW LEVEL SECURITY;

-- =====================================================
-- DADOS INICIAIS PARA TESTE
-- =====================================================

-- Categorias comuns de despesas
-- Nota: Não criamos uma tabela separada, mas sugerimos categorias padrão

-- Exemplo de entrada inicial (remova em produção se não desejar)
-- INSERT INTO financial_control_entries (company_name, company_code, commission_amount, period_start, period_end, description)
-- VALUES ('ERECHIM', 'erechim', 5000.00, CURRENT_DATE - INTERVAL '30 days', CURRENT_DATE, 'Comissões do mês anterior');

-- =====================================================
-- FUNÇÕES AUXILIARES
-- =====================================================

-- Função para calcular saldo atual
CREATE OR REPLACE FUNCTION get_current_financial_balance()
RETURNS DECIMAL(15,2) AS $$
DECLARE
    balance DECIMAL(15,2);
BEGIN
    SELECT 
        COALESCE(SUM(commission_amount), 0) - COALESCE((SELECT SUM(amount) FROM financial_control_expenses), 0)
    INTO balance
    FROM financial_control_entries;
    
    RETURN balance;
END;
$$ LANGUAGE plpgsql;

-- Função para calcular reinvestimento recomendado
CREATE OR REPLACE FUNCTION get_recommended_reinvestment()
RETURNS DECIMAL(15,2) AS $$
DECLARE
    current_balance DECIMAL(15,2);
    reinvestment DECIMAL(15,2);
BEGIN
    current_balance := get_current_financial_balance();
    reinvestment := current_balance * 0.15;
    
    RETURN CASE WHEN reinvestment > 0 THEN reinvestment ELSE 0 END;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- CONCLUÍDO
-- =====================================================
-- Estrutura do Controle Financeiro criada com sucesso!
-- Tabelas criadas: 
--   - financial_control_entries (entradas/comissões)
--   - financial_control_expenses (despesas)
--   - financial_control_reinvestments (reinvestimentos)
--   - financial_control_settings (configurações)
-- Views criadas para relatórios
-- Funções auxiliares criadas
-- =====================================================
