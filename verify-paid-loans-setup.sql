-- =====================================================
-- VERIFICAÇÃO RÁPIDA: Setup da Tabela paid_loans
-- =====================================================
-- Execute este script para diagnosticar problemas
-- =====================================================

\echo '=========================================='
\echo 'VERIFICAÇÃO DA TABELA PAID_LOANS'
\echo '=========================================='
\echo ''

-- 1. Verificar se a tabela existe
\echo '1. Verificando se a tabela existe...'
SELECT 
    CASE 
        WHEN EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'paid_loans') 
        THEN '✅ Tabela paid_loans EXISTE'
        ELSE '❌ Tabela paid_loans NÃO EXISTE - Execute setup-paid-loans.sql'
    END as status;

\echo ''

-- 2. Verificar estrutura da tabela
\echo '2. Estrutura da tabela:'
SELECT 
    column_name as "Coluna",
    data_type as "Tipo",
    is_nullable as "Permite NULL",
    column_default as "Valor Padrão"
FROM information_schema.columns
WHERE table_name = 'paid_loans'
ORDER BY ordinal_position;

\echo ''

-- 3. Verificar RLS (Row Level Security)
\echo '3. Status do RLS:'
SELECT 
    schemaname as "Schema",
    tablename as "Tabela",
    CASE 
        WHEN rowsecurity = true THEN '🔒 RLS ATIVADO'
        ELSE '🔓 RLS DESATIVADO'
    END as "Status RLS"
FROM pg_tables
WHERE tablename = 'paid_loans';

\echo ''

-- 4. Verificar políticas RLS
\echo '4. Políticas RLS ativas:'
SELECT 
    policyname as "Nome da Política",
    cmd as "Comando",
    CASE 
        WHEN permissive = 't' THEN 'Permissivo'
        ELSE 'Restritivo'
    END as "Tipo",
    roles as "Roles"
FROM pg_policies 
WHERE tablename = 'paid_loans'
ORDER BY cmd;

\echo ''

-- 5. Verificar permissões
\echo '5. Permissões concedidas:'
SELECT 
    grantee as "Usuário/Role",
    privilege_type as "Permissão"
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans'
ORDER BY grantee, privilege_type;

\echo ''

-- 6. Verificar índices
\echo '6. Índices criados:'
SELECT 
    indexname as "Nome do Índice",
    indexdef as "Definição"
FROM pg_indexes 
WHERE tablename = 'paid_loans'
ORDER BY indexname;

\echo ''

-- 7. Contar registros existentes
\echo '7. Registros na tabela:'
SELECT 
    COUNT(*) as "Total de Empréstimos Quitados",
    COALESCE(MIN(paid_date)::text, 'N/A') as "Primeira Quitação",
    COALESCE(MAX(paid_date)::text, 'N/A') as "Última Quitação"
FROM paid_loans;

\echo ''

-- 8. Verificar últimos 5 registros
\echo '8. Últimos 5 empréstimos quitados:'
SELECT 
    id,
    loan_id,
    original_amount as "Valor",
    interest_rate as "Juros %",
    paid_date as "Data Quitação",
    created_at as "Criado em"
FROM paid_loans
ORDER BY created_at DESC
LIMIT 5;

\echo ''

-- 9. Verificar foreign keys
\echo '9. Relacionamentos (Foreign Keys):'
SELECT 
    tc.constraint_name as "Nome da Constraint",
    kcu.column_name as "Coluna",
    ccu.table_name as "Tabela Referenciada",
    ccu.column_name as "Coluna Referenciada"
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_name = 'paid_loans' 
    AND tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.constraint_name;

\echo ''

-- 10. Verificar triggers
\echo '10. Triggers configurados:'
SELECT 
    trigger_name as "Nome do Trigger",
    event_manipulation as "Evento",
    action_statement as "Ação"
FROM information_schema.triggers
WHERE event_object_table = 'paid_loans'
ORDER BY trigger_name;

\echo ''
\echo '=========================================='
\echo 'DIAGNÓSTICO COMPLETO'
\echo '=========================================='

-- Diagnóstico resumido
SELECT 
    CASE 
        WHEN NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'paid_loans')
        THEN '❌ CRÍTICO: Tabela não existe'
        
        WHEN NOT EXISTS (SELECT FROM pg_policies WHERE tablename = 'paid_loans')
        THEN '⚠️  AVISO: Nenhuma política RLS configurada'
        
        WHEN NOT EXISTS (
            SELECT FROM information_schema.role_table_grants 
            WHERE table_name = 'paid_loans' 
            AND grantee = 'authenticated' 
            AND privilege_type = 'INSERT'
        )
        THEN '❌ PROBLEMA: Role "authenticated" não tem permissão de INSERT'
        
        ELSE '✅ SETUP PARECE OK - Se ainda há problemas, verifique o console do navegador'
    END as "Diagnóstico Final";

\echo ''
\echo '=========================================='
\echo 'PRÓXIMOS PASSOS'
\echo '=========================================='
\echo ''
\echo 'Se encontrou problemas:'
\echo '1. Execute: fix-paid-loans-issue.sql'
\echo '2. Teste marcar um empréstimo como quitado'
\echo '3. Abra o console do navegador (F12) para ver logs detalhados'
\echo ''
\echo 'Se tudo está OK mas ainda não funciona:'
\echo '1. Abra o console do navegador (F12)'
\echo '2. Marque um empréstimo como quitado'
\echo '3. Procure por erros em vermelho'
\echo '4. Compartilhe os logs do console'
\echo ''
