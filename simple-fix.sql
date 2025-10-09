-- =====================================================
-- CORREÇÃO SIMPLES: PARCELAMENTOS INDEPENDENTES
-- =====================================================

-- Remover constraint NOT NULL do campo loan_id
ALTER TABLE installments ALTER COLUMN loan_id DROP NOT NULL;

-- Atualizar comentários
COMMENT ON TABLE installments IS 'Tabela para armazenar planos de parcelamento - pode ser vinculado a empréstimos ou independente';
COMMENT ON COLUMN installments.loan_id IS 'Referência ao empréstimo original (opcional - pode ser NULL para parcelamentos independentes)';

-- Criar índice para parcelamentos independentes
CREATE INDEX IF NOT EXISTS idx_installments_client_independent 
ON installments(client_id) WHERE loan_id IS NULL;

-- Verificar se funcionou
SELECT 
    table_name,
    column_name,
    is_nullable,
    CASE 
        WHEN is_nullable = 'YES' THEN 'SUCESSO: loan_id aceita NULL'
        ELSE 'ERRO: loan_id ainda NOT NULL'
    END as status
FROM information_schema.columns 
WHERE table_name = 'installments' 
AND column_name = 'loan_id';