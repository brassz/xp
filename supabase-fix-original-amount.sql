-- =====================================================
-- CORREÇÃO SUPABASE: Campo original_amount na tabela loans
-- =====================================================
-- Execute este script no SQL Editor do Supabase para corrigir
-- o erro "null value in column original_amount violates not-null constraint"

-- 1. Verificar se a coluna original_amount existe
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'loans' AND column_name = 'original_amount';

-- 2. Adicionar a coluna original_amount se não existir
ALTER TABLE loans ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);

-- 3. Preencher valores NULL com o valor atual de amount
UPDATE loans 
SET original_amount = amount 
WHERE original_amount IS NULL;

-- 4. Tornar a coluna obrigatória
ALTER TABLE loans 
ALTER COLUMN original_amount SET NOT NULL;

-- 5. Adicionar comentário
COMMENT ON COLUMN loans.original_amount IS 'Valor original do empréstimo (preservado para histórico)';

-- 6. Criar índice para performance
CREATE INDEX IF NOT EXISTS idx_loans_original_amount ON loans(original_amount);

-- 7. Verificar a estrutura final
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default
FROM information_schema.columns 
WHERE table_name = 'loans' 
AND column_name IN ('amount', 'original_amount')
ORDER BY column_name;

-- 8. Mostrar estatísticas
SELECT 
    COUNT(*) as total_loans,
    COUNT(original_amount) as loans_with_original_amount,
    AVG(original_amount) as avg_original_amount
FROM loans;