-- CORREÇÃO RÁPIDA para o problema de constraint de status
-- Execute este script no Supabase SQL Editor

-- 1. Remover constraint problemática
ALTER TABLE loans DROP CONSTRAINT IF EXISTS loans_status_check;

-- 2. Recriar constraint corretamente
ALTER TABLE loans 
ADD CONSTRAINT loans_status_check 
CHECK (status IN ('active', 'overdue', 'paid', 'partial_paid', 'cancelled'));

-- 3. Verificar se funcionou
SELECT 'Constraint criada com sucesso!' as resultado;