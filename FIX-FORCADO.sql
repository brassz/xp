-- =====================================================
-- FIX FORÇADO - Remove TODAS as constraints de payment_type
-- =====================================================
-- Use este script se o fix anterior não funcionou

-- Passo 1: Desabilitar checagem de integridade temporariamente
SET session_replication_role = replica;

-- Passo 2: Dropar TODAS as constraints relacionadas a payment_type
DO $$ 
DECLARE
    constraint_record RECORD;
BEGIN
    FOR constraint_record IN 
        SELECT conname 
        FROM pg_constraint 
        WHERE conrelid = 'payments'::regclass 
          AND conname LIKE '%payment_type%'
    LOOP
        EXECUTE format('ALTER TABLE payments DROP CONSTRAINT IF EXISTS %I CASCADE', constraint_record.conname);
        RAISE NOTICE 'Removida constraint: %', constraint_record.conname;
    END LOOP;
END $$;

-- Passo 3: Remover constraint específica (garantia extra)
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check CASCADE;
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_check CASCADE;

-- Passo 4: Reabilitar checagem de integridade
SET session_replication_role = DEFAULT;

-- Passo 5: Verificar se foi removido
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM pg_constraint 
            WHERE conrelid = 'payments'::regclass 
              AND (conname LIKE '%payment_type%' OR conname LIKE '%check%')
              AND pg_get_constraintdef(oid) LIKE '%payment_type%'
        ) 
        THEN '❌ AINDA EXISTE - Contacte suporte!'
        ELSE '✅ SUCESSO - Todas as constraints foram removidas!'
    END as resultado;

-- Passo 6: Listar todas as constraints restantes
SELECT 
    conname as constraint_name,
    pg_get_constraintdef(oid) as definition
FROM pg_constraint 
WHERE conrelid = 'payments'::regclass;
