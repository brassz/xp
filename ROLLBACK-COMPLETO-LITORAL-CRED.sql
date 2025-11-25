-- =====================================================
-- ROLLBACK COMPLETO - LITORAL CRED
-- =====================================================
-- Este script REMOVE tudo que foi criado pelos scripts de recuperação
-- Copie e cole TODO este arquivo no SQL Editor
-- =====================================================

-- 1. REMOVER TABELA PAID_LOANS
DROP TABLE IF EXISTS paid_loans CASCADE;

-- 2. REMOVER TABELA DE AUDITORIA (se foi criada)
DROP TABLE IF EXISTS paid_loans_audit CASCADE;

-- 3. REMOVER TABELAS DE BACKUP (se foram criadas)
DROP TABLE IF EXISTS loans_backup_20241125 CASCADE;
DROP TABLE IF EXISTS payments_backup_20241125 CASCADE;
DROP TABLE IF EXISTS clients_backup_20241125 CASCADE;
DROP TABLE IF EXISTS paid_loans_backup_20241125 CASCADE;

-- 4. REMOVER TABELA DE AUDITORIA DE BACKUP (se foi criada)
DROP TABLE IF EXISTS backup_audit_litoral_cred CASCADE;

-- 5. REMOVER VIEWS (se foram criadas)
DROP VIEW IF EXISTS paid_loans_with_details CASCADE;
DROP VIEW IF EXISTS restore_commands CASCADE;

-- 6. REMOVER FUNÇÕES (se foram criadas)
DROP FUNCTION IF EXISTS update_paid_loans_updated_at() CASCADE;
DROP FUNCTION IF EXISTS auto_move_paid_loan() CASCADE;
DROP FUNCTION IF EXISTS audit_paid_loans() CASCADE;
DROP FUNCTION IF EXISTS generate_restore_script() CASCADE;

-- 7. LIMPAR POLÍTICAS RLS (se foram criadas)
-- Não gera erro se não existir

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar se paid_loans foi removida
SELECT 
    CASE 
        WHEN NOT EXISTS (
            SELECT FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name = 'paid_loans'
        ) THEN '✅ paid_loans REMOVIDA com sucesso'
        ELSE '❌ paid_loans ainda existe'
    END as resultado;

-- Listar tabelas restantes
SELECT 
    'Tabelas restantes:' as info,
    table_name
FROM information_schema.tables 
WHERE table_schema = 'public'
AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- =====================================================
-- MENSAGEM FINAL
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '=========================================';
    RAISE NOTICE 'ROLLBACK COMPLETO EXECUTADO';
    RAISE NOTICE '=========================================';
    RAISE NOTICE '';
    RAISE NOTICE '✅ Tabela paid_loans: REMOVIDA';
    RAISE NOTICE '✅ Tabelas de backup: REMOVIDAS';
    RAISE NOTICE '✅ Funções e triggers: REMOVIDOS';
    RAISE NOTICE '✅ Views: REMOVIDAS';
    RAISE NOTICE '';
    RAISE NOTICE 'O banco de dados voltou ao estado anterior.';
    RAISE NOTICE 'NENHUM dado das tabelas originais foi alterado.';
    RAISE NOTICE '';
    RAISE NOTICE '=========================================';
END $$;
