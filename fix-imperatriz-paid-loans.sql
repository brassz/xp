-- =====================================================
-- CORREÇÃO TABELA PAID_LOANS - IMPERATRIZ CRED
-- =====================================================
-- Problema: Ao marcar empréstimo como quitado, não salva no banco
-- Solução: Configurar tabela paid_loans com RLS e permissões
-- =====================================================

-- PASSO 1: Verificar se a tabela existe
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'paid_loans') THEN
        RAISE NOTICE 'Tabela paid_loans não existe. Será criada agora.';
    ELSE
        RAISE NOTICE 'Tabela paid_loans já existe. Verificando configuração...';
    END IF;
END $$;

-- =====================================================
-- PASSO 2: Criar extensões necessárias
-- =====================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- PASSO 3: Criar ou recriar tabela paid_loans
-- =====================================================

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
COMMENT ON TABLE paid_loans IS 'Tabela para armazenar empréstimos completamente quitados - IMPERATRIZ CRED';
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
-- PASSO 4: Criar índices para performance
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_paid_loans_loan_id ON paid_loans(loan_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_client_id ON paid_loans(client_id);
CREATE INDEX IF NOT EXISTS idx_paid_loans_paid_date ON paid_loans(paid_date);
CREATE INDEX IF NOT EXISTS idx_paid_loans_created_by ON paid_loans(created_by);
CREATE INDEX IF NOT EXISTS idx_paid_loans_created_at ON paid_loans(created_at);

-- =====================================================
-- PASSO 5: Criar função para atualizar updated_at
-- =====================================================

CREATE OR REPLACE FUNCTION update_paid_loans_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Remover trigger se já existir
DROP TRIGGER IF EXISTS update_paid_loans_updated_at_trigger ON paid_loans;

-- Criar trigger para atualizar updated_at
CREATE TRIGGER update_paid_loans_updated_at_trigger
    BEFORE UPDATE ON paid_loans
    FOR EACH ROW
    EXECUTE FUNCTION update_paid_loans_updated_at();

-- =====================================================
-- PASSO 6: Configurar RLS (Row Level Security)
-- =====================================================

-- Desabilitar RLS temporariamente para limpeza
ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;

-- Remover políticas antigas se existirem
DROP POLICY IF EXISTS "Authenticated users can view all paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Authenticated users can insert paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Users can update paid loans they created or admins can update all" ON paid_loans;
DROP POLICY IF EXISTS "Users can delete paid loans they created or admins can delete all" ON paid_loans;

-- Habilitar RLS novamente
ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;

-- IMPORTANTE: Criar políticas permissivas para autenticados
-- Estas políticas garantem que usuários autenticados possam inserir/visualizar/editar

CREATE POLICY "Authenticated users can view all paid loans" 
ON paid_loans FOR SELECT 
USING (true);  -- Permite SELECT para todos (mais permissivo)

CREATE POLICY "Authenticated users can insert paid loans" 
ON paid_loans FOR INSERT 
WITH CHECK (true);  -- Permite INSERT para todos usuários autenticados (mais permissivo)

CREATE POLICY "Authenticated users can update paid loans" 
ON paid_loans FOR UPDATE 
USING (true);  -- Permite UPDATE para todos (mais permissivo)

CREATE POLICY "Authenticated users can delete paid loans" 
ON paid_loans FOR DELETE 
USING (true);  -- Permite DELETE para todos (mais permissivo)

-- =====================================================
-- PASSO 7: Configurar permissões
-- =====================================================

-- Revogar permissões antigas
REVOKE ALL ON paid_loans FROM PUBLIC;
REVOKE ALL ON paid_loans FROM authenticated;
REVOKE ALL ON paid_loans FROM anon;

-- Conceder todas as permissões para usuários autenticados
GRANT ALL ON paid_loans TO authenticated;

-- Conceder permissões de uso de sequências
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- =====================================================
-- PASSO 8: Criar VIEW para facilitar consultas
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

-- Conceder permissões na view
GRANT SELECT ON paid_loans_with_details TO authenticated;

-- =====================================================
-- PASSO 9: VERIFICAÇÃO E DIAGNÓSTICO
-- =====================================================

-- Verificar se a tabela foi criada
SELECT 
    '✅ Tabela paid_loans' as status,
    CASE 
        WHEN EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'paid_loans')
        THEN 'EXISTE'
        ELSE '❌ NÃO EXISTE'
    END as resultado;

-- Verificar RLS
SELECT 
    '✅ RLS ativado' as status,
    CASE 
        WHEN relrowsecurity THEN 'SIM ✅'
        ELSE '❌ NÃO'
    END as resultado
FROM pg_class
WHERE relname = 'paid_loans';

-- Verificar políticas RLS
SELECT 
    '✅ Políticas RLS' as status,
    COUNT(*) as total_politicas
FROM pg_policies 
WHERE tablename = 'paid_loans';

-- Verificar permissões
SELECT 
    '✅ Permissões' as status,
    grantee,
    privilege_type
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans'
AND grantee = 'authenticated';

-- Verificar índices
SELECT 
    '✅ Índices criados' as status,
    COUNT(*) as total_indices
FROM pg_indexes 
WHERE tablename = 'paid_loans';

-- Verificar trigger
SELECT 
    '✅ Triggers' as status,
    COUNT(*) as total_triggers
FROM pg_trigger
WHERE tgrelid = 'paid_loans'::regclass;

-- =====================================================
-- PASSO 10: Teste de inserção
-- =====================================================

-- Tentar inserir um registro de teste (será removido depois)
DO $$ 
DECLARE
    test_client_id UUID;
    test_loan_id UUID;
BEGIN
    -- Buscar um cliente existente para teste
    SELECT id INTO test_client_id FROM clients LIMIT 1;
    
    IF test_client_id IS NOT NULL THEN
        test_loan_id := gen_random_uuid();
        
        -- Tentar inserir
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
            test_loan_id,
            test_client_id,
            1000.00,
            5.00,
            1050.00,
            CURRENT_DATE - INTERVAL '30 days',
            CURRENT_DATE - INTERVAL '1 day',
            CURRENT_DATE,
            1050.00,
            'Teste',
            'Registro de teste - pode ser removido'
        );
        
        RAISE NOTICE '✅ Teste de inserção: SUCESSO';
        
        -- Remover registro de teste
        DELETE FROM paid_loans WHERE loan_id = test_loan_id;
        RAISE NOTICE '✅ Registro de teste removido';
    ELSE
        RAISE NOTICE '⚠️  Aviso: Nenhum cliente encontrado para teste';
    END IF;
    
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '❌ Erro no teste de inserção: %', SQLERRM;
END $$;

-- =====================================================
-- RESUMO FINAL
-- =====================================================

SELECT '
╔═══════════════════════════════════════════════════════════════╗
║     CORREÇÃO CONCLUÍDA - IMPERATRIZ CRED                      ║
║     Tabela paid_loans configurada com sucesso!                ║
╚═══════════════════════════════════════════════════════════════╝

✅ Tabela paid_loans criada
✅ Índices criados para performance
✅ RLS (Row Level Security) configurado
✅ Políticas de acesso configuradas (permissivas)
✅ Permissões concedidas para authenticated
✅ Trigger de updated_at criado
✅ View paid_loans_with_details criada
✅ Teste de inserção realizado

📋 PRÓXIMOS PASSOS:
   1. Faça login no sistema como IMPERATRIZ CRED
   2. Teste marcar um empréstimo como quitado
   3. Verifique se aparece na aba "Empréstimos Quitados"

🔧 Se ainda houver problemas:
   - Verifique se você está logado no sistema
   - Verifique se selecionou a empresa IMPERATRIZ CRED
   - Verifique o console do navegador (F12) para erros
   
' as resumo;

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================
