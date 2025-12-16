-- CONFIGURAÇÃO DO CONTROLE FINANCEIRO - FRANCA PRIVATE
-- Este script cria as tabelas necessárias para o controle financeiro
-- Data: 16/12/2025

-- Criar tabela de controle de caixa
CREATE TABLE IF NOT EXISTS financial_control (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    cash_balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    last_commission_date TIMESTAMP WITH TIME ZONE,
    next_commission_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar tabela de transações financeiras
CREATE TABLE IF NOT EXISTS financial_transactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    transaction_type VARCHAR(50) NOT NULL, -- 'commission', 'expense', 'reinvestment'
    description TEXT,
    amount DECIMAL(10, 2) NOT NULL,
    balance_after DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100),
    notes TEXT,
    transaction_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar tabela para armazenar comissões coletadas de todas as empresas
CREATE TABLE IF NOT EXISTS collected_commissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    commission_amount DECIMAL(10, 2) NOT NULL,
    collection_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    period_start DATE,
    period_end DATE,
    added_to_cash BOOLEAN DEFAULT FALSE,
    added_to_cash_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Inserir registro inicial de controle financeiro se não existir
INSERT INTO financial_control (cash_balance, last_commission_date, next_commission_date)
SELECT 0.00, NOW(), NOW() + INTERVAL '7 days'
WHERE NOT EXISTS (SELECT 1 FROM financial_control);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_financial_transactions_type ON financial_transactions(transaction_type);
CREATE INDEX IF NOT EXISTS idx_financial_transactions_date ON financial_transactions(transaction_date);
CREATE INDEX IF NOT EXISTS idx_collected_commissions_company ON collected_commissions(company_name);
CREATE INDEX IF NOT EXISTS idx_collected_commissions_date ON collected_commissions(collection_date);
CREATE INDEX IF NOT EXISTS idx_collected_commissions_added ON collected_commissions(added_to_cash);

-- Criar função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger para atualizar updated_at
DROP TRIGGER IF EXISTS update_financial_control_updated_at ON financial_control;
CREATE TRIGGER update_financial_control_updated_at
    BEFORE UPDATE ON financial_control
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Comentários nas tabelas
COMMENT ON TABLE financial_control IS 'Controla o saldo de caixa e datas de adição de comissões';
COMMENT ON TABLE financial_transactions IS 'Registra todas as transações (comissões, despesas, reinvestimentos)';
COMMENT ON TABLE collected_commissions IS 'Armazena as comissões coletadas de todas as empresas';

-- Mensagem de sucesso
DO $$
BEGIN
    RAISE NOTICE '==============================================';
    RAISE NOTICE '✅ CONTROLE FINANCEIRO CONFIGURADO COM SUCESSO!';
    RAISE NOTICE '==============================================';
    RAISE NOTICE '';
    RAISE NOTICE 'Tabelas criadas:';
    RAISE NOTICE '  ✓ financial_control - Saldo de caixa';
    RAISE NOTICE '  ✓ financial_transactions - Transações';
    RAISE NOTICE '  ✓ collected_commissions - Comissões coletadas';
    RAISE NOTICE '';
    RAISE NOTICE 'Próximos passos:';
    RAISE NOTICE '  1. Acesse o sistema Franca Private';
    RAISE NOTICE '  2. Vá para a aba "Controle Financeiro"';
    RAISE NOTICE '  3. O sistema buscará automaticamente as comissões';
    RAISE NOTICE '';
END $$;
