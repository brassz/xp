-- =====================================================
-- REMOVER CONSTRAINT DE payment_type NA TABELA PAYMENTS
-- =====================================================
-- Este script remove a constraint que limita os valores de payment_type
-- para permitir os novos tipos: interest_renewal, capital_payment, etc.

-- Verificar a constraint atual
SELECT conname, pg_get_constraintdef(oid) 
FROM pg_constraint 
WHERE conname = 'payments_payment_type_check';

-- Remover a constraint antiga que limita os valores
ALTER TABLE payments 
DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- Verificar se a constraint foi removida
SELECT conname, pg_get_constraintdef(oid) 
FROM pg_constraint 
WHERE conrelid = 'payments'::regclass;

-- Comentário atualizado sobre o campo
COMMENT ON COLUMN payments.payment_type IS 'Tipo de operação do pagamento: interest_renewal (renovação - apenas juros), capital_payment (pagamento de capital), early_payment_partial_interest, early_payment_interest_renewal, early_payment_capital_reduction, partial_interest, ou métodos de pagamento como dinheiro, pix, cartao';

-- Verificação: Teste se agora aceita os novos valores
-- (descomente para testar após aplicar o script)
/*
-- Este é apenas um teste, não será commitado
BEGIN;
    INSERT INTO payments (loan_id, amount, payment_date, payment_type, notes, created_by)
    SELECT 
        id as loan_id, 
        100.00 as amount, 
        CURRENT_DATE as payment_date, 
        'interest_renewal' as payment_type,
        'TESTE - pode deletar' as notes,
        created_by
    FROM loans 
    LIMIT 1;
    
    -- Se chegou aqui, funcionou!
    SELECT 'Constraint removida com sucesso! Novos tipos de payment_type funcionam.' as resultado;
ROLLBACK; -- Desfazer o teste
*/
