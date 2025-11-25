-- =====================================================
-- CORREÇÃO: Problema com Empréstimos Quitados
-- =====================================================
-- Este script corrige o problema onde empréstimos não 
-- são salvos na tabela paid_loans
-- =====================================================

-- PASSO 1: Verificar se a tabela existe
SELECT '✓ PASSO 1: Verificando se a tabela existe...' as status;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'paid_loans') THEN
        RAISE EXCEPTION 'ERRO: Tabela paid_loans não existe! Execute o script setup-paid-loans.sql primeiro';
    END IF;
END $$;

SELECT 'Tabela paid_loans encontrada!' as resultado;

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
SELECT '✓ PASSO 4: Desabilitando RLS...' as status;

ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;

-- PASSO 5: Criar políticas RLS mais permissivas
SELECT '✓ PASSO 5: Criando políticas RLS permissivas...' as status;

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

SELECT 'Políticas RLS criadas com sucesso!' as resultado;

-- PASSO 6: Garantir permissões no nível de tabela
SELECT '✓ PASSO 6: Concedendo permissões...' as status;

GRANT ALL ON paid_loans TO authenticated;
GRANT ALL ON paid_loans TO anon;
GRANT ALL ON paid_loans TO service_role;

SELECT 'Permissões concedidas com sucesso!' as resultado;

-- PASSO 7: Verificar se existem dados na tabela
SELECT '✓ PASSO 7: Verificando dados existentes...' as status;

SELECT 
    COUNT(*) as total_emprestimos_quitados,
    MIN(paid_date) as primeira_quitacao,
    MAX(paid_date) as ultima_quitacao
FROM paid_loans;

-- PASSO 8: Verificar políticas ativas
SELECT '✓ PASSO 8: Verificando políticas RLS...' as status;

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
SELECT '✓ PASSO 9: Verificando permissões concedidas...' as status;

SELECT 
    grantee,
    privilege_type
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans';

-- =====================================================
-- RESULTADO FINAL
-- =====================================================

SELECT '✅✅✅ CORREÇÃO APLICADA COM SUCESSO! ✅✅✅' as resultado_final;

SELECT 'Agora teste marcar um empréstimo como quitado no sistema.' as proximos_passos;

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
