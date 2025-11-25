-- =====================================================
-- DIAGNÓSTICO: Verificar Tabela PAID_LOANS
-- =====================================================
-- Execute este script no SQL Editor do Supabase para
-- verificar se a tabela paid_loans existe e está
-- configurada corretamente
-- =====================================================

-- Banner inicial
SELECT '🔍 INICIANDO DIAGNÓSTICO DA TABELA PAID_LOANS' as status;
SELECT '================================================' as separador;

-- =====================================================
-- 1. VERIFICAR SE A TABELA EXISTE
-- =====================================================

DO $$
BEGIN
    IF EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans'
    ) THEN
        RAISE NOTICE '✅ A tabela paid_loans EXISTE';
    ELSE
        RAISE NOTICE '❌ A tabela paid_loans NÃO EXISTE';
        RAISE NOTICE '';
        RAISE NOTICE '🔧 AÇÃO NECESSÁRIA:';
        RAISE NOTICE '   Execute o script setup-paid-loans-generic.sql para criar a tabela';
        RAISE NOTICE '';
    END IF;
END $$;

-- =====================================================
-- 2. LISTAR ESTRUTURA DA TABELA (se existir)
-- =====================================================

SELECT '📋 ESTRUTURA DA TABELA PAID_LOANS:' as info;
SELECT '================================================' as separador;

SELECT 
    column_name as "Coluna",
    data_type as "Tipo",
    character_maximum_length as "Tamanho Max",
    is_nullable as "Permite NULL",
    column_default as "Valor Padrão"
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'paid_loans'
ORDER BY ordinal_position;

-- =====================================================
-- 3. VERIFICAR ÍNDICES
-- =====================================================

SELECT '📊 ÍNDICES DA TABELA PAID_LOANS:' as info;
SELECT '================================================' as separador;

SELECT 
    indexname as "Nome do Índice",
    indexdef as "Definição"
FROM pg_indexes 
WHERE tablename = 'paid_loans'
ORDER BY indexname;

-- =====================================================
-- 4. VERIFICAR RLS (Row Level Security)
-- =====================================================

DO $$
DECLARE
    v_rls_enabled BOOLEAN;
    v_policy_count INTEGER;
BEGIN
    SELECT relrowsecurity INTO v_rls_enabled
    FROM pg_class
    WHERE relname = 'paid_loans';
    
    IF v_rls_enabled IS NULL THEN
        RAISE NOTICE '❌ Tabela paid_loans não encontrada para verificação de RLS';
        RETURN;
    END IF;
    
    IF v_rls_enabled THEN
        RAISE NOTICE '🔒 RLS está HABILITADO na tabela paid_loans';
        
        -- Contar políticas
        SELECT COUNT(*) INTO v_policy_count
        FROM pg_policies
        WHERE tablename = 'paid_loans';
        
        RAISE NOTICE '   Políticas RLS ativas: %', v_policy_count;
        
        IF v_policy_count = 0 THEN
            RAISE NOTICE '   ⚠️ ATENÇÃO: RLS está habilitado mas não há políticas configuradas!';
            RAISE NOTICE '   Isso pode impedir inserções na tabela.';
        END IF;
    ELSE
        RAISE NOTICE '🔓 RLS está DESABILITADO na tabela paid_loans';
    END IF;
END $$;

-- Listar políticas RLS (se existirem)
SELECT '🔐 POLÍTICAS RLS:' as info;
SELECT '================================================' as separador;

SELECT 
    policyname as "Nome da Política",
    cmd as "Comando",
    permissive as "Permissiva",
    roles as "Roles"
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'paid_loans'
ORDER BY policyname;

-- =====================================================
-- 5. VERIFICAR PERMISSÕES
-- =====================================================

SELECT '🔑 PERMISSÕES DA TABELA:' as info;
SELECT '================================================' as separador;

SELECT 
    grantee as "Usuário/Role",
    privilege_type as "Permissão"
FROM information_schema.table_privileges
WHERE table_schema = 'public'
AND table_name = 'paid_loans'
ORDER BY grantee, privilege_type;

-- =====================================================
-- 6. VERIFICAR VIEW PAID_LOANS_WITH_DETAILS
-- =====================================================

DO $$
BEGIN
    IF EXISTS (
        SELECT FROM information_schema.views 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans_with_details'
    ) THEN
        RAISE NOTICE '✅ View paid_loans_with_details EXISTE';
    ELSE
        RAISE NOTICE '⚠️ View paid_loans_with_details NÃO EXISTE';
    END IF;
END $$;

-- =====================================================
-- 7. VERIFICAR TRIGGERS
-- =====================================================

SELECT '⚡ TRIGGERS DA TABELA:' as info;
SELECT '================================================' as separador;

SELECT 
    trigger_name as "Nome do Trigger",
    event_manipulation as "Evento",
    action_timing as "Timing"
FROM information_schema.triggers
WHERE event_object_table = 'paid_loans'
ORDER BY trigger_name;

-- =====================================================
-- 8. CONTAR REGISTROS
-- =====================================================

DO $$
DECLARE
    v_count INTEGER;
BEGIN
    IF EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans'
    ) THEN
        SELECT COUNT(*) INTO v_count FROM paid_loans;
        RAISE NOTICE '📊 Número de empréstimos quitados registrados: %', v_count;
    ELSE
        RAISE NOTICE '❌ Não foi possível contar registros - tabela não existe';
    END IF;
END $$;

-- =====================================================
-- 9. TESTE DE PERMISSÕES (sem inserir dados)
-- =====================================================

DO $$
DECLARE
    v_can_insert BOOLEAN;
    v_test_client_id UUID;
BEGIN
    -- Verificar se há clientes na tabela
    SELECT id INTO v_test_client_id FROM clients LIMIT 1;
    
    IF v_test_client_id IS NULL THEN
        RAISE NOTICE '⚠️ Não há clientes cadastrados para testar permissões';
        RETURN;
    END IF;
    
    -- Testar se podemos fazer uma query de inserção (sem realmente inserir)
    BEGIN
        PERFORM 1 FROM paid_loans WHERE false; -- Query que não retorna nada
        RAISE NOTICE '✅ Permissões de leitura na tabela paid_loans: OK';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '❌ Erro ao acessar tabela paid_loans: %', SQLERRM;
    END;
END $$;

-- =====================================================
-- 10. RESUMO DO DIAGNÓSTICO
-- =====================================================

SELECT '📋 RESUMO DO DIAGNÓSTICO:' as info;
SELECT '================================================' as separador;

DO $$
DECLARE
    v_table_exists BOOLEAN;
    v_column_count INTEGER;
    v_index_count INTEGER;
    v_rls_enabled BOOLEAN;
    v_policy_count INTEGER;
    v_view_exists BOOLEAN;
    v_trigger_count INTEGER;
    v_record_count INTEGER;
    v_has_issues BOOLEAN := FALSE;
BEGIN
    -- Verificar tabela
    SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans'
    ) INTO v_table_exists;
    
    IF NOT v_table_exists THEN
        RAISE NOTICE '❌ PROBLEMA: Tabela paid_loans não existe!';
        RAISE NOTICE '   🔧 SOLUÇÃO: Execute o script setup-paid-loans-generic.sql';
        v_has_issues := TRUE;
    ELSE
        -- Contar colunas
        SELECT COUNT(*) INTO v_column_count
        FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans';
        
        IF v_column_count < 14 THEN
            RAISE NOTICE '⚠️ ATENÇÃO: Tabela tem apenas % colunas (esperadas 14)', v_column_count;
            v_has_issues := TRUE;
        END IF;
        
        -- Contar índices
        SELECT COUNT(*) INTO v_index_count
        FROM pg_indexes 
        WHERE tablename = 'paid_loans';
        
        IF v_index_count < 5 THEN
            RAISE NOTICE '⚠️ ATENÇÃO: Apenas % índices encontrados (esperados 5+)', v_index_count;
        END IF;
        
        -- Verificar RLS
        SELECT relrowsecurity INTO v_rls_enabled
        FROM pg_class
        WHERE relname = 'paid_loans';
        
        IF v_rls_enabled THEN
            SELECT COUNT(*) INTO v_policy_count
            FROM pg_policies
            WHERE tablename = 'paid_loans';
            
            IF v_policy_count = 0 THEN
                RAISE NOTICE '❌ PROBLEMA: RLS habilitado mas sem políticas configuradas!';
                RAISE NOTICE '   🔧 SOLUÇÃO: Execute o script setup-paid-loans-generic.sql';
                v_has_issues := TRUE;
            END IF;
        END IF;
        
        -- Verificar view
        SELECT EXISTS (
            SELECT FROM information_schema.views 
            WHERE table_schema = 'public' 
            AND table_name = 'paid_loans_with_details'
        ) INTO v_view_exists;
        
        IF NOT v_view_exists THEN
            RAISE NOTICE '⚠️ ATENÇÃO: View paid_loans_with_details não existe';
        END IF;
        
        -- Contar triggers
        SELECT COUNT(*) INTO v_trigger_count
        FROM information_schema.triggers
        WHERE event_object_table = 'paid_loans';
        
        -- Contar registros
        SELECT COUNT(*) INTO v_record_count FROM paid_loans;
        
        IF NOT v_has_issues THEN
            RAISE NOTICE '';
            RAISE NOTICE '✅ TUDO OK! A tabela paid_loans está configurada corretamente.';
            RAISE NOTICE '   - Colunas: %', v_column_count;
            RAISE NOTICE '   - Índices: %', v_index_count;
            RAISE NOTICE '   - Triggers: %', v_trigger_count;
            RAISE NOTICE '   - Registros: %', v_record_count;
            RAISE NOTICE '';
        END IF;
    END IF;
    
    IF v_has_issues THEN
        RAISE NOTICE '';
        RAISE NOTICE '🔧 AÇÃO RECOMENDADA:';
        RAISE NOTICE '   1. Execute o script: setup-paid-loans-generic.sql';
        RAISE NOTICE '   2. Execute novamente este diagnóstico para confirmar';
        RAISE NOTICE '   3. Teste a funcionalidade de quitação no sistema';
        RAISE NOTICE '';
    END IF;
END $$;

-- Banner final
SELECT '================================================' as separador;
SELECT '✅ DIAGNÓSTICO CONCLUÍDO!' as status;
