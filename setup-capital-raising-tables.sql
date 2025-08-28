-- =====================================================
-- CONFIGURAÇÃO TABELAS LEVANTAMENTO DE CAPITAL
-- =====================================================
-- Execute estes comandos no SQL Editor do Supabase
-- =====================================================

-- =====================================================
-- TABELA DE LEVANTAMENTOS DE CAPITAL
-- =====================================================
CREATE TABLE IF NOT EXISTS capital_raisings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    gross_amount DECIMAL(15,2) NOT NULL CHECK (gross_amount > 0),
    interest_rate DECIMAL(5,2) NOT NULL CHECK (interest_rate >= 0 AND interest_rate <= 100),
    total_amount DECIMAL(15,2) NOT NULL CHECK (total_amount > 0),
    raising_date DATE NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela de levantamentos de capital
COMMENT ON TABLE capital_raisings IS 'Tabela para armazenar levantamentos de capital';
COMMENT ON COLUMN capital_raisings.id IS 'Identificador único do levantamento';
COMMENT ON COLUMN capital_raisings.gross_amount IS 'Valor bruto do levantamento sem juros';
COMMENT ON COLUMN capital_raisings.interest_rate IS 'Taxa de juros em porcentagem';
COMMENT ON COLUMN capital_raisings.total_amount IS 'Valor total com juros (gross_amount + juros)';
COMMENT ON COLUMN capital_raisings.raising_date IS 'Data do levantamento';
COMMENT ON COLUMN capital_raisings.status IS 'Status do levantamento (active, completed, cancelled)';
COMMENT ON COLUMN capital_raisings.notes IS 'Observações sobre o levantamento';
COMMENT ON COLUMN capital_raisings.created_by IS 'Usuário que criou o levantamento';
COMMENT ON COLUMN capital_raisings.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN capital_raisings.updated_at IS 'Data da última atualização';

-- =====================================================
-- TABELA DE CLIENTES DO LEVANTAMENTO DE CAPITAL
-- =====================================================
CREATE TABLE IF NOT EXISTS capital_raising_clients (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    capital_raising_id UUID NOT NULL REFERENCES capital_raisings(id) ON DELETE CASCADE,
    client_name TEXT NOT NULL,
    client_amount DECIMAL(15,2) NOT NULL CHECK (client_amount > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela de clientes do levantamento
COMMENT ON TABLE capital_raising_clients IS 'Tabela para armazenar clientes associados aos levantamentos de capital';
COMMENT ON COLUMN capital_raising_clients.id IS 'Identificador único do cliente do levantamento';
COMMENT ON COLUMN capital_raising_clients.capital_raising_id IS 'Referência ao levantamento de capital';
COMMENT ON COLUMN capital_raising_clients.client_name IS 'Nome do cliente no levantamento';
COMMENT ON COLUMN capital_raising_clients.client_amount IS 'Valor individual do cliente no levantamento';
COMMENT ON COLUMN capital_raising_clients.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN capital_raising_clients.updated_at IS 'Data da última atualização';

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================

-- Índice para buscar levantamentos por status
CREATE INDEX IF NOT EXISTS idx_capital_raisings_status 
ON capital_raisings(status);

-- Índice para buscar levantamentos por data
CREATE INDEX IF NOT EXISTS idx_capital_raisings_date 
ON capital_raisings(raising_date);

-- Índice para buscar clientes por levantamento
CREATE INDEX IF NOT EXISTS idx_capital_raising_clients_raising_id 
ON capital_raising_clients(capital_raising_id);

-- Índice para buscar clientes por nome
CREATE INDEX IF NOT EXISTS idx_capital_raising_clients_name 
ON capital_raising_clients(client_name);

-- =====================================================
-- TRIGGERS PARA ATUALIZAÇÃO AUTOMÁTICA DE TIMESTAMPS
-- =====================================================

-- Função para atualizar timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para capital_raisings
DROP TRIGGER IF EXISTS update_capital_raisings_updated_at ON capital_raisings;
CREATE TRIGGER update_capital_raisings_updated_at
    BEFORE UPDATE ON capital_raisings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger para capital_raising_clients
DROP TRIGGER IF EXISTS update_capital_raising_clients_updated_at ON capital_raising_clients;
CREATE TRIGGER update_capital_raising_clients_updated_at
    BEFORE UPDATE ON capital_raising_clients
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- FUNÇÕES AUXILIARES
-- =====================================================

-- Função para calcular valor total com juros
CREATE OR REPLACE FUNCTION calculate_total_amount(gross_amount DECIMAL, interest_rate DECIMAL)
RETURNS DECIMAL AS $$
BEGIN
    RETURN gross_amount + (gross_amount * interest_rate / 100);
END;
$$ LANGUAGE plpgsql;

-- Função para obter estatísticas do levantamento
CREATE OR REPLACE FUNCTION get_capital_raising_stats(raising_id UUID)
RETURNS TABLE (
    total_clients INTEGER,
    total_client_amount DECIMAL,
    remaining_amount DECIMAL,
    percentage_distributed DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(crc.id)::INTEGER as total_clients,
        COALESCE(SUM(crc.client_amount), 0) as total_client_amount,
        (cr.total_amount - COALESCE(SUM(crc.client_amount), 0)) as remaining_amount,
        CASE 
            WHEN cr.total_amount > 0 THEN 
                (COALESCE(SUM(crc.client_amount), 0) / cr.total_amount * 100)
            ELSE 0 
        END as percentage_distributed
    FROM capital_raisings cr
    LEFT JOIN capital_raising_clients crc ON cr.id = crc.capital_raising_id
    WHERE cr.id = raising_id
    GROUP BY cr.id, cr.total_amount;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- POLÍTICAS DE SEGURANÇA (RLS)
-- =====================================================

-- Habilitar RLS nas tabelas
ALTER TABLE capital_raisings ENABLE ROW LEVEL SECURITY;
ALTER TABLE capital_raising_clients ENABLE ROW LEVEL SECURITY;

-- Política para capital_raisings - usuários autenticados podem ver todos
CREATE POLICY "Users can view all capital raisings" ON capital_raisings
    FOR SELECT USING (auth.role() = 'authenticated');

-- Política para capital_raisings - usuários autenticados podem inserir
CREATE POLICY "Users can insert capital raisings" ON capital_raisings
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Política para capital_raisings - usuários autenticados podem atualizar
CREATE POLICY "Users can update capital raisings" ON capital_raisings
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Política para capital_raisings - usuários autenticados podem deletar
CREATE POLICY "Users can delete capital raisings" ON capital_raisings
    FOR DELETE USING (auth.role() = 'authenticated');

-- Política para capital_raising_clients - usuários autenticados podem ver todos
CREATE POLICY "Users can view all capital raising clients" ON capital_raising_clients
    FOR SELECT USING (auth.role() = 'authenticated');

-- Política para capital_raising_clients - usuários autenticados podem inserir
CREATE POLICY "Users can insert capital raising clients" ON capital_raising_clients
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Política para capital_raising_clients - usuários autenticados podem atualizar
CREATE POLICY "Users can update capital raising clients" ON capital_raising_clients
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Política para capital_raising_clients - usuários autenticados podem deletar
CREATE POLICY "Users can delete capital raising clients" ON capital_raising_clients
    FOR DELETE USING (auth.role() = 'authenticated');

-- =====================================================
-- DADOS DE EXEMPLO (OPCIONAL)
-- =====================================================

-- Inserir levantamento de exemplo
-- INSERT INTO capital_raisings (gross_amount, interest_rate, total_amount, raising_date, notes)
-- VALUES (10000.00, 20.00, 12000.00, CURRENT_DATE, 'Levantamento de exemplo');

-- =====================================================
-- FIM DA CONFIGURAÇÃO
-- =====================================================