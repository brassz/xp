-- =====================================================
-- CORREÇÃO URGENTE - ERRO 400 (fine_amount não existe)
-- =====================================================
-- Execute IMEDIATAMENTE no Supabase → SQL Editor

-- O problema: O código JavaScript está tentando buscar fine_amount
-- mas a coluna foi removida, causando erro 400
-- Solução: Adicionar a coluna de volta (vazia)

-- =====================================================
-- ADICIONAR COLUNA fine_amount DE VOLTA
-- =====================================================

ALTER TABLE payments 
ADD COLUMN IF NOT EXISTS fine_amount DECIMAL(10,2) DEFAULT 0.00 NOT NULL;

-- Adicionar constraint simples
ALTER TABLE payments
ADD CONSTRAINT fine_amount_non_negative CHECK (fine_amount >= 0);

-- =====================================================
-- VERIFICAR SE FOI CRIADA
-- =====================================================

SELECT 'Verificando coluna fine_amount' as etapa;

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'payments' 
AND column_name = 'fine_amount';

-- =====================================================
-- ATUALIZAR TODOS OS VALORES PARA 0
-- =====================================================

-- Garantir que todos os pagamentos têm fine_amount = 0
UPDATE payments 
SET fine_amount = 0.00 
WHERE fine_amount IS NULL;

SELECT 'Valores atualizados' as etapa;

-- =====================================================
-- VERIFICAR ÚLTIMOS PAGAMENTOS
-- =====================================================

SELECT 'Últimos 10 pagamentos com fine_amount' as etapa;

SELECT 
    id,
    loan_id,
    amount,
    fine_amount,
    payment_date,
    notes
FROM payments
ORDER BY created_at DESC
LIMIT 10;

-- =====================================================
-- RESULTADO ESPERADO:
-- ✅ Coluna fine_amount criada
-- ✅ Todos os valores = 0.00
-- ✅ Erro 400 deve parar de aparecer
-- ✅ Valores restantes voltam a calcular
-- =====================================================

SELECT '✅ CORREÇÃO APLICADA! Recarregue o sistema (Ctrl+Shift+R)' as resultado;
