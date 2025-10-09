-- =====================================================
-- FIX PARA CONSTRAINT NOT NULL DO CAMPO loan_id
-- =====================================================
-- Este script remove a constraint NOT NULL do campo loan_id
-- na tabela installments para permitir parcelamentos independentes
-- =====================================================

-- Verificar se a constraint NOT NULL existe e removê-la
DO $$
BEGIN
    -- Tentar remover a constraint NOT NULL do campo loan_id
    BEGIN
        ALTER TABLE installments ALTER COLUMN loan_id DROP NOT NULL;
        RAISE NOTICE 'Constraint NOT NULL removida do campo loan_id com sucesso';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Campo loan_id já permite valores NULL ou erro: %', SQLERRM;
    END;
END $$;

-- Atualizar comentário da coluna para refletir a mudança
COMMENT ON COLUMN installments.loan_id IS 'Referência ao empréstimo original (opcional - pode ser NULL para parcelamentos independentes)';

-- Atualizar comentário da tabela
COMMENT ON TABLE installments IS 'Tabela para armazenar planos de parcelamento - pode ser vinculado a empréstimos ou independente';

-- Verificar a estrutura atual da tabela
\d installments;

-- Mostrar alguns exemplos de parcelamentos para verificar
SELECT 
    id,
    loan_id,
    client_id,
    total_amount,
    status,
    created_at
FROM installments 
ORDER BY created_at DESC 
LIMIT 5;

-- =====================================================
-- SCRIPT CONCLUÍDO
-- =====================================================
-- Execute este script no SQL Editor do Supabase
-- para garantir que parcelamentos independentes funcionem
-- =====================================================