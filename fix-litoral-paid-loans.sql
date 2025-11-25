-- =====================================================
-- SCRIPT DE CORREÇÃO PARA LITORAL CRED
-- Verificar e Criar Tabela paid_loans
-- =====================================================
-- Execute este script no SQL Editor do Supabase da LITORAL CRED
-- =====================================================

-- PASSO 1: Verificar se a tabela paid_loans existe
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'paid_loans') THEN
        RAISE NOTICE '❌ TABELA paid_loans NÃO EXISTE - Será criada agora...';
    ELSE
        RAISE NOTICE '✅ TABELA paid_loans JÁ EXISTE';
    END IF;
END $$;

-- =====================================================
-- PASSO 2: CRIAR TABELA paid_loans
-- =====================================================

-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Criar tabela se não existir
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
-- PASSO 3: CRIAR ÍNDICES PARA PERFORMANCE
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_paid_loans_loan_id ON paid_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_client_id ON paid_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_paid_date ON paid_loans(paid_date);
CREATE INDEX IF NOT EXISTS idx_paid_loans_created_by ON paid_loans(created_by);
CREATE INDEX IF NOT EXISTS idx_paid_loans_created_at ON paid_loans(created_at);

-- =====================================================
-- PASSO 4: CRIAR FUNÇÃO PARA ATUALIZAR UPDATED_AT
-- =====================================================

CREATE OR REPLACE FUNCTION update_paid_loans_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger para atualizar updated_at automaticamente
DROP TRIGGER IF EXISTS update_paid_loans_updated_at_trigger ON paid_loans;
CREATE TRIGGER update_paid_loans_updated_at_trigger
    BEFORE UPDATE ON paid_loans
    FOR EACH ROW
    EXECUTE FUNCTION update_paid_loans_updated_at();

-- =====================================================
-- PASSO 5: CRIAR VIEW PARA EMPRÉSTIMOS QUITADOS
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
JOIN clients c ON pl.client_id = c.id
LEFT JOIN users u ON pl.created_by = u.id
ORDER BY pl.paid_date DESC;

-- =====================================================
-- PASSO 6: CONFIGURAR POLÍTICAS DE SEGURANÇA (RLS)
-- =====================================================

-- Habilitar RLS na tabela
ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;

-- Remover políticas antigas se existirem
DROP POLICY IF EXISTS "Authenticated users can view all paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Authenticated users can insert paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Users can update paid loans they created or admins can update all" ON paid_loans;
DROP POLICY IF EXISTS "Users can delete paid loans they created or admins can delete all" ON paid_loans;

-- Criar políticas novas
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
-- PASSO 7: CONCEDER PERMISSÕES
-- =====================================================

-- Conceder permissões para usuários autenticados
GRANT SELECT, INSERT, UPDATE, DELETE ON paid_loans TO authenticated;
GRANT USAGE ON SEQUENCE paid_loans_id_seq TO authenticated;

-- Conceder permissões para a view
GRANT SELECT ON paid_loans_with_details TO authenticated;

-- =====================================================
-- PASSO 8: VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar se a tabela foi criada
SELECT 
    '✅ Tabela paid_loans criada com sucesso!' as status,
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'paid_loans';

-- Verificar se os índices foram criados
SELECT 
    '✅ Índices criados:' as status,
    indexname,
    tablename
FROM pg_indexes 
WHERE tablename = 'paid_loans'
ORDER BY indexname;

-- Verificar se as políticas RLS estão ativas
SELECT 
    '✅ Políticas RLS configuradas:' as status,
    policyname,
    cmd
FROM pg_policies 
WHERE schemaname = 'public' AND tablename = 'paid_loans'
ORDER BY policyname;

-- Contar registros existentes
SELECT 
    '📊 Total de empréstimos quitados:' as status,
    COUNT(*) as total
FROM paid_loans;

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================

-- Mensagem final
DO $$ 
BEGIN
    RAISE NOTICE '==============================================';
    RAISE NOTICE '✅ CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!';
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'A tabela paid_loans está pronta para uso.';
    RAISE NOTICE 'Agora você pode marcar empréstimos como quitados.';
    RAISE NOTICE '==============================================';
END $$;
