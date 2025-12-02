-- =====================================================
-- ADICIONAR CAMPO PARA RASTREAR ALTERAÇÃO MANUAL DE DATA DE VENCIMENTO
-- =====================================================
-- Este script adiciona um campo booleano na tabela loans para rastrear
-- quando a data de vencimento foi alterada manualmente

-- Adicionar o campo due_date_manually_changed
ALTER TABLE loans 
ADD COLUMN IF NOT EXISTS due_date_manually_changed BOOLEAN DEFAULT FALSE;

-- Adicionar comentário explicando o campo
COMMENT ON COLUMN loans.due_date_manually_changed IS 'Indica se a data de vencimento foi alterada manualmente (exibida em amarelo na interface)';

-- Criar índice para melhorar consultas que filtram por este campo
CREATE INDEX IF NOT EXISTS idx_loans_due_date_manually_changed 
ON loans(due_date_manually_changed);

-- Mensagem de sucesso
DO $$
BEGIN
    RAISE NOTICE 'Campo due_date_manually_changed adicionado com sucesso à tabela loans!';
    RAISE NOTICE 'Todas as datas de vencimento alteradas manualmente serão destacadas em amarelo.';
END $$;
