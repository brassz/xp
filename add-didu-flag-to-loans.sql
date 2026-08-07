-- =====================================================
-- ADICIONAR CAMPO DIDU PARA EMPRÉSTIMOS (MOGIANA)
-- =====================================================
-- Este script adiciona um campo booleano na tabela loans para marcar
-- empréstimos criados com a opção DIDU.

-- Adicionar o campo is_didu
ALTER TABLE loans
ADD COLUMN IF NOT EXISTS is_didu BOOLEAN DEFAULT FALSE;

-- Garantir valor padrão nos registros existentes
UPDATE loans
SET is_didu = FALSE
WHERE is_didu IS NULL;

-- Adicionar comentário explicando o campo
COMMENT ON COLUMN loans.is_didu IS 'Indica se o empréstimo foi marcado como DIDU na criação (nome do cliente em verde)';

-- Criar índice para consultas por empréstimos DIDU
CREATE INDEX IF NOT EXISTS idx_loans_is_didu
ON loans(is_didu);

-- Mensagem de sucesso
DO $$
BEGIN
    RAISE NOTICE 'Campo is_didu adicionado com sucesso à tabela loans!';
    RAISE NOTICE 'Empréstimos marcados como DIDU serão exibidos com nome do cliente em verde.';
END $$;
