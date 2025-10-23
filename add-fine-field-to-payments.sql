-- =====================================================
-- ADICIONAR CAMPO DE MULTA NA TABELA DE PAGAMENTOS
-- =====================================================
-- Este script adiciona um campo opcional de multa na tabela payments
-- A multa é um valor separado do valor principal do pagamento

-- Adicionar coluna de multa na tabela payments
ALTER TABLE payments 
ADD COLUMN IF NOT EXISTS fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);

-- Adicionar comentário explicativo
COMMENT ON COLUMN payments.fine_amount IS 'Valor da multa aplicada ao pagamento (opcional, separado do valor principal)';

-- Criar índice para consultas de relatórios de multas
CREATE INDEX IF NOT EXISTS idx_payments_fine_amount ON payments(fine_amount) WHERE fine_amount > 0;

-- Verificar se a coluna foi adicionada corretamente
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'payments' AND column_name = 'fine_amount';

-- Exemplo de consulta para relatórios de multas
-- Total de multas por período
/*
SELECT 
    DATE_TRUNC('week', payment_date) as semana,
    SUM(fine_amount) as total_multas_semana,
    COUNT(*) FILTER (WHERE fine_amount > 0) as quantidade_multas
FROM payments 
WHERE fine_amount > 0 
GROUP BY DATE_TRUNC('week', payment_date)
ORDER BY semana DESC;
*/

-- Total de multas por mês
/*
SELECT 
    DATE_TRUNC('month', payment_date) as mes,
    SUM(fine_amount) as total_multas_mes,
    COUNT(*) FILTER (WHERE fine_amount > 0) as quantidade_multas
FROM payments 
WHERE fine_amount > 0 
GROUP BY DATE_TRUNC('month', payment_date)
ORDER BY mes DESC;
*/