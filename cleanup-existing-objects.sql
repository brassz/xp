-- Script para limpar completamente todos os objetos existentes
-- Execute este arquivo ANTES de executar loan-status-tables.sql
-- Use apenas se houver problemas com objetos existentes

-- Verificar o que existe atualmente
SELECT 
    schemaname,
    tablename,
    tabletype
FROM pg_tables 
WHERE tablename IN ('paid_loans', 'overdue_loans', 'partial_paid_loans', 'cancelled_loans')
ORDER BY tablename;

SELECT 
    schemaname,
    viewname,
    definition
FROM pg_views 
WHERE viewname IN ('paid_loans', 'overdue_loans', 'partial_paid_loans', 'cancelled_loans')
ORDER BY viewname;

-- Remover triggers existentes (se houver)
DO $$
DECLARE
    trigger_rec RECORD;
BEGIN
    FOR trigger_rec IN 
        SELECT trigger_name, event_object_table 
        FROM information_schema.triggers 
        WHERE event_object_table = 'loans' 
        AND trigger_name LIKE '%loan%'
    LOOP
        EXECUTE 'DROP TRIGGER IF EXISTS ' || trigger_rec.trigger_name || ' ON loans CASCADE';
        RAISE NOTICE 'Trigger removido: %', trigger_rec.trigger_name;
    END LOOP;
END $$;

-- Remover funções existentes
DROP FUNCTION IF EXISTS insert_paid_loan() CASCADE;
DROP FUNCTION IF EXISTS insert_overdue_loan() CASCADE;
DROP FUNCTION IF EXISTS insert_partial_paid_loan() CASCADE;
DROP FUNCTION IF EXISTS insert_cancelled_loan() CASCADE;
DROP FUNCTION IF EXISTS cleanup_loan_status_tables() CASCADE;

-- Remover views existentes
DROP VIEW IF EXISTS cancelled_loans CASCADE;
DROP VIEW IF EXISTS partial_paid_loans CASCADE;
DROP VIEW IF EXISTS overdue_loans CASCADE;
DROP VIEW IF EXISTS paid_loans CASCADE;

-- Remover tabelas existentes
DROP TABLE IF EXISTS cancelled_loans CASCADE;
DROP TABLE IF EXISTS partial_paid_loans CASCADE;
DROP TABLE IF EXISTS overdue_loans CASCADE;
DROP TABLE IF EXISTS paid_loans CASCADE;

-- Verificar se tudo foi removido
SELECT 
    'Tabelas restantes:' as tipo,
    tablename
FROM pg_tables 
WHERE tablename IN ('paid_loans', 'overdue_loans', 'partial_paid_loans', 'cancelled_loans')

UNION ALL

SELECT 
    'Views restantes:' as tipo,
    viewname
FROM pg_views 
WHERE viewname IN ('paid_loans', 'overdue_loans', 'partial_paid_loans', 'cancelled_loans')

UNION ALL

SELECT 
    'Triggers restantes:' as tipo,
    trigger_name
FROM information_schema.triggers 
WHERE event_object_table = 'loans' 
AND trigger_name LIKE '%loan%';

-- Verificar se as tabelas principais existem
SELECT 
    CASE 
        WHEN EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'loans') THEN '✓ Tabela loans existe'
        ELSE '✗ Tabela loans NÃO existe'
    END as status_loans,
    
    CASE 
        WHEN EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'clients') THEN '✓ Tabela clients existe'
        ELSE '✗ Tabela clients NÃO existe'
    END as status_clients,
    
    CASE 
        WHEN EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users') THEN '✓ Tabela users existe'
        ELSE '✗ Tabela users NÃO existe'
    END as status_users,
    
    CASE 
        WHEN EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'payments') THEN '✓ Tabela payments existe'
        ELSE '✗ Tabela payments NÃO existe'
    END as status_payments;

RAISE NOTICE 'Limpeza concluída! Agora execute loan-status-tables.sql'; 