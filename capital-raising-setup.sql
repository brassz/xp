-- Criação da tabela para Levantamento de Capital
-- Esta funcionalidade é independente de empréstimos e clientes

-- Tabela principal de levantamentos de capital
CREATE TABLE IF NOT EXISTS capital_raising (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    valor_bruto DECIMAL(15,2) NOT NULL,
    taxa_juros DECIMAL(5,2) NOT NULL DEFAULT 0,
    valor_total DECIMAL(15,2) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    observacoes TEXT,
    user_id VARCHAR(255) NOT NULL
);

-- Tabela para clientes do levantamento de capital
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
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (capital_raising_id) REFERENCES capital_raising(id) ON DELETE CASCADE
);

-- Índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_capital_raising_user_id ON capital_raising(user_id);
CREATE INDEX IF NOT EXISTS idx_capital_raising_ativo ON capital_raising(ativo);
CREATE INDEX IF NOT EXISTS idx_capital_raising_clients_capital_id ON capital_raising_clients(capital_raising_id);
CREATE INDEX IF NOT EXISTS idx_capital_raising_clients_ativo ON capital_raising_clients(ativo);

-- Trigger para atualizar data_atualizacao
CREATE OR REPLACE FUNCTION update_capital_raising_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.data_atualizacao = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_capital_raising_timestamp 
    BEFORE UPDATE ON capital_raising 
    FOR EACH ROW EXECUTE FUNCTION update_capital_raising_timestamp();

-- Comentários nas tabelas
COMMENT ON TABLE capital_raising IS 'Tabela para gerenciar levantamentos de capital independente de empréstimos';
COMMENT ON TABLE capital_raising_clients IS 'Tabela para clientes vinculados a um levantamento de capital específico';

COMMENT ON COLUMN capital_raising.nome IS 'Nome/descrição do levantamento';
COMMENT ON COLUMN capital_raising.valor_bruto IS 'Valor bruto inicial do levantamento';
COMMENT ON COLUMN capital_raising.taxa_juros IS 'Taxa de juros aplicada (em percentual)';
COMMENT ON COLUMN capital_raising.valor_total IS 'Valor total com juros aplicados';
COMMENT ON COLUMN capital_raising_clients.valor_individual IS 'Valor que cada cliente deve contribuir';