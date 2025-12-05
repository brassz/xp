-- ============================================================================
-- VERIFICAÇÃO EM 10 SEGUNDOS: EMPRÉSTIMOS ESTÃO SUMINDO?
-- ============================================================================
-- Cole este script inteiro no SQL Editor do Supabase e clique RUN
-- ============================================================================

SELECT 
    '🔍 VERIFICAÇÃO RÁPIDA DE EMPRÉSTIMOS' as titulo,
    '' as resultado;

-- RESULTADO 1: Totais em cada tabela
WITH counts AS (
    SELECT 
        (SELECT COUNT(*) FROM loans) as total_loans,
        (SELECT COUNT(*) FROM cancelled_loans) as total_cancelled,
        (SELECT COUNT(*) FROM paid_loans) as total_paid,
        (SELECT COALESCE(MAX(rowsecurity), false) FROM pg_tables 
         WHERE schemaname = 'public' AND tablename = 'loans') as rls_enabled
)
SELECT 
    '📊 TOTAIS' as verificacao,
    total_loans || ' ativos | ' || 
    total_cancelled || ' cancelados | ' || 
    total_paid || ' pagos' as resultado,
    CASE 
        WHEN total_loans = 0 THEN '🔴 CRÍTICO: Nenhum empréstimo ativo!'
        WHEN total_cancelled > total_loans * 0.3 THEN '⚠️ ALERTA: Muitos cancelados'
        ELSE '✅ Normal'
    END as status
FROM counts

UNION ALL

-- RESULTADO 2: Status do RLS
SELECT 
    '🔒 RLS (Segurança)' as verificacao,
    CASE 
        WHEN rls_enabled THEN 'HABILITADO - Pode esconder dados'
        ELSE 'DESABILITADO'
    END as resultado,
    CASE 
        WHEN rls_enabled THEN '🔴 RISCO ALTO: Desabilite com ALTER TABLE loans DISABLE ROW LEVEL SECURITY;'
        ELSE '✅ Seguro'
    END as status
FROM counts

UNION ALL

-- RESULTADO 3: Cancelamentos recentes
SELECT 
    '📅 Últimos 7 dias' as verificacao,
    (SELECT COUNT(*) FROM cancelled_loans 
     WHERE cancelled_at >= CURRENT_DATE - INTERVAL '7 days')::TEXT || ' cancelamentos' as resultado,
    CASE 
        WHEN (SELECT COUNT(*) FROM cancelled_loans 
              WHERE cancelled_at >= CURRENT_DATE - INTERVAL '7 days') > 5 
        THEN '⚠️ ALERTA: Muitos cancelamentos'
        ELSE '✅ Normal'
    END as status

UNION ALL

-- RESULTADO 4: Cancelamentos hoje
SELECT 
    '⏰ Hoje' as verificacao,
    (SELECT COUNT(*) FROM cancelled_loans 
     WHERE cancelled_at::date = CURRENT_DATE)::TEXT || ' cancelamentos' as resultado,
    CASE 
        WHEN (SELECT COUNT(*) FROM cancelled_loans 
              WHERE cancelled_at::date = CURRENT_DATE) > 2 
        THEN '⚠️ ALERTA: Atividade suspeita'
        WHEN (SELECT COUNT(*) FROM cancelled_loans 
              WHERE cancelled_at::date = CURRENT_DATE) > 0 
        THEN '⚠️ Verificar motivos'
        ELSE '✅ Nenhum'
    END as status

UNION ALL

-- RESULTADO 5: Auditoria existe?
SELECT 
    '📋 Sistema de Auditoria' as verificacao,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.tables 
                     WHERE table_name = 'loans_audit')
        THEN 'Instalado'
        ELSE 'NÃO INSTALADO'
    END as resultado,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.tables 
                     WHERE table_name = 'loans_audit')
        THEN '✅ Protegido'
        ELSE '🔴 CRÍTICO: Execute CORRECAO-PREVENTIVA-EMPRESTIMOS.sql'
    END as status;

-- Mostrar últimos cancelamentos se houver
SELECT 
    '' as separador,
    '📋 ÚLTIMOS CANCELAMENTOS' as titulo,
    '' as info;

SELECT 
    cl.cancelled_at::timestamp(0) as quando,
    c.name as cliente,
    cl.original_amount as valor,
    SUBSTRING(cl.cancellation_reason, 1, 50) as motivo
FROM cancelled_loans cl
LEFT JOIN clients c ON c.id = cl.client_id
ORDER BY cl.cancelled_at DESC
LIMIT 5;

-- DIAGNÓSTICO FINAL
SELECT 
    '' as separador,
    '🎯 DIAGNÓSTICO FINAL' as titulo,
    '' as info;

WITH analysis AS (
    SELECT 
        (SELECT COUNT(*) FROM loans) as active_count,
        (SELECT COUNT(*) FROM cancelled_loans) as cancelled_count,
        (SELECT COALESCE(MAX(rowsecurity), false) FROM pg_tables 
         WHERE schemaname = 'public' AND tablename = 'loans') as has_rls,
        (SELECT COUNT(*) FROM cancelled_loans 
         WHERE cancelled_at >= CURRENT_DATE - INTERVAL '7 days') as recent_cancels,
        (SELECT EXISTS (SELECT 1 FROM information_schema.tables 
                        WHERE table_name = 'loans_audit')) as has_audit
)
SELECT 
    CASE 
        WHEN has_rls AND recent_cancels > 3 THEN '🔴 RISCO CRÍTICO'
        WHEN has_rls OR recent_cancels > 3 THEN '⚠️ RISCO MÉDIO'
        WHEN NOT has_audit THEN '⚠️ SEM PROTEÇÃO'
        ELSE '✅ SITUAÇÃO NORMAL'
    END as avaliacao,
    
    CASE 
        WHEN has_rls AND recent_cancels > 3 THEN 
            'RLS habilitado + muitos cancelamentos = Alta chance de empréstimos sumindo'
        WHEN has_rls THEN 
            'RLS pode estar escondendo empréstimos. Execute: ALTER TABLE loans DISABLE ROW LEVEL SECURITY;'
        WHEN recent_cancels > 3 THEN 
            'Muitos cancelamentos recentes. Verifique se foram legítimos.'
        WHEN NOT has_audit THEN 
            'Sistema sem auditoria. Execute: CORRECAO-PREVENTIVA-EMPRESTIMOS.sql'
        ELSE 
            'Nenhum problema detectado. Sistema operando normalmente.'
    END as recomendacao,
    
    active_count as emprestimos_ativos,
    cancelled_count as total_cancelados,
    recent_cancels as cancelados_ultimos_7_dias
FROM analysis;

-- ============================================================================
-- PRÓXIMOS PASSOS
-- ============================================================================

SELECT 
    '' as separador,
    '📖 PRÓXIMOS PASSOS' as titulo,
    '' as info;

SELECT 
    '1. Leia o arquivo: README-EMPRESTIMOS-SUMINDO.md' as passo,
    'Entenda o problema e as soluções' as descricao
UNION ALL
SELECT 
    '2. Se encontrou alertas 🔴 ou ⚠️ acima:',
    'Execute: DIAGNOSTICO-RAPIDO-EMPRESTIMOS.sql (mais detalhado)'
UNION ALL
SELECT 
    '3. Para implementar proteções:',
    'Execute: CORRECAO-PREVENTIVA-EMPRESTIMOS.sql'
UNION ALL
SELECT 
    '4. Para guia passo a passo:',
    'Abra: GUIA-RAPIDO-VERIFICAR-EMPRESTIMOS.md';

-- ============================================================================
-- FIM - Tempo de execução: ~10 segundos
-- ============================================================================
