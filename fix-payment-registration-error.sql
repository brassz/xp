-- =====================================================
-- CORREÇÃO PARA ERRO DE REGISTRO DE PAGAMENTO
-- =====================================================
-- Erro: "there is no unique or exclusion constraint matching the ON CONFLICT specification"
-- =====================================================

-- Passo 1: Verificar e corrigir a estrutura da tabela installment_payments
DO $$
BEGIN
    -- Verificar se a tabela existe
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'installment_payments') THEN
        RAISE EXCEPTION 'Tabela installment_payments não encontrada!';
    END IF;
    
    RAISE NOTICE 'Tabela installment_payments encontrada. Verificando constraints...';
END $$;

-- Passo 2: Garantir que a constraint UNIQUE existe
DO $$
BEGIN
    -- Verificar se já existe a constraint
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
        WHERE tc.table_name = 'installment_payments' 
        AND tc.constraint_type = 'UNIQUE'
        AND kcu.column_name IN ('installment_id', 'installment_number')
    ) THEN
        -- Criar a constraint se não existir
        ALTER TABLE installment_payments 
        ADD CONSTRAINT installment_payments_unique_combo 
        UNIQUE (installment_id, installment_number);
        
        RAISE NOTICE 'Constraint UNIQUE criada: (installment_id, installment_number)';
    ELSE
        RAISE NOTICE 'Constraint UNIQUE já existe';
    END IF;
EXCEPTION WHEN duplicate_table THEN
    RAISE NOTICE 'Constraint já existe com nome diferente';
WHEN others THEN
    RAISE NOTICE 'Erro ao criar constraint: %', SQLERRM;
END $$;

-- Passo 3: Verificar e limpar dados duplicados
DO $$
DECLARE
    duplicate_count INTEGER;
    rec RECORD;
BEGIN
    -- Contar duplicatas
    SELECT COUNT(*) INTO duplicate_count
    FROM (
        SELECT installment_id, installment_number
        FROM installment_payments 
        GROUP BY installment_id, installment_number 
        HAVING COUNT(*) > 1
    ) dups;
    
    IF duplicate_count > 0 THEN
        RAISE WARNING 'Encontradas duplicatas. Removendo registros duplicados...';
        
        -- Manter apenas o registro mais recente de cada duplicata
        DELETE FROM installment_payments 
        WHERE id NOT IN (
            SELECT DISTINCT ON (installment_id, installment_number) id
            FROM installment_payments 
            ORDER BY installment_id, installment_number, created_at DESC
        );
        
        RAISE NOTICE 'Duplicatas removidas';
    ELSE
        RAISE NOTICE 'Nenhuma duplicata encontrada';
    END IF;
END $$;

-- Passo 4: Verificar se há problemas com valores NULL
UPDATE installment_payments 
SET installment_number = 1 
WHERE installment_number IS NULL;

-- Passo 5: Recriar índices se necessário
DROP INDEX IF EXISTS idx_installment_payments_unique_combo;
CREATE UNIQUE INDEX idx_installment_payments_unique_combo 
ON installment_payments(installment_id, installment_number);

-- Passo 6: Testar ON CONFLICT
DO $$
DECLARE
    test_installment_id UUID;
    success BOOLEAN := FALSE;
BEGIN
    -- Pegar um installment_id existente
    SELECT installment_id INTO test_installment_id 
    FROM installment_payments 
    LIMIT 1;
    
    IF test_installment_id IS NOT NULL THEN
        -- Testar ON CONFLICT
        BEGIN
            INSERT INTO installment_payments (
                installment_id, 
                installment_number, 
                amount, 
                due_date, 
                status
            ) VALUES (
                test_installment_id, 
                9999, 
                1.00, 
                CURRENT_DATE, 
                'pending'
            ) ON CONFLICT (installment_id, installment_number) DO NOTHING;
            
            success := TRUE;
            
            -- Limpar teste
            DELETE FROM installment_payments 
            WHERE installment_id = test_installment_id 
            AND installment_number = 9999;
            
        EXCEPTION WHEN OTHERS THEN
            RAISE WARNING 'Teste ON CONFLICT falhou: %', SQLERRM;
        END;
    END IF;
    
    IF success THEN
        RAISE NOTICE '✅ ON CONFLICT está funcionando corretamente!';
    ELSE
        RAISE WARNING '❌ ON CONFLICT ainda apresenta problemas';
    END IF;
END $$;

-- Passo 7: Verificar constraints finais
SELECT 
    'Constraint Check' as status,
    conname as constraint_name,
    pg_get_constraintdef(oid) as definition
FROM pg_constraint 
WHERE conrelid = 'installment_payments'::regclass
AND contype = 'u';

-- Passo 8: Mostrar estatísticas finais
SELECT 
    'Estatísticas Finais' as info,
    COUNT(*) as total_records,
    COUNT(DISTINCT installment_id) as unique_installments,
    MIN(created_at) as oldest_record,
    MAX(created_at) as newest_record
FROM installment_payments;

RAISE NOTICE '=== CORREÇÃO CONCLUÍDA ===';
RAISE NOTICE 'Se o erro persistir, execute o diagnóstico completo com diagnose-on-conflict-error.sql';
RAISE NOTICE 'Ou verifique se há código JavaScript usando upsert() sem as opções corretas';