-- ===================================================
-- CRIAÇÃO DAS TABELAS PARA LEVANTAMENTO DE CAPITAL
-- ===================================================

-- Tabela principal para os levantamentos de capital
CREATE TABLE IF NOT EXISTS capital_raising (
    id SERIAL PRIMARY KEY,
    gross_amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL,
    raised_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'active',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela para os clientes dos levantamentos de capital
CREATE TABLE IF NOT EXISTS capital_clients (
    id SERIAL PRIMARY KEY,
    capital_raising_id INTEGER REFERENCES capital_raising(id) ON DELETE CASCADE,
    client_name VARCHAR(255) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    document VARCHAR(50),
    phone VARCHAR(20),
    notes TEXT,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_capital_raising_date ON capital_raising(raised_date);
CREATE INDEX IF NOT EXISTS idx_capital_raising_status ON capital_raising(status);
CREATE INDEX IF NOT EXISTS idx_capital_clients_capital_id ON capital_clients(capital_raising_id);
CREATE INDEX IF NOT EXISTS idx_capital_clients_status ON capital_clients(status);

-- Comentários nas tabelas
COMMENT ON TABLE capital_raising IS 'Tabela para armazenar os levantamentos de capital';
COMMENT ON COLUMN capital_raising.gross_amount IS 'Valor bruto levantado';
COMMENT ON COLUMN capital_raising.interest_rate IS 'Taxa de juros aplicada (%)';
COMMENT ON COLUMN capital_raising.total_amount IS 'Valor total com juros';
COMMENT ON COLUMN capital_raising.status IS 'Status do levantamento: active, completed, cancelled';

COMMENT ON TABLE capital_clients IS 'Tabela para armazenar os clientes associados aos levantamentos';
COMMENT ON COLUMN capital_clients.client_name IS 'Nome do cliente no levantamento';
COMMENT ON COLUMN capital_clients.amount IS 'Valor individual do cliente';
COMMENT ON COLUMN capital_clients.document IS 'CPF ou RG do cliente';
COMMENT ON COLUMN capital_clients.status IS 'Status do cliente: active, paid, cancelled';

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar o trigger nas tabelas
CREATE TRIGGER update_capital_raising_updated_at BEFORE UPDATE ON capital_raising FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_capital_clients_updated_at BEFORE UPDATE ON capital_clients FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ===================================================
-- FUNÇÕES AUXILIARES
-- ===================================================

-- Função para calcular o total distribuído de um levantamento
CREATE OR REPLACE FUNCTION get_capital_distributed_amount(capital_id INTEGER)
RETURNS DECIMAL(15,2) AS $$
BEGIN
    RETURN COALESCE(
        (SELECT SUM(amount) FROM capital_clients WHERE capital_raising_id = capital_id AND status = 'active'),
        0
    );
END;
$$ LANGUAGE plpgsql;

-- Função para calcular o saldo disponível de um levantamento
CREATE OR REPLACE FUNCTION get_capital_available_balance(capital_id INTEGER)
RETURNS DECIMAL(15,2) AS $$
DECLARE
    total_amount DECIMAL(15,2);
    distributed_amount DECIMAL(15,2);
BEGIN
    SELECT cr.total_amount INTO total_amount 
    FROM capital_raising cr 
    WHERE cr.id = capital_id;
    
    SELECT get_capital_distributed_amount(capital_id) INTO distributed_amount;
    
    RETURN COALESCE(total_amount, 0) - COALESCE(distributed_amount, 0);
END;
$$ LANGUAGE plpgsql;

-- ===================================================
-- VIEWS ÚTEIS
-- ===================================================

-- View para relatório completo dos levantamentos
CREATE OR REPLACE VIEW capital_raising_summary AS
SELECT 
    cr.id,
    cr.gross_amount,
    cr.interest_rate,
    cr.total_amount,
    cr.raised_date,
    cr.status,
    cr.notes,
    COUNT(cc.id) as total_clients,
    COALESCE(SUM(cc.amount), 0) as distributed_amount,
    cr.total_amount - COALESCE(SUM(cc.amount), 0) as available_balance,
    cr.created_at,
    cr.updated_at
FROM capital_raising cr
LEFT JOIN capital_clients cc ON cr.id = cc.capital_raising_id AND cc.status = 'active'
GROUP BY cr.id, cr.gross_amount, cr.interest_rate, cr.total_amount, cr.raised_date, cr.status, cr.notes, cr.created_at, cr.updated_at
ORDER BY cr.raised_date DESC;

-- View para clientes dos levantamentos com informações do levantamento
CREATE OR REPLACE VIEW capital_clients_with_raising AS
SELECT 
    cc.id,
    cc.capital_raising_id,
    cc.client_name,
    cc.amount,
    cc.document,
    cc.phone,
    cc.notes as client_notes,
    cc.status as client_status,
    cr.gross_amount,
    cr.interest_rate,
    cr.total_amount as raising_total,
    cr.raised_date,
    cr.status as raising_status,
    cr.notes as raising_notes,
    cc.created_at,
    cc.updated_at
FROM capital_clients cc
JOIN capital_raising cr ON cc.capital_raising_id = cr.id
ORDER BY cr.raised_date DESC, cc.created_at ASC;

-- ===================================================
-- DADOS DE EXEMPLO (OPCIONAL)
-- ===================================================

-- Inserir dados de exemplo para demonstração
-- INSERT INTO capital_raising (gross_amount, interest_rate, total_amount, raised_date, notes) 
-- VALUES 
--     (10000.00, 20.00, 12000.00, CURRENT_DATE, 'Primeiro levantamento de capital'),
--     (5000.00, 15.00, 5750.00, CURRENT_DATE - INTERVAL '7 days', 'Segundo levantamento menor');

-- INSERT INTO capital_clients (capital_raising_id, client_name, amount, document, phone)
-- VALUES 
--     (1, 'João Silva', 1200.00, '123.456.789-00', '(11) 99999-0001'),
--     (1, 'Maria Santos', 1200.00, '987.654.321-00', '(11) 99999-0002'),
--     (1, 'Pedro Oliveira', 1200.00, '456.789.123-00', '(11) 99999-0003'),
--     (2, 'Ana Costa', 600.00, '321.654.987-00', '(11) 99999-0004'),
--     (2, 'Carlos Lima', 800.00, '159.753.486-00', '(11) 99999-0005');