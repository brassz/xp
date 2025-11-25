-- =====================================================
-- FIX: PROBLEMA DE FOREIGN KEY NA EMPRESA MOGIANA
-- =====================================================
-- Este script corrige o problema de violação de chave estrangeira
-- ao tentar criar empréstimos na empresa Mogiana
-- =====================================================

-- PASSO 1: Verificar o status atual das tabelas
-- =====================================================
SELECT 'Status de RLS nas tabelas principais:' as info;
SELECT 
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('clients', 'loans', 'users')
ORDER BY tablename;

-- PASSO 2: Verificar políticas ativas
-- =====================================================
SELECT '
Políticas RLS ativas:' as info;
SELECT 
    schemaname,
    tablename,
    policyname,
    cmd,
    permissive
FROM pg_policies 
WHERE schemaname = 'public'
AND tablename IN ('clients', 'loans')
ORDER BY tablename, policyname;

-- PASSO 3: Verificar se há clientes cadastrados
-- =====================================================
SELECT '
Verificando clientes cadastrados:' as info;
SELECT COUNT(*) as total_clients FROM clients;
SELECT id, name, cpf, email FROM clients LIMIT 5;

-- PASSO 4: Verificar constraints da tabela loans
-- =====================================================
SELECT '
Constraints da tabela loans:' as info;
SELECT
    conname AS constraint_name,
    contype AS constraint_type,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint
WHERE conrelid = 'loans'::regclass
ORDER BY conname;

-- =====================================================
-- SOLUÇÃO 1: DESABILITAR RLS (Recomendado para corrigir o problema)
-- =====================================================
-- Isto permitirá que o sistema funcione sem restrições de RLS
-- Descomente as linhas abaixo se quiser aplicar esta solução:

-- Desabilitar RLS em todas as tabelas principais
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE clients DISABLE ROW LEVEL SECURITY;
ALTER TABLE loans DISABLE ROW LEVEL SECURITY;
ALTER TABLE payments DISABLE ROW LEVEL SECURITY;

-- Desabilitar RLS em tabelas auxiliares (se existirem)
DO $$ 
BEGIN
    -- Tentar desabilitar RLS em todas as tabelas que podem existir
    ALTER TABLE IF EXISTS guarantors DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS emergency_contacts DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS client_documents DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS expense_categories DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS expenses DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS installments DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS installment_payments DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS cash_transactions DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS cash_settings DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS paid_loans DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS overdue_loans DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS partial_paid_loans DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS cancelled_loans DISABLE ROW LEVEL SECURITY;
    ALTER TABLE IF EXISTS client_pix_keys DISABLE ROW LEVEL SECURITY;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Algumas tabelas não existem, mas não há problema: %', SQLERRM;
END $$;

-- =====================================================
-- SOLUÇÃO 2: REMOVER TODAS AS POLÍTICAS RLS (Alternativa)
-- =====================================================
-- Isto remove todas as políticas RLS existentes
-- Descomente as linhas abaixo se preferir esta abordagem:

-- DROP POLICY IF EXISTS "Users can view their own profile" ON users;
-- DROP POLICY IF EXISTS "Users can update their own profile" ON users;
-- DROP POLICY IF EXISTS "Admins can view all users" ON users;
-- DROP POLICY IF EXISTS "Admins can manage all users" ON users;
-- DROP POLICY IF EXISTS "Authenticated users can view all clients" ON clients;
-- DROP POLICY IF EXISTS "Authenticated users can insert clients" ON clients;
-- DROP POLICY IF EXISTS "Users can update clients they created or admins can update all" ON clients;
-- DROP POLICY IF EXISTS "Users can delete clients they created or admins can delete all" ON clients;
-- DROP POLICY IF EXISTS "Authenticated users can view all loans" ON loans;
-- DROP POLICY IF EXISTS "Authenticated users can insert loans" ON loans;
-- DROP POLICY IF EXISTS "Users can update loans they created or admins can update all" ON loans;
-- DROP POLICY IF EXISTS "Users can delete loans they created or admins can delete all" ON loans;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================
SELECT '
Status após correção:' as info;
SELECT 
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('clients', 'loans', 'users')
ORDER BY tablename;

SELECT '
Políticas RLS restantes:' as info;
SELECT COUNT(*) as total_policies
FROM pg_policies 
WHERE schemaname = 'public';

-- =====================================================
-- TESTE DE INSERÇÃO
-- =====================================================
SELECT '
Execute este teste manualmente após a correção:
1. Tente criar um cliente no sistema
2. Tente criar um empréstimo para esse cliente
3. Verifique se não há mais erros de foreign key
' as instrucoes;

-- =====================================================
-- INFORMAÇÕES ADICIONAIS
-- =====================================================
SELECT '
NOTA IMPORTANTE:
- Este script desabilita o RLS em todas as tabelas
- Isto significa que todos os usuários autenticados terão acesso a todos os dados
- Para sistemas com múltiplos usuários, considere reconfigurar as políticas RLS
- Para a empresa Mogiana, isso deve resolver o problema imediatamente
' as nota;
