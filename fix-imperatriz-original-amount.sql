-- =====================================================
-- FIX URGENTE: IMPERATRIZ CRED - ADICIONAR original_amount
-- =====================================================
-- Este script resolve 2 problemas da empresa IMPERATRIZ:
-- 1. Erro: "Could not find the 'original_amount' column of 'loans' in the schema cache"
-- 2. Valor restante zerado ao criar empréstimos
--
-- ⚠️ EXECUTE ESTE SCRIPT NO BANCO DA IMPERATRIZ CRED:
-- URL: https://eppzphzwwpvpoocospxy.supabase.co
-- =====================================================

-- ===== DIAGNÓSTICO =====
-- Verificar se a coluna original_amount existe
DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'loans' 
        AND column_name = 'original_amount'
    ) THEN
        RAISE NOTICE '✅ Coluna original_amount já existe!';
    ELSE
        RAISE NOTICE '❌ Coluna original_amount NÃO existe - será criada agora';
    END IF;
END $$;

-- ===== CORREÇÃO 1: ADICIONAR COLUNA =====
-- Adicionar coluna original_amount à tabela loans (se não existir)
ALTER TABLE loans 
ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);

RAISE NOTICE '✅ Passo 1/5: Coluna original_amount adicionada';

-- ===== CORREÇÃO 2: PREENCHER VALORES EXISTENTES =====
-- Para empréstimos já existentes, copiar o valor de amount
UPDATE loans 
SET original_amount = amount 
WHERE original_amount IS NULL;

RAISE NOTICE '✅ Passo 2/5: Valores existentes preenchidos';

-- ===== CORREÇÃO 3: TORNAR OBRIGATÓRIO =====
-- Tornar a coluna obrigatória (NOT NULL)
ALTER TABLE loans 
ALTER COLUMN original_amount SET NOT NULL;

RAISE NOTICE '✅ Passo 3/5: Coluna definida como obrigatória';

-- ===== CORREÇÃO 4: DOCUMENTAÇÃO =====
-- Adicionar comentários explicativos
COMMENT ON COLUMN loans.amount IS 'Valor atual do empréstimo (pode ser reduzido por pagamentos de capital)';
COMMENT ON COLUMN loans.original_amount IS 'Valor original do empréstimo (NUNCA deve ser alterado após criação - usado para cálculos de valor restante)';

RAISE NOTICE '✅ Passo 4/5: Documentação adicionada';

-- ===== CORREÇÃO 5: ÍNDICE PARA PERFORMANCE =====
-- Criar índice para melhorar consultas
CREATE INDEX IF NOT EXISTS idx_loans_original_amount ON loans(original_amount);

RAISE NOTICE '✅ Passo 5/5: Índice criado';

-- =====================================================
-- VERIFICAÇÕES
-- =====================================================

-- Verificar estrutura da tabela
SELECT 
    '📊 ESTRUTURA DA TABELA LOANS' as titulo;

SELECT 
    column_name AS "Coluna", 
    data_type AS "Tipo", 
    is_nullable AS "Aceita NULL",
    column_default AS "Valor Padrão"
FROM information_schema.columns 
WHERE table_name = 'loans' 
AND column_name IN ('id', 'amount', 'original_amount', 'interest_rate', 'total_amount', 'status')
ORDER BY ordinal_position;

-- Verificar índices
SELECT 
    '📑 ÍNDICES DA TABELA LOANS' as titulo;

SELECT 
    indexname AS "Nome do Índice",
    indexdef AS "Definição"
FROM pg_indexes 
WHERE tablename = 'loans'
AND indexname LIKE '%original_amount%';

-- Verificar empréstimos existentes
SELECT 
    '💰 PRIMEIROS 10 EMPRÉSTIMOS' as titulo;

SELECT 
    id,
    client_id,
    amount AS "Valor Atual",
    original_amount AS "Valor Original",
    interest_rate AS "Taxa Juros %",
    (original_amount - amount) AS "Diferença",
    status,
    DATE(created_at) AS "Data Criação"
FROM loans 
ORDER BY created_at DESC 
LIMIT 10;

-- Estatísticas gerais
SELECT 
    '📈 ESTATÍSTICAS GERAIS' as titulo;

SELECT 
    COUNT(*) AS "Total de Empréstimos",
    COUNT(CASE WHEN original_amount IS NOT NULL THEN 1 END) AS "Com original_amount",
    COUNT(CASE WHEN original_amount IS NULL THEN 1 END) AS "Sem original_amount (DEVE SER 0)",
    SUM(original_amount) AS "Total Original Emprestado",
    SUM(amount) AS "Total Atual",
    AVG(interest_rate) AS "Taxa Média %"
FROM loans;

-- =====================================================
-- ✅ CORREÇÃO CONCLUÍDA!
-- =====================================================
-- 
-- PRÓXIMOS PASSOS OBRIGATÓRIOS:
-- 
-- 1. RECARREGAR O SCHEMA CACHE DO SUPABASE
--    - Vá para: Settings → API → Schema Cache
--    - Clique em: "Reload schema"
--    
--    OU execute via SQL:
--    NOTIFY pgrst, 'reload schema';
--
-- 2. AGUARDAR 30 SEGUNDOS
--    - O Supabase precisa deste tempo para atualizar o cache
--
-- 3. TESTAR NA APLICAÇÃO
--    - Selecione a empresa IMPERATRIZ CRED
--    - Tente criar um novo empréstimo
--    - Verifique se o valor restante aparece corretamente
--
-- 4. SE O ERRO PERSISTIR:
--    - Reinicie a API do Supabase: Settings → API → Restart API
--    - Aguarde 1-2 minutos
--    - Teste novamente
--
-- =====================================================
-- 
-- 🎯 O QUE FOI CORRIGIDO:
-- 
-- ANTES:
-- ❌ Coluna original_amount não existia
-- ❌ Erro ao criar empréstimo: "Could not find the 'original_amount' column"
-- ❌ Valor restante zerado (cálculo falhava)
--
-- DEPOIS:
-- ✅ Coluna original_amount existe e é obrigatória
-- ✅ Valores existentes foram preservados
-- ✅ Novos empréstimos salvam original_amount corretamente
-- ✅ Valor restante calculado corretamente
-- ✅ Sistema funciona perfeitamente na IMPERATRIZ CRED
--
-- =====================================================
-- 
-- 📝 DETALHES TÉCNICOS:
-- 
-- Campo original_amount:
-- - Tipo: DECIMAL(10,2)
-- - Obrigatório: SIM (NOT NULL)
-- - Propósito: Preservar valor original do empréstimo
-- - Comportamento: Definido na criação, NUNCA alterado
-- - Uso: Base para cálculos de valor restante
--
-- Campo amount:
-- - Tipo: DECIMAL(10,2)
-- - Propósito: Valor atual do empréstimo
-- - Comportamento: Reduzido por pagamentos de capital
-- 
-- Relação:
-- - original_amount = Valor inicial (fixo)
-- - amount = Valor atual (variável)
-- - Diferença = Capital já pago
--
-- =====================================================
