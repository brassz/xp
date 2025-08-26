-- =====================================================
-- CONFIGURAÇÃO DA TABELA CANCELLED_LOANS
-- =====================================================
-- Execute este script no SQL Editor do Supabase
-- =====================================================

-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABELA DE EMPRÉSTIMOS CANCELADOS
-- =====================================================

-- Criar tabela se não existir
CREATE TABLE IF NOT EXISTS cancelled_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID NOT NULL,
    client_id UUID NOT NULL,
    original_amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    total_with_interest DECIMAL(10,2) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    cancellation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    cancellation_reason TEXT NOT NULL DEFAULT 'Cancelado pelo usuário',
    total_paid_before_cancellation DECIMAL(10,2) DEFAULT 0,
    refund_amount DECIMAL(10,2) DEFAULT 0,
    cancellation_fee DECIMAL(10,2) DEFAULT 0,
    cancelled_by UUID,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela
COMMENT ON TABLE cancelled_loans IS 'Tabela para armazenar empréstimos cancelados';
COMMENT ON COLUMN cancelled_loans.id IS 'Identificador único do registro de cancelamento';
COMMENT ON COLUMN cancelled_loans.loan_id IS 'ID original do empréstimo (para referência)';
COMMENT ON COLUMN cancelled_loans.client_id IS 'Referência ao cliente';
COMMENT ON COLUMN cancelled_loans.original_amount IS 'Valor original do empréstimo';
COMMENT ON COLUMN cancelled_loans.interest_rate IS 'Taxa de juros original';
COMMENT ON COLUMN cancelled_loans.total_with_interest IS 'Valor total com juros';
COMMENT ON COLUMN cancelled_loans.loan_date IS 'Data original do empréstimo';
COMMENT ON COLUMN cancelled_loans.due_date IS 'Data de vencimento original';
COMMENT ON COLUMN cancelled_loans.cancellation_date IS 'Data em que foi cancelado';
COMMENT ON COLUMN cancelled_loans.cancellation_reason IS 'Motivo do cancelamento';
COMMENT ON COLUMN cancelled_loans.total_paid_before_cancellation IS 'Total pago antes do cancelamento';
COMMENT ON COLUMN cancelled_loans.refund_amount IS 'Valor a ser reembolsado';
COMMENT ON COLUMN cancelled_loans.cancellation_fee IS 'Taxa de cancelamento aplicada';
COMMENT ON COLUMN cancelled_loans.cancelled_by IS 'Usuário que cancelou o empréstimo';
COMMENT ON COLUMN cancelled_loans.created_by IS 'Usuário que criou o empréstimo original';

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_cancelled_loans_loan_id ON cancelled_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_cancelled_loans_client_id ON cancelled_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_cancelled_loans_cancellation_date ON cancelled_loans(cancellation_date);
CREATE INDEX IF NOT EXISTS idx_cancelled_loans_cancelled_by ON cancelled_loans(cancelled_by);
CREATE INDEX IF NOT EXISTS idx_cancelled_loans_created_at ON cancelled_loans(created_at);

-- =====================================================
-- FUNÇÃO PARA ATUALIZAR UPDATED_AT
-- =====================================================

CREATE OR REPLACE FUNCTION update_cancelled_loans_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para atualizar updated_at automaticamente
CREATE TRIGGER update_cancelled_loans_updated_at_trigger
    BEFORE UPDATE ON cancelled_loans
    FOR EACH ROW
    EXECUTE FUNCTION update_cancelled_loans_updated_at();

-- =====================================================
-- VIEW PARA EMPRÉSTIMOS CANCELADOS COM DETALHES
-- =====================================================

CREATE OR REPLACE VIEW cancelled_loans_with_details AS
SELECT 
    cl.*,
    c.name as client_name,
    c.cpf as client_cpf,
    c.email as client_email,
    c.phone as client_phone,
    c.photo as client_photo,
    u_cancelled.full_name as cancelled_by_name,
    u_created.full_name as created_by_name
FROM cancelled_loans cl
JOIN clients c ON cl.client_id = c.id
LEFT JOIN users u_cancelled ON cl.cancelled_by = u_cancelled.id
LEFT JOIN users u_created ON cl.created_by = u_created.id
ORDER BY cl.cancellation_date DESC;

-- =====================================================
-- POLÍTICAS DE SEGURANÇA (RLS)
-- =====================================================

-- Habilitar RLS na tabela
ALTER TABLE cancelled_loans ENABLE ROW LEVEL SECURITY;

-- Políticas para empréstimos cancelados
CREATE POLICY "Authenticated users can view all cancelled loans" ON cancelled_loans
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert cancelled loans" ON cancelled_loans
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update cancelled loans they created or admins can update all" ON cancelled_loans
    FOR UPDATE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

CREATE POLICY "Users can delete cancelled loans they created or admins can delete all" ON cancelled_loans
    FOR DELETE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- =====================================================
-- PERMISSÕES
-- =====================================================

-- Conceder permissões para usuários autenticados
GRANT SELECT, INSERT, UPDATE, DELETE ON cancelled_loans TO authenticated;

-- Conceder permissões para a view
GRANT SELECT ON cancelled_loans_with_details TO authenticated;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar se a tabela foi criada
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'cancelled_loans';

-- Verificar se os índices foram criados
SELECT 
    indexname,
    tablename
FROM pg_indexes 
WHERE tablename = 'cancelled_loans'
ORDER BY indexname;

-- Verificar se as políticas RLS estão ativas
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE schemaname = 'public' AND tablename = 'cancelled_loans'
ORDER BY policyname;

-- =====================================================
-- FIM DA CONFIGURAÇÃO
-- =====================================================
-- 
-- Para executar este script:
-- 1. Acesse o SQL Editor no Supabase
-- 2. Cole todo o conteúdo deste arquivo
-- 3. Clique em "Run" para executar
-- 4. Verifique se não há erros na execução
-- 5. Confirme que a tabela foi criada corretamente
--
-- Após a execução, a funcionalidade de cancelamento estará disponível!
-- ===================================================== 