-- Script para corrigir o campo total_paid em empréstimos quitados
-- Este script atualiza o total_paid para ser igual ao total_with_interest
-- para empréstimos que foram quitados, garantindo que as comissões sejam calculadas corretamente

-- Verificar dados antes da correção
SELECT 
    id,
    client_id,
    original_amount,
    interest_rate,
    total_with_interest,
    total_paid,
    (total_with_interest - original_amount) as juros_calculados,
    paid_date
FROM paid_loans 
WHERE total_paid != total_with_interest
ORDER BY paid_date DESC;

-- Atualizar total_paid para ser igual a total_with_interest
-- (valor correto para empréstimos quitados)
UPDATE paid_loans 
SET total_paid = total_with_interest,
    notes = COALESCE(notes, '') || ' | CORRIGIDO: total_paid atualizado para valor correto da quitação'
WHERE total_paid != total_with_interest;

-- Verificar dados após a correção
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
ORDER BY paid_date DESC
LIMIT 10;

-- Mostrar estatísticas da correção
SELECT 
    COUNT(*) as total_emprestimos_quitados,
    SUM(original_amount) as total_capital,
    SUM(total_with_interest - original_amount) as total_juros,
    SUM(total_paid) as total_pago_corrigido
FROM paid_loans;