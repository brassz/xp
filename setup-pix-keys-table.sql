-- =====================================================
-- CONFIGURAÇÃO DA TABELA DE CHAVES PIX
-- =====================================================
-- Script para criar a tabela de chaves PIX para cobrança
-- Execute este arquivo no SQL Editor do Supabase
-- =====================================================

-- Criar tabela de chaves PIX
CREATE TABLE IF NOT EXISTS pix_keys (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    bank_name VARCHAR(100) NOT NULL,
    pix_key VARCHAR(255) NOT NULL,
    pix_key_type VARCHAR(20) NOT NULL CHECK (pix_key_type IN ('cpf', 'cnpj', 'email', 'phone', 'random')),
    account_holder VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_pix_keys_active ON pix_keys(is_active);
CREATE INDEX IF NOT EXISTS idx_pix_keys_bank ON pix_keys(bank_name);

-- Inserir algumas chaves PIX de exemplo
INSERT INTO pix_keys (bank_name, pix_key, pix_key_type, account_holder) VALUES
('Banco do Brasil', '12345678901', 'cpf', 'João Silva'),
('Itaú', 'joao@email.com', 'email', 'João Silva'),
('Nubank', '11987654321', 'phone', 'João Silva'),
('Caixa Econômica', '12.345.678/0001-90', 'cnpj', 'Empresa LTDA'),
('Santander', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'random', 'Maria Santos')
ON CONFLICT DO NOTHING;

-- Habilitar RLS (Row Level Security)
ALTER TABLE pix_keys ENABLE ROW LEVEL SECURITY;

-- Criar política para permitir acesso aos usuários autenticados
CREATE POLICY "Allow authenticated users to view pix keys" ON pix_keys
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to insert pix keys" ON pix_keys
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to update pix keys" ON pix_keys
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to delete pix keys" ON pix_keys
    FOR DELETE USING (auth.role() = 'authenticated');

-- Comentários para documentação
COMMENT ON TABLE pix_keys IS 'Tabela para armazenar as chaves PIX disponíveis para cobrança';
COMMENT ON COLUMN pix_keys.bank_name IS 'Nome do banco da chave PIX';
COMMENT ON COLUMN pix_keys.pix_key IS 'A chave PIX (CPF, CNPJ, email, telefone ou chave aleatória)';
COMMENT ON COLUMN pix_keys.pix_key_type IS 'Tipo da chave PIX';
COMMENT ON COLUMN pix_keys.account_holder IS 'Nome do titular da conta';
COMMENT ON COLUMN pix_keys.is_active IS 'Se a chave PIX está ativa para uso';