-- =====================================================
-- BACKUP PREVENTIVO - LITORAL CRED
-- =====================================================
-- Execute este script ANTES de qualquer operação de recuperação
-- URL: https://dtifsfzmnjnllzzlndxv.supabase.co
-- =====================================================

-- ⚠️ IMPORTANTE: Este script cria cópias de segurança das tabelas principais
-- para permitir rollback em caso de problemas

\echo '========================================='
\echo 'BACKUP PREVENTIVO - LITORAL CRED'
\echo '========================================='
\echo ''

-- =====================================================
-- CRIAR TABELAS DE BACKUP
-- =====================================================

-- Backup da tabela loans
\echo '📦 Criando backup da tabela loans...'
DROP TABLE IF EXISTS loans_backup_20241125 CASCADE;
CREATE TABLE loans_backup_20241125 AS 
SELECT * FROM loans;

SELECT COUNT(*) as registros_backup_loans 
FROM loans_backup_20241125;

-- Backup da tabela payments
\echo '📦 Criando backup da tabela payments...'
DROP TABLE IF EXISTS payments_backup_20241125 CASCADE;
CREATE TABLE payments_backup_20241125 AS 
SELECT * FROM payments;

SELECT COUNT(*) as registros_backup_payments 
FROM payments_backup_20241125;

-- Backup da tabela clients
\echo '📦 Criando backup da tabela clients...'
DROP TABLE IF EXISTS clients_backup_20241125 CASCADE;
CREATE TABLE clients_backup_20241125 AS 
SELECT * FROM clients;

SELECT COUNT(*) as registros_backup_clients 
FROM clients_backup_20241125;

-- Backup da tabela paid_loans (se existir)
\echo '📦 Verificando e criando backup da tabela paid_loans (se existir)...'
DO $$
BEGIN
    IF EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans'
    ) THEN
        DROP TABLE IF EXISTS paid_loans_backup_20241125 CASCADE;
        EXECUTE 'CREATE TABLE paid_loans_backup_20241125 AS SELECT * FROM paid_loans';
        RAISE NOTICE '✅ Backup de paid_loans criado';
    ELSE
        RAISE NOTICE '⚠️  Tabela paid_loans não existe - backup não necessário';
    END IF;
END $$;

\echo ''

-- =====================================================
-- CRIAR TABELA DE AUDITORIA DO BACKUP
-- =====================================================

\echo '📋 Criando registro de auditoria do backup...'

DROP TABLE IF EXISTS backup_audit_litoral_cred CASCADE;
CREATE TABLE backup_audit_litoral_cred (
    id SERIAL PRIMARY KEY,
    backup_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    table_name VARCHAR(100),
    records_count INTEGER,
    backup_table_name VARCHAR(100),
    notes TEXT
);

-- Registrar backups criados
INSERT INTO backup_audit_litoral_cred (table_name, records_count, backup_table_name, notes)
SELECT 'loans', COUNT(*), 'loans_backup_20241125', 'Backup preventivo antes da recuperação de empréstimos quitados'
FROM loans_backup_20241125;

INSERT INTO backup_audit_litoral_cred (table_name, records_count, backup_table_name, notes)
SELECT 'payments', COUNT(*), 'payments_backup_20241125', 'Backup preventivo antes da recuperação de empréstimos quitados'
FROM payments_backup_20241125;

INSERT INTO backup_audit_litoral_cred (table_name, records_count, backup_table_name, notes)
SELECT 'clients', COUNT(*), 'clients_backup_20241125', 'Backup preventivo antes da recuperação de empréstimos quitados'
FROM clients_backup_20241125;

-- Verificar se paid_loans existe e adicionar ao audit
DO $$
DECLARE
    v_count INTEGER;
BEGIN
    IF EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans_backup_20241125'
    ) THEN
        EXECUTE 'SELECT COUNT(*) FROM paid_loans_backup_20241125' INTO v_count;
        INSERT INTO backup_audit_litoral_cred (table_name, records_count, backup_table_name, notes)
        VALUES ('paid_loans', v_count, 'paid_loans_backup_20241125', 'Backup preventivo antes da recuperação de empréstimos quitados');
    END IF;
END $$;

\echo ''

-- =====================================================
-- EXPORTAR DADOS CRÍTICOS (FORMATO SQL)
-- =====================================================

\echo '💾 Criando scripts de restauração...'

-- Criar função para gerar script de restauração
CREATE OR REPLACE FUNCTION generate_restore_script()
RETURNS TABLE(script_line TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT '-- =================================================' as script_line
    UNION ALL
    SELECT '-- SCRIPT DE RESTAURAÇÃO - LITORAL CRED'
    UNION ALL
    SELECT '-- Data do Backup: ' || NOW()::TEXT
    UNION ALL
    SELECT '-- ================================================='
    UNION ALL
    SELECT ''
    UNION ALL
    SELECT '-- Para restaurar, execute:'
    UNION ALL
    SELECT '-- DROP TABLE IF EXISTS loans CASCADE;'
    UNION ALL
    SELECT '-- CREATE TABLE loans AS SELECT * FROM loans_backup_20241125;'
    UNION ALL
    SELECT ''
    UNION ALL
    SELECT '-- DROP TABLE IF EXISTS payments CASCADE;'
    UNION ALL
    SELECT '-- CREATE TABLE payments AS SELECT * FROM payments_backup_20241125;'
    UNION ALL
    SELECT ''
    UNION ALL
    SELECT '-- DROP TABLE IF EXISTS clients CASCADE;'
    UNION ALL
    SELECT '-- CREATE TABLE clients AS SELECT * FROM clients_backup_20241125;';
END;
$$ LANGUAGE plpgsql;

\echo ''

-- =====================================================
-- RELATÓRIO DE BACKUP
-- =====================================================

\echo '========================================='
\echo 'RELATÓRIO DE BACKUP'
\echo '========================================='

SELECT 
    table_name as tabela,
    records_count as registros,
    backup_table_name as tabela_backup,
    TO_CHAR(backup_date, 'DD/MM/YYYY HH24:MI:SS') as data_backup
FROM backup_audit_litoral_cred
ORDER BY backup_date DESC;

\echo ''
\echo '========================================='
\echo 'ESTATÍSTICAS DO BACKUP'
\echo '========================================='

DO $$
DECLARE
    v_loans_count INTEGER;
    v_payments_count INTEGER;
    v_clients_count INTEGER;
    v_paid_loans_count INTEGER := 0;
    v_total_size TEXT;
BEGIN
    -- Contar registros
    SELECT COUNT(*) INTO v_loans_count FROM loans_backup_20241125;
    SELECT COUNT(*) INTO v_payments_count FROM payments_backup_20241125;
    SELECT COUNT(*) INTO v_clients_count FROM clients_backup_20241125;
    
    -- Contar paid_loans se existir
    IF EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans_backup_20241125'
    ) THEN
        EXECUTE 'SELECT COUNT(*) FROM paid_loans_backup_20241125' INTO v_paid_loans_count;
    END IF;
    
    -- Calcular tamanho total
    SELECT pg_size_pretty(
        pg_total_relation_size('loans_backup_20241125') +
        pg_total_relation_size('payments_backup_20241125') +
        pg_total_relation_size('clients_backup_20241125') +
        CASE 
            WHEN EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'paid_loans_backup_20241125'
            ) 
            THEN pg_total_relation_size('paid_loans_backup_20241125')
            ELSE 0
        END
    ) INTO v_total_size;
    
    RAISE NOTICE '';
    RAISE NOTICE '📊 Resumo do Backup:';
    RAISE NOTICE '-------------------------------------------';
    RAISE NOTICE '✅ Empréstimos (loans): % registros', v_loans_count;
    RAISE NOTICE '✅ Pagamentos (payments): % registros', v_payments_count;
    RAISE NOTICE '✅ Clientes (clients): % registros', v_clients_count;
    
    IF v_paid_loans_count > 0 THEN
        RAISE NOTICE '✅ Empréstimos Quitados (paid_loans): % registros', v_paid_loans_count;
    END IF;
    
    RAISE NOTICE '💾 Tamanho total do backup: %', v_total_size;
    RAISE NOTICE '';
    RAISE NOTICE '📋 Tabelas de Backup Criadas:';
    RAISE NOTICE '   - loans_backup_20241125';
    RAISE NOTICE '   - payments_backup_20241125';
    RAISE NOTICE '   - clients_backup_20241125';
    
    IF v_paid_loans_count > 0 THEN
        RAISE NOTICE '   - paid_loans_backup_20241125';
    END IF;
    
    RAISE NOTICE '';
END $$;

-- =====================================================
-- INSTRUÇÕES DE RESTAURAÇÃO
-- =====================================================

\echo ''
\echo '========================================='
\echo 'INSTRUÇÕES DE RESTAURAÇÃO'
\echo '========================================='
\echo ''
\echo '🔄 Para restaurar os dados originais em caso de problema:'
\echo ''
\echo '1. Restaurar tabela loans:'
\echo '   DROP TABLE IF EXISTS loans CASCADE;'
\echo '   CREATE TABLE loans AS SELECT * FROM loans_backup_20241125;'
\echo ''
\echo '2. Restaurar tabela payments:'
\echo '   DROP TABLE IF EXISTS payments CASCADE;'
\echo '   CREATE TABLE payments AS SELECT * FROM payments_backup_20241125;'
\echo ''
\echo '3. Restaurar tabela clients:'
\echo '   DROP TABLE IF EXISTS clients CASCADE;'
\echo '   CREATE TABLE clients AS SELECT * FROM clients_backup_20241125;'
\echo ''
\echo '4. Recriar índices e constraints (execute database-setup.sql)'
\echo ''
\echo '⚠️  IMPORTANTE: Guarde o nome das tabelas de backup!'
\echo '   Elas têm a data no nome: _backup_20241125'
\echo ''
\echo '========================================='

-- =====================================================
-- CRIAR SCRIPT DE RESTAURAÇÃO RÁPIDA
-- =====================================================

CREATE OR REPLACE VIEW restore_commands AS
SELECT '-- COMANDOS DE RESTAURAÇÃO RÁPIDA - LITORAL CRED' as comando
UNION ALL SELECT '-- Execute estes comandos se precisar voltar ao estado anterior'
UNION ALL SELECT ''
UNION ALL SELECT '-- 1. Restaurar loans'
UNION ALL SELECT 'DROP TABLE IF EXISTS loans CASCADE;'
UNION ALL SELECT 'CREATE TABLE loans AS SELECT * FROM loans_backup_20241125;'
UNION ALL SELECT ''
UNION ALL SELECT '-- 2. Restaurar payments'
UNION ALL SELECT 'DROP TABLE IF EXISTS payments CASCADE;'
UNION ALL SELECT 'CREATE TABLE payments AS SELECT * FROM payments_backup_20241125;'
UNION ALL SELECT ''
UNION ALL SELECT '-- 3. Restaurar clients'
UNION ALL SELECT 'DROP TABLE IF EXISTS clients CASCADE;'
UNION ALL SELECT 'CREATE TABLE clients AS SELECT * FROM clients_backup_20241125;'
UNION ALL SELECT ''
UNION ALL SELECT '-- 4. Verificar restauração'
UNION ALL SELECT 'SELECT COUNT(*) FROM loans;'
UNION ALL SELECT 'SELECT COUNT(*) FROM payments;'
UNION ALL SELECT 'SELECT COUNT(*) FROM clients;';

\echo ''
\echo '📝 Script de restauração rápida disponível em:'
\echo '   SELECT * FROM restore_commands;'
\echo ''

-- =====================================================
-- FIM DO BACKUP
-- =====================================================

\echo '========================================='
\echo '✅ BACKUP CONCLUÍDO COM SUCESSO!'
\echo '========================================='
\echo ''
\echo '📋 Próximos passos:'
\echo '1. Execute: litoral-cred-diagnostico-rapido.sql'
\echo '2. Execute: litoral-cred-restore-paid-loans.sql'
\echo '3. Execute: litoral-cred-recover-data.sql'
\echo ''
\echo '⚠️  Em caso de problemas, use os comandos em:'
\echo '   SELECT * FROM restore_commands;'
\echo ''
\echo '========================================='
