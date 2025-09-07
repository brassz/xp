-- =====================================================
-- TABELA DE CONTATOS DE EMERGÊNCIA
-- =====================================================
-- Script para criar a tabela de contatos de emergência relacionada aos clientes

CREATE TABLE IF NOT EXISTS emergency_contacts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    relationship TEXT NOT NULL, -- Relacionamento com o cliente (ex: mãe, pai, irmão, cônjuge, amigo)
    secondary_phone TEXT, -- Telefone secundário (opcional)
    email TEXT, -- Email do contato de emergência (opcional)
    address TEXT, -- Endereço do contato (opcional)
    is_primary BOOLEAN DEFAULT false, -- Se é o contato de emergência principal
    notes TEXT, -- Observações sobre o contato
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela
COMMENT ON TABLE emergency_contacts IS 'Tabela para armazenar contatos de emergência dos clientes';
COMMENT ON COLUMN emergency_contacts.id IS 'Identificador único do contato de emergência';
COMMENT ON COLUMN emergency_contacts.client_id IS 'Referência ao cliente para o qual é contato de emergência';
COMMENT ON COLUMN emergency_contacts.name IS 'Nome completo do contato de emergência';
COMMENT ON COLUMN emergency_contacts.phone IS 'Telefone principal do contato de emergência';
COMMENT ON COLUMN emergency_contacts.relationship IS 'Relacionamento com o cliente';
COMMENT ON COLUMN emergency_contacts.secondary_phone IS 'Telefone secundário do contato (opcional)';
COMMENT ON COLUMN emergency_contacts.email IS 'Email do contato de emergência (opcional)';
COMMENT ON COLUMN emergency_contacts.address IS 'Endereço do contato de emergência (opcional)';
COMMENT ON COLUMN emergency_contacts.is_primary IS 'Se é o contato de emergência principal';
COMMENT ON COLUMN emergency_contacts.notes IS 'Observações sobre o contato';
COMMENT ON COLUMN emergency_contacts.created_by IS 'Usuário que criou o registro do contato';
COMMENT ON COLUMN emergency_contacts.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN emergency_contacts.updated_at IS 'Data da última atualização';

-- Índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_emergency_contacts_client_id ON emergency_contacts(client_id);
CREATE INDEX IF NOT EXISTS idx_emergency_contacts_phone ON emergency_contacts(phone);
CREATE INDEX IF NOT EXISTS idx_emergency_contacts_is_primary ON emergency_contacts(is_primary);
CREATE INDEX IF NOT EXISTS idx_emergency_contacts_created_at ON emergency_contacts(created_at);

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_emergency_contacts_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_emergency_contacts_updated_at_trigger
    BEFORE UPDATE ON emergency_contacts
    FOR EACH ROW
    EXECUTE FUNCTION update_emergency_contacts_updated_at();

-- Política de RLS (Row Level Security)
ALTER TABLE emergency_contacts ENABLE ROW LEVEL SECURITY;

-- Política para visualizar contatos de emergência
CREATE POLICY "Users can view all emergency contacts" ON emergency_contacts
    FOR SELECT USING (auth.role() = 'authenticated');

-- Política para inserir contatos de emergência
CREATE POLICY "Users can insert emergency contacts" ON emergency_contacts
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Política para atualizar contatos de emergência
CREATE POLICY "Users can update emergency contacts they created or admins can update all" ON emergency_contacts
    FOR UPDATE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- Política para deletar contatos de emergência
CREATE POLICY "Users can delete emergency contacts they created or admins can delete all" ON emergency_contacts
    FOR DELETE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- View para contatos de emergência com informações do cliente
CREATE OR REPLACE VIEW emergency_contacts_with_client AS
SELECT 
    ec.*,
    c.name as client_name,
    c.cpf as client_cpf,
    c.email as client_email,
    c.phone as client_phone,
    u.full_name as created_by_name
FROM emergency_contacts ec
JOIN clients c ON ec.client_id = c.id
LEFT JOIN users u ON ec.created_by = u.id;

-- Inserir dados de exemplo (opcional - remover em produção)
-- INSERT INTO emergency_contacts (client_id, name, phone, relationship, is_primary) VALUES
-- ('client-uuid-example', 'Maria Silva Santos', '(11) 99999-7777', 'Mãe', true);