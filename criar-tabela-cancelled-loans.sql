-- =====================================================
-- CRIAR TABELA CANCELLED_LOANS
-- =====================================================
-- Script para criar apenas a tabela de empréstimos cancelados
-- =====================================================

-- Habilitar extensão UUID (se ainda não estiver)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- CRIAR TABELA
-- =====================================================
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
    cancellation_reason TEXT NOT NULL,
    total_paid_before_cancellation DECIMAL(10,2) DEFAULT 0,
    refund_amount DECIMAL(10,2) DEFAULT 0,
    cancellation_fee DECIMAL(10,2) DEFAULT 0,
    cancelled_by UUID,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comentário da tabela
COMMENT ON TABLE cancelled_loans IS 'Tabela para armazenar empréstimos cancelados';
COMMENT ON COLUMN cancelled_loans.id IS 'Identificador único do registro de cancelamento';
COMMENT ON COLUMN cancelled_loans.loan_id IS 'ID original do empréstimo (para referência)';
COMMENT ON COLUMN cancelled_loans.client_id IS 'Referência ao cliente';
COMMENT ON COLUMN cancelled_loans.original_amount IS 'Valor original do empréstimo';
COMMENT ON COLUMN cancelled_loans.interest_rate IS 'Taxa de juros original';
COMMENT ON COLUMN cancelled_loans.total_with_interest IS 'Valor total com juros';
COMMENT ON COLUMN cancelled_loans.loan_date IS 'Data original do empréstimo';
COMMENT ON COLUMN cancelled_loans.due_date IS 'Data de vencimento original';
COMMENT ON COLUMN cancelled_loans.cancellation_date IS 'Data do cancelamento';
COMMENT ON COLUMN cancelled_loans.cancellation_reason IS 'Motivo do cancelamento';
COMMENT ON COLUMN cancelled_loans.total_paid_before_cancellation IS 'Total pago antes do cancelamento';
COMMENT ON COLUMN cancelled_loans.refund_amount IS 'Valor a ser reembolsado';
COMMENT ON COLUMN cancelled_loans.cancellation_fee IS 'Taxa de cancelamento cobrada';
COMMENT ON COLUMN cancelled_loans.cancelled_by IS 'Usuário que cancelou';
COMMENT ON COLUMN cancelled_loans.created_by IS 'Usuário que criou o empréstimo original';

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_cancelled_loans_loan_id ON cancelled_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_cancelled_loans_client_id ON cancelled_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_cancelled_loans_cancellation_date ON cancelled_loans(cancellation_date);
CREATE INDEX IF NOT EXISTS idx_cancelled_loans_created_at ON cancelled_loans(created_at);
CREATE INDEX IF NOT EXISTS idx_cancelled_loans_cancelled_by ON cancelled_loans(cancelled_by);

-- =====================================================
-- FOREIGN KEYS (OPCIONAL - descomente se necessário)
-- =====================================================
-- Descomente as linhas abaixo se as tabelas relacionadas existirem

-- ALTER TABLE cancelled_loans 
-- ADD CONSTRAINT fk_cancelled_loans_client_id 
-- FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;

-- ALTER TABLE cancelled_loans 
-- ADD CONSTRAINT fk_cancelled_loans_cancelled_by 
-- FOREIGN KEY (cancelled_by) REFERENCES users(id);

-- ALTER TABLE cancelled_loans 
-- ADD CONSTRAINT fk_cancelled_loans_created_by 
-- FOREIGN KEY (created_by) REFERENCES users(id);

-- =====================================================
-- TRIGGER PARA ATUALIZAR UPDATED_AT
-- =====================================================
CREATE OR REPLACE FUNCTION update_cancelled_loans_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_cancelled_loans_updated_at_trigger ON cancelled_loans;
CREATE TRIGGER update_cancelled_loans_updated_at_trigger
    BEFORE UPDATE ON cancelled_loans
    FOR EACH ROW
    EXECUTE FUNCTION update_cancelled_loans_updated_at();

-- =====================================================
-- POLÍTICAS DE SEGURANÇA (RLS)
-- =====================================================
-- Habilitar RLS na tabela
ALTER TABLE cancelled_loans ENABLE ROW LEVEL SECURITY;

-- Políticas de acesso
DROP POLICY IF EXISTS "Usuários autenticados podem ver empréstimos cancelados" ON cancelled_loans;
CREATE POLICY "Usuários autenticados podem ver empréstimos cancelados" 
ON cancelled_loans FOR SELECT 
USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários autenticados podem inserir empréstimos cancelados" ON cancelled_loans;
CREATE POLICY "Usuários autenticados podem inserir empréstimos cancelados" 
ON cancelled_loans FOR INSERT 
WITH CHECK (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários podem atualizar empréstimos cancelados" ON cancelled_loans;
CREATE POLICY "Usuários podem atualizar empréstimos cancelados" 
ON cancelled_loans FOR UPDATE 
USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Usuários podem excluir empréstimos cancelados" ON cancelled_loans;
CREATE POLICY "Usuários podem excluir empréstimos cancelados" 
ON cancelled_loans FOR DELETE 
USING (auth.role() = 'authenticated');

-- =====================================================
-- PERMISSÕES
-- =====================================================
-- Conceder permissões para usuários autenticados
GRANT SELECT, INSERT, UPDATE, DELETE ON cancelled_loans TO authenticated;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'cancelled_loans') THEN
        RAISE NOTICE '✅ Tabela cancelled_loans criada com sucesso!';
        RAISE NOTICE '✅ Índices criados';
        RAISE NOTICE '✅ Trigger configurado';
        RAISE NOTICE '✅ RLS policies configuradas';
        RAISE NOTICE '✅ Permissões concedidas';
        RAISE NOTICE '';
        RAISE NOTICE '🎉 Pronto! A tabela cancelled_loans está disponível.';
    ELSE
        RAISE NOTICE '❌ Erro: Tabela cancelled_loans não foi criada';
    END IF;
END $$;

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================
-- 
-- INSTRUÇÕES:
-- 1. Abra o SQL Editor no Supabase
-- 2. Cole este script completo
-- 3. Clique em "Run"
-- 4. Aguarde a mensagem de sucesso
-- 5. Recarregue a aplicação (F5)
-- =====================================================
