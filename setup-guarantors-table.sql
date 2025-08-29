-- =====================================================
-- TABELA DE AVALISTAS
-- =====================================================
-- Script para criar a tabela de avalistas relacionada aos clientes

CREATE TABLE IF NOT EXISTS guarantors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    cpf TEXT NOT NULL,
    rg TEXT,
    email TEXT,
    phone TEXT NOT NULL,
    address TEXT,
    birth_date DATE,
    relationship TEXT, -- Relacionamento com o cliente (ex: cônjuge, parente, amigo)
    photo TEXT, -- URL da foto do avalista (Uploadcare)
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela
COMMENT ON TABLE guarantors IS 'Tabela para armazenar informações dos avalistas dos clientes';
COMMENT ON COLUMN guarantors.id IS 'Identificador único do avalista';
COMMENT ON COLUMN guarantors.client_id IS 'Referência ao cliente para o qual é avalista';
COMMENT ON COLUMN guarantors.name IS 'Nome completo do avalista';
COMMENT ON COLUMN guarantors.cpf IS 'CPF do avalista';
COMMENT ON COLUMN guarantors.rg IS 'RG do avalista';
COMMENT ON COLUMN guarantors.email IS 'Email do avalista';
COMMENT ON COLUMN guarantors.phone IS 'Telefone do avalista';
COMMENT ON COLUMN guarantors.address IS 'Endereço do avalista';
COMMENT ON COLUMN guarantors.birth_date IS 'Data de nascimento do avalista';
COMMENT ON COLUMN guarantors.relationship IS 'Relacionamento com o cliente';
COMMENT ON COLUMN guarantors.photo IS 'URL da foto do avalista (Uploadcare)';
COMMENT ON COLUMN guarantors.created_by IS 'Usuário que criou o registro do avalista';
COMMENT ON COLUMN guarantors.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN guarantors.updated_at IS 'Data da última atualização';

-- Índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_guarantors_client_id ON guarantors(client_id);
CREATE INDEX IF NOT EXISTS idx_guarantors_cpf ON guarantors(cpf);
CREATE INDEX IF NOT EXISTS idx_guarantors_created_at ON guarantors(created_at);

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_guarantors_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_guarantors_updated_at_trigger
    BEFORE UPDATE ON guarantors
    FOR EACH ROW
    EXECUTE FUNCTION update_guarantors_updated_at();

-- Política de RLS (Row Level Security) se necessário
-- ALTER TABLE guarantors ENABLE ROW LEVEL SECURITY;

-- Inserir dados de exemplo (opcional - remover em produção)
-- INSERT INTO guarantors (client_id, name, cpf, phone, relationship) VALUES
-- ('client-uuid-example', 'João Silva Santos', '123.456.789-10', '(11) 99999-8888', 'Cônjuge');