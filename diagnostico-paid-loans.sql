-- =====================================================
-- DIAGNÓSTICO COMPLETO - Tabela paid_loans
-- =====================================================
-- Execute este script para diagnosticar o problema
-- =====================================================

-- PASSO 1: Verificar se a tabela existe
SELECT 
    '1️⃣ VERIFICAR TABELA' as passo,
    CASE 
        WHEN EXISTS (SELECT FROM pg_tables WHERE tablename = 'paid_loans') 
        THEN '✅ Tabela existe'
        ELSE '❌ Tabela NÃO existe'
    END as status;

-- PASSO 2: Verificar se RLS está habilitado
SELECT 
    '2️⃣ VERIFICAR RLS' as passo,
    tablename,
    CASE 
        WHEN rowsecurity THEN '✅ RLS Habilitado'
        ELSE '❌ RLS Desabilitado'
    END as status
FROM pg_tables 
WHERE tablename = 'paid_loans';

-- PASSO 3: Listar todas as políticas RLS
SELECT 
    '3️⃣ POLÍTICAS RLS' as passo,
    policyname,
    cmd as operacao,
    qual as condicao_select,
    with_check as condicao_insert
FROM pg_policies 
WHERE tablename = 'paid_loans';

-- PASSO 4: Verificar permissões da role 'authenticated'
SELECT 
    '4️⃣ PERMISSÕES' as passo,
    privilege_type
FROM information_schema.role_table_grants
WHERE table_name = 'paid_loans' 
AND grantee = 'authenticated';

-- PASSO 5: Testar INSERT manualmente (como authenticated)
-- Este teste vai mostrar se o problema é de permissão
DO $$ 
BEGIN
    -- Tentar inserir um registro de teste
    BEGIN
        INSERT INTO paid_loans (
            loan_id,
            client_id,
            original_amount,
            interest_rate,
            total_with_interest,
            loan_date,
            due_date,
            paid_date,
            total_paid,
            payment_method,
            notes
        ) VALUES (
            gen_random_uuid(), -- loan_id
            gen_random_uuid(), -- client_id (fake)
            1000.00,
            5.00,
            1050.00,
            CURRENT_DATE,
            CURRENT_DATE + INTERVAL '30 days',
            CURRENT_DATE,
            1050.00,
            'Teste',
            'Teste de inserção manual'
        );
        
        RAISE NOTICE '5️⃣ TESTE INSERT: ✅ INSERT funcionou! O problema pode ser nas políticas RLS ou no código JavaScript.';
        
        -- Remover o registro de teste
        DELETE FROM paid_loans WHERE notes = 'Teste de inserção manual';
        RAISE NOTICE '   Registro de teste removido.';
        
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '5️⃣ TESTE INSERT: ❌ INSERT falhou! Erro: %', SQLERRM;
    END;
END $$;

-- PASSO 6: Verificar se há registros na tabela
SELECT 
    '6️⃣ CONTAGEM' as passo,
    COUNT(*) as total_registros
FROM paid_loans;

-- PASSO 7: Tentar ver registros existentes
SELECT 
    '7️⃣ ÚLTIMOS REGISTROS' as passo,
    id,
    loan_id,
    paid_date,
    original_amount,
    notes
FROM paid_loans
ORDER BY created_at DESC
LIMIT 5;

-- =====================================================
-- MENSAGEM FINAL
-- =====================================================

DO $$ 
DECLARE
    table_exists BOOLEAN;
    rls_enabled BOOLEAN;
    policy_count INTEGER;
    permission_count INTEGER;
BEGIN
    -- Verificar tabela
    SELECT EXISTS (
        SELECT FROM pg_tables 
        WHERE tablename = 'paid_loans'
    ) INTO table_exists;
    
    -- Verificar RLS
    SELECT rowsecurity INTO rls_enabled
    FROM pg_tables 
    WHERE tablename = 'paid_loans';
    
    -- Contar políticas
    SELECT COUNT(*) INTO policy_count
    FROM pg_policies 
    WHERE tablename = 'paid_loans';
    
    -- Contar permissões
    SELECT COUNT(*) INTO permission_count
    FROM information_schema.role_table_grants
    WHERE table_name = 'paid_loans' 
    AND grantee = 'authenticated';
    
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'RESUMO DO DIAGNÓSTICO';
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Tabela existe: %', table_exists;
    RAISE NOTICE 'RLS habilitado: %', rls_enabled;
    RAISE NOTICE 'Políticas RLS: %', policy_count;
    RAISE NOTICE 'Permissões: %', permission_count;
    RAISE NOTICE '==============================================';
    
    IF NOT table_exists THEN
        RAISE NOTICE '❌ PROBLEMA: Tabela não existe!';
        RAISE NOTICE '   SOLUÇÃO: Execute fix-litoral-paid-loans.sql';
    ELSIF policy_count < 4 THEN
        RAISE NOTICE '⚠️ PROBLEMA: Políticas RLS incompletas!';
        RAISE NOTICE '   SOLUÇÃO: Execute fix-litoral-paid-loans.sql';
    ELSIF permission_count < 4 THEN
        RAISE NOTICE '⚠️ PROBLEMA: Permissões insuficientes!';
        RAISE NOTICE '   SOLUÇÃO: Execute fix-litoral-paid-loans.sql';
    ELSE
        RAISE NOTICE '✅ Configuração parece correta.';
        RAISE NOTICE '   Se ainda não funciona, o problema pode ser:';
        RAISE NOTICE '   1. Políticas RLS muito restritivas';
        RAISE NOTICE '   2. created_by não está sendo passado';
        RAISE NOTICE '   3. Erro no código JavaScript';
        RAISE NOTICE '   ';
        RAISE NOTICE '   PRÓXIMO PASSO: Veja os logs do console do navegador (F12)';
    END IF;
    
    RAISE NOTICE '==============================================';
END $$;
