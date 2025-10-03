-- =====================================================
-- REVERTER ALTERAÇÕES NA TABELA DE PARCELAMENTOS
-- Para tornar loan_id obrigatório novamente
-- =====================================================
-- Execute estes comandos no SQL Editor do Supabase
-- =====================================================

-- Tornar o campo loan_id obrigatório novamente
ALTER TABLE installments 
ALTER COLUMN loan_id SET NOT NULL;

-- Reverter comentário da coluna loan_id
COMMENT ON COLUMN installments.loan_id IS 'Referência ao empréstimo original que está sendo parcelado';

-- Reverter comentário da tabela
COMMENT ON TABLE installments IS 'Tabela para armazenar planos de parcelamento de empréstimos vencidos';

-- =====================================================
-- VERIFICAÇÃO DOS DADOS EXISTENTES
-- =====================================================
-- ATENÇÃO: Antes de executar, verifique se há parcelamentos com loan_id NULL:
-- SELECT COUNT(*) FROM installments WHERE loan_id IS NULL;
-- 
-- Se houver registros com loan_id NULL, você precisará:
-- 1. Ou excluí-los: DELETE FROM installments WHERE loan_id IS NULL;
-- 2. Ou atribuir um loan_id válido a eles antes de executar o ALTER COLUMN

-- =====================================================
-- NOTA IMPORTANTE
-- =====================================================
-- Esta reversão tornará o campo loan_id obrigatório novamente.
-- Certifique-se de que todos os parcelamentos existentes tenham um loan_id válido
-- antes de executar este script, caso contrário o comando falhará.