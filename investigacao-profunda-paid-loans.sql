-- =====================================================
-- INVESTIGAÇÃO PROFUNDA: Por que não salva?
-- =====================================================
-- Execute este script para encontrar o problema real
-- =====================================================

SELECT '🔍 INVESTIGAÇÃO PROFUNDA INICIADA' as titulo;

-- 1. Verificar se a tabela existe e está acessível
SELECT '1. TABELA EXISTE?' as passo;

SELECT 
    table_name,
    table_type,
    CASE 
        WHEN table_name = 'paid_loans' THEN '✅ Tabela existe'
        ELSE '❌ Tabela não encontrada'
    END as status
FROM information_schema.tables
WHERE table_name = 'paid_loans';

-- 2. Verificar constraints que podem estar bloqueando
SELECT '2. CONSTRAINTS (podem bloquear)?' as passo;

SELECT 
    constraint_name,
    constraint_type,
    table_name
FROM information_schema.table_constraints
WHERE table_name = 'paid_loans'
ORDER BY constraint_type;

-- 3. Verificar foreign keys (podem falhar silenciosamente)
SELECT '3. FOREIGN KEYS (podem causar erro)?' as passo;

SELECT 
    tc.constraint_name,
    kcu.column_name,
    ccu.table_name AS foreign_table,
    ccu.column_name AS foreign_column,
    CASE 
        WHEN ccu.table_name IS NOT NULL THEN '⚠️  Verifica se referência existe'
        ELSE '✅ OK'
    END as alerta
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
LEFT JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_name = 'paid_loans' 
    AND tc.constraint_type = 'FOREIGN KEY';

-- 4. Verificar triggers (podem estar deletando/bloqueando)
SELECT '4. TRIGGERS (podem deletar após inserir)?' as passo;

SELECT 
    trigger_name,
    event_manipulation as evento,
    action_timing as quando,
    action_statement as acao,
    '⚠️  PODE ESTAR INTERFERINDO!' as alerta
FROM information_schema.triggers
WHERE event_object_table = 'paid_loans';

-- 5. RLS realmente desabilitado?
SELECT '5. RLS STATUS (deve estar false)?' as passo;

SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_ativo,
    CASE 
        WHEN rowsecurity = false THEN '✅ RLS desabilitado'
        ELSE '❌ RLS AINDA ATIVO!'
    END as status
FROM pg_tables
WHERE tablename = 'paid_loans';

-- 6. Políticas (deve estar vazio)
SELECT '6. POLÍTICAS RLS (deve estar vazio)?' as passo;

SELECT 
    policyname,
    cmd,
    '❌ AINDA TEM POLÍTICA!' as problema
FROM pg_policies 
WHERE tablename = 'paid_loans';

SELECT CASE 
    WHEN NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'paid_loans')
    THEN '✅ Nenhuma política (correto)'
    ELSE '❌ Ainda tem políticas ativas!'
END as resultado;

-- 7. Permissões
SELECT '7. PERMISSÕES?' as passo;

SELECT 
    grantee,
    privilege_type
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans'
ORDER BY grantee, privilege_type;

-- 8. Verificar se há dados na tabela
SELECT '8. QUANTOS REGISTROS EXISTEM?' as passo;

SELECT COUNT(*) as total_registros FROM paid_loans;

-- 9. TESTE DE INSERÇÃO DETALHADO
SELECT '9. TESTE DE INSERÇÃO DETALHADO' as passo;

DO $$
DECLARE
    v_client_id UUID;
    v_loan_id UUID := gen_random_uuid();
    v_inserted_id UUID;
    v_count_before INTEGER;
    v_count_after INTEGER;
    v_exists BOOLEAN;
BEGIN
    -- Contar antes
    SELECT COUNT(*) INTO v_count_before FROM paid_loans;
    RAISE NOTICE 'Registros ANTES: %', v_count_before;
    
    -- Buscar cliente
    SELECT id INTO v_client_id FROM clients LIMIT 1;
    
    IF v_client_id IS NULL THEN
        RAISE EXCEPTION 'Nenhum cliente encontrado - cadastre um primeiro';
    END IF;
    
    RAISE NOTICE 'Cliente encontrado: %', v_client_id;
    RAISE NOTICE 'Tentando inserir com loan_id: %', v_loan_id;
    
    -- Tentar inserir COM tratamento de erro
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
            v_loan_id,
            v_client_id,
            1000.00,
            10.00,
            1100.00,
            CURRENT_DATE,
            CURRENT_DATE,
            CURRENT_DATE,
            1100.00,
            'TESTE_INVESTIGACAO',
            'Teste de investigação profunda'
        ) RETURNING id INTO v_inserted_id;
        
        RAISE NOTICE '✅ INSERT executado sem erro! ID retornado: %', v_inserted_id;
        
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '❌ ERRO NO INSERT!';
            RAISE NOTICE 'Erro: %', SQLERRM;
            RAISE NOTICE 'Código: %', SQLSTATE;
            RAISE NOTICE 'Detalhe: %', PG_EXCEPTION_DETAIL;
            RAISE NOTICE 'Hint: %', PG_EXCEPTION_HINT;
            RETURN;
    END;
    
    -- Contar depois
    SELECT COUNT(*) INTO v_count_after FROM paid_loans;
    RAISE NOTICE 'Registros DEPOIS: %', v_count_after;
    
    IF v_count_after > v_count_before THEN
        RAISE NOTICE '✅ Registro FOI INSERIDO! Diferença: %', v_count_after - v_count_before;
    ELSE
        RAISE NOTICE '❌ Registro NÃO FOI INSERIDO! Contagem permanece: %', v_count_after;
    END IF;
    
    -- Verificar se consegue ler o registro inserido
    SELECT EXISTS(
        SELECT 1 FROM paid_loans WHERE loan_id = v_loan_id
    ) INTO v_exists;
    
    IF v_exists THEN
        RAISE NOTICE '✅ Registro ENCONTRADO na tabela!';
        
        -- Mostrar o registro
        RAISE NOTICE 'Dados do registro:';
        FOR v_record IN 
            SELECT * FROM paid_loans WHERE loan_id = v_loan_id
        LOOP
            RAISE NOTICE 'ID: %, loan_id: %, client_id: %, amount: %', 
                v_record.id, v_record.loan_id, v_record.client_id, v_record.original_amount;
        END LOOP;
        
        -- Limpar teste
        DELETE FROM paid_loans WHERE loan_id = v_loan_id;
        RAISE NOTICE '✅ Teste limpo';
    ELSE
        RAISE NOTICE '❌ Registro NÃO ENCONTRADO mesmo após INSERT bem-sucedido!';
        RAISE NOTICE '❌ Isso indica problema de TRANSAÇÃO ou TRIGGER!';
    END IF;
    
END $$;

-- 10. DIAGNÓSTICO FINAL
SELECT '10. DIAGNÓSTICO FINAL' as passo;

SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.triggers WHERE event_object_table = 'paid_loans')
        THEN '⚠️  HÁ TRIGGERS NA TABELA - podem estar interferindo!'
        
        WHEN EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'paid_loans')
        THEN '❌ AINDA HÁ POLÍTICAS RLS ATIVAS!'
        
        WHEN (SELECT rowsecurity FROM pg_tables WHERE tablename = 'paid_loans') = true
        THEN '❌ RLS AINDA ESTÁ ATIVO!'
        
        WHEN NOT EXISTS (
            SELECT 1 FROM information_schema.role_table_grants 
            WHERE table_name = 'paid_loans' AND grantee = 'authenticated' AND privilege_type = 'INSERT'
        )
        THEN '❌ FALTA PERMISSÃO DE INSERT!'
        
        ELSE '✅ Configuração parece OK - problema pode ser no código JavaScript ou transação'
    END as diagnostico;

-- =====================================================
-- RECOMENDAÇÕES
-- =====================================================

SELECT 'RECOMENDAÇÕES:' as titulo;

SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.triggers WHERE event_object_table = 'paid_loans')
        THEN 'Desabilite os triggers: DROP TRIGGER ... ON paid_loans'
        
        WHEN EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'paid_loans')
        THEN 'Execute: DROP POLICY ... ON paid_loans para cada política'
        
        ELSE 'Problema pode estar no código JavaScript - verifique console do navegador'
    END as recomendacao;
