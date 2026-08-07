-- =====================================================
-- CRIAÇÃO DA TABELA PAID_LOANS
-- =====================================================
-- Execute este script SE a tabela não existir
-- =====================================================

SELECT '🔧 Criando tabela paid_loans...' as status;

-- Criar extensão UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Criar a tabela
CREATE TABLE IF NOT EXISTS paid_loans (
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

SELECT '✅ Tabela criada!' as status;

-- Criar índices
CREATE INDEX IF NOT EXISTS idx_paid_loans_loan_id ON paid_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_client_id ON paid_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_paid_date ON paid_loans(paid_date);

SELECT '✅ Índices criados!' as status;

-- Verificar se foi criada
SELECT 
    '🎉 RESULTADO:' as status,
    CASE 
        WHEN EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'paid_loans')
        THEN '✅ Tabela paid_loans criada com sucesso!'
        ELSE '❌ Erro - tabela não foi criada'
    END as resultado;
