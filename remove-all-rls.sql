-- =====================================================
-- SCRIPT PARA REMOVER TODAS AS POLÍTICAS RLS
-- =====================================================
-- Este script remove todas as políticas de Row Level Security
-- e desabilita o RLS em todas as tabelas do sistema
-- 
-- ATENÇÃO: Use este script com CUIDADO!
-- Remover RLS expõe todos os dados sem restrições de acesso
-- 
-- USO:
-- 1. Acesse o SQL Editor do Supabase
-- 2. Cole este script
-- 3. Execute com "Run"
-- =====================================================

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA USERS
-- =====================================================
DROP POLICY IF EXISTS "Users can view their own profile" ON users;
DROP POLICY IF EXISTS "Users can update their own profile" ON users;
DROP POLICY IF EXISTS "Admins can view all users" ON users;
DROP POLICY IF EXISTS "Admins can manage all users" ON users;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA CLIENTS
-- =====================================================
DROP POLICY IF EXISTS "Authenticated users can view all clients" ON clients;
DROP POLICY IF EXISTS "Authenticated users can insert clients" ON clients;
DROP POLICY IF EXISTS "Users can update clients they created or admins can update all" ON clients;
DROP POLICY IF EXISTS "Users can delete clients they created or admins can delete all" ON clients;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA LOANS
-- =====================================================
DROP POLICY IF EXISTS "Authenticated users can view all loans" ON loans;
DROP POLICY IF EXISTS "Authenticated users can insert loans" ON loans;
DROP POLICY IF EXISTS "Users can update loans they created or admins can update all" ON loans;
DROP POLICY IF EXISTS "Users can delete loans they created or admins can delete all" ON loans;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA PAYMENTS
-- =====================================================
DROP POLICY IF EXISTS "Authenticated users can view all payments" ON payments;
DROP POLICY IF EXISTS "Authenticated users can insert payments" ON payments;
DROP POLICY IF EXISTS "Users can update payments they created or admins can update all" ON payments;
DROP POLICY IF EXISTS "Users can delete payments they created or admins can delete all" ON payments;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA GUARANTORS
-- =====================================================
DROP POLICY IF EXISTS "Users can view all guarantors" ON guarantors;
DROP POLICY IF EXISTS "Users can insert guarantors" ON guarantors;
DROP POLICY IF EXISTS "Users can update guarantors they created or admins can update all" ON guarantors;
DROP POLICY IF EXISTS "Users can delete guarantors they created or admins can delete all" ON guarantors;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA EMERGENCY_CONTACTS
-- =====================================================
DROP POLICY IF EXISTS "Users can view all emergency contacts" ON emergency_contacts;
DROP POLICY IF EXISTS "Users can insert emergency contacts" ON emergency_contacts;
DROP POLICY IF EXISTS "Users can update emergency contacts they created or admins can update all" ON emergency_contacts;
DROP POLICY IF EXISTS "Users can delete emergency contacts they created or admins can delete all" ON emergency_contacts;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA CLIENT_DOCUMENTS
-- =====================================================
DROP POLICY IF EXISTS "Enable all operations for client_documents" ON client_documents;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA EXPENSE_CATEGORIES
-- =====================================================
DROP POLICY IF EXISTS "Anyone can view active expense categories" ON expense_categories;
DROP POLICY IF EXISTS "Admins can manage expense categories" ON expense_categories;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA EXPENSES
-- =====================================================
DROP POLICY IF EXISTS "Users can view own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can insert own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can update own expenses or admins can update all" ON expenses;
DROP POLICY IF EXISTS "Users can delete own expenses or admins can delete all" ON expenses;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA INSTALLMENTS
-- =====================================================
DROP POLICY IF EXISTS "Users can view installments" ON installments;
DROP POLICY IF EXISTS "Users can create installments" ON installments;
DROP POLICY IF EXISTS "Users can update installments" ON installments;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA INSTALLMENT_PAYMENTS
-- =====================================================
DROP POLICY IF EXISTS "Users can view installment payments" ON installment_payments;
DROP POLICY IF EXISTS "Users can create installment payments" ON installment_payments;
DROP POLICY IF EXISTS "Users can update installment payments" ON installment_payments;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA CASH_TRANSACTIONS
-- =====================================================
DROP POLICY IF EXISTS "Usuários autenticados podem ver transações de caixa" ON cash_transactions;
DROP POLICY IF EXISTS "Usuários autenticados podem inserir transações de caixa" ON cash_transactions;
DROP POLICY IF EXISTS "Usuários autenticados podem atualizar transações de caixa" ON cash_transactions;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA CASH_SETTINGS
-- =====================================================
DROP POLICY IF EXISTS "Usuários autenticados podem ver configurações de caixa" ON cash_settings;
DROP POLICY IF EXISTS "Usuários autenticados podem atualizar configurações de caixa" ON cash_settings;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA PAID_LOANS
-- =====================================================
DROP POLICY IF EXISTS "Authenticated users can view all paid loans" ON paid_loans;
DROP POLICY IF EXISTS "Authenticated users can insert paid loans" ON paid_loans;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA OVERDUE_LOANS
-- =====================================================
DROP POLICY IF EXISTS "Authenticated users can view all overdue loans" ON overdue_loans;
DROP POLICY IF EXISTS "Authenticated users can insert overdue loans" ON overdue_loans;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA PARTIAL_PAID_LOANS
-- =====================================================
DROP POLICY IF EXISTS "Authenticated users can view all partial paid loans" ON partial_paid_loans;
DROP POLICY IF EXISTS "Authenticated users can insert partial paid loans" ON partial_paid_loans;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA CANCELLED_LOANS
-- =====================================================
DROP POLICY IF EXISTS "Authenticated users can view all cancelled loans" ON cancelled_loans;
DROP POLICY IF EXISTS "Authenticated users can insert cancelled loans" ON cancelled_loans;

-- =====================================================
-- REMOVER POLÍTICAS DA TABELA CLIENT_PIX_KEYS (se existir)
-- =====================================================
DROP POLICY IF EXISTS "Users can view all pix keys" ON client_pix_keys;
DROP POLICY IF EXISTS "Users can insert pix keys" ON client_pix_keys;
DROP POLICY IF EXISTS "Users can update pix keys" ON client_pix_keys;
DROP POLICY IF EXISTS "Users can delete pix keys" ON client_pix_keys;

-- =====================================================
-- DESABILITAR RLS EM TODAS AS TABELAS
-- =====================================================

-- Tabelas principais
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE clients DISABLE ROW LEVEL SECURITY;
ALTER TABLE loans DISABLE ROW LEVEL SECURITY;
ALTER TABLE payments DISABLE ROW LEVEL SECURITY;

-- Tabelas auxiliares
ALTER TABLE guarantors DISABLE ROW LEVEL SECURITY;
ALTER TABLE emergency_contacts DISABLE ROW LEVEL SECURITY;
ALTER TABLE client_documents DISABLE ROW LEVEL SECURITY;
ALTER TABLE expense_categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE expenses DISABLE ROW LEVEL SECURITY;

-- Tabelas de parcelamento
ALTER TABLE installments DISABLE ROW LEVEL SECURITY;
ALTER TABLE installment_payments DISABLE ROW LEVEL SECURITY;

-- Tabelas de caixa
ALTER TABLE cash_transactions DISABLE ROW LEVEL SECURITY;
ALTER TABLE cash_settings DISABLE ROW LEVEL SECURITY;

-- Tabelas de status de empréstimos
ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;
ALTER TABLE overdue_loans DISABLE ROW LEVEL SECURITY;
ALTER TABLE partial_paid_loans DISABLE ROW LEVEL SECURITY;
ALTER TABLE cancelled_loans DISABLE ROW LEVEL SECURITY;

-- Tabela de chaves PIX (se existir)
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'client_pix_keys') THEN
        ALTER TABLE client_pix_keys DISABLE ROW LEVEL SECURITY;
    END IF;
END $$;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Listar todas as tabelas e seu status de RLS
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE schemaname = 'public'
AND tablename IN (
    'users', 'clients', 'loans', 'payments', 'guarantors', 
    'emergency_contacts', 'client_documents', 'expense_categories', 
    'expenses', 'installments', 'installment_payments', 
    'cash_transactions', 'cash_settings', 'paid_loans', 
    'overdue_loans', 'partial_paid_loans', 'cancelled_loans',
    'client_pix_keys', 'capital_raising', 'capital_raising_clients'
)
ORDER BY tablename;

-- Listar políticas restantes (deve retornar vazio)
SELECT 
    schemaname,
    tablename,
    policyname
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- =====================================================
-- MENSAGEM FINAL
-- =====================================================
SELECT 
    'RLS REMOVIDO COM SUCESSO!' as status,
    'Todas as políticas foram removidas e o RLS foi desabilitado em todas as tabelas.' as message,
    'ATENÇÃO: O banco de dados agora está sem restrições de acesso!' as warning;

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================
