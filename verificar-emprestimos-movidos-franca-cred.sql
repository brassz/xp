-- ========================================
-- SCRIPT DE VERIFICAÇÃO DE EMPRÉSTIMOS
-- Sistema: Franca Cred
-- Objetivo: Investigar redução de 283 para 280 empréstimos
-- Data: 6 de dezembro de 2025
-- ========================================

-- INSTRUÇÕES:
-- 1. Abra o Supabase (https://mhtxyxizfnxupwmilith.supabase.co)
-- 2. Vá em SQL Editor
-- 3. Crie uma nova query
-- 4. Cole este script completo
-- 5. Clique em "Run" para executar

-- ========================================
-- PARTE 1: VISÃO GERAL - CONTAGEM POR TABELA
-- ========================================

SELECT 
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' as separador,
    'CONTAGEM GERAL DE EMPRÉSTIMOS' as titulo;

SELECT 
    'EMPRÉSTIMOS ATIVOS (loans)' as tipo,
    COUNT(*) as quantidade,
    '✅ Aparecem no dashboard' as observacao
FROM loans

UNION ALL

SELECT 
    'EMPRÉSTIMOS QUITADOS (paid_loans)' as tipo,
    COUNT(*) as quantidade,
    '📊 Aba "Empréstimos Quitados"' as observacao
FROM paid_loans

UNION ALL

SELECT 
    'EMPRÉSTIMOS CANCELADOS (cancelled_loans)' as tipo,
    COUNT(*) as quantidade,
    '🗑️ Aba "Empréstimos Cancelados"' as observacao
FROM cancelled_loans

UNION ALL

SELECT 
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' as tipo,
    'TOTAL GERAL' as quantidade,
    CAST(
        (SELECT COUNT(*) FROM loans) + 
        (SELECT COUNT(*) FROM paid_loans) + 
        (SELECT COUNT(*) FROM cancelled_loans) 
    AS TEXT) as observacao;

-- ========================================
-- PARTE 2: EMPRÉSTIMOS QUITADOS RECENTEMENTE
-- ========================================

SELECT 
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' as separador,
    'EMPRÉSTIMOS QUITADOS NAS ÚLTIMAS 48 HORAS' as titulo;

SELECT 
    pl.id as id_registro,
    pl.loan_id as id_emprestimo_original,
    TO_CHAR(pl.paid_date, 'DD/MM/YYYY') as data_quitacao,
    TO_CHAR(pl.created_at, 'DD/MM/YYYY HH24:MI:SS') as hora_exata_registro,
    CONCAT('R$ ', TO_CHAR(pl.original_amount, 'FM999,999,990.00')) as valor_original,
    CONCAT('R$ ', TO_CHAR(pl.total_with_interest, 'FM999,999,990.00')) as valor_com_juros,
    CONCAT('R$ ', TO_CHAR(pl.total_paid, 'FM999,999,990.00')) as total_pago,
    pl.payment_method as forma_pagamento,
    pl.notes as observacoes,
    pl.client_id as id_cliente,
    '🟢 QUITADO' as status
FROM paid_loans pl
WHERE pl.paid_date >= CURRENT_DATE - INTERVAL '2 days'
ORDER BY pl.created_at DESC;

-- Se não encontrar nenhum registro, mostrar mensagem
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM paid_loans WHERE paid_date >= CURRENT_DATE - INTERVAL '2 days') = 0
        THEN '⚠️ Nenhum empréstimo foi QUITADO nas últimas 48 horas'
        ELSE ''
    END as mensagem
WHERE (SELECT COUNT(*) FROM paid_loans WHERE paid_date >= CURRENT_DATE - INTERVAL '2 days') = 0;

-- ========================================
-- PARTE 3: EMPRÉSTIMOS CANCELADOS RECENTEMENTE
-- ========================================

SELECT 
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' as separador,
    'EMPRÉSTIMOS CANCELADOS NAS ÚLTIMAS 48 HORAS' as titulo;

SELECT 
    cl.id as id_registro,
    cl.loan_id as id_emprestimo_original,
    TO_CHAR(cl.cancellation_date, 'DD/MM/YYYY') as data_cancelamento,
    TO_CHAR(cl.created_at, 'DD/MM/YYYY HH24:MI:SS') as hora_exata_registro,
    CONCAT('R$ ', TO_CHAR(cl.original_amount, 'FM999,999,990.00')) as valor_original,
    CONCAT('R$ ', TO_CHAR(cl.total_with_interest, 'FM999,999,990.00')) as valor_com_juros,
    CONCAT('R$ ', TO_CHAR(cl.total_paid_before_cancellation, 'FM999,999,990.00')) as pago_antes_cancelamento,
    CONCAT('R$ ', TO_CHAR(cl.refund_amount, 'FM999,999,990.00')) as valor_reembolso,
    cl.cancellation_reason as motivo_cancelamento,
    cl.client_id as id_cliente,
    cl.cancelled_by as cancelado_por_usuario_id,
    '🔴 CANCELADO' as status
FROM cancelled_loans cl
WHERE cl.cancellation_date >= CURRENT_DATE - INTERVAL '2 days'
ORDER BY cl.created_at DESC;

-- Se não encontrar nenhum registro, mostrar mensagem
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM cancelled_loans WHERE cancellation_date >= CURRENT_DATE - INTERVAL '2 days') = 0
        THEN '⚠️ Nenhum empréstimo foi CANCELADO nas últimas 48 horas'
        ELSE ''
    END as mensagem
WHERE (SELECT COUNT(*) FROM cancelled_loans WHERE cancellation_date >= CURRENT_DATE - INTERVAL '2 days') = 0;

-- ========================================
-- PARTE 4: RESUMO DA MOVIMENTAÇÃO
-- ========================================

SELECT 
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' as separador,
    'RESUMO DAS MOVIMENTAÇÕES (48H)' as titulo;

WITH movimentacoes AS (
    SELECT 
        'QUITADOS' as tipo,
        COUNT(*) as quantidade,
        COALESCE(SUM(original_amount), 0) as valor_total
    FROM paid_loans
    WHERE paid_date >= CURRENT_DATE - INTERVAL '2 days'
    
    UNION ALL
    
    SELECT 
        'CANCELADOS' as tipo,
        COUNT(*) as quantidade,
        COALESCE(SUM(original_amount), 0) as valor_total
    FROM cancelled_loans
    WHERE cancellation_date >= CURRENT_DATE - INTERVAL '2 days'
)
SELECT 
    tipo,
    quantidade as qtd_emprestimos_movidos,
    CONCAT('R$ ', TO_CHAR(valor_total, 'FM999,999,990.00')) as valor_total,
    CASE 
        WHEN tipo = 'QUITADOS' THEN '→ Movidos para paid_loans'
        WHEN tipo = 'CANCELADOS' THEN '→ Movidos para cancelled_loans'
    END as destino
FROM movimentacoes

UNION ALL

SELECT 
    '━━━━━━━━━━━━━━━━━━' as tipo,
    'TOTAL MOVIDO' as qtd_emprestimos_movidos,
    CAST((SELECT SUM(quantidade) FROM movimentacoes) AS TEXT) as valor_total,
    '← Esta é a diferença na contagem' as destino;

-- ========================================
-- PARTE 5: HISTÓRICO SEMANAL (Últimos 7 dias)
-- ========================================

SELECT 
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' as separador,
    'HISTÓRICO DE MOVIMENTAÇÕES (7 DIAS)' as titulo;

WITH movimentacoes_semanais AS (
    SELECT 
        created_at::date as data,
        'CRIADO' as tipo,
        COUNT(*) as quantidade
    FROM loans
    WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
    GROUP BY created_at::date
    
    UNION ALL
    
    SELECT 
        paid_date as data,
        'QUITADO' as tipo,
        COUNT(*) as quantidade
    FROM paid_loans
    WHERE paid_date >= CURRENT_DATE - INTERVAL '7 days'
    GROUP BY paid_date
    
    UNION ALL
    
    SELECT 
        cancellation_date as data,
        'CANCELADO' as tipo,
        COUNT(*) as quantidade
    FROM cancelled_loans
    WHERE cancellation_date >= CURRENT_DATE - INTERVAL '7 days'
    GROUP BY cancellation_date
)
SELECT 
    TO_CHAR(data, 'DD/MM/YYYY') as data,
    CASE 
        WHEN EXTRACT(DOW FROM data) = 0 THEN 'Domingo'
        WHEN EXTRACT(DOW FROM data) = 1 THEN 'Segunda'
        WHEN EXTRACT(DOW FROM data) = 2 THEN 'Terça'
        WHEN EXTRACT(DOW FROM data) = 3 THEN 'Quarta'
        WHEN EXTRACT(DOW FROM data) = 4 THEN 'Quinta'
        WHEN EXTRACT(DOW FROM data) = 5 THEN 'Sexta'
        WHEN EXTRACT(DOW FROM data) = 6 THEN 'Sábado'
    END as dia_semana,
    tipo,
    quantidade,
    CASE 
        WHEN tipo = 'CRIADO' THEN '➕ Adicionado a loans'
        WHEN tipo = 'QUITADO' THEN '✅ Removido de loans → paid_loans'
        WHEN tipo = 'CANCELADO' THEN '❌ Removido de loans → cancelled_loans'
    END as acao
FROM movimentacoes_semanais
ORDER BY data DESC, 
    CASE tipo 
        WHEN 'CRIADO' THEN 1 
        WHEN 'QUITADO' THEN 2 
        WHEN 'CANCELADO' THEN 3 
    END;

-- ========================================
-- PARTE 6: SALDO LÍQUIDO (Criados vs Movidos)
-- ========================================

SELECT 
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' as separador,
    'BALANÇO FINAL (ÚLTIMAS 48H)' as titulo;

WITH balanco AS (
    SELECT 
        (SELECT COUNT(*) FROM loans WHERE created_at >= CURRENT_DATE - INTERVAL '2 days') as criados,
        (SELECT COUNT(*) FROM paid_loans WHERE paid_date >= CURRENT_DATE - INTERVAL '2 days') as quitados,
        (SELECT COUNT(*) FROM cancelled_loans WHERE cancellation_date >= CURRENT_DATE - INTERVAL '2 days') as cancelados
)
SELECT 
    criados as emprestimos_criados,
    quitados as emprestimos_quitados,
    cancelados as emprestimos_cancelados,
    (quitados + cancelados) as total_removidos_de_loans,
    (criados - quitados - cancelados) as saldo_liquido,
    CASE 
        WHEN (criados - quitados - cancelados) > 0 THEN '📈 Crescimento'
        WHEN (criados - quitados - cancelados) < 0 THEN '📉 Redução'
        ELSE '➡️ Estável'
    END as tendencia,
    CASE 
        WHEN (criados - quitados - cancelados) < 0 
        THEN '⚠️ Este é o motivo da redução de 283 para 280'
        ELSE '✅ Sem redução significativa'
    END as explicacao
FROM balanco;

-- ========================================
-- PARTE 7: VERIFICAÇÃO DE INTEGRIDADE
-- ========================================

SELECT 
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' as separador,
    'VERIFICAÇÃO DE INTEGRIDADE DE DADOS' as titulo;

-- Verificar IDs duplicados entre tabelas
WITH ids_em_uso AS (
    SELECT id, 'loans' as origem FROM loans
    UNION ALL
    SELECT loan_id as id, 'paid_loans' as origem FROM paid_loans
    UNION ALL
    SELECT loan_id as id, 'cancelled_loans' as origem FROM cancelled_loans
),
duplicatas AS (
    SELECT id, COUNT(*) as vezes_encontrado
    FROM ids_em_uso
    GROUP BY id
    HAVING COUNT(*) > 1
)
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '✅ SEM DUPLICATAS'
        ELSE '⚠️ IDs DUPLICADOS ENCONTRADOS'
    END as status_integridade,
    COUNT(*) as quantidade_duplicatas,
    CASE 
        WHEN COUNT(*) = 0 THEN 'Todos os IDs são únicos entre as tabelas'
        ELSE 'Há IDs que aparecem em múltiplas tabelas'
    END as observacao
FROM duplicatas;

-- ========================================
-- FIM DO SCRIPT
-- ========================================

SELECT 
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' as separador,
    '✅ SCRIPT EXECUTADO COM SUCESSO' as titulo,
    'Analise os resultados acima para entender a movimentação dos empréstimos' as instrucao;

-- ========================================
-- INTERPRETAÇÃO DOS RESULTADOS
-- ========================================

/*
COMO INTERPRETAR OS RESULTADOS:

1️⃣ CONTAGEM GERAL
   - Se loans = 280, isso está CORRETO
   - Verifique paid_loans e cancelled_loans
   - Soma total deve incluir todos os empréstimos já criados

2️⃣ EMPRÉSTIMOS MOVIDOS (48H)
   - Se houver 3 registros em "QUITADOS" → 3 empréstimos foram quitados
   - Se houver 3 registros em "CANCELADOS" → 3 empréstimos foram cancelados
   - Se houver combinação (ex: 2 quitados + 1 cancelado) → total de 3 movidos

3️⃣ BALANÇO FINAL
   - saldo_liquido negativo = redução na contagem de loans
   - Exemplo: -3 significa que 3 empréstimos foram removidos de loans

4️⃣ VERIFICAÇÃO DE INTEGRIDADE
   - "SEM DUPLICATAS" = ✅ Sistema funcionando corretamente
   - "IDs DUPLICADOS" = ⚠️ Investigar mais a fundo

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CONCLUSÃO:

Se o script mostrar que 3 empréstimos foram movidos para 
paid_loans ou cancelled_loans nas últimas 48 horas, 
então o sistema está funcionando CORRETAMENTE.

Os empréstimos não sumiram - eles foram processados 
(quitados ou cancelados) e movidos para as tabelas apropriadas.

Para ver esses empréstimos no sistema web:
- Acesse a aba "Empréstimos Quitados"
- Acesse a aba "Empréstimos Cancelados"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
*/
