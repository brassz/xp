-- =====================================================
-- CONFIGURAÇÃO DO BANCO DE DADOS BRUNO ASSONI SYSTEM
-- =====================================================
-- Sistema de Gestão Financeira Nexus
-- Execute estes comandos no SQL Editor do Supabase
-- URL: https://pebwoerzslfzhjptyjwh.supabase.co
-- =====================================================

-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABELA DE USUÁRIOS (SISTEMA DE LOGIN)
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    full_name TEXT NOT NULL,
    role TEXT DEFAULT 'user' CHECK (role IN ('admin', 'user', 'manager')),
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela de usuários
COMMENT ON TABLE users IS 'Tabela para armazenar usuários do sistema';
COMMENT ON COLUMN users.id IS 'Identificador único do usuário';
COMMENT ON COLUMN users.email IS 'Email único do usuário (usado para login)';
COMMENT ON COLUMN users.password_hash IS 'Hash da senha do usuário';
COMMENT ON COLUMN users.full_name IS 'Nome completo do usuário';
COMMENT ON COLUMN users.role IS 'Papel do usuário no sistema (admin, user, manager)';
COMMENT ON COLUMN users.is_active IS 'Status ativo/inativo do usuário';
COMMENT ON COLUMN users.last_login IS 'Data e hora do último login';
COMMENT ON COLUMN users.created_at IS 'Data de criação da conta';
COMMENT ON COLUMN users.updated_at IS 'Data da última atualização';

-- =====================================================
-- TABELA DE CLIENTES
-- =====================================================
CREATE TABLE IF NOT EXISTS clients (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    cpf TEXT UNIQUE NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    address TEXT NOT NULL,
    photo TEXT,
    birth_date DATE,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    rg TEXT,
    mother_name TEXT,
    father_name TEXT,
    marital_status TEXT,
    occupation TEXT,
    monthly_income DECIMAL(10,2),
    company_name TEXT,
    company_phone TEXT,
    admission_date DATE,
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela de clientes
COMMENT ON TABLE clients IS 'Tabela para armazenar informações dos clientes';
COMMENT ON COLUMN clients.id IS 'Identificador único do cliente';
COMMENT ON COLUMN clients.name IS 'Nome completo do cliente';
COMMENT ON COLUMN clients.cpf IS 'CPF único do cliente';
COMMENT ON COLUMN clients.email IS 'Email do cliente';
COMMENT ON COLUMN clients.phone IS 'Telefone do cliente';
COMMENT ON COLUMN clients.photo IS 'URL da foto do cliente (Uploadcare)';
COMMENT ON COLUMN clients.created_by IS 'Usuário que criou o cliente';
COMMENT ON COLUMN clients.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN clients.updated_at IS 'Data da última atualização';

-- =====================================================
-- TABELA DE CONTATOS DE EMERGÊNCIA
-- =====================================================
CREATE TABLE IF NOT EXISTS emergency_contacts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    relationship TEXT NOT NULL,
    phone TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE emergency_contacts IS 'Tabela para armazenar contatos de emergência dos clientes';
COMMENT ON COLUMN emergency_contacts.client_id IS 'Referência ao cliente';
COMMENT ON COLUMN emergency_contacts.name IS 'Nome do contato de emergência';
COMMENT ON COLUMN emergency_contacts.relationship IS 'Grau de parentesco';
COMMENT ON COLUMN emergency_contacts.phone IS 'Telefone do contato';

-- =====================================================
-- TABELA DE DOCUMENTOS DOS CLIENTES
-- =====================================================
CREATE TABLE IF NOT EXISTS client_documents (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    document_type TEXT NOT NULL,
    document_url TEXT NOT NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    uploaded_by UUID REFERENCES users(id)
);

COMMENT ON TABLE client_documents IS 'Tabela para armazenar documentos dos clientes';
COMMENT ON COLUMN client_documents.client_id IS 'Referência ao cliente';
COMMENT ON COLUMN client_documents.document_type IS 'Tipo do documento';
COMMENT ON COLUMN client_documents.document_url IS 'URL do documento no Uploadcare';

-- =====================================================
-- TABELA DE CHAVES PIX
-- =====================================================
CREATE TABLE IF NOT EXISTS pix_keys (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    bank_name TEXT NOT NULL,
    key_type TEXT NOT NULL CHECK (key_type IN ('cpf', 'cnpj', 'email', 'phone', 'random')),
    pix_key TEXT NOT NULL,
    account_holder TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE pix_keys IS 'Tabela para armazenar chaves PIX da empresa';
COMMENT ON COLUMN pix_keys.bank_name IS 'Nome do banco';
COMMENT ON COLUMN pix_keys.key_type IS 'Tipo da chave PIX';
COMMENT ON COLUMN pix_keys.pix_key IS 'Chave PIX';
COMMENT ON COLUMN pix_keys.account_holder IS 'Titular da conta';

-- =====================================================
-- TABELA DE AVALISTAS
-- =====================================================
CREATE TABLE IF NOT EXISTS guarantors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    cpf TEXT NOT NULL,
    rg TEXT,
    phone TEXT NOT NULL,
    email TEXT,
    address TEXT NOT NULL,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    birth_date DATE,
    marital_status TEXT,
    occupation TEXT,
    monthly_income DECIMAL(10,2),
    relationship TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE guarantors IS 'Tabela para armazenar avalistas dos clientes';
COMMENT ON COLUMN guarantors.client_id IS 'Referência ao cliente';
COMMENT ON COLUMN guarantors.name IS 'Nome completo do avalista';
COMMENT ON COLUMN guarantors.cpf IS 'CPF do avalista';

-- =====================================================
-- TABELA DE EMPRÉSTIMOS
-- =====================================================
CREATE TABLE IF NOT EXISTS loans (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    original_amount DECIMAL(10,2) NOT NULL CHECK (original_amount > 0),
    interest_rate DECIMAL(5,2) NOT NULL CHECK (interest_rate >= 0),
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    fixed_due_day INTEGER CHECK (fixed_due_day BETWEEN 1 AND 31),
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'overdue', 'paid', 'partial_paid', 'cancelled')),
    total_amount DECIMAL(10,2) GENERATED ALWAYS AS (amount + (amount * interest_rate / 100)) STORED,
    payment_type TEXT DEFAULT 'pix' CHECK (payment_type IN ('pix', 'dinheiro', 'transferencia', 'cartao')),
    notes TEXT,
    cancellation_reason TEXT,
    cancelled_at TIMESTAMP WITH TIME ZONE,
    cancelled_by UUID REFERENCES users(id),
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela de empréstimos
COMMENT ON TABLE loans IS 'Tabela para armazenar informações dos empréstimos';
COMMENT ON COLUMN loans.id IS 'Identificador único do empréstimo';
COMMENT ON COLUMN loans.client_id IS 'Referência ao cliente';
COMMENT ON COLUMN loans.amount IS 'Valor principal do empréstimo';
COMMENT ON COLUMN loans.original_amount IS 'Valor original do empréstimo (preservado)';
COMMENT ON COLUMN loans.interest_rate IS 'Taxa de juros em porcentagem';
COMMENT ON COLUMN loans.loan_date IS 'Data em que o empréstimo foi realizado';
COMMENT ON COLUMN loans.due_date IS 'Data de vencimento do empréstimo';
COMMENT ON COLUMN loans.fixed_due_day IS 'Dia fixo de vencimento mensal';
COMMENT ON COLUMN loans.status IS 'Status atual do empréstimo';
COMMENT ON COLUMN loans.total_amount IS 'Valor total com juros (calculado automaticamente)';
COMMENT ON COLUMN loans.payment_type IS 'Tipo de pagamento do empréstimo';
COMMENT ON COLUMN loans.created_by IS 'Usuário que criou o empréstimo';
COMMENT ON COLUMN loans.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN loans.updated_at IS 'Data da última atualização';

-- =====================================================
-- TABELA DE PAGAMENTOS
-- =====================================================
CREATE TABLE IF NOT EXISTS payments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    loan_id UUID NOT NULL REFERENCES loans(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_date DATE NOT NULL,
    payment_type TEXT DEFAULT 'pix' CHECK (payment_type IN ('pix', 'dinheiro', 'transferencia', 'cartao')),
    fine DECIMAL(10,2) DEFAULT 0,
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela de pagamentos
COMMENT ON TABLE payments IS 'Tabela para armazenar histórico de pagamentos';
COMMENT ON COLUMN payments.id IS 'Identificador único do pagamento';
COMMENT ON COLUMN payments.loan_id IS 'Referência ao empréstimo';
COMMENT ON COLUMN payments.amount IS 'Valor do pagamento';
COMMENT ON COLUMN payments.payment_date IS 'Data do pagamento';
COMMENT ON COLUMN payments.payment_type IS 'Tipo do pagamento';
COMMENT ON COLUMN payments.fine IS 'Valor de multa aplicado';
COMMENT ON COLUMN payments.notes IS 'Observações sobre o pagamento';
COMMENT ON COLUMN payments.created_by IS 'Usuário que registrou o pagamento';
COMMENT ON COLUMN payments.created_at IS 'Data de criação do registro';

-- =====================================================
-- TABELA DE PARCELAMENTOS (INSTALLMENTS)
-- =====================================================
CREATE TABLE IF NOT EXISTS installments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount > 0),
    installment_count INTEGER NOT NULL CHECK (installment_count > 0),
    installment_value DECIMAL(10,2) NOT NULL CHECK (installment_value > 0),
    interest_rate DECIMAL(5,2) NOT NULL CHECK (interest_rate >= 0),
    start_date DATE NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE installments IS 'Tabela para armazenar parcelamentos';
COMMENT ON COLUMN installments.client_id IS 'Referência ao cliente';
COMMENT ON COLUMN installments.total_amount IS 'Valor total do parcelamento';
COMMENT ON COLUMN installments.installment_count IS 'Número de parcelas';
COMMENT ON COLUMN installments.installment_value IS 'Valor de cada parcela';

-- =====================================================
-- TABELA DE PARCELAS INDIVIDUAIS
-- =====================================================
CREATE TABLE IF NOT EXISTS installment_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    installment_id UUID NOT NULL REFERENCES installments(id) ON DELETE CASCADE,
    installment_number INTEGER NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    due_date DATE NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'overdue')),
    paid_date DATE,
    paid_amount DECIMAL(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE installment_items IS 'Tabela para armazenar parcelas individuais';
COMMENT ON COLUMN installment_items.installment_id IS 'Referência ao parcelamento';
COMMENT ON COLUMN installment_items.installment_number IS 'Número da parcela';
COMMENT ON COLUMN installment_items.due_date IS 'Data de vencimento da parcela';

-- =====================================================
-- TABELA DE PAGAMENTOS DE PARCELAS
-- =====================================================
CREATE TABLE IF NOT EXISTS installment_payments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    installment_item_id UUID NOT NULL REFERENCES installment_items(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_date DATE NOT NULL,
    payment_type TEXT DEFAULT 'pix' CHECK (payment_type IN ('pix', 'dinheiro', 'transferencia', 'cartao')),
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE installment_payments IS 'Tabela para armazenar pagamentos de parcelas';

-- =====================================================
-- TABELA DE DESPESAS
-- =====================================================
CREATE TABLE IF NOT EXISTS expenses (
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

COMMENT ON TABLE expenses IS 'Tabela para armazenar despesas da empresa';
COMMENT ON COLUMN expenses.user_id IS 'Usuário que registrou a despesa';
COMMENT ON COLUMN expenses.category IS 'Categoria da despesa';
COMMENT ON COLUMN expenses.signature IS 'Assinatura digital em base64';

-- =====================================================
-- TABELA DE CATEGORIAS DE DESPESAS
-- =====================================================
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

COMMENT ON TABLE expense_categories IS 'Tabela para categorias de despesas';

-- Inserir categorias padrão
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

-- =====================================================
-- TABELA DE COMISSÕES
-- =====================================================
CREATE TABLE IF NOT EXISTS commissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    loan_id UUID REFERENCES loans(id) ON DELETE SET NULL,
    installment_id UUID REFERENCES installments(id) ON DELETE SET NULL,
    payment_id UUID REFERENCES payments(id) ON DELETE SET NULL,
    commission_type TEXT NOT NULL CHECK (commission_type IN ('loan', 'installment', 'payment')),
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    percentage DECIMAL(5,2) NOT NULL CHECK (percentage >= 0),
    base_amount DECIMAL(10,2) NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'cancelled')),
    paid_date DATE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE commissions IS 'Tabela para armazenar comissões dos usuários';
COMMENT ON COLUMN commissions.user_id IS 'Usuário que receberá a comissão';
COMMENT ON COLUMN commissions.commission_type IS 'Tipo de comissão';
COMMENT ON COLUMN commissions.amount IS 'Valor da comissão';
COMMENT ON COLUMN commissions.percentage IS 'Percentual aplicado';

-- =====================================================
-- TABELA DE CAPITAL RAISING (CAPTAÇÃO DE CAPITAL)
-- =====================================================
CREATE TABLE IF NOT EXISTS capital_raising (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    investor_name TEXT NOT NULL,
    cpf TEXT,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    interest_rate DECIMAL(5,2) NOT NULL CHECK (interest_rate >= 0),
    start_date DATE NOT NULL,
    maturity_date DATE NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
    payment_frequency TEXT CHECK (payment_frequency IN ('monthly', 'quarterly', 'semiannual', 'annual', 'at_maturity')),
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE capital_raising IS 'Tabela para captação de capital (investidores)';

-- =====================================================
-- TABELA DE PAGAMENTOS DE JUROS PARA INVESTIDORES
-- =====================================================
CREATE TABLE IF NOT EXISTS investor_payments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    capital_raising_id UUID NOT NULL REFERENCES capital_raising(id) ON DELETE CASCADE,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_type TEXT DEFAULT 'pix' CHECK (payment_type IN ('pix', 'transferencia', 'dinheiro')),
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE investor_payments IS 'Tabela para pagamentos de juros aos investidores';

-- =====================================================
-- TABELA DE GESTÃO DE CAIXA
-- =====================================================
CREATE TABLE IF NOT EXISTS cash_management (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('entrada', 'saida')),
    category TEXT NOT NULL,
    description TEXT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    transaction_date DATE NOT NULL,
    payment_method TEXT,
    reference_id UUID,
    reference_type TEXT,
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE cash_management IS 'Tabela para gestão de caixa (entradas e saídas)';

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================

-- Índices para usuários
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- Índices para clientes
CREATE INDEX IF NOT EXISTS idx_clients_cpf ON clients(cpf);
CREATE INDEX IF NOT EXISTS idx_clients_email ON clients(email);
CREATE INDEX IF NOT EXISTS idx_clients_name ON clients(name);
CREATE INDEX IF NOT EXISTS idx_clients_created_at ON clients(created_at);
CREATE INDEX IF NOT EXISTS idx_clients_created_by ON clients(created_by);

-- Índices para contatos de emergência
CREATE INDEX IF NOT EXISTS idx_emergency_contacts_client_id ON emergency_contacts(client_id);

-- Índices para documentos
CREATE INDEX IF NOT EXISTS idx_client_documents_client_id ON client_documents(client_id);
CREATE INDEX IF NOT EXISTS idx_client_documents_document_type ON client_documents(document_type);

-- Índices para chaves PIX
CREATE INDEX IF NOT EXISTS idx_pix_keys_is_active ON pix_keys(is_active);

-- Índices para avalistas
CREATE INDEX IF NOT EXISTS idx_guarantors_client_id ON guarantors(client_id);
CREATE INDEX IF NOT EXISTS idx_guarantors_cpf ON guarantors(cpf);

-- Índices para empréstimos
CREATE INDEX IF NOT EXISTS idx_loans_client_id ON loans(client_id);
CREATE INDEX IF NOT EXISTS idx_loans_status ON loans(status);
CREATE INDEX IF NOT EXISTS idx_loans_due_date ON loans(due_date);
CREATE INDEX IF NOT EXISTS idx_loans_loan_date ON loans(loan_date);
CREATE INDEX IF NOT EXISTS idx_loans_created_at ON loans(created_at);
CREATE INDEX IF NOT EXISTS idx_loans_created_by ON loans(created_by);

-- Índices para pagamentos
CREATE INDEX IF NOT EXISTS idx_payments_loan_id ON payments(loan_id);
CREATE INDEX IF NOT EXISTS idx_payments_payment_date ON payments(payment_date);
CREATE INDEX IF NOT EXISTS idx_payments_created_by ON payments(created_by);

-- Índices para parcelamentos
CREATE INDEX IF NOT EXISTS idx_installments_client_id ON installments(client_id);
CREATE INDEX IF NOT EXISTS idx_installments_status ON installments(status);
CREATE INDEX IF NOT EXISTS idx_installments_start_date ON installments(start_date);

-- Índices para parcelas
CREATE INDEX IF NOT EXISTS idx_installment_items_installment_id ON installment_items(installment_id);
CREATE INDEX IF NOT EXISTS idx_installment_items_status ON installment_items(status);
CREATE INDEX IF NOT EXISTS idx_installment_items_due_date ON installment_items(due_date);

-- Índices para pagamentos de parcelas
CREATE INDEX IF NOT EXISTS idx_installment_payments_item_id ON installment_payments(installment_item_id);
CREATE INDEX IF NOT EXISTS idx_installment_payments_payment_date ON installment_payments(payment_date);

-- Índices para despesas
CREATE INDEX IF NOT EXISTS idx_expenses_user_id ON expenses(user_id);
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date);
CREATE INDEX IF NOT EXISTS idx_expenses_category ON expenses(category);

-- Índices para comissões
CREATE INDEX IF NOT EXISTS idx_commissions_user_id ON commissions(user_id);
CREATE INDEX IF NOT EXISTS idx_commissions_status ON commissions(status);
CREATE INDEX IF NOT EXISTS idx_commissions_created_at ON commissions(created_at);

-- Índices para captação de capital
CREATE INDEX IF NOT EXISTS idx_capital_raising_status ON capital_raising(status);
CREATE INDEX IF NOT EXISTS idx_capital_raising_maturity_date ON capital_raising(maturity_date);

-- Índices para pagamentos de investidores
CREATE INDEX IF NOT EXISTS idx_investor_payments_capital_id ON investor_payments(capital_raising_id);
CREATE INDEX IF NOT EXISTS idx_investor_payments_payment_date ON investor_payments(payment_date);

-- Índices para gestão de caixa
CREATE INDEX IF NOT EXISTS idx_cash_management_transaction_date ON cash_management(transaction_date);
CREATE INDEX IF NOT EXISTS idx_cash_management_transaction_type ON cash_management(transaction_type);
CREATE INDEX IF NOT EXISTS idx_cash_management_category ON cash_management(category);

-- =====================================================
-- FUNÇÕES E TRIGGERS
-- =====================================================

-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para atualizar updated_at
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_clients_updated_at 
    BEFORE UPDATE ON clients 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_emergency_contacts_updated_at 
    BEFORE UPDATE ON emergency_contacts 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_pix_keys_updated_at 
    BEFORE UPDATE ON pix_keys 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_guarantors_updated_at 
    BEFORE UPDATE ON guarantors 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_loans_updated_at 
    BEFORE UPDATE ON loans 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_installments_updated_at 
    BEFORE UPDATE ON installments 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_installment_items_updated_at 
    BEFORE UPDATE ON installment_items 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_expenses_updated_at 
    BEFORE UPDATE ON expenses 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_expense_categories_updated_at 
    BEFORE UPDATE ON expense_categories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_commissions_updated_at 
    BEFORE UPDATE ON commissions 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_capital_raising_updated_at 
    BEFORE UPDATE ON capital_raising 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_cash_management_updated_at 
    BEFORE UPDATE ON cash_management 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- VIEWS ÚTEIS
-- =====================================================

-- View para empréstimos com informações do cliente
CREATE OR REPLACE VIEW loans_with_details AS
SELECT 
    l.*,
    c.name as client_name,
    c.cpf as client_cpf,
    c.email as client_email,
    c.phone as client_phone,
    c.photo as client_photo,
    u.full_name as created_by_name,
    u.role as created_by_role
FROM loans l
JOIN clients c ON l.client_id = c.id
LEFT JOIN users u ON l.created_by = u.id;

-- View para empréstimos vencidos
CREATE OR REPLACE VIEW overdue_loans AS
SELECT 
    l.*,
    c.name as client_name,
    c.cpf as client_cpf,
    c.email as client_email,
    c.phone as client_phone,
    CURRENT_DATE - l.due_date as days_overdue
FROM loans l
JOIN clients c ON l.client_id = c.id
WHERE l.due_date < CURRENT_DATE AND l.status NOT IN ('paid', 'cancelled');

-- View para resumo financeiro
CREATE OR REPLACE VIEW financial_summary AS
SELECT 
    COUNT(DISTINCT c.id) as total_clients,
    COUNT(l.id) as total_loans,
    SUM(l.amount) as total_loaned,
    SUM(l.total_amount - l.amount) as total_interest,
    SUM(l.total_amount) as total_with_interest,
    COUNT(CASE WHEN l.status = 'active' THEN 1 END) as active_loans,
    COUNT(CASE WHEN l.status = 'overdue' THEN 1 END) as overdue_loans,
    COUNT(CASE WHEN l.status = 'paid' THEN 1 END) as paid_loans
FROM clients c
LEFT JOIN loans l ON c.id = l.client_id;

-- View para parcelamentos com detalhes
CREATE OR REPLACE VIEW installments_with_details AS
SELECT 
    i.*,
    c.name as client_name,
    c.cpf as client_cpf,
    c.phone as client_phone,
    u.full_name as created_by_name
FROM installments i
JOIN clients c ON i.client_id = c.id
LEFT JOIN users u ON i.created_by = u.id;

-- View para resumo de caixa
CREATE OR REPLACE VIEW cash_summary AS
SELECT 
    SUM(CASE WHEN transaction_type = 'entrada' THEN amount ELSE 0 END) as total_income,
    SUM(CASE WHEN transaction_type = 'saida' THEN amount ELSE 0 END) as total_expenses,
    SUM(CASE WHEN transaction_type = 'entrada' THEN amount ELSE -amount END) as balance
FROM cash_management;

-- =====================================================
-- REMOVER RLS (Row Level Security)
-- =====================================================
-- Para facilitar o uso com aplicações que não usam auth do Supabase
-- As políticas serão gerenciadas pela aplicação

ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE clients DISABLE ROW LEVEL SECURITY;
ALTER TABLE emergency_contacts DISABLE ROW LEVEL SECURITY;
ALTER TABLE client_documents DISABLE ROW LEVEL SECURITY;
ALTER TABLE pix_keys DISABLE ROW LEVEL SECURITY;
ALTER TABLE guarantors DISABLE ROW LEVEL SECURITY;
ALTER TABLE loans DISABLE ROW LEVEL SECURITY;
ALTER TABLE payments DISABLE ROW LEVEL SECURITY;
ALTER TABLE installments DISABLE ROW LEVEL SECURITY;
ALTER TABLE installment_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE installment_payments DISABLE ROW LEVEL SECURITY;
ALTER TABLE expenses DISABLE ROW LEVEL SECURITY;
ALTER TABLE expense_categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE commissions DISABLE ROW LEVEL SECURITY;
ALTER TABLE capital_raising DISABLE ROW LEVEL SECURITY;
ALTER TABLE investor_payments DISABLE ROW LEVEL SECURITY;
ALTER TABLE cash_management DISABLE ROW LEVEL SECURITY;

-- =====================================================
-- FUNÇÃO PARA CRIAR USUÁRIO INICIAL
-- =====================================================

-- Função para criar usuário admin inicial
CREATE OR REPLACE FUNCTION create_initial_admin()
RETURNS void AS $$
BEGIN
    -- Inserir usuário admin padrão
    INSERT INTO users (email, password_hash, full_name, role, is_active)
    VALUES (
        'admin@brunoassoni.com',
        '1020',
        'Administrador Bruno Assoni',
        'admin',
        true
    )
    ON CONFLICT (email) DO NOTHING;
    
    -- Inserir usuário Bruno Assoni
    INSERT INTO users (email, password_hash, full_name, role, is_active)
    VALUES (
        'bruno@assoni.com',
        '1020',
        'Bruno Assoni',
        'admin',
        true
    )
    ON CONFLICT (email) DO NOTHING;
    
    RAISE NOTICE 'Usuários admin criados com sucesso!';
END;
$$ LANGUAGE plpgsql;

-- Executar função para criar admins iniciais
SELECT create_initial_admin();

-- =====================================================
-- DADOS DE EXEMPLO (OPCIONAL)
-- =====================================================

-- Inserir clientes de exemplo
INSERT INTO clients (name, cpf, email, phone, address, created_by) VALUES
('Cliente Exemplo 1', '123.456.789-00', 'cliente1@email.com', '(11) 99999-9999', 'Rua Exemplo, 123', 
 (SELECT id FROM users WHERE email = 'admin@brunoassoni.com' LIMIT 1)),
('Cliente Exemplo 2', '987.654.321-00', 'cliente2@email.com', '(11) 88888-8888', 'Av. Exemplo, 456',
 (SELECT id FROM users WHERE email = 'admin@brunoassoni.com' LIMIT 1))
ON CONFLICT (cpf) DO NOTHING;

-- Inserir chave PIX de exemplo
INSERT INTO pix_keys (bank_name, key_type, pix_key, account_holder) VALUES
('Banco Exemplo', 'email', 'contato@brunoassoni.com', 'Bruno Assoni System')
ON CONFLICT DO NOTHING;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar se as tabelas foram criadas
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Verificar usuários criados
SELECT id, email, full_name, role, is_active, created_at 
FROM users 
WHERE role = 'admin';

-- Contar registros
SELECT 
    'users' as tabela, COUNT(*) as registros FROM users
UNION ALL
SELECT 'clients', COUNT(*) FROM clients
UNION ALL
SELECT 'loans', COUNT(*) FROM loans
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'installments', COUNT(*) FROM installments
UNION ALL
SELECT 'expenses', COUNT(*) FROM expenses
UNION ALL
SELECT 'expense_categories', COUNT(*) FROM expense_categories
UNION ALL
SELECT 'pix_keys', COUNT(*) FROM pix_keys;

-- =====================================================
-- FIM DA CONFIGURAÇÃO - BRUNO ASSONI SYSTEM
-- =====================================================
-- 
-- INSTRUÇÕES DE USO:
-- 1. Acesse: https://pebwoerzslfzhjptyjwh.supabase.co
-- 2. Vá no SQL Editor
-- 3. Cole todo o conteúdo deste arquivo
-- 4. Clique em "Run" para executar
-- 5. Verifique se não há erros
-- 6. Confirme que as tabelas foram criadas
--
-- USUÁRIOS ADMIN CRIADOS:
-- Email: admin@brunoassoni.com | Senha: 1020
-- Email: bruno@assoni.com | Senha: 1020
--
-- COMO ACESSAR O SISTEMA:
-- 1. Abra a aplicação Nexus
-- 2. Clique 3 vezes em "Bruno Assoni" na tela de login
-- 3. Ou selecione "BRUNO ASSONI SYSTEM" no dropdown de empresas
-- 4. Faça login com um dos usuários acima
-- =====================================================
