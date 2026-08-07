-- Tabelas para diferentes status de empréstimos
-- Este arquivo cria tabelas separadas para melhor organização e controle dos dados

-- Primeiro, remover views e tabelas existentes se houver conflitos
DROP VIEW IF EXISTS cancelled_loans CASCADE;
DROP VIEW IF EXISTS partial_paid_loans CASCADE;
DROP VIEW IF EXISTS overdue_loans CASCADE;
DROP VIEW IF EXISTS paid_loans CASCADE;

DROP TABLE IF EXISTS cancelled_loans CASCADE;
DROP TABLE IF EXISTS partial_paid_loans CASCADE;
DROP TABLE IF EXISTS overdue_loans CASCADE;
DROP TABLE IF EXISTS paid_loans CASCADE;

-- Remover funções e triggers existentes
DROP FUNCTION IF EXISTS insert_paid_loan() CASCADE;
DROP FUNCTION IF EXISTS insert_overdue_loan() CASCADE;
DROP FUNCTION IF EXISTS insert_partial_paid_loan() CASCADE;
DROP FUNCTION IF EXISTS insert_cancelled_loan() CASCADE;
DROP FUNCTION IF EXISTS cleanup_loan_status_tables() CASCADE;

-- Tabela para empréstimos quitados (status = 'paid')
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

-- Tabela para empréstimos vencidos (status = 'overdue')
CREATE TABLE overdue_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID NOT NULL,
    client_id UUID NOT NULL,
    original_amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    total_with_interest DECIMAL(10,2) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    days_overdue INTEGER NOT NULL DEFAULT 0,
    remaining_amount DECIMAL(10,2) NOT NULL,
    total_paid DECIMAL(10,2) DEFAULT 0,
    last_payment_date DATE,
    collection_notes TEXT,
    collection_status VARCHAR(50) DEFAULT 'pending',
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela para empréstimos parcelados (status = 'partial_paid')
CREATE TABLE partial_paid_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID NOT NULL,
    client_id UUID NOT NULL,
    original_amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    total_with_interest DECIMAL(10,2) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    total_paid DECIMAL(10,2) NOT NULL DEFAULT 0,
    remaining_amount DECIMAL(10,2) NOT NULL,
    payment_count INTEGER DEFAULT 0,
    last_payment_date DATE,
    next_payment_date DATE,
    payment_schedule TEXT,
    installment_amount DECIMAL(10,2),
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela para empréstimos cancelados (status = 'cancelled')
CREATE TABLE cancelled_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID NOT NULL,
    client_id UUID NOT NULL,
    original_amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    total_with_interest DECIMAL(10,2) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    cancellation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    cancellation_reason TEXT NOT NULL,
    total_paid_before_cancellation DECIMAL(10,2) DEFAULT 0,
    refund_amount DECIMAL(10,2) DEFAULT 0,
    cancellation_fee DECIMAL(10,2) DEFAULT 0,
    cancelled_by UUID,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Adicionar constraints de foreign key após criar as tabelas
-- IMPORTANTE: Certifique-se de que as tabelas loans, clients e users já existem antes de executar este script
ALTER TABLE paid_loans ADD CONSTRAINT fk_paid_loans_loan_id FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;
ALTER TABLE paid_loans ADD CONSTRAINT fk_paid_loans_client_id FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;
ALTER TABLE paid_loans ADD CONSTRAINT fk_paid_loans_created_by FOREIGN KEY (created_by) REFERENCES users(id);

ALTER TABLE overdue_loans ADD CONSTRAINT fk_overdue_loans_loan_id FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;
ALTER TABLE overdue_loans ADD CONSTRAINT fk_overdue_loans_client_id FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;
ALTER TABLE overdue_loans ADD CONSTRAINT fk_overdue_loans_created_by FOREIGN KEY (created_by) REFERENCES users(id);

ALTER TABLE partial_paid_loans ADD CONSTRAINT fk_partial_paid_loans_loan_id FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;
ALTER TABLE partial_paid_loans ADD CONSTRAINT fk_partial_paid_loans_client_id FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;
ALTER TABLE partial_paid_loans ADD CONSTRAINT fk_partial_paid_loans_created_by FOREIGN KEY (created_by) REFERENCES users(id);

ALTER TABLE cancelled_loans ADD CONSTRAINT fk_cancelled_loans_loan_id FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;
ALTER TABLE cancelled_loans ADD CONSTRAINT fk_cancelled_loans_client_id FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;
ALTER TABLE cancelled_loans ADD CONSTRAINT fk_cancelled_loans_cancelled_by FOREIGN KEY (cancelled_by) REFERENCES users(id);
ALTER TABLE cancelled_loans ADD CONSTRAINT fk_cancelled_loans_created_by FOREIGN KEY (created_by) REFERENCES users(id);

-- =====================================================
-- ADICIONAR CONSTRAINTS ÚNICAS PARA loan_id
-- =====================================================
-- Estas constraints são necessárias para o ON CONFLICT funcionar corretamente
ALTER TABLE paid_loans ADD CONSTRAINT unique_paid_loan_id UNIQUE (loan_id);
ALTER TABLE overdue_loans ADD CONSTRAINT unique_overdue_loan_id UNIQUE (loan_id);
ALTER TABLE partial_paid_loans ADD CONSTRAINT unique_partial_paid_loan_id UNIQUE (loan_id);
ALTER TABLE cancelled_loans ADD CONSTRAINT unique_cancelled_loan_id UNIQUE (loan_id);

-- Índices para melhor performance
CREATE INDEX idx_paid_loans_loan_id ON paid_loans(loan_id);
CREATE INDEX idx_paid_loans_client_id ON paid_loans(client_id);
CREATE INDEX idx_paid_loans_paid_date ON paid_loans(paid_date);

CREATE INDEX idx_overdue_loans_loan_id ON overdue_loans(loan_id);
CREATE INDEX idx_overdue_loans_client_id ON overdue_loans(client_id);
CREATE INDEX idx_overdue_loans_days_overdue ON overdue_loans(days_overdue);
CREATE INDEX idx_overdue_loans_collection_status ON overdue_loans(collection_status);

CREATE INDEX idx_partial_paid_loans_loan_id ON partial_paid_loans(loan_id);
CREATE INDEX idx_partial_paid_loans_client_id ON partial_paid_loans(client_id);
CREATE INDEX idx_partial_paid_loans_next_payment_date ON partial_paid_loans(next_payment_date);

CREATE INDEX idx_cancelled_loans_loan_id ON cancelled_loans(loan_id);
CREATE INDEX idx_cancelled_loans_client_id ON cancelled_loans(client_id);
CREATE INDEX idx_cancelled_loans_cancellation_date ON cancelled_loans(cancellation_date);

-- Triggers para manter as tabelas sincronizadas
-- Trigger para inserir empréstimos quitados
CREATE OR REPLACE FUNCTION insert_paid_loan()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'paid' AND OLD.status != 'paid' THEN
        INSERT INTO paid_loans (
            loan_id, client_id, original_amount, interest_rate, 
            total_with_interest, loan_date, due_date, total_paid,
            created_by
        ) VALUES (
            NEW.id, NEW.client_id, NEW.amount, NEW.interest_rate,
            NEW.amount + (NEW.amount * NEW.interest_rate / 100),
            NEW.loan_date, NEW.due_date, 
            (SELECT COALESCE(SUM(amount), 0) FROM payments WHERE loan_id = NEW.id),
            NEW.created_by
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_paid_loan
    AFTER UPDATE ON loans
    FOR EACH ROW
    EXECUTE FUNCTION insert_paid_loan();

-- Trigger para inserir empréstimos vencidos
CREATE OR REPLACE FUNCTION insert_overdue_loan()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.due_date < CURRENT_DATE AND NEW.status NOT IN ('paid', 'cancelled') THEN
        INSERT INTO overdue_loans (
            loan_id, client_id, original_amount, interest_rate,
            total_with_interest, loan_date, due_date, days_overdue,
            remaining_amount, total_paid, created_by
        ) VALUES (
            NEW.id, NEW.client_id, NEW.amount, NEW.interest_rate,
            NEW.amount + (NEW.amount * NEW.interest_rate / 100),
            NEW.loan_date, NEW.due_date,
            CURRENT_DATE - NEW.due_date,
            (NEW.amount + (NEW.amount * NEW.interest_rate / 100)) - 
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            NEW.created_by
        )
        ON CONFLICT (loan_id) DO UPDATE SET
            days_overdue = CURRENT_DATE - NEW.due_date,
            remaining_amount = (NEW.amount + (NEW.amount * NEW.interest_rate / 100)) - 
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            total_paid = COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_overdue_loan
    AFTER INSERT OR UPDATE ON loans
    FOR EACH ROW
    EXECUTE FUNCTION insert_overdue_loan();

-- Trigger para inserir empréstimos parcelados
CREATE OR REPLACE FUNCTION insert_partial_paid_loan()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'partial_paid' AND OLD.status != 'partial_paid' THEN
        INSERT INTO partial_paid_loans (
            loan_id, client_id, original_amount, interest_rate,
            total_with_interest, loan_date, due_date, total_paid,
            remaining_amount, payment_count, last_payment_date, created_by
        ) VALUES (
            NEW.id, NEW.client_id, NEW.amount, NEW.interest_rate,
            NEW.amount + (NEW.amount * NEW.interest_rate / 100),
            NEW.loan_date, NEW.due_date,
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            (NEW.amount + (NEW.amount * NEW.interest_rate / 100)) - 
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            (SELECT COUNT(*) FROM payments WHERE loan_id = NEW.id),
            (SELECT MAX(payment_date) FROM payments WHERE loan_id = NEW.id),
            NEW.created_by
        )
        ON CONFLICT (loan_id) DO UPDATE SET
            total_paid = COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            remaining_amount = (NEW.amount + (NEW.amount * NEW.interest_rate / 100)) - 
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            payment_count = (SELECT COUNT(*) FROM payments WHERE loan_id = NEW.id),
            last_payment_date = (SELECT MAX(payment_date) FROM payments WHERE loan_id = NEW.id),
            updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_partial_paid_loan
    AFTER UPDATE ON loans
    FOR EACH ROW
    EXECUTE FUNCTION insert_partial_paid_loan();

-- Trigger para inserir empréstimos cancelados
CREATE OR REPLACE FUNCTION insert_cancelled_loan()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'cancelled' AND OLD.status != 'cancelled' THEN
        INSERT INTO cancelled_loans (
            loan_id, client_id, original_amount, interest_rate,
            total_with_interest, loan_date, due_date, total_paid_before_cancellation,
            created_by
        ) VALUES (
            NEW.id, NEW.client_id, NEW.amount, NEW.interest_rate,
            NEW.amount + (NEW.amount * NEW.interest_rate / 100),
            NEW.loan_date, NEW.due_date,
            COALESCE((SELECT SUM(amount) FROM payments WHERE loan_id = NEW.id), 0),
            NEW.created_by
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insert_cancelled_loan
    AFTER UPDATE ON loans
    FOR EACH ROW
    EXECUTE FUNCTION insert_cancelled_loan();

-- Função para limpar registros antigos quando o status muda
CREATE OR REPLACE FUNCTION cleanup_loan_status_tables()
RETURNS TRIGGER AS $$
BEGIN
    -- Remover da tabela de vencidos se o empréstimo foi quitado ou cancelado
    IF NEW.status IN ('paid', 'cancelled') THEN
        DELETE FROM overdue_loans WHERE loan_id = NEW.id;
    END IF;
    
    -- Remover da tabela de parcelados se o empréstimo foi quitado ou cancelado
    IF NEW.status IN ('paid', 'cancelled') THEN
        DELETE FROM partial_paid_loans WHERE loan_id = NEW.id;
    END IF;
    
    -- Remover da tabela de quitados se o empréstimo foi cancelado
    IF NEW.status = 'cancelled' THEN
        DELETE FROM paid_loans WHERE loan_id = NEW.id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_cleanup_loan_status_tables
    AFTER UPDATE ON loans
    FOR EACH ROW
    EXECUTE FUNCTION cleanup_loan_status_tables();

-- Comentários das tabelas
COMMENT ON TABLE paid_loans IS 'Tabela para empréstimos completamente quitados';
COMMENT ON TABLE overdue_loans IS 'Tabela para empréstimos vencidos em processo de cobrança';
COMMENT ON TABLE partial_paid_loans IS 'Tabela para empréstimos com pagamentos parciais';
COMMENT ON TABLE cancelled_loans IS 'Tabela para empréstimos cancelados';

-- Permissões (ajustar conforme necessário)
-- GRANT SELECT, INSERT, UPDATE, DELETE ON paid_loans TO authenticated;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON overdue_loans TO authenticated;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON partial_paid_loans TO authenticated;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON cancelled_loans TO authenticated; 