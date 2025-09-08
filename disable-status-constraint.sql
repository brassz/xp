-- Script para temporariamente desabilitar a constraint de status
-- Execute este script no Supabase SQL Editor se o problema persistir

-- OPÇÃO 1: Remover completamente a constraint (mais simples)
ALTER TABLE loans DROP CONSTRAINT IF EXISTS loans_status_check;

-- Verificar se foi removida
SELECT 'Constraint removida com sucesso!' as resultado;

-- OPÇÃO 2: Se quiser recriar depois (opcional)
-- ALTER TABLE loans ADD CONSTRAINT loans_status_check 
-- CHECK (status IN ('active', 'overdue', 'paid', 'partial_paid', 'cancelled'));

-- OPÇÃO 3: Verificar se existem outras constraints problemáticas
SELECT 
    conname AS constraint_name,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint 
WHERE conrelid = 'loans'::regclass 
AND contype = 'c';