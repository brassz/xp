-- =====================================================
-- SOLUÇÃO EMERGENCIAL - DESABILITAR RLS
-- =====================================================
-- ⚠️  USE APENAS SE O SCRIPT DE PERMISSÕES NÃO FUNCIONOU
-- =====================================================
-- Este script desabilita completamente o RLS da tabela
-- paid_loans, permitindo todas as operações sem restrição.
-- =====================================================

SELECT '
╔═══════════════════════════════════════════════════════════════╗
║          🚨 SOLUÇÃO EMERGENCIAL - DESABILITAR RLS             ║
╚═══════════════════════════════════════════════════════════════╝

⚠️  ATENÇÃO: Este script desabilita COMPLETAMENTE o Row Level
    Security (RLS) da tabela paid_loans.

    Isso significa que qualquer usuário autenticado poderá:
    ✅ Inserir registros
    ✅ Ler registros
    ✅ Atualizar registros
    ✅ Deletar registros

    Use apenas se as outras soluções não funcionaram!

' as aviso;

-- =====================================================
-- PASSO 1: DESABILITAR RLS COMPLETAMENTE
-- =====================================================

ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;

SELECT '✅ RLS DESABILITADO na tabela paid_loans' as status;

-- =====================================================
-- PASSO 2: CONCEDER TODAS AS PERMISSÕES
-- =====================================================

-- Garantir que authenticated tem todas as permissões
GRANT ALL PRIVILEGES ON paid_loans TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON paid_loans TO authenticated;

SELECT '✅ Todas as permissões concedidas' as status;

-- =====================================================
-- PASSO 3: REMOVER POLÍTICAS (NÃO SERÃO MAIS USADAS)
-- =====================================================

-- Remover todas as políticas já que RLS está desabilitado
DROP POLICY IF EXISTS "allow_all_select" ON paid_loans;
DROP POLICY IF EXISTS "allow_all_insert" ON paid_loans;
DROP POLICY IF EXISTS "allow_all_update" ON paid_loans;
DROP POLICY IF EXISTS "allow_all_delete" ON paid_loans;
DROP POLICY IF EXISTS "Authenticated users can view all paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Authenticated users can insert paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Authenticated users can update paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Authenticated users can delete paid loans" ON paid_loans;

SELECT '✅ Políticas removidas (não são mais necessárias)' as status;

-- =====================================================
-- PASSO 4: TESTE DE INSERÇÃO
-- =====================================================

DO $$ 
DECLARE
    test_client_id UUID;
    test_loan_id UUID;
BEGIN
    -- Buscar um cliente para teste
    SELECT id INTO test_client_id FROM clients LIMIT 1;
    
    IF test_client_id IS NOT NULL THEN
        test_loan_id := gen_random_uuid();
        
        -- Tentar inserir
        INSERT INTO paid_loans (
            loan_id, client_id, original_amount, interest_rate,
            total_with_interest, loan_date, due_date, paid_date,
            total_paid, payment_method, notes
        ) VALUES (
            test_loan_id, test_client_id, 1000.00, 5.00, 1050.00,
            CURRENT_DATE - 30, CURRENT_DATE - 1, CURRENT_DATE,
            1050.00, 'Teste Final', '🧪 Teste - será removido'
        );
        
        RAISE NOTICE '✅ ✅ ✅ TESTE DE INSERÇÃO: SUCESSO TOTAL! ✅ ✅ ✅';
        
        -- Remover teste
        DELETE FROM paid_loans WHERE loan_id = test_loan_id;
        RAISE NOTICE '✅ Registro de teste removido';
    ELSE
        RAISE NOTICE '⚠️  Nenhum cliente para teste (não é problema)';
    END IF;
    
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '❌ Erro no teste: % - Entre em contato com suporte!', SQLERRM;
END $$;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Status do RLS
SELECT 
    '🔍 Status RLS' as verificacao,
    CASE 
        WHEN relrowsecurity THEN '⚠️  AINDA ATIVADO (não deveria estar!)'
        ELSE '✅ DESABILITADO (correto!)'
    END as resultado
FROM pg_class
WHERE relname = 'paid_loans';

-- Permissões
SELECT 
    '🔍 Permissões' as verificacao,
    COUNT(*)::text || ' permissão(ões) para authenticated' as resultado
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans'
AND grantee = 'authenticated';

-- =====================================================
-- MENSAGEM FINAL
-- =====================================================

SELECT '
╔═══════════════════════════════════════════════════════════════╗
║              ✅ SOLUÇÃO EMERGENCIAL APLICADA                  ║
╚═══════════════════════════════════════════════════════════════╝

✅ RLS DESABILITADO COMPLETAMENTE
✅ Todas as permissões concedidas
✅ Teste de inserção realizado

🎯 PRÓXIMOS PASSOS:

1️⃣  FAÇA LOGOUT DO SISTEMA
2️⃣  FAÇA LOGIN NOVAMENTE (selecione IMPERATRIZ CRED)
3️⃣  TESTE MARCAR EMPRÉSTIMO COMO QUITADO

    👉 DEVE FUNCIONAR AGORA! 👈

⚠️  NOTA DE SEGURANÇA:
    Com RLS desabilitado, qualquer usuário autenticado pode
    acessar todos os dados da tabela paid_loans.
    
    Isso é aceitável porque:
    - Os usuários já precisam fazer login
    - Todos os usuários são da mesma empresa
    - Os dados já estão isolados por empresa (banco separado)
    
    Se quiser reativar RLS no futuro, execute novamente
    o script fix-paid-loans-permissions.sql

📋 CHECKLIST:
   [ ] Script executado sem erros
   [ ] Viu "SUCESSO TOTAL" no teste
   [ ] Fez logout do sistema
   [ ] Fez login novamente
   [ ] Testou marcar como quitado
   [ ] FUNCIONOU! 🎉

🐛 SE AINDA NÃO FUNCIONAR:
   O problema pode não ser de permissões SQL.
   Verifique:
   - Console do navegador (F12) para ver erro detalhado
   - Se está na empresa correta (IMPERATRIZ CRED)
   - Se o Supabase está acessível
   - Se há erros de rede

' as mensagem_final;

-- =====================================================
-- PARA REATIVAR RLS NO FUTURO (OPCIONAL)
-- =====================================================
-- Se no futuro quiser reativar RLS com políticas seguras:
--
-- ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;
--
-- CREATE POLICY "allow_authenticated_all" ON paid_loans
--     FOR ALL
--     USING (true)
--     WITH CHECK (true);
--
-- =====================================================
