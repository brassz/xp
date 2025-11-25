-- =====================================================
-- CORRIGIR NOME DA COLUNA DE MULTA
-- =====================================================
-- Este script corrige o nome da coluna de multa de 'fine' para 'fine_amount'
-- e migra os dados existentes

-- Primeiro, verificar se a coluna 'fine_amount' já existe
DO $$ 
BEGIN
    -- Se fine_amount não existe, criar e migrar dados de fine
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'payments' AND column_name = 'fine_amount'
    ) THEN
        -- Adicionar a nova coluna fine_amount
        ALTER TABLE payments 
        ADD COLUMN fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);
        
        -- Migrar dados da coluna 'fine' para 'fine_amount' se a coluna 'fine' existir
        IF EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'payments' AND column_name = 'fine'
        ) THEN
            UPDATE payments SET fine_amount = COALESCE(fine, 0);
        END IF;
        
        RAISE NOTICE 'Coluna fine_amount criada e dados migrados com sucesso!';
    ELSE
        RAISE NOTICE 'Coluna fine_amount já existe';
    END IF;
END $$;

-- Adicionar comentário explicativo
COMMENT ON COLUMN payments.fine_amount IS 'Valor da multa aplicada ao pagamento (opcional, separado do valor principal)';

-- Criar índice para consultas de relatórios de multas
CREATE INDEX IF NOT EXISTS idx_payments_fine_amount ON payments(fine_amount) WHERE fine_amount > 0;

-- Verificar se a coluna foi adicionada corretamente
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default 
FROM information_schema.columns 
WHERE table_name = 'payments' AND column_name IN ('fine', 'fine_amount')
ORDER BY column_name;

-- Mostrar alguns registros com multa para verificar
SELECT 
    id, 
    amount, 
    fine_amount,
    payment_date,
    created_at
FROM payments 
WHERE fine_amount > 0 
LIMIT 5;

-- Estatísticas de multas
SELECT 
    COUNT(*) as total_pagamentos,
    COUNT(*) FILTER (WHERE fine_amount > 0) as pagamentos_com_multa,
    SUM(fine_amount) as total_multas
FROM payments;
