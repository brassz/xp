-- =====================================================
-- CORREÇÃO: TABELA PAID_LOANS PARA LITORAL CRED
-- =====================================================
-- Execute este script no SQL Editor do Supabase da LITORAL CRED
-- URL: https://dtifsfzmnjnllzzlndxv.supabase.co
-- =====================================================

-- Verificar se a tabela existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans'
    ) THEN
        RAISE NOTICE '⚠️ TABELA paid_loans NÃO EXISTE - Será criada agora';
    ELSE
        RAISE NOTICE '✅ Tabela paid_loans já existe - Verificando estrutura...';
    END IF;
END $$;

-- =====================================================
-- CRIAR TABELA PAID_LOANS
-- =====================================================

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
-- ÍNDICES PARA PERFORMANCE
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_paid_loans_loan_id ON paid_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_client_id ON paid_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_paid_date ON paid_loans(paid_date);
CREATE INDEX IF NOT EXISTS idx_paid_loans_created_by ON paid_loans(created_by);
CREATE INDEX IF NOT EXISTS idx_paid_loans_created_at ON paid_loans(created_at);

-- =====================================================
-- FUNÇÃO PARA ATUALIZAR UPDATED_AT
-- =====================================================

CREATE OR REPLACE FUNCTION update_paid_loans_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para atualizar updated_at automaticamente
DROP TRIGGER IF EXISTS update_paid_loans_updated_at_trigger ON paid_loans;
CREATE TRIGGER update_paid_loans_updated_at_trigger
    BEFORE UPDATE ON paid_loans
    FOR EACH ROW
    EXECUTE FUNCTION update_paid_loans_updated_at();

-- =====================================================
-- VIEW PARA EMPRÉSTIMOS QUITADOS COM DETALHES
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
-- DESABILITAR RLS (Row Level Security)
-- =====================================================
-- IMPORTANTE: O sistema Litoral Cred não usa RLS
-- Vamos desabilitar para garantir compatibilidade

ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;

-- Remover políticas RLS antigas (se existirem)
DROP POLICY IF EXISTS "Authenticated users can view all paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Authenticated users can insert paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Users can update paid loans they created or admins can update all" ON paid_loans;
DROP POLICY IF EXISTS "Users can delete paid loans they created or admins can delete all" ON paid_loans;

-- =====================================================
-- PERMISSÕES
-- =====================================================

-- Conceder permissões COMPLETAS para usuários autenticados
GRANT ALL ON paid_loans TO authenticated;
GRANT ALL ON paid_loans TO anon;
GRANT ALL ON paid_loans TO postgres;

-- Conceder permissões para a view
GRANT SELECT ON paid_loans_with_details TO authenticated;
GRANT SELECT ON paid_loans_with_details TO anon;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar se a tabela foi criada
DO $$
DECLARE
    v_table_exists BOOLEAN;
    v_index_count INTEGER;
    v_rls_enabled BOOLEAN;
BEGIN
    -- Verificar tabela
    SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans'
    ) INTO v_table_exists;
    
    IF v_table_exists THEN
        RAISE NOTICE '✅ Tabela paid_loans criada com sucesso';
    ELSE
        RAISE EXCEPTION '❌ ERRO: Tabela paid_loans não foi criada';
    END IF;
    
    -- Verificar índices
    SELECT COUNT(*) INTO v_index_count
    FROM pg_indexes 
    WHERE tablename = 'paid_loans';
    
    RAISE NOTICE '✅ Índices criados: %', v_index_count;
    
    -- Verificar RLS
    SELECT relrowsecurity INTO v_rls_enabled
    FROM pg_class
    WHERE relname = 'paid_loans';
    
    IF v_rls_enabled THEN
        RAISE NOTICE '⚠️ RLS está HABILITADO (deveria estar desabilitado para Litoral Cred)';
    ELSE
        RAISE NOTICE '✅ RLS está DESABILITADO (correto para Litoral Cred)';
    END IF;
END $$;

-- Listar estrutura da tabela
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'paid_loans'
ORDER BY ordinal_position;

-- =====================================================
-- TESTE DE INSERÇÃO (OPCIONAL)
-- =====================================================

-- Descomente as linhas abaixo para testar se a inserção funciona
-- ATENÇÃO: Isso vai inserir um registro de teste na tabela

/*
DO $$
DECLARE
    v_test_client_id UUID;
    v_test_loan_id UUID;
BEGIN
    -- Buscar um cliente existente para teste
    SELECT id INTO v_test_client_id 
    FROM clients 
    LIMIT 1;
    
    IF v_test_client_id IS NULL THEN
        RAISE NOTICE '⚠️ Nenhum cliente encontrado para teste';
        RETURN;
    END IF;
    
    -- Gerar um loan_id fictício
    v_test_loan_id := gen_random_uuid();
    
    -- Tentar inserir registro de teste
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
        notes
    ) VALUES (
        v_test_loan_id,
        v_test_client_id,
        1000.00,
        5.00,
        1050.00,
        CURRENT_DATE - INTERVAL '30 days',
        CURRENT_DATE - INTERVAL '1 day',
        CURRENT_DATE,
        1050.00,
        'TESTE',
        'Registro de teste - PODE SER EXCLUÍDO'
    );
    
    RAISE NOTICE '✅ Teste de inserção bem-sucedido! ID do registro de teste: %', v_test_loan_id;
    RAISE NOTICE '⚠️ Para excluir o registro de teste, execute: DELETE FROM paid_loans WHERE loan_id = ''%'';', v_test_loan_id;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ ERRO no teste de inserção: %', SQLERRM;
END $$;
*/

-- =====================================================
-- FIM DA CORREÇÃO
-- =====================================================

SELECT '🎉 Script executado com sucesso!' as status;
SELECT 'A funcionalidade de marcar empréstimos como quitados agora deve funcionar na LITORAL CRED!' as mensagem;
