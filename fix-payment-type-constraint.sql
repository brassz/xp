-- =====================================================
-- FIX PAYMENT TYPE CONSTRAINT
-- =====================================================
-- Este script corrige a constraint de payment_type na tabela payments
-- para aceitar os valores corretos do formulário

-- Remover a constraint antiga
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- Adicionar a nova constraint com todos os valores válidos
ALTER TABLE payments ADD CONSTRAINT payments_payment_type_check 
    CHECK (payment_type IN (
        'dinheiro', 'pix', 'cartao',           -- Métodos de pagamento do formulário
        'partial', 'full',                     -- Tipos de pagamento (parcial/total)
        'interest', 'principal', 'adjustment', -- Tipos especiais de pagamento
        'renewal', 'interest_renewal',         -- Renovações
        'capital_payment', 'partial_interest'  -- Outros tipos especiais
    ));

-- Atualizar o valor padrão
ALTER TABLE payments ALTER COLUMN payment_type SET DEFAULT 'dinheiro';

-- Atualizar comentário da coluna
COMMENT ON COLUMN payments.payment_type IS 'Tipo/método do pagamento (dinheiro, pix, cartao, partial, full, etc.)';

-- Verificar se existem registros com valores inválidos
SELECT DISTINCT payment_type, COUNT(*) as count 
FROM payments 
WHERE payment_type NOT IN (
    'dinheiro', 'pix', 'cartao', 'partial', 'full', 
    'interest', 'principal', 'adjustment', 'renewal', 
    'interest_renewal', 'capital_payment', 'partial_interest'
)
GROUP BY payment_type;