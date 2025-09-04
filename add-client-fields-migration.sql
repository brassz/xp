-- =====================================================
-- MIGRAÇÃO: Adicionar campos RG e Data de Nascimento à tabela clients
-- =====================================================

-- Adicionar coluna RG se não existir
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'clients' AND column_name = 'rg') THEN
        ALTER TABLE clients ADD COLUMN rg TEXT;
        COMMENT ON COLUMN clients.rg IS 'RG do cliente';
    END IF;
END $$;

-- Adicionar coluna birth_date se não existir
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'clients' AND column_name = 'birth_date') THEN
        ALTER TABLE clients ADD COLUMN birth_date DATE;
        COMMENT ON COLUMN clients.birth_date IS 'Data de nascimento do cliente';
    END IF;
END $$;

-- Verificar se as colunas foram adicionadas com sucesso
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'clients' 
AND column_name IN ('rg', 'birth_date')
ORDER BY column_name;