-- =====================================================
-- CORREÇÃO URGENTE PARA MOGIANA CRED
-- =====================================================
-- Erro: "new row for relation "payments" violates check constraint "payments_payment_type_check""
-- URL Supabase: https://eemfnpefgojllvzzaimu.supabase.co

-- PASSO 1: Remover constraint antiga
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- PASSO 2: Adicionar nova constraint com todos os tipos utilizados
ALTER TABLE payments ADD CONSTRAINT payments_payment_type_check 
CHECK (payment_type IN (
    'partial', 
    'full', 
    'interest_renewal', 
    'early_payment_partial_interest', 
    'early_payment_interest_renewal', 
    'early_payment_capital_reduction', 
    'capital_payment', 
    'partial_interest', 
    'adjustment',
    'renewal'
));

-- PASSO 3: Atualizar comentário da coluna
COMMENT ON COLUMN payments.payment_type IS 'Tipo do pagamento: partial (parcial), full (total), interest_renewal (renovação de juros), early_payment_partial_interest (pagamento antecipado parcial de juros), early_payment_interest_renewal (pagamento antecipado com renovação), early_payment_capital_reduction (pagamento antecipado com redução de capital), capital_payment (pagamento de capital), partial_interest (juros parcial), adjustment (ajuste), renewal (renovação)';

-- VERIFICAÇÃO: Consultar constraint atual
SELECT 
    conname as constraint_name,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE conrelid = 'payments'::regclass 
AND conname = 'payments_payment_type_check';