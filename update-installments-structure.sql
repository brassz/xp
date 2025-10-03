-- =====================================================
-- ATUALIZAÇÃO DA ESTRUTURA DE PARCELAMENTOS
-- =====================================================
-- Execute este script no SQL Editor do Supabase para
-- permitir parcelamentos independentes (sem empréstimo vinculado)
-- =====================================================

-- Remover a constraint NOT NULL do campo loan_id para permitir parcelamentos independentes
ALTER TABLE installments 
ALTER COLUMN loan_id DROP NOT NULL;

-- Atualizar comentário da coluna
COMMENT ON COLUMN installments.loan_id IS 'Referência ao empréstimo original (opcional - pode ser NULL para parcelamentos independentes)';

-- Atualizar comentário da tabela
COMMENT ON TABLE installments IS 'Tabela para armazenar planos de parcelamento - pode ser vinculado a empréstimos ou independente';

-- Criar índice para consultas por cliente (se não existir)
CREATE INDEX IF NOT EXISTS idx_installments_client_only ON installments(client_id) WHERE loan_id IS NULL;

-- Verificar se há parcelamentos com loan_id NULL (para teste)
-- SELECT COUNT(*) as parcelamentos_independentes FROM installments WHERE loan_id IS NULL;

-- =====================================================
-- ATUALIZAÇÃO CONCLUÍDA
-- =====================================================
-- Agora é possível criar parcelamentos para qualquer cliente
-- sem necessidade de empréstimo vinculado
-- =====================================================