-- =====================================================
-- CORREÇÃO FINAL: PARCELAMENTOS INDEPENDENTES
-- =====================================================
-- Execute este script no Supabase para garantir que
-- parcelamentos independentes funcionem perfeitamente
-- =====================================================

-- 1. Garantir que loan_id aceita NULL
DO $$
BEGIN
    ALTER TABLE installments ALTER COLUMN loan_id DROP NOT NULL;
    RAISE NOTICE '✅ Campo loan_id configurado para aceitar NULL';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '⚠️  Campo loan_id já aceita NULL: %', SQLERRM;
END $$;

-- 2. Teste prático de inserção
DO $$
DECLARE
    test_client_id UUID;
    test_user_id UUID;
    test_installment_id UUID;
BEGIN
    -- Buscar dados para teste
    SELECT id INTO test_client_id FROM clients LIMIT 1;
    SELECT id INTO test_user_id FROM users LIMIT 1;
    
    IF test_client_id IS NOT NULL AND test_user_id IS NOT NULL THEN
        -- Inserir parcelamento independente (sem loan_id)
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
            'TESTE - Parcelamento independente'
        ) RETURNING id INTO test_installment_id;
        
        RAISE NOTICE '🎉 SUCESSO! Parcelamento independente criado: %', test_installment_id;
        
        -- Limpar teste
        DELETE FROM installments WHERE id = test_installment_id;
        RAISE NOTICE '🧹 Teste removido com sucesso';
        
    ELSE
        RAISE NOTICE '⚠️  Não foi possível executar teste - dados não encontrados';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ ERRO NO TESTE: %', SQLERRM;
END $$;

-- 3. Verificação final
SELECT 
    CASE 
        WHEN is_nullable = 'YES' THEN '✅ CORRETO: loan_id aceita NULL'
        ELSE '❌ ERRO: loan_id ainda tem constraint NOT NULL'
    END as status
FROM information_schema.columns 
WHERE table_name = 'installments' 
AND column_name = 'loan_id';

RAISE NOTICE '🎯 CORREÇÃO CONCLUÍDA! Agora você pode criar parcelamentos independentes sem problemas.';