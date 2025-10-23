-- =====================================================
-- CORREÇÃO: PRESERVAR VALOR ORIGINAL DOS EMPRÉSTIMOS
-- =====================================================
-- Este script corrige o problema onde o valor original dos empréstimos
-- estava sendo alterado incorretamente pelos pagamentos

-- 1. Adicionar campo para preservar valor original (se não existir)
ALTER TABLE loans 
ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);

-- 2. Preencher campo original_amount com valores atuais (para empréstimos existentes)
-- Isso deve ser feito apenas uma vez, para preservar os valores originais
UPDATE loans 
SET original_amount = amount 
WHERE original_amount IS NULL;

-- 3. Tornar o campo obrigatório após preencher
ALTER TABLE loans 
ALTER COLUMN original_amount SET NOT NULL;

-- 4. Adicionar comentários explicativos
COMMENT ON COLUMN loans.amount IS 'Valor atual do empréstimo (pode ser reduzido por pagamentos de capital)';
COMMENT ON COLUMN loans.original_amount IS 'Valor original do empréstimo (NUNCA deve ser alterado após criação)';

-- 5. Criar índice para consultas
CREATE INDEX IF NOT EXISTS idx_loans_original_amount ON loans(original_amount);

-- 6. Verificar se as colunas foram criadas corretamente
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default,
    col_description(pgc.oid, a.attnum) as comment
FROM information_schema.columns a
JOIN pg_class pgc ON pgc.relname = a.table_name
WHERE a.table_name = 'loans' 
AND a.column_name IN ('amount', 'original_amount')
ORDER BY a.column_name;

-- 7. Exemplo de consulta para verificar dados
/*
SELECT 
    id,
    original_amount as "Valor Original",
    amount as "Valor Atual",
    (original_amount - amount) as "Capital Pago",
    created_at
FROM loans 
ORDER BY created_at DESC 
LIMIT 10;
*/