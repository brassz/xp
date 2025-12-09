-- =====================================================
-- DESABILITAR RLS E CONCEDER PERMISSÕES
-- =====================================================
-- Execute este script APÓS criar a tabela
-- =====================================================

SELECT '🔧 Configurando permissões...' as status;

-- DESABILITAR RLS COMPLETAMENTE
ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;

SELECT '✅ RLS desabilitado!' as status;

-- Remover todas as políticas
DO $$ 
DECLARE
    pol RECORD;
BEGIN
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = 'paid_loans'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON paid_loans', pol.policyname);
    END LOOP;
END $$;

SELECT '✅ Políticas removidas!' as status;

-- CONCEDER TODAS AS PERMISSÕES
GRANT ALL PRIVILEGES ON TABLE paid_loans TO authenticated;
GRANT ALL PRIVILEGES ON TABLE paid_loans TO anon;
GRANT ALL PRIVILEGES ON TABLE paid_loans TO service_role;

SELECT '✅ Permissões concedidas!' as status;

-- Verificar RLS
SELECT 
    '🔍 RLS Status:' as verificacao,
    CASE 
        WHEN relrowsecurity THEN '❌ AINDA ATIVO (erro!)'
        ELSE '✅ DESABILITADO (correto!)'
    END as status
FROM pg_class WHERE relname = 'paid_loans';

-- Verificar permissões
SELECT 
    '🔍 Permissões:' as verificacao,
    COUNT(*)::text || ' permissões concedidas' as status
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans';

-- Teste final
DO $$ 
BEGIN
    PERFORM COUNT(*) FROM paid_loans;
    RAISE NOTICE '✅ TESTE SELECT: SUCESSO!';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '❌ TESTE SELECT FALHOU: %', SQLERRM;
END $$;

SELECT '
╔═══════════════════════════════════════════════════════════════╗
║              ✅ CONFIGURAÇÃO CONCLUÍDA                        ║
╚═══════════════════════════════════════════════════════════════╝

Agora:
1. FECHE o navegador completamente
2. Abra novamente
3. Faça LOGIN no sistema
4. Teste a funcionalidade

' as mensagem_final;
