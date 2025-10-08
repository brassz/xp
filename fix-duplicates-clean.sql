-- =====================================================
-- FIX: Clean Duplicates and Add Unique Constraints
-- =====================================================
-- Script limpo para remover duplicatas e adicionar constraints únicas

-- =====================================================
-- PASSO 1: REMOVER DUPLICATAS DA TABELA cancelled_loans
-- =====================================================

-- Verificar duplicatas existentes
SELECT 
    'Duplicatas em cancelled_loans antes da limpeza' as status,
    loan_id,
    COUNT(*) as count
FROM cancelled_loans
GROUP BY loan_id
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- Remover duplicatas mantendo o registro mais recente
WITH duplicates_to_remove AS (
    SELECT id
    FROM (
        SELECT 
            id,
            ROW_NUMBER() OVER (
                PARTITION BY loan_id 
                ORDER BY cancellation_date DESC, created_at DESC
            ) as rn
        FROM cancelled_loans
    ) ranked
    WHERE rn > 1
)
DELETE FROM cancelled_loans 
WHERE id IN (SELECT id FROM duplicates_to_remove);

-- Verificar se duplicatas foram removidas
SELECT 
    'Duplicatas restantes em cancelled_loans' as status,
    COUNT(*) as count
FROM (
    SELECT loan_id, COUNT(*) as cnt
    FROM cancelled_loans
    GROUP BY loan_id
    HAVING COUNT(*) > 1
) remaining_duplicates;

-- =====================================================
-- PASSO 2: REMOVER DUPLICATAS DAS OUTRAS TABELAS
-- =====================================================

-- Limpar paid_loans
WITH duplicates_to_remove AS (
    SELECT id
    FROM (
        SELECT 
            id,
            ROW_NUMBER() OVER (
                PARTITION BY loan_id 
                ORDER BY created_at DESC
            ) as rn
        FROM paid_loans
    ) ranked
    WHERE rn > 1
)
DELETE FROM paid_loans 
WHERE id IN (SELECT id FROM duplicates_to_remove);

-- Limpar overdue_loans
WITH duplicates_to_remove AS (
    SELECT id
    FROM (
        SELECT 
            id,
            ROW_NUMBER() OVER (
                PARTITION BY loan_id 
                ORDER BY updated_at DESC, created_at DESC
            ) as rn
        FROM overdue_loans
    ) ranked
    WHERE rn > 1
)
DELETE FROM overdue_loans 
WHERE id IN (SELECT id FROM duplicates_to_remove);

-- Limpar partial_paid_loans
WITH duplicates_to_remove AS (
    SELECT id
    FROM (
        SELECT 
            id,
            ROW_NUMBER() OVER (
                PARTITION BY loan_id 
                ORDER BY updated_at DESC, created_at DESC
            ) as rn
        FROM partial_paid_loans
    ) ranked
    WHERE rn > 1
)
DELETE FROM partial_paid_loans 
WHERE id IN (SELECT id FROM duplicates_to_remove);

-- =====================================================
-- PASSO 3: ADICIONAR CONSTRAINTS ÚNICAS
-- =====================================================

-- Adicionar constraint para paid_loans
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_paid_loan_id' 
        AND table_name = 'paid_loans'
    ) THEN
        ALTER TABLE paid_loans ADD CONSTRAINT unique_paid_loan_id UNIQUE (loan_id);
        RAISE NOTICE 'Constraint unique_paid_loan_id adicionada';
    ELSE
        RAISE NOTICE 'Constraint unique_paid_loan_id já existe';
    END IF;
END $$;

-- Adicionar constraint para overdue_loans
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_overdue_loan_id' 
        AND table_name = 'overdue_loans'
    ) THEN
        ALTER TABLE overdue_loans ADD CONSTRAINT unique_overdue_loan_id UNIQUE (loan_id);
        RAISE NOTICE 'Constraint unique_overdue_loan_id adicionada';
    ELSE
        RAISE NOTICE 'Constraint unique_overdue_loan_id já existe';
    END IF;
END $$;

-- Adicionar constraint para partial_paid_loans
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_partial_paid_loan_id' 
        AND table_name = 'partial_paid_loans'
    ) THEN
        ALTER TABLE partial_paid_loans ADD CONSTRAINT unique_partial_paid_loan_id UNIQUE (loan_id);
        RAISE NOTICE 'Constraint unique_partial_paid_loan_id adicionada';
    ELSE
        RAISE NOTICE 'Constraint unique_partial_paid_loan_id já existe';
    END IF;
END $$;

-- Adicionar constraint para cancelled_loans
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'unique_cancelled_loan_id' 
        AND table_name = 'cancelled_loans'
    ) THEN
        ALTER TABLE cancelled_loans ADD CONSTRAINT unique_cancelled_loan_id UNIQUE (loan_id);
        RAISE NOTICE 'Constraint unique_cancelled_loan_id adicionada';
    ELSE
        RAISE NOTICE 'Constraint unique_cancelled_loan_id já existe';
    END IF;
END $$;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar constraints criadas
SELECT 
    table_name,
    constraint_name,
    constraint_type
FROM information_schema.table_constraints 
WHERE table_name IN ('paid_loans', 'overdue_loans', 'partial_paid_loans', 'cancelled_loans')
    AND constraint_name LIKE 'unique_%_loan_id'
ORDER BY table_name;

-- Verificar se ainda existem duplicatas
SELECT 
    'paid_loans' as table_name,
    COUNT(*) as duplicates
FROM (
    SELECT loan_id FROM paid_loans GROUP BY loan_id HAVING COUNT(*) > 1
) d1

UNION ALL

SELECT 
    'overdue_loans' as table_name,
    COUNT(*) as duplicates
FROM (
    SELECT loan_id FROM overdue_loans GROUP BY loan_id HAVING COUNT(*) > 1
) d2

UNION ALL

SELECT 
    'partial_paid_loans' as table_name,
    COUNT(*) as duplicates
FROM (
    SELECT loan_id FROM partial_paid_loans GROUP BY loan_id HAVING COUNT(*) > 1
) d3

UNION ALL

SELECT 
    'cancelled_loans' as table_name,
    COUNT(*) as duplicates
FROM (
    SELECT loan_id FROM cancelled_loans GROUP BY loan_id HAVING COUNT(*) > 1
) d4;