-- =====================================================
-- FIX: Remove Duplicates and Add Unique Constraints
-- =====================================================
-- Este script remove duplicatas das tabelas de status de empréstimos
-- e depois adiciona as constraints únicas necessárias para corrigir
-- o erro "there is no unique or exclusion constraint matching the ON CONFLICT specification"

-- =====================================================
-- PASSO 1: IDENTIFICAR E REMOVER DUPLICATAS
-- =====================================================

-- Verificar duplicatas em cada tabela
DO $$
DECLARE
    duplicate_count INTEGER;
BEGIN
    -- Verificar duplicatas em paid_loans
    SELECT COUNT(*) INTO duplicate_count
    FROM (
        SELECT loan_id, COUNT(*) as cnt
        FROM paid_loans
        GROUP BY loan_id
        HAVING COUNT(*) > 1
    ) duplicates;
    
    IF duplicate_count > 0 THEN
        RAISE NOTICE 'Encontradas % duplicatas em paid_loans', duplicate_count;
        
        -- Manter apenas o registro mais recente para cada loan_id
        DELETE FROM paid_loans 
        WHERE id NOT IN (
            SELECT DISTINCT ON (loan_id) id
            FROM paid_loans
            ORDER BY loan_id, created_at DESC
        );
        
        RAISE NOTICE 'Duplicatas removidas de paid_loans';
    ELSE
        RAISE NOTICE 'Nenhuma duplicata encontrada em paid_loans';
    END IF;

    -- Verificar duplicatas em overdue_loans
    SELECT COUNT(*) INTO duplicate_count
    FROM (
        SELECT loan_id, COUNT(*) as cnt
        FROM overdue_loans
        GROUP BY loan_id
        HAVING COUNT(*) > 1
    ) duplicates;
    
    IF duplicate_count > 0 THEN
        RAISE NOTICE 'Encontradas % duplicatas em overdue_loans', duplicate_count;
        
        -- Manter apenas o registro mais recente para cada loan_id
        DELETE FROM overdue_loans 
        WHERE id NOT IN (
            SELECT DISTINCT ON (loan_id) id
            FROM overdue_loans
            ORDER BY loan_id, updated_at DESC, created_at DESC
        );
        
        RAISE NOTICE 'Duplicatas removidas de overdue_loans';
    ELSE
        RAISE NOTICE 'Nenhuma duplicata encontrada em overdue_loans';
    END IF;

    -- Verificar duplicatas em partial_paid_loans
    SELECT COUNT(*) INTO duplicate_count
    FROM (
        SELECT loan_id, COUNT(*) as cnt
        FROM partial_paid_loans
        GROUP BY loan_id
        HAVING COUNT(*) > 1
    ) duplicates;
    
    IF duplicate_count > 0 THEN
        RAISE NOTICE 'Encontradas % duplicatas em partial_paid_loans', duplicate_count;
        
        -- Manter apenas o registro mais recente para cada loan_id
        DELETE FROM partial_paid_loans 
        WHERE id NOT IN (
            SELECT DISTINCT ON (loan_id) id
            FROM partial_paid_loans
            ORDER BY loan_id, updated_at DESC, created_at DESC
        );
        
        RAISE NOTICE 'Duplicatas removidas de partial_paid_loans';
    ELSE
        RAISE NOTICE 'Nenhuma duplicata encontrada em partial_paid_loans';
    END IF;

    -- Verificar duplicatas em cancelled_loans
    SELECT COUNT(*) INTO duplicate_count
    FROM (
        SELECT loan_id, COUNT(*) as cnt
        FROM cancelled_loans
        GROUP BY loan_id
        HAVING COUNT(*) > 1
    ) duplicates;
    
    IF duplicate_count > 0 THEN
        RAISE NOTICE 'Encontradas % duplicatas em cancelled_loans', duplicate_count;
        
        -- Manter apenas o registro mais recente para cada loan_id
        DELETE FROM cancelled_loans 
        WHERE id NOT IN (
            SELECT DISTINCT ON (loan_id) id
            FROM cancelled_loans
            ORDER BY loan_id, cancelled_at DESC, created_at DESC
        );
        
        RAISE NOTICE 'Duplicatas removidas de cancelled_loans';
    ELSE
        RAISE NOTICE 'Nenhuma duplicata encontrada em cancelled_loans';
    END IF;

END
$$;

-- =====================================================
-- PASSO 2: ADICIONAR CONSTRAINTS ÚNICAS
-- =====================================================

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
-- PASSO 3: VERIFICAÇÃO FINAL
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

-- Verificar se ainda existem duplicatas
SELECT 
    'paid_loans' as table_name,
    COUNT(*) as total_duplicates
FROM (
    SELECT loan_id, COUNT(*) as cnt
    FROM paid_loans
    GROUP BY loan_id
    HAVING COUNT(*) > 1
) duplicates

UNION ALL

SELECT 
    'overdue_loans' as table_name,
    COUNT(*) as total_duplicates
FROM (
    SELECT loan_id, COUNT(*) as cnt
    FROM overdue_loans
    GROUP BY loan_id
    HAVING COUNT(*) > 1
) duplicates

UNION ALL

SELECT 
    'partial_paid_loans' as table_name,
    COUNT(*) as total_duplicates
FROM (
    SELECT loan_id, COUNT(*) as cnt
    FROM partial_paid_loans
    GROUP BY loan_id
    HAVING COUNT(*) > 1
) duplicates

UNION ALL

SELECT 
    'cancelled_loans' as table_name,
    COUNT(*) as total_duplicates
FROM (
    SELECT loan_id, COUNT(*) as cnt
    FROM cancelled_loans
    GROUP BY loan_id
    HAVING COUNT(*) > 1
) duplicates;