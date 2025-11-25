-- =====================================================
-- VERIFICAÇÃO RÁPIDA: Setup da Tabela paid_loans
-- =====================================================
-- Execute este script para diagnosticar problemas
-- =====================================================

-- ==========================================
-- VERIFICAÇÃO DA TABELA PAID_LOANS
-- ==========================================

-- 1. Verificar se a tabela existe
SELECT '1. VERIFICANDO SE A TABELA EXISTE...' as etapa;

SELECT 
    CASE 
        WHEN EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'paid_loans') 
        THEN '✅ Tabela paid_loans EXISTE'
        ELSE '❌ Tabela paid_loans NÃO EXISTE - Execute setup-paid-loans.sql'
    END as status;

-- 2. Verificar estrutura da tabela
SELECT '2. ESTRUTURA DA TABELA:' as etapa;
SELECT 
    column_name as "Coluna",
    data_type as "Tipo",
    is_nullable as "Permite NULL",
    column_default as "Valor Padrão"
FROM information_schema.columns
WHERE table_name = 'paid_loans'
ORDER BY ordinal_position;

-- 3. Verificar RLS (Row Level Security)
SELECT '3. STATUS DO RLS:' as etapa;

SELECT 
    schemaname as "Schema",
    tablename as "Tabela",
    CASE 
        WHEN rowsecurity = true THEN '🔒 RLS ATIVADO'
        ELSE '🔓 RLS DESATIVADO'
    END as "Status RLS"
FROM pg_tables
WHERE tablename = 'paid_loans';

-- 4. Verificar políticas RLS
SELECT '4. POLÍTICAS RLS ATIVAS:' as etapa;

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

-- 5. Verificar permissões
SELECT '5. PERMISSÕES CONCEDIDAS:' as etapa;

SELECT 
    grantee as "Usuário/Role",
    privilege_type as "Permissão"
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans'
ORDER BY grantee, privilege_type;

-- 6. Verificar índices
SELECT '6. ÍNDICES CRIADOS:' as etapa;

SELECT 
    indexname as "Nome do Índice",
    indexdef as "Definição"
FROM pg_indexes 
WHERE tablename = 'paid_loans'
ORDER BY indexname;

-- 7. Contar registros existentes
SELECT '7. REGISTROS NA TABELA:' as etapa;

SELECT 
    COUNT(*) as "Total de Empréstimos Quitados",
    COALESCE(MIN(paid_date)::text, 'N/A') as "Primeira Quitação",
    COALESCE(MAX(paid_date)::text, 'N/A') as "Última Quitação"
FROM paid_loans;

-- 8. Verificar últimos 5 registros
SELECT '8. ÚLTIMOS 5 EMPRÉSTIMOS QUITADOS:' as etapa;

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

-- 9. Verificar foreign keys
SELECT '9. RELACIONAMENTOS (FOREIGN KEYS):' as etapa;

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

-- 10. Verificar triggers
SELECT '10. TRIGGERS CONFIGURADOS:' as etapa;

SELECT 
    trigger_name as "Nome do Trigger",
    event_manipulation as "Evento",
    action_statement as "Ação"
FROM information_schema.triggers
WHERE event_object_table = 'paid_loans'
ORDER BY trigger_name;

-- ==========================================
-- DIAGNÓSTICO COMPLETO
-- ==========================================

SELECT 'DIAGNÓSTICO FINAL:' as etapa;

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

-- ==========================================
-- PRÓXIMOS PASSOS
-- ==========================================
-- Se encontrou problemas:
-- 1. Execute: fix-paid-loans-issue.sql
-- 2. Teste marcar um empréstimo como quitado
-- 3. Abra o console do navegador (F12) para ver logs detalhados
-- 
-- Se tudo está OK mas ainda não funciona:
-- 1. Abra o console do navegador (F12)
-- 2. Marque um empréstimo como quitado
-- 3. Procure por erros em vermelho
-- 4. Compartilhe os logs do console
-- ==========================================
