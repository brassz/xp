-- =====================================================
-- CONFIGURAÇÃO DO BANCO DE DADOS LITORAL CRED
-- =====================================================
-- Execute estes comandos no SQL Editor do Supabase da LITORAL CRED
-- URL: https://dtifsfzmnjnllzzlndxv.supabase.co
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
COMMENT ON TABLE users IS 'Tabela para armazenar usuários do sistema - LITORAL CRED';
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
    phone TEXT NOT NULL,
    email TEXT,
    address TEXT NOT NULL,
    birth_date DATE,
    profession TEXT,
    monthly_income DECIMAL(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela de clientes
COMMENT ON TABLE clients IS 'Tabela para armazenar clientes - LITORAL CRED';
COMMENT ON COLUMN clients.id IS 'Identificador único do cliente';
COMMENT ON COLUMN clients.name IS 'Nome completo do cliente';
COMMENT ON COLUMN clients.cpf IS 'CPF único do cliente';
COMMENT ON COLUMN clients.phone IS 'Telefone de contato';
COMMENT ON COLUMN clients.email IS 'Email do cliente';
COMMENT ON COLUMN clients.address IS 'Endereço completo';
COMMENT ON COLUMN clients.birth_date IS 'Data de nascimento';
COMMENT ON COLUMN clients.profession IS 'Profissão do cliente';
COMMENT ON COLUMN clients.monthly_income IS 'Renda mensal declarada';
COMMENT ON COLUMN clients.created_at IS 'Data de cadastro';
COMMENT ON COLUMN clients.updated_at IS 'Data da última atualização';

-- =====================================================
-- TABELA DE EMPRÉSTIMOS
-- =====================================================
CREATE TABLE IF NOT EXISTS loans (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'paid', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela de empréstimos
COMMENT ON TABLE loans IS 'Tabela para armazenar empréstimos - LITORAL CRED';
COMMENT ON COLUMN loans.id IS 'Identificador único do empréstimo';
COMMENT ON COLUMN loans.client_id IS 'Referência ao cliente';
COMMENT ON COLUMN loans.amount IS 'Valor emprestado';
COMMENT ON COLUMN loans.interest_rate IS 'Taxa de juros (%)';
COMMENT ON COLUMN loans.loan_date IS 'Data do empréstimo';
COMMENT ON COLUMN loans.due_date IS 'Data de vencimento';
COMMENT ON COLUMN loans.total_amount IS 'Valor total a receber';
COMMENT ON COLUMN loans.status IS 'Status do empréstimo';
COMMENT ON COLUMN loans.created_at IS 'Data de criação';
COMMENT ON COLUMN loans.updated_at IS 'Data da última atualização';

-- Inserir usuário admin padrão para LITORAL CRED
INSERT INTO users (email, password_hash, full_name, role, is_active)
VALUES (
    'admin@litoralcred.com',
    '1020', -- Senha simples para demonstração
    'Admin Litoral Cred',
    'admin',
    true
) ON CONFLICT (email) DO UPDATE SET
    is_active = true,
    updated_at = NOW();

-- Habilitar RLS (Row Level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE loans ENABLE ROW LEVEL SECURITY;

-- Políticas de segurança básicas
CREATE POLICY "Users can view all records" ON users FOR SELECT USING (true);
CREATE POLICY "Users can view all clients" ON clients FOR SELECT USING (true);
CREATE POLICY "Users can view all loans" ON loans FOR SELECT USING (true);

CREATE POLICY "Users can insert clients" ON clients FOR INSERT WITH CHECK (true);
CREATE POLICY "Users can update clients" ON clients FOR UPDATE USING (true);
CREATE POLICY "Users can delete clients" ON clients FOR DELETE USING (true);

CREATE POLICY "Users can insert loans" ON loans FOR INSERT WITH CHECK (true);
CREATE POLICY "Users can update loans" ON loans FOR UPDATE USING (true);
CREATE POLICY "Users can delete loans" ON loans FOR DELETE USING (true);

-- Índices para performance
CREATE INDEX idx_clients_cpf ON clients(cpf);
CREATE INDEX idx_clients_name ON clients(name);
CREATE INDEX idx_loans_client_id ON loans(client_id);
CREATE INDEX idx_loans_status ON loans(status);
CREATE INDEX idx_loans_due_date ON loans(due_date);

-- Trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_clients_updated_at BEFORE UPDATE ON clients
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_loans_updated_at BEFORE UPDATE ON loans
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- Verificar usuário admin criado
SELECT id, email, full_name, role, is_active, created_at 
FROM users WHERE role = 'admin';

-- =====================================================
-- FIM DA CONFIGURAÇÃO LITORAL CRED
-- =====================================================
-- 
-- Para executar este script:
-- 1. Acesse o SQL Editor no Supabase da LITORAL CRED
-- 2. Cole todo o conteúdo deste arquivo
-- 3. Clique em "Run" para executar
-- 4. Verifique se não há erros na execução
-- 5. Confirme que as tabelas foram criadas corretamente
--
-- USUÁRIO ADMIN PADRÃO LITORAL CRED:
-- Email: admin@litoralcred.com
-- Senha: 1020
-- =====================================================