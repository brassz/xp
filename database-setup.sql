-- =====================================================
-- CONFIGURAÇÃO DO BANCO DE DADOS NEXUS GESTÃO FINANCEIRA
-- =====================================================
-- Execute estes comandos no SQL Editor do Supabase
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
COMMENT ON COLUMN payments.created_by IS 'Usuário que registrou o pagamento';
COMMENT ON COLUMN payments.created_at IS 'Data de criação do registro';

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

-- Função para calcular status do empréstimo
CREATE OR REPLACE FUNCTION calculate_loan_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Atualizar status baseado na data de vencimento
    IF NEW.due_date < CURRENT_DATE THEN
        NEW.status = 'overdue';
    ELSIF NEW.due_date = CURRENT_DATE THEN
        NEW.status = 'due_today';
    ELSE
        NEW.status = 'active';
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para calcular status automaticamente
CREATE TRIGGER calculate_loan_status_trigger
    BEFORE INSERT OR UPDATE ON loans
    FOR EACH ROW EXECUTE FUNCTION calculate_loan_status();

-- Função para registrar último login
CREATE OR REPLACE FUNCTION update_last_login()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_login = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para atualizar último login (será usado pela aplicação)
CREATE TRIGGER update_user_last_login
    BEFORE UPDATE ON users
    FOR EACH ROW 
    WHEN (OLD.last_login IS DISTINCT FROM NEW.last_login)
    EXECUTE FUNCTION update_last_login();

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

-- =====================================================
-- POLÍTICAS DE SEGURANÇA (RLS)
-- =====================================================

-- Habilitar RLS nas tabelas
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE loans ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

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

-- Políticas para clientes (usuários autenticados podem ver todos)
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

-- =====================================================
-- FUNÇÃO PARA CRIAR USUÁRIO INICIAL
-- =====================================================

-- Função para criar usuário admin inicial
CREATE OR REPLACE FUNCTION create_initial_admin()
RETURNS void AS $$
BEGIN
    -- Inserir usuário admin padrão se não existir
    INSERT INTO users (email, password_hash, full_name, role, is_active)
    VALUES (
        'admin@nexus.com',
        '1020',
        'Administrador Nexus',
        'admin',
        true
    )
    ON CONFLICT (email) DO NOTHING;
    
    RAISE NOTICE 'Usuário admin criado com sucesso!';
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- DADOS DE EXEMPLO (OPCIONAL)
-- =====================================================

-- Executar função para criar admin inicial
SELECT create_initial_admin();

-- Inserir clientes de exemplo
INSERT INTO clients (name, cpf, email, phone, address, created_by) VALUES
('João Silva', '123.456.789-00', 'joao@email.com', '(11) 99999-9999', 'Rua das Flores, 123 - São Paulo/SP', 
 (SELECT id FROM users WHERE email = 'admin@nexus.com')),
('Maria Santos', '987.654.321-00', 'maria@email.com', '(11) 88888-8888', 'Av. Paulista, 456 - São Paulo/SP',
 (SELECT id FROM users WHERE email = 'admin@nexus.com')),
('Pedro Oliveira', '111.222.333-44', 'pedro@email.com', '(11) 77777-7777', 'Rua Augusta, 789 - São Paulo/SP',
 (SELECT id FROM users WHERE email = 'admin@nexus.com'))
ON CONFLICT (cpf) DO NOTHING;

-- Inserir empréstimos de exemplo
INSERT INTO loans (client_id, amount, interest_rate, loan_date, due_date, created_by) VALUES
((SELECT id FROM clients WHERE cpf = '123.456.789-00'), 5000.00, 2.5, CURRENT_DATE - INTERVAL '30 days', CURRENT_DATE + INTERVAL '30 days',
 (SELECT id FROM users WHERE email = 'admin@nexus.com')),
((SELECT id FROM clients WHERE cpf = '987.654.321-00'), 3000.00, 3.0, CURRENT_DATE - INTERVAL '15 days', CURRENT_DATE + INTERVAL '45 days',
 (SELECT id FROM users WHERE email = 'admin@nexus.com')),
((SELECT id FROM clients WHERE cpf = '111.222.333-44'), 8000.00, 2.0, CURRENT_DATE - INTERVAL '60 days', CURRENT_DATE - INTERVAL '10 days',
 (SELECT id FROM users WHERE email = 'admin@nexus.com'))
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
AND table_name IN ('users', 'clients', 'loans', 'payments')
ORDER BY table_name;

-- Verificar se as views foram criadas
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('loans_with_details', 'overdue_loans', 'financial_summary', 'active_users')
ORDER BY table_name;

-- Verificar se os índices foram criados
SELECT 
    indexname,
    tablename
FROM pg_indexes 
WHERE tablename IN ('users', 'clients', 'loans', 'payments')
ORDER BY tablename, indexname;

-- Verificar se as políticas RLS estão ativas
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- Criar tabela de despesas
CREATE TABLE expenses (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    description TEXT NOT NULL,
    category VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    date DATE NOT NULL,
    notes TEXT,
    signature TEXT, -- Base64 da assinatura digital
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Índices para a tabela expenses
CREATE INDEX idx_expenses_user_id ON expenses(user_id);
CREATE INDEX idx_expenses_date ON expenses(date);
CREATE INDEX idx_expenses_category ON expenses(category);

-- RLS para a tabela expenses
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

-- Política para ver apenas as próprias despesas
CREATE POLICY "Users can view own expenses" ON expenses
    FOR SELECT USING (user_id = auth.uid());

-- Política para inserir despesas
CREATE POLICY "Users can insert own expenses" ON expenses
    FOR INSERT WITH CHECK (user_id = auth.uid());

-- Política para atualizar próprias despesas
CREATE POLICY "Users can update own expenses" ON expenses
    FOR UPDATE USING (user_id = auth.uid());

-- Política para deletar próprias despesas
CREATE POLICY "Users can delete own expenses" ON expenses
    FOR DELETE USING (user_id = auth.uid());

-- Trigger para atualizar updated_at
CREATE TRIGGER update_expenses_updated_at BEFORE UPDATE ON expenses
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- Verificar usuário admin criado
SELECT id, email, full_name, role, is_active, created_at FROM users WHERE role = 'admin';

-- =====================================================
-- FIM DA CONFIGURAÇÃO
-- =====================================================
-- 
-- Para executar este script:
-- 1. Acesse o SQL Editor no Supabase
-- 2. Cole todo o conteúdo deste arquivo
-- 3. Clique em "Run" para executar
-- 4. Verifique se não há erros na execução
-- 5. Confirme que as tabelas foram criadas corretamente
--
-- Após a execução, você pode começar a usar a aplicação!
-- 
-- USUÁRIO ADMIN PADRÃO:
-- Email: admin@nexus.com
-- Senha: 1020
-- ===================================================== 