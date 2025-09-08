-- =====================================================
-- OTIMIZAÇÃO DE PERFORMANCE - ÍNDICES ADICIONAIS
-- =====================================================
-- Execute este script para melhorar a performance das consultas

-- Índices para a tabela de clientes
CREATE INDEX IF NOT EXISTS idx_clients_name ON clients(name);
CREATE INDEX IF NOT EXISTS idx_clients_created_at ON clients(created_at DESC);

-- Índices para a tabela de empréstimos
CREATE INDEX IF NOT EXISTS idx_loans_client_id ON loans(client_id);
CREATE INDEX IF NOT EXISTS idx_loans_status ON loans(status);
CREATE INDEX IF NOT EXISTS idx_loans_due_date ON loans(due_date);
CREATE INDEX IF NOT EXISTS idx_loans_created_at ON loans(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_loans_status_due_date ON loans(status, due_date);

-- Índices para a tabela de pagamentos
CREATE INDEX IF NOT EXISTS idx_payments_loan_id ON payments(loan_id);
CREATE INDEX IF NOT EXISTS idx_payments_payment_date ON payments(payment_date DESC);

-- Índices para a tabela de despesas
CREATE INDEX IF NOT EXISTS idx_expenses_user_id ON expenses(user_id);
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date DESC);
CREATE INDEX IF NOT EXISTS idx_expenses_category_id ON expenses(category_id);

-- Índices para avalistas
CREATE INDEX IF NOT EXISTS idx_guarantors_client_id ON guarantors(client_id);
CREATE INDEX IF NOT EXISTS idx_guarantors_created_at ON guarantors(created_at DESC);

-- Índices para contatos de emergência
CREATE INDEX IF NOT EXISTS idx_emergency_contacts_client_id ON emergency_contacts(client_id);

-- Índices para parcelamentos
CREATE INDEX IF NOT EXISTS idx_installments_loan_id ON installments(loan_id);
CREATE INDEX IF NOT EXISTS idx_installments_status ON installments(status);
CREATE INDEX IF NOT EXISTS idx_installments_created_at ON installments(created_at DESC);

-- Índices para pagamentos de parcelamentos
CREATE INDEX IF NOT EXISTS idx_installment_payments_installment_id ON installment_payments(installment_id);
CREATE INDEX IF NOT EXISTS idx_installment_payments_due_date ON installment_payments(due_date);
CREATE INDEX IF NOT EXISTS idx_installment_payments_status ON installment_payments(status);

-- Índices para transações de caixa
CREATE INDEX IF NOT EXISTS idx_cash_transactions_type ON cash_transactions(type);
CREATE INDEX IF NOT EXISTS idx_cash_transactions_created_at ON cash_transactions(created_at DESC);

-- Índices para documentos de clientes
CREATE INDEX IF NOT EXISTS idx_client_documents_client_id ON client_documents(client_id);
CREATE INDEX IF NOT EXISTS idx_client_documents_created_at ON client_documents(created_at DESC);

COMMENT ON INDEX idx_clients_name IS 'Índice para busca por nome de clientes';
COMMENT ON INDEX idx_loans_status_due_date IS 'Índice composto para consultas de empréstimos por status e data de vencimento';
COMMENT ON INDEX idx_loans_created_at IS 'Índice para ordenação por data de criação (mais recentes primeiro)';