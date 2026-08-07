-- =====================================================
-- ROLLBACK - REMOVER SISTEMA DE MULTAS
-- =====================================================
-- Execute este script no SQL Editor do Supabase
-- para reverter todas as mudanças do sistema de multas
-- =====================================================

-- =====================================================
-- REMOVER VIEWS
-- =====================================================
DROP VIEW IF EXISTS client_payment_history CASCADE;
DROP VIEW IF EXISTS pending_fines CASCADE;
DROP VIEW IF EXISTS client_fines_summary CASCADE;

-- =====================================================
-- REMOVER FUNÇÕES
-- =====================================================
DROP FUNCTION IF EXISTS update_fine_status() CASCADE;
DROP FUNCTION IF EXISTS calculate_late_fine(UUID, INTEGER, DECIMAL) CASCADE;

-- =====================================================
-- REMOVER TABELA DE MULTAS
-- =====================================================
-- Isso removerá automaticamente:
-- - Todos os triggers associados
-- - Todos os índices
-- - Todas as policies RLS
DROP TABLE IF EXISTS fines CASCADE;

-- =====================================================
-- VERIFICAÇÃO
-- =====================================================

-- Verificar se a tabela foi removida
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'fines';

-- Verificar se as views foram removidas
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('client_payment_history', 'pending_fines', 'client_fines_summary');

-- Verificar se as funções foram removidas
SELECT 
    routine_name,
    routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name IN ('update_fine_status', 'calculate_late_fine');

-- =====================================================
-- MENSAGEM DE SUCESSO
-- =====================================================
DO $$
BEGIN
    RAISE NOTICE '✓ Sistema de multas removido com sucesso!';
    RAISE NOTICE '✓ Tabela fines deletada';
    RAISE NOTICE '✓ Views removidas';
    RAISE NOTICE '✓ Funções removidas';
    RAISE NOTICE '✓ Triggers e índices removidos automaticamente';
END $$;

-- =====================================================
-- FIM DO ROLLBACK
-- =====================================================
