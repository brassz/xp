-- =====================================================
-- SCRIPT PARA RECUPERAR EMPRÉSTIMOS QUITADOS - LITORAL CRED
-- =====================================================
-- Execute este script no SQL Editor do Supabase da LITORAL CRED
-- URL: https://dtifsfzmnjnllzzlndxv.supabase.co
-- =====================================================
-- IMPORTANTE: Execute PRIMEIRO o script de diagnóstico
-- para entender qual é o problema antes de executar este
-- =====================================================

-- OPÇÃO 1: CRIAR TABELA PAID_LOANS SE NÃO EXISTIR
-- =====================================================

-- Verificar se precisa criar a tabela
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans'
    ) THEN
        -- Criar tabela paid_loans
        CREATE TABLE paid_loans (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            loan_id UUID NOT NULL,
            client_id UUID NOT NULL,
            original_amount DECIMAL(10,2) NOT NULL,
            interest_rate DECIMAL(5,2) NOT NULL,
            total_with_interest DECIMAL(10,2) NOT NULL,
            loan_date DATE NOT NULL,
            due_date DATE NOT NULL,
            paid_date DATE NOT NULL DEFAULT CURRENT_DATE,
            total_paid DECIMAL(10,2) NOT NULL,
            payment_method VARCHAR(50),
            notes TEXT,
            created_by UUID,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );

        -- Criar índices
        CREATE INDEX idx_paid_loans_loan_id ON paid_loans(loan_id);
        CREATE INDEX idx_paid_loans_client_id ON paid_loans(client_id);
        CREATE INDEX idx_paid_loans_paid_date ON paid_loans(paid_date);

        -- Habilitar RLS
        ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;

        -- Criar políticas
        CREATE POLICY "Authenticated users can view all paid loans" ON paid_loans
            FOR SELECT USING (auth.role() = 'authenticated');

        CREATE POLICY "Authenticated users can insert paid loans" ON paid_loans
            FOR INSERT WITH CHECK (auth.role() = 'authenticated');

        CREATE POLICY "Users can update paid loans they created" ON paid_loans
            FOR UPDATE USING (
                created_by::text = auth.uid()::text OR
                EXISTS (
                    SELECT 1 FROM users 
                    WHERE id::text = auth.uid()::text 
                    AND role = 'admin'
                )
            );

        CREATE POLICY "Users can delete paid loans they created" ON paid_loans
            FOR DELETE USING (
                created_by::text = auth.uid()::text OR
                EXISTS (
                    SELECT 1 FROM users 
                    WHERE id::text = auth.uid()::text 
                    AND role = 'admin'
                )
            );

        -- Conceder permissões
        GRANT SELECT, INSERT, UPDATE, DELETE ON paid_loans TO authenticated;

        RAISE NOTICE 'Tabela paid_loans criada com sucesso!';
    ELSE
        RAISE NOTICE 'Tabela paid_loans já existe.';
    END IF;
END $$;

-- =====================================================
-- OPÇÃO 2: RECUPERAR DADOS DE EMPRÉSTIMOS QUITADOS
-- =====================================================

-- 2.1 Migrar empréstimos com status 'paid' da tabela loans
-- para a tabela paid_loans
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
    payment_method,
    notes,
    created_by,
    created_at
)
SELECT 
    l.id as loan_id,
    l.client_id,
    l.amount as original_amount,
    l.interest_rate,
    l.amount + (l.amount * l.interest_rate / 100) as total_with_interest,
    l.loan_date,
    l.due_date,
    COALESCE(
        (SELECT MAX(payment_date) FROM payments WHERE loan_id = l.id),
        CURRENT_DATE
    ) as paid_date,
    COALESCE(
        (SELECT SUM(amount) FROM payments WHERE loan_id = l.id),
        l.amount + (l.amount * l.interest_rate / 100)
    ) as total_paid,
    'Recuperado' as payment_method,
    'Empréstimo recuperado da tabela loans - estava marcado como pago' as notes,
    l.created_by,
    l.created_at
FROM loans l
WHERE l.status = 'paid'
AND NOT EXISTS (
    SELECT 1 FROM paid_loans pl WHERE pl.loan_id = l.id
)
ON CONFLICT (loan_id) DO NOTHING;

-- Mostrar quantos foram recuperados
SELECT 
    COUNT(*) as emprestimos_recuperados,
    'Empréstimos com status paid migrados para paid_loans' as descricao
FROM paid_loans
WHERE notes LIKE '%Recuperado da tabela loans%';

-- =====================================================
-- OPÇÃO 3: RECUPERAR DE PAGAMENTOS FINAIS
-- =====================================================

-- Criar temporary table com empréstimos que tiveram pagamento final
CREATE TEMP TABLE temp_recovered_loans AS
SELECT DISTINCT
    p.loan_id,
    l.client_id,
    l.amount as original_amount,
    l.interest_rate,
    l.amount + (l.amount * l.interest_rate / 100) as total_with_interest,
    l.loan_date,
    l.due_date,
    MAX(p.payment_date) as paid_date,
    SUM(p.amount) as total_paid,
    STRING_AGG(DISTINCT p.payment_method, ', ') as payment_method,
    'Recuperado de pagamentos - marcado como pagamento final' as notes,
    l.created_by,
    MIN(p.created_at) as created_at
FROM payments p
INNER JOIN loans l ON l.id = p.loan_id
WHERE p.is_final_payment = true
GROUP BY p.loan_id, l.client_id, l.amount, l.interest_rate, l.loan_date, l.due_date, l.created_by
HAVING NOT EXISTS (
    SELECT 1 FROM paid_loans pl WHERE pl.loan_id = p.loan_id
);

-- Inserir na tabela paid_loans
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
    payment_method,
    notes,
    created_by,
    created_at
)
SELECT * FROM temp_recovered_loans
ON CONFLICT (loan_id) DO NOTHING;

-- Mostrar resultado
SELECT 
    COUNT(*) as emprestimos_de_pagamentos,
    'Empréstimos recuperados de pagamentos finais' as descricao
FROM temp_recovered_loans;

-- Limpar temporary table
DROP TABLE IF EXISTS temp_recovered_loans;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Mostrar resumo dos empréstimos quitados recuperados
SELECT 
    'Total de empréstimos quitados' as descricao,
    COUNT(*) as quantidade,
    SUM(original_amount) as valor_original_total,
    SUM(total_paid) as valor_pago_total
FROM paid_loans;

-- Listar os últimos 20 empréstimos quitados
SELECT 
    pl.id,
    c.name as cliente,
    pl.original_amount,
    pl.interest_rate,
    pl.paid_date,
    pl.total_paid,
    pl.notes
FROM paid_loans pl
LEFT JOIN clients c ON c.id = pl.client_id
ORDER BY pl.paid_date DESC
LIMIT 20;

-- =====================================================
-- PRÓXIMOS PASSOS
-- =====================================================

/*
APÓS EXECUTAR ESTE SCRIPT:

1. Verifique se os empréstimos quitados aparecem no sistema
2. Se ainda não aparecerem, execute o diagnóstico novamente
3. Verifique as políticas RLS se houver problemas de permissão
4. Se necessário, desabilite temporariamente o RLS para teste:
   
   ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;
   
   (Não esqueça de reabilitar depois!)

5. Se os dados foram perdidos permanentemente e não há backup,
   você pode tentar recuperar do histórico de pagamentos
   manualmente usando as queries acima

6. Considere fazer backup regular da tabela paid_loans:
   
   -- Criar backup
   CREATE TABLE paid_loans_backup AS SELECT * FROM paid_loans;
*/

-- =====================================================
-- FIM DO SCRIPT DE RECUPERAÇÃO
-- =====================================================
