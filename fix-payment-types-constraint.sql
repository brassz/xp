-- Fix payment_type constraint to allow all payment types used by the application
-- This script resolves the error: "new row for relation "payments" violates check constraint "payments_payment_type_check"

-- Drop the existing constraint
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- Add the new constraint with all valid payment types
ALTER TABLE payments ADD CONSTRAINT payments_payment_type_check 
CHECK (payment_type IN (
    'partial',                          -- Pagamento parcial
    'full',                            -- Pagamento total
    'dinheiro',                        -- Método: Dinheiro
    'pix',                             -- Método: Pix
    'cartao',                          -- Método: Cartão
    'interest',                        -- Apenas Juros
    'principal',                       -- Apenas Principal
    'adjustment',                      -- Ajuste/Recálculo
    'renewal',                         -- Renovação
    'interest_renewal',                -- Renovação (Juros)
    'early_payment_interest_renewal',  -- Pagamento Antecipado - Renovação
    'early_payment_partial_interest',  -- Pagamento Antecipado Parcial de Juros
    'early_payment_capital_reduction', -- Pagamento Antecipado com Redução de Capital
    'capital_payment',                 -- Pagamento Capital
    'partial_interest',                -- Juros Parcial
    'quitacao'                         -- Quitação
));

-- Update the column comment to reflect the new valid values
COMMENT ON COLUMN payments.payment_type IS 'Tipo do pagamento: partial, full, dinheiro, pix, cartao, interest, principal, adjustment, renewal, interest_renewal, early_payment_interest_renewal, early_payment_partial_interest, early_payment_capital_reduction, capital_payment, partial_interest, quitacao';

-- Verify the constraint was applied correctly
SELECT conname, consrc 
FROM pg_constraint 
WHERE conname = 'payments_payment_type_check';