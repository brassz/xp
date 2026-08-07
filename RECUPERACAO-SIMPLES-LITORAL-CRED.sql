-- =====================================================
-- RECUPERAÇÃO SIMPLES E DIRETA - LITORAL CRED
-- =====================================================
-- Copie TODO este arquivo e cole no SQL Editor do Supabase
-- Execute tudo de uma vez
-- =====================================================

-- Passo 1: Criar tabela paid_loans se não existir
CREATE TABLE IF NOT EXISTS paid_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID NOT NULL UNIQUE,
    client_id UUID,
    original_amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) DEFAULT 0,
    total_with_interest DECIMAL(10,2) NOT NULL,
    loan_date DATE,
    due_date DATE,
    paid_date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_paid DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) DEFAULT 'Recuperado',
    notes TEXT,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Passo 2: Criar índices
CREATE INDEX IF NOT EXISTS idx_paid_loans_loan_id ON paid_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_client_id ON paid_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_paid_date ON paid_loans(paid_date);

-- Passo 3: Habilitar RLS
ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;

-- Passo 4: Criar política de acesso (permite tudo para authenticated)
DROP POLICY IF EXISTS "Enable all for authenticated users" ON paid_loans;
CREATE POLICY "Enable all for authenticated users" ON paid_loans
    FOR ALL USING (auth.role() = 'authenticated');

-- Passo 5: Conceder permissões
GRANT ALL ON paid_loans TO authenticated;

-- =====================================================
-- RECUPERAÇÃO DE DADOS - MÉTODO 1
-- =====================================================
-- Recuperar empréstimos que ainda existem na tabela loans com status 'paid'

INSERT INTO paid_loans (
    loan_id,
    client_id,
    original_amount,
    interest_rate,
    total_with_interest,
    loan_date,
    due_date,
    paid_date,
    total_paid,
    notes,
    created_by,
    created_at
)
SELECT 
    l.id,
    l.client_id,
    l.amount,
    COALESCE(l.interest_rate, 0),
    l.amount + (l.amount * COALESCE(l.interest_rate, 0) / 100),
    l.loan_date,
    l.due_date,
    COALESCE((SELECT MAX(p.payment_date) FROM payments p WHERE p.loan_id = l.id), CURRENT_DATE),
    COALESCE((SELECT SUM(p.amount) FROM payments p WHERE p.loan_id = l.id), l.amount),
    'Recuperado: Estava marcado como paid',
    l.created_by,
    l.created_at
FROM loans l
WHERE l.status = 'paid'
ON CONFLICT (loan_id) DO NOTHING;

-- =====================================================
-- RECUPERAÇÃO DE DADOS - MÉTODO 2
-- =====================================================
-- Recuperar empréstimos totalmente pagos mas com status errado

INSERT INTO paid_loans (
    loan_id,
    client_id,
    original_amount,
    interest_rate,
    total_with_interest,
    loan_date,
    due_date,
    paid_date,
    total_paid,
    notes,
    created_by,
    created_at
)
SELECT 
    l.id,
    l.client_id,
    l.amount,
    COALESCE(l.interest_rate, 0),
    l.amount + (l.amount * COALESCE(l.interest_rate, 0) / 100),
    l.loan_date,
    l.due_date,
    MAX(p.payment_date),
    SUM(p.amount),
    'Recuperado: Estava totalmente pago mas status incorreto',
    l.created_by,
    l.created_at
FROM loans l
INNER JOIN payments p ON l.id = p.loan_id
WHERE l.status != 'paid'
GROUP BY l.id, l.client_id, l.amount, l.interest_rate, l.loan_date, l.due_date, l.created_by, l.created_at
HAVING SUM(p.amount) >= (l.amount + (l.amount * COALESCE(l.interest_rate, 0) / 100))
ON CONFLICT (loan_id) DO NOTHING;

-- =====================================================
-- RECUPERAÇÃO DE DADOS - MÉTODO 3 (CRÍTICO)
-- =====================================================
-- Reconstruir empréstimos que foram DELETADOS mas têm pagamentos

INSERT INTO paid_loans (
    loan_id,
    client_id,
    original_amount,
    interest_rate,
    total_with_interest,
    loan_date,
    due_date,
    paid_date,
    total_paid,
    notes,
    created_by,
    created_at
)
SELECT 
    p.loan_id,
    p.created_by, -- Usando created_by como client_id temporário (será corrigido depois)
    SUM(p.amount) * 0.9, -- Estimativa: 90% do total pago foi o valor original
    10.00, -- Taxa estimada
    SUM(p.amount),
    MIN(p.payment_date),
    MAX(p.payment_date),
    MAX(p.payment_date),
    SUM(p.amount),
    'RECONSTRUÍDO de pagamentos - VALORES ESTIMADOS - Revisar client_id e valores',
    p.created_by,
    MIN(p.created_at)
FROM payments p
LEFT JOIN loans l ON p.loan_id = l.id
WHERE l.id IS NULL -- Pagamentos de empréstimos que não existem mais
GROUP BY p.loan_id, p.created_by
ON CONFLICT (loan_id) DO NOTHING;

-- =====================================================
-- RELATÓRIO FINAL
-- =====================================================

-- Contar total recuperado
SELECT 
    'TOTAL RECUPERADO' as status,
    COUNT(*) as quantidade,
    SUM(total_paid) as total_valor
FROM paid_loans;

-- Contar por método
SELECT 
    CASE 
        WHEN notes LIKE '%status paid%' THEN 'Método 1: Status Paid'
        WHEN notes LIKE '%status incorreto%' THEN 'Método 2: Totalmente Pagos'
        WHEN notes LIKE '%RECONSTRUÍDO%' THEN 'Método 3: Reconstruídos (Revisar)'
        ELSE 'Outros'
    END as metodo,
    COUNT(*) as quantidade,
    SUM(total_paid) as total_valor
FROM paid_loans
GROUP BY 
    CASE 
        WHEN notes LIKE '%status paid%' THEN 'Método 1: Status Paid'
        WHEN notes LIKE '%status incorreto%' THEN 'Método 2: Totalmente Pagos'
        WHEN notes LIKE '%RECONSTRUÍDO%' THEN 'Método 3: Reconstruídos (Revisar)'
        ELSE 'Outros'
    END;

-- Listar primeiros 20 registros recuperados
SELECT 
    pl.id,
    pl.loan_id,
    c.name as cliente,
    pl.original_amount,
    pl.total_paid,
    pl.paid_date,
    pl.notes
FROM paid_loans pl
LEFT JOIN clients c ON pl.client_id = c.id
ORDER BY pl.paid_date DESC
LIMIT 20;

-- Verificar empréstimos reconstruídos que precisam revisão
SELECT 
    COUNT(*) as quantidade_revisar,
    SUM(total_paid) as valor_total
FROM paid_loans
WHERE notes LIKE '%RECONSTRUÍDO%';

-- =====================================================
-- MENSAGEM FINAL
-- =====================================================

DO $$
DECLARE
    v_total INTEGER;
    v_metodo1 INTEGER;
    v_metodo2 INTEGER;
    v_metodo3 INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_total FROM paid_loans;
    
    SELECT COUNT(*) INTO v_metodo1 FROM paid_loans WHERE notes LIKE '%status paid%';
    SELECT COUNT(*) INTO v_metodo2 FROM paid_loans WHERE notes LIKE '%status incorreto%';
    SELECT COUNT(*) INTO v_metodo3 FROM paid_loans WHERE notes LIKE '%RECONSTRUÍDO%';
    
    RAISE NOTICE '';
    RAISE NOTICE '=========================================';
    RAISE NOTICE 'RECUPERAÇÃO CONCLUÍDA!';
    RAISE NOTICE '=========================================';
    RAISE NOTICE '';
    RAISE NOTICE 'Total de empréstimos recuperados: %', v_total;
    RAISE NOTICE '  - Método 1 (Status paid): %', v_metodo1;
    RAISE NOTICE '  - Método 2 (Totalmente pagos): %', v_metodo2;
    RAISE NOTICE '  - Método 3 (Reconstruídos): %', v_metodo3;
    RAISE NOTICE '';
    
    IF v_metodo3 > 0 THEN
        RAISE NOTICE 'ATENÇÃO: % empréstimos foram RECONSTRUÍDOS', v_metodo3;
        RAISE NOTICE 'Estes precisam de revisão manual para corrigir:';
        RAISE NOTICE '  - client_id (atualmente usando created_by)';
        RAISE NOTICE '  - Valores originais (atualmente estimados)';
        RAISE NOTICE '';
    END IF;
    
    IF v_total = 0 THEN
        RAISE NOTICE 'NENHUM empréstimo foi recuperado!';
        RAISE NOTICE 'Possíveis causas:';
        RAISE NOTICE '  1. Tabela payments também foi limpa';
        RAISE NOTICE '  2. Não havia empréstimos quitados';
        RAISE NOTICE '  3. Dados foram deletados permanentemente';
        RAISE NOTICE '';
        RAISE NOTICE 'Verificar: SELECT COUNT(*) FROM payments;';
    END IF;
    
    RAISE NOTICE '=========================================';
END $$;
