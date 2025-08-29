-- Script para criar tabela de documentos dos clientes
-- Execute este script no seu banco de dados Supabase

-- Criar tabela de documentos dos clientes
CREATE TABLE IF NOT EXISTS client_documents (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL CHECK (category IN ('identificacao', 'comprovante_renda', 'comprovante_residencia', 'referencias', 'outros')),
    file_path TEXT NOT NULL,
    file_type VARCHAR(100),
    file_size INTEGER,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_client_documents_client_id ON client_documents(client_id);
CREATE INDEX IF NOT EXISTS idx_client_documents_category ON client_documents(category);
CREATE INDEX IF NOT EXISTS idx_client_documents_created_at ON client_documents(created_at);

-- Criar trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE OR REPLACE TRIGGER update_client_documents_updated_at
    BEFORE UPDATE ON client_documents
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Configurar RLS (Row Level Security) se necessário
ALTER TABLE client_documents ENABLE ROW LEVEL SECURITY;

-- Política para permitir todas as operações (ajuste conforme sua necessidade de segurança)
CREATE POLICY "Enable all operations for client_documents" ON client_documents
    FOR ALL USING (true);

-- Criar bucket no Supabase Storage para documentos (execute no painel do Supabase)
-- INSERT INTO storage.buckets (id, name, public) VALUES ('client-documents', 'client-documents', false);

-- Política de storage para permitir upload e download de documentos
-- CREATE POLICY "Enable upload for client documents" ON storage.objects
--     FOR INSERT WITH CHECK (bucket_id = 'client-documents');

-- CREATE POLICY "Enable download for client documents" ON storage.objects
--     FOR SELECT USING (bucket_id = 'client-documents');

-- CREATE POLICY "Enable delete for client documents" ON storage.objects
--     FOR DELETE USING (bucket_id = 'client-documents');

COMMENT ON TABLE client_documents IS 'Tabela para armazenar documentos dos clientes';
COMMENT ON COLUMN client_documents.client_id IS 'ID do cliente proprietário do documento';
COMMENT ON COLUMN client_documents.name IS 'Nome/descrição do documento';
COMMENT ON COLUMN client_documents.category IS 'Categoria do documento (identificacao, comprovante_renda, etc.)';
COMMENT ON COLUMN client_documents.file_path IS 'Caminho do arquivo no storage';
COMMENT ON COLUMN client_documents.file_type IS 'Tipo MIME do arquivo';
COMMENT ON COLUMN client_documents.file_size IS 'Tamanho do arquivo em bytes';
COMMENT ON COLUMN client_documents.notes IS 'Observações sobre o documento';