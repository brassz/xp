-- =====================================================
-- 🔥 FIX COMPLETO - IMPERATRIZ CRED
-- =====================================================
-- Este script resolve TODOS os problemas de schema da IMPERATRIZ:
-- 1. Coluna 'original_amount' faltando em 'loans'
-- 2. Coluna 'fine_amount' faltando em 'payments'
--
-- ⚠️ EXECUTE NO BANCO DA IMPERATRIZ:
-- URL: https://eppzphzwwpvpoocospxy.supabase.co
-- =====================================================

-- ========================================
-- PARTE 1: CORRIGIR TABELA LOANS
-- ========================================

DO $$ 
BEGIN
    RAISE NOTICE '🔧 INICIANDO CORREÇÃO DA TABELA LOANS...';
END $$;

-- Adicionar coluna original_amount
ALTER TABLE loans 
ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);

-- Preencher valores existentes
UPDATE loans 
SET original_amount = amount 
WHERE original_amount IS NULL;

-- Tornar obrigatório
ALTER TABLE loans 
ALTER COLUMN original_amount SET NOT NULL;

-- Criar índice
CREATE INDEX IF NOT EXISTS idx_loans_original_amount ON loans(original_amount);

-- Adicionar comentários
COMMENT ON COLUMN loans.amount IS 'Valor atual do empréstimo (reduzido por pagamentos)';
COMMENT ON COLUMN loans.original_amount IS 'Valor original do empréstimo (NUNCA alterado)';

DO $$ 
BEGIN
    RAISE NOTICE '✅ TABELA LOANS CORRIGIDA!';
    RAISE NOTICE '   - Coluna original_amount adicionada';
    RAISE NOTICE '   - Valores existentes preservados';
    RAISE NOTICE '   - Índice criado';
END $$;

-- ========================================
-- PARTE 2: CORRIGIR TABELA PAYMENTS
-- ========================================

DO $$ 
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '🔧 INICIANDO CORREÇÃO DA TABELA PAYMENTS...';
END $$;

-- Adicionar coluna fine_amount (multa)
ALTER TABLE payments 
ADD COLUMN IF NOT EXISTS fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);

-- Adicionar comentário
COMMENT ON COLUMN payments.fine_amount IS 'Valor da multa aplicada ao pagamento (opcional, separado do valor principal)';

-- Criar índice para consultas de multas
CREATE INDEX IF NOT EXISTS idx_payments_fine_amount ON payments(fine_amount) WHERE fine_amount > 0;

DO $$ 
BEGIN
    RAISE NOTICE '✅ TABELA PAYMENTS CORRIGIDA!';
    RAISE NOTICE '   - Coluna fine_amount adicionada';
    RAISE NOTICE '   - Valor padrão: 0.00';
    RAISE NOTICE '   - Índice criado';
END $$;

-- ========================================
-- VERIFICAÇÕES E ESTATÍSTICAS
-- ========================================

DO $$ 
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '📊 GERANDO RELATÓRIOS DE VERIFICAÇÃO...';
END $$;

-- Verificar estrutura da tabela LOANS
SELECT 
    '📋 ESTRUTURA LOANS' as titulo;

SELECT 
    column_name AS "Coluna", 
    data_type AS "Tipo", 
    is_nullable AS "NULL?",
    column_default AS "Padrão"
FROM information_schema.columns 
WHERE table_name = 'loans' 
AND column_name IN ('amount', 'original_amount', 'interest_rate', 'status')
ORDER BY ordinal_position;

-- Verificar estrutura da tabela PAYMENTS
SELECT 
    '📋 ESTRUTURA PAYMENTS' as titulo;

SELECT 
    column_name AS "Coluna", 
    data_type AS "Tipo", 
    is_nullable AS "NULL?",
    column_default AS "Padrão"
FROM information_schema.columns 
WHERE table_name = 'payments' 
AND column_name IN ('amount', 'fine_amount', 'payment_type', 'payment_date')
ORDER BY ordinal_position;

-- Estatísticas de empréstimos
SELECT 
    '💰 ESTATÍSTICAS DE EMPRÉSTIMOS' as titulo;

SELECT 
    COUNT(*) AS "Total Empréstimos",
    COUNT(CASE WHEN original_amount IS NOT NULL THEN 1 END) AS "Com original_amount",
    SUM(original_amount) AS "Total Original",
    SUM(amount) AS "Total Atual",
    AVG(interest_rate) AS "Taxa Média %"
FROM loans;

-- Estatísticas de pagamentos
SELECT 
    '💳 ESTATÍSTICAS DE PAGAMENTOS' as titulo;

SELECT 
    COUNT(*) AS "Total Pagamentos",
    SUM(amount) AS "Total Pago",
    SUM(fine_amount) AS "Total Multas",
    COUNT(CASE WHEN fine_amount > 0 THEN 1 END) AS "Pagamentos com Multa"
FROM payments;

-- Índices criados
SELECT 
    '📑 ÍNDICES CRIADOS' as titulo;

SELECT 
    tablename AS "Tabela",
    indexname AS "Nome do Índice"
FROM pg_indexes 
WHERE tablename IN ('loans', 'payments')
AND (indexname LIKE '%original_amount%' OR indexname LIKE '%fine_amount%')
ORDER BY tablename, indexname;

-- Exemplo de empréstimos
SELECT 
    '💵 PRIMEIROS 5 EMPRÉSTIMOS' as titulo;

SELECT 
    id,
    client_id,
    amount AS "Valor Atual",
    original_amount AS "Valor Original",
    (original_amount - amount) AS "Diferença",
    interest_rate AS "Taxa %",
    status,
    DATE(created_at) AS "Criado Em"
FROM loans 
ORDER BY created_at DESC 
LIMIT 5;

-- ========================================
-- ✅ CORREÇÃO COMPLETA!
-- ========================================

DO $$ 
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '════════════════════════════════════════';
    RAISE NOTICE '✅ CORREÇÃO COMPLETA CONCLUÍDA COM SUCESSO!';
    RAISE NOTICE '════════════════════════════════════════';
    RAISE NOTICE '';
    RAISE NOTICE '📋 PROBLEMAS CORRIGIDOS:';
    RAISE NOTICE '   ✅ original_amount adicionado em loans';
    RAISE NOTICE '   ✅ fine_amount adicionado em payments';
    RAISE NOTICE '   ✅ Índices criados para performance';
    RAISE NOTICE '   ✅ Valores existentes preservados';
    RAISE NOTICE '';
    RAISE NOTICE '⚠️  PRÓXIMO PASSO OBRIGATÓRIO:';
    RAISE NOTICE '   👉 RECARREGAR SCHEMA CACHE DO SUPABASE!';
    RAISE NOTICE '';
    RAISE NOTICE '   Como fazer:';
    RAISE NOTICE '   1. Settings → API → Schema Cache';
    RAISE NOTICE '   2. Clique "Reload schema"';
    RAISE NOTICE '   3. Aguarde 30 segundos';
    RAISE NOTICE '   4. Teste na aplicação!';
    RAISE NOTICE '';
    RAISE NOTICE '   OU execute: NOTIFY pgrst, ''reload schema'';';
    RAISE NOTICE '';
    RAISE NOTICE '════════════════════════════════════════';
END $$;

-- =====================================================
-- APÓS RECARREGAR O SCHEMA CACHE:
-- =====================================================
-- 
-- ✅ Criar empréstimos funcionará sem erros
-- ✅ Renovar empréstimos funcionará sem erros  
-- ✅ Valor restante calculado corretamente
-- ✅ Multas registradas corretamente
-- ✅ Sistema 100% funcional na IMPERATRIZ CRED!
--
-- =====================================================
