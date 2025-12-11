-- =====================================================
-- ROLLBACK - CONTROLE FINANCEIRO
-- =====================================================
-- Este script remove TODAS as alterações feitas pelo
-- sistema de Controle Financeiro
-- Execute no SQL Editor do Supabase
-- URL: https://pebwoerzslfzhjptyjwh.supabase.co
-- =====================================================

-- ATENÇÃO: Este script vai DELETAR todos os dados!
-- Faça backup antes se necessário!

BEGIN;

-- =====================================================
-- 1. DROPAR TRIGGERS
-- =====================================================

DROP TRIGGER IF EXISTS update_fc_entries_timestamp ON financial_control_entries;
DROP TRIGGER IF EXISTS update_fc_expenses_timestamp ON financial_control_expenses;
DROP TRIGGER IF EXISTS update_fc_reinvestments_timestamp ON financial_control_reinvestments;
DROP TRIGGER IF EXISTS update_fc_settings_timestamp ON financial_control_settings;

-- =====================================================
-- 2. DROPAR FUNÇÕES
-- =====================================================

DROP FUNCTION IF EXISTS update_financial_control_timestamp();
DROP FUNCTION IF EXISTS get_current_financial_balance();
DROP FUNCTION IF EXISTS get_recommended_reinvestment();

-- =====================================================
-- 3. DROPAR VIEWS
-- =====================================================

DROP VIEW IF EXISTS financial_control_summary;
DROP VIEW IF EXISTS expenses_by_category;
DROP VIEW IF EXISTS entries_by_company;
DROP VIEW IF EXISTS monthly_financial_report;

-- =====================================================
-- 4. DROPAR TABELAS (ordem reversa por dependências)
-- =====================================================

DROP TABLE IF EXISTS financial_control_settings CASCADE;
DROP TABLE IF EXISTS financial_control_reinvestments CASCADE;
DROP TABLE IF EXISTS financial_control_expenses CASCADE;
DROP TABLE IF EXISTS financial_control_entries CASCADE;

-- =====================================================
-- 5. DROPAR ÍNDICES (se não foram dropados automaticamente)
-- =====================================================

DROP INDEX IF EXISTS idx_fc_entries_company;
DROP INDEX IF EXISTS idx_fc_entries_date;
DROP INDEX IF EXISTS idx_fc_entries_period;
DROP INDEX IF EXISTS idx_fc_expenses_date;
DROP INDEX IF EXISTS idx_fc_expenses_category;
DROP INDEX IF EXISTS idx_fc_reinvestments_date;
DROP INDEX IF EXISTS idx_fc_reinvestments_status;

COMMIT;

-- =====================================================
-- VERIFICAÇÃO
-- =====================================================
-- Execute estas queries para verificar se tudo foi removido:

-- Verificar tabelas
SELECT table_name 
FROM information_schema.tables 
WHERE table_name LIKE 'financial_control%';

-- Verificar views
SELECT table_name 
FROM information_schema.views 
WHERE table_name LIKE 'financial_control%' 
   OR table_name LIKE 'expenses_by_category%'
   OR table_name LIKE 'entries_by_company%'
   OR table_name LIKE 'monthly_financial_report%';

-- Verificar funções
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_name LIKE '%financial%';

-- =====================================================
-- RESULTADO ESPERADO
-- =====================================================
-- Todas as queries acima devem retornar 0 linhas
-- Se retornarem alguma linha, algo não foi removido

-- =====================================================
-- CONCLUÍDO
-- =====================================================
-- ✅ Todas as alterações do Controle Financeiro foram revertidas
-- ✅ Nenhum dado foi mantido
-- ✅ Banco de dados voltou ao estado anterior
-- =====================================================
