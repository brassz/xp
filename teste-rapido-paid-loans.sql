-- =====================================================
-- TESTE RÁPIDO: Verificar se RLS está bloqueando
-- =====================================================
-- Execute este script para diagnosticar em 30 segundos
-- =====================================================

SELECT '🔍 TESTE RÁPIDO DE DIAGNÓSTICO' as titulo;

-- 1. RLS está ativo?
SELECT 
    '1. Status do RLS:' as passo,
    CASE 
        WHEN rowsecurity = true THEN '❌ RLS ATIVO (pode estar bloqueando)'
        ELSE '✅ RLS DESABILITADO (bom!)'
    END as status
FROM pg_tables
WHERE tablename = 'paid_loans';

-- 2. Quantas políticas RLS existem?
SELECT 
    '2. Políticas RLS:' as passo,
    COUNT(*) as total_politicas,
    CASE 
        WHEN COUNT(*) > 0 THEN '⚠️  Existem políticas (podem estar bloqueando)'
        ELSE '✅ Nenhuma política (bom!)'
    END as status
FROM pg_policies 
WHERE tablename = 'paid_loans';

-- 3. Listar políticas (se existirem)
SELECT 
    '3. Lista de políticas:' as passo,
    policyname,
    cmd,
    CASE WHEN permissive = 't' THEN 'Permissivo' ELSE 'Restritivo' END as tipo
FROM pg_policies 
WHERE tablename = 'paid_loans';

-- 4. Permissões concedidas
SELECT 
    '4. Permissões:' as passo,
    grantee as role,
    CASE 
        WHEN COUNT(*) >= 4 THEN '✅ Todas permissões'
        ELSE '⚠️  Faltam permissões'
    END as status
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans'
GROUP BY grantee;

-- 5. Teste de inserção real
SELECT '5. TESTE DE INSERÇÃO REAL:' as passo;

DO $$
DECLARE
    v_client_id UUID;
    v_test_id UUID;
BEGIN
    -- Buscar cliente
    SELECT id INTO v_client_id FROM clients LIMIT 1;
    
    IF v_client_id IS NULL THEN
        RAISE NOTICE '⚠️  Nenhum cliente encontrado';
        RETURN;
    END IF;
    
    -- Tentar inserir
    INSERT INTO paid_loans (
        loan_id, client_id, original_amount, interest_rate,
        total_with_interest, loan_date, due_date, paid_date,
        total_paid, payment_method, notes
    ) VALUES (
        gen_random_uuid(), v_client_id, 1000.00, 10.00,
        1100.00, CURRENT_DATE, CURRENT_DATE, CURRENT_DATE,
        1100.00, 'TESTE_DIAGNOSTICO', 'Teste de diagnóstico'
    ) RETURNING id INTO v_test_id;
    
    RAISE NOTICE '✅ INSERÇÃO FUNCIONOU! ID: %', v_test_id;
    
    -- Limpar teste
    DELETE FROM paid_loans WHERE id = v_test_id;
    RAISE NOTICE '✅ Teste limpo';
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ ERRO NA INSERÇÃO: %', SQLERRM;
        RAISE NOTICE '❌ Código: %', SQLSTATE;
        RAISE NOTICE '';
        RAISE NOTICE '🔧 SOLUÇÃO: Execute fix-paid-loans-DEFINITIVO.sql';
END $$;

-- =====================================================
-- DIAGNÓSTICO FINAL
-- =====================================================

SELECT '📊 DIAGNÓSTICO FINAL:' as titulo;

SELECT 
    CASE 
        -- RLS ativo E tem políticas = problema provável
        WHEN EXISTS (
            SELECT 1 FROM pg_tables 
            WHERE tablename = 'paid_loans' AND rowsecurity = true
        ) AND EXISTS (
            SELECT 1 FROM pg_policies WHERE tablename = 'paid_loans'
        )
        THEN '❌ RLS ATIVO COM POLÍTICAS - Este é o problema!'
        
        -- RLS ativo mas sem políticas = problema
        WHEN EXISTS (
            SELECT 1 FROM pg_tables 
            WHERE tablename = 'paid_loans' AND rowsecurity = true
        )
        THEN '⚠️  RLS ATIVO SEM POLÍTICAS - Pode causar problemas'
        
        -- RLS desabilitado = bom
        WHEN EXISTS (
            SELECT 1 FROM pg_tables 
            WHERE tablename = 'paid_loans' AND rowsecurity = false
        )
        THEN '✅ RLS DESABILITADO - Deve funcionar!'
        
        ELSE '❓ Tabela paid_loans não encontrada'
    END as diagnostico,
    
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM pg_tables 
            WHERE tablename = 'paid_loans' AND rowsecurity = true
        )
        THEN '🔧 Execute: fix-paid-loans-DEFINITIVO.sql'
        ELSE '✅ Nenhuma ação necessária'
    END as solucao;

-- =====================================================
-- FIM DO TESTE
-- =====================================================
