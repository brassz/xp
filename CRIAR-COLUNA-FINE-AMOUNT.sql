-- =====================================================
-- SOLUÇÃO DEFINITIVA: CRIAR COLUNA fine_amount
-- =====================================================
-- Execute este script NO PAINEL DO SUPABASE
-- SQL Editor → New Query → Cole este código → Run

-- Passo 1: Criar a coluna (se não existir)
ALTER TABLE payments 
ADD COLUMN IF NOT EXISTS fine_amount DECIMAL(10,2) DEFAULT 0.00;

-- Passo 2: Atualizar valores NULL para 0
UPDATE payments 
SET fine_amount = 0.00 
WHERE fine_amount IS NULL;

-- Passo 3: Tornar a coluna NOT NULL
ALTER TABLE payments 
ALTER COLUMN fine_amount SET NOT NULL;

-- Passo 4: Adicionar constraint para valores não-negativos
ALTER TABLE payments
DROP CONSTRAINT IF EXISTS fine_amount_non_negative;

ALTER TABLE payments
ADD CONSTRAINT fine_amount_non_negative CHECK (fine_amount >= 0);

-- Passo 5: Criar índice para otimização
CREATE INDEX IF NOT EXISTS idx_payments_fine_amount 
ON payments(fine_amount) 
WHERE fine_amount > 0;

-- Passo 6: Adicionar comentário
COMMENT ON COLUMN payments.fine_amount IS 'Valor da multa aplicada ao pagamento (separado do valor principal)';

-- =====================================================
-- VERIFICAÇÃO
-- =====================================================

-- Verificar se a coluna foi criada
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'payments' 
AND column_name = 'fine_amount';

-- Mostrar estrutura atual da tabela payments
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'payments'
ORDER BY ordinal_position;

-- Contar pagamentos
SELECT 
    COUNT(*) as total_pagamentos,
    SUM(CASE WHEN fine_amount > 0 THEN 1 ELSE 0 END) as com_multas
FROM payments;

-- Mostrar últimos 5 pagamentos
SELECT 
    id,
    loan_id,
    amount,
    fine_amount,
    payment_date,
    created_at
FROM payments 
ORDER BY created_at DESC 
LIMIT 5;

-- =====================================================
-- MENSAGEM DE SUCESSO
-- =====================================================
-- Se chegou até aqui sem erros, a coluna foi criada!
-- Agora recarregue a página do sistema (Ctrl + Shift + R)
