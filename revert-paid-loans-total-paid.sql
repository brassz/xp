-- Script para reverter as correções feitas no total_paid de empréstimos quitados
-- Este script desfaz as mudanças aplicadas pelo fix-paid-loans-total-paid.sql
-- ATENÇÃO: Execute apenas se necessário reverter as correções

-- Verificar dados antes da reversão
SELECT 
    id,
    client_id,
    original_amount,
    interest_rate,
    total_with_interest,
    total_paid,
    (total_with_interest - original_amount) as juros_calculados,
    paid_date,
    notes
FROM paid_loans 
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%'
ORDER BY paid_date DESC;

-- Mostrar quantos registros serão afetados
SELECT COUNT(*) as registros_a_reverter
FROM paid_loans 
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%';

-- OPÇÃO 1: Reverter para soma de pagamentos parciais (se disponível)
-- Esta opção tentará calcular o total_paid baseado nos pagamentos parciais existentes
-- NOTA: Isso pode não ser preciso se não houver registros de pagamentos parciais

UPDATE paid_loans 
SET total_paid = (
    SELECT COALESCE(SUM(p.amount), 0)
    FROM payments p 
    WHERE p.loan_id = paid_loans.loan_id
),
notes = REPLACE(notes, ' | CORRIGIDO: total_paid atualizado para valor correto da quitação', '')
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%'
AND EXISTS (
    SELECT 1 FROM payments p WHERE p.loan_id = paid_loans.loan_id
);

-- OPÇÃO 2: Para registros sem pagamentos parciais, definir total_paid como original_amount
-- (assumindo que foram quitados sem pagamentos parciais registrados)
UPDATE paid_loans 
SET total_paid = original_amount,
notes = REPLACE(notes, ' | CORRIGIDO: total_paid atualizado para valor correto da quitação', '')
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%'
AND NOT EXISTS (
    SELECT 1 FROM payments p WHERE p.loan_id = paid_loans.loan_id
);

-- Limpar notas vazias que podem ter ficado
UPDATE paid_loans 
SET notes = TRIM(notes)
WHERE notes = '' OR notes IS NULL;

-- Verificar dados após a reversão
SELECT 
    id,
    client_id,
    original_amount,
    interest_rate,
    total_with_interest,
    total_paid,
    (total_with_interest - original_amount) as juros_calculados,
    (total_paid - original_amount) as juros_pagos_calculados,
    paid_date,
    notes
FROM paid_loans 
ORDER BY paid_date DESC
LIMIT 10;

-- Mostrar estatísticas após a reversão
SELECT 
    COUNT(*) as total_emprestimos_quitados,
    SUM(original_amount) as total_capital,
    SUM(total_with_interest - original_amount) as total_juros_teoricos,
    SUM(total_paid - original_amount) as total_juros_pagos_revertidos,
    SUM(total_paid) as total_pago_apos_reversao
FROM paid_loans;

-- Verificar se ainda existem registros com a nota de correção
SELECT COUNT(*) as registros_nao_revertidos
FROM paid_loans 
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%';