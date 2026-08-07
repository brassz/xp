-- =====================================================
-- FIX PARA ERRO: ON CONFLICT CONSTRAINT MISSING
-- =====================================================
-- Este script corrige o erro "there is no unique or exclusion constraint matching the ON CONFLICT specification"
-- relacionado à tabela installment_payments
-- =====================================================

-- Verificar se a tabela installment_payments existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'installment_payments') THEN
        RAISE EXCEPTION 'Tabela installment_payments não encontrada. Execute primeiro o setup-installments-table.sql';
    END IF;
END $$;

-- Verificar constraints existentes na tabela installment_payments
SELECT 
    conname as constraint_name,
    contype as constraint_type,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE conrelid = 'installment_payments'::regclass;

-- Verificar se a constraint UNIQUE (installment_id, installment_number) existe
DO $$
BEGIN
    -- Remover constraint existente se houver problema
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE table_name = 'installment_payments' 
        AND constraint_type = 'UNIQUE'
        AND constraint_name LIKE '%installment_id%'
    ) THEN
        -- Constraint já existe, verificar se está funcionando
        RAISE NOTICE 'Constraint UNIQUE já existe na tabela installment_payments';
    ELSE
        -- Criar a constraint se não existir
        ALTER TABLE installment_payments 
        ADD CONSTRAINT installment_payments_installment_id_installment_number_key 
        UNIQUE (installment_id, installment_number);
        
        RAISE NOTICE 'Constraint UNIQUE criada: (installment_id, installment_number)';
    END IF;
END $$;

-- Verificar se existe constraint de PRIMARY KEY
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE table_name = 'installment_payments' 
        AND constraint_type = 'PRIMARY KEY'
    ) THEN
        -- Adicionar PRIMARY KEY se não existir
        ALTER TABLE installment_payments ADD PRIMARY KEY (id);
        RAISE NOTICE 'PRIMARY KEY adicionada na coluna id';
    END IF;
END $$;

-- Verificar integridade dos dados existentes
DO $$
DECLARE
    duplicate_count INTEGER;
BEGIN
    -- Verificar se há duplicatas que poderiam causar problemas
    SELECT COUNT(*) INTO duplicate_count
    FROM (
        SELECT installment_id, installment_number, COUNT(*)
        FROM installment_payments 
        GROUP BY installment_id, installment_number 
        HAVING COUNT(*) > 1
    ) duplicates;
    
    IF duplicate_count > 0 THEN
        RAISE WARNING 'Encontradas % duplicatas na tabela installment_payments. Isso pode causar problemas com ON CONFLICT.', duplicate_count;
        
        -- Mostrar as duplicatas
        RAISE NOTICE 'Duplicatas encontradas:';
        FOR rec IN 
            SELECT installment_id, installment_number, COUNT(*) as count
            FROM installment_payments 
            GROUP BY installment_id, installment_number 
            HAVING COUNT(*) > 1
        LOOP
            RAISE NOTICE 'installment_id: %, installment_number: %, count: %', rec.installment_id, rec.installment_number, rec.count;
        END LOOP;
    ELSE
        RAISE NOTICE 'Nenhuma duplicata encontrada. Constraints estão funcionando corretamente.';
    END IF;
END $$;

-- Criar índices para melhor performance se não existirem
CREATE INDEX IF NOT EXISTS idx_installment_payments_unique_combo 
ON installment_payments(installment_id, installment_number);

-- Verificar se as políticas RLS estão ativas
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'installment_payments'
    ) THEN
        RAISE WARNING 'Nenhuma política RLS encontrada para installment_payments. Verifique as permissões.';
    ELSE
        RAISE NOTICE 'Políticas RLS estão configuradas para installment_payments.';
    END IF;
END $$;

-- Mostrar informações finais sobre a tabela
SELECT 
    'installment_payments' as table_name,
    COUNT(*) as total_records,
    COUNT(DISTINCT installment_id) as unique_installments,
    MIN(created_at) as oldest_record,
    MAX(created_at) as newest_record
FROM installment_payments;

-- Verificar se há registros com problemas de integridade
SELECT 
    'Verificação de Integridade' as check_type,
    COUNT(*) as records_with_null_installment_id
FROM installment_payments 
WHERE installment_id IS NULL;

SELECT 
    'Verificação de Integridade' as check_type,
    COUNT(*) as records_with_null_installment_number
FROM installment_payments 
WHERE installment_number IS NULL;

RAISE NOTICE 'Script de correção executado com sucesso!';
RAISE NOTICE 'Se o erro persistir, verifique se há código usando ON CONFLICT com constraint inexistente.';