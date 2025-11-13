-- =====================================================
-- 🚀 COPIE E COLE ESTE CÓDIGO NO SUPABASE DA IMPERATRIZ
-- =====================================================
-- URL: https://eppzphzwwpvpoocospxy.supabase.co
-- Vá em: SQL Editor → Cole este código → Clique Run
-- =====================================================

-- Corrigir tabela LOANS (original_amount)
ALTER TABLE loans ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);
UPDATE loans SET original_amount = amount WHERE original_amount IS NULL;
ALTER TABLE loans ALTER COLUMN original_amount SET NOT NULL;
CREATE INDEX IF NOT EXISTS idx_loans_original_amount ON loans(original_amount);

-- Corrigir tabela PAYMENTS (fine_amount)
ALTER TABLE payments ADD COLUMN IF NOT EXISTS fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);
CREATE INDEX IF NOT EXISTS idx_payments_fine_amount ON payments(fine_amount) WHERE fine_amount > 0;

-- Adicionar comentários
COMMENT ON COLUMN loans.original_amount IS 'Valor original do empréstimo (NUNCA alterado)';
COMMENT ON COLUMN payments.fine_amount IS 'Valor da multa (opcional)';

-- =====================================================
-- ✅ CONCLUÍDO!
-- =====================================================
-- 
-- PRÓXIMO PASSO OBRIGATÓRIO:
-- 
-- 1. Settings → API → Schema Cache
-- 2. Clique "Reload schema"  
-- 3. Aguarde 30 segundos
-- 4. Teste na aplicação!
--
-- OU execute:
-- NOTIFY pgrst, 'reload schema';
--
-- =====================================================
