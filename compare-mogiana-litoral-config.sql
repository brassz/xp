-- =====================================================
-- COMPARAÇÃO: MOGIANA vs LITORAL
-- =====================================================
-- Script para identificar diferenças entre as configurações
-- das empresas MOGIANA (funcionando) e LITORAL (não funcionando)
-- =====================================================

-- =====================================================
-- 1. INFORMAÇÕES BÁSICAS DO SISTEMA
-- =====================================================

SELECT 'INFORMAÇÕES DO SISTEMA' as categoria;

SELECT 
    'DATABASE_INFO' as tipo,
    current_database() as nome_database,
    current_user as usuario_atual,
    inet_server_addr() as endereco_servidor,
    version() as versao_postgresql;

-- =====================================================
-- 2. VERIFICAÇÃO DE TABELAS E ESTRUTURA
-- =====================================================

SELECT 'VERIFICAÇÃO DE TABELAS' as categoria;

-- Listar todas as tabelas principais
SELECT 
    'TABELAS_PRINCIPAIS' as tipo,
    table_name,
    CASE 
        WHEN table_name = 'loans' THEN '🏦 EMPRÉSTIMOS'
        WHEN table_name = 'payments' THEN '💰 PAGAMENTOS'
        WHEN table_name = 'clients' THEN '👥 CLIENTES'
        WHEN table_name = 'users' THEN '👤 USUÁRIOS'
        WHEN table_name LIKE '%_loans' THEN '📊 STATUS EMPRÉSTIMOS'
        ELSE '📋 AUXILIAR'
    END as categoria_tabela
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
  AND table_name IN (
    'loans', 'payments', 'clients', 'users',
    'overdue_loans', 'partial_paid_loans', 'paid_loans', 'cancelled_loans',
    'installments', 'installment_payments', 'guarantors', 'emergency_contacts'
  )
ORDER BY table_name;

-- Verificar estrutura específica da tabela loans
SELECT 'ESTRUTURA TABELA LOANS' as categoria;

SELECT 
    'CAMPOS_LOANS' as tipo,
    column_name,
    data_type,
    is_nullable,
    column_default,
    CASE 
        WHEN column_name = 'original_amount' THEN '🎯 CAMPO CRÍTICO'
        WHEN column_name IN ('amount', 'interest_rate', 'status') THEN '⭐ ESSENCIAL'
        ELSE '📝 NORMAL'
    END as importancia
FROM information_schema.columns 
WHERE table_name = 'loans'
ORDER BY ordinal_position;

-- =====================================================
-- 3. VERIFICAÇÃO DE TRIGGERS
-- =====================================================

SELECT 'VERIFICAÇÃO DE TRIGGERS' as categoria;

SELECT 
    'TRIGGERS_LOANS' as tipo,
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement,
    CASE 
        WHEN trigger_name LIKE '%overdue%' THEN '📅 VENCIDOS'
        WHEN trigger_name LIKE '%partial%' THEN '💸 PARCIAIS'
        WHEN trigger_name LIKE '%paid%' THEN '✅ QUITADOS'
        WHEN trigger_name LIKE '%update%' THEN '🔄 ATUALIZAÇÃO'
        ELSE '❓ OUTRO'
    END as tipo_trigger
FROM information_schema.triggers 
WHERE event_object_table = 'loans'
ORDER BY trigger_name;

-- =====================================================
-- 4. ANÁLISE DOS DADOS
-- =====================================================

SELECT 'ANÁLISE DOS DADOS' as categoria;

-- Estatísticas gerais
SELECT 
    'ESTATÍSTICAS_GERAIS' as tipo,
    COUNT(*) as total_emprestimos,
    COUNT(CASE WHEN amount > 0 THEN 1 END) as com_valor_amount,
    COUNT(CASE WHEN original_amount IS NOT NULL THEN 1 END) as com_original_amount,
    COUNT(CASE WHEN original_amount > 0 THEN 1 END) as original_amount_positivo,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as ativos,
    COUNT(CASE WHEN status = 'overdue' THEN 1 END) as vencidos,
    COUNT(CASE WHEN status = 'partial_paid' THEN 1 END) as parciais,
    COUNT(CASE WHEN status = 'paid' THEN 1 END) as quitados
FROM loans;

-- Problemas específicos
SELECT 
    'PROBLEMAS_IDENTIFICADOS' as tipo,
    COUNT(CASE WHEN amount = 0 THEN 1 END) as amount_zero,
    COUNT(CASE WHEN original_amount IS NULL THEN 1 END) as original_amount_null,
    COUNT(CASE WHEN original_amount = 0 THEN 1 END) as original_amount_zero,
    COUNT(CASE WHEN amount != original_amount THEN 1 END) as valores_diferentes,
    COUNT(CASE WHEN amount = 0 AND status IN ('active', 'overdue', 'partial_paid') THEN 1 END) as ativos_sem_valor
FROM loans;

-- =====================================================
-- 5. VERIFICAÇÃO DE TABELAS DE STATUS
-- =====================================================

SELECT 'TABELAS DE STATUS' as categoria;

-- Overdue loans
SELECT 
    'OVERDUE_LOANS' as tipo,
    COUNT(*) as total_registros,
    COUNT(CASE WHEN remaining_amount > 0 THEN 1 END) as com_valor_restante,
    COUNT(CASE WHEN remaining_amount = 0 THEN 1 END) as sem_valor_restante,
    COUNT(CASE WHEN original_amount > 0 THEN 1 END) as com_valor_original,
    AVG(remaining_amount) as media_valor_restante
FROM overdue_loans;

-- Partial paid loans
SELECT 
    'PARTIAL_PAID_LOANS' as tipo,
    COUNT(*) as total_registros,
    COUNT(CASE WHEN remaining_amount > 0 THEN 1 END) as com_valor_restante,
    COUNT(CASE WHEN remaining_amount = 0 THEN 1 END) as sem_valor_restante,
    COUNT(CASE WHEN original_amount > 0 THEN 1 END) as com_valor_original,
    AVG(remaining_amount) as media_valor_restante
FROM partial_paid_loans;

-- =====================================================
-- 6. VERIFICAÇÃO DE POLÍTICAS RLS
-- =====================================================

SELECT 'POLÍTICAS DE SEGURANÇA (RLS)' as categoria;

SELECT 
    'RLS_STATUS' as tipo,
    schemaname,
    tablename,
    rowsecurity as rls_habilitado,
    CASE 
        WHEN rowsecurity THEN '🔒 RLS ATIVO'
        ELSE '🔓 RLS INATIVO'
    END as status_rls
FROM pg_tables 
WHERE schemaname = 'public' 
  AND tablename IN ('loans', 'payments', 'overdue_loans', 'partial_paid_loans')
ORDER BY tablename;

-- =====================================================
-- 7. VERIFICAÇÃO DE FUNÇÕES
-- =====================================================

SELECT 'FUNÇÕES DO SISTEMA' as categoria;

SELECT 
    'FUNCOES_PERSONALIZADAS' as tipo,
    routine_name,
    routine_type,
    CASE 
        WHEN routine_name LIKE '%loan%' THEN '🏦 EMPRÉSTIMOS'
        WHEN routine_name LIKE '%payment%' THEN '💰 PAGAMENTOS'
        WHEN routine_name LIKE '%overdue%' THEN '📅 VENCIDOS'
        WHEN routine_name LIKE '%update%' THEN '🔄 ATUALIZAÇÃO'
        ELSE '❓ OUTRO'
    END as categoria_funcao
FROM information_schema.routines 
WHERE routine_schema = 'public'
  AND routine_name LIKE '%loan%'
ORDER BY routine_name;

-- =====================================================
-- 8. TESTE DE INTEGRIDADE DOS DADOS
-- =====================================================

SELECT 'TESTE DE INTEGRIDADE' as categoria;

-- Empréstimos órfãos (sem cliente)
SELECT 
    'EMPRESTIMOS_ORFAOS' as tipo,
    COUNT(*) as total_orfaos
FROM loans l
LEFT JOIN clients c ON l.client_id = c.id
WHERE c.id IS NULL;

-- Pagamentos órfãos (sem empréstimo)
SELECT 
    'PAGAMENTOS_ORFAOS' as tipo,
    COUNT(*) as total_orfaos
FROM payments p
LEFT JOIN loans l ON p.loan_id = l.id
WHERE l.id IS NULL;

-- Inconsistências nas tabelas de status
SELECT 
    'INCONSISTENCIAS_STATUS' as tipo,
    (SELECT COUNT(*) FROM overdue_loans ol LEFT JOIN loans l ON ol.loan_id = l.id WHERE l.id IS NULL) as overdue_orfaos,
    (SELECT COUNT(*) FROM partial_paid_loans ppl LEFT JOIN loans l ON ppl.loan_id = l.id WHERE l.id IS NULL) as partial_orfaos;

-- =====================================================
-- 9. AMOSTRA DE DADOS PROBLEMÁTICOS
-- =====================================================

SELECT 'AMOSTRA DE DADOS PROBLEMÁTICOS' as categoria;

-- Mostrar alguns empréstimos problemáticos
SELECT 
    'EMPRESTIMOS_PROBLEMATICOS' as tipo,
    l.id,
    c.name as cliente,
    l.amount,
    l.original_amount,
    l.interest_rate,
    l.status,
    l.created_at,
    CASE 
        WHEN l.amount = 0 AND l.original_amount IS NULL THEN 'SEM VALORES'
        WHEN l.amount = 0 THEN 'VALOR ATUAL ZERO'
        WHEN l.original_amount IS NULL THEN 'SEM VALOR ORIGINAL'
        WHEN l.original_amount = 0 THEN 'VALOR ORIGINAL ZERO'
        ELSE 'OUTRO PROBLEMA'
    END as tipo_problema
FROM loans l
LEFT JOIN clients c ON l.client_id = c.id
WHERE l.status IN ('active', 'overdue', 'partial_paid')
  AND (l.amount = 0 OR l.original_amount IS NULL OR l.original_amount = 0)
ORDER BY l.created_at DESC
LIMIT 5;

-- =====================================================
-- 10. RELATÓRIO FINAL DE COMPARAÇÃO
-- =====================================================

DO $$
DECLARE
    total_emprestimos INTEGER;
    problemas_criticos INTEGER;
    tabelas_status_ok BOOLEAN;
    triggers_ok BOOLEAN;
BEGIN
    -- Contar estatísticas
    SELECT COUNT(*) INTO total_emprestimos FROM loans;
    
    SELECT COUNT(*) INTO problemas_criticos
    FROM loans 
    WHERE status IN ('active', 'overdue', 'partial_paid')
      AND (amount = 0 OR original_amount IS NULL OR original_amount = 0);
    
    -- Verificar tabelas de status
    SELECT (
        (SELECT COUNT(*) FROM overdue_loans WHERE remaining_amount > 0) > 0 OR
        (SELECT COUNT(*) FROM partial_paid_loans WHERE remaining_amount > 0) > 0
    ) INTO tabelas_status_ok;
    
    -- Verificar triggers
    SELECT COUNT(*) > 0 INTO triggers_ok
    FROM information_schema.triggers 
    WHERE event_object_table = 'loans';
    
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'RELATÓRIO DE COMPARAÇÃO - CONCLUÍDO';
    RAISE NOTICE '==========================================';
    RAISE NOTICE '';
    RAISE NOTICE '📊 ESTATÍSTICAS:';
    RAISE NOTICE '• Total de empréstimos: %', total_emprestimos;
    RAISE NOTICE '• Problemas críticos: %', problemas_criticos;
    RAISE NOTICE '• Tabelas de status: %', CASE WHEN tabelas_status_ok THEN 'OK' ELSE 'PROBLEMA' END;
    RAISE NOTICE '• Triggers: %', CASE WHEN triggers_ok THEN 'OK' ELSE 'PROBLEMA' END;
    RAISE NOTICE '';
    
    IF problemas_criticos = 0 THEN
        RAISE NOTICE '✅ EMPRESA ESTÁ FUNCIONANDO CORRETAMENTE';
        RAISE NOTICE '📋 Esta configuração pode ser usada como referência';
    ELSE
        RAISE NOTICE '❌ EMPRESA TEM PROBLEMAS CRÍTICOS';
        RAISE NOTICE '🔧 Execute o script fix-litoral-specific-issues.sql';
    END IF;
    
    RAISE NOTICE '';
    RAISE NOTICE '📋 PARA COMPARAR COM OUTRA EMPRESA:';
    RAISE NOTICE '1. Execute este script na MOGIANA';
    RAISE NOTICE '2. Execute este script na LITORAL';
    RAISE NOTICE '3. Compare os resultados';
    RAISE NOTICE '4. Identifique as diferenças';
    RAISE NOTICE '';
    RAISE NOTICE '==========================================';
END $$;

-- =====================================================
-- INSTRUÇÕES DE USO PARA COMPARAÇÃO
-- =====================================================
/*
COMO USAR ESTE SCRIPT PARA COMPARAÇÃO:

1. EXECUTAR NA MOGIANA (que está funcionando):
   - Acesse: https://eemfnpefgojllvzzaimu.supabase.co
   - Execute este script
   - Salve os resultados como "MOGIANA_RESULTS"

2. EXECUTAR NA LITORAL (que não está funcionando):
   - Acesse: https://dtifsfzmnjnllzzlndxv.supabase.co
   - Execute este script
   - Salve os resultados como "LITORAL_RESULTS"

3. COMPARAR OS RESULTADOS:
   - Compare as estatísticas gerais
   - Identifique diferenças na estrutura
   - Verifique se os triggers são diferentes
   - Compare os problemas identificados

4. APLICAR CORREÇÕES:
   - Se LITORAL tiver problemas que MOGIANA não tem
   - Execute fix-litoral-specific-issues.sql na LITORAL
   - Re-execute este script para confirmar correção

5. VALIDAR:
   - Teste a interface da LITORAL
   - Compare comportamento com MOGIANA
   - Confirme que ambas funcionam igual

Este processo ajudará a identificar exatamente o que está diferente
entre as duas empresas e corrigir especificamente o problema da LITORAL.
*/