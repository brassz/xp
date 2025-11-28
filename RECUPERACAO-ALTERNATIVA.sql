-- =====================================================
-- RECUPERAÇÃO ALTERNATIVA - SE NÃO TEM BACKUP
-- =====================================================
-- Use este script se não conseguir restaurar do backup

-- =====================================================
-- OPÇÃO A: Verificar se os pagamentos ainda existem
-- =====================================================

-- Procurar por pagamentos "deletados" que podem estar em outro lugar
SELECT 'Verificando tabelas relacionadas' as etapa;

-- Ver se existe tabela de log/audit
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND (table_name LIKE '%payment%' OR table_name LIKE '%log%' OR table_name LIKE '%audit%');

-- =====================================================
-- OPÇÃO B: Recalcular valores com base em paid_loans
-- =====================================================

-- Empréstimos que já foram quitados tem registros em paid_loans
SELECT 'Valores de empréstimos quitados' as etapa;

SELECT 
    loan_id,
    original_amount,
    total_paid,
    paid_date
FROM paid_loans
ORDER BY paid_date DESC
LIMIT 20;

-- =====================================================
-- OPÇÃO C: Criar pagamentos baseado em padrão típico
-- =====================================================

-- Ver empréstimos que provavelmente deveriam ter pagamentos
SELECT 'Empréstimos criados há mais de 7 dias sem pagamentos' as etapa;

SELECT 
    l.id,
    l.amount,
    l.interest_rate,
    l.loan_date,
    l.due_date,
    c.name as cliente,
    DATEDIFF(day, l.loan_date, CURRENT_DATE) as dias_desde_criacao
FROM loans l
JOIN clients c ON c.id = l.client_id
LEFT JOIN payments p ON p.loan_id = l.id
WHERE l.status != 'cancelled'
  AND p.id IS NULL
  AND l.loan_date < CURRENT_DATE - INTERVAL '7 days'
ORDER BY l.loan_date;

-- =====================================================
-- OPÇÃO D: Verificar inconsistências
-- =====================================================

-- Empréstimos com status 'paid' mas sem pagamentos
SELECT 'Empréstimos marcados como pagos mas sem pagamentos registrados' as etapa;

SELECT 
    l.id,
    l.amount,
    l.status,
    c.name as cliente,
    COUNT(p.id) as qtd_pagamentos
FROM loans l
JOIN clients c ON c.id = l.client_id
LEFT JOIN payments p ON p.loan_id = l.id
WHERE l.status = 'paid'
GROUP BY l.id, l.amount, l.status, c.name
HAVING COUNT(p.id) = 0;

-- =====================================================
-- CORREÇÃO: Resetar status de empréstimos afetados
-- =====================================================

-- Se empréstimos ficaram com status inconsistente
-- Descomente as linhas abaixo se necessário

/*
UPDATE loans
SET status = 'active'
WHERE status = 'paid'
  AND id NOT IN (SELECT DISTINCT loan_id FROM payments WHERE loan_id IS NOT NULL)
  AND id NOT IN (SELECT DISTINCT loan_id FROM paid_loans WHERE loan_id IS NOT NULL);
*/

SELECT '⚠️ Verifique os resultados acima para entender a extensão do problema' as alerta;

-- =====================================================
-- ATENÇÃO:
-- Este script apenas DIAGNOSTICA o problema
-- NÃO faz alterações automáticas
-- 
-- Depois de ver os resultados, posso criar um script
-- específico de recuperação baseado no seu caso
-- =====================================================
