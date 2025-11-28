-- =====================================================
-- VERIFICAR E ADICIONAR CAMPO DE MULTA (fine_amount)
-- =====================================================
-- Este script verifica se a coluna fine_amount existe
-- e a cria se necessário

-- Verificar se a coluna já existe
DO $$ 
BEGIN
    -- Verificar se a coluna existe
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'payments' 
        AND column_name = 'fine_amount'
    ) THEN
        -- Adicionar coluna se não existir
        ALTER TABLE payments 
        ADD COLUMN fine_amount DECIMAL(10,2) DEFAULT 0.00;
        
        -- Adicionar constraint
        ALTER TABLE payments
        ADD CONSTRAINT fine_amount_non_negative CHECK (fine_amount >= 0);
        
        -- Adicionar comentário
        COMMENT ON COLUMN payments.fine_amount IS 'Valor da multa aplicada ao pagamento (opcional, separado do valor principal)';
        
        -- Criar índice para otimizar consultas
        CREATE INDEX idx_payments_fine_amount ON payments(fine_amount) WHERE fine_amount > 0;
        
        RAISE NOTICE 'Coluna fine_amount adicionada com sucesso!';
    ELSE
        RAISE NOTICE 'Coluna fine_amount já existe!';
    END IF;
END $$;

-- Verificar estrutura da coluna
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns 
WHERE table_name = 'payments' 
AND column_name = 'fine_amount';

-- Verificar se há pagamentos com multas
SELECT 
    COUNT(*) as total_payments,
    COUNT(CASE WHEN fine_amount > 0 THEN 1 END) as payments_with_fines,
    SUM(fine_amount) as total_fines
FROM payments;

-- Listar os últimos 10 pagamentos com suas multas (se houver)
SELECT 
    id,
    loan_id,
    amount,
    fine_amount,
    payment_date,
    payment_type,
    created_at
FROM payments 
ORDER BY created_at DESC 
LIMIT 10;
