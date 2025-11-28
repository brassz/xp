-- =====================================================
-- SOLUÇÃO DEFINITIVA - CORRIGIR RLS PARA MULTAS
-- =====================================================
-- Execute TODO este código de uma vez no SQL Editor

-- PASSO 1: Manter RLS desabilitado (já está assim da opção 3)
-- Se você executou a opção 3, o RLS já está desabilitado
-- Vamos manter assim por enquanto

-- Verificar status atual
SELECT 
    tablename,
    rowsecurity as rls_habilitado
FROM pg_tables
WHERE tablename = 'payments';

-- PASSO 2: Remover TODAS as políticas antigas
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON payments;
DROP POLICY IF EXISTS "Enable update for authenticated users only" ON payments;
DROP POLICY IF EXISTS "Enable select for authenticated users only" ON payments;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON payments;
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON payments;
DROP POLICY IF EXISTS "Enable insert access for authenticated users" ON payments;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON payments;
DROP POLICY IF EXISTS "payments_insert_policy" ON payments;
DROP POLICY IF EXISTS "payments_update_policy" ON payments;
DROP POLICY IF EXISTS "payments_select_policy" ON payments;
DROP POLICY IF EXISTS "payments_delete_policy" ON payments;

-- PASSO 3: Criar políticas SIMPLES e COMPLETAS
-- Estas políticas permitem TODOS os campos (incluindo fine_amount)

CREATE POLICY "payments_all_access_authenticated"
ON payments
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- PASSO 4: Reabilitar RLS agora com as políticas corretas
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

-- PASSO 5: Verificar se funcionou
SELECT 'Verificação das políticas' as etapa;
SELECT policyname FROM pg_policies WHERE tablename = 'payments';

-- PASSO 6: Testar se funciona com RLS habilitado
SELECT 'Testando INSERT com multa (RLS habilitado)' as etapa;

INSERT INTO payments (
    loan_id,
    amount,
    fine_amount,
    payment_date,
    payment_type,
    notes
) 
SELECT 
    id,
    100.00,
    99.00,
    CURRENT_DATE,
    'dinheiro',
    '✅ TESTE FINAL - RLS habilitado com políticas corretas'
FROM loans 
LIMIT 1
RETURNING id, amount, fine_amount, notes;

-- PASSO 7: Verificar o que foi salvo
SELECT 'Verificando resultado' as etapa;

SELECT 
    id,
    amount,
    fine_amount,
    notes,
    created_at
FROM payments
WHERE notes LIKE '%TESTE FINAL%'
ORDER BY created_at DESC
LIMIT 1;

-- =====================================================
-- RESULTADO ESPERADO:
-- - fine_amount deve ser 99.00 (não 0)
-- - Se for 99.00 = ✅ FUNCIONOU!
-- - Se for 0.00 = ❌ Ainda tem problema
-- =====================================================

-- PASSO 8: Limpar pagamentos de teste (opcional)
-- Descomente se quiser limpar os testes
/*
DELETE FROM payments 
WHERE notes LIKE '%TESTE%' 
   OR notes LIKE '%teste%'
   OR notes LIKE '%MANUAL%';
*/
