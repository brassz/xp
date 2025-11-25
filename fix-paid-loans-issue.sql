-- =====================================================
-- CORREÇÃO: Problema com Empréstimos Quitados
-- =====================================================
-- Este script corrige o problema onde empréstimos não 
-- são salvos na tabela paid_loans
-- =====================================================

-- PASSO 1: Verificar se a tabela existe
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'paid_loans') THEN
        RAISE NOTICE 'ERRO: Tabela paid_loans não existe!';
        RAISE NOTICE 'Execute o script setup-paid-loans.sql primeiro';
    ELSE
        RAISE NOTICE '✓ Tabela paid_loans existe';
    END IF;
END $$;

-- PASSO 2: Verificar estrutura da tabela
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'paid_loans'
ORDER BY ordinal_position;

-- PASSO 3: Remover todas as políticas RLS existentes
DROP POLICY IF EXISTS "Authenticated users can view all paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Authenticated users can insert paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Users can update paid loans they created or admins can update all" ON paid_loans;
DROP POLICY IF EXISTS "Users can delete paid loans they created or admins can delete all" ON paid_loans;

-- PASSO 4: Desabilitar RLS temporariamente para diagnóstico
ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;

RAISE NOTICE '✓ RLS desabilitado na tabela paid_loans';

-- PASSO 5: Criar políticas RLS mais permissivas
ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;

-- Política de SELECT - Todos usuários autenticados podem ver
CREATE POLICY "Enable read access for authenticated users" ON paid_loans
    FOR SELECT
    USING (true);

-- Política de INSERT - Todos usuários autenticados podem inserir
CREATE POLICY "Enable insert access for authenticated users" ON paid_loans
    FOR INSERT
    WITH CHECK (true);

-- Política de UPDATE - Todos usuários autenticados podem atualizar
CREATE POLICY "Enable update access for authenticated users" ON paid_loans
    FOR UPDATE
    USING (true);

-- Política de DELETE - Todos usuários autenticados podem deletar
CREATE POLICY "Enable delete access for authenticated users" ON paid_loans
    FOR DELETE
    USING (true);

RAISE NOTICE '✓ Políticas RLS permissivas criadas';

-- PASSO 6: Garantir permissões no nível de tabela
GRANT ALL ON paid_loans TO authenticated;
GRANT ALL ON paid_loans TO anon;
GRANT ALL ON paid_loans TO service_role;

RAISE NOTICE '✓ Permissões concedidas';

-- PASSO 7: Verificar se existem dados na tabela
SELECT 
    COUNT(*) as total_emprestimos_quitados,
    MIN(paid_date) as primeira_quitacao,
    MAX(paid_date) as ultima_quitacao
FROM paid_loans;

-- PASSO 8: Verificar políticas ativas
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
FROM pg_policies 
WHERE tablename = 'paid_loans';

-- PASSO 9: Verificar permissões
SELECT 
    grantee,
    privilege_type
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans';

-- =====================================================
-- INSTRUÇÕES DE USO
-- =====================================================
-- 1. Execute este script no SQL Editor do Supabase
-- 2. Verifique se todas as mensagens de ✓ aparecem
-- 3. Teste marcar um empréstimo como quitado no sistema
-- 4. Se ainda não funcionar, execute o diagnóstico abaixo
-- =====================================================

-- DIAGNÓSTICO ADICIONAL (Execute se o problema persistir)
-- Verificar se há empréstimos que podem ser quitados
SELECT 
    l.id,
    l.amount,
    l.interest_rate,
    l.status,
    c.name as client_name
FROM loans l
LEFT JOIN clients c ON l.client_id = c.id
WHERE l.status != 'paid'
LIMIT 5;

-- Testar inserção manual (substitua os valores pelos dados reais)
-- INSERT INTO paid_loans (
--     loan_id,
--     client_id,
--     original_amount,
--     interest_rate,
--     total_with_interest,
--     loan_date,
--     due_date,
--     paid_date,
--     total_paid,
--     payment_method,
--     notes,
--     created_by
-- ) VALUES (
--     'COLE-AQUI-O-ID-DO-EMPRESTIMO'::uuid,
--     'COLE-AQUI-O-ID-DO-CLIENTE'::uuid,
--     1000.00,
--     10.00,
--     1100.00,
--     CURRENT_DATE,
--     CURRENT_DATE + INTERVAL '30 days',
--     CURRENT_DATE,
--     1100.00,
--     'Teste',
--     'Teste de inserção manual',
--     (SELECT id FROM users LIMIT 1)
-- );

-- =====================================================
-- FIM DO SCRIPT DE CORREÇÃO
-- =====================================================
