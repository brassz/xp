-- =====================================================
-- ATUALIZAÇÃO DA TABELA DE PARCELAMENTOS
-- Para usar apenas clientes ao invés de empréstimos
-- =====================================================
-- Execute estes comandos no SQL Editor do Supabase
-- =====================================================

-- Remover a obrigatoriedade do campo loan_id
ALTER TABLE installments 
ALTER COLUMN loan_id DROP NOT NULL;

-- Atualizar comentário da coluna loan_id
COMMENT ON COLUMN installments.loan_id IS 'Referência ao empréstimo original (opcional - pode ser NULL para parcelamentos diretos)';

-- Atualizar comentário da tabela
COMMENT ON TABLE installments IS 'Tabela para armazenar planos de parcelamento - pode ser vinculado a empréstimos ou criado diretamente para clientes';

-- =====================================================
-- VERIFICAÇÃO DOS DADOS EXISTENTES
-- =====================================================
-- Para verificar se há parcelamentos existentes que dependem de empréstimos:
-- SELECT COUNT(*) FROM installments WHERE loan_id IS NOT NULL;

-- =====================================================
-- NOTA IMPORTANTE
-- =====================================================
-- Esta alteração torna o campo loan_id opcional, permitindo:
-- 1. Parcelamentos criados a partir de empréstimos existentes (loan_id preenchido)
-- 2. Parcelamentos criados diretamente para clientes (loan_id NULL)
-- 
-- Isso mantém a compatibilidade com dados existentes enquanto
-- permite a nova funcionalidade de criar parcelamentos apenas com clientes.