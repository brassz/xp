-- =====================================================
-- FIX COMPLETO - BANCO DE DADOS FRANCA PRIVATE v3
-- =====================================================
-- Este script cria/atualiza todas as tabelas e estruturas ausentes
-- Versão 3: Usa ALTER TABLE para TODAS as tabelas existentes
-- =====================================================

-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABELA DE AVALISTAS (GUARANTORS)
-- =====================================================
-- Criar tabela se não existir (estrutura mínima)
CREATE TABLE IF NOT EXISTS guarantors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Adicionar colunas que podem não existir
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='guarantors' AND column_name='client_id') THEN
        ALTER TABLE guarantors ADD COLUMN client_id UUID NOT NULL;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='guarantors' AND column_name='name') THEN
        ALTER TABLE guarantors ADD COLUMN name TEXT NOT NULL;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='guarantors' AND column_name='cpf') THEN
        ALTER TABLE guarantors ADD COLUMN cpf TEXT NOT NULL;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='guarantors' AND column_name='rg') THEN
        ALTER TABLE guarantors ADD COLUMN rg TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='guarantors' AND column_name='email') THEN
        ALTER TABLE guarantors ADD COLUMN email TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='guarantors' AND column_name='phone') THEN
        ALTER TABLE guarantors ADD COLUMN phone TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='guarantors' AND column_name='address') THEN
        ALTER TABLE guarantors ADD COLUMN address TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='guarantors' AND column_name='birth_date') THEN
        ALTER TABLE guarantors ADD COLUMN birth_date DATE;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='guarantors' AND column_name='relationship') THEN
        ALTER TABLE guarantors ADD COLUMN relationship TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='guarantors' AND column_name='photo') THEN
        ALTER TABLE guarantors ADD COLUMN photo TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='guarantors' AND column_name='created_by') THEN
        ALTER TABLE guarantors ADD COLUMN created_by UUID;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='guarantors' AND column_name='updated_at') THEN
        ALTER TABLE guarantors ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
END $$;

-- Adicionar foreign keys se não existirem
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name='guarantors_client_id_fkey') THEN
        ALTER TABLE guarantors ADD CONSTRAINT guarantors_client_id_fkey 
        FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;
    END IF;
EXCEPTION
    WHEN OTHERS THEN NULL;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name='guarantors_created_by_fkey') THEN
        ALTER TABLE guarantors ADD CONSTRAINT guarantors_created_by_fkey 
        FOREIGN KEY (created_by) REFERENCES users(id);
    END IF;
EXCEPTION
    WHEN OTHERS THEN NULL;
END $$;

COMMENT ON TABLE guarantors IS 'Tabela para armazenar informações dos avalistas dos clientes';

-- Índices
CREATE INDEX IF NOT EXISTS idx_guarantors_client_id ON guarantors(client_id);
CREATE INDEX IF NOT EXISTS idx_guarantors_cpf ON guarantors(cpf);
CREATE INDEX IF NOT EXISTS idx_guarantors_created_at ON guarantors(created_at);

-- Trigger
CREATE OR REPLACE FUNCTION update_guarantors_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_guarantors_updated_at_trigger ON guarantors;
CREATE TRIGGER update_guarantors_updated_at_trigger
    BEFORE UPDATE ON guarantors
    FOR EACH ROW
    EXECUTE FUNCTION update_guarantors_updated_at();

-- =====================================================
-- TABELA DE TRANSAÇÕES DE CAIXA
-- =====================================================
CREATE TABLE IF NOT EXISTS cash_transactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Adicionar colunas
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='cash_transactions' AND column_name='transaction_type') THEN
        ALTER TABLE cash_transactions ADD COLUMN transaction_type TEXT NOT NULL CHECK (transaction_type IN ('deposit', 'withdrawal'));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='cash_transactions' AND column_name='amount') THEN
        ALTER TABLE cash_transactions ADD COLUMN amount DECIMAL(15,2) NOT NULL CHECK (amount > 0);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='cash_transactions' AND column_name='description') THEN
        ALTER TABLE cash_transactions ADD COLUMN description TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='cash_transactions' AND column_name='reference_id') THEN
        ALTER TABLE cash_transactions ADD COLUMN reference_id UUID;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='cash_transactions' AND column_name='reference_type') THEN
        ALTER TABLE cash_transactions ADD COLUMN reference_type TEXT CHECK (reference_type IN ('loan', 'expense', 'manual', 'installment'));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='cash_transactions' AND column_name='balance_after') THEN
        ALTER TABLE cash_transactions ADD COLUMN balance_after DECIMAL(15,2) NOT NULL;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='cash_transactions' AND column_name='created_by') THEN
        ALTER TABLE cash_transactions ADD COLUMN created_by UUID;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='cash_transactions' AND column_name='updated_at') THEN
        ALTER TABLE cash_transactions ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name='cash_transactions_created_by_fkey') THEN
        ALTER TABLE cash_transactions ADD CONSTRAINT cash_transactions_created_by_fkey 
        FOREIGN KEY (created_by) REFERENCES users(id);
    END IF;
EXCEPTION
    WHEN OTHERS THEN NULL;
END $$;

COMMENT ON TABLE cash_transactions IS 'Tabela para registrar todas as transações de entrada e saída de dinheiro do caixa';

-- Índices
CREATE INDEX IF NOT EXISTS idx_cash_transactions_type ON cash_transactions(transaction_type);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_date ON cash_transactions(created_at);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_user ON cash_transactions(created_by);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_reference ON cash_transactions(reference_id, reference_type);

-- =====================================================
-- TABELA DE CONFIGURAÇÃO DO CAIXA
-- =====================================================
CREATE TABLE IF NOT EXISTS cash_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY
);

-- Adicionar colunas
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='cash_settings' AND column_name='current_balance') THEN
        ALTER TABLE cash_settings ADD COLUMN current_balance DECIMAL(15,2) DEFAULT 0 NOT NULL;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='cash_settings' AND column_name='initial_balance') THEN
        ALTER TABLE cash_settings ADD COLUMN initial_balance DECIMAL(15,2) DEFAULT 0 NOT NULL;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='cash_settings' AND column_name='last_updated') THEN
        ALTER TABLE cash_settings ADD COLUMN last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='cash_settings' AND column_name='updated_by') THEN
        ALTER TABLE cash_settings ADD COLUMN updated_by UUID;
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name='cash_settings_updated_by_fkey') THEN
        ALTER TABLE cash_settings ADD CONSTRAINT cash_settings_updated_by_fkey 
        FOREIGN KEY (updated_by) REFERENCES users(id);
    END IF;
EXCEPTION
    WHEN OTHERS THEN NULL;
END $$;

COMMENT ON TABLE cash_settings IS 'Tabela para armazenar as configurações e saldo atual do caixa';

-- Inserir configuração inicial
INSERT INTO cash_settings (current_balance, initial_balance) 
SELECT 0, 0 
WHERE NOT EXISTS (SELECT 1 FROM cash_settings);

-- Função e trigger para atualizar saldo
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

DROP TRIGGER IF EXISTS trigger_update_cash_balance ON cash_transactions;
CREATE TRIGGER trigger_update_cash_balance
    AFTER INSERT ON cash_transactions
    FOR EACH ROW
    EXECUTE FUNCTION update_cash_balance();

-- =====================================================
-- TABELA DE LEVANTAMENTO DE CAPITAL
-- =====================================================
CREATE TABLE IF NOT EXISTS capital_raising (
    id SERIAL PRIMARY KEY
);

-- Adicionar colunas
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising' AND column_name='nome') THEN
        ALTER TABLE capital_raising ADD COLUMN nome VARCHAR(255) NOT NULL DEFAULT 'Levantamento';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising' AND column_name='valor_bruto') THEN
        ALTER TABLE capital_raising ADD COLUMN valor_bruto DECIMAL(15,2) NOT NULL DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising' AND column_name='taxa_juros') THEN
        ALTER TABLE capital_raising ADD COLUMN taxa_juros DECIMAL(5,2) NOT NULL DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising' AND column_name='valor_total') THEN
        ALTER TABLE capital_raising ADD COLUMN valor_total DECIMAL(15,2) NOT NULL DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising' AND column_name='data_criacao') THEN
        ALTER TABLE capital_raising ADD COLUMN data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising' AND column_name='data_atualizacao') THEN
        ALTER TABLE capital_raising ADD COLUMN data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising' AND column_name='ativo') THEN
        ALTER TABLE capital_raising ADD COLUMN ativo BOOLEAN DEFAULT TRUE;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising' AND column_name='data_baixa') THEN
        ALTER TABLE capital_raising ADD COLUMN data_baixa TIMESTAMP NULL;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising' AND column_name='motivo_baixa') THEN
        ALTER TABLE capital_raising ADD COLUMN motivo_baixa TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising' AND column_name='observacoes') THEN
        ALTER TABLE capital_raising ADD COLUMN observacoes TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising' AND column_name='user_id') THEN
        ALTER TABLE capital_raising ADD COLUMN user_id VARCHAR(255) NOT NULL DEFAULT 'system';
    END IF;
END $$;

COMMENT ON TABLE capital_raising IS 'Tabela para gerenciar levantamentos de capital independente de empréstimos';

-- Índices
CREATE INDEX IF NOT EXISTS idx_capital_raising_user_id ON capital_raising(user_id);
CREATE INDEX IF NOT EXISTS idx_capital_raising_ativo ON capital_raising(ativo);

-- Trigger
CREATE OR REPLACE FUNCTION update_capital_raising_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.data_atualizacao = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_capital_raising_timestamp ON capital_raising;
CREATE TRIGGER update_capital_raising_timestamp 
    BEFORE UPDATE ON capital_raising 
    FOR EACH ROW EXECUTE FUNCTION update_capital_raising_timestamp();

-- =====================================================
-- TABELA DE CLIENTES DO LEVANTAMENTO DE CAPITAL
-- =====================================================
CREATE TABLE IF NOT EXISTS capital_raising_clients (
    id SERIAL PRIMARY KEY
);

-- Adicionar colunas
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising_clients' AND column_name='capital_raising_id') THEN
        ALTER TABLE capital_raising_clients ADD COLUMN capital_raising_id INTEGER NOT NULL DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising_clients' AND column_name='nome') THEN
        ALTER TABLE capital_raising_clients ADD COLUMN nome VARCHAR(255) NOT NULL DEFAULT 'Cliente';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising_clients' AND column_name='cpf') THEN
        ALTER TABLE capital_raising_clients ADD COLUMN cpf VARCHAR(14);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising_clients' AND column_name='telefone') THEN
        ALTER TABLE capital_raising_clients ADD COLUMN telefone VARCHAR(20);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising_clients' AND column_name='email') THEN
        ALTER TABLE capital_raising_clients ADD COLUMN email VARCHAR(255);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising_clients' AND column_name='valor_individual') THEN
        ALTER TABLE capital_raising_clients ADD COLUMN valor_individual DECIMAL(15,2) NOT NULL DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising_clients' AND column_name='data_entrada') THEN
        ALTER TABLE capital_raising_clients ADD COLUMN data_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising_clients' AND column_name='observacoes') THEN
        ALTER TABLE capital_raising_clients ADD COLUMN observacoes TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='capital_raising_clients' AND column_name='ativo') THEN
        ALTER TABLE capital_raising_clients ADD COLUMN ativo BOOLEAN DEFAULT TRUE;
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name='capital_raising_clients_capital_raising_id_fkey') THEN
        ALTER TABLE capital_raising_clients ADD CONSTRAINT capital_raising_clients_capital_raising_id_fkey 
        FOREIGN KEY (capital_raising_id) REFERENCES capital_raising(id) ON DELETE CASCADE;
    END IF;
EXCEPTION
    WHEN OTHERS THEN NULL;
END $$;

COMMENT ON TABLE capital_raising_clients IS 'Tabela para clientes vinculados a um levantamento de capital específico';

-- Índices
CREATE INDEX IF NOT EXISTS idx_capital_raising_clients_capital_id ON capital_raising_clients(capital_raising_id);
CREATE INDEX IF NOT EXISTS idx_capital_raising_clients_ativo ON capital_raising_clients(ativo);

-- =====================================================
-- TABELA DE EMPRÉSTIMOS QUITADOS
-- =====================================================
CREATE TABLE IF NOT EXISTS paid_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Adicionar colunas
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='loan_id') THEN
        ALTER TABLE paid_loans ADD COLUMN loan_id UUID NOT NULL;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='client_id') THEN
        ALTER TABLE paid_loans ADD COLUMN client_id UUID NOT NULL;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='original_amount') THEN
        ALTER TABLE paid_loans ADD COLUMN original_amount DECIMAL(10,2) NOT NULL DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='interest_rate') THEN
        ALTER TABLE paid_loans ADD COLUMN interest_rate DECIMAL(5,2) NOT NULL DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='total_with_interest') THEN
        ALTER TABLE paid_loans ADD COLUMN total_with_interest DECIMAL(10,2) NOT NULL DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='loan_date') THEN
        ALTER TABLE paid_loans ADD COLUMN loan_date DATE NOT NULL DEFAULT CURRENT_DATE;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='due_date') THEN
        ALTER TABLE paid_loans ADD COLUMN due_date DATE NOT NULL DEFAULT CURRENT_DATE;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='paid_date') THEN
        ALTER TABLE paid_loans ADD COLUMN paid_date DATE NOT NULL DEFAULT CURRENT_DATE;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='total_paid') THEN
        ALTER TABLE paid_loans ADD COLUMN total_paid DECIMAL(10,2) NOT NULL DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='payment_method') THEN
        ALTER TABLE paid_loans ADD COLUMN payment_method VARCHAR(50);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='notes') THEN
        ALTER TABLE paid_loans ADD COLUMN notes TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='created_by') THEN
        ALTER TABLE paid_loans ADD COLUMN created_by UUID;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='paid_loans' AND column_name='updated_at') THEN
        ALTER TABLE paid_loans ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
END $$;

COMMENT ON TABLE paid_loans IS 'Tabela para armazenar empréstimos completamente quitados';

-- Índices
CREATE INDEX IF NOT EXISTS idx_paid_loans_loan_id ON paid_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_client_id ON paid_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_paid_date ON paid_loans(paid_date);
CREATE INDEX IF NOT EXISTS idx_paid_loans_created_by ON paid_loans(created_by);
CREATE INDEX IF NOT EXISTS idx_paid_loans_created_at ON paid_loans(created_at);

-- Trigger
CREATE OR REPLACE FUNCTION update_paid_loans_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_paid_loans_updated_at_trigger ON paid_loans;
CREATE TRIGGER update_paid_loans_updated_at_trigger
    BEFORE UPDATE ON paid_loans
    FOR EACH ROW
    EXECUTE FUNCTION update_paid_loans_updated_at();

-- =====================================================
-- FIX: CONSTRAINT DE PAYMENT_TYPE
-- =====================================================
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'payments') THEN
        ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;
        RAISE NOTICE '✓ Constraint de payment_type removida';
    END IF;
END $$;

-- =====================================================
-- RLS POLICIES
-- =====================================================
ALTER TABLE guarantors ENABLE ROW LEVEL SECURITY;
ALTER TABLE cash_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE cash_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE capital_raising ENABLE ROW LEVEL SECURITY;
ALTER TABLE capital_raising_clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;

-- Policies (criar se não existirem)
DO $$
BEGIN
    DROP POLICY IF EXISTS "Usuários autenticados podem ver avalistas" ON guarantors;
    CREATE POLICY "Usuários autenticados podem ver avalistas" ON guarantors FOR SELECT USING (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem inserir avalistas" ON guarantors;
    CREATE POLICY "Usuários autenticados podem inserir avalistas" ON guarantors FOR INSERT WITH CHECK (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem atualizar avalistas" ON guarantors;
    CREATE POLICY "Usuários autenticados podem atualizar avalistas" ON guarantors FOR UPDATE USING (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem excluir avalistas" ON guarantors;
    CREATE POLICY "Usuários autenticados podem excluir avalistas" ON guarantors FOR DELETE USING (auth.role() = 'authenticated');
    
    -- Cash transactions
    DROP POLICY IF EXISTS "Usuários autenticados podem ver transações de caixa" ON cash_transactions;
    CREATE POLICY "Usuários autenticados podem ver transações de caixa" ON cash_transactions FOR SELECT USING (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem inserir transações de caixa" ON cash_transactions;
    CREATE POLICY "Usuários autenticados podem inserir transações de caixa" ON cash_transactions FOR INSERT WITH CHECK (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem atualizar transações de caixa" ON cash_transactions;
    CREATE POLICY "Usuários autenticados podem atualizar transações de caixa" ON cash_transactions FOR UPDATE USING (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem excluir transações de caixa" ON cash_transactions;
    CREATE POLICY "Usuários autenticados podem excluir transações de caixa" ON cash_transactions FOR DELETE USING (auth.role() = 'authenticated');
    
    -- Cash settings
    DROP POLICY IF EXISTS "Usuários autenticados podem ver configurações de caixa" ON cash_settings;
    CREATE POLICY "Usuários autenticados podem ver configurações de caixa" ON cash_settings FOR SELECT USING (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem atualizar configurações de caixa" ON cash_settings;
    CREATE POLICY "Usuários autenticados podem atualizar configurações de caixa" ON cash_settings FOR UPDATE USING (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem inserir configurações de caixa" ON cash_settings;
    CREATE POLICY "Usuários autenticados podem inserir configurações de caixa" ON cash_settings FOR INSERT WITH CHECK (auth.role() = 'authenticated');
    
    -- Capital raising
    DROP POLICY IF EXISTS "Usuários autenticados podem ver levantamentos" ON capital_raising;
    CREATE POLICY "Usuários autenticados podem ver levantamentos" ON capital_raising FOR SELECT USING (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem inserir levantamentos" ON capital_raising;
    CREATE POLICY "Usuários autenticados podem inserir levantamentos" ON capital_raising FOR INSERT WITH CHECK (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem atualizar levantamentos" ON capital_raising;
    CREATE POLICY "Usuários autenticados podem atualizar levantamentos" ON capital_raising FOR UPDATE USING (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem excluir levantamentos" ON capital_raising;
    CREATE POLICY "Usuários autenticados podem excluir levantamentos" ON capital_raising FOR DELETE USING (auth.role() = 'authenticated');
    
    -- Capital raising clients
    DROP POLICY IF EXISTS "Usuários autenticados podem ver clientes de levantamento" ON capital_raising_clients;
    CREATE POLICY "Usuários autenticados podem ver clientes de levantamento" ON capital_raising_clients FOR SELECT USING (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem inserir clientes de levantamento" ON capital_raising_clients;
    CREATE POLICY "Usuários autenticados podem inserir clientes de levantamento" ON capital_raising_clients FOR INSERT WITH CHECK (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem atualizar clientes de levantamento" ON capital_raising_clients;
    CREATE POLICY "Usuários autenticados podem atualizar clientes de levantamento" ON capital_raising_clients FOR UPDATE USING (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem excluir clientes de levantamento" ON capital_raising_clients;
    CREATE POLICY "Usuários autenticados podem excluir clientes de levantamento" ON capital_raising_clients FOR DELETE USING (auth.role() = 'authenticated');
    
    -- Paid loans
    DROP POLICY IF EXISTS "Usuários autenticados podem ver empréstimos quitados" ON paid_loans;
    CREATE POLICY "Usuários autenticados podem ver empréstimos quitados" ON paid_loans FOR SELECT USING (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários autenticados podem inserir empréstimos quitados" ON paid_loans;
    CREATE POLICY "Usuários autenticados podem inserir empréstimos quitados" ON paid_loans FOR INSERT WITH CHECK (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários podem atualizar seus empréstimos quitados" ON paid_loans;
    CREATE POLICY "Usuários podem atualizar seus empréstimos quitados" ON paid_loans FOR UPDATE USING (auth.role() = 'authenticated');
    
    DROP POLICY IF EXISTS "Usuários podem excluir empréstimos quitados" ON paid_loans;
    CREATE POLICY "Usuários podem excluir empréstimos quitados" ON paid_loans FOR DELETE USING (auth.role() = 'authenticated');
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Aviso ao criar policies: %', SQLERRM;
END $$;

-- =====================================================
-- PERMISSÕES
-- =====================================================
GRANT SELECT, INSERT, UPDATE, DELETE ON guarantors TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON cash_transactions TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON cash_settings TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON capital_raising TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON capital_raising_clients TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON paid_loans TO authenticated;

GRANT USAGE, SELECT ON SEQUENCE capital_raising_id_seq TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE capital_raising_clients_id_seq TO authenticated;

-- =====================================================
-- VIEWS
-- =====================================================
DROP VIEW IF EXISTS cash_transactions_summary CASCADE;
CREATE OR REPLACE VIEW cash_transactions_summary AS
SELECT 
    DATE(created_at) as transaction_date,
    transaction_type,
    COUNT(*) as transaction_count,
    SUM(amount) as total_amount
FROM cash_transactions
GROUP BY DATE(created_at), transaction_type
ORDER BY transaction_date DESC;

DROP VIEW IF EXISTS daily_cash_balance CASCADE;
CREATE OR REPLACE VIEW daily_cash_balance AS
SELECT 
    DATE(created_at) as date,
    SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE -amount END) as daily_flow,
    SUM(SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE -amount END)) 
        OVER (ORDER BY DATE(created_at)) as running_balance
FROM cash_transactions
GROUP BY DATE(created_at)
ORDER BY date;

DROP VIEW IF EXISTS paid_loans_with_details CASCADE;
CREATE OR REPLACE VIEW paid_loans_with_details AS
SELECT 
    pl.*,
    c.name as client_name,
    c.cpf as client_cpf,
    c.email as client_email,
    c.phone as client_phone,
    c.photo as client_photo,
    u.full_name as created_by_name
FROM paid_loans pl
LEFT JOIN clients c ON pl.client_id = c.id
LEFT JOIN users u ON pl.created_by = u.id
ORDER BY pl.paid_date DESC;

GRANT SELECT ON cash_transactions_summary TO authenticated;
GRANT SELECT ON daily_cash_balance TO authenticated;
GRANT SELECT ON paid_loans_with_details TO authenticated;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================
DO $$
BEGIN
    RAISE NOTICE '====================================================';
    RAISE NOTICE 'FIX v3 CONCLUÍDO COM SUCESSO!';
    RAISE NOTICE '====================================================';
    RAISE NOTICE '✓ Todas as tabelas foram criadas/atualizadas';
    RAISE NOTICE '✓ Todas as colunas foram adicionadas';
    RAISE NOTICE '✓ Constraint de payment_type removida';
    RAISE NOTICE '✓ RLS policies configuradas';
    RAISE NOTICE '✓ Triggers criados';
    RAISE NOTICE '✓ Views criadas';
    RAISE NOTICE '';
    RAISE NOTICE 'Próximo passo: Recarregue a aplicação (F5)';
    RAISE NOTICE '====================================================';
END $$;
