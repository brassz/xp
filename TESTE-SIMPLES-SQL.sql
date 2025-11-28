-- =====================================================
-- TESTE SIMPLES - COPIE E EXECUTE TUDO DE UMA VEZ
-- =====================================================
-- Cole tudo isso no SQL Editor do Supabase e clique RUN

-- ============= INFORMAÇÕES DA COLUNA =============
SELECT 'TESTE 1: Estrutura da coluna fine_amount' as teste;

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    is_updatable
FROM information_schema.columns 
WHERE table_name = 'payments' 
AND column_name = 'fine_amount';

-- ============= RLS HABILITADO? =============
SELECT 'TESTE 2: RLS está habilitado?' as teste;

SELECT 
    tablename,
    rowsecurity as rls_habilitado
FROM pg_tables
WHERE tablename = 'payments';

-- ============= POLÍTICAS DE SEGURANÇA =============
SELECT 'TESTE 3: Políticas RLS' as teste;

SELECT 
    policyname as nome_politica,
    cmd as comando,
    roles as funcoes
FROM pg_policies
WHERE tablename = 'payments';

-- ============= TODAS AS COLUNAS =============
SELECT 'TESTE 4: Todas as colunas da tabela payments' as teste;

SELECT column_name
FROM information_schema.columns 
WHERE table_name = 'payments'
ORDER BY ordinal_position;

-- ============= CONSTRAINTS =============
SELECT 'TESTE 5: Constraints da tabela' as teste;

SELECT
    conname as constraint_name,
    contype as type
FROM pg_constraint
WHERE conrelid = 'payments'::regclass;

-- ============= ÚLTIMOS PAGAMENTOS =============
SELECT 'TESTE 6: Últimos 5 pagamentos' as teste;

SELECT 
    id,
    amount,
    fine_amount,
    payment_date,
    created_at
FROM payments
ORDER BY created_at DESC
LIMIT 5;

-- ============= TESTE DE INSERT =============
SELECT 'TESTE 7: Tentando inserir pagamento com multa' as teste;

-- Primeiro desabilita RLS temporariamente
ALTER TABLE payments DISABLE ROW LEVEL SECURITY;

-- Tenta inserir
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
    88.00,
    CURRENT_DATE,
    'dinheiro',
    '🔥 TESTE SQL DIRETO 🔥'
FROM loans 
LIMIT 1
RETURNING id, amount, fine_amount, notes;

-- ============= VERIFICAR SE SALVOU =============
SELECT 'TESTE 8: Verificando se salvou' as teste;

SELECT 
    id,
    amount,
    fine_amount,
    notes,
    created_at
FROM payments
WHERE notes LIKE '%TESTE SQL DIRETO%'
ORDER BY created_at DESC
LIMIT 1;

-- ============= REABILITAR RLS =============
-- Descomente a linha abaixo se quiser reabilitar RLS
-- ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- RESULTADO ESPERADO:
-- - TESTE 1: Deve mostrar fine_amount com tipo numeric/decimal
-- - TESTE 2: Mostra se RLS está true ou false
-- - TESTE 3: Lista todas as políticas
-- - TESTE 4: Lista todas as colunas (fine_amount deve estar lá)
-- - TESTE 5: Lista constraints
-- - TESTE 6: Mostra últimos pagamentos
-- - TESTE 7: Insere pagamento com fine_amount = 88.00
-- - TESTE 8: Confirma que salvou com fine_amount = 88.00
-- =====================================================

-- SE O TESTE 8 MOSTRAR fine_amount = 88.00:
-- ✅ A coluna funciona! O problema é RLS ou código JavaScript

-- SE O TESTE 8 MOSTRAR fine_amount = 0 ou NULL:
-- ❌ Problema mais profundo no banco de dados
