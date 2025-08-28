-- Capital Raising Tables Setup
-- Este script cria as tabelas necessárias para o módulo de Levantamento de Capital

-- Tabela principal de levantamentos de capital
CREATE TABLE IF NOT EXISTS capital_raisings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    description TEXT NOT NULL,
    gross_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    interest_rate DECIMAL(5,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de clientes dos levantamentos
CREATE TABLE IF NOT EXISTS raising_clients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    raising_id UUID NOT NULL REFERENCES capital_raisings(id) ON DELETE CASCADE,
    client_name VARCHAR(255) NOT NULL,
    client_cpf VARCHAR(14) NOT NULL,
    amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para otimizar consultas
CREATE INDEX IF NOT EXISTS idx_capital_raisings_status ON capital_raisings(status);
CREATE INDEX IF NOT EXISTS idx_capital_raisings_created_at ON capital_raisings(created_at);
CREATE INDEX IF NOT EXISTS idx_raising_clients_raising_id ON raising_clients(raising_id);
CREATE INDEX IF NOT EXISTS idx_raising_clients_cpf ON raising_clients(client_cpf);
CREATE INDEX IF NOT EXISTS idx_raising_clients_status ON raising_clients(status);

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_capital_raising_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_capital_raisings_updated_at
    BEFORE UPDATE ON capital_raisings
    FOR EACH ROW
    EXECUTE FUNCTION update_capital_raising_updated_at();

CREATE TRIGGER trigger_raising_clients_updated_at
    BEFORE UPDATE ON raising_clients
    FOR EACH ROW
    EXECUTE FUNCTION update_capital_raising_updated_at();

-- Função para calcular o valor total com juros
CREATE OR REPLACE FUNCTION calculate_total_with_interest(gross_amount DECIMAL, interest_rate DECIMAL)
RETURNS DECIMAL AS $$
BEGIN
    RETURN gross_amount + (gross_amount * interest_rate / 100);
END;
$$ LANGUAGE plpgsql;

-- View para resumo dos levantamentos
CREATE OR REPLACE VIEW capital_raising_summary AS
SELECT 
    cr.id,
    cr.description,
    cr.gross_amount,
    cr.interest_rate,
    cr.total_amount,
    cr.status,
    cr.created_at,
    COUNT(rc.id) as total_clients,
    COALESCE(SUM(rc.amount), 0) as total_client_amount,
    (cr.total_amount - COALESCE(SUM(rc.amount), 0)) as remaining_amount
FROM capital_raisings cr
LEFT JOIN raising_clients rc ON cr.id = rc.raising_id AND rc.status = 'active'
WHERE cr.status = 'active'
GROUP BY cr.id, cr.description, cr.gross_amount, cr.interest_rate, cr.total_amount, cr.status, cr.created_at
ORDER BY cr.created_at DESC;

-- Política RLS (Row Level Security) para multi-tenancy se necessário
-- ALTER TABLE capital_raisings ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE raising_clients ENABLE ROW LEVEL SECURITY;

-- Comentários nas tabelas
COMMENT ON TABLE capital_raisings IS 'Tabela para armazenar informações dos levantamentos de capital';
COMMENT ON TABLE raising_clients IS 'Tabela para armazenar clientes associados aos levantamentos de capital';

COMMENT ON COLUMN capital_raisings.description IS 'Descrição do levantamento de capital';
COMMENT ON COLUMN capital_raisings.gross_amount IS 'Valor bruto do levantamento';
COMMENT ON COLUMN capital_raisings.interest_rate IS 'Taxa de juros em percentual';
COMMENT ON COLUMN capital_raisings.total_amount IS 'Valor total com juros incluídos';
COMMENT ON COLUMN capital_raisings.status IS 'Status do levantamento: active, completed, cancelled';

COMMENT ON COLUMN raising_clients.raising_id IS 'ID do levantamento associado';
COMMENT ON COLUMN raising_clients.client_name IS 'Nome completo do cliente';
COMMENT ON COLUMN raising_clients.client_cpf IS 'CPF do cliente (formato XXX.XXX.XXX-XX)';
COMMENT ON COLUMN raising_clients.amount IS 'Valor que o cliente deve contribuir';
COMMENT ON COLUMN raising_clients.status IS 'Status do cliente: active, inactive';

-- Dados de exemplo (opcional - remover em produção)
-- INSERT INTO capital_raisings (description, gross_amount, interest_rate, total_amount) 
-- VALUES ('Levantamento Q1 2024', 10000.00, 20.00, 12000.00);

-- Verificação final
SELECT 'Capital Raising tables created successfully!' as status;