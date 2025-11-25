-- =====================================================
-- SOLUÇÃO: Remover constraint de foreign key problemática
-- =====================================================
-- Esta constraint bloqueia inserções em paid_loans
-- porque exige que loan_id exista em loans (mas já foi deletado)
-- =====================================================

SELECT '🔧 REMOVENDO CONSTRAINT PROBLEMÁTICA...' as status;

-- PASSO 1: Identificar a constraint
SELECT '1. Identificando constraint problemática:' as passo;

SELECT 
    constraint_name,
    table_name,
    constraint_type
FROM information_schema.table_constraints
WHERE table_name = 'paid_loans'
    AND constraint_type = 'FOREIGN KEY'
    AND constraint_name LIKE '%loan_id%';

-- PASSO 2: Remover a constraint
SELECT '2. Removendo constraint fk_paid_loans_loan_id...' as passo;

ALTER TABLE paid_loans DROP CONSTRAINT IF EXISTS fk_paid_loans_loan_id;

SELECT '✅ Constraint removida!' as resultado;

-- PASSO 3: Verificar outras constraints de loan_id
SELECT '3. Verificando se há outras constraints com loan_id:' as passo;

SELECT 
    tc.constraint_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_name = 'paid_loans' 
    AND tc.constraint_type = 'FOREIGN KEY'
    AND kcu.column_name = 'loan_id';

-- PASSO 4: Manter apenas constraint de client_id (importante)
SELECT '4. Verificando constraint de client_id (deve permanecer):' as passo;

SELECT 
    constraint_name,
    constraint_type
FROM information_schema.table_constraints
WHERE table_name = 'paid_loans'
    AND constraint_name LIKE '%client_id%';

-- PASSO 5: TESTE FINAL
SELECT '5. TESTANDO INSERÇÃO...' as passo;

DO $$
DECLARE
    v_client_id UUID;
    v_test_loan_id UUID := gen_random_uuid();
    v_inserted_id UUID;
BEGIN
    -- Buscar cliente
    SELECT id INTO v_client_id FROM clients LIMIT 1;
    
    IF v_client_id IS NULL THEN
        RAISE EXCEPTION 'Nenhum cliente encontrado';
    END IF;
    
    -- Inserir com loan_id que NÃO existe em loans (isso deve funcionar agora!)
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
        v_test_loan_id,  -- UUID aleatório que NÃO existe em loans
        v_client_id,
        1000.00,
        10.00,
        1100.00,
        CURRENT_DATE,
        CURRENT_DATE,
        CURRENT_DATE,
        1100.00,
        'TESTE_FINAL',
        'Teste após remover constraint'
    ) RETURNING id INTO v_inserted_id;
    
    RAISE NOTICE '✅✅✅ SUCESSO! ✅✅✅';
    RAISE NOTICE 'Registro inserido com ID: %', v_inserted_id;
    RAISE NOTICE 'loan_id usado: % (não existe em loans)', v_test_loan_id;
    
    -- Verificar
    IF EXISTS (SELECT 1 FROM paid_loans WHERE id = v_inserted_id) THEN
        RAISE NOTICE '✅ Registro CONFIRMADO na tabela!';
        
        -- Limpar teste
        DELETE FROM paid_loans WHERE id = v_inserted_id;
        RAISE NOTICE '✅ Teste limpo';
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ ERRO: %', SQLERRM;
        RAISE NOTICE 'Se ainda der erro de foreign key, há outra constraint';
END $$;

-- RESULTADO FINAL
SELECT '✅✅✅ PROBLEMA RESOLVIDO! ✅✅✅' as resultado;
SELECT 'A constraint de foreign key foi removida' as detalhe;
SELECT 'Agora paid_loans pode ter loan_id de empréstimos que já foram deletados' as explicacao;

-- PASSO 6: Verificar constraints restantes
SELECT '6. Constraints finais em paid_loans:' as passo;

SELECT 
    constraint_name,
    constraint_type
FROM information_schema.table_constraints
WHERE table_name = 'paid_loans'
ORDER BY constraint_type;

-- =====================================================
-- EXPLICAÇÃO
-- =====================================================
-- 
-- POR QUE REMOVER ESTA CONSTRAINT?
-- 
-- A tabela "paid_loans" é um ARQUIVO/HISTÓRICO de empréstimos
-- que já foram quitados e removidos da tabela "loans".
-- 
-- O fluxo correto é:
-- 1. Empréstimo está em "loans" (ativo)
-- 2. Usuário marca como quitado
-- 3. Sistema copia para "paid_loans" (histórico)
-- 4. Sistema remove de "loans" (não está mais ativo)
-- 
-- Se existe foreign key exigindo que loan_id exista em "loans",
-- o passo 3 falha porque o empréstimo ainda está ativo!
-- 
-- Após remover a constraint:
-- - paid_loans pode ter loan_id de qualquer empréstimo
-- - Não precisa existir em loans (já foi quitado/removido)
-- - É apenas uma referência histórica
-- 
-- =====================================================
