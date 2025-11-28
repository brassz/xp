-- =====================================================
-- REVERTER TODAS AS ALTERAÇÕES DE MULTAS
-- =====================================================
-- Este script remove TUDO relacionado a multas (fine_amount)
-- Execute no Supabase → SQL Editor

-- =====================================================
-- PASSO 1: REMOVER PAGAMENTOS DE TESTE
-- =====================================================

-- Remover todos os pagamentos de teste criados durante os diagnósticos
DELETE FROM payments 
WHERE notes LIKE '%TESTE%' 
   OR notes LIKE '%teste%'
   OR notes LIKE '%TEST%'
   OR notes LIKE '%MANUAL%'
   OR notes LIKE '%🔥%'
   OR notes LIKE '%✅%';

SELECT 'Pagamentos de teste removidos' as status;

-- =====================================================
-- PASSO 2: REMOVER ÍNDICE DA COLUNA fine_amount
-- =====================================================

DROP INDEX IF EXISTS idx_payments_fine_amount;

SELECT 'Índice removido' as status;

-- =====================================================
-- PASSO 3: REMOVER CONSTRAINTS DA COLUNA fine_amount
-- =====================================================

ALTER TABLE payments 
DROP CONSTRAINT IF EXISTS fine_amount_non_negative;

ALTER TABLE payments
DROP CONSTRAINT IF EXISTS payments_fine_amount_check;

SELECT 'Constraints removidos' as status;

-- =====================================================
-- PASSO 4: REMOVER A COLUNA fine_amount
-- =====================================================

ALTER TABLE payments 
DROP COLUMN IF EXISTS fine_amount;

SELECT 'Coluna fine_amount removida' as status;

-- =====================================================
-- PASSO 5: RESTAURAR POLÍTICAS RLS ORIGINAIS
-- =====================================================

-- Remover políticas que foram criadas durante os testes
DROP POLICY IF EXISTS "payments_all_access_authenticated" ON payments;
DROP POLICY IF EXISTS "payments_insert_policy" ON payments;
DROP POLICY IF EXISTS "payments_update_policy" ON payments;
DROP POLICY IF EXISTS "payments_select_policy" ON payments;
DROP POLICY IF EXISTS "payments_delete_policy" ON payments;

-- Recriar políticas padrão do Supabase (ajuste conforme necessário)
-- Nota: Estas são políticas genéricas, você pode precisar ajustar
-- conforme as políticas originais do seu sistema

CREATE POLICY "Enable insert for authenticated users only"
ON payments FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "Enable select for authenticated users only"
ON payments FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Enable update for authenticated users only"
ON payments FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Enable delete for users based on user_id"
ON payments FOR DELETE
TO authenticated
USING (true);

-- Garantir que RLS está habilitado
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

SELECT 'Políticas RLS restauradas' as status;

-- =====================================================
-- PASSO 6: VERIFICAR ESTRUTURA FINAL
-- =====================================================

-- Verificar colunas da tabela payments
SELECT 'Colunas atuais da tabela payments:' as info;

SELECT column_name, data_type
FROM information_schema.columns 
WHERE table_name = 'payments'
ORDER BY ordinal_position;

-- Verificar se fine_amount foi removida
SELECT 'Verificando se fine_amount foi removida:' as info;

SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM information_schema.columns 
            WHERE table_name = 'payments' 
            AND column_name = 'fine_amount'
        ) 
        THEN '❌ AINDA EXISTE - Execute o script novamente'
        ELSE '✅ REMOVIDA COM SUCESSO'
    END as resultado;

-- Verificar políticas atuais
SELECT 'Políticas RLS atuais:' as info;

SELECT policyname, cmd
FROM pg_policies
WHERE tablename = 'payments';

-- Verificar status do RLS
SELECT 'Status do RLS:' as info;

SELECT 
    tablename,
    CASE 
        WHEN rowsecurity = true THEN '✅ HABILITADO'
        ELSE '❌ DESABILITADO'
    END as status_rls
FROM pg_tables
WHERE tablename = 'payments';

-- =====================================================
-- RESULTADO ESPERADO:
-- ✅ Coluna fine_amount removida
-- ✅ Índices e constraints removidos
-- ✅ Políticas RLS restauradas
-- ✅ RLS habilitado
-- ✅ Pagamentos de teste deletados
-- =====================================================

SELECT '✅ REVERSÃO COMPLETA!' as resultado;
