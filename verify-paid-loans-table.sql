-- =====================================================
-- SCRIPT DE VERIFICAÇÃO DA TABELA paid_loans
-- =====================================================
-- Execute este script no SQL Editor do Supabase
-- para verificar se a tabela paid_loans existe e está configurada corretamente
-- =====================================================

-- Verificar se a tabela existe
DO $$ 
DECLARE
    table_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT FROM pg_tables 
        WHERE schemaname = 'public' 
        AND tablename = 'paid_loans'
    ) INTO table_exists;
    
    IF table_exists THEN
        RAISE NOTICE '==============================================';
        RAISE NOTICE '✅ TABELA paid_loans EXISTE!';
        RAISE NOTICE '==============================================';
    ELSE
        RAISE NOTICE '==============================================';
        RAISE NOTICE '❌ TABELA paid_loans NÃO EXISTE!';
        RAISE NOTICE '==============================================';
        RAISE NOTICE 'Execute o script fix-litoral-paid-loans.sql para criar a tabela.';
        RAISE NOTICE '==============================================';
    END IF;
END $$;

-- =====================================================
-- INFORMAÇÕES DA TABELA
-- =====================================================

-- 1. Verificar colunas da tabela
SELECT 
    '📋 COLUNAS DA TABELA paid_loans:' as info,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'paid_loans'
ORDER BY ordinal_position;

-- 2. Verificar índices
SELECT 
    '🔍 ÍNDICES DA TABELA paid_loans:' as info,
    indexname,
    indexdef
FROM pg_indexes 
WHERE schemaname = 'public' 
AND tablename = 'paid_loans'
ORDER BY indexname;

-- 3. Verificar políticas RLS
SELECT 
    '🔒 POLÍTICAS RLS DA TABELA paid_loans:' as info,
    policyname,
    cmd as operacao,
    CASE 
        WHEN permissive = 'PERMISSIVE' THEN '✅ Permissivo'
        ELSE '⚠️ Restritivo'
    END as tipo
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'paid_loans'
ORDER BY policyname;

-- 4. Verificar se RLS está habilitado
SELECT 
    '🔐 STATUS DO RLS:' as info,
    tablename,
    CASE 
        WHEN rowsecurity THEN '✅ RLS Habilitado'
        ELSE '⚠️ RLS Desabilitado'
    END as status
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename = 'paid_loans';

-- 5. Verificar triggers
SELECT 
    '⚡ TRIGGERS DA TABELA paid_loans:' as info,
    trigger_name,
    event_manipulation as evento,
    action_timing as quando
FROM information_schema.triggers
WHERE event_object_schema = 'public' 
AND event_object_table = 'paid_loans'
ORDER BY trigger_name;

-- 6. Contar registros
SELECT 
    '📊 ESTATÍSTICAS:' as info,
    COUNT(*) as total_emprestimos_quitados,
    COUNT(DISTINCT client_id) as total_clientes_diferentes,
    SUM(original_amount) as soma_valores_originais,
    SUM(total_paid) as soma_valores_pagos,
    MIN(paid_date) as primeira_quitacao,
    MAX(paid_date) as ultima_quitacao
FROM paid_loans;

-- 7. Verificar últimos empréstimos quitados
SELECT 
    '📝 ÚLTIMOS 5 EMPRÉSTIMOS QUITADOS:' as info,
    pl.id,
    c.name as cliente,
    pl.original_amount as valor_original,
    pl.total_paid as valor_pago,
    pl.paid_date as data_quitacao,
    pl.notes as observacoes
FROM paid_loans pl
LEFT JOIN clients c ON pl.client_id = c.id
ORDER BY pl.paid_date DESC
LIMIT 5;

-- =====================================================
-- VERIFICAÇÃO DE INTEGRIDADE
-- =====================================================

-- Verificar se há registros órfãos (sem cliente)
SELECT 
    '⚠️ VERIFICAÇÃO DE INTEGRIDADE - Registros sem Cliente:' as info,
    COUNT(*) as total_registros_orfaos
FROM paid_loans pl
LEFT JOIN clients c ON pl.client_id = c.id
WHERE c.id IS NULL;

-- Verificar se há valores negativos ou zerados
SELECT 
    '⚠️ VERIFICAÇÃO DE INTEGRIDADE - Valores Inválidos:' as info,
    COUNT(*) as total_valores_invalidos
FROM paid_loans
WHERE original_amount <= 0 
OR total_with_interest <= 0 
OR total_paid < 0;

-- =====================================================
-- MENSAGEM FINAL
-- =====================================================

DO $$ 
DECLARE
    table_exists BOOLEAN;
    record_count INTEGER;
BEGIN
    -- Verificar se tabela existe
    SELECT EXISTS (
        SELECT FROM pg_tables 
        WHERE schemaname = 'public' 
        AND tablename = 'paid_loans'
    ) INTO table_exists;
    
    IF table_exists THEN
        -- Contar registros
        SELECT COUNT(*) INTO record_count FROM paid_loans;
        
        RAISE NOTICE '==============================================';
        RAISE NOTICE '✅ VERIFICAÇÃO CONCLUÍDA COM SUCESSO!';
        RAISE NOTICE '==============================================';
        RAISE NOTICE 'A tabela paid_loans existe e está configurada.';
        RAISE NOTICE 'Total de registros: %', record_count;
        RAISE NOTICE '==============================================';
    ELSE
        RAISE NOTICE '==============================================';
        RAISE NOTICE '❌ AÇÃO NECESSÁRIA!';
        RAISE NOTICE '==============================================';
        RAISE NOTICE 'A tabela paid_loans NÃO existe neste banco.';
        RAISE NOTICE 'Execute o script: fix-litoral-paid-loans.sql';
        RAISE NOTICE '==============================================';
    END IF;
END $$;
