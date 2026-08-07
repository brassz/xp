-- =====================================================
-- VERIFICAÇÃO: Coluna due_date_manually_changed
-- =====================================================
-- Este script verifica se a coluna due_date_manually_changed existe
-- e mostra informações sobre seu estado

DO $$
DECLARE
    column_exists BOOLEAN;
    index_exists BOOLEAN;
    total_loans INTEGER;
    loans_with_manual_change INTEGER;
    percentage NUMERIC;
BEGIN
    RAISE NOTICE '================================================';
    RAISE NOTICE 'VERIFICAÇÃO DA COLUNA due_date_manually_changed';
    RAISE NOTICE '================================================';
    RAISE NOTICE '';
    
    -- 1. Verificar se a coluna existe
    SELECT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'public'
        AND table_name = 'loans' 
        AND column_name = 'due_date_manually_changed'
    ) INTO column_exists;
    
    IF column_exists THEN
        RAISE NOTICE '✓ A coluna due_date_manually_changed EXISTE na tabela loans';
        
        -- 2. Verificar tipo de dados
        RAISE NOTICE '  Tipo: %', (
            SELECT data_type 
            FROM information_schema.columns 
            WHERE table_name = 'loans' 
            AND column_name = 'due_date_manually_changed'
        );
        
        -- 3. Verificar valor padrão
        RAISE NOTICE '  Default: %', (
            SELECT column_default 
            FROM information_schema.columns 
            WHERE table_name = 'loans' 
            AND column_name = 'due_date_manually_changed'
        );
        
        -- 4. Verificar se aceita NULL
        RAISE NOTICE '  Nullable: %', (
            SELECT is_nullable 
            FROM information_schema.columns 
            WHERE table_name = 'loans' 
            AND column_name = 'due_date_manually_changed'
        );
        
        RAISE NOTICE '';
        
        -- 5. Verificar índice
        SELECT EXISTS (
            SELECT 1 
            FROM pg_indexes 
            WHERE tablename = 'loans' 
            AND indexname = 'idx_loans_due_date_manually_changed'
        ) INTO index_exists;
        
        IF index_exists THEN
            RAISE NOTICE '✓ O índice idx_loans_due_date_manually_changed EXISTE';
        ELSE
            RAISE NOTICE '✗ O índice idx_loans_due_date_manually_changed NÃO existe';
            RAISE NOTICE '  Recomendação: Criar o índice para melhor performance';
        END IF;
        
        RAISE NOTICE '';
        
        -- 6. Estatísticas
        SELECT COUNT(*) INTO total_loans FROM loans;
        SELECT COUNT(*) INTO loans_with_manual_change 
        FROM loans 
        WHERE due_date_manually_changed = true;
        
        IF total_loans > 0 THEN
            percentage := (loans_with_manual_change::NUMERIC / total_loans::NUMERIC) * 100;
        ELSE
            percentage := 0;
        END IF;
        
        RAISE NOTICE 'ESTATÍSTICAS:';
        RAISE NOTICE '  Total de empréstimos: %', total_loans;
        RAISE NOTICE '  Com data alterada manualmente: % (%.2f%%)', loans_with_manual_change, percentage;
        RAISE NOTICE '  Com data calculada automaticamente: %', (total_loans - loans_with_manual_change);
        
        RAISE NOTICE '';
        RAISE NOTICE '================================================';
        RAISE NOTICE 'STATUS: OK - Coluna configurada corretamente';
        RAISE NOTICE '================================================';
        
    ELSE
        RAISE NOTICE '✗ A coluna due_date_manually_changed NÃO EXISTE na tabela loans';
        RAISE NOTICE '';
        RAISE NOTICE 'PROBLEMA IDENTIFICADO:';
        RAISE NOTICE '  O código da aplicação está tentando usar esta coluna,';
        RAISE NOTICE '  mas ela não existe no banco de dados.';
        RAISE NOTICE '';
        RAISE NOTICE 'SOLUÇÃO:';
        RAISE NOTICE '  Execute o script: fix-due-date-manually-changed-column.sql';
        RAISE NOTICE '';
        RAISE NOTICE '================================================';
        RAISE NOTICE 'STATUS: ERRO - Coluna não encontrada';
        RAISE NOTICE '================================================';
    END IF;
END $$;

-- Consulta adicional: Listar empréstimos com data alterada manualmente
-- (só funciona se a coluna existir)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'loans' 
        AND column_name = 'due_date_manually_changed'
    ) THEN
        RAISE NOTICE '';
        RAISE NOTICE 'EMPRÉSTIMOS COM DATA ALTERADA MANUALMENTE:';
        RAISE NOTICE '(Execute a consulta SELECT abaixo para ver detalhes)';
    END IF;
END $$;

-- Descomente as linhas abaixo para ver detalhes dos empréstimos com data alterada
/*
SELECT 
    id,
    amount,
    due_date,
    status,
    due_date_manually_changed,
    created_at,
    updated_at
FROM loans
WHERE due_date_manually_changed = true
ORDER BY updated_at DESC
LIMIT 10;
*/
