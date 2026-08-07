-- =====================================================
-- DIAGNÓSTICO PARA ERRO ON CONFLICT
-- =====================================================
-- Este script ajuda a identificar problemas com ON CONFLICT
-- na tabela installment_payments
-- =====================================================

-- 1. Verificar estrutura da tabela installment_payments
\echo '=== ESTRUTURA DA TABELA installment_payments ==='
\d+ installment_payments;

-- 2. Listar todas as constraints da tabela
\echo '=== CONSTRAINTS DA TABELA installment_payments ==='
SELECT 
    conname as constraint_name,
    contype as type,
    CASE contype 
        WHEN 'p' THEN 'PRIMARY KEY'
        WHEN 'u' THEN 'UNIQUE'
        WHEN 'f' THEN 'FOREIGN KEY'
        WHEN 'c' THEN 'CHECK'
        WHEN 'x' THEN 'EXCLUSION'
        ELSE 'OTHER'
    END as constraint_type,
    pg_get_constraintdef(oid) as definition
FROM pg_constraint 
WHERE conrelid = 'installment_payments'::regclass
ORDER BY contype, conname;

-- 3. Verificar índices únicos
\echo '=== ÍNDICES ÚNICOS ==='
SELECT 
    indexname,
    indexdef
FROM pg_indexes 
WHERE tablename = 'installment_payments' 
AND indexdef LIKE '%UNIQUE%';

-- 4. Verificar se há duplicatas que impediriam ON CONFLICT
\echo '=== VERIFICAÇÃO DE DUPLICATAS ==='
SELECT 
    installment_id, 
    installment_number, 
    COUNT(*) as count,
    array_agg(id) as ids
FROM installment_payments 
GROUP BY installment_id, installment_number 
HAVING COUNT(*) > 1;

-- 5. Verificar registros com valores NULL nas colunas chave
\echo '=== VERIFICAÇÃO DE VALORES NULL ==='
SELECT 
    'installment_id NULL' as issue,
    COUNT(*) as count
FROM installment_payments 
WHERE installment_id IS NULL
UNION ALL
SELECT 
    'installment_number NULL' as issue,
    COUNT(*) as count
FROM installment_payments 
WHERE installment_number IS NULL;

-- 6. Testar ON CONFLICT manualmente
\echo '=== TESTE DE ON CONFLICT ==='
DO $$
DECLARE
    test_installment_id UUID;
    test_result TEXT;
BEGIN
    -- Pegar um installment_id existente para teste
    SELECT installment_id INTO test_installment_id 
    FROM installment_payments 
    LIMIT 1;
    
    IF test_installment_id IS NOT NULL THEN
        BEGIN
            -- Tentar inserir com ON CONFLICT
            INSERT INTO installment_payments (
                installment_id, 
                installment_number, 
                amount, 
                due_date, 
                status
            ) VALUES (
                test_installment_id, 
                999, -- Número alto para evitar conflito real
                100.00, 
                CURRENT_DATE, 
                'pending'
            ) ON CONFLICT (installment_id, installment_number) DO NOTHING;
            
            test_result := 'ON CONFLICT funcionou corretamente';
            
            -- Remover o registro de teste
            DELETE FROM installment_payments 
            WHERE installment_id = test_installment_id 
            AND installment_number = 999;
            
        EXCEPTION WHEN OTHERS THEN
            test_result := 'ERRO: ' || SQLERRM;
        END;
    ELSE
        test_result := 'Nenhum registro encontrado para teste';
    END IF;
    
    RAISE NOTICE 'Resultado do teste ON CONFLICT: %', test_result;
END $$;

-- 7. Verificar políticas RLS que podem afetar ON CONFLICT
\echo '=== POLÍTICAS RLS ==='
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'installment_payments';

-- 8. Verificar triggers que podem interferir
\echo '=== TRIGGERS ==='
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'installment_payments';

-- 9. Estatísticas da tabela
\echo '=== ESTATÍSTICAS ==='
SELECT 
    COUNT(*) as total_records,
    COUNT(DISTINCT installment_id) as unique_installments,
    COUNT(DISTINCT installment_number) as unique_numbers,
    MIN(installment_number) as min_number,
    MAX(installment_number) as max_number,
    COUNT(DISTINCT status) as unique_statuses
FROM installment_payments;

-- 10. Verificar se a tabela está em uma transação
\echo '=== STATUS DA TRANSAÇÃO ==='
SELECT 
    pid,
    state,
    query_start,
    state_change,
    query
FROM pg_stat_activity 
WHERE datname = current_database()
AND query LIKE '%installment_payments%'
AND state != 'idle';

\echo '=== DIAGNÓSTICO CONCLUÍDO ==='
\echo 'Se ON CONFLICT ainda não funcionar, verifique:'
\echo '1. Se há código JavaScript usando upsert() do Supabase'
\echo '2. Se há funções PL/pgSQL usando ON CONFLICT'
\echo '3. Se as constraints foram criadas corretamente'
\echo '4. Se há conflitos de nomenclatura de constraints';