-- COPIE E COLE ESTE CÓDIGO NO SUPABASE SQL EDITOR DA MOGIANA CRED:

ALTER TABLE payments DROP CONSTRAINT payments_payment_type_check;
ALTER TABLE payments ADD CONSTRAINT payments_payment_type_check CHECK (payment_type IN ('partial', 'full', 'interest_renewal', 'early_payment_partial_interest', 'early_payment_interest_renewal', 'early_payment_capital_reduction', 'capital_payment', 'partial_interest', 'adjustment', 'renewal'));