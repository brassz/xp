-- =====================================================
-- CORREÇÃO: MULTAS NÃO APARECEM NO HISTÓRICO E RELATÓRIOS
-- =====================================================
-- Data: 2025-12-23
-- Problema: Ao incluir uma multa na aba de empréstimos, a multa não aparece 
--           no histórico de pagamentos nem na aba de relatórios
-- Causa: Campo fine_amount pode não existir no banco de dados
-- Solução: Garantir que o campo existe e tem valor padrão

-- Passo 1: Verificar se a coluna fine_amount existe
DO $$
BEGIN
    -- Tentar adicionar a coluna fine_amount se não existir
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'payments' 
        AND column_name = 'fine_amount'
    ) THEN
        -- Adicionar coluna
        ALTER TABLE payments 
        ADD COLUMN fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);
        
        RAISE NOTICE '✅ Coluna fine_amount adicionada com sucesso à tabela payments';
    ELSE
        RAISE NOTICE '✓ Coluna fine_amount já existe na tabela payments';
    END IF;
END $$;

-- Passo 2: Garantir que registros existentes tenham valor padrão
UPDATE payments 
SET fine_amount = 0.00 
WHERE fine_amount IS NULL;

-- Passo 3: Adicionar comentário explicativo
COMMENT ON COLUMN payments.fine_amount IS 'Valor da multa aplicada ao pagamento (opcional, separado do valor principal)';

-- Passo 4: Criar índice para consultas de relatórios de multas (se não existir)
CREATE INDEX IF NOT EXISTS idx_payments_fine_amount 
ON payments(fine_amount) 
WHERE fine_amount > 0;

-- Passo 5: Verificar estrutura final
SELECT 
    '=== VERIFICAÇÃO DA ESTRUTURA DA TABELA PAYMENTS ===' as verificacao;

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'payments' 
AND column_name IN ('id', 'loan_id', 'amount', 'fine_amount', 'payment_date', 'payment_type')
ORDER BY ordinal_position;

-- Passo 6: Estatísticas de multas
SELECT 
    '=== ESTATÍSTICAS DE MULTAS ===' as verificacao;

SELECT 
    COUNT(*) as total_pagamentos,
    COUNT(*) FILTER (WHERE fine_amount > 0) as pagamentos_com_multa,
    SUM(amount) as total_pagamentos_valor,
    SUM(fine_amount) as total_multas_valor,
    AVG(fine_amount) FILTER (WHERE fine_amount > 0) as media_multas,
    MAX(fine_amount) as maior_multa
FROM payments;

-- Passo 7: Exemplos de pagamentos com multa (se houver)
SELECT 
    '=== EXEMPLOS DE PAGAMENTOS COM MULTA (ÚLTIMOS 5) ===' as verificacao;

SELECT 
    id,
    loan_id,
    amount,
    fine_amount,
    payment_date,
    payment_type,
    created_at
FROM payments 
WHERE fine_amount > 0 
ORDER BY created_at DESC 
LIMIT 5;

-- =====================================================
-- INSTRUÇÕES PARA APLICAR
-- =====================================================
/*
1. Execute este script no banco de dados via Supabase SQL Editor
2. Verifique se não há erros nas mensagens de retorno
3. Confirme que a coluna fine_amount existe consultando a tabela payments
4. Teste adicionar uma multa em um pagamento na interface
5. Verifique se a multa aparece no histórico de pagamentos
6. Verifique se a multa aparece na aba de relatórios

NOTAS IMPORTANTES:
- Este script é idempotente (pode ser executado múltiplas vezes sem problemas)
- Não afeta pagamentos existentes (mantém valores null como 0.00)
- Cria índice para melhorar performance em consultas de multas
*/
