-- =====================================================
-- TABELA DE PARCELAMENTOS - NEXUS GESTÃO FINANCEIRA
-- =====================================================
-- Execute estes comandos no SQL Editor do Supabase
-- =====================================================

-- =====================================================
-- TABELA DE PARCELAMENTOS
-- =====================================================
CREATE TABLE IF NOT EXISTS installments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    loan_id UUID NOT NULL REFERENCES loans(id) ON DELETE CASCADE,
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    total_amount DECIMAL(15,2) NOT NULL,
    total_installments INTEGER NOT NULL CHECK (total_installments > 0),
    installment_amount DECIMAL(15,2) NOT NULL,
    first_due_date DATE NOT NULL,
    interest_rate DECIMAL(5,2) DEFAULT 0.00,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentários da tabela de parcelamentos
COMMENT ON TABLE installments IS 'Tabela para armazenar planos de parcelamento de empréstimos vencidos';
COMMENT ON COLUMN installments.id IS 'Identificador único do parcelamento';
COMMENT ON COLUMN installments.loan_id IS 'Referência ao empréstimo original que está sendo parcelado';
COMMENT ON COLUMN installments.client_id IS 'Referência ao cliente que possui o parcelamento';
COMMENT ON COLUMN installments.total_amount IS 'Valor total a ser parcelado';
COMMENT ON COLUMN installments.total_installments IS 'Número total de parcelas';
COMMENT ON COLUMN installments.installment_amount IS 'Valor de cada parcela';
COMMENT ON COLUMN installments.first_due_date IS 'Data de vencimento da primeira parcela';
COMMENT ON COLUMN installments.interest_rate IS 'Taxa de juros aplicada ao parcelamento (%)';
COMMENT ON COLUMN installments.status IS 'Status do parcelamento (active, completed, cancelled)';
COMMENT ON COLUMN installments.notes IS 'Observações sobre o parcelamento';
COMMENT ON COLUMN installments.created_by IS 'Usuário que criou o parcelamento';
COMMENT ON COLUMN installments.created_at IS 'Data de criação do parcelamento';
COMMENT ON COLUMN installments.updated_at IS 'Data da última atualização';

-- =====================================================
-- TABELA DE PARCELAS INDIVIDUAIS
-- =====================================================
CREATE TABLE IF NOT EXISTS installment_payments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    installment_id UUID NOT NULL REFERENCES installments(id) ON DELETE CASCADE,
    installment_number INTEGER NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    due_date DATE NOT NULL,
    paid_date DATE,
    paid_amount DECIMAL(15,2) DEFAULT 0.00,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'overdue', 'partial')),
    payment_method TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(installment_id, installment_number)
);

-- Comentários da tabela de parcelas individuais
COMMENT ON TABLE installment_payments IS 'Tabela para armazenar cada parcela individual de um parcelamento';
COMMENT ON COLUMN installment_payments.id IS 'Identificador único da parcela';
COMMENT ON COLUMN installment_payments.installment_id IS 'Referência ao plano de parcelamento';
COMMENT ON COLUMN installment_payments.installment_number IS 'Número da parcela (1, 2, 3, etc.)';
COMMENT ON COLUMN installment_payments.amount IS 'Valor da parcela';
COMMENT ON COLUMN installment_payments.due_date IS 'Data de vencimento da parcela';
COMMENT ON COLUMN installment_payments.paid_date IS 'Data em que a parcela foi paga';
COMMENT ON COLUMN installment_payments.paid_amount IS 'Valor efetivamente pago da parcela';
COMMENT ON COLUMN installment_payments.status IS 'Status da parcela (pending, paid, overdue, partial)';
COMMENT ON COLUMN installment_payments.payment_method IS 'Método de pagamento utilizado';
COMMENT ON COLUMN installment_payments.notes IS 'Observações sobre o pagamento da parcela';
COMMENT ON COLUMN installment_payments.created_at IS 'Data de criação da parcela';
COMMENT ON COLUMN installment_payments.updated_at IS 'Data da última atualização';

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_installments_loan_id ON installments(loan_id);
CREATE INDEX IF NOT EXISTS idx_installments_client_id ON installments(client_id);
CREATE INDEX IF NOT EXISTS idx_installments_status ON installments(status);
CREATE INDEX IF NOT EXISTS idx_installments_created_at ON installments(created_at);

CREATE INDEX IF NOT EXISTS idx_installment_payments_installment_id ON installment_payments(installment_id);
CREATE INDEX IF NOT EXISTS idx_installment_payments_due_date ON installment_payments(due_date);
CREATE INDEX IF NOT EXISTS idx_installment_payments_status ON installment_payments(status);
CREATE INDEX IF NOT EXISTS idx_installment_payments_paid_date ON installment_payments(paid_date);

-- =====================================================
-- FUNÇÃO PARA ATUALIZAR updated_at AUTOMATICAMENTE
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para atualizar updated_at automaticamente
DROP TRIGGER IF EXISTS update_installments_updated_at ON installments;
CREATE TRIGGER update_installments_updated_at
    BEFORE UPDATE ON installments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_installment_payments_updated_at ON installment_payments;
CREATE TRIGGER update_installment_payments_updated_at
    BEFORE UPDATE ON installment_payments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- FUNCTION TO UPDATE INSTALLMENT STATUS AUTOMATICALLY
-- =====================================================
CREATE OR REPLACE FUNCTION update_installment_status()
RETURNS TRIGGER AS $$
DECLARE
    total_parcelas INTEGER;
    parcelas_pagas INTEGER;
BEGIN
    -- Get total installments and paid installments count
    SELECT 
        i.total_installments,
        COUNT(CASE WHEN ip.status = 'paid' THEN 1 END)
    INTO total_parcelas, parcelas_pagas
    FROM installments i
    LEFT JOIN installment_payments ip ON i.id = ip.installment_id
    WHERE i.id = NEW.installment_id
    GROUP BY i.total_installments;
    
    -- Update installment status based on payment status
    IF parcelas_pagas = total_parcelas THEN
        UPDATE installments 
        SET status = 'completed', updated_at = NOW()
        WHERE id = NEW.installment_id;
    ELSIF parcelas_pagas > 0 THEN
        UPDATE installments 
        SET status = 'active', updated_at = NOW()
        WHERE id = NEW.installment_id;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update installment status when payments are made
DROP TRIGGER IF EXISTS trigger_update_installment_status ON installment_payments;
CREATE TRIGGER trigger_update_installment_status
    AFTER INSERT OR UPDATE ON installment_payments
    FOR EACH ROW
    EXECUTE FUNCTION update_installment_status();

-- =====================================================
-- RLS (ROW LEVEL SECURITY) POLICIES
-- =====================================================
-- Enable RLS
ALTER TABLE installments ENABLE ROW LEVEL SECURITY;
ALTER TABLE installment_payments ENABLE ROW LEVEL SECURITY;

-- Policy for installments - users can see all installments they created or if they are admin
CREATE POLICY "Users can view installments" ON installments
    FOR SELECT USING (
        auth.uid() = created_by OR 
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid() 
            AND users.role = 'admin'
        )
    );

-- Policy for installments - users can insert installments
CREATE POLICY "Users can create installments" ON installments
    FOR INSERT WITH CHECK (auth.uid() = created_by);

-- Policy for installments - users can update their own installments or admins can update any
CREATE POLICY "Users can update installments" ON installments
    FOR UPDATE USING (
        auth.uid() = created_by OR 
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid() 
            AND users.role = 'admin'
        )
    );

-- Similar policies for installment_payments
CREATE POLICY "Users can view installment payments" ON installment_payments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM installments 
            WHERE installments.id = installment_payments.installment_id 
            AND (
                installments.created_by = auth.uid() OR 
                EXISTS (
                    SELECT 1 FROM users 
                    WHERE users.id = auth.uid() 
                    AND users.role = 'admin'
                )
            )
        )
    );

CREATE POLICY "Users can create installment payments" ON installment_payments
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM installments 
            WHERE installments.id = installment_payments.installment_id 
            AND installments.created_by = auth.uid()
        )
    );

CREATE POLICY "Users can update installment payments" ON installment_payments
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM installments 
            WHERE installments.id = installment_payments.installment_id 
            AND (
                installments.created_by = auth.uid() OR 
                EXISTS (
                    SELECT 1 FROM users 
                    WHERE users.id = auth.uid() 
                    AND users.role = 'admin'
                )
            )
        )
    );

-- =====================================================
-- SAMPLE DATA (OPTIONAL - REMOVE IF NOT NEEDED)
-- =====================================================
-- INSERT INTO installments (loan_id, client_id, total_amount, total_installments, installment_amount, first_due_date, interest_rate, created_by, notes) VALUES
-- ('LOAN_ID_HERE', 'CLIENT_ID_HERE', 1000.00, 10, 100.00, '2024-02-01', 2.5, 'USER_ID_HERE', 'Parcelamento de empréstimo vencido em 10x');