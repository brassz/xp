-- Script para adicionar campos birth_date e rg à tabela clients
-- Este script corrige o problema da data de nascimento não estar sendo salva

-- Adicionar campo birth_date (data de nascimento)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'clients' AND column_name = 'birth_date'
    ) THEN
        ALTER TABLE clients ADD COLUMN birth_date DATE;
        COMMENT ON COLUMN clients.birth_date IS 'Data de nascimento do cliente';
    END IF;
END $$;

-- Adicionar campo rg (registro geral)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'clients' AND column_name = 'rg'
    ) THEN
        ALTER TABLE clients ADD COLUMN rg TEXT;
        COMMENT ON COLUMN clients.rg IS 'RG (Registro Geral) do cliente';
    END IF;
END $$;

-- Verificar se os campos foram adicionados corretamente
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'clients' 
    AND column_name IN ('birth_date', 'rg')
ORDER BY column_name;