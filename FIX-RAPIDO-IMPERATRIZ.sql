-- =====================================================
-- ⚡ FIX RÁPIDO - IMPERATRIZ CRED (2 minutos)
-- =====================================================
-- Execute este script no banco da IMPERATRIZ:
-- https://eppzphzwwpvpoocospxy.supabase.co
-- =====================================================

-- Adicionar coluna original_amount
ALTER TABLE loans ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);

-- Preencher valores existentes
UPDATE loans SET original_amount = amount WHERE original_amount IS NULL;

-- Tornar obrigatório
ALTER TABLE loans ALTER COLUMN original_amount SET NOT NULL;

-- Criar índice
CREATE INDEX IF NOT EXISTS idx_loans_original_amount ON loans(original_amount);

-- Adicionar comentários
COMMENT ON COLUMN loans.original_amount IS 'Valor original do empréstimo (NUNCA alterado - base para cálculos)';

-- =====================================================
-- ✅ CONCLUÍDO!
-- =====================================================
-- 
-- PRÓXIMO PASSO OBRIGATÓRIO:
-- 
-- Recarregar Schema Cache:
-- Settings → API → Schema Cache → "Reload schema"
-- 
-- OU execute:
-- NOTIFY pgrst, 'reload schema';
-- 
-- Aguarde 30 segundos e teste criar um empréstimo!
-- =====================================================
