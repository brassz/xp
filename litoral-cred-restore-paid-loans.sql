-- =====================================================
-- RECUPERAÇÃO DE EMPRÉSTIMOS QUITADOS - LITORAL CRED
-- =====================================================
-- Execute este script no SQL Editor do Supabase da Litoral Cred
-- URL: https://dtifsfzmnjnllzzlndxv.supabase.co
-- =====================================================

-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- PASSO 1: CRIAR/RECRIAR TABELA PAID_LOANS
-- =====================================================

-- Remover tabela existente se houver (CUIDADO: isso apaga dados!)
-- Comente a linha abaixo se quiser preservar dados existentes
-- DROP TABLE IF EXISTS paid_loans CASCADE;

-- Criar tabela paid_loans se não existir
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

-- Comentários da tabela
COMMENT ON TABLE paid_loans IS 'Tabela para armazenar empréstimos completamente quitados';
COMMENT ON COLUMN paid_loans.id IS 'Identificador único do registro de quitação';
COMMENT ON COLUMN paid_loans.loan_id IS 'ID original do empréstimo (para referência)';
COMMENT ON COLUMN paid_loans.client_id IS 'Referência ao cliente';
COMMENT ON COLUMN paid_loans.original_amount IS 'Valor original do empréstimo';
COMMENT ON COLUMN paid_loans.interest_rate IS 'Taxa de juros original';
COMMENT ON COLUMN paid_loans.total_with_interest IS 'Valor total com juros';
COMMENT ON COLUMN paid_loans.loan_date IS 'Data original do empréstimo';
COMMENT ON COLUMN paid_loans.due_date IS 'Data de vencimento original';
COMMENT ON COLUMN paid_loans.paid_date IS 'Data em que foi quitado';
COMMENT ON COLUMN paid_loans.total_paid IS 'Total pago (incluindo juros)';
COMMENT ON COLUMN paid_loans.payment_method IS 'Método de pagamento utilizado';
COMMENT ON COLUMN paid_loans.notes IS 'Observações sobre a quitação';
COMMENT ON COLUMN paid_loans.created_by IS 'Usuário que criou o empréstimo original';

-- =====================================================
-- PASSO 2: CRIAR ÍNDICES PARA PERFORMANCE
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_paid_loans_loan_id ON paid_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_client_id ON paid_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_paid_date ON paid_loans(paid_date);
CREATE INDEX IF NOT EXISTS idx_paid_loans_created_by ON paid_loans(created_by);
CREATE INDEX IF NOT EXISTS idx_paid_loans_created_at ON paid_loans(created_at);

-- =====================================================
-- PASSO 3: CRIAR TRIGGER PARA ATUALIZAR UPDATED_AT
-- =====================================================

CREATE OR REPLACE FUNCTION update_paid_loans_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_paid_loans_updated_at_trigger ON paid_loans;
CREATE TRIGGER update_paid_loans_updated_at_trigger
    BEFORE UPDATE ON paid_loans
    FOR EACH ROW
    EXECUTE FUNCTION update_paid_loans_updated_at();

-- =====================================================
-- PASSO 4: CRIAR VIEW PARA EMPRÉSTIMOS QUITADOS COM DETALHES
-- =====================================================

CREATE OR REPLACE VIEW paid_loans_with_details AS
SELECT 
    pl.*,
    c.name as client_name,
    c.cpf as client_cpf,
    c.email as client_email,
    c.phone as client_phone,
    c.photo as client_photo,
    u.full_name as created_by_name
FROM paid_loans pl
LEFT JOIN clients c ON pl.client_id = c.id
LEFT JOIN users u ON pl.created_by = u.id
ORDER BY pl.paid_date DESC;

-- =====================================================
-- PASSO 5: CONFIGURAR POLÍTICAS DE SEGURANÇA (RLS)
-- =====================================================

-- Habilitar RLS na tabela
ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;

-- Remover políticas antigas se existirem
DROP POLICY IF EXISTS "Authenticated users can view all paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Authenticated users can insert paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Users can update paid loans they created or admins can update all" ON paid_loans;
DROP POLICY IF EXISTS "Users can delete paid loans they created or admins can delete all" ON paid_loans;

-- Políticas para empréstimos quitados
CREATE POLICY "Authenticated users can view all paid loans" ON paid_loans
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert paid loans" ON paid_loans
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update paid loans they created or admins can update all" ON paid_loans
    FOR UPDATE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

CREATE POLICY "Users can delete paid loans they created or admins can delete all" ON paid_loans
    FOR DELETE USING (
        created_by::text = auth.uid()::text OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id::text = auth.uid()::text 
            AND role = 'admin'
        )
    );

-- =====================================================
-- PASSO 6: CONCEDER PERMISSÕES
-- =====================================================

-- Conceder permissões para usuários autenticados
GRANT SELECT, INSERT, UPDATE, DELETE ON paid_loans TO authenticated;

-- Conceder permissões para a view
GRANT SELECT ON paid_loans_with_details TO authenticated;

-- =====================================================
-- PASSO 7: CRIAR TRIGGER PARA MOVER EMPRÉSTIMOS QUITADOS AUTOMATICAMENTE
-- =====================================================

CREATE OR REPLACE FUNCTION auto_move_paid_loan()
RETURNS TRIGGER AS $$
DECLARE
    v_total_paid DECIMAL(10,2);
    v_last_payment_date DATE;
BEGIN
    -- Verificar se o status mudou para 'paid'
    IF NEW.status = 'paid' AND (OLD.status IS NULL OR OLD.status != 'paid') THEN
        -- Calcular total pago e data do último pagamento
        SELECT 
            COALESCE(SUM(amount), 0),
            MAX(payment_date)
        INTO v_total_paid, v_last_payment_date
        FROM payments 
        WHERE loan_id = NEW.id;
        
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
            created_by
        ) VALUES (
            NEW.id,
            NEW.client_id,
            NEW.amount,
            NEW.interest_rate,
            NEW.amount + (NEW.amount * NEW.interest_rate / 100),
            NEW.loan_date,
            NEW.due_date,
            COALESCE(v_last_payment_date, CURRENT_DATE),
            v_total_paid,
            'Pagamento Completo',
            'Movido automaticamente ao marcar como quitado',
            NEW.created_by
        )
        ON CONFLICT (loan_id) DO UPDATE SET
            total_paid = EXCLUDED.total_paid,
            paid_date = EXCLUDED.paid_date,
            updated_at = NOW();
        
        -- Deletar da tabela loans
        DELETE FROM loans WHERE id = NEW.id;
        RETURN NULL; -- Não inserir/atualizar na tabela loans
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Remover trigger antigo se existir
DROP TRIGGER IF EXISTS trigger_auto_move_paid_loan ON loans;

-- Criar novo trigger
CREATE TRIGGER trigger_auto_move_paid_loan
    BEFORE INSERT OR UPDATE ON loans
    FOR EACH ROW
    EXECUTE FUNCTION auto_move_paid_loan();

-- =====================================================
-- PASSO 8: ADICIONAR CONSTRAINT ÚNICA PARA LOAN_ID
-- =====================================================

-- Adicionar constraint única em loan_id para evitar duplicatas
ALTER TABLE paid_loans DROP CONSTRAINT IF EXISTS unique_paid_loans_loan_id;
ALTER TABLE paid_loans ADD CONSTRAINT unique_paid_loans_loan_id UNIQUE (loan_id);

-- =====================================================
-- PASSO 9: CRIAR TABELA DE AUDITORIA (OPCIONAL)
-- =====================================================

CREATE TABLE IF NOT EXISTS paid_loans_audit (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    paid_loan_id UUID NOT NULL,
    action VARCHAR(50) NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE', 'RESTORE'
    changed_data JSONB,
    changed_by UUID,
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_paid_loans_audit_paid_loan_id ON paid_loans_audit(paid_loan_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_audit_changed_at ON paid_loans_audit(changed_at);

-- Trigger para registrar mudanças
CREATE OR REPLACE FUNCTION audit_paid_loans()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO paid_loans_audit (paid_loan_id, action, changed_data, changed_by)
        VALUES (NEW.id, 'INSERT', row_to_json(NEW)::jsonb, auth.uid());
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO paid_loans_audit (paid_loan_id, action, changed_data, changed_by)
        VALUES (NEW.id, 'UPDATE', jsonb_build_object(
            'old', row_to_json(OLD)::jsonb,
            'new', row_to_json(NEW)::jsonb
        ), auth.uid());
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO paid_loans_audit (paid_loan_id, action, changed_data, changed_by)
        VALUES (OLD.id, 'DELETE', row_to_json(OLD)::jsonb, auth.uid());
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_audit_paid_loans ON paid_loans;
CREATE TRIGGER trigger_audit_paid_loans
    AFTER INSERT OR UPDATE OR DELETE ON paid_loans
    FOR EACH ROW
    EXECUTE FUNCTION audit_paid_loans();

-- =====================================================
-- PASSO 10: VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar se a tabela foi criada
SELECT 
    'paid_loans' as tabela,
    EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans'
    ) AS existe;

-- Verificar índices criados
SELECT 
    indexname,
    indexdef
FROM pg_indexes 
WHERE tablename = 'paid_loans'
ORDER BY indexname;

-- Verificar políticas RLS
SELECT 
    policyname,
    cmd as comando,
    qual as condicao
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'paid_loans'
ORDER BY policyname;

-- Verificar triggers
SELECT 
    trigger_name,
    event_manipulation as evento
FROM information_schema.triggers
WHERE event_object_table = 'paid_loans' OR event_object_table = 'loans'
ORDER BY event_object_table, trigger_name;

-- Contar registros atuais
SELECT 
    COUNT(*) as total_emprestimos_quitados
FROM paid_loans;

-- =====================================================
-- FIM DA CONFIGURAÇÃO
-- =====================================================

-- Mensagem de sucesso
DO $$
BEGIN
    RAISE NOTICE '✅ Tabela paid_loans criada/restaurada com sucesso!';
    RAISE NOTICE '✅ Índices criados';
    RAISE NOTICE '✅ Políticas RLS configuradas';
    RAISE NOTICE '✅ Triggers automáticos criados';
    RAISE NOTICE '✅ Sistema de auditoria configurado';
    RAISE NOTICE '';
    RAISE NOTICE '📋 Próximo passo: Execute o script litoral-cred-recover-data.sql para recuperar dados';
END $$;
