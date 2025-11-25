-- =====================================================
-- CORREÇÃO RÁPIDA - Erro de Sequence
-- =====================================================
-- Se você recebeu o erro:
-- "ERROR: 42P01: relation "paid_loans_id_seq" does not exist"
--
-- Execute este script OU execute o fix-litoral-paid-loans.sql corrigido
-- =====================================================

-- Este erro aconteceu porque o script antigo tentava dar permissão
-- em uma sequence que não existe. A tabela paid_loans usa UUID
-- (gen_random_uuid()) ao invés de SERIAL, então não há sequence.

-- SOLUÇÃO: Execute apenas estas linhas para conceder as permissões corretas

-- Conceder permissões para usuários autenticados
GRANT SELECT, INSERT, UPDATE, DELETE ON paid_loans TO authenticated;

-- Conceder permissões para a view (se já foi criada)
GRANT SELECT ON paid_loans_with_details TO authenticated;

-- Verificar se as permissões foram concedidas
SELECT 
    '✅ Permissões concedidas com sucesso!' as status,
    grantee,
    privilege_type
FROM information_schema.role_table_grants
WHERE table_name = 'paid_loans'
ORDER BY grantee, privilege_type;

-- Mensagem final
DO $$ 
BEGIN
    RAISE NOTICE '==============================================';
    RAISE NOTICE '✅ CORREÇÃO APLICADA COM SUCESSO!';
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'As permissões foram concedidas corretamente.';
    RAISE NOTICE 'A funcionalidade de quitação já deve funcionar.';
    RAISE NOTICE '==============================================';
END $$;
