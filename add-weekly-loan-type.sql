-- Script para adicionar campo de tipo de empréstimo (semanal/mensal)
-- Executar este script para suportar empréstimos semanais

-- Adicionar coluna para identificar o tipo de empréstimo
ALTER TABLE loans 
ADD COLUMN IF NOT EXISTS loan_type TEXT DEFAULT 'monthly' CHECK (loan_type IN ('weekly', 'monthly'));

-- Comentário da nova coluna
COMMENT ON COLUMN loans.loan_type IS 'Tipo do empréstimo: weekly (semanal) ou monthly (mensal)';

-- Atualizar empréstimos existentes para mensal por padrão
UPDATE loans 
SET loan_type = 'monthly' 
WHERE loan_type IS NULL;