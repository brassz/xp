-- =====================================================
-- FIX PARA RLS DOS EMPRÉSTIMOS
-- =====================================================
-- Este script corrige as políticas RLS para permitir acesso
-- aos empréstimos com o sistema de autenticação customizado
-- =====================================================

-- Remover as políticas existentes para empréstimos
DROP POLICY IF EXISTS "Authenticated users can view all loans" ON loans;
DROP POLICY IF EXISTS "Authenticated users can insert loans" ON loans;
DROP POLICY IF EXISTS "Users can update loans they created or admins can update all" ON loans;
DROP POLICY IF EXISTS "Users can delete loans they created or admins can delete all" ON loans;

-- Opção 1: Desabilitar RLS temporariamente para depuração
-- ALTER TABLE loans DISABLE ROW LEVEL SECURITY;

-- Opção 2: Criar políticas mais permissivas (recomendado para desenvolvimento)
-- Permitir acesso total para o role anon (usado pela aplicação)
CREATE POLICY "Allow all operations for anon role" ON loans
    FOR ALL USING (true)
    WITH CHECK (true);

-- Verificar se as políticas foram aplicadas
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'loans'
ORDER BY policyname;

-- Conceder permissões explícitas para o role anon
GRANT ALL ON loans TO anon;
GRANT ALL ON clients TO anon;
GRANT ALL ON payments TO anon;
GRANT ALL ON users TO anon;

-- Verificar permissões
SELECT 
    table_name,
    privilege_type,
    grantee
FROM information_schema.table_privileges 
WHERE table_name IN ('loans', 'clients', 'payments', 'users')
AND grantee = 'anon'
ORDER BY table_name, privilege_type;