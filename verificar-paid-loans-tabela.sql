-- =====================================================
-- VERIFICAÇÃO RÁPIDA - TABELA PAID_LOANS
-- =====================================================
-- Execute este script em cada empresa para verificar
-- se a tabela paid_loans está configurada corretamente
-- =====================================================

-- Cabeçalho
SELECT '
╔═══════════════════════════════════════════════════════════════╗
║        VERIFICAÇÃO DA TABELA PAID_LOANS                       ║
╚═══════════════════════════════════════════════════════════════╝
' as diagnostico;

-- =====================================================
-- 1. VERIFICAR SE A TABELA EXISTE
-- =====================================================
SELECT 
    '1️⃣  VERIFICAÇÃO: Tabela existe?' as teste,
    CASE 
        WHEN EXISTS (
            SELECT FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name = 'paid_loans'
        )
        THEN '✅ SIM - Tabela paid_loans existe'
        ELSE '❌ NÃO - Tabela paid_loans NÃO existe (PROBLEMA!)'
    END as resultado;

-- =====================================================
-- 2. VERIFICAR COLUNAS DA TABELA (SE EXISTIR)
-- =====================================================
SELECT 
    '2️⃣  VERIFICAÇÃO: Estrutura da tabela' as teste,
    CASE 
        WHEN EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'paid_loans')
        THEN (
            SELECT CONCAT('✅ ', COUNT(*)::text, ' colunas encontradas')
            FROM information_schema.columns 
            WHERE table_name = 'paid_loans'
        )
        ELSE '⚠️  Tabela não existe para verificar colunas'
    END as resultado;

-- Listar colunas (se a tabela existir)
SELECT 
    column_name as coluna,
    data_type as tipo,
    is_nullable as permite_null
FROM information_schema.columns 
WHERE table_name = 'paid_loans'
ORDER BY ordinal_position;

-- =====================================================
-- 3. VERIFICAR RLS (ROW LEVEL SECURITY)
-- =====================================================
SELECT 
    '3️⃣  VERIFICAÇÃO: RLS ativado?' as teste,
    CASE 
        WHEN EXISTS (SELECT FROM pg_class WHERE relname = 'paid_loans')
        THEN (
            SELECT CASE WHEN relrowsecurity 
                THEN '✅ SIM - RLS está ativado' 
                ELSE '⚠️  NÃO - RLS não está ativado'
            END
            FROM pg_class
            WHERE relname = 'paid_loans'
        )
        ELSE '⚠️  Tabela não existe'
    END as resultado;

-- =====================================================
-- 4. VERIFICAR POLÍTICAS RLS
-- =====================================================
SELECT 
    '4️⃣  VERIFICAÇÃO: Políticas RLS' as teste,
    CASE 
        WHEN EXISTS (SELECT FROM pg_policies WHERE tablename = 'paid_loans')
        THEN CONCAT('✅ ', COUNT(*)::text, ' políticas configuradas')
        ELSE '⚠️  Nenhuma política RLS encontrada'
    END as resultado
FROM pg_policies 
WHERE tablename = 'paid_loans';

-- Listar políticas (se existirem)
SELECT 
    policyname as politica,
    cmd as comando,
    CASE 
        WHEN cmd = 'SELECT' THEN 'Leitura'
        WHEN cmd = 'INSERT' THEN 'Inserção'
        WHEN cmd = 'UPDATE' THEN 'Atualização'
        WHEN cmd = 'DELETE' THEN 'Exclusão'
        ELSE cmd
    END as tipo_operacao
FROM pg_policies 
WHERE tablename = 'paid_loans'
ORDER BY policyname;

-- =====================================================
-- 5. VERIFICAR ÍNDICES
-- =====================================================
SELECT 
    '5️⃣  VERIFICAÇÃO: Índices criados' as teste,
    CASE 
        WHEN EXISTS (SELECT FROM pg_indexes WHERE tablename = 'paid_loans')
        THEN CONCAT('✅ ', COUNT(*)::text, ' índices criados')
        ELSE '⚠️  Nenhum índice encontrado'
    END as resultado
FROM pg_indexes 
WHERE tablename = 'paid_loans';

-- Listar índices (se existirem)
SELECT 
    indexname as indice,
    indexdef as definicao
FROM pg_indexes 
WHERE tablename = 'paid_loans'
ORDER BY indexname;

-- =====================================================
-- 6. VERIFICAR TRIGGERS
-- =====================================================
SELECT 
    '6️⃣  VERIFICAÇÃO: Triggers' as teste,
    CASE 
        WHEN EXISTS (SELECT FROM pg_trigger WHERE tgrelid = 'paid_loans'::regclass)
        THEN CONCAT('✅ ', COUNT(*)::text, ' trigger(s) configurado(s)')
        ELSE '⚠️  Nenhum trigger encontrado'
    END as resultado
FROM pg_trigger
WHERE tgrelid = 'paid_loans'::regclass
AND tgisinternal = false;  -- Excluir triggers internos

-- =====================================================
-- 7. VERIFICAR PERMISSÕES
-- =====================================================
SELECT 
    '7️⃣  VERIFICAÇÃO: Permissões' as teste,
    CASE 
        WHEN EXISTS (
            SELECT FROM information_schema.role_table_grants 
            WHERE table_name = 'paid_loans' 
            AND grantee = 'authenticated'
        )
        THEN '✅ Permissões configuradas para authenticated'
        ELSE '⚠️  Permissões não encontradas para authenticated'
    END as resultado;

-- Listar permissões (se existirem)
SELECT 
    grantee as usuario,
    privilege_type as permissao
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans'
AND grantee IN ('authenticated', 'public', 'anon')
ORDER BY grantee, privilege_type;

-- =====================================================
-- 8. VERIFICAR REGISTROS NA TABELA
-- =====================================================
SELECT 
    '8️⃣  VERIFICAÇÃO: Registros existentes' as teste,
    CASE 
        WHEN EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'paid_loans')
        THEN (
            SELECT CONCAT('ℹ️  ', COUNT(*)::text, ' empréstimo(s) quitado(s) registrado(s)')
            FROM paid_loans
        )
        ELSE '⚠️  Tabela não existe'
    END as resultado;

-- =====================================================
-- 9. TESTE DE PERMISSÃO DE INSERÇÃO
-- =====================================================
SELECT 
    '9️⃣  VERIFICAÇÃO: Teste de inserção' as teste,
    CASE 
        WHEN EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'paid_loans')
        THEN 'ℹ️  Execute o fix para fazer teste automático'
        ELSE '❌ Tabela não existe - EXECUTE O FIX'
    END as resultado;

-- =====================================================
-- RESUMO FINAL E RECOMENDAÇÕES
-- =====================================================

DO $$ 
DECLARE
    tabela_existe BOOLEAN;
    tem_rls BOOLEAN;
    tem_politicas INTEGER;
    tem_indices INTEGER;
    tem_permissoes BOOLEAN;
BEGIN
    -- Verificar se tabela existe
    SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_name = 'paid_loans'
    ) INTO tabela_existe;
    
    IF NOT tabela_existe THEN
        RAISE NOTICE '
╔═══════════════════════════════════════════════════════════════╗
║                    ❌ PROBLEMA ENCONTRADO                     ║
╚═══════════════════════════════════════════════════════════════╝

❌ A tabela paid_loans NÃO EXISTE neste banco de dados!

📋 SINTOMAS:
   - Não consegue marcar empréstimos como quitados
   - Aba "Empréstimos Quitados" não funciona
   - Erro ao tentar salvar empréstimo quitado

🔧 SOLUÇÃO:
   1. Execute o script: fix-imperatriz-paid-loans.sql
   2. Este script irá criar a tabela e todas as configurações
   3. O script é seguro e pode ser executado múltiplas vezes
   4. Após executar, teste a funcionalidade de quitação

📁 ARQUIVO: fix-imperatriz-paid-loans.sql
📖 DOCUMENTAÇÃO: README-fix-imperatriz-quitacao.md

⚠️  PRIORIDADE: ALTA - Funcionalidade crítica não está funcionando
';
        RETURN;
    END IF;
    
    -- Se chegou aqui, a tabela existe. Verificar configurações
    SELECT relrowsecurity INTO tem_rls
    FROM pg_class WHERE relname = 'paid_loans';
    
    SELECT COUNT(*) INTO tem_politicas
    FROM pg_policies WHERE tablename = 'paid_loans';
    
    SELECT COUNT(*) INTO tem_indices
    FROM pg_indexes WHERE tablename = 'paid_loans';
    
    SELECT EXISTS (
        SELECT FROM information_schema.role_table_grants 
        WHERE table_name = 'paid_loans' 
        AND grantee = 'authenticated'
        AND privilege_type = 'INSERT'
    ) INTO tem_permissoes;
    
    RAISE NOTICE '
╔═══════════════════════════════════════════════════════════════╗
║                    ✅ TABELA EXISTE                           ║
╚═══════════════════════════════════════════════════════════════╝

✅ A tabela paid_loans existe!

📊 CONFIGURAÇÃO ATUAL:
   - RLS: %
   - Políticas: % política(s)
   - Índices: % índice(s)
   - Permissões: %

%

', 
        CASE WHEN tem_rls THEN '✅ Ativado' ELSE '⚠️  Desativado' END,
        tem_politicas,
        tem_indices,
        CASE WHEN tem_permissoes THEN '✅ Configuradas' ELSE '⚠️  Não configuradas' END,
        CASE 
            WHEN NOT tem_rls OR tem_politicas = 0 OR tem_indices = 0 OR NOT tem_permissoes THEN
                '⚠️  ATENÇÃO: Algumas configurações estão faltando.
   Recomendamos executar o script fix-imperatriz-paid-loans.sql
   para garantir que tudo está configurado corretamente.'
            ELSE
                '✅ Todas as configurações parecem estar OK!
   Se ainda houver problemas, execute fix-imperatriz-paid-loans.sql
   para reconfigurar completamente.'
        END;
    
END $$;

-- Mensagem final
SELECT '
╔═══════════════════════════════════════════════════════════════╗
║              VERIFICAÇÃO CONCLUÍDA                            ║
╚═══════════════════════════════════════════════════════════════╝

📋 Verifique os resultados acima.

🔧 Se houver algum problema (❌ ou ⚠️), execute:
   -> fix-imperatriz-paid-loans.sql

📖 Para mais informações, veja:
   -> README-fix-imperatriz-quitacao.md
   -> ANALISE-PROBLEMA-PAID-LOANS.md

' as mensagem_final;
