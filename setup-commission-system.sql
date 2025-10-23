-- =====================================================
-- SISTEMA DE COMISSÕES NEXUS
-- =====================================================
-- Sistema para calcular comissões baseadas nos juros
-- de empréstimos e parcelamentos
-- =====================================================

-- =====================================================
-- TABELA DE CONFIGURAÇÃO DE COMISSÕES
-- =====================================================
CREATE TABLE IF NOT EXISTS commission_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    commission_rate DECIMAL(5,2) NOT NULL CHECK (commission_rate >= 0 AND commission_rate <= 100),
    applies_to TEXT[] NOT NULL DEFAULT '{"loans", "installments"}' CHECK (
        applies_to <@ ARRAY['loans', 'installments', 'capital_raising']
    ),
    is_active BOOLEAN DEFAULT true,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE commission_settings IS 'Configurações de taxas de comissão para diferentes tipos de operações';
COMMENT ON COLUMN commission_settings.name IS 'Nome da configuração de comissão';
COMMENT ON COLUMN commission_settings.commission_rate IS 'Taxa de comissão em porcentagem sobre os juros';
COMMENT ON COLUMN commission_settings.applies_to IS 'Tipos de operação que esta comissão se aplica';

-- =====================================================
-- TABELA DE COMISSÕES CALCULADAS
-- =====================================================
CREATE TABLE IF NOT EXISTS commissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    reference_id UUID NOT NULL,
    reference_type TEXT NOT NULL CHECK (reference_type IN ('loan', 'installment', 'capital_raising')),
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),
    commission_setting_id UUID REFERENCES commission_settings(id),
    
    -- Valores base para cálculo
    principal_amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    interest_amount DECIMAL(15,2) NOT NULL,
    
    -- Comissão calculada
    commission_rate DECIMAL(5,2) NOT NULL,
    commission_amount DECIMAL(15,2) NOT NULL,
    
    -- Datas
    operation_date DATE NOT NULL,
    due_date DATE,
    paid_date DATE,
    
    -- Status
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'cancelled')),
    
    -- Metadados
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE commissions IS 'Comissões calculadas sobre os juros de empréstimos e parcelamentos';
COMMENT ON COLUMN commissions.reference_id IS 'ID da operação que gerou a comissão (loan_id, installment_id, etc)';
COMMENT ON COLUMN commissions.reference_type IS 'Tipo da operação (loan, installment, capital_raising)';
COMMENT ON COLUMN commissions.principal_amount IS 'Valor principal da operação';
COMMENT ON COLUMN commissions.interest_amount IS 'Valor dos juros da operação';
COMMENT ON COLUMN commissions.commission_amount IS 'Valor da comissão calculada';

-- =====================================================
-- TABELA DE PAGAMENTOS DE COMISSÕES
-- =====================================================
CREATE TABLE IF NOT EXISTS commission_payments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    commission_id UUID NOT NULL REFERENCES commissions(id) ON DELETE CASCADE,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    payment_method TEXT DEFAULT 'cash' CHECK (payment_method IN ('cash', 'pix', 'transfer', 'check', 'other')),
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE commission_payments IS 'Histórico de pagamentos de comissões';

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_commission_settings_active ON commission_settings(is_active);
CREATE INDEX IF NOT EXISTS idx_commission_settings_applies_to ON commission_settings USING GIN(applies_to);

CREATE INDEX IF NOT EXISTS idx_commissions_reference ON commissions(reference_id, reference_type);
CREATE INDEX IF NOT EXISTS idx_commissions_client_id ON commissions(client_id);
CREATE INDEX IF NOT EXISTS idx_commissions_user_id ON commissions(user_id);
CREATE INDEX IF NOT EXISTS idx_commissions_status ON commissions(status);
CREATE INDEX IF NOT EXISTS idx_commissions_operation_date ON commissions(operation_date);
CREATE INDEX IF NOT EXISTS idx_commissions_due_date ON commissions(due_date);
CREATE INDEX IF NOT EXISTS idx_commissions_paid_date ON commissions(paid_date);

CREATE INDEX IF NOT EXISTS idx_commission_payments_commission_id ON commission_payments(commission_id);
CREATE INDEX IF NOT EXISTS idx_commission_payments_payment_date ON commission_payments(payment_date);

-- =====================================================
-- TRIGGERS PARA ATUALIZAÇÃO AUTOMÁTICA
-- =====================================================

-- Trigger para updated_at
CREATE TRIGGER update_commission_settings_updated_at 
    BEFORE UPDATE ON commission_settings 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_commissions_updated_at 
    BEFORE UPDATE ON commissions 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- FUNÇÕES PARA CÁLCULO DE COMISSÕES
-- =====================================================

-- Função para calcular comissão de empréstimo
CREATE OR REPLACE FUNCTION calculate_loan_commission(
    loan_id_param UUID,
    commission_setting_id_param UUID DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    loan_record RECORD;
    commission_setting RECORD;
    commission_id UUID;
    interest_amount DECIMAL(15,2);
    commission_amount DECIMAL(15,2);
BEGIN
    -- Buscar dados do empréstimo
    SELECT * INTO loan_record FROM loans WHERE id = loan_id_param;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Empréstimo não encontrado: %', loan_id_param;
    END IF;
    
    -- Buscar configuração de comissão
    IF commission_setting_id_param IS NULL THEN
        SELECT * INTO commission_setting 
        FROM commission_settings 
        WHERE is_active = true 
        AND 'loans' = ANY(applies_to)
        ORDER BY created_at DESC 
        LIMIT 1;
    ELSE
        SELECT * INTO commission_setting 
        FROM commission_settings 
        WHERE id = commission_setting_id_param AND is_active = true;
    END IF;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Configuração de comissão não encontrada';
    END IF;
    
    -- Calcular valores
    interest_amount := loan_record.amount * loan_record.interest_rate / 100;
    commission_amount := interest_amount * commission_setting.commission_rate / 100;
    
    -- Inserir ou atualizar comissão
    INSERT INTO commissions (
        reference_id, reference_type, client_id, user_id, commission_setting_id,
        principal_amount, interest_rate, interest_amount,
        commission_rate, commission_amount,
        operation_date, due_date, created_by
    ) VALUES (
        loan_record.id, 'loan', loan_record.client_id, loan_record.created_by, commission_setting.id,
        loan_record.amount, loan_record.interest_rate, interest_amount,
        commission_setting.commission_rate, commission_amount,
        loan_record.loan_date, loan_record.due_date, loan_record.created_by
    )
    ON CONFLICT (reference_id, reference_type) DO UPDATE SET
        commission_rate = commission_setting.commission_rate,
        commission_amount = interest_amount * commission_setting.commission_rate / 100,
        updated_at = NOW()
    RETURNING id INTO commission_id;
    
    RETURN commission_id;
END;
$$ LANGUAGE plpgsql;

-- Função para calcular comissão de parcelamento
CREATE OR REPLACE FUNCTION calculate_installment_commission(
    installment_id_param UUID,
    commission_setting_id_param UUID DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    installment_record RECORD;
    commission_setting RECORD;
    commission_id UUID;
    interest_amount DECIMAL(15,2);
    commission_amount DECIMAL(15,2);
BEGIN
    -- Buscar dados do parcelamento
    SELECT * INTO installment_record FROM installments WHERE id = installment_id_param;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Parcelamento não encontrado: %', installment_id_param;
    END IF;
    
    -- Buscar configuração de comissão
    IF commission_setting_id_param IS NULL THEN
        SELECT * INTO commission_setting 
        FROM commission_settings 
        WHERE is_active = true 
        AND 'installments' = ANY(applies_to)
        ORDER BY created_at DESC 
        LIMIT 1;
    ELSE
        SELECT * INTO commission_setting 
        FROM commission_settings 
        WHERE id = commission_setting_id_param AND is_active = true;
    END IF;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Configuração de comissão não encontrada';
    END IF;
    
    -- Calcular valores (assumindo que total_amount já inclui juros)
    interest_amount := installment_record.total_amount * installment_record.interest_rate / 100;
    commission_amount := interest_amount * commission_setting.commission_rate / 100;
    
    -- Inserir ou atualizar comissão
    INSERT INTO commissions (
        reference_id, reference_type, client_id, user_id, commission_setting_id,
        principal_amount, interest_rate, interest_amount,
        commission_rate, commission_amount,
        operation_date, due_date, created_by
    ) VALUES (
        installment_record.id, 'installment', installment_record.client_id, installment_record.created_by, commission_setting.id,
        installment_record.total_amount, installment_record.interest_rate, interest_amount,
        commission_setting.commission_rate, commission_amount,
        installment_record.created_at::date, installment_record.first_due_date, installment_record.created_by
    )
    ON CONFLICT (reference_id, reference_type) DO UPDATE SET
        commission_rate = commission_setting.commission_rate,
        commission_amount = interest_amount * commission_setting.commission_rate / 100,
        updated_at = NOW()
    RETURNING id INTO commission_id;
    
    RETURN commission_id;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- TRIGGERS AUTOMÁTICOS PARA CALCULAR COMISSÕES
-- =====================================================

-- Trigger para calcular comissão automaticamente ao criar/atualizar empréstimo
CREATE OR REPLACE FUNCTION auto_calculate_loan_commission()
RETURNS TRIGGER AS $$
BEGIN
    -- Só calcular se o empréstimo está ativo
    IF NEW.status IN ('active', 'overdue', 'partial_paid') THEN
        PERFORM calculate_loan_commission(NEW.id);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_auto_calculate_loan_commission
    AFTER INSERT OR UPDATE ON loans
    FOR EACH ROW
    EXECUTE FUNCTION auto_calculate_loan_commission();

-- Trigger para calcular comissão automaticamente ao criar/atualizar parcelamento
CREATE OR REPLACE FUNCTION auto_calculate_installment_commission()
RETURNS TRIGGER AS $$
BEGIN
    -- Só calcular se o parcelamento está ativo
    IF NEW.status = 'active' THEN
        PERFORM calculate_installment_commission(NEW.id);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_auto_calculate_installment_commission
    AFTER INSERT OR UPDATE ON installments
    FOR EACH ROW
    EXECUTE FUNCTION auto_calculate_installment_commission();

-- =====================================================
-- VIEWS PARA RELATÓRIOS DE COMISSÕES
-- =====================================================

-- View para comissões com detalhes completos
CREATE OR REPLACE VIEW commissions_with_details AS
SELECT 
    c.*,
    cl.name as client_name,
    cl.cpf as client_cpf,
    u.full_name as user_name,
    cs.name as commission_setting_name,
    cs.description as commission_setting_description,
    cb.full_name as created_by_name,
    
    -- Informações específicas por tipo
    CASE 
        WHEN c.reference_type = 'loan' THEN 
            (SELECT json_build_object(
                'loan_date', l.loan_date,
                'due_date', l.due_date,
                'status', l.status,
                'total_amount', l.total_amount
            ) FROM loans l WHERE l.id = c.reference_id)
        WHEN c.reference_type = 'installment' THEN 
            (SELECT json_build_object(
                'total_installments', i.total_installments,
                'installment_amount', i.installment_amount,
                'first_due_date', i.first_due_date,
                'status', i.status
            ) FROM installments i WHERE i.id = c.reference_id)
        ELSE NULL
    END as reference_details
    
FROM commissions c
JOIN clients cl ON c.client_id = cl.id
LEFT JOIN users u ON c.user_id = u.id
LEFT JOIN commission_settings cs ON c.commission_setting_id = cs.id
LEFT JOIN users cb ON c.created_by = cb.id;

-- View para resumo de comissões por período
CREATE OR REPLACE VIEW commission_summary_by_period AS
SELECT 
    DATE_TRUNC('month', operation_date) as period,
    reference_type,
    status,
    COUNT(*) as total_commissions,
    SUM(principal_amount) as total_principal,
    SUM(interest_amount) as total_interest,
    SUM(commission_amount) as total_commission,
    AVG(commission_rate) as avg_commission_rate
FROM commissions
GROUP BY DATE_TRUNC('month', operation_date), reference_type, status
ORDER BY period DESC, reference_type;

-- View para comissões pendentes
CREATE OR REPLACE VIEW pending_commissions AS
SELECT 
    c.*,
    cl.name as client_name,
    cl.cpf as client_cpf,
    u.full_name as user_name,
    cs.name as commission_setting_name
FROM commissions c
JOIN clients cl ON c.client_id = cl.id
LEFT JOIN users u ON c.user_id = u.id
LEFT JOIN commission_settings cs ON c.commission_setting_id = cs.id
WHERE c.status = 'pending'
ORDER BY c.operation_date DESC;

-- =====================================================
-- FUNÇÕES PARA RELATÓRIOS
-- =====================================================

-- Função para gerar relatório de comissões por período
CREATE OR REPLACE FUNCTION generate_commission_report(
    start_date DATE DEFAULT CURRENT_DATE - INTERVAL '30 days',
    end_date DATE DEFAULT CURRENT_DATE,
    user_filter UUID DEFAULT NULL,
    reference_type_filter TEXT DEFAULT NULL
)
RETURNS TABLE (
    total_commissions BIGINT,
    total_commission_amount DECIMAL(15,2),
    total_interest_amount DECIMAL(15,2),
    avg_commission_rate DECIMAL(5,2),
    pending_commissions BIGINT,
    paid_commissions BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_commissions,
        COALESCE(SUM(c.commission_amount), 0)::DECIMAL(15,2) as total_commission_amount,
        COALESCE(SUM(c.interest_amount), 0)::DECIMAL(15,2) as total_interest_amount,
        COALESCE(AVG(c.commission_rate), 0)::DECIMAL(5,2) as avg_commission_rate,
        COUNT(*) FILTER (WHERE c.status = 'pending') as pending_commissions,
        COUNT(*) FILTER (WHERE c.status = 'paid') as paid_commissions
    FROM commissions c
    WHERE c.operation_date BETWEEN start_date AND end_date
    AND (user_filter IS NULL OR c.user_id = user_filter)
    AND (reference_type_filter IS NULL OR c.reference_type = reference_type_filter);
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- POLÍTICAS DE SEGURANÇA (RLS)
-- =====================================================

-- Habilitar RLS
ALTER TABLE commission_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE commissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE commission_payments ENABLE ROW LEVEL SECURITY;

-- Políticas para configurações de comissão
CREATE POLICY "Admins can manage commission settings" ON commission_settings
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

CREATE POLICY "Users can view active commission settings" ON commission_settings
    FOR SELECT USING (is_active = true);

-- Políticas para comissões
CREATE POLICY "Users can view commissions" ON commissions
    FOR SELECT USING (
        user_id::text = auth.uid()::text OR
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role IN ('admin', 'manager')
        )
    );

CREATE POLICY "System can insert commissions" ON commissions
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update own commissions or admins can update all" ON commissions
    FOR UPDATE USING (
        user_id::text = auth.uid()::text OR
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role IN ('admin', 'manager')
        )
    );

-- Políticas para pagamentos de comissões
CREATE POLICY "Users can view commission payments" ON commission_payments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM commissions c
            WHERE c.id = commission_payments.commission_id
            AND (
                c.user_id::text = auth.uid()::text OR
                c.created_by::text = auth.uid()::text OR
                EXISTS (
                    SELECT 1 FROM users 
                    WHERE id::text = auth.uid()::text 
                    AND role IN ('admin', 'manager')
                )
            )
        )
    );

CREATE POLICY "Users can insert commission payments" ON commission_payments
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM commissions c
            WHERE c.id = commission_payments.commission_id
            AND (
                c.user_id::text = auth.uid()::text OR
                c.created_by::text = auth.uid()::text OR
                EXISTS (
                    SELECT 1 FROM users 
                    WHERE id::text = auth.uid()::text 
                    AND role IN ('admin', 'manager')
                )
            )
        )
    );

-- =====================================================
-- DADOS INICIAIS
-- =====================================================

-- Inserir configuração padrão de comissão
INSERT INTO commission_settings (name, description, commission_rate, applies_to) VALUES
('Comissão Padrão Empréstimos', 'Comissão padrão de 10% sobre os juros de empréstimos', 10.00, '{"loans"}'),
('Comissão Padrão Parcelamentos', 'Comissão padrão de 8% sobre os juros de parcelamentos', 8.00, '{"installments"}'),
('Comissão Geral', 'Comissão aplicável a todas as operações', 5.00, '{"loans", "installments", "capital_raising"}')
ON CONFLICT (name) DO NOTHING;

-- Adicionar constraint única para evitar duplicatas
ALTER TABLE commissions ADD CONSTRAINT unique_commission_reference UNIQUE (reference_id, reference_type);

-- =====================================================
-- MENSAGEM FINAL
-- =====================================================
SELECT 
    'COMMISSION SYSTEM SETUP COMPLETED!' as status,
    'Sistema de comissões implementado com sucesso!' as message,
    'Comissões serão calculadas automaticamente para novos empréstimos e parcelamentos' as info;