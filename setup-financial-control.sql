-- =====================================================
-- CONFIGURAÇÃO DO CONTROLE FINANCEIRO - FRANCA PRIVATE
-- =====================================================
-- Execute este script no SQL Editor do Supabase da Franca Private
-- =====================================================

-- Criar tabela de controle de caixa
CREATE TABLE IF NOT EXISTS financial_control (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    current_balance DECIMAL(10, 2) NOT NULL DEFAULT 0,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    next_addition_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela
COMMENT ON TABLE financial_control IS 'Tabela para controle de caixa consolidado';
COMMENT ON COLUMN financial_control.id IS 'Identificador único';
COMMENT ON COLUMN financial_control.current_balance IS 'Saldo atual do caixa';
COMMENT ON COLUMN financial_control.last_update IS 'Data da última atualização';
COMMENT ON COLUMN financial_control.next_addition_date IS 'Data da próxima adição ao caixa (a cada 7 dias)';
COMMENT ON COLUMN financial_control.created_at IS 'Data de criação';
COMMENT ON COLUMN financial_control.updated_at IS 'Data da última atualização';

-- Criar tabela de transações financeiras
CREATE TABLE IF NOT EXISTS financial_transactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    type VARCHAR(20) NOT NULL CHECK (type IN ('commission', 'expense', 'reinvestment')),
    description TEXT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date DATE NOT NULL,
    notes TEXT,
    balance_after DECIMAL(10, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela
COMMENT ON TABLE financial_transactions IS 'Tabela para histórico de transações financeiras';
COMMENT ON COLUMN financial_transactions.id IS 'Identificador único da transação';
COMMENT ON COLUMN financial_transactions.type IS 'Tipo de transação: commission (comissão), expense (despesa), reinvestment (reinvestimento)';
COMMENT ON COLUMN financial_transactions.description IS 'Descrição da transação';
COMMENT ON COLUMN financial_transactions.amount IS 'Valor da transação (positivo para entrada, negativo para saída)';
COMMENT ON COLUMN financial_transactions.transaction_date IS 'Data da transação';
COMMENT ON COLUMN financial_transactions.notes IS 'Observações adicionais';
COMMENT ON COLUMN financial_transactions.balance_after IS 'Saldo após a transação';
COMMENT ON COLUMN financial_transactions.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN financial_transactions.updated_at IS 'Data da última atualização';

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_financial_transactions_type ON financial_transactions(type);
CREATE INDEX IF NOT EXISTS idx_financial_transactions_date ON financial_transactions(transaction_date);
CREATE INDEX IF NOT EXISTS idx_financial_transactions_created_at ON financial_transactions(created_at);

-- Criar tabela de comissões consolidadas (cache de comissões de todas as empresas)
CREATE TABLE IF NOT EXISTS commission_cache (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    commission_amount DECIMAL(10, 2) NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    cached_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela
COMMENT ON TABLE commission_cache IS 'Cache de comissões do Vinicius de todas as empresas';
COMMENT ON COLUMN commission_cache.id IS 'Identificador único';
COMMENT ON COLUMN commission_cache.company_name IS 'Nome da empresa';
COMMENT ON COLUMN commission_cache.commission_amount IS 'Valor da comissão do Vinicius';
COMMENT ON COLUMN commission_cache.period_start IS 'Data de início do período';
COMMENT ON COLUMN commission_cache.period_end IS 'Data de fim do período';
COMMENT ON COLUMN commission_cache.cached_at IS 'Quando foi armazenado em cache';
COMMENT ON COLUMN commission_cache.created_at IS 'Data de criação';

-- Índices para o cache de comissões
CREATE INDEX IF NOT EXISTS idx_commission_cache_period ON commission_cache(period_start, period_end);
CREATE INDEX IF NOT EXISTS idx_commission_cache_company ON commission_cache(company_name);

-- Trigger para atualizar updated_at automaticamente
CREATE TRIGGER update_financial_control_updated_at 
    BEFORE UPDATE ON financial_control 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_financial_transactions_updated_at 
    BEFORE UPDATE ON financial_transactions 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Habilitar RLS nas tabelas
ALTER TABLE financial_control ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE commission_cache ENABLE ROW LEVEL SECURITY;

-- Políticas para controle financeiro (apenas usuários autenticados)
CREATE POLICY "Authenticated users can view financial control" ON financial_control
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update financial control" ON financial_control
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert financial control" ON financial_control
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Políticas para transações financeiras
CREATE POLICY "Authenticated users can view transactions" ON financial_transactions
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert transactions" ON financial_transactions
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update transactions" ON financial_transactions
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can delete transactions" ON financial_transactions
    FOR DELETE USING (auth.role() = 'authenticated');

-- Políticas para cache de comissões
CREATE POLICY "Authenticated users can view commission cache" ON commission_cache
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert commission cache" ON commission_cache
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update commission cache" ON commission_cache
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Inserir registro inicial de controle financeiro
INSERT INTO financial_control (current_balance, next_addition_date)
VALUES (0, CURRENT_DATE + INTERVAL '7 days')
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
AND table_name IN ('financial_control', 'financial_transactions', 'commission_cache')
ORDER BY table_name;

-- Verificar se os índices foram criados
SELECT 
    indexname,
    tablename
FROM pg_indexes 
WHERE tablename IN ('financial_transactions', 'commission_cache')
ORDER BY tablename, indexname;

-- =====================================================
-- FIM DA CONFIGURAÇÃO
-- =====================================================

-- INSTRUÇÕES DE USO:
-- 1. Acesse o Supabase da Franca Private
-- 2. Vá para SQL Editor
-- 3. Cole este script completo
-- 4. Execute (Run)
-- 5. Verifique se não há erros
-- 
-- Após a execução, a funcionalidade de Controle Financeiro 
-- estará disponível na aba correspondente do sistema.
