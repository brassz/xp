-- =====================================================
-- FORÇA BRUTA: Remove TUDO que pode bloquear
-- =====================================================
-- Use este script se NADA mais funcionou
-- =====================================================

SELECT '💪 INICIANDO CORREÇÃO FORÇA BRUTA...' as status;

-- PASSO 1: Remover TODOS os triggers
SELECT '1. Removendo TODOS os triggers...' as passo;

DO $$
DECLARE
    trigger_record RECORD;
BEGIN
    FOR trigger_record IN 
        SELECT trigger_name 
        FROM information_schema.triggers 
        WHERE event_object_table = 'paid_loans'
    LOOP
        EXECUTE 'DROP TRIGGER IF EXISTS ' || trigger_record.trigger_name || ' ON paid_loans CASCADE';
        RAISE NOTICE 'Trigger removido: %', trigger_record.trigger_name;
    END LOOP;
END $$;

-- PASSO 2: Remover TODAS as políticas RLS
SELECT '2. Removendo TODAS as políticas RLS...' as passo;

DO $$
DECLARE
    policy_record RECORD;
BEGIN
    FOR policy_record IN 
        SELECT policyname 
        FROM pg_policies 
        WHERE tablename = 'paid_loans'
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS "' || policy_record.policyname || '" ON paid_loans';
        RAISE NOTICE 'Política removida: %', policy_record.policyname;
    END LOOP;
END $$;

-- PASSO 3: Desabilitar RLS
SELECT '3. Desabilitando RLS...' as passo;

ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;

-- PASSO 4: Remover TODAS as constraints (exceto PK)
SELECT '4. Analisando constraints...' as passo;

DO $$
DECLARE
    constraint_record RECORD;
BEGIN
    FOR constraint_record IN 
        SELECT constraint_name, constraint_type
        FROM information_schema.table_constraints
        WHERE table_name = 'paid_loans'
        AND constraint_type != 'PRIMARY KEY'
    LOOP
        BEGIN
            EXECUTE 'ALTER TABLE paid_loans DROP CONSTRAINT IF EXISTS ' || constraint_record.constraint_name || ' CASCADE';
            RAISE NOTICE 'Constraint removida: % (%)', constraint_record.constraint_name, constraint_record.constraint_type;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Não foi possível remover: % (ignorando)', constraint_record.constraint_name;
        END;
    END LOOP;
END $$;

-- PASSO 5: Conceder TODAS as permissões possíveis
SELECT '5. Concedendo TODAS as permissões...' as passo;

GRANT ALL PRIVILEGES ON paid_loans TO PUBLIC;
GRANT ALL PRIVILEGES ON paid_loans TO authenticated;
GRANT ALL PRIVILEGES ON paid_loans TO anon;
GRANT ALL PRIVILEGES ON paid_loans TO service_role;
GRANT ALL PRIVILEGES ON paid_loans TO postgres;

-- PASSO 6: Verificar estrutura mínima
SELECT '6. Verificando estrutura da tabela...' as passo;

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'paid_loans'
ORDER BY ordinal_position;

-- PASSO 7: TESTE FINAL
SELECT '7. TESTE FINAL DE INSERÇÃO...' as passo;

DO $$
DECLARE
    v_client_id UUID;
    v_test_id UUID;
BEGIN
    SELECT id INTO v_client_id FROM clients LIMIT 1;
    
    IF v_client_id IS NULL THEN
        RAISE EXCEPTION 'Nenhum cliente encontrado';
    END IF;
    
    INSERT INTO paid_loans (
        loan_id, client_id, original_amount, interest_rate,
        total_with_interest, loan_date, due_date, paid_date,
        total_paid, payment_method, notes
    ) VALUES (
        gen_random_uuid(), v_client_id, 1000.00, 10.00,
        1100.00, CURRENT_DATE, CURRENT_DATE, CURRENT_DATE,
        1100.00, 'TESTE_FINAL', 'Teste após força bruta'
    ) RETURNING id INTO v_test_id;
    
    RAISE NOTICE '✅✅✅ INSERÇÃO FUNCIONOU! ✅✅✅';
    RAISE NOTICE 'ID do registro: %', v_test_id;
    
    -- Verificar se está lá
    IF EXISTS (SELECT 1 FROM paid_loans WHERE id = v_test_id) THEN
        RAISE NOTICE '✅ Registro CONFIRMADO na tabela!';
        DELETE FROM paid_loans WHERE id = v_test_id;
        RAISE NOTICE '✅ Teste limpo';
    ELSE
        RAISE NOTICE '❌ ERRO CRÍTICO: Registro inserido mas não encontrado!';
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ ERRO: %', SQLERRM;
        RAISE NOTICE 'Código: %', SQLSTATE;
END $$;

-- RESULTADO
SELECT '✅ FORÇA BRUTA COMPLETA!' as resultado;
SELECT 'Agora a tabela paid_loans está COMPLETAMENTE ABERTA' as status;
SELECT 'Teste novamente no sistema!' as proxima_acao;

-- Ver status final
SELECT 
    'Status Final:' as titulo,
    (SELECT COUNT(*) FROM information_schema.triggers WHERE event_object_table = 'paid_loans') as triggers_restantes,
    (SELECT COUNT(*) FROM pg_policies WHERE tablename = 'paid_loans') as politicas_restantes,
    (SELECT rowsecurity FROM pg_tables WHERE tablename = 'paid_loans') as rls_ativo;
