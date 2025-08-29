-- ==================================================
-- Fix Payment Type Check Constraint
-- ==================================================
-- This script fixes the payment_type check constraint to allow
-- all payment types supported by the application interface

-- Drop the existing constraint
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- Add the new constraint with all supported payment types
ALTER TABLE payments ADD CONSTRAINT payments_payment_type_check 
    CHECK (payment_type IN ('partial', 'full', 'interest', 'principal'));

-- Update the column comment
COMMENT ON COLUMN payments.payment_type IS 'Tipo do pagamento (parcial, total, apenas juros ou apenas principal)';

-- Verify the constraint was applied correctly
SELECT 
    conname as constraint_name,
    consrc as constraint_definition
FROM pg_constraint 
WHERE conrelid = 'payments'::regclass 
    AND conname = 'payments_payment_type_check';