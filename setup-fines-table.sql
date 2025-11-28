-- =====================================================
-- TABELA DE MULTAS - NEXUS GESTÃO FINANCEIRA
-- =====================================================
-- Execute estes comandos no SQL Editor do Supabase
-- =====================================================

-- =====================================================
-- TABELA DE MULTAS
-- =====================================================
CREATE TABLE IF NOT EXISTS fines (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    loan_id UUID REFERENCES loans(id) ON DELETE SET NULL,
    installment_payment_id UUID REFERENCES installment_payments(id) ON DELETE SET NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    reason TEXT NOT NULL,
    fine_type TEXT DEFAULT 'late_payment' CHECK (fine_type IN ('late_payment', 'breach_of_contract', 'administrative', 'other')),
    fine_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    paid_date DATE,
    paid_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (paid_amount >= 0),
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'partial_paid', 'cancelled')),
    payment_method TEXT,
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela de multas
COMMENT ON TABLE fines IS 'Tabela para armazenar multas aplicadas aos clientes';
COMMENT ON COLUMN fines.id IS 'Identificador único da multa';
COMMENT ON COLUMN fines.client_id IS 'Referência ao cliente que recebeu a multa';
COMMENT ON COLUMN fines.loan_id IS 'Referência ao empréstimo relacionado (opcional)';
COMMENT ON COLUMN fines.installment_payment_id IS 'Referência à parcela relacionada (opcional)';
COMMENT ON COLUMN fines.amount IS 'Valor da multa';
COMMENT ON COLUMN fines.reason IS 'Motivo da aplicação da multa';
COMMENT ON COLUMN fines.fine_type IS 'Tipo de multa (atraso, quebra de contrato, administrativa, outros)';
COMMENT ON COLUMN fines.fine_date IS 'Data em que a multa foi aplicada';
COMMENT ON COLUMN fines.due_date IS 'Data de vencimento da multa';
COMMENT ON COLUMN fines.paid_date IS 'Data em que a multa foi paga';
COMMENT ON COLUMN fines.paid_amount IS 'Valor pago da multa';
COMMENT ON COLUMN fines.status IS 'Status da multa (pendente, paga, parcialmente paga, cancelada)';
COMMENT ON COLUMN fines.payment_method IS 'Método de pagamento utilizado';
COMMENT ON COLUMN fines.notes IS 'Observações sobre a multa';
COMMENT ON COLUMN fines.created_by IS 'Usuário que criou a multa';
COMMENT ON COLUMN fines.created_at IS 'Data de criação do registro';
COMMENT ON COLUMN fines.updated_at IS 'Data da última atualização';

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_fines_client_id ON fines(client_id);
CREATE INDEX IF NOT EXISTS idx_fines_loan_id ON fines(loan_id);
CREATE INDEX IF NOT EXISTS idx_fines_installment_payment_id ON fines(installment_payment_id);
CREATE INDEX IF NOT EXISTS idx_fines_status ON fines(status);
CREATE INDEX IF NOT EXISTS idx_fines_fine_date ON fines(fine_date);
CREATE INDEX IF NOT EXISTS idx_fines_due_date ON fines(due_date);
CREATE INDEX IF NOT EXISTS idx_fines_created_at ON fines(created_at);
CREATE INDEX IF NOT EXISTS idx_fines_created_by ON fines(created_by);

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Trigger para atualizar updated_at automaticamente
CREATE TRIGGER update_fines_updated_at
    BEFORE UPDATE ON fines
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Função para atualizar status da multa baseado no pagamento
CREATE OR REPLACE FUNCTION update_fine_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Se o valor pago é igual ao valor da multa, marcar como paga
    IF NEW.paid_amount >= NEW.amount THEN
        NEW.status = 'paid';
        IF NEW.paid_date IS NULL THEN
            NEW.paid_date = CURRENT_DATE;
        END IF;
    -- Se o valor pago é maior que 0 mas menor que o valor total, marcar como parcialmente paga
    ELSIF NEW.paid_amount > 0 AND NEW.paid_amount < NEW.amount THEN
        NEW.status = 'partial_paid';
    -- Se não há valor pago e está vencida, manter como pendente
    ELSE
        IF NEW.status != 'cancelled' THEN
            NEW.status = 'pending';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para atualizar status automaticamente
DROP TRIGGER IF EXISTS trigger_update_fine_status ON fines;
CREATE TRIGGER trigger_update_fine_status
    BEFORE INSERT OR UPDATE OF paid_amount ON fines
    FOR EACH ROW
    EXECUTE FUNCTION update_fine_status();

-- =====================================================
-- VIEW UNIFICADA DE HISTÓRICO DE PAGAMENTOS
-- =====================================================
-- Esta view combina pagamentos, parcelas e multas em um único histórico

CREATE OR REPLACE VIEW client_payment_history AS
-- Pagamentos regulares de empréstimos
SELECT 
    p.id,
    p.loan_id,
    l.client_id,
    c.name as client_name,
    c.cpf as client_cpf,
    'payment' as transaction_type,
    'Pagamento de Empréstimo' as transaction_description,
    p.amount,
    p.payment_date as transaction_date,
    p.payment_type,
    'paid' as status,
    p.notes,
    p.created_by,
    u.full_name as created_by_name,
    p.created_at,
    l.amount as loan_amount,
    l.total_amount as loan_total_amount
FROM payments p
JOIN loans l ON p.loan_id = l.id
JOIN clients c ON l.client_id = c.id
LEFT JOIN users u ON p.created_by = u.id

UNION ALL

-- Pagamentos de parcelas
SELECT 
    ip.id,
    i.loan_id,
    i.client_id,
    c.name as client_name,
    c.cpf as client_cpf,
    'installment_payment' as transaction_type,
    CONCAT('Parcela ', ip.installment_number, '/', i.total_installments) as transaction_description,
    ip.paid_amount as amount,
    ip.paid_date as transaction_date,
    'installment' as payment_type,
    ip.status,
    ip.notes,
    i.created_by,
    u.full_name as created_by_name,
    ip.created_at,
    NULL as loan_amount,
    i.total_amount as loan_total_amount
FROM installment_payments ip
JOIN installments i ON ip.installment_id = i.id
JOIN clients c ON i.client_id = c.id
LEFT JOIN users u ON i.created_by = u.id
WHERE ip.paid_date IS NOT NULL

UNION ALL

-- Multas aplicadas
SELECT 
    f.id,
    f.loan_id,
    f.client_id,
    c.name as client_name,
    c.cpf as client_cpf,
    'fine' as transaction_type,
    CONCAT('Multa - ', f.reason) as transaction_description,
    f.amount,
    COALESCE(f.paid_date, f.fine_date) as transaction_date,
    'fine' as payment_type,
    f.status,
    f.notes,
    f.created_by,
    u.full_name as created_by_name,
    f.created_at,
    NULL as loan_amount,
    NULL as loan_total_amount
FROM fines f
JOIN clients c ON f.client_id = c.id
LEFT JOIN users u ON f.created_by = u.id

ORDER BY transaction_date DESC;

-- Comentário da view
COMMENT ON VIEW client_payment_history IS 'View unificada que combina pagamentos, parcelas e multas no histórico do cliente';

-- =====================================================
-- VIEW DE MULTAS PENDENTES
-- =====================================================
CREATE OR REPLACE VIEW pending_fines AS
SELECT 
    f.id,
    f.client_id,
    c.name as client_name,
    c.cpf as client_cpf,
    c.phone as client_phone,
    c.email as client_email,
    f.amount,
    f.paid_amount,
    (f.amount - f.paid_amount) as remaining_amount,
    f.reason,
    f.fine_type,
    f.fine_date,
    f.due_date,
    CASE 
        WHEN f.due_date < CURRENT_DATE THEN CURRENT_DATE - f.due_date
        ELSE 0
    END as days_overdue,
    f.status,
    f.loan_id,
    l.amount as loan_amount,
    u.full_name as created_by_name,
    f.created_at
FROM fines f
JOIN clients c ON f.client_id = c.id
LEFT JOIN loans l ON f.loan_id = l.id
LEFT JOIN users u ON f.created_by = u.id
WHERE f.status IN ('pending', 'partial_paid')
ORDER BY f.due_date ASC;

-- Comentário da view
COMMENT ON VIEW pending_fines IS 'View de multas pendentes e parcialmente pagas';

-- =====================================================
-- VIEW DE RESUMO DE MULTAS POR CLIENTE
-- =====================================================
CREATE OR REPLACE VIEW client_fines_summary AS
SELECT 
    c.id as client_id,
    c.name as client_name,
    c.cpf as client_cpf,
    COUNT(f.id) as total_fines,
    COUNT(CASE WHEN f.status = 'pending' THEN 1 END) as pending_fines,
    COUNT(CASE WHEN f.status = 'partial_paid' THEN 1 END) as partial_paid_fines,
    COUNT(CASE WHEN f.status = 'paid' THEN 1 END) as paid_fines,
    COUNT(CASE WHEN f.status = 'cancelled' THEN 1 END) as cancelled_fines,
    COALESCE(SUM(f.amount), 0) as total_fines_amount,
    COALESCE(SUM(f.paid_amount), 0) as total_paid_amount,
    COALESCE(SUM(f.amount - f.paid_amount), 0) as total_outstanding_amount
FROM clients c
LEFT JOIN fines f ON c.id = f.client_id
GROUP BY c.id, c.name, c.cpf
ORDER BY total_outstanding_amount DESC;

-- Comentário da view
COMMENT ON VIEW client_fines_summary IS 'Resumo de multas por cliente';

-- =====================================================
-- RLS (ROW LEVEL SECURITY) POLICIES
-- =====================================================
ALTER TABLE fines ENABLE ROW LEVEL SECURITY;

-- Política para visualizar multas - usuários autenticados podem ver todas
CREATE POLICY "Authenticated users can view all fines" ON fines
    FOR SELECT USING (auth.role() = 'authenticated');

-- Política para inserir multas - usuários autenticados podem criar
CREATE POLICY "Authenticated users can insert fines" ON fines
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Política para atualizar multas - criador ou admin
CREATE POLICY "Users can update fines they created or admins can update all" ON fines
    FOR UPDATE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- Política para deletar multas - criador ou admin
CREATE POLICY "Users can delete fines they created or admins can delete all" ON fines
    FOR DELETE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- =====================================================
-- FUNÇÃO PARA CRIAR MULTA POR ATRASO AUTOMATICAMENTE
-- =====================================================
CREATE OR REPLACE FUNCTION calculate_late_fine(
    p_loan_id UUID,
    p_days_late INTEGER,
    p_fine_rate DECIMAL DEFAULT 0.02
)
RETURNS DECIMAL AS $$
DECLARE
    v_loan_amount DECIMAL;
    v_fine_amount DECIMAL;
BEGIN
    -- Buscar o valor do empréstimo
    SELECT amount INTO v_loan_amount
    FROM loans
    WHERE id = p_loan_id;
    
    -- Calcular multa (2% ao dia sobre o valor do empréstimo, por exemplo)
    v_fine_amount := v_loan_amount * p_fine_rate * p_days_late;
    
    RETURN v_fine_amount;
END;
$$ LANGUAGE plpgsql;

-- Comentário da função
COMMENT ON FUNCTION calculate_late_fine IS 'Calcula o valor da multa por atraso baseado nos dias de atraso e taxa';

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar se a tabela foi criada
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'fines';

-- Verificar colunas da tabela
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'fines'
ORDER BY ordinal_position;

-- Verificar índices
SELECT 
    indexname,
    tablename
FROM pg_indexes 
WHERE tablename = 'fines'
ORDER BY indexname;

-- Verificar views criadas
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('client_payment_history', 'pending_fines', 'client_fines_summary')
ORDER BY table_name;

-- =====================================================
-- FIM DA CONFIGURAÇÃO
-- =====================================================
