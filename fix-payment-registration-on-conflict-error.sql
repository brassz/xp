-- =====================================================
-- FIX: Payment Registration ON CONFLICT Error
-- =====================================================
-- Este script corrige o erro "there is no unique or exclusion constraint matching the ON CONFLICT specification"
-- que ocorre quando as funções de trigger tentam usar ON CONFLICT (loan_id) mas as constraints únicas não existem.

-- Verificar se as constraints já existem antes de tentar criá-las
DO $$
BEGIN
    -- Adicionar constraint única para paid_loans se não existir
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_paid_loan_id' 
        AND table_name = 'paid_loans'
    ) THEN
        ALTER TABLE paid_loans ADD CONSTRAINT unique_paid_loan_id UNIQUE (loan_id);
        RAISE NOTICE 'Constraint unique_paid_loan_id adicionada à tabela paid_loans';
    ELSE
        RAISE NOTICE 'Constraint unique_paid_loan_id já existe na tabela paid_loans';
    END IF;

    -- Adicionar constraint única para overdue_loans se não existir
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_overdue_loan_id' 
        AND table_name = 'overdue_loans'
    ) THEN
        ALTER TABLE overdue_loans ADD CONSTRAINT unique_overdue_loan_id UNIQUE (loan_id);
        RAISE NOTICE 'Constraint unique_overdue_loan_id adicionada à tabela overdue_loans';
    ELSE
        RAISE NOTICE 'Constraint unique_overdue_loan_id já existe na tabela overdue_loans';
    END IF;

    -- Adicionar constraint única para partial_paid_loans se não existir
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_partial_paid_loan_id' 
        AND table_name = 'partial_paid_loans'
    ) THEN
        ALTER TABLE partial_paid_loans ADD CONSTRAINT unique_partial_paid_loan_id UNIQUE (loan_id);
        RAISE NOTICE 'Constraint unique_partial_paid_loan_id adicionada à tabela partial_paid_loans';
    ELSE
        RAISE NOTICE 'Constraint unique_partial_paid_loan_id já existe na tabela partial_paid_loans';
    END IF;

    -- Adicionar constraint única para cancelled_loans se não existir
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_cancelled_loan_id' 
        AND table_name = 'cancelled_loans'
    ) THEN
        ALTER TABLE cancelled_loans ADD CONSTRAINT unique_cancelled_loan_id UNIQUE (loan_id);
        RAISE NOTICE 'Constraint unique_cancelled_loan_id adicionada à tabela cancelled_loans';
    ELSE
        RAISE NOTICE 'Constraint unique_cancelled_loan_id já existe na tabela cancelled_loans';
    END IF;

    RAISE NOTICE 'Correção do erro ON CONFLICT concluída com sucesso!';
END
$$;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================
-- Verificar se todas as constraints foram criadas corretamente
SELECT 
    table_name,
    constraint_name,
    constraint_type
FROM information_schema.table_constraints 
WHERE table_name IN ('paid_loans', 'overdue_loans', 'partial_paid_loans', 'cancelled_loans')
    AND constraint_name LIKE 'unique_%_loan_id'
ORDER BY table_name, constraint_name;