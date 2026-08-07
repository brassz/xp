-- =====================================================
-- FIX: REMOVER CONSTRAINT DE PAYMENT_TYPE
-- =====================================================
-- Este script corrige o erro ao renovar empréstimos:
-- "new row for relation "payments" violates check constraint "payments_payment_type_check"
--
-- IMPORTANTE: Execute este script em CADA BANCO DE DADOS das empresas:
-- 1. NEXUS (Empresa 1)
-- 2. LITORAL CRED (Empresa 2)
-- 3. MOGIANA CRED (Empresa 3)
-- 4. ERECHIM (Empresa 4)
-- 5. IMPERATRIZ CRED (Empresa 5)
-- =====================================================

-- Passo 1: Verificar se a constraint existe
SELECT 
    conname as constraint_name,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE conrelid = 'payments'::regclass 
  AND conname = 'payments_payment_type_check';

-- Passo 2: Remover a constraint antiga que limita os valores
ALTER TABLE payments 
DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- Passo 3: Verificar se a constraint foi removida com sucesso
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM pg_constraint 
            WHERE conrelid = 'payments'::regclass 
              AND conname = 'payments_payment_type_check'
        ) THEN '❌ ERRO: Constraint ainda existe!'
        ELSE '✅ SUCESSO: Constraint removida com sucesso!'
    END as resultado;

-- Passo 4: Atualizar comentário do campo para documentar os novos tipos aceitos
COMMENT ON COLUMN payments.payment_type IS 
'Tipo de operação do pagamento. Valores aceitos:
- interest_renewal: Renovação +30 dias (somente juros)
- capital_interest_renewal: Renovação +30 dias (capital + juros)
- capital_renewal: Renovação +30 dias (somente capital)
- capital_payment: Pagamento de capital
- loan_reactivation: Reativação de empréstimo
- early_payment_partial_interest: Pagamento antecipado (juros parcial)
- early_payment_interest_renewal: Renovação antecipada (juros)
- early_payment_capital_reduction: Pagamento antecipado (redução capital)
- partial_interest: Juros parcial
- loan_payoff: Quitação total
- renewal: Renovação (tipo legado)
- partial: Pagamento parcial (tipo legado)
- full: Pagamento total (tipo legado)
- E outros métodos de pagamento: dinheiro, pix, cartao, transferencia, etc.';

-- Passo 5: Verificar configuração final
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    col_description('payments'::regclass, ordinal_position) as description
FROM information_schema.columns
WHERE table_name = 'payments' 
  AND column_name = 'payment_type';

-- =====================================================
-- TESTE OPCIONAL (Descomente para testar)
-- =====================================================
-- Este teste insere um pagamento de renovação e depois remove
-- Descomente as linhas abaixo para executar o teste

/*
DO $$ 
DECLARE
    test_loan_id UUID;
BEGIN
    -- Buscar um empréstimo válido para teste
    SELECT id INTO test_loan_id 
    FROM loans 
    WHERE status = 'active' 
    LIMIT 1;
    
    IF test_loan_id IS NOT NULL THEN
        -- Tentar inserir um pagamento com o novo tipo
        BEGIN
            INSERT INTO payments (
                loan_id, 
                amount, 
                payment_date, 
                payment_type, 
                notes
            ) VALUES (
                test_loan_id,
                100.00,
                CURRENT_DATE,
                'interest_renewal',
                '🧪 TESTE - Este registro será removido imediatamente'
            );
            
            -- Se chegou aqui, o teste passou!
            RAISE NOTICE '✅ TESTE PASSOU: Constraint removida com sucesso! Novos tipos de payment_type funcionam.';
            
            -- Remover o registro de teste
            DELETE FROM payments 
            WHERE loan_id = test_loan_id 
              AND notes LIKE '🧪 TESTE%';
            
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE '❌ TESTE FALHOU: %', SQLERRM;
        END;
    ELSE
        RAISE NOTICE '⚠️ Nenhum empréstimo ativo encontrado para teste';
    END IF;
END $$;
*/

-- =====================================================
-- RESULTADO ESPERADO
-- =====================================================
-- Após executar este script, você deve ver:
-- ✅ Constraint removida com sucesso
-- ✅ Comentário atualizado no campo payment_type
-- ✅ Sistema pode registrar renovações sem erros
-- =====================================================
