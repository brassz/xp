-- =====================================================
-- CRIAR TABELA DE MULTAS DE CLIENTES
-- =====================================================
-- Este script cria uma tabela para gerenciar multas aplicadas diretamente aos clientes
-- Independente dos pagamentos de empréstimos

-- Criar tabela client_fines
CREATE TABLE IF NOT EXISTS client_fines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    fine_amount DECIMAL(10,2) NOT NULL CHECK (fine_amount > 0),
    description TEXT,
    fine_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Adicionar comentários explicativos
COMMENT ON TABLE client_fines IS 'Tabela para gerenciar multas aplicadas diretamente aos clientes';
COMMENT ON COLUMN client_fines.client_id IS 'ID do cliente que recebeu a multa';
COMMENT ON COLUMN client_fines.company_id IS 'ID da empresa que aplicou a multa';
COMMENT ON COLUMN client_fines.fine_amount IS 'Valor da multa aplicada';
COMMENT ON COLUMN client_fines.description IS 'Descrição ou motivo da multa';
COMMENT ON COLUMN client_fines.fine_date IS 'Data em que a multa foi aplicada';
COMMENT ON COLUMN client_fines.created_by IS 'ID do usuário que criou a multa';

-- Criar índices para melhorar performance
CREATE INDEX IF NOT EXISTS idx_client_fines_client_id ON client_fines(client_id);
CREATE INDEX IF NOT EXISTS idx_client_fines_company_id ON client_fines(company_id);
CREATE INDEX IF NOT EXISTS idx_client_fines_fine_date ON client_fines(fine_date);
CREATE INDEX IF NOT EXISTS idx_client_fines_created_at ON client_fines(created_at);

-- Criar trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION update_client_fines_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_client_fines_updated_at
    BEFORE UPDATE ON client_fines
    FOR EACH ROW
    EXECUTE FUNCTION update_client_fines_updated_at();

-- Verificar se a tabela foi criada corretamente
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'client_fines'
ORDER BY ordinal_position;

-- Exemplo de consultas úteis:

-- Total de multas por cliente
/*
SELECT 
    c.name as cliente,
    c.cpf,
    COUNT(*) as quantidade_multas,
    SUM(cf.fine_amount) as total_multas
FROM client_fines cf
JOIN clients c ON c.id = cf.client_id
WHERE cf.company_id = 'YOUR_COMPANY_ID'
GROUP BY c.id, c.name, c.cpf
ORDER BY total_multas DESC;
*/

-- Multas aplicadas em um período
/*
SELECT 
    c.name as cliente,
    cf.fine_amount,
    cf.description,
    cf.fine_date,
    u.name as aplicado_por
FROM client_fines cf
JOIN clients c ON c.id = cf.client_id
LEFT JOIN users u ON u.id = cf.created_by
WHERE cf.company_id = 'YOUR_COMPANY_ID'
  AND cf.fine_date >= 'START_DATE'
  AND cf.fine_date <= 'END_DATE'
ORDER BY cf.fine_date DESC;
*/

-- Total de multas por período
/*
SELECT 
    DATE_TRUNC('month', fine_date) as mes,
    COUNT(*) as quantidade_multas,
    SUM(fine_amount) as total_multas
FROM client_fines
WHERE company_id = 'YOUR_COMPANY_ID'
GROUP BY DATE_TRUNC('month', fine_date)
ORDER BY mes DESC;
*/
