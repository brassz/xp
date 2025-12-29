-- ================================================
-- TABELA DE MULTAS DE CLIENTES
-- ================================================
-- Esta tabela armazena multas aplicadas diretamente aos clientes
-- (não relacionadas a pagamentos específicos de empréstimos)
-- ================================================

-- Criar tabela de multas de clientes
CREATE TABLE IF NOT EXISTS client_fines (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    reason TEXT,
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_client_fines_client_id ON client_fines(client_id);
CREATE INDEX IF NOT EXISTS idx_client_fines_created_at ON client_fines(created_at);
CREATE INDEX IF NOT EXISTS idx_client_fines_created_by ON client_fines(created_by);

-- Adicionar comentários
COMMENT ON TABLE client_fines IS 'Armazena multas aplicadas diretamente aos clientes';
COMMENT ON COLUMN client_fines.id IS 'Identificador único da multa';
COMMENT ON COLUMN client_fines.client_id IS 'Referência ao cliente que recebeu a multa';
COMMENT ON COLUMN client_fines.amount IS 'Valor da multa em reais';
COMMENT ON COLUMN client_fines.reason IS 'Motivo da multa';
COMMENT ON COLUMN client_fines.notes IS 'Observações adicionais sobre a multa';
COMMENT ON COLUMN client_fines.created_by IS 'Usuário que criou o registro da multa';
COMMENT ON COLUMN client_fines.created_at IS 'Data e hora de criação do registro';
COMMENT ON COLUMN client_fines.updated_at IS 'Data e hora da última atualização';

-- Habilitar RLS (Row Level Security)
ALTER TABLE client_fines ENABLE ROW LEVEL SECURITY;

-- Política de visualização (todos os usuários autenticados podem ver)
CREATE POLICY "Permitir leitura de multas para usuários autenticados"
    ON client_fines FOR SELECT
    USING (auth.role() = 'authenticated');

-- Política de inserção (todos os usuários autenticados podem inserir)
CREATE POLICY "Permitir inserção de multas para usuários autenticados"
    ON client_fines FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

-- Política de atualização (todos os usuários autenticados podem atualizar)
CREATE POLICY "Permitir atualização de multas para usuários autenticados"
    ON client_fines FOR UPDATE
    USING (auth.role() = 'authenticated');

-- Política de exclusão (todos os usuários autenticados podem deletar)
CREATE POLICY "Permitir exclusão de multas para usuários autenticados"
    ON client_fines FOR DELETE
    USING (auth.role() = 'authenticated');

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_client_fines_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_client_fines_timestamp
    BEFORE UPDATE ON client_fines
    FOR EACH ROW
    EXECUTE FUNCTION update_client_fines_updated_at();

-- Verificação final
SELECT 'Tabela client_fines criada com sucesso!' AS status;
