-- Script para adicionar campos RG e data de nascimento na tabela clients
-- Execute este script no seu banco de dados Supabase

-- Adicionar campo RG
ALTER TABLE clients 
ADD COLUMN IF NOT EXISTS rg TEXT;

-- Adicionar campo data de nascimento
ALTER TABLE clients 
ADD COLUMN IF NOT EXISTS birth_date DATE;

-- Adicionar comentários para os novos campos
COMMENT ON COLUMN clients.rg IS 'RG (Registro Geral) do cliente';
COMMENT ON COLUMN clients.birth_date IS 'Data de nascimento do cliente';

-- Verificar se os campos foram adicionados corretamente
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'clients'
ORDER BY ordinal_position;