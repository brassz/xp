-- =====================================================
-- FIX: Remove Duplicates from cancelled_loans Table
-- =====================================================
-- Este script corrige especificamente o erro na tabela cancelled_loans
-- removendo duplicatas antes de adicionar a constraint única

-- Primeiro, vamos ver quantas duplicatas existem
SELECT 
    loan_id,
    COUNT(*) as duplicate_count,
    STRING_AGG(id::text, ', ') as duplicate_ids
FROM cancelled_loans
GROUP BY loan_id
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- Remover duplicatas mantendo apenas o registro mais recente para cada loan_id
DELETE FROM cancelled_loans 
WHERE id NOT IN (
    SELECT DISTINCT ON (loan_id) id
    FROM cancelled_loans
    ORDER BY loan_id, 
             cancelled_at DESC NULLS LAST, 
             created_at DESC
);

-- Verificar se as duplicatas foram removidas
SELECT 
    'Duplicatas restantes' as status,
    COUNT(*) as count
FROM (
    SELECT loan_id, COUNT(*) as cnt
    FROM cancelled_loans
    GROUP BY loan_id
    HAVING COUNT(*) > 1
) duplicates;

-- Agora adicionar a constraint única
ALTER TABLE cancelled_loans ADD CONSTRAINT unique_cancelled_loan_id UNIQUE (loan_id);

-- Verificar se a constraint foi criada
SELECT 
    constraint_name,
    constraint_type
FROM information_schema.table_constraints 
WHERE table_name = 'cancelled_loans'
    AND constraint_name = 'unique_cancelled_loan_id';