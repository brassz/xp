-- =====================================================
-- FIX COMPLETO - BANCO DE DADOS FRANCA PRIVATE v2
-- =====================================================
-- Este script cria/atualiza todas as tabelas e estruturas ausentes
-- Versão 2: Usa ALTER TABLE para tabelas existentes
-- =====================================================

-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABELA DE AVALISTAS (GUARANTORS)
-- =====================================================
-- Criar tabela se não existir
CREATE TABLE IF NOT EXISTS guarantors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL,
    name TEXT NOT NULL,
    cpf TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Adicionar colunas que podem não existir
DO $$ 
BEGIN
    -- Adicionar coluna rg se não existir
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='guarantors' AND column_name='rg') THEN
        ALTER TABLE guarantors ADD COLUMN rg TEXT;
    END IF;
    
    -- Adicionar coluna email se não existir
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='guarantors' AND column_name='email') THEN
        ALTER TABLE guarantors ADD COLUMN email TEXT;
    END IF;
    
    -- Adicionar coluna phone se não existir
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='guarantors' AND column_name='phone') THEN
        ALTER TABLE guarantors ADD COLUMN phone TEXT;
    END IF;
    
    -- Adicionar coluna address se não existir
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='guarantors' AND column_name='address') THEN
        ALTER TABLE guarantors ADD COLUMN address TEXT;
    END IF;
    
    -- Adicionar coluna birth_date se não existir
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='guarantors' AND column_name='birth_date') THEN
        ALTER TABLE guarantors ADD COLUMN birth_date DATE;
    END IF;
    
    -- Adicionar coluna relationship se não existir
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='guarantors' AND column_name='relationship') THEN
        ALTER TABLE guarantors ADD COLUMN relationship TEXT;
    END IF;
    
    -- Adicionar coluna photo se não existir
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='guarantors' AND column_name='photo') THEN
        ALTER TABLE guarantors ADD COLUMN photo TEXT;
    END IF;
    
    -- Adicionar coluna created_by se não existir
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='guarantors' AND column_name='created_by') THEN
        ALTER TABLE guarantors ADD COLUMN created_by UUID;
    END IF;
    
    -- Adicionar coluna updated_at se não existir
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='guarantors' AND column_name='updated_at') THEN
        ALTER TABLE guarantors ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
    END IF;
END $$;

-- Adicionar foreign keys se não existirem
DO $$
BEGIN
    -- FK para clients
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_name='guarantors_client_id_fkey') THEN
        ALTER TABLE guarantors ADD CONSTRAINT guarantors_client_id_fkey 
        FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;
    END IF;
    
    -- FK para users
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_name='guarantors_created_by_fkey') THEN
        ALTER TABLE guarantors ADD CONSTRAINT guarantors_created_by_fkey 
        FOREIGN KEY (created_by) REFERENCES users(id);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Aviso: Não foi possível adicionar foreign keys em guarantors: %', SQLERRM;
END $$;

COMMENT ON TABLE guarantors IS 'Tabela para armazenar informações dos avalistas dos clientes';

-- Índices para guarantors
CREATE INDEX IF NOT EXISTS idx_guarantors_client_id ON guarantors(client_id);
CREATE INDEX IF NOT EXISTS idx_guarantors_cpf ON guarantors(cpf);
CREATE INDEX IF NOT EXISTS idx_guarantors_created_at ON guarantors(created_at);

-- Trigger para atualizar updated_at em guarantors
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
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('deposit', 'withdrawal')),
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    description TEXT,
    reference_id UUID,
    reference_type TEXT CHECK (reference_type IN ('loan', 'expense', 'manual', 'installment')),
    balance_after DECIMAL(15,2) NOT NULL,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Adicionar FK para users em cash_transactions
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_name='cash_transactions_created_by_fkey') THEN
        ALTER TABLE cash_transactions ADD CONSTRAINT cash_transactions_created_by_fkey 
        FOREIGN KEY (created_by) REFERENCES users(id);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Aviso: Não foi possível adicionar FK em cash_transactions: %', SQLERRM;
END $$;

COMMENT ON TABLE cash_transactions IS 'Tabela para registrar todas as transações de entrada e saída de dinheiro do caixa';

-- Índices para cash_transactions
CREATE INDEX IF NOT EXISTS idx_cash_transactions_type ON cash_transactions(transaction_type);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_date ON cash_transactions(created_at);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_user ON cash_transactions(created_by);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_reference ON cash_transactions(reference_id, reference_type);

-- =====================================================
-- TABELA DE CONFIGURAÇÃO DO CAIXA
-- =====================================================
CREATE TABLE IF NOT EXISTS cash_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    current_balance DECIMAL(15,2) DEFAULT 0 NOT NULL,
    initial_balance DECIMAL(15,2) DEFAULT 0 NOT NULL,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_by UUID
);

-- Adicionar FK para users em cash_settings
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_name='cash_settings_updated_by_fkey') THEN
        ALTER TABLE cash_settings ADD CONSTRAINT cash_settings_updated_by_fkey 
        FOREIGN KEY (updated_by) REFERENCES users(id);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Aviso: Não foi possível adicionar FK em cash_settings: %', SQLERRM;
END $$;

COMMENT ON TABLE cash_settings IS 'Tabela para armazenar as configurações e saldo atual do caixa';

-- Inserir configuração inicial do caixa (caso não exista)
INSERT INTO cash_settings (current_balance, initial_balance) 
SELECT 0, 0 
WHERE NOT EXISTS (SELECT 1 FROM cash_settings);

-- =====================================================
-- FUNÇÃO PARA ATUALIZAR SALDO DO CAIXA
-- =====================================================
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

-- Índices para capital_raising
CREATE INDEX IF NOT EXISTS idx_capital_raising_user_id ON capital_raising(user_id);
CREATE INDEX IF NOT EXISTS idx_capital_raising_ativo ON capital_raising(ativo);

-- Trigger para atualizar data_atualizacao
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
    id SERIAL PRIMARY KEY,
    capital_raising_id INTEGER NOT NULL,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14),
    telefone VARCHAR(20),
    email VARCHAR(255),
    valor_individual DECIMAL(15,2) NOT NULL,
    data_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observacoes TEXT,
    ativo BOOLEAN DEFAULT TRUE
);

-- Adicionar FK para capital_raising
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE constraint_name='capital_raising_clients_capital_raising_id_fkey') THEN
        ALTER TABLE capital_raising_clients ADD CONSTRAINT capital_raising_clients_capital_raising_id_fkey 
        FOREIGN KEY (capital_raising_id) REFERENCES capital_raising(id) ON DELETE CASCADE;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Aviso: Não foi possível adicionar FK em capital_raising_clients: %', SQLERRM;
END $$;

COMMENT ON TABLE capital_raising_clients IS 'Tabela para clientes vinculados a um levantamento de capital específico';

-- Índices para capital_raising_clients
CREATE INDEX IF NOT EXISTS idx_capital_raising_clients_capital_id ON capital_raising_clients(capital_raising_id);
CREATE INDEX IF NOT EXISTS idx_capital_raising_clients_ativo ON capital_raising_clients(ativo);

-- =====================================================
-- TABELA DE EMPRÉSTIMOS QUITADOS
-- =====================================================
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

COMMENT ON TABLE paid_loans IS 'Tabela para armazenar empréstimos completamente quitados';

-- Índices para paid_loans
CREATE INDEX IF NOT EXISTS idx_paid_loans_loan_id ON paid_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_client_id ON paid_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_paid_date ON paid_loans(paid_date);
CREATE INDEX IF NOT EXISTS idx_paid_loans_created_by ON paid_loans(created_by);
CREATE INDEX IF NOT EXISTS idx_paid_loans_created_at ON paid_loans(created_at);

-- Função para atualizar updated_at em paid_loans
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
-- FIX: CONSTRAINT DE PAYMENT_TYPE NA TABELA PAYMENTS
-- =====================================================
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'payments') THEN
        -- Remover a constraint antiga
        ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;
        
        -- Atualizar comentário do campo
        COMMENT ON COLUMN payments.payment_type IS 'Tipo de operação do pagamento: interest_renewal (renovação), capital_payment, early_payment_partial_interest, early_payment_interest_renewal, early_payment_capital_reduction, partial_interest, loan_renewal, loan_reactivation, ou métodos como dinheiro, pix, cartao';
        
        RAISE NOTICE '✓ Constraint de payment_type removida com sucesso';
    ELSE
        RAISE NOTICE '⚠ Tabela payments não existe, pulando correção de constraint';
    END IF;
END $$;

-- =====================================================
-- POLÍTICAS DE SEGURANÇA (RLS)
-- =====================================================

-- Habilitar RLS nas tabelas
ALTER TABLE guarantors ENABLE ROW LEVEL SECURITY;
ALTER TABLE cash_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE cash_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE capital_raising ENABLE ROW LEVEL SECURITY;
ALTER TABLE capital_raising_clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;

-- Políticas para guarantors
DROP POLICY IF EXISTS "Usuários autenticados podem ver avalistas" ON guarantors;
CREATE POLICY "Usuários autenticados podem ver avalistas" ON guarantors
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem inserir avalistas" ON guarantors;
CREATE POLICY "Usuários autenticados podem inserir avalistas" ON guarantors
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem atualizar avalistas" ON guarantors;
CREATE POLICY "Usuários autenticados podem atualizar avalistas" ON guarantors
    FOR UPDATE USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem excluir avalistas" ON guarantors;
CREATE POLICY "Usuários autenticados podem excluir avalistas" ON guarantors
    FOR DELETE USING (auth.role() = 'authenticated');

-- Políticas para cash_transactions
DROP POLICY IF EXISTS "Usuários autenticados podem ver transações de caixa" ON cash_transactions;
CREATE POLICY "Usuários autenticados podem ver transações de caixa" ON cash_transactions
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem inserir transações de caixa" ON cash_transactions;
CREATE POLICY "Usuários autenticados podem inserir transações de caixa" ON cash_transactions
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem atualizar transações de caixa" ON cash_transactions;
CREATE POLICY "Usuários autenticados podem atualizar transações de caixa" ON cash_transactions
    FOR UPDATE USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem excluir transações de caixa" ON cash_transactions;
CREATE POLICY "Usuários autenticados podem excluir transações de caixa" ON cash_transactions
    FOR DELETE USING (auth.role() = 'authenticated');

-- Políticas para cash_settings
DROP POLICY IF EXISTS "Usuários autenticados podem ver configurações de caixa" ON cash_settings;
CREATE POLICY "Usuários autenticados podem ver configurações de caixa" ON cash_settings
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem atualizar configurações de caixa" ON cash_settings;
CREATE POLICY "Usuários autenticados podem atualizar configurações de caixa" ON cash_settings
    FOR UPDATE USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem inserir configurações de caixa" ON cash_settings;
CREATE POLICY "Usuários autenticados podem inserir configurações de caixa" ON cash_settings
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Políticas para capital_raising
DROP POLICY IF EXISTS "Usuários autenticados podem ver levantamentos" ON capital_raising;
CREATE POLICY "Usuários autenticados podem ver levantamentos" ON capital_raising
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem inserir levantamentos" ON capital_raising;
CREATE POLICY "Usuários autenticados podem inserir levantamentos" ON capital_raising
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem atualizar levantamentos" ON capital_raising;
CREATE POLICY "Usuários autenticados podem atualizar levantamentos" ON capital_raising
    FOR UPDATE USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem excluir levantamentos" ON capital_raising;
CREATE POLICY "Usuários autenticados podem excluir levantamentos" ON capital_raising
    FOR DELETE USING (auth.role() = 'authenticated');

-- Políticas para capital_raising_clients
DROP POLICY IF EXISTS "Usuários autenticados podem ver clientes de levantamento" ON capital_raising_clients;
CREATE POLICY "Usuários autenticados podem ver clientes de levantamento" ON capital_raising_clients
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem inserir clientes de levantamento" ON capital_raising_clients;
CREATE POLICY "Usuários autenticados podem inserir clientes de levantamento" ON capital_raising_clients
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem atualizar clientes de levantamento" ON capital_raising_clients;
CREATE POLICY "Usuários autenticados podem atualizar clientes de levantamento" ON capital_raising_clients
    FOR UPDATE USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem excluir clientes de levantamento" ON capital_raising_clients;
CREATE POLICY "Usuários autenticados podem excluir clientes de levantamento" ON capital_raising_clients
    FOR DELETE USING (auth.role() = 'authenticated');

-- Políticas para paid_loans
DROP POLICY IF EXISTS "Usuários autenticados podem ver empréstimos quitados" ON paid_loans;
CREATE POLICY "Usuários autenticados podem ver empréstimos quitados" ON paid_loans
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem inserir empréstimos quitados" ON paid_loans;
CREATE POLICY "Usuários autenticados podem inserir empréstimos quitados" ON paid_loans
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários podem atualizar seus empréstimos quitados" ON paid_loans;
CREATE POLICY "Usuários podem atualizar seus empréstimos quitados" ON paid_loans
    FOR UPDATE USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários podem excluir empréstimos quitados" ON paid_loans;
CREATE POLICY "Usuários podem excluir empréstimos quitados" ON paid_loans
    FOR DELETE USING (auth.role() = 'authenticated');

-- =====================================================
-- PERMISSÕES
-- =====================================================

GRANT SELECT, INSERT, UPDATE, DELETE ON guarantors TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON cash_transactions TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON cash_settings TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON capital_raising TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON capital_raising_clients TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON paid_loans TO authenticated;

-- Conceder permissões para uso de sequências
GRANT USAGE, SELECT ON SEQUENCE capital_raising_id_seq TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE capital_raising_clients_id_seq TO authenticated;

-- =====================================================
-- VIEWS ÚTEIS
-- =====================================================

DROP VIEW IF EXISTS cash_transactions_summary;
CREATE OR REPLACE VIEW cash_transactions_summary AS
SELECT 
    DATE(created_at) as transaction_date,
    transaction_type,
    COUNT(*) as transaction_count,
    SUM(amount) as total_amount
FROM cash_transactions
GROUP BY DATE(created_at), transaction_type
ORDER BY transaction_date DESC;

DROP VIEW IF EXISTS daily_cash_balance;
CREATE OR REPLACE VIEW daily_cash_balance AS
SELECT 
    DATE(created_at) as date,
    SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE -amount END) as daily_flow,
    SUM(SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE -amount END)) 
        OVER (ORDER BY DATE(created_at)) as running_balance
FROM cash_transactions
GROUP BY DATE(created_at)
ORDER BY date;

DROP VIEW IF EXISTS paid_loans_with_details;
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
DECLARE
    constraint_exists BOOLEAN;
BEGIN
    RAISE NOTICE '=====================================================';
    RAISE NOTICE 'VERIFICAÇÃO DO BANCO DE DADOS - v2';
    RAISE NOTICE '=====================================================';
    
    -- Verificar se a constraint de payment_type foi removida
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'payments') THEN
        SELECT EXISTS (
            SELECT 1 FROM pg_constraint 
            WHERE conrelid = 'payments'::regclass 
            AND conname = 'payments_payment_type_check'
        ) INTO constraint_exists;
        
        IF NOT constraint_exists THEN
            RAISE NOTICE '✓ Constraint de payment_type removida com sucesso';
        ELSE
            RAISE NOTICE '⚠ Constraint de payment_type ainda existe';
        END IF;
    END IF;
    
    -- Verificar tabelas criadas/atualizadas
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'guarantors') THEN
        RAISE NOTICE '✓ Tabela guarantors criada/atualizada com sucesso';
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'cash_transactions') THEN
        RAISE NOTICE '✓ Tabela cash_transactions criada com sucesso';
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'cash_settings') THEN
        RAISE NOTICE '✓ Tabela cash_settings criada com sucesso';
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'capital_raising') THEN
        RAISE NOTICE '✓ Tabela capital_raising criada com sucesso';
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'capital_raising_clients') THEN
        RAISE NOTICE '✓ Tabela capital_raising_clients criada com sucesso';
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'paid_loans') THEN
        RAISE NOTICE '✓ Tabela paid_loans criada com sucesso';
    END IF;
    
    RAISE NOTICE '=====================================================';
    RAISE NOTICE 'INSTALAÇÃO CONCLUÍDA COM SUCESSO!';
    RAISE NOTICE 'Todas as tabelas foram criadas/atualizadas.';
    RAISE NOTICE 'Atualize a aplicação (F5) para aplicar as mudanças.';
    RAISE NOTICE '=====================================================';
END $$;

-- =====================================================
-- FIM DA INSTALAÇÃO
-- =====================================================
