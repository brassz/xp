-- =====================================================
-- CORREÇÃO COMPLETA: ERRO loan_id NULL EM INSTALLMENTS
-- =====================================================
-- Execute este script no SQL Editor do Supabase para
-- corrigir o erro: null value in column "loan_id" violates not-null constraint
-- =====================================================

-- 1. Remover a constraint NOT NULL do campo loan_id
DO $$
BEGIN
    ALTER TABLE installments ALTER COLUMN loan_id DROP NOT NULL;
    RAISE NOTICE '✅ Constraint NOT NULL removida do campo loan_id';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '⚠️  Campo loan_id já permite NULL ou erro: %', SQLERRM;
END $$;

-- 2. Atualizar comentários para documentar a mudança
COMMENT ON TABLE installments IS 'Tabela para armazenar planos de parcelamento - pode ser vinculado a empréstimos ou independente';
COMMENT ON COLUMN installments.loan_id IS 'Referência ao empréstimo original (opcional - pode ser NULL para parcelamentos independentes)';

-- 3. Criar índice otimizado para consultas de parcelamentos independentes
CREATE INDEX IF NOT EXISTS idx_installments_client_independent 
ON installments(client_id) WHERE loan_id IS NULL;

-- 4. Verificar se a correção funcionou
DO $$
DECLARE
    constraint_exists BOOLEAN;
BEGIN
    -- Verificar se ainda existe constraint NOT NULL
    SELECT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'installments' 
        AND column_name = 'loan_id' 
        AND is_nullable = 'NO'
    ) INTO constraint_exists;
    
    IF constraint_exists THEN
        RAISE NOTICE '❌ ERRO: Constraint NOT NULL ainda existe no campo loan_id';
    ELSE
        RAISE NOTICE '✅ SUCESSO: Campo loan_id agora permite valores NULL';
    END IF;
END $$;

-- 5. Teste: Tentar inserir um parcelamento sem loan_id
DO $$
DECLARE
    test_client_id UUID;
    test_user_id UUID;
BEGIN
    -- Buscar um cliente existente para teste
    SELECT id INTO test_client_id FROM clients LIMIT 1;
    
    -- Buscar um usuário existente para teste
    SELECT id INTO test_user_id FROM users LIMIT 1;
    
    IF test_client_id IS NOT NULL AND test_user_id IS NOT NULL THEN
        -- Tentar inserir parcelamento de teste
        INSERT INTO installments (
            client_id,
            total_amount,
            total_installments,
            installment_amount,
            first_due_date,
            created_by,
            notes
        ) VALUES (
            test_client_id,
            1000.00,
            10,
            100.00,
            CURRENT_DATE + INTERVAL '30 days',
            test_user_id,
            'TESTE - Parcelamento independente criado pelo script de correção'
        );
        
        RAISE NOTICE '✅ TESTE PASSOU: Parcelamento independente criado com sucesso!';
        
        -- Remover o registro de teste
        DELETE FROM installments WHERE notes = 'TESTE - Parcelamento independente criado pelo script de correção';
        RAISE NOTICE '🧹 Registro de teste removido';
    ELSE
        RAISE NOTICE '⚠️  Não foi possível executar teste - clientes ou usuários não encontrados';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ TESTE FALHOU: %', SQLERRM;
END $$;

-- =====================================================
-- RESULTADO ESPERADO
-- =====================================================
-- ✅ Constraint NOT NULL removida do campo loan_id
-- ✅ SUCESSO: Campo loan_id agora permite valores NULL  
-- ✅ TESTE PASSOU: Parcelamento independente criado com sucesso!
-- 🧹 Registro de teste removido
-- =====================================================

RAISE NOTICE '🎉 CORREÇÃO CONCLUÍDA! Agora você pode criar parcelamentos independentes sem erro de loan_id NULL.';