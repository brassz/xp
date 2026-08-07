-- =====================================================
-- ROLLBACK PARCIAL - LITORAL CRED
-- =====================================================
-- Remove APENAS tabelas auxiliares e de backup
-- PRESERVA a tabela paid_loans com todos os dados
-- =====================================================

-- 1. REMOVER TABELAS DE BACKUP (criadas pelo script de backup)
DROP TABLE IF EXISTS loans_backup_20241125 CASCADE;
DROP TABLE IF EXISTS payments_backup_20241125 CASCADE;
DROP TABLE IF EXISTS clients_backup_20241125 CASCADE;
DROP TABLE IF EXISTS paid_loans_backup_20241125 CASCADE;

-- 2. REMOVER TABELA DE AUDITORIA DE BACKUP
DROP TABLE IF EXISTS backup_audit_litoral_cred CASCADE;

-- 3. REMOVER TABELA DE AUDITORIA DE PAID_LOANS (se foi criada)
DROP TABLE IF EXISTS paid_loans_audit CASCADE;

-- 4. REMOVER VIEWS AUXILIARES
DROP VIEW IF EXISTS paid_loans_with_details CASCADE;
DROP VIEW IF EXISTS restore_commands CASCADE;

-- 5. REMOVER FUNÇÕES AUXILIARES
DROP FUNCTION IF EXISTS update_paid_loans_updated_at() CASCADE;
DROP FUNCTION IF EXISTS auto_move_paid_loan() CASCADE;
DROP FUNCTION IF EXISTS audit_paid_loans() CASCADE;
DROP FUNCTION IF EXISTS generate_restore_script() CASCADE;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar se paid_loans AINDA EXISTE (deve existir!)
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name = 'paid_loans'
        ) THEN '✅ paid_loans PRESERVADA (está segura!)'
        ELSE '❌ ERRO: paid_loans foi removida (não deveria)'
    END as status_paid_loans;

-- Contar registros em paid_loans
SELECT 
    'Registros em paid_loans:' as info,
    COUNT(*) as quantidade
FROM paid_loans;

-- Verificar se backups foram removidos
SELECT 
    CASE 
        WHEN NOT EXISTS (
            SELECT FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name LIKE '%_backup_20241125'
        ) THEN '✅ Tabelas de backup REMOVIDAS'
        ELSE '⚠️ Ainda há tabelas de backup'
    END as status_backups;

-- Listar tabelas principais restantes
SELECT 
    'Tabelas principais:' as categoria,
    table_name
FROM information_schema.tables 
WHERE table_schema = 'public'
AND table_type = 'BASE TABLE'
AND table_name IN ('loans', 'payments', 'clients', 'users', 'paid_loans')
ORDER BY table_name;

-- =====================================================
-- MENSAGEM FINAL
-- =====================================================

DO $$
DECLARE
    v_paid_loans_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_paid_loans_count FROM paid_loans;
    
    RAISE NOTICE '';
    RAISE NOTICE '=========================================';
    RAISE NOTICE 'ROLLBACK PARCIAL CONCLUÍDO';
    RAISE NOTICE '=========================================';
    RAISE NOTICE '';
    RAISE NOTICE '✅ PRESERVADO:';
    RAISE NOTICE '   - Tabela paid_loans: % registros', v_paid_loans_count;
    RAISE NOTICE '   - Todos os dados de paid_loans: INTACTOS';
    RAISE NOTICE '';
    RAISE NOTICE '✅ REMOVIDO:';
    RAISE NOTICE '   - Tabelas de backup (*_backup_20241125)';
    RAISE NOTICE '   - Tabela de auditoria (paid_loans_audit)';
    RAISE NOTICE '   - Views auxiliares';
    RAISE NOTICE '   - Funções auxiliares';
    RAISE NOTICE '';
    RAISE NOTICE '📊 TABELAS PRINCIPAIS (todas preservadas):';
    RAISE NOTICE '   - loans: Intacta';
    RAISE NOTICE '   - payments: Intacta';
    RAISE NOTICE '   - clients: Intacta';
    RAISE NOTICE '   - paid_loans: Intacta com % registros', v_paid_loans_count;
    RAISE NOTICE '';
    RAISE NOTICE '=========================================';
END $$;
