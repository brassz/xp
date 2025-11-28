-- =====================================================
-- CORREÇÃO URGENTE - RESTAURAR VALORES RESTANTES
-- =====================================================
-- Execute IMEDIATAMENTE no Supabase → SQL Editor

-- PASSO 1: DIAGNOSTICAR O PROBLEMA
-- Ver quantos empréstimos estão com valores zerados

SELECT 'DIAGNÓSTICO: Empréstimos com problemas' as etapa;

SELECT 
    COUNT(*) as total_emprestimos,
    COUNT(CASE WHEN amount = 0 THEN 1 END) as com_valor_zero,
    COUNT(CASE WHEN amount IS NULL THEN 1 END) as com_valor_null
FROM loans
WHERE status != 'cancelled';

-- Ver se há pagamentos
SELECT 'Total de pagamentos na tabela' as etapa;
SELECT COUNT(*) as total_pagamentos FROM payments;

-- =====================================================
-- PASSO 2: VERIFICAR SE PAGAMENTOS FORAM DELETADOS
-- =====================================================

-- Ver últimos pagamentos
SELECT 'Últimos 10 pagamentos' as etapa;
SELECT 
    id,
    loan_id,
    amount,
    payment_date,
    notes,
    created_at
FROM payments
ORDER BY created_at DESC
LIMIT 10;

-- =====================================================
-- PASSO 3: RECALCULAR VALORES RESTANTES
-- =====================================================

-- Esta query mostra o valor que DEVERIA estar em cada empréstimo

SELECT 'Valores que deveriam estar nos empréstimos' as etapa;

SELECT 
    l.id as loan_id,
    l.amount as valor_atual,
    l.interest_rate,
    (l.amount + (l.amount * l.interest_rate / 100)) as total_com_juros,
    COALESCE(SUM(p.amount), 0) as total_pago,
    (l.amount + (l.amount * l.interest_rate / 100)) - COALESCE(SUM(p.amount), 0) as valor_restante_correto
FROM loans l
LEFT JOIN payments p ON p.loan_id = l.id
WHERE l.status != 'cancelled'
GROUP BY l.id, l.amount, l.interest_rate
ORDER BY l.created_at DESC
LIMIT 20;

-- =====================================================
-- PASSO 4: VERIFICAR SE DELETOU PAGAMENTOS REAIS
-- =====================================================

-- Verificar se há empréstimos sem nenhum pagamento
SELECT 'Empréstimos que ficaram sem pagamentos' as etapa;

SELECT 
    l.id,
    l.amount,
    l.loan_date,
    c.name as cliente,
    COUNT(p.id) as qtd_pagamentos
FROM loans l
JOIN clients c ON l.client_id = c.id
LEFT JOIN payments p ON p.loan_id = l.id
WHERE l.status != 'cancelled'
GROUP BY l.id, l.amount, l.loan_date, c.name
HAVING COUNT(p.id) = 0
ORDER BY l.loan_date DESC;

-- =====================================================
-- AÇÕES DE RECUPERAÇÃO
-- =====================================================

-- Se você tem BACKUP dos pagamentos, restaure aqui
-- Se NÃO tem backup, tente recuperar do histórico do Supabase

SELECT '⚠️ ATENÇÃO: Verifique os resultados acima!' as alerta;
SELECT '⚠️ Se pagamentos REAIS foram deletados, você precisa restaurar do backup!' as alerta;
SELECT '⚠️ Supabase mantém backups automáticos - vá em Settings → Database → Point-in-time Recovery' as alerta;

-- =====================================================
-- RESULTADO ESPERADO:
-- Você verá se:
-- 1. Pagamentos foram deletados incorretamente
-- 2. Quantos empréstimos ficaram sem pagamentos
-- 3. Quais valores deveriam estar em cada empréstimo
-- =====================================================
