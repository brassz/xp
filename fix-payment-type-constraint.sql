-- Fix payment_type constraint to include all payment types used in the application
-- This addresses the error: "new row for relation "payments" violates check constraint "payments_payment_type_check""

-- Drop the existing constraint
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- Add the new constraint with all payment types used in the application
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

-- Update the column comment to reflect the new allowed values
COMMENT ON COLUMN payments.payment_type IS 'Tipo do pagamento: partial (parcial), full (total), interest_renewal (renovação de juros), early_payment_partial_interest (pagamento antecipado parcial de juros), early_payment_interest_renewal (pagamento antecipado com renovação), early_payment_capital_reduction (pagamento antecipado com redução de capital), capital_payment (pagamento de capital), partial_interest (juros parcial), adjustment (ajuste), renewal (renovação)';