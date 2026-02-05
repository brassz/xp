-- Adicionar campo term_days na tabela loans para armazenar o período de vencimento (20 ou 30 dias)
-- =====================================================

-- Adicionar coluna term_days se não existir
ALTER TABLE loans 
ADD COLUMN IF NOT EXISTS term_days INTEGER DEFAULT 30 CHECK (term_days IN (20, 30));

-- Comentário na coluna
COMMENT ON COLUMN loans.term_days IS 'Período de vencimento do empréstimo em dias (20 ou 30)';

-- Atualizar empréstimos existentes para 30 dias (padrão)
UPDATE loans 
SET term_days = 30 
WHERE term_days IS NULL;

