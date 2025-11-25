-- =====================================================
-- CONFIGURAÇÃO DA TABELA PAID_LOANS - SCRIPT GENÉRICO
-- =====================================================
-- Execute este script no SQL Editor do Supabase da empresa que
-- está com problema ao marcar empréstimos como quitados
-- =====================================================
-- 
-- EMPRESAS SUPORTADAS:
-- - NEXUS (Principal): https://mhtxyxizfnxupwmilith.supabase.co
-- - LITORAL CRED: https://dtifsfzmnjnllzzlndxv.supabase.co
-- - MOGIANA CRED: https://eemfnpefgojllvzzaimu.supabase.co
-- - ERECHIM: https://adjrvtupfshdhwjvhmgj.supabase.co
-- - IMPERATRIZ CRED: https://eppzphzwwpvpoocospxy.supabase.co
--
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
-- CONFIGURAÇÃO DE SEGURANÇA (RLS)
-- =====================================================

-- Verificar se RLS deve estar habilitado ou não
DO $$
DECLARE
    v_has_rls BOOLEAN;
    v_loans_rls BOOLEAN;
BEGIN
    -- Verificar se a tabela loans tem RLS habilitado
    SELECT relrowsecurity INTO v_loans_rls
    FROM pg_class
    WHERE relname = 'loans';
    
    IF v_loans_rls THEN
        RAISE NOTICE '✅ Tabela loans tem RLS habilitado - Habilitando RLS em paid_loans também';
        
        -- Habilitar RLS
        ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;
        
        -- Remover políticas antigas
        DROP POLICY IF EXISTS "Authenticated users can view all paid loans" ON paid_loans;
        DROP POLICY IF EXISTS "Authenticated users can insert paid loans" ON paid_loans;
        DROP POLICY IF EXISTS "Users can update paid loans they created or admins can update all" ON paid_loans;
        DROP POLICY IF EXISTS "Users can delete paid loans they created or admins can delete all" ON paid_loans;
        
        -- Criar políticas
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
        
        RAISE NOTICE '✅ Políticas RLS criadas para paid_loans';
    ELSE
        RAISE NOTICE '✅ Tabela loans NÃO tem RLS - Desabilitando RLS em paid_loans';
        
        -- Desabilitar RLS
        ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;
        
        -- Remover políticas
        DROP POLICY IF EXISTS "Authenticated users can view all paid loans" ON paid_loans;
        DROP POLICY IF EXISTS "Authenticated users can insert paid loans" ON paid_loans;
        DROP POLICY IF EXISTS "Users can update paid loans they created or admins can update all" ON paid_loans;
        DROP POLICY IF EXISTS "Users can delete paid loans they created or admins can delete all" ON paid_loans;
    END IF;
END $$;

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

DO $$
DECLARE
    v_table_exists BOOLEAN;
    v_index_count INTEGER;
    v_rls_enabled BOOLEAN;
    v_column_count INTEGER;
    v_policy_count INTEGER;
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
    
    -- Verificar colunas
    SELECT COUNT(*) INTO v_column_count
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'paid_loans';
    
    RAISE NOTICE '✅ Colunas criadas: %', v_column_count;
    
    IF v_column_count < 14 THEN
        RAISE WARNING '⚠️ ATENÇÃO: Esperadas 14 colunas, mas apenas % foram encontradas', v_column_count;
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
        RAISE NOTICE '✅ RLS está HABILITADO';
        
        -- Contar políticas
        SELECT COUNT(*) INTO v_policy_count
        FROM pg_policies
        WHERE tablename = 'paid_loans';
        
        RAISE NOTICE '✅ Políticas RLS criadas: %', v_policy_count;
    ELSE
        RAISE NOTICE '✅ RLS está DESABILITADO';
    END IF;
    
    -- Verificar view
    IF EXISTS (
        SELECT FROM information_schema.views 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans_with_details'
    ) THEN
        RAISE NOTICE '✅ View paid_loans_with_details criada com sucesso';
    ELSE
        RAISE WARNING '⚠️ View paid_loans_with_details não foi criada';
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
-- RESUMO FINAL
-- =====================================================

SELECT '🎉 CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!' as status;
SELECT 'A funcionalidade de marcar empréstimos como quitados agora deve funcionar!' as mensagem;
SELECT 'Teste no sistema: Empréstimos > Selecionar um empréstimo > Marcar como Quitado' as proximo_passo;
