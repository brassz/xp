-- =============================================================================
-- VERIFICAÇÃO DE VALORES CORRETOS - TODOS OS EMPRÉSTIMOS DA LITORAL
-- =============================================================================
-- Execute este script no SQL Editor do Supabase da Litoral
-- URL: https://dtifsfzmnjnllzzlndxv.supabase.co
-- =============================================================================

-- =============================================================================
-- RESUMO GERAL - VALORES TOTAIS
-- =============================================================================

SELECT 
    '========== RESUMO GERAL - LITORAL CRED ==========' as titulo;

SELECT 
    COUNT(*) as total_emprestimos,
    SUM(amount) as valor_total_emprestado,
    SUM(total_amount) as valor_total_com_juros,
    SUM(total_amount) - SUM(amount) as total_juros,
    ROUND(AVG(interest_rate), 2) as taxa_juros_media,
    MIN(loan_date) as emprestimo_mais_antigo,
    MAX(loan_date) as emprestimo_mais_recente
FROM loans;

-- =============================================================================
-- VALORES POR STATUS
-- =============================================================================

SELECT 
    '' as separador,
    '========== VALORES POR STATUS ==========' as titulo;

SELECT 
    status as status_emprestimo,
    COUNT(*) as quantidade,
    SUM(amount) as valor_emprestado,
    SUM(total_amount) as valor_com_juros,
    ROUND(AVG(interest_rate), 2) as taxa_media,
    SUM(total_amount) - SUM(amount) as total_juros
FROM loans
GROUP BY status
ORDER BY 
    CASE status
        WHEN 'active' THEN 1
        WHEN 'overdue' THEN 2
        WHEN 'partial_paid' THEN 3
        WHEN 'paid' THEN 4
        WHEN 'cancelled' THEN 5
        ELSE 6
    END;

-- =============================================================================
-- TOP 10 MAIORES EMPRÉSTIMOS
-- =============================================================================

SELECT 
    '' as separador,
    '========== TOP 10 MAIORES EMPRÉSTIMOS ==========' as titulo;

SELECT 
    c.name as cliente,
    l.amount as valor_emprestado,
    l.interest_rate as taxa_juros,
    l.total_amount as valor_total,
    l.status as status,
    l.loan_date as data_emprestimo,
    l.due_date as vencimento,
    CASE 
        WHEN l.due_date < CURRENT_DATE AND l.status IN ('active', 'partial_paid') 
        THEN CURRENT_DATE - l.due_date
        ELSE 0
    END as dias_vencido
FROM loans l
LEFT JOIN clients c ON c.id = l.client_id
ORDER BY l.amount DESC
LIMIT 10;

-- =============================================================================
-- EMPRÉSTIMOS ATIVOS (A RECEBER)
-- =============================================================================

SELECT 
    '' as separador,
    '========== EMPRÉSTIMOS ATIVOS (A RECEBER) ==========' as titulo;

SELECT 
    COUNT(*) as total_emprestimos_ativos,
    SUM(amount) as valor_emprestado,
    SUM(total_amount) as valor_a_receber_com_juros,
    SUM(
        COALESCE(
            (SELECT SUM(p.amount) 
             FROM payments p 
             WHERE p.loan_id = loans.id), 
            0
        )
    ) as valor_ja_pago,
    SUM(total_amount) - SUM(
        COALESCE(
            (SELECT SUM(p.amount) 
             FROM payments p 
             WHERE p.loan_id = loans.id), 
            0
        )
    ) as saldo_a_receber
FROM loans
WHERE status IN ('active', 'overdue', 'partial_paid');

-- =============================================================================
-- EMPRÉSTIMOS VENCIDOS
-- =============================================================================

SELECT 
    '' as separador,
    '========== EMPRÉSTIMOS VENCIDOS ==========' as titulo;

SELECT 
    COUNT(*) as total_vencidos,
    SUM(amount) as valor_emprestado,
    SUM(total_amount) as valor_com_juros,
    SUM(
        COALESCE(
            (SELECT SUM(p.amount) 
             FROM payments p 
             WHERE p.loan_id = loans.id), 
            0
        )
    ) as valor_ja_pago,
    SUM(total_amount) - SUM(
        COALESCE(
            (SELECT SUM(p.amount) 
             FROM payments p 
             WHERE p.loan_id = loans.id), 
            0
        )
    ) as saldo_vencido
FROM loans
WHERE due_date < CURRENT_DATE 
    AND status IN ('active', 'overdue', 'partial_paid');

-- =============================================================================
-- EMPRÉSTIMOS VENCIDOS POR PERÍODO
-- =============================================================================

SELECT 
    '' as separador,
    '========== EMPRÉSTIMOS VENCIDOS POR PERÍODO ==========' as titulo;

SELECT 
    CASE 
        WHEN CURRENT_DATE - due_date <= 30 THEN '1-30 dias'
        WHEN CURRENT_DATE - due_date <= 60 THEN '31-60 dias'
        WHEN CURRENT_DATE - due_date <= 90 THEN '61-90 dias'
        WHEN CURRENT_DATE - due_date <= 180 THEN '91-180 dias'
        ELSE 'Mais de 180 dias'
    END as periodo_vencimento,
    COUNT(*) as quantidade,
    SUM(amount) as valor_emprestado,
    SUM(total_amount) as valor_total,
    SUM(total_amount) - SUM(
        COALESCE(
            (SELECT SUM(p.amount) 
             FROM payments p 
             WHERE p.loan_id = loans.id), 
            0
        )
    ) as saldo_devedor
FROM loans
WHERE due_date < CURRENT_DATE 
    AND status IN ('active', 'overdue', 'partial_paid')
GROUP BY 
    CASE 
        WHEN CURRENT_DATE - due_date <= 30 THEN '1-30 dias'
        WHEN CURRENT_DATE - due_date <= 60 THEN '31-60 dias'
        WHEN CURRENT_DATE - due_date <= 90 THEN '61-90 dias'
        WHEN CURRENT_DATE - due_date <= 180 THEN '91-180 dias'
        ELSE 'Mais de 180 dias'
    END
ORDER BY 
    CASE 
        WHEN CURRENT_DATE - due_date <= 30 THEN 1
        WHEN CURRENT_DATE - due_date <= 60 THEN 2
        WHEN CURRENT_DATE - due_date <= 90 THEN 3
        WHEN CURRENT_DATE - due_date <= 180 THEN 4
        ELSE 5
    END;

-- =============================================================================
-- EMPRÉSTIMOS QUITADOS
-- =============================================================================

SELECT 
    '' as separador,
    '========== EMPRÉSTIMOS QUITADOS ==========' as titulo;

SELECT 
    COUNT(*) as total_quitados,
    SUM(amount) as valor_emprestado,
    SUM(total_amount) as valor_total_com_juros,
    SUM(
        COALESCE(
            (SELECT SUM(p.amount) 
             FROM payments p 
             WHERE p.loan_id = loans.id), 
            0
        )
    ) as total_recebido
FROM loans
WHERE status = 'paid';

-- =============================================================================
-- EMPRÉSTIMOS CANCELADOS
-- =============================================================================

SELECT 
    '' as separador,
    '========== EMPRÉSTIMOS CANCELADOS ==========' as titulo;

SELECT 
    COUNT(*) as total_cancelados,
    SUM(amount) as valor_emprestado,
    SUM(total_amount) as valor_total_com_juros,
    SUM(
        COALESCE(
            (SELECT SUM(p.amount) 
             FROM payments p 
             WHERE p.loan_id = loans.id), 
            0
        )
    ) as valor_pago_antes_cancelamento
FROM loans
WHERE status = 'cancelled';

-- Se houver registros na tabela cancelled_loans, mostrar também
SELECT 
    COUNT(*) as total_em_cancelled_loans,
    SUM(original_amount) as valor_emprestado,
    SUM(total_with_interest) as valor_total_com_juros,
    SUM(total_paid_before_cancellation) as valor_pago_antes_cancelamento
FROM cancelled_loans;

-- =============================================================================
-- VALORES POR MÊS DE CRIAÇÃO (ÚLTIMOS 12 MESES)
-- =============================================================================

SELECT 
    '' as separador,
    '========== EMPRÉSTIMOS POR MÊS (ÚLTIMOS 12 MESES) ==========' as titulo;

SELECT 
    TO_CHAR(loan_date, 'YYYY-MM') as mes,
    COUNT(*) as quantidade,
    SUM(amount) as valor_emprestado,
    SUM(total_amount) as valor_com_juros,
    ROUND(AVG(interest_rate), 2) as taxa_media
FROM loans
WHERE loan_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY TO_CHAR(loan_date, 'YYYY-MM')
ORDER BY mes DESC;

-- =============================================================================
-- TOP 10 CLIENTES COM MAIS EMPRÉSTIMOS
-- =============================================================================

SELECT 
    '' as separador,
    '========== TOP 10 CLIENTES COM MAIS EMPRÉSTIMOS ==========' as titulo;

SELECT 
    c.name as cliente,
    c.cpf,
    COUNT(l.id) as total_emprestimos,
    SUM(l.amount) as valor_total_emprestado,
    SUM(l.total_amount) as valor_total_com_juros,
    SUM(
        COALESCE(
            (SELECT SUM(p.amount) 
             FROM payments p 
             WHERE p.loan_id = l.id), 
            0
        )
    ) as total_pago,
    SUM(l.total_amount) - SUM(
        COALESCE(
            (SELECT SUM(p.amount) 
             FROM payments p 
             WHERE p.loan_id = l.id), 
            0
        )
    ) as saldo_devedor
FROM clients c
INNER JOIN loans l ON l.client_id = c.id
GROUP BY c.id, c.name, c.cpf
ORDER BY COUNT(l.id) DESC, SUM(l.amount) DESC
LIMIT 10;

-- =============================================================================
-- EMPRÉSTIMOS QUE VENCEM NOS PRÓXIMOS 30 DIAS
-- =============================================================================

SELECT 
    '' as separador,
    '========== EMPRÉSTIMOS QUE VENCEM NOS PRÓXIMOS 30 DIAS ==========' as titulo;

SELECT 
    COUNT(*) as total_vencendo_30_dias,
    SUM(amount) as valor_emprestado,
    SUM(total_amount) as valor_a_receber,
    SUM(
        COALESCE(
            (SELECT SUM(p.amount) 
             FROM payments p 
             WHERE p.loan_id = loans.id), 
            0
        )
    ) as valor_ja_pago,
    SUM(total_amount) - SUM(
        COALESCE(
            (SELECT SUM(p.amount) 
             FROM payments p 
             WHERE p.loan_id = loans.id), 
            0
        )
    ) as saldo_a_receber
FROM loans
WHERE due_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days'
    AND status IN ('active', 'partial_paid');

-- =============================================================================
-- LISTA DETALHADA - EMPRÉSTIMOS QUE VENCEM NOS PRÓXIMOS 30 DIAS
-- =============================================================================

SELECT 
    c.name as cliente,
    c.phone as telefone,
    l.amount as valor_emprestado,
    l.total_amount as valor_total,
    COALESCE(
        (SELECT SUM(p.amount) 
         FROM payments p 
         WHERE p.loan_id = l.id), 
        0
    ) as ja_pago,
    l.total_amount - COALESCE(
        (SELECT SUM(p.amount) 
         FROM payments p 
         WHERE p.loan_id = l.id), 
        0
    ) as saldo_devedor,
    l.due_date as vencimento,
    l.due_date - CURRENT_DATE as dias_para_vencer
FROM loans l
LEFT JOIN clients c ON c.id = l.client_id
WHERE l.due_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days'
    AND l.status IN ('active', 'partial_paid')
ORDER BY l.due_date ASC;

-- =============================================================================
-- RESUMO FINAL - FLUXO DE CAIXA
-- =============================================================================

SELECT 
    '' as separador,
    '========== RESUMO FINAL - FLUXO DE CAIXA ==========' as titulo;

WITH valores AS (
    SELECT 
        SUM(CASE WHEN status IN ('active', 'overdue', 'partial_paid') THEN total_amount ELSE 0 END) as total_a_receber,
        SUM(CASE WHEN status IN ('active', 'overdue', 'partial_paid') THEN amount ELSE 0 END) as capital_ativo,
        SUM(CASE WHEN status = 'paid' THEN total_amount ELSE 0 END) as total_recebido,
        SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END) as capital_recebido,
        COALESCE((SELECT SUM(amount) FROM payments), 0) as pagamentos_totais
    FROM loans
)
SELECT 
    capital_ativo as capital_emprestado_ativo,
    total_a_receber as valor_total_a_receber,
    total_a_receber - capital_ativo as juros_a_receber,
    pagamentos_totais as total_pago_ate_agora,
    total_a_receber - pagamentos_totais as saldo_a_receber_real,
    capital_recebido as capital_quitado,
    total_recebido as total_quitado_com_juros,
    total_recebido - capital_recebido as juros_recebidos
FROM valores;

-- =============================================================================
-- VERIFICAÇÃO DE INTEGRIDADE
-- =============================================================================

SELECT 
    '' as separador,
    '========== VERIFICAÇÃO DE INTEGRIDADE ==========' as titulo;

SELECT 
    'Empréstimos sem cliente (PROBLEMA!)' as verificacao,
    COUNT(*) as quantidade
FROM loans
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE clients.id = loans.client_id)
UNION ALL
SELECT 
    'Empréstimos com total_amount NULL' as verificacao,
    COUNT(*) as quantidade
FROM loans
WHERE total_amount IS NULL
UNION ALL
SELECT 
    'Empréstimos com amount = 0' as verificacao,
    COUNT(*) as quantidade
FROM loans
WHERE amount = 0
UNION ALL
SELECT 
    'Empréstimos com data futura' as verificacao,
    COUNT(*) as quantidade
FROM loans
WHERE loan_date > CURRENT_DATE;

-- =============================================================================
-- FIM DO RELATÓRIO
-- =============================================================================

SELECT 
    '' as separador,
    '========================================' as titulo,
    'Relatório gerado em: ' || NOW()::timestamp(0) as data_hora,
    'Empresa: LITORAL CRED' as empresa;
