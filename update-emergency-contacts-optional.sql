-- =====================================================
-- ATUALIZAÇÃO: TORNAR CONTATOS DE EMERGÊNCIA OPCIONAIS
-- =====================================================
-- Script para permitir campos NULL na tabela emergency_contacts

-- Remover a restrição NOT NULL dos campos name e phone
ALTER TABLE emergency_contacts 
ALTER COLUMN name DROP NOT NULL;

ALTER TABLE emergency_contacts 
ALTER COLUMN phone DROP NOT NULL;

-- Atualizar comentários da tabela para refletir que os campos são opcionais
COMMENT ON COLUMN emergency_contacts.name IS 'Nome completo do contato de emergência (opcional)';
COMMENT ON COLUMN emergency_contacts.phone IS 'Celular do contato de emergência (opcional)';

-- Adicionar uma constraint CHECK para garantir que pelo menos um campo esteja preenchido
-- Isso evita registros completamente vazios
ALTER TABLE emergency_contacts 
ADD CONSTRAINT emergency_contacts_at_least_one_field_check 
CHECK (name IS NOT NULL OR phone IS NOT NULL);

COMMENT ON CONSTRAINT emergency_contacts_at_least_one_field_check ON emergency_contacts 
IS 'Garante que pelo menos o nome ou o telefone esteja preenchido';