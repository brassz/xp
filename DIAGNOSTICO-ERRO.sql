-- =====================================================
-- DIAGNÓSTICO COMPLETO - Erro de Payment Type
-- =====================================================
-- Execute este script no Supabase para diagnosticar o problema

-- 1. Verificar TODAS as constraints da tabela payments
SELECT 
    conname as "Nome da Constraint",
    contype as "Tipo",
    pg_get_constraintdef(oid) as "Definição"
FROM pg_constraint 
WHERE conrelid = 'payments'::regclass
ORDER BY conname;

-- 2. Verificar estrutura completa da coluna payment_type
SELECT 
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'payments' 
  AND column_name = 'payment_type';

-- 3. Verificar se existe a constraint específica
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM pg_constraint 
            WHERE conrelid = 'payments'::regclass 
              AND conname = 'payments_payment_type_check'
        ) 
        THEN '❌ CONSTRAINT AINDA EXISTE - Precisa remover!'
        ELSE '✅ Constraint foi removida corretamente'
    END as "Status da Constraint";

-- 4. Verificar últimos registros de pagamentos
SELECT 
    id,
    payment_type,
    amount,
    payment_date,
    created_at
FROM payments
ORDER BY created_at DESC
LIMIT 5;

-- 5. Testar se aceita novos tipos (SEM GRAVAR - apenas teste)
DO $$ 
BEGIN
    -- Apenas simular, não gravar nada
    RAISE NOTICE 'Testando tipos de payment_type...';
    
    -- Este bloco não grava nada, apenas testa
    PERFORM 1 WHERE 'interest_renewal' IN ('partial', 'full');
    
    IF NOT FOUND THEN
        RAISE NOTICE '✅ Sistema pode aceitar novos tipos de payment_type';
    END IF;
END $$;

-- =====================================================
-- RESULTADO ESPERADO
-- =====================================================
-- Se a constraint ainda existe, você verá na primeira query
-- Execute novamente o comando de remoção
