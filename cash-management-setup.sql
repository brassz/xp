-- =====================================================
-- CONFIGURAÇÃO DA TABELA DE GESTÃO DE CAIXA
-- =====================================================
-- Execute este comando no SQL Editor do Supabase
-- =====================================================

-- =====================================================
-- TABELA DE TRANSAÇÕES DE CAIXA
-- =====================================================
CREATE TABLE IF NOT EXISTS cash_transactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('deposit', 'withdrawal')),
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    description TEXT,
    reference_id UUID, -- Para referenciar empréstimos, despesas, etc.
    reference_type TEXT CHECK (reference_type IN ('loan', 'expense', 'manual', 'installment')),
    balance_after DECIMAL(15,2) NOT NULL,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela de transações de caixa
COMMENT ON TABLE cash_transactions IS 'Tabela para registrar todas as transações de entrada e saída de dinheiro do caixa';
COMMENT ON COLUMN cash_transactions.id IS 'Identificador único da transação';
COMMENT ON COLUMN cash_transactions.transaction_type IS 'Tipo da transação: deposit (entrada) ou withdrawal (saída)';
COMMENT ON COLUMN cash_transactions.amount IS 'Valor da transação (sempre positivo)';
COMMENT ON COLUMN cash_transactions.description IS 'Descrição da transação';
COMMENT ON COLUMN cash_transactions.reference_id IS 'ID de referência para empréstimos, despesas, etc.';
COMMENT ON COLUMN cash_transactions.reference_type IS 'Tipo da referência (loan, expense, manual, installment)';
COMMENT ON COLUMN cash_transactions.balance_after IS 'Saldo do caixa após a transação';
COMMENT ON COLUMN cash_transactions.created_by IS 'Usuário que criou a transação';
COMMENT ON COLUMN cash_transactions.created_at IS 'Data de criação da transação';
COMMENT ON COLUMN cash_transactions.updated_at IS 'Data da última atualização';

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

-- Comentários da tabela de configuração do caixa
COMMENT ON TABLE cash_settings IS 'Tabela para armazenar as configurações e saldo atual do caixa';
COMMENT ON COLUMN cash_settings.id IS 'Identificador único da configuração';
COMMENT ON COLUMN cash_settings.current_balance IS 'Saldo atual do caixa';
COMMENT ON COLUMN cash_settings.initial_balance IS 'Saldo inicial configurado';
COMMENT ON COLUMN cash_settings.last_updated IS 'Data da última atualização do saldo';
COMMENT ON COLUMN cash_settings.updated_by IS 'Usuário que fez a última atualização';

-- Inserir configuração inicial do caixa (caso não exista)
INSERT INTO cash_settings (current_balance, initial_balance) 
SELECT 0, 0 
WHERE NOT EXISTS (SELECT 1 FROM cash_settings);

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_cash_transactions_type ON cash_transactions(transaction_type);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_date ON cash_transactions(created_at);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_user ON cash_transactions(created_by);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_reference ON cash_transactions(reference_id, reference_type);

-- =====================================================
-- POLÍTICAS DE SEGURANÇA (RLS)
-- =====================================================
-- Habilitar RLS para as tabelas
ALTER TABLE cash_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE cash_settings ENABLE ROW LEVEL SECURITY;

-- Política para cash_transactions: usuários autenticados podem ver e inserir
CREATE POLICY "Usuários autenticados podem ver transações de caixa" ON cash_transactions
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Usuários autenticados podem inserir transações de caixa" ON cash_transactions
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Usuários autenticados podem atualizar transações de caixa" ON cash_transactions
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Política para cash_settings: usuários autenticados podem ver e atualizar
CREATE POLICY "Usuários autenticados podem ver configurações de caixa" ON cash_settings
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Usuários autenticados podem atualizar configurações de caixa" ON cash_settings
    FOR UPDATE USING (auth.role() = 'authenticated');

-- =====================================================
-- FUNÇÃO PARA ATUALIZAR SALDO DO CAIXA
-- =====================================================
CREATE OR REPLACE FUNCTION update_cash_balance()
RETURNS TRIGGER AS $$
BEGIN
    -- Atualizar o saldo na tabela cash_settings
    UPDATE cash_settings 
    SET current_balance = NEW.balance_after,
        last_updated = NOW(),
        updated_by = NEW.created_by
    WHERE id = (SELECT id FROM cash_settings LIMIT 1);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para atualizar saldo automaticamente
CREATE TRIGGER trigger_update_cash_balance
    AFTER INSERT ON cash_transactions
    FOR EACH ROW
    EXECUTE FUNCTION update_cash_balance();

-- =====================================================
-- VIEWS ÚTEIS
-- =====================================================

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