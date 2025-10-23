-- =====================================================
-- SCRIPT PARA ADICIONAR CAMPO DE MULTA AOS PAGAMENTOS
-- =====================================================
-- Este script adiciona o campo 'fine_amount' (valor da multa) 
-- na tabela payments para registrar multas opcionais nos pagamentos

-- Adicionar coluna fine_amount na tabela payments
ALTER TABLE payments 
ADD COLUMN IF NOT EXISTS fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);

-- Adicionar comentário explicativo
COMMENT ON COLUMN payments.fine_amount IS 'Valor da multa aplicada ao pagamento (opcional)';

-- Também adicionar na tabela installment_payments para parcelamentos
ALTER TABLE installment_payments 
ADD COLUMN IF NOT EXISTS fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);

-- Adicionar comentário explicativo
COMMENT ON COLUMN installment_payments.fine_amount IS 'Valor da multa aplicada ao pagamento da parcela (opcional)';

-- Verificar se as colunas foram adicionadas com sucesso
SELECT 
    table_name, 
    column_name, 
    data_type, 
    column_default,
    is_nullable
FROM information_schema.columns 
WHERE table_name IN ('payments', 'installment_payments') 
AND column_name = 'fine_amount'
ORDER BY table_name, column_name;