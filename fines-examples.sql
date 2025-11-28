-- =====================================================
-- EXEMPLOS PRÁTICOS - SISTEMA DE MULTAS
-- =====================================================
-- Nexus Gestão Financeira
-- =====================================================

-- =====================================================
-- CENÁRIO 1: APLICAR MULTA POR ATRASO DE PAGAMENTO
-- =====================================================

-- Passo 1: Identificar empréstimos vencidos
SELECT 
    l.id as loan_id,
    l.client_id,
    c.name as client_name,
    c.phone,
    l.amount,
    l.due_date,
    CURRENT_DATE - l.due_date as days_overdue
FROM loans l
JOIN clients c ON l.client_id = c.id
WHERE l.due_date < CURRENT_DATE 
AND l.status = 'overdue'
ORDER BY days_overdue DESC;

-- Passo 2: Criar multa automática (exemplo com 5 dias de atraso, 2% ao dia)
DO $$
DECLARE
    v_loan_id UUID := '987fcdeb-51a2-43d7-9876-543210987654'; -- Substituir pelo ID real
    v_client_id UUID := '123e4567-e89b-12d3-a456-426614174000'; -- Substituir pelo ID real
    v_user_id UUID := (SELECT id FROM users WHERE role = 'admin' LIMIT 1);
    v_days_late INTEGER := 5;
    v_fine_amount DECIMAL;
BEGIN
    -- Calcular multa
    v_fine_amount := calculate_late_fine(v_loan_id, v_days_late, 0.02);
    
    -- Inserir multa
    INSERT INTO fines (
        client_id,
        loan_id,
        amount,
        reason,
        fine_type,
        fine_date,
        due_date,
        created_by,
        notes
    ) VALUES (
        v_client_id,
        v_loan_id,
        v_fine_amount,
        'Atraso de ' || v_days_late || ' dias no pagamento do empréstimo',
        'late_payment',
        CURRENT_DATE,
        CURRENT_DATE + INTERVAL '7 days',
        v_user_id,
        'Multa calculada automaticamente - 2% ao dia'
    );
    
    RAISE NOTICE 'Multa de R$ % criada com sucesso', v_fine_amount;
END $$;

-- =====================================================
-- CENÁRIO 2: CRIAR MÚLTIPLAS MULTAS DE UMA VEZ
-- =====================================================

-- Aplicar multa a todos os empréstimos vencidos há mais de 7 dias
INSERT INTO fines (client_id, loan_id, amount, reason, fine_type, fine_date, due_date, created_by, notes)
SELECT 
    l.client_id,
    l.id,
    l.amount * 0.02 * (CURRENT_DATE - l.due_date) as fine_amount, -- 2% ao dia
    'Atraso de ' || (CURRENT_DATE - l.due_date) || ' dias no pagamento',
    'late_payment',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '15 days',
    (SELECT id FROM users WHERE role = 'admin' LIMIT 1),
    'Multa automática por atraso superior a 7 dias'
FROM loans l
WHERE l.due_date < CURRENT_DATE - INTERVAL '7 days'
AND l.status = 'overdue'
AND NOT EXISTS (
    -- Não criar multa duplicada
    SELECT 1 FROM fines f 
    WHERE f.loan_id = l.id 
    AND f.fine_date = CURRENT_DATE
);

-- =====================================================
-- CENÁRIO 3: REGISTRAR PAGAMENTO DE MULTA
-- =====================================================

-- Pagamento integral de uma multa
UPDATE fines 
SET 
    paid_amount = amount,
    paid_date = CURRENT_DATE,
    payment_method = 'PIX',
    notes = COALESCE(notes, '') || ' | Pago integralmente via PIX em ' || CURRENT_DATE::TEXT
WHERE id = '456e7890-e89b-12d3-a456-426614174111'
AND status != 'paid'
RETURNING 
    id,
    client_id,
    amount,
    paid_amount,
    status;

-- Pagamento parcial de uma multa
UPDATE fines 
SET 
    paid_amount = paid_amount + 30.00, -- adicionar valor parcial
    payment_method = 'Dinheiro',
    notes = COALESCE(notes, '') || ' | Pagamento parcial de R$ 30,00 em ' || CURRENT_DATE::TEXT
WHERE id = '456e7890-e89b-12d3-a456-426614174111'
RETURNING 
    id,
    amount,
    paid_amount,
    amount - paid_amount as remaining,
    status;

-- =====================================================
-- CENÁRIO 4: HISTÓRICO COMPLETO DO CLIENTE
-- =====================================================

-- Ver todas as transações de um cliente específico
WITH client_info AS (
    SELECT id, name, cpf 
    FROM clients 
    WHERE cpf = '123.456.789-00'
)
SELECT 
    cph.transaction_type,
    cph.transaction_description,
    cph.amount,
    cph.transaction_date,
    cph.status,
    cph.created_by_name,
    cph.notes
FROM client_payment_history cph
JOIN client_info ci ON cph.client_id = ci.id
ORDER BY cph.transaction_date DESC;

-- =====================================================
-- CENÁRIO 5: DASHBOARD DE MULTAS
-- =====================================================

-- Resumo geral de multas
SELECT 
    COUNT(*) as total_multas,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as multas_pendentes,
    COUNT(CASE WHEN status = 'paid' THEN 1 END) as multas_pagas,
    SUM(amount) as valor_total,
    SUM(paid_amount) as valor_recebido,
    SUM(amount - paid_amount) as saldo_devedor
FROM fines;

-- Multas por tipo
SELECT 
    fine_type,
    COUNT(*) as quantidade,
    SUM(amount) as valor_total,
    AVG(amount) as valor_medio,
    SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END) as valor_pago
FROM fines
GROUP BY fine_type
ORDER BY quantidade DESC;

-- =====================================================
-- CENÁRIO 6: ALERTAS E NOTIFICAÇÕES
-- =====================================================

-- Multas vencendo nos próximos 3 dias
SELECT 
    f.id,
    c.name as client_name,
    c.phone,
    c.email,
    f.amount,
    f.paid_amount,
    f.amount - f.paid_amount as saldo,
    f.due_date,
    f.reason,
    f.status
FROM fines f
JOIN clients c ON f.client_id = c.id
WHERE f.due_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '3 days'
AND f.status IN ('pending', 'partial_paid')
ORDER BY f.due_date ASC;

-- Multas vencidas
SELECT 
    f.id,
    c.name as client_name,
    c.phone,
    c.email,
    f.amount,
    f.paid_amount,
    f.amount - f.paid_amount as saldo,
    f.due_date,
    CURRENT_DATE - f.due_date as dias_vencido,
    f.reason
FROM fines f
JOIN clients c ON f.client_id = c.id
WHERE f.due_date < CURRENT_DATE
AND f.status IN ('pending', 'partial_paid')
ORDER BY dias_vencido DESC;

-- =====================================================
-- CENÁRIO 7: RELATÓRIO MENSAL DE MULTAS
-- =====================================================

SELECT 
    DATE_TRUNC('month', fine_date) as mes,
    COUNT(*) as total_multas_mes,
    SUM(amount) as valor_total_aplicado,
    SUM(paid_amount) as valor_recebido,
    SUM(amount - paid_amount) as saldo_devedor,
    COUNT(CASE WHEN status = 'paid' THEN 1 END) as multas_pagas,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as multas_pendentes,
    ROUND(
        COUNT(CASE WHEN status = 'paid' THEN 1 END)::NUMERIC / 
        COUNT(*)::NUMERIC * 100, 
        2
    ) as taxa_recuperacao_pct
FROM fines
WHERE fine_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY DATE_TRUNC('month', fine_date)
ORDER BY mes DESC;

-- =====================================================
-- CENÁRIO 8: TOP CLIENTES COM MULTAS
-- =====================================================

SELECT 
    c.name,
    c.cpf,
    c.phone,
    c.email,
    cfs.total_fines,
    cfs.pending_fines,
    cfs.total_fines_amount,
    cfs.total_paid_amount,
    cfs.total_outstanding_amount
FROM client_fines_summary cfs
JOIN clients c ON c.id = cfs.client_id
WHERE cfs.total_outstanding_amount > 0
ORDER BY cfs.total_outstanding_amount DESC
LIMIT 20;

-- =====================================================
-- CENÁRIO 9: CANCELAR MULTA
-- =====================================================

-- Cancelar uma multa específica
UPDATE fines 
SET 
    status = 'cancelled',
    notes = COALESCE(notes, '') || ' | Multa cancelada pelo administrador em ' || CURRENT_DATE::TEXT || '. Motivo: [INSERIR MOTIVO]'
WHERE id = '456e7890-e89b-12d3-a456-426614174111'
RETURNING id, client_id, amount, reason, status;

-- Cancelar todas as multas de um cliente específico (usar com cuidado!)
UPDATE fines 
SET 
    status = 'cancelled',
    notes = COALESCE(notes, '') || ' | Cancelamento em lote autorizado em ' || CURRENT_DATE::TEXT
WHERE client_id = '123e4567-e89b-12d3-a456-426614174000'
AND status IN ('pending', 'partial_paid')
RETURNING id, amount, reason;

-- =====================================================
-- CENÁRIO 10: MULTA ADMINISTRATIVA
-- =====================================================

-- Criar multa administrativa (taxa de serviço, por exemplo)
INSERT INTO fines (
    client_id,
    amount,
    reason,
    fine_type,
    fine_date,
    due_date,
    created_by,
    notes
) VALUES (
    '123e4567-e89b-12d3-a456-426614174000',
    75.00,
    'Taxa de reemissão de boleto bancário',
    'administrative',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '10 days',
    (SELECT id FROM users WHERE role = 'admin' LIMIT 1),
    'Taxa administrativa conforme contrato'
);

-- =====================================================
-- CENÁRIO 11: MULTA POR QUEBRA DE CONTRATO
-- =====================================================

-- Criar multa por quebra de contrato
INSERT INTO fines (
    client_id,
    loan_id,
    amount,
    reason,
    fine_type,
    fine_date,
    due_date,
    created_by,
    notes
) VALUES (
    '123e4567-e89b-12d3-a456-426614174000',
    '987fcdeb-51a2-43d7-9876-543210987654',
    500.00,
    'Quebra de cláusula contratual - pagamento antecipado sem aviso',
    'breach_of_contract',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '30 days',
    (SELECT id FROM users WHERE role = 'admin' LIMIT 1),
    'Conforme cláusula 5.2 do contrato de empréstimo'
);

-- =====================================================
-- CENÁRIO 12: RELATÓRIO DE EFETIVIDADE
-- =====================================================

-- Análise de efetividade de cobrança de multas
WITH multas_stats AS (
    SELECT 
        fine_type,
        COUNT(*) as total,
        SUM(amount) as valor_aplicado,
        SUM(paid_amount) as valor_recebido,
        AVG(CASE 
            WHEN paid_date IS NOT NULL 
            THEN paid_date - fine_date 
            ELSE NULL 
        END) as dias_medio_pagamento
    FROM fines
    WHERE fine_date >= CURRENT_DATE - INTERVAL '6 months'
    GROUP BY fine_type
)
SELECT 
    fine_type as tipo_multa,
    total as quantidade,
    valor_aplicado,
    valor_recebido,
    valor_aplicado - valor_recebido as valor_pendente,
    ROUND((valor_recebido / NULLIF(valor_aplicado, 0) * 100), 2) as taxa_recuperacao_pct,
    ROUND(dias_medio_pagamento, 1) as dias_medio_para_pagar
FROM multas_stats
ORDER BY valor_aplicado DESC;

-- =====================================================
-- CENÁRIO 13: MIGRAÇÃO - CONVERTER MULTAS ANTIGAS
-- =====================================================

-- Se você já tinha multas no campo fine_amount da tabela payments,
-- pode migrar para a nova tabela fines:
/*
INSERT INTO fines (
    client_id,
    loan_id,
    amount,
    reason,
    fine_type,
    fine_date,
    due_date,
    paid_amount,
    paid_date,
    status,
    payment_method,
    created_by,
    notes
)
SELECT 
    l.client_id,
    p.loan_id,
    p.fine_amount,
    'Multa migrada do sistema antigo',
    'late_payment',
    p.payment_date,
    p.payment_date,
    p.fine_amount, -- Já estava paga
    p.payment_date,
    'paid',
    p.payment_type,
    p.created_by,
    'Migrado automaticamente em ' || CURRENT_DATE::TEXT
FROM payments p
JOIN loans l ON p.loan_id = l.id
WHERE p.fine_amount > 0
AND NOT EXISTS (
    SELECT 1 FROM fines f 
    WHERE f.loan_id = p.loan_id 
    AND f.amount = p.fine_amount
);
*/

-- =====================================================
-- CENÁRIO 14: BUSCA AVANÇADA
-- =====================================================

-- Buscar multas com filtros múltiplos
SELECT 
    f.id,
    c.name as cliente,
    f.amount,
    f.paid_amount,
    f.status,
    f.fine_type,
    f.due_date,
    f.reason
FROM fines f
JOIN clients c ON f.client_id = c.id
WHERE 
    -- Filtros customizáveis
    f.fine_date >= '2024-01-01'
    AND f.fine_date <= CURRENT_DATE
    AND f.status IN ('pending', 'partial_paid')
    AND f.amount >= 50.00
    -- AND c.name ILIKE '%silva%' -- Busca por nome
    -- AND f.fine_type = 'late_payment' -- Filtrar por tipo
ORDER BY f.due_date ASC;

-- =====================================================
-- FIM DOS EXEMPLOS
-- =====================================================
