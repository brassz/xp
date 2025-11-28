-- =====================================================
-- VERIFICAR E CORRIGIR PERMISSÕES (RLS) NA TABELA PAYMENTS
-- =====================================================
-- Este script verifica se há políticas de RLS bloqueando o salvamento de fine_amount

-- Passo 1: Ver políticas atuais da tabela payments
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
WHERE tablename = 'payments';

-- Passo 2: Verificar se RLS está habilitado
SELECT 
    tablename,
    rowsecurity
FROM pg_tables
WHERE tablename = 'payments';

-- Passo 3: Ver permissões da tabela
SELECT 
    grantee,
    privilege_type
FROM information_schema.table_privileges
WHERE table_name = 'payments';

-- =====================================================
-- SOLUÇÃO: DESABILITAR RLS (se necessário)
-- =====================================================
-- ATENÇÃO: Apenas execute isso se você tiver certeza
-- Descomente as linhas abaixo se quiser desabilitar RLS

-- ALTER TABLE payments DISABLE ROW LEVEL SECURITY;

-- =====================================================
-- SOLUÇÃO ALTERNATIVA: Criar política permissiva
-- =====================================================
-- Se você quiser manter RLS mas permitir INSERT/UPDATE com fine_amount

-- Remover políticas existentes que podem estar bloqueando
-- DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON payments;
-- DROP POLICY IF EXISTS "Enable update for authenticated users only" ON payments;

-- Criar política de INSERT mais permissiva
-- CREATE POLICY "Enable insert with all fields for authenticated users"
-- ON payments FOR INSERT
-- TO authenticated
-- WITH CHECK (true);

-- Criar política de UPDATE mais permissiva
-- CREATE POLICY "Enable update with all fields for authenticated users"
-- ON payments FOR UPDATE
-- TO authenticated
-- USING (true)
-- WITH CHECK (true);

-- Criar política de SELECT
-- CREATE POLICY "Enable select for authenticated users"
-- ON payments FOR SELECT
-- TO authenticated
-- USING (true);

-- =====================================================
-- TESTE: Inserir pagamento com multa manualmente
-- =====================================================
-- Teste se você consegue inserir manualmente

-- Primeiro, pegar um loan_id válido
SELECT id as loan_id FROM loans LIMIT 1;

-- Depois, tentar inserir com multa (substitua LOAN_ID_AQUI pelo ID acima)
/*
INSERT INTO payments (
    loan_id,
    amount,
    fine_amount,
    payment_date,
    payment_type,
    notes
) VALUES (
    'LOAN_ID_AQUI',
    100.00,
    50.00,
    CURRENT_DATE,
    'dinheiro',
    'Teste de multa manual'
) RETURNING *;
*/

-- Verificar se foi inserido
-- SELECT id, amount, fine_amount, payment_date FROM payments WHERE notes LIKE '%Teste de multa manual%';

-- =====================================================
-- DIAGNÓSTICO COMPLETO
-- =====================================================

-- Ver estrutura completa da coluna fine_amount
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    is_updatable
FROM information_schema.columns 
WHERE table_name = 'payments' 
AND column_name = 'fine_amount';

-- Ver constraints da coluna
SELECT
    conname as constraint_name,
    contype as constraint_type,
    pg_get_constraintdef(oid) as definition
FROM pg_constraint
WHERE conrelid = 'payments'::regclass
AND conname LIKE '%fine%';

-- Ver últimos pagamentos
SELECT 
    id,
    loan_id,
    amount,
    fine_amount,
    payment_date,
    created_at
FROM payments
ORDER BY created_at DESC
LIMIT 10;
