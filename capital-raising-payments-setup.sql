-- Criação da tabela para pagamentos de levantamento de capital
-- Esta tabela armazena todos os pagamentos feitos pelos clientes

-- Tabela para pagamentos dos clientes de levantamento de capital
CREATE TABLE IF NOT EXISTS capital_raising_payments (
    id SERIAL PRIMARY KEY,
    capital_raising_client_id INTEGER NOT NULL,
    valor_pagamento DECIMAL(15,2) NOT NULL,
    data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_vencimento DATE,
    status_pagamento VARCHAR(20) DEFAULT 'confirmado' CHECK (status_pagamento IN ('confirmado', 'pendente', 'cancelado')),
    metodo_pagamento VARCHAR(50),
    observacoes TEXT,
    comprovante_url TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (capital_raising_client_id) REFERENCES capital_raising_clients(id) ON DELETE CASCADE
);

-- Adicionar campo para valor total pago na tabela de clientes
ALTER TABLE capital_raising_clients 
ADD COLUMN IF NOT EXISTS valor_total_pago DECIMAL(15,2) DEFAULT 0;

-- Adicionar campo para saldo devedor na tabela de clientes
ALTER TABLE capital_raising_clients 
ADD COLUMN IF NOT EXISTS saldo_devedor DECIMAL(15,2) DEFAULT 0;

-- Índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_capital_raising_payments_client_id ON capital_raising_payments(capital_raising_client_id);
CREATE INDEX IF NOT EXISTS idx_capital_raising_payments_status ON capital_raising_payments(status_pagamento);
CREATE INDEX IF NOT EXISTS idx_capital_raising_payments_data ON capital_raising_payments(data_pagamento);

-- Trigger para atualizar data_atualizacao em pagamentos
CREATE OR REPLACE FUNCTION update_capital_raising_payments_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_capital_raising_payments_timestamp 
    BEFORE UPDATE ON capital_raising_payments 
    FOR EACH ROW EXECUTE FUNCTION update_capital_raising_payments_timestamp();

-- Função para atualizar valores totais do cliente
CREATE OR REPLACE FUNCTION update_capital_client_totals()
RETURNS TRIGGER AS $$
BEGIN
    -- Atualizar valor total pago e saldo devedor do cliente
    UPDATE capital_raising_clients 
    SET 
        valor_total_pago = (
            SELECT COALESCE(SUM(valor_pagamento), 0) 
            FROM capital_raising_payments 
            WHERE capital_raising_client_id = COALESCE(NEW.capital_raising_client_id, OLD.capital_raising_client_id)
            AND status_pagamento = 'confirmado'
        ),
        saldo_devedor = valor_individual - (
            SELECT COALESCE(SUM(valor_pagamento), 0) 
            FROM capital_raising_payments 
            WHERE capital_raising_client_id = COALESCE(NEW.capital_raising_client_id, OLD.capital_raising_client_id)
            AND status_pagamento = 'confirmado'
        )
    WHERE id = COALESCE(NEW.capital_raising_client_id, OLD.capital_raising_client_id);
    
    RETURN COALESCE(NEW, OLD);
END;
$$ language 'plpgsql';

-- Triggers para atualizar totais quando pagamentos são inseridos, atualizados ou deletados
CREATE TRIGGER trigger_update_client_totals_on_insert 
    AFTER INSERT ON capital_raising_payments 
    FOR EACH ROW EXECUTE FUNCTION update_capital_client_totals();

CREATE TRIGGER trigger_update_client_totals_on_update 
    AFTER UPDATE ON capital_raising_payments 
    FOR EACH ROW EXECUTE FUNCTION update_capital_client_totals();

CREATE TRIGGER trigger_update_client_totals_on_delete 
    AFTER DELETE ON capital_raising_payments 
    FOR EACH ROW EXECUTE FUNCTION update_capital_client_totals();

-- Atualizar saldos devedores existentes
UPDATE capital_raising_clients 
SET saldo_devedor = valor_individual - valor_total_pago;

-- Comentários nas tabelas
COMMENT ON TABLE capital_raising_payments IS 'Tabela para armazenar pagamentos dos clientes de levantamento de capital';
COMMENT ON COLUMN capital_raising_payments.valor_pagamento IS 'Valor do pagamento realizado';
COMMENT ON COLUMN capital_raising_payments.data_pagamento IS 'Data em que o pagamento foi realizado';
COMMENT ON COLUMN capital_raising_payments.data_vencimento IS 'Data de vencimento do pagamento (se aplicável)';
COMMENT ON COLUMN capital_raising_payments.status_pagamento IS 'Status do pagamento: confirmado, pendente ou cancelado';
COMMENT ON COLUMN capital_raising_payments.metodo_pagamento IS 'Método utilizado para o pagamento (PIX, transferência, etc.)';
COMMENT ON COLUMN capital_raising_clients.valor_total_pago IS 'Soma de todos os pagamentos confirmados do cliente';
COMMENT ON COLUMN capital_raising_clients.saldo_devedor IS 'Valor restante que o cliente deve pagar';