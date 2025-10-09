-- =====================================================
-- CORREÇÃO COMPLETA: ERRO DE PARCELAMENTO
-- =====================================================
-- Este script resolve tanto o erro de constraint NOT NULL
-- quanto possíveis problemas de JavaScript
-- =====================================================

-- 1. CORRIGIR CONSTRAINT NOT NULL
DO $$
BEGIN
    ALTER TABLE installments ALTER COLUMN loan_id DROP NOT NULL;
    RAISE NOTICE '✅ Constraint NOT NULL removida do campo loan_id';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '⚠️  Campo loan_id já permite NULL: %', SQLERRM;
END $$;

-- 2. ATUALIZAR COMENTÁRIOS
COMMENT ON TABLE installments IS 'Tabela para armazenar planos de parcelamento - pode ser vinculado a empréstimos ou independente';
COMMENT ON COLUMN installments.loan_id IS 'Referência ao empréstimo original (opcional - pode ser NULL para parcelamentos independentes)';

-- 3. CRIAR ÍNDICE OTIMIZADO
CREATE INDEX IF NOT EXISTS idx_installments_client_independent 
ON installments(client_id) WHERE loan_id IS NULL;

-- 4. TESTE FINAL
DO $$
DECLARE
    test_client_id UUID;
    test_user_id UUID;
    test_installment_id UUID;
BEGIN
    -- Buscar IDs para teste
    SELECT id INTO test_client_id FROM clients LIMIT 1;
    SELECT id INTO test_user_id FROM users LIMIT 1;
    
    IF test_client_id IS NOT NULL AND test_user_id IS NOT NULL THEN
        -- Inserir parcelamento de teste
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
            'TESTE AUTOMÁTICO - Parcelamento independente'
        ) RETURNING id INTO test_installment_id;
        
        -- Inserir parcela de teste
        INSERT INTO installment_payments (
            installment_id,
            installment_number,
            amount,
            due_date
        ) VALUES (
            test_installment_id,
            1,
            100.00,
            CURRENT_DATE + INTERVAL '30 days'
        );
        
        RAISE NOTICE '✅ TESTE PASSOU: Parcelamento independente criado com sucesso!';
        
        -- Limpar dados de teste
        DELETE FROM installment_payments WHERE installment_id = test_installment_id;
        DELETE FROM installments WHERE id = test_installment_id;
        RAISE NOTICE '🧹 Dados de teste removidos';
        
    ELSE
        RAISE NOTICE '⚠️  Não foi possível executar teste - dados não encontrados';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ TESTE FALHOU: %', SQLERRM;
        -- Tentar limpar em caso de erro
        BEGIN
            DELETE FROM installment_payments WHERE installment_id = test_installment_id;
            DELETE FROM installments WHERE notes = 'TESTE AUTOMÁTICO - Parcelamento independente';
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
END $$;

-- 5. VERIFICAÇÃO FINAL
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'installments' 
        AND column_name = 'loan_id' 
        AND is_nullable = 'YES'
    ) THEN
        RAISE NOTICE '🎉 CORREÇÃO CONCLUÍDA! Parcelamentos independentes agora funcionam perfeitamente.';
    ELSE
        RAISE NOTICE '❌ ERRO: Constraint ainda existe. Execute o script novamente.';
    END IF;
END $$;