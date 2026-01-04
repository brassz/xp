-- =====================================================
-- FIX: ADICIONAR COLUNA due_date_manually_changed
-- =====================================================
-- Este script corrige o erro: "Could not find the 'due_date_manually_changed' column"
-- Adiciona a coluna necessária para rastrear alterações manuais de data de vencimento

-- 1. Adicionar a coluna due_date_manually_changed se não existir
DO $$
BEGIN
    -- Verificar se a coluna já existe
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'loans' 
        AND column_name = 'due_date_manually_changed'
    ) THEN
        -- Adicionar a coluna
        ALTER TABLE loans 
        ADD COLUMN due_date_manually_changed BOOLEAN DEFAULT FALSE;
        
        RAISE NOTICE 'Coluna due_date_manually_changed adicionada com sucesso!';
    ELSE
        RAISE NOTICE 'Coluna due_date_manually_changed já existe.';
    END IF;
END $$;

-- 2. Adicionar comentário explicando o campo
COMMENT ON COLUMN loans.due_date_manually_changed IS 'Indica se a data de vencimento foi alterada manualmente (exibida em amarelo na interface)';

-- 3. Criar índice para melhorar performance nas consultas
CREATE INDEX IF NOT EXISTS idx_loans_due_date_manually_changed 
ON loans(due_date_manually_changed)
WHERE due_date_manually_changed = true;

-- 4. Garantir que todos os registros existentes tenham um valor (false por padrão)
UPDATE loans 
SET due_date_manually_changed = false 
WHERE due_date_manually_changed IS NULL;

-- 5. Verificação final
DO $$
DECLARE
    column_exists BOOLEAN;
    total_loans INTEGER;
    loans_with_flag INTEGER;
BEGIN
    -- Verificar se a coluna existe
    SELECT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'loans' 
        AND column_name = 'due_date_manually_changed'
    ) INTO column_exists;
    
    IF column_exists THEN
        -- Contar empréstimos
        SELECT COUNT(*) INTO total_loans FROM loans;
        SELECT COUNT(*) INTO loans_with_flag FROM loans WHERE due_date_manually_changed = true;
        
        RAISE NOTICE '✓ Coluna criada com sucesso!';
        RAISE NOTICE '✓ Total de empréstimos: %', total_loans;
        RAISE NOTICE '✓ Empréstimos com data alterada manualmente: %', loans_with_flag;
        RAISE NOTICE '✓ Índice criado para otimização de consultas';
        RAISE NOTICE '';
        RAISE NOTICE 'O erro "Could not find the due_date_manually_changed column" foi corrigido!';
    ELSE
        RAISE EXCEPTION 'Erro: A coluna não foi criada corretamente.';
    END IF;
END $$;
