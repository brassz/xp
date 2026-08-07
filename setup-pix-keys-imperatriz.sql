-- =====================================================
-- CONFIGURAÇÃO DA TABELA PIX_KEYS - IMPERATRIZ CRED
-- =====================================================
-- Execute este script no SQL Editor do Supabase da Imperatriz Cred
-- URL: https://eppzphzwwpvpoocospxy.supabase.co
-- =====================================================

-- Verificar se a tabela já existe
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'pix_keys') THEN
        RAISE NOTICE 'Tabela pix_keys não existe. Criando...';
    ELSE
        RAISE NOTICE 'Tabela pix_keys já existe. Pulando criação.';
    END IF;
END $$;

-- Criar tabela de chaves PIX
CREATE TABLE IF NOT EXISTS public.pix_keys (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    bank_name VARCHAR(100) NOT NULL,
    pix_key VARCHAR(255) NOT NULL,
    pix_key_type VARCHAR(20) NOT NULL CHECK (pix_key_type IN ('cpf', 'cnpj', 'email', 'phone', 'random')),
    account_holder VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Comentários para documentação
COMMENT ON TABLE public.pix_keys IS 'Tabela para armazenar as chaves PIX disponíveis para cobrança';
COMMENT ON COLUMN public.pix_keys.bank_name IS 'Nome do banco da chave PIX';
COMMENT ON COLUMN public.pix_keys.pix_key IS 'A chave PIX (CPF, CNPJ, email, telefone ou chave aleatória)';
COMMENT ON COLUMN public.pix_keys.pix_key_type IS 'Tipo da chave PIX';
COMMENT ON COLUMN public.pix_keys.account_holder IS 'Nome do titular da conta';
COMMENT ON COLUMN public.pix_keys.is_active IS 'Se a chave PIX está ativa para uso';

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_pix_keys_active ON public.pix_keys(is_active);
CREATE INDEX IF NOT EXISTS idx_pix_keys_bank ON public.pix_keys(bank_name);
CREATE INDEX IF NOT EXISTS idx_pix_keys_type ON public.pix_keys(pix_key_type);

-- Habilitar RLS (Row Level Security)
ALTER TABLE public.pix_keys ENABLE ROW LEVEL SECURITY;

-- Remover políticas existentes se houver
DROP POLICY IF EXISTS "Allow authenticated users to view pix keys" ON public.pix_keys;
DROP POLICY IF EXISTS "Allow authenticated users to insert pix keys" ON public.pix_keys;
DROP POLICY IF EXISTS "Allow authenticated users to update pix keys" ON public.pix_keys;
DROP POLICY IF EXISTS "Allow authenticated users to delete pix keys" ON public.pix_keys;

-- Criar políticas de acesso
CREATE POLICY "Allow authenticated users to view pix keys" ON public.pix_keys
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to insert pix keys" ON public.pix_keys
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to update pix keys" ON public.pix_keys
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to delete pix keys" ON public.pix_keys
    FOR DELETE USING (auth.role() = 'authenticated');

-- Inserir chave PIX de exemplo (opcional - remova se não quiser dados de exemplo)
INSERT INTO public.pix_keys (bank_name, pix_key, pix_key_type, account_holder, is_active) VALUES
('Banco do Brasil', '12345678901234', 'cpf', 'IMPERATRIZ CRED', true)
ON CONFLICT DO NOTHING;

-- Criar trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_pix_keys_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_pix_keys_updated_at ON public.pix_keys;

CREATE TRIGGER trigger_update_pix_keys_updated_at
    BEFORE UPDATE ON public.pix_keys
    FOR EACH ROW
    EXECUTE FUNCTION update_pix_keys_updated_at();

-- Verificação final
SELECT 
    'Tabela pix_keys criada com sucesso!' as status,
    COUNT(*) as total_chaves
FROM public.pix_keys;

-- Mostrar estrutura da tabela
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'pix_keys'
ORDER BY ordinal_position;

-- Mostrar políticas RLS
SELECT 
    policyname,
    cmd,
    permissive
FROM pg_policies
WHERE schemaname = 'public' 
AND tablename = 'pix_keys';

-- =====================================================
-- FIM DA CONFIGURAÇÃO
-- =====================================================
