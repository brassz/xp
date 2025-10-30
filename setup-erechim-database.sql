-- =====================================================
-- NEXUS GESTÃO FINANCEIRA - BANCO DE DADOS ERECHIM
-- =====================================================
-- Script de configuração completa para a empresa ERECHIM
-- 
-- INSTRUÇÕES DE USO:
-- 1. Acesse https://adjrvtupfshdhwjvhmgj.supabase.co
-- 2. Faça login no painel do Supabase
-- 3. Vá em "SQL Editor" no menu lateral
-- 4. Cole este script completo
-- 5. Clique em "Run" para executar
-- 6. Aguarde a conclusão (pode levar alguns minutos)
-- 7. Verifique se não há erros
-- 
-- CREDENCIAIS:
-- - URL: https://adjrvtupfshdhwjvhmgj.supabase.co
-- - Anon Key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFkanJ2dHVwZnNoZGh3anZobWdqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc2MDAyMDUsImV4cCI6MjA3MzE3NjIwNX0.iSl7bECBz8yl5HHcBwL6gp5Pd5Y06nNFWgLTzvLgVSY
-- =====================================================

-- =====================================================
-- EXTENSÕES NECESSÁRIAS
-- =====================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABELAS PRINCIPAIS
-- =====================================================

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
    rg TEXT,
    birth_date DATE,
    photo TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela
COMMENT ON TABLE clients IS 'Tabela para armazenar informações dos clientes';
COMMENT ON COLUMN clients.id IS 'Identificador único do cliente';
COMMENT ON COLUMN clients.name IS 'Nome completo do cliente';
COMMENT ON COLUMN clients.cpf IS 'CPF único do cliente';
COMMENT ON COLUMN clients.email IS 'Email do cliente';
COMMENT ON COLUMN clients.phone IS 'Telefone do cliente';
COMMENT ON COLUMN clients.address IS 'Endereço do cliente';
COMMENT ON COLUMN clients.rg IS 'RG (Registro Geral) do cliente';
COMMENT ON COLUMN clients.birth_date IS 'Data de nascimento do cliente';
COMMENT ON COLUMN clients.photo IS 'URL da foto do cliente (Uploadcare)';
COMMENT ON COLUMN clients.created_by IS 'Usuário que criou o cliente';
COMMENT ON COLUMN clients.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN clients.updated_at IS 'Data da última atualização';

-- =====================================================
-- TABELA DE EMPRÉSTIMOS
-- =====================================================
CREATE TABLE IF NOT EXISTS loans (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    interest_rate DECIMAL(5,2) NOT NULL CHECK (interest_rate >= 0),
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'overdue', 'paid', 'partial_paid', 'cancelled')),
    total_amount DECIMAL(10,2) GENERATED ALWAYS AS (amount + (amount * interest_rate / 100)) STORED,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela
COMMENT ON TABLE loans IS 'Tabela para armazenar informações dos empréstimos';
COMMENT ON COLUMN loans.id IS 'Identificador único do empréstimo';
COMMENT ON COLUMN loans.client_id IS 'Referência ao cliente';
COMMENT ON COLUMN loans.amount IS 'Valor principal do empréstimo';
COMMENT ON COLUMN loans.interest_rate IS 'Taxa de juros em porcentagem';
COMMENT ON COLUMN loans.loan_date IS 'Data em que o empréstimo foi realizado';
COMMENT ON COLUMN loans.due_date IS 'Data de vencimento do empréstimo';
COMMENT ON COLUMN loans.status IS 'Status atual do empréstimo';
COMMENT ON COLUMN loans.total_amount IS 'Valor total com juros (calculado automaticamente)';
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
    payment_type TEXT DEFAULT 'partial' CHECK (payment_type IN ('partial', 'full')),
    notes TEXT,
    fine DECIMAL(10,2) DEFAULT 0,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela
COMMENT ON TABLE payments IS 'Tabela para armazenar histórico de pagamentos';
COMMENT ON COLUMN payments.id IS 'Identificador único do pagamento';
COMMENT ON COLUMN payments.loan_id IS 'Referência ao empréstimo';
COMMENT ON COLUMN payments.amount IS 'Valor do pagamento';
COMMENT ON COLUMN payments.payment_date IS 'Data do pagamento';
COMMENT ON COLUMN payments.payment_type IS 'Tipo do pagamento (parcial ou total)';
COMMENT ON COLUMN payments.notes IS 'Observações sobre o pagamento';
COMMENT ON COLUMN payments.fine IS 'Valor da multa aplicada';
COMMENT ON COLUMN payments.created_by IS 'Usuário que registrou o pagamento';
COMMENT ON COLUMN payments.created_at IS 'Data de criação do registro';

-- =====================================================
-- TABELAS AUXILIARES
-- =====================================================

-- =====================================================
-- TABELA DE AVALISTAS
-- =====================================================
CREATE TABLE IF NOT EXISTS guarantors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    cpf TEXT NOT NULL,
    rg TEXT,
    email TEXT,
    phone TEXT NOT NULL,
    address TEXT,
    birth_date DATE,
    relationship TEXT,
    photo TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE guarantors IS 'Tabela para armazenar informações dos avalistas dos clientes';

-- =====================================================
-- TABELA DE CONTATOS DE EMERGÊNCIA
-- =====================================================
CREATE TABLE IF NOT EXISTS emergency_contacts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE emergency_contacts IS 'Tabela para armazenar contatos de emergência dos clientes';

-- =====================================================
-- TABELA DE DOCUMENTOS DOS CLIENTES
-- =====================================================
CREATE TABLE IF NOT EXISTS client_documents (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL CHECK (category IN ('identificacao', 'comprovante_renda', 'comprovante_residencia', 'referencias', 'outros')),
    file_path TEXT NOT NULL,
    file_type VARCHAR(100),
    file_size INTEGER,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

COMMENT ON TABLE client_documents IS 'Tabela para armazenar documentos dos clientes';

-- =====================================================
-- TABELA DE CATEGORIAS DE DESPESAS
-- =====================================================
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

COMMENT ON TABLE expense_categories IS 'Tabela para armazenar categorias de despesas';

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

COMMENT ON TABLE expenses IS 'Tabela para armazenar despesas do sistema';

-- =====================================================
-- TABELA DE PARCELAMENTOS
-- =====================================================
CREATE TABLE IF NOT EXISTS installments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    loan_id UUID REFERENCES loans(id) ON DELETE CASCADE,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    total_amount DECIMAL(15,2) NOT NULL,
    total_installments INTEGER NOT NULL CHECK (total_installments > 0),
    installment_amount DECIMAL(15,2) NOT NULL,
    first_due_date DATE NOT NULL,
    interest_rate DECIMAL(5,2) DEFAULT 0.00,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE installments IS 'Tabela para armazenar planos de parcelamento - pode ser vinculado a empréstimos ou independente';
COMMENT ON COLUMN installments.loan_id IS 'Referência ao empréstimo original (opcional - pode ser NULL para parcelamentos independentes)';

-- =====================================================
-- TABELA DE PARCELAS INDIVIDUAIS
-- =====================================================
CREATE TABLE IF NOT EXISTS installment_payments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    installment_id UUID NOT NULL REFERENCES installments(id) ON DELETE CASCADE,
    installment_number INTEGER NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    due_date DATE NOT NULL,
    paid_date DATE,
    paid_amount DECIMAL(15,2) DEFAULT 0.00,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'overdue', 'partial')),
    payment_method TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(installment_id, installment_number)
);

COMMENT ON TABLE installment_payments IS 'Tabela para armazenar cada parcela individual de um parcelamento';

-- =====================================================
-- TABELA DE TRANSAÇÕES DE CAIXA
-- =====================================================
CREATE TABLE IF NOT EXISTS cash_transactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('deposit', 'withdrawal')),
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    description TEXT,
    reference_id UUID,
    reference_type TEXT CHECK (reference_type IN ('loan', 'expense', 'manual', 'installment')),
    balance_after DECIMAL(15,2) NOT NULL,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE cash_transactions IS 'Tabela para registrar todas as transações de entrada e saída de dinheiro do caixa';

-- =====================================================
-- TABELA DE CONFIGURAÇÃO DO CAIXA
-- =====================================================
CREATE TABLE IF NOT EXISTS cash_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    current_balance DECIMAL(15,2) DEFAULT 0 NOT NULL,
    initial_balance DECIMAL(15,2) DEFAULT 0 NOT NULL,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_by UUID REFERENCES users(id)
);

COMMENT ON TABLE cash_settings IS 'Tabela para armazenar as configurações e saldo atual do caixa';

-- =====================================================
-- TABELA DE LEVANTAMENTO DE CAPITAL
-- =====================================================
CREATE TABLE IF NOT EXISTS capital_raising (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    valor_bruto DECIMAL(15,2) NOT NULL,
    taxa_juros DECIMAL(5,2) NOT NULL DEFAULT 0,
    valor_total DECIMAL(15,2) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    data_baixa TIMESTAMP NULL,
    motivo_baixa TEXT,
    observacoes TEXT,
    user_id VARCHAR(255) NOT NULL
);

COMMENT ON TABLE capital_raising IS 'Tabela para gerenciar levantamentos de capital independente de empréstimos';

-- =====================================================
-- TABELA DE CLIENTES DO LEVANTAMENTO DE CAPITAL
-- =====================================================
CREATE TABLE IF NOT EXISTS capital_raising_clients (
    id SERIAL PRIMARY KEY,
    capital_raising_id INTEGER NOT NULL,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14),
    telefone VARCHAR(20),
    email VARCHAR(255),
    valor_individual DECIMAL(15,2) NOT NULL,
    data_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observacoes TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (capital_raising_id) REFERENCES capital_raising(id) ON DELETE CASCADE
);

COMMENT ON TABLE capital_raising_clients IS 'Tabela para clientes vinculados a um levantamento de capital específico';

-- =====================================================
-- TABELAS DE STATUS DE EMPRÉSTIMOS
-- =====================================================

-- Tabela para empréstimos quitados
CREATE TABLE IF NOT EXISTS paid_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID NOT NULL,
    client_id UUID NOT NULL,
    original_amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    total_with_interest DECIMAL(10,2) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    paid_date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_paid DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    notes TEXT,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE paid_loans IS 'Tabela para empréstimos completamente quitados';

-- Tabela para empréstimos vencidos
CREATE TABLE IF NOT EXISTS overdue_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID NOT NULL,
    client_id UUID NOT NULL,
    original_amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    total_with_interest DECIMAL(10,2) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    days_overdue INTEGER NOT NULL DEFAULT 0,
    remaining_amount DECIMAL(10,2) NOT NULL,
    total_paid DECIMAL(10,2) DEFAULT 0,
    last_payment_date DATE,
    collection_notes TEXT,
    collection_status VARCHAR(50) DEFAULT 'pending',
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE overdue_loans IS 'Tabela para empréstimos vencidos em processo de cobrança';

-- Tabela para empréstimos parcelados
CREATE TABLE IF NOT EXISTS partial_paid_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID NOT NULL,
    client_id UUID NOT NULL,
    original_amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    total_with_interest DECIMAL(10,2) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    total_paid DECIMAL(10,2) NOT NULL DEFAULT 0,
    remaining_amount DECIMAL(10,2) NOT NULL,
    payment_count INTEGER DEFAULT 0,
    last_payment_date DATE,
    next_payment_date DATE,
    payment_schedule TEXT,
    installment_amount DECIMAL(10,2),
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE partial_paid_loans IS 'Tabela para empréstimos com pagamentos parciais';

-- Tabela para empréstimos cancelados
CREATE TABLE IF NOT EXISTS cancelled_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID NOT NULL,
    client_id UUID NOT NULL,
    original_amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    total_with_interest DECIMAL(10,2) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    cancellation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    cancellation_reason TEXT NOT NULL,
    total_paid_before_cancellation DECIMAL(10,2) DEFAULT 0,
    refund_amount DECIMAL(10,2) DEFAULT 0,
    cancellation_fee DECIMAL(10,2) DEFAULT 0,
    cancelled_by UUID,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE cancelled_loans IS 'Tabela para empréstimos cancelados';

-- =====================================================
-- TABELA DE CHAVES PIX DOS CLIENTES
-- =====================================================
CREATE TABLE IF NOT EXISTS client_pix_keys (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    pix_key_type TEXT NOT NULL CHECK (pix_key_type IN ('cpf', 'email', 'phone', 'random')),
    pix_key_value TEXT NOT NULL,
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(client_id, pix_key_value)
);

COMMENT ON TABLE client_pix_keys IS 'Tabela para armazenar chaves PIX dos clientes';
COMMENT ON COLUMN client_pix_keys.pix_key_type IS 'Tipo da chave PIX (cpf, email, phone, random)';
COMMENT ON COLUMN client_pix_keys.pix_key_value IS 'Valor da chave PIX';
COMMENT ON COLUMN client_pix_keys.is_primary IS 'Indica se é a chave PIX principal do cliente';

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
CREATE INDEX IF NOT EXISTS idx_clients_created_at ON clients(created_at);
CREATE INDEX IF NOT EXISTS idx_clients_created_by ON clients(created_by);

-- Índices para empréstimos
CREATE INDEX IF NOT EXISTS idx_loans_client_id ON loans(client_id);
CREATE INDEX IF NOT EXISTS idx_loans_status ON loans(status);
CREATE INDEX IF NOT EXISTS idx_loans_due_date ON loans(due_date);
CREATE INDEX IF NOT EXISTS idx_loans_created_at ON loans(created_at);
CREATE INDEX IF NOT EXISTS idx_loans_created_by ON loans(created_by);

-- Índices para pagamentos
CREATE INDEX IF NOT EXISTS idx_payments_loan_id ON payments(loan_id);
CREATE INDEX IF NOT EXISTS idx_payments_payment_date ON payments(payment_date);
CREATE INDEX IF NOT EXISTS idx_payments_created_by ON payments(created_by);

-- Índices para avalistas
CREATE INDEX IF NOT EXISTS idx_guarantors_client_id ON guarantors(client_id);
CREATE INDEX IF NOT EXISTS idx_guarantors_cpf ON guarantors(cpf);
CREATE INDEX IF NOT EXISTS idx_guarantors_created_at ON guarantors(created_at);

-- Índices para contatos de emergência
CREATE INDEX IF NOT EXISTS idx_emergency_contacts_client_id ON emergency_contacts(client_id);
CREATE INDEX IF NOT EXISTS idx_emergency_contacts_phone ON emergency_contacts(phone);
CREATE INDEX IF NOT EXISTS idx_emergency_contacts_created_at ON emergency_contacts(created_at);

-- Índices para documentos
CREATE INDEX IF NOT EXISTS idx_client_documents_client_id ON client_documents(client_id);
CREATE INDEX IF NOT EXISTS idx_client_documents_category ON client_documents(category);
CREATE INDEX IF NOT EXISTS idx_client_documents_created_at ON client_documents(created_at);

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
CREATE INDEX IF NOT EXISTS idx_expenses_user_date ON expenses(user_id, expense_date DESC);
CREATE INDEX IF NOT EXISTS idx_expenses_category_date ON expenses(category_id, expense_date DESC);

-- Índices para parcelamentos
CREATE INDEX IF NOT EXISTS idx_installments_loan_id ON installments(loan_id);
CREATE INDEX IF NOT EXISTS idx_installments_client_id ON installments(client_id);
CREATE INDEX IF NOT EXISTS idx_installments_status ON installments(status);
CREATE INDEX IF NOT EXISTS idx_installments_created_at ON installments(created_at);

-- Índices para parcelas
CREATE INDEX IF NOT EXISTS idx_installment_payments_installment_id ON installment_payments(installment_id);
CREATE INDEX IF NOT EXISTS idx_installment_payments_due_date ON installment_payments(due_date);
CREATE INDEX IF NOT EXISTS idx_installment_payments_status ON installment_payments(status);
CREATE INDEX IF NOT EXISTS idx_installment_payments_paid_date ON installment_payments(paid_date);

-- Índices para transações de caixa
CREATE INDEX IF NOT EXISTS idx_cash_transactions_type ON cash_transactions(transaction_type);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_date ON cash_transactions(created_at);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_user ON cash_transactions(created_by);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_reference ON cash_transactions(reference_id, reference_type);

-- Índices para levantamento de capital
CREATE INDEX IF NOT EXISTS idx_capital_raising_user_id ON capital_raising(user_id);
CREATE INDEX IF NOT EXISTS idx_capital_raising_ativo ON capital_raising(ativo);
CREATE INDEX IF NOT EXISTS idx_capital_raising_clients_capital_id ON capital_raising_clients(capital_raising_id);
CREATE INDEX IF NOT EXISTS idx_capital_raising_clients_ativo ON capital_raising_clients(ativo);

-- Índices para tabelas de status de empréstimos
CREATE INDEX IF NOT EXISTS idx_paid_loans_loan_id ON paid_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_client_id ON paid_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_paid_date ON paid_loans(paid_date);

CREATE INDEX IF NOT EXISTS idx_overdue_loans_loan_id ON overdue_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_overdue_loans_client_id ON overdue_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_overdue_loans_days_overdue ON overdue_loans(days_overdue);
CREATE INDEX IF NOT EXISTS idx_overdue_loans_collection_status ON overdue_loans(collection_status);

CREATE INDEX IF NOT EXISTS idx_partial_paid_loans_loan_id ON partial_paid_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_partial_paid_loans_client_id ON partial_paid_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_partial_paid_loans_next_payment_date ON partial_paid_loans(next_payment_date);

CREATE INDEX IF NOT EXISTS idx_cancelled_loans_loan_id ON cancelled_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_cancelled_loans_client_id ON cancelled_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_cancelled_loans_cancellation_date ON cancelled_loans(cancellation_date);

-- Índices para chaves PIX
CREATE INDEX IF NOT EXISTS idx_client_pix_keys_client_id ON client_pix_keys(client_id);
CREATE INDEX IF NOT EXISTS idx_client_pix_keys_type ON client_pix_keys(pix_key_type);
CREATE INDEX IF NOT EXISTS idx_client_pix_keys_primary ON client_pix_keys(client_id, is_primary);

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

CREATE TRIGGER update_loans_updated_at 
    BEFORE UPDATE ON loans 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_guarantors_updated_at_trigger
    BEFORE UPDATE ON guarantors
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_emergency_contacts_updated_at_trigger
    BEFORE UPDATE ON emergency_contacts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_client_documents_updated_at
    BEFORE UPDATE ON client_documents
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_expense_categories_updated_at 
    BEFORE UPDATE ON expense_categories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_expenses_updated_at 
    BEFORE UPDATE ON expenses 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_installments_updated_at
    BEFORE UPDATE ON installments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_installment_payments_updated_at
    BEFORE UPDATE ON installment_payments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_client_pix_keys_updated_at
    BEFORE UPDATE ON client_pix_keys
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger para levantamento de capital
CREATE OR REPLACE FUNCTION update_capital_raising_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.data_atualizacao = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_capital_raising_timestamp 
    BEFORE UPDATE ON capital_raising 
    FOR EACH ROW EXECUTE FUNCTION update_capital_raising_timestamp();

-- Função para atualizar status de parcelamento
CREATE OR REPLACE FUNCTION update_installment_status()
RETURNS TRIGGER AS $$
DECLARE
    total_parcelas INTEGER;
    parcelas_pagas INTEGER;
BEGIN
    SELECT 
        i.total_installments,
        COUNT(CASE WHEN ip.status = 'paid' THEN 1 END)
    INTO total_parcelas, parcelas_pagas
    FROM installments i
    LEFT JOIN installment_payments ip ON i.id = ip.installment_id
    WHERE i.id = NEW.installment_id
    GROUP BY i.total_installments;
    
    IF parcelas_pagas = total_parcelas THEN
        UPDATE installments 
        SET status = 'completed', updated_at = NOW()
        WHERE id = NEW.installment_id;
    ELSIF parcelas_pagas > 0 THEN
        UPDATE installments 
        SET status = 'active', updated_at = NOW()
        WHERE id = NEW.installment_id;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER trigger_update_installment_status
    AFTER INSERT OR UPDATE ON installment_payments
    FOR EACH ROW
    EXECUTE FUNCTION update_installment_status();

-- Função para atualizar saldo do caixa
CREATE OR REPLACE FUNCTION update_cash_balance()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE cash_settings 
    SET current_balance = NEW.balance_after,
        last_updated = NOW(),
        updated_by = NEW.created_by
    WHERE id = (SELECT id FROM cash_settings LIMIT 1);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_cash_balance
    AFTER INSERT ON cash_transactions
    FOR EACH ROW
    EXECUTE FUNCTION update_cash_balance();

-- =====================================================
-- TRIGGERS PARA TABELAS DE STATUS DE EMPRÉSTIMOS
-- =====================================================

-- Trigger para inserir empréstimos quitados
CREATE OR REPLACE FUNCTION insert_paid_loan()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'paid' AND (OLD IS NULL OR OLD.status != 'paid') THEN
        INSERT INTO paid_loans (
            loan_id, client_id, original_amount, interest_rate, 
            total_with_interest, loan_date, due_date, total_paid,
            created_by
        ) VALUES (
            NEW.id, NEW.client_id, NEW.amount, NEW.interest_rate,
            NEW.amount + (NEW.amount * NEW.interest_rate / 100),
            NEW.loan_date, NEW.due_date, 
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            NEW.created_by
        ) ON CONFLICT (loan_id) DO NOTHING;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_paid_loan
    AFTER INSERT OR UPDATE ON loans
    FOR EACH ROW
    EXECUTE FUNCTION insert_paid_loan();

-- Trigger para inserir empréstimos vencidos
CREATE OR REPLACE FUNCTION insert_overdue_loan()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.due_date < CURRENT_DATE AND NEW.status NOT IN ('paid', 'cancelled') THEN
        INSERT INTO overdue_loans (
            loan_id, client_id, original_amount, interest_rate,
            total_with_interest, loan_date, due_date, days_overdue,
            remaining_amount, total_paid, created_by
        ) VALUES (
            NEW.id, NEW.client_id, NEW.amount, NEW.interest_rate,
            NEW.amount + (NEW.amount * NEW.interest_rate / 100),
            NEW.loan_date, NEW.due_date,
            CURRENT_DATE - NEW.due_date,
            (NEW.amount + (NEW.amount * NEW.interest_rate / 100)) - 
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            NEW.created_by
        )
        ON CONFLICT (loan_id) DO UPDATE SET
            days_overdue = CURRENT_DATE - NEW.due_date,
            remaining_amount = (NEW.amount + (NEW.amount * NEW.interest_rate / 100)) - 
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            total_paid = COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_overdue_loan
    AFTER INSERT OR UPDATE ON loans
    FOR EACH ROW
    EXECUTE FUNCTION insert_overdue_loan();

-- Trigger para inserir empréstimos parcelados
CREATE OR REPLACE FUNCTION insert_partial_paid_loan()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'partial_paid' AND (OLD IS NULL OR OLD.status != 'partial_paid') THEN
        INSERT INTO partial_paid_loans (
            loan_id, client_id, original_amount, interest_rate,
            total_with_interest, loan_date, due_date, total_paid,
            remaining_amount, payment_count, last_payment_date, created_by
        ) VALUES (
            NEW.id, NEW.client_id, NEW.amount, NEW.interest_rate,
            NEW.amount + (NEW.amount * NEW.interest_rate / 100),
            NEW.loan_date, NEW.due_date,
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            (NEW.amount + (NEW.amount * NEW.interest_rate / 100)) - 
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            (SELECT COUNT(*) FROM payments WHERE loan_id = NEW.id),
            (SELECT MAX(payment_date) FROM payments WHERE loan_id = NEW.id),
            NEW.created_by
        )
        ON CONFLICT (loan_id) DO UPDATE SET
            total_paid = COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            remaining_amount = (NEW.amount + (NEW.amount * NEW.interest_rate / 100)) - 
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            payment_count = (SELECT COUNT(*) FROM payments WHERE loan_id = NEW.id),
            last_payment_date = (SELECT MAX(payment_date) FROM payments WHERE loan_id = NEW.id),
            updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_partial_paid_loan
    AFTER INSERT OR UPDATE ON loans
    FOR EACH ROW
    EXECUTE FUNCTION insert_partial_paid_loan();

-- Trigger para inserir empréstimos cancelados
CREATE OR REPLACE FUNCTION insert_cancelled_loan()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'cancelled' AND (OLD IS NULL OR OLD.status != 'cancelled') THEN
        INSERT INTO cancelled_loans (
            loan_id, client_id, original_amount, interest_rate,
            total_with_interest, loan_date, due_date, total_paid_before_cancellation,
            created_by, cancellation_reason
        ) VALUES (
            NEW.id, NEW.client_id, NEW.amount, NEW.interest_rate,
            NEW.amount + (NEW.amount * NEW.interest_rate / 100),
            NEW.loan_date, NEW.due_date,
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            NEW.created_by, 'Cancelamento automático'
        ) ON CONFLICT (loan_id) DO NOTHING;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_cancelled_loan
    AFTER INSERT OR UPDATE ON loans
    FOR EACH ROW
    EXECUTE FUNCTION insert_cancelled_loan();

-- Função para limpar registros antigos quando o status muda
CREATE OR REPLACE FUNCTION cleanup_loan_status_tables()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status IN ('paid', 'cancelled') THEN
        DELETE FROM overdue_loans WHERE loan_id = NEW.id;
    END IF;
    
    IF NEW.status IN ('paid', 'cancelled') THEN
        DELETE FROM partial_paid_loans WHERE loan_id = NEW.id;
    END IF;
    
    IF NEW.status = 'cancelled' THEN
        DELETE FROM paid_loans WHERE loan_id = NEW.id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_cleanup_loan_status_tables
    AFTER UPDATE ON loans
    FOR EACH ROW
    EXECUTE FUNCTION cleanup_loan_status_tables();

-- =====================================================
-- FOREIGN KEYS PARA TABELAS DE STATUS
-- =====================================================

-- Foreign keys para paid_loans
ALTER TABLE paid_loans 
ADD CONSTRAINT fk_paid_loans_loan_id 
FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;

ALTER TABLE paid_loans 
ADD CONSTRAINT fk_paid_loans_client_id 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;

ALTER TABLE paid_loans 
ADD CONSTRAINT fk_paid_loans_created_by 
FOREIGN KEY (created_by) REFERENCES users(id);

-- Foreign keys para overdue_loans
ALTER TABLE overdue_loans 
ADD CONSTRAINT fk_overdue_loans_loan_id 
FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;

ALTER TABLE overdue_loans 
ADD CONSTRAINT fk_overdue_loans_client_id 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;

ALTER TABLE overdue_loans 
ADD CONSTRAINT fk_overdue_loans_created_by 
FOREIGN KEY (created_by) REFERENCES users(id);

-- Foreign keys para partial_paid_loans
ALTER TABLE partial_paid_loans 
ADD CONSTRAINT fk_partial_paid_loans_loan_id 
FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;

ALTER TABLE partial_paid_loans 
ADD CONSTRAINT fk_partial_paid_loans_client_id 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;

ALTER TABLE partial_paid_loans 
ADD CONSTRAINT fk_partial_paid_loans_created_by 
FOREIGN KEY (created_by) REFERENCES users(id);

-- Foreign keys para cancelled_loans
ALTER TABLE cancelled_loans 
ADD CONSTRAINT fk_cancelled_loans_loan_id 
FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;

ALTER TABLE cancelled_loans 
ADD CONSTRAINT fk_cancelled_loans_client_id 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;

ALTER TABLE cancelled_loans 
ADD CONSTRAINT fk_cancelled_loans_cancelled_by 
FOREIGN KEY (cancelled_by) REFERENCES users(id);

ALTER TABLE cancelled_loans 
ADD CONSTRAINT fk_cancelled_loans_created_by 
FOREIGN KEY (created_by) REFERENCES users(id);

-- Adicionar constraint única para loan_id nas tabelas de status
ALTER TABLE paid_loans ADD CONSTRAINT unique_paid_loan_id UNIQUE (loan_id);
ALTER TABLE overdue_loans ADD CONSTRAINT unique_overdue_loan_id UNIQUE (loan_id);
ALTER TABLE partial_paid_loans ADD CONSTRAINT unique_partial_paid_loan_id UNIQUE (loan_id);
ALTER TABLE cancelled_loans ADD CONSTRAINT unique_cancelled_loan_id UNIQUE (loan_id);

-- =====================================================
-- VIEWS ÚTEIS
-- =====================================================

-- View para empréstimos com informações do cliente e usuário
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

-- View para usuários ativos
CREATE OR REPLACE VIEW active_users AS
SELECT 
    id,
    email,
    full_name,
    role,
    last_login,
    created_at
FROM users
WHERE is_active = true
ORDER BY last_login DESC NULLS LAST;

-- View para contatos de emergência com informações do cliente
CREATE OR REPLACE VIEW emergency_contacts_with_client AS
SELECT 
    ec.*,
    c.name as client_name,
    c.cpf as client_cpf,
    c.email as client_email,
    c.phone as client_phone,
    u.full_name as created_by_name
FROM emergency_contacts ec
JOIN clients c ON ec.client_id = c.id
LEFT JOIN users u ON ec.created_by = u.id;

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

-- View para resumo de transações por período
CREATE OR REPLACE VIEW cash_transactions_summary AS
SELECT 
    DATE(created_at) as transaction_date,
    transaction_type,
    COUNT(*) as transaction_count,
    SUM(amount) as total_amount
FROM cash_transactions
GROUP BY DATE(created_at), transaction_type
ORDER BY transaction_date DESC;

-- View para balanço diário
CREATE OR REPLACE VIEW daily_cash_balance AS
SELECT 
    DATE(created_at) as date,
    SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE -amount END) as daily_flow,
    SUM(SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE -amount END)) 
        OVER (ORDER BY DATE(created_at)) as running_balance
FROM cash_transactions
GROUP BY DATE(created_at)
ORDER BY date;

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

-- Função para criar usuário inicial
CREATE OR REPLACE FUNCTION create_initial_admin()
RETURNS void AS $$
BEGIN
    INSERT INTO users (email, password_hash, full_name, role, is_active)
    VALUES (
        'admin@erechim.com',
        '1020',
        'Administrador ERECHIM',
        'admin',
        true
    )
    ON CONFLICT (email) DO NOTHING;
    
    RAISE NOTICE 'Usuário admin criado com sucesso!';
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- POLÍTICAS DE SEGURANÇA (RLS)
-- =====================================================

-- Habilitar RLS nas tabelas
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE loans ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE guarantors ENABLE ROW LEVEL SECURITY;
ALTER TABLE emergency_contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE client_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE expense_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE installments ENABLE ROW LEVEL SECURITY;
ALTER TABLE installment_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE cash_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE cash_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;
ALTER TABLE overdue_loans ENABLE ROW LEVEL SECURITY;
ALTER TABLE partial_paid_loans ENABLE ROW LEVEL SECURITY;
ALTER TABLE cancelled_loans ENABLE ROW LEVEL SECURITY;
ALTER TABLE client_pix_keys ENABLE ROW LEVEL SECURITY;

-- Políticas para usuários
CREATE POLICY "Users can view their own profile" ON users
    FOR SELECT USING (auth.uid()::text = id::text);

CREATE POLICY "Users can update their own profile" ON users
    FOR UPDATE USING (auth.uid()::text = id::text);

CREATE POLICY "Admins can view all users" ON users
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

CREATE POLICY "Admins can manage all users" ON users
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- Políticas para clientes
CREATE POLICY "Authenticated users can view all clients" ON clients
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert clients" ON clients
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update clients they created or admins can update all" ON clients
    FOR UPDATE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

CREATE POLICY "Users can delete clients they created or admins can delete all" ON clients
    FOR DELETE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- Políticas para empréstimos
CREATE POLICY "Authenticated users can view all loans" ON loans
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert loans" ON loans
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update loans they created or admins can update all" ON loans
    FOR UPDATE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

CREATE POLICY "Users can delete loans they created or admins can delete all" ON loans
    FOR DELETE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- Políticas para pagamentos
CREATE POLICY "Authenticated users can view all payments" ON payments
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert payments" ON payments
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update payments they created or admins can update all" ON payments
    FOR UPDATE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

CREATE POLICY "Users can delete payments they created or admins can delete all" ON payments
    FOR DELETE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- Políticas para avalistas
CREATE POLICY "Users can view all guarantors" ON guarantors
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert guarantors" ON guarantors
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update guarantors they created or admins can update all" ON guarantors
    FOR UPDATE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

CREATE POLICY "Users can delete guarantors they created or admins can delete all" ON guarantors
    FOR DELETE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- Políticas para contatos de emergência
CREATE POLICY "Users can view all emergency contacts" ON emergency_contacts
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert emergency contacts" ON emergency_contacts
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update emergency contacts they created or admins can update all" ON emergency_contacts
    FOR UPDATE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

CREATE POLICY "Users can delete emergency contacts they created or admins can delete all" ON emergency_contacts
    FOR DELETE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- Políticas para documentos
CREATE POLICY "Enable all operations for client_documents" ON client_documents
    FOR ALL USING (true);

-- Políticas para categorias de despesas
CREATE POLICY "Anyone can view active expense categories" ON expense_categories
    FOR SELECT USING (is_active = true);

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

-- Políticas para parcelamentos
CREATE POLICY "Users can view installments" ON installments
    FOR SELECT USING (
        auth.uid() = created_by OR 
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid() 
            AND users.role = 'admin'
        )
    );

CREATE POLICY "Users can create installments" ON installments
    FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update installments" ON installments
    FOR UPDATE USING (
        auth.uid() = created_by OR 
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid() 
            AND users.role = 'admin'
        )
    );

-- Políticas para parcelas
CREATE POLICY "Users can view installment payments" ON installment_payments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM installments 
            WHERE installments.id = installment_payments.installment_id 
            AND (
                installments.created_by = auth.uid() OR 
                EXISTS (
                    SELECT 1 FROM users 
                    WHERE users.id = auth.uid() 
                    AND users.role = 'admin'
                )
            )
        )
    );

CREATE POLICY "Users can create installment payments" ON installment_payments
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM installments 
            WHERE installments.id = installment_payments.installment_id 
            AND installments.created_by = auth.uid()
        )
    );

CREATE POLICY "Users can update installment payments" ON installment_payments
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM installments 
            WHERE installments.id = installment_payments.installment_id 
            AND (
                installments.created_by = auth.uid() OR 
                EXISTS (
                    SELECT 1 FROM users 
                    WHERE users.id = auth.uid() 
                    AND users.role = 'admin'
                )
            )
        )
    );

-- Políticas para transações de caixa
CREATE POLICY "Usuários autenticados podem ver transações de caixa" ON cash_transactions
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Usuários autenticados podem inserir transações de caixa" ON cash_transactions
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Usuários autenticados podem atualizar transações de caixa" ON cash_transactions
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Políticas para configurações de caixa
CREATE POLICY "Usuários autenticados podem ver configurações de caixa" ON cash_settings
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Usuários autenticados podem atualizar configurações de caixa" ON cash_settings
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Políticas para tabelas de status de empréstimos
CREATE POLICY "Authenticated users can view all paid loans" ON paid_loans
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert paid loans" ON paid_loans
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can view all overdue loans" ON overdue_loans
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert overdue loans" ON overdue_loans
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can view all partial paid loans" ON partial_paid_loans
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert partial paid loans" ON partial_paid_loans
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can view all cancelled loans" ON cancelled_loans
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert cancelled loans" ON cancelled_loans
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Políticas para chaves PIX
CREATE POLICY "Users can view all pix keys" ON client_pix_keys
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert pix keys" ON client_pix_keys
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update pix keys" ON client_pix_keys
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Users can delete pix keys" ON client_pix_keys
    FOR DELETE USING (auth.role() = 'authenticated');

-- =====================================================
-- DADOS INICIAIS
-- =====================================================

-- Inserir configuração inicial do caixa
INSERT INTO cash_settings (current_balance, initial_balance) 
SELECT 0, 0 
WHERE NOT EXISTS (SELECT 1 FROM cash_settings);

-- Inserir categorias padrão de despesas
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

-- Executar função para criar admin inicial
SELECT create_initial_admin();

-- =====================================================
-- VERIFICAÇÕES FINAIS
-- =====================================================

-- Verificar se as tabelas foram criadas
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN (
    'users', 'clients', 'loans', 'payments', 'guarantors', 'emergency_contacts',
    'client_documents', 'expense_categories', 'expenses', 'installments',
    'installment_payments', 'cash_transactions', 'cash_settings',
    'capital_raising', 'capital_raising_clients', 'paid_loans', 'overdue_loans',
    'partial_paid_loans', 'cancelled_loans', 'client_pix_keys'
)
ORDER BY table_name;

-- Verificar se as views foram criadas
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_type = 'VIEW'
AND table_name IN (
    'loans_with_details', 'financial_summary', 'active_users',
    'emergency_contacts_with_client', 'expenses_with_details',
    'expenses_summary_by_category', 'current_month_expenses',
    'pending_approval_expenses', 'cash_transactions_summary', 'daily_cash_balance'
)
ORDER BY table_name;

-- Verificar usuários criados
SELECT 
    id, email, full_name, role, is_active, created_at 
FROM users 
WHERE email = 'admin@erechim.com'
ORDER BY email;

-- Verificar categorias de despesas
SELECT 
    COUNT(*) as total_categories,
    COUNT(*) FILTER (WHERE is_active = true) as active_categories
FROM expense_categories;

-- =====================================================
-- MENSAGEM FINAL
-- =====================================================
SELECT 
    'ERECHIM DATABASE SETUP COMPLETED!' as status,
    'Todas as tabelas, índices, triggers, views e dados iniciais foram criados com sucesso!' as message,
    'Usuário criado: admin@erechim.com (senha: 1020)' as login_info;

-- =====================================================
-- FIM DA CONFIGURAÇÃO DO BANCO DE DADOS ERECHIM
-- =====================================================
