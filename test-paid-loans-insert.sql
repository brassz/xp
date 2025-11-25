-- =====================================================
-- TESTE: Inserção na Tabela paid_loans
-- =====================================================
-- Este script testa se a inserção em paid_loans funciona
-- Execute APÓS aplicar a correção fix-paid-loans-issue.sql
-- =====================================================

\echo '=========================================='
\echo 'TESTE DE INSERÇÃO EM PAID_LOANS'
\echo '=========================================='
\echo ''

-- Passo 1: Verificar se a tabela existe
\echo '1. Verificando se a tabela existe...'
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'paid_loans') THEN
        RAISE EXCEPTION 'ERRO: Tabela paid_loans não existe! Execute setup-paid-loans.sql primeiro.';
    ELSE
        RAISE NOTICE '✅ Tabela paid_loans existe';
    END IF;
END $$;

\echo ''

-- Passo 2: Buscar um cliente e um empréstimo para teste
\echo '2. Buscando dados para teste...'
\echo ''

-- Pegar primeiro cliente disponível
SELECT 
    id as client_id,
    name as client_name,
    cpf
FROM clients 
LIMIT 1;

-- Pegar primeiro empréstimo ativo (se existir)
SELECT 
    l.id as loan_id,
    l.amount,
    l.interest_rate,
    l.loan_date,
    l.due_date,
    c.name as client_name
FROM loans l
JOIN clients c ON l.client_id = c.id
WHERE l.status != 'paid'
LIMIT 1;

\echo ''

-- Passo 3: Realizar inserção de teste
\echo '3. Tentando inserir um registro de teste...'
\echo ''

DO $$
DECLARE
    v_client_id UUID;
    v_test_loan_id UUID;
    v_test_id UUID;
BEGIN
    -- Buscar primeiro cliente
    SELECT id INTO v_client_id FROM clients LIMIT 1;
    
    IF v_client_id IS NULL THEN
        RAISE EXCEPTION 'ERRO: Nenhum cliente encontrado. Cadastre um cliente primeiro.';
    END IF;
    
    -- Gerar UUID para o teste
    v_test_loan_id := gen_random_uuid();
    
    -- Inserir registro de teste
    INSERT INTO paid_loans (
        id,
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
        notes,
        created_at
    ) VALUES (
        gen_random_uuid(),
        v_test_loan_id,
        v_client_id,
        1000.00,
        10.00,
        1100.00,
        CURRENT_DATE - INTERVAL '30 days',
        CURRENT_DATE,
        CURRENT_DATE,
        1100.00,
        'TESTE',
        '⚠️ TESTE DE INSERÇÃO - PODE SER DELETADO',
        NOW()
    ) RETURNING id INTO v_test_id;
    
    RAISE NOTICE '✅ SUCESSO! Registro de teste inserido com ID: %', v_test_id;
    RAISE NOTICE '✅ A inserção em paid_loans está FUNCIONANDO!';
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ ERRO na inserção: %', SQLERRM;
        RAISE NOTICE '❌ Código do erro: %', SQLSTATE;
        RAISE NOTICE '';
        RAISE NOTICE '🔧 Execute o script fix-paid-loans-issue.sql para corrigir';
        RAISE;
END $$;

\echo ''

-- Passo 4: Verificar se o registro foi inserido
\echo '4. Verificando registros de teste inseridos...'
\echo ''

SELECT 
    id,
    loan_id,
    client_id,
    original_amount,
    interest_rate,
    paid_date,
    payment_method,
    notes,
    created_at
FROM paid_loans
WHERE payment_method = 'TESTE'
ORDER BY created_at DESC
LIMIT 5;

\echo ''

-- Passo 5: Contar total de registros
\echo '5. Total de registros em paid_loans:'
SELECT 
    COUNT(*) as total_registros,
    COUNT(CASE WHEN payment_method = 'TESTE' THEN 1 END) as registros_teste,
    COUNT(CASE WHEN payment_method != 'TESTE' THEN 1 END) as registros_reais
FROM paid_loans;

\echo ''
\echo '=========================================='
\echo 'LIMPEZA (OPCIONAL)'
\echo '=========================================='
\echo ''
\echo 'Para REMOVER os registros de teste:'
\echo 'DELETE FROM paid_loans WHERE payment_method = ''TESTE'';'
\echo ''

-- Passo 6: Diagnóstico de permissões
\echo '6. Verificando permissões...'
SELECT 
    grantee as "Role",
    string_agg(privilege_type, ', ') as "Permissões"
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans'
GROUP BY grantee
ORDER BY grantee;

\echo ''

-- Passo 7: Verificar RLS
\echo '7. Verificando políticas RLS...'
SELECT 
    policyname as "Política",
    cmd as "Comando",
    CASE WHEN permissive = 't' THEN '✅ Permissivo' ELSE '⚠️ Restritivo' END as "Tipo"
FROM pg_policies 
WHERE tablename = 'paid_loans'
ORDER BY cmd;

\echo ''
\echo '=========================================='
\echo 'RESULTADO DO TESTE'
\echo '=========================================='
\echo ''

DO $$
DECLARE
    v_count INTEGER;
    v_has_permissions BOOLEAN;
    v_has_insert_policy BOOLEAN;
BEGIN
    -- Verificar se tem registros de teste
    SELECT COUNT(*) INTO v_count FROM paid_loans WHERE payment_method = 'TESTE';
    
    -- Verificar permissões
    SELECT EXISTS (
        SELECT 1 FROM information_schema.role_table_grants 
        WHERE table_name = 'paid_loans' 
        AND privilege_type = 'INSERT'
        AND grantee = 'authenticated'
    ) INTO v_has_permissions;
    
    -- Verificar política de INSERT
    SELECT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'paid_loans' 
        AND cmd = 'INSERT'
    ) INTO v_has_insert_policy;
    
    IF v_count > 0 THEN
        RAISE NOTICE '✅✅✅ TESTE PASSOU! ✅✅✅';
        RAISE NOTICE '';
        RAISE NOTICE '✅ Registro de teste inserido com sucesso!';
        RAISE NOTICE '✅ A tabela paid_loans está FUNCIONANDO corretamente!';
        RAISE NOTICE '✅ O sistema agora deve salvar empréstimos quitados!';
        RAISE NOTICE '';
        RAISE NOTICE '📝 Próximos passos:';
        RAISE NOTICE '1. Teste marcar um empréstimo como quitado no sistema';
        RAISE NOTICE '2. Verifique se aparece na interface';
        RAISE NOTICE '3. Para limpar registros de teste: DELETE FROM paid_loans WHERE payment_method = ''TESTE'';';
    ELSE
        RAISE NOTICE '❌❌❌ TESTE FALHOU! ❌❌❌';
        RAISE NOTICE '';
        RAISE NOTICE '❌ Não foi possível inserir o registro de teste';
        RAISE NOTICE '';
        IF NOT v_has_permissions THEN
            RAISE NOTICE '❌ Problema: Role "authenticated" não tem permissão INSERT';
            RAISE NOTICE '🔧 Solução: Execute fix-paid-loans-issue.sql';
        END IF;
        IF NOT v_has_insert_policy THEN
            RAISE NOTICE '⚠️  Aviso: Nenhuma política RLS para INSERT';
            RAISE NOTICE '🔧 Solução: Execute fix-paid-loans-issue.sql';
        END IF;
    END IF;
END $$;

\echo ''
\echo '=========================================='
\echo 'FIM DO TESTE'
\echo '=========================================='
\echo ''
\echo '📚 Para mais detalhes, consulte:'
\echo '   - README-CORRECAO-PAID-LOANS.md'
\echo '   - GUIA-RAPIDO-PAID-LOANS.md'
\echo ''
