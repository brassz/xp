-- Script SEGURO para reverter correções no total_paid de empréstimos quitados
-- Este script oferece diferentes opções de reversão com verificações de segurança

-- ========================================
-- PASSO 1: ANÁLISE DOS DADOS ATUAIS
-- ========================================

-- Verificar registros que foram corrigidos
SELECT 
    'REGISTROS CORRIGIDOS' as categoria,
    COUNT(*) as quantidade
FROM paid_loans 
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%'

UNION ALL

SELECT 
    'TOTAL DE EMPRÉSTIMOS QUITADOS' as categoria,
    COUNT(*) as quantidade
FROM paid_loans;

-- Mostrar detalhes dos registros corrigidos
SELECT 
    id,
    loan_id,
    client_id,
    original_amount,
    interest_rate,
    total_with_interest,
    total_paid as total_paid_atual,
    (total_with_interest - original_amount) as juros_teoricos,
    (total_paid - original_amount) as juros_no_total_paid_atual,
    paid_date,
    CASE 
        WHEN notes LIKE '%CORRIGIDO%' THEN 'CORRIGIDO'
        ELSE 'ORIGINAL'
    END as status_correcao
FROM paid_loans 
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%'
ORDER BY paid_date DESC;

-- ========================================
-- PASSO 2: VERIFICAR PAGAMENTOS PARCIAIS
-- ========================================

-- Verificar se existem pagamentos parciais para os empréstimos corrigidos
SELECT 
    pl.id as paid_loan_id,
    pl.loan_id,
    pl.original_amount,
    pl.total_paid as total_paid_atual,
    COALESCE(SUM(p.amount), 0) as soma_pagamentos_parciais,
    COUNT(p.id) as qtd_pagamentos_parciais,
    CASE 
        WHEN COUNT(p.id) > 0 THEN 'TEM PAGAMENTOS PARCIAIS'
        ELSE 'SEM PAGAMENTOS PARCIAIS'
    END as tem_pagamentos
FROM paid_loans pl
LEFT JOIN payments p ON p.loan_id = pl.loan_id
WHERE pl.notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%'
GROUP BY pl.id, pl.loan_id, pl.original_amount, pl.total_paid
ORDER BY pl.paid_date DESC;

-- ========================================
-- PASSO 3: OPÇÕES DE REVERSÃO
-- ========================================

-- IMPORTANTE: Execute apenas UMA das opções abaixo, conforme sua necessidade

-- ----------------------------------------
-- OPÇÃO A: REVERTER PARA SOMA DE PAGAMENTOS PARCIAIS
-- (Recomendado se os empréstimos tiveram pagamentos parciais registrados)
-- ----------------------------------------

/*
UPDATE paid_loans 
SET total_paid = (
    SELECT COALESCE(SUM(p.amount), original_amount)
    FROM payments p 
    WHERE p.loan_id = paid_loans.loan_id
),
notes = REPLACE(notes, ' | CORRIGIDO: total_paid atualizado para valor correto da quitação', '')
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%';
*/

-- ----------------------------------------
-- OPÇÃO B: REVERTER PARA VALOR ORIGINAL (CAPITAL)
-- (Use se quiser que total_paid seja apenas o capital, sem juros)
-- ----------------------------------------

/*
UPDATE paid_loans 
SET total_paid = original_amount,
notes = REPLACE(notes, ' | CORRIGIDO: total_paid atualizado para valor correto da quitação', '')
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%';
*/

-- ----------------------------------------
-- OPÇÃO C: REVERTER PARA VALOR ESPECÍFICO CALCULADO
-- (Use se quiser definir total_paid como capital + uma porcentagem dos juros)
-- Exemplo: capital + 50% dos juros pagos
-- ----------------------------------------

/*
UPDATE paid_loans 
SET total_paid = original_amount + ((total_with_interest - original_amount) * 0.5),
notes = REPLACE(notes, ' | CORRIGIDO: total_paid atualizado para valor correto da quitação', '')
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%';
*/

-- ----------------------------------------
-- OPÇÃO D: REVERTER APENAS REGISTROS ESPECÍFICOS
-- (Use se quiser reverter apenas alguns registros específicos)
-- ----------------------------------------

/*
UPDATE paid_loans 
SET total_paid = original_amount,
notes = REPLACE(notes, ' | CORRIGIDO: total_paid atualizado para valor correto da quitação', '')
WHERE id IN (1, 2, 3) -- Substitua pelos IDs específicos
AND notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%';
*/

-- ========================================
-- PASSO 4: VERIFICAÇÃO PÓS-REVERSÃO
-- ========================================

-- Execute após escolher e executar uma das opções acima

-- Verificar se a reversão foi aplicada
SELECT 
    'REGISTROS AINDA COM CORREÇÃO' as categoria,
    COUNT(*) as quantidade
FROM paid_loans 
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%'

UNION ALL

SELECT 
    'REGISTROS REVERTIDOS' as categoria,
    COUNT(*) as quantidade
FROM paid_loans 
WHERE notes NOT LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%'
OR notes IS NULL;

-- Mostrar estatísticas finais
SELECT 
    COUNT(*) as total_emprestimos_quitados,
    SUM(original_amount) as total_capital,
    SUM(total_with_interest - original_amount) as total_juros_teoricos,
    SUM(total_paid - original_amount) as total_juros_no_total_paid,
    AVG(total_paid / original_amount) as media_percentual_pago
FROM paid_loans;

-- Mostrar alguns registros após reversão
SELECT 
    id,
    loan_id,
    original_amount,
    total_with_interest,
    total_paid,
    (total_paid - original_amount) as juros_no_total_paid,
    paid_date,
    LEFT(notes, 50) as primeiras_50_chars_notas
FROM paid_loans 
ORDER BY paid_date DESC
LIMIT 10;