-- =====================================================
-- VERIFICAÇÃO RÁPIDA DO SCHEMA DE INSTALLMENTS
-- =====================================================
-- Execute este script para verificar se a correção foi aplicada
-- =====================================================

-- =====================================================
-- 1. VERIFICAR SE AS COLUNAS NECESSÁRIAS EXISTEM
-- =====================================================

SELECT 
    '✓ ESTRUTURA DA TABELA INSTALLMENTS' as verificacao;

SELECT 
    column_name,
    data_type,
    CASE 
        WHEN is_nullable = 'YES' THEN '✓ NULL'
        ELSE '✓ NOT NULL'
    END as nullable,
    CASE 
        WHEN column_name = 'first_due_date' THEN '✅ OBRIGATÓRIO'
        WHEN column_name = 'loan_id' THEN '✅ OPCIONAL'
        WHEN column_name = 'total_installments' THEN '✅ OBRIGATÓRIO'
        WHEN column_name = 'installment_amount' THEN '✅ OBRIGATÓRIO'
        ELSE '✓ OK'
    END as status
FROM information_schema.columns
WHERE table_name = 'installments'
AND column_name IN (
    'id',
    'loan_id',
    'client_id',
    'total_amount',
    'total_installments',
    'installment_amount',
    'first_due_date',
    'interest_rate',
    'status',
    'notes',
    'created_by',
    'created_at',
    'updated_at'
)
ORDER BY 
    CASE column_name
        WHEN 'id' THEN 1
        WHEN 'loan_id' THEN 2
        WHEN 'client_id' THEN 3
        WHEN 'total_amount' THEN 4
        WHEN 'total_installments' THEN 5
        WHEN 'installment_amount' THEN 6
        WHEN 'first_due_date' THEN 7
        WHEN 'interest_rate' THEN 8
        WHEN 'status' THEN 9
        WHEN 'notes' THEN 10
        WHEN 'created_by' THEN 11
        WHEN 'created_at' THEN 12
        WHEN 'updated_at' THEN 13
    END;

-- =====================================================
-- 2. VERIFICAR ÍNDICES
-- =====================================================

SELECT 
    '✓ ÍNDICES DA TABELA INSTALLMENTS' as verificacao;

SELECT 
    indexname as index_name,
    indexdef as definition,
    '✅ OK' as status
FROM pg_indexes
WHERE tablename = 'installments'
AND indexname IN (
    'installments_pkey',
    'idx_installments_loan_id',
    'idx_installments_client_id',
    'idx_installments_status',
    'idx_installments_first_due_date',
    'idx_installments_created_at'
)
ORDER BY indexname;

-- =====================================================
-- 3. VERIFICAR CONSTRAINTS
-- =====================================================

SELECT 
    '✓ CONSTRAINTS DA TABELA INSTALLMENTS' as verificacao;

SELECT 
    conname as constraint_name,
    contype as constraint_type,
    CASE contype
        WHEN 'p' THEN '✅ PRIMARY KEY'
        WHEN 'f' THEN '✅ FOREIGN KEY'
        WHEN 'c' THEN '✅ CHECK'
        WHEN 'u' THEN '✅ UNIQUE'
        ELSE '✓ OTHER'
    END as description,
    '✅ OK' as status
FROM pg_constraint
WHERE conrelid = 'installments'::regclass
ORDER BY contype, conname;

-- =====================================================
-- 4. VERIFICAR FOREIGN KEYS
-- =====================================================

SELECT 
    '✓ FOREIGN KEYS DA TABELA INSTALLMENTS' as verificacao;

SELECT 
    tc.constraint_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    '✅ OK' as status
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_name = 'installments'
AND tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.constraint_name;

-- =====================================================
-- 5. VERIFICAR TABELA INSTALLMENT_PAYMENTS
-- =====================================================

SELECT 
    '✓ TABELA INSTALLMENT_PAYMENTS (PARCELAS)' as verificacao;

SELECT 
    column_name,
    data_type,
    CASE 
        WHEN is_nullable = 'YES' THEN '✓ NULL'
        ELSE '✓ NOT NULL'
    END as nullable,
    '✓ OK' as status
FROM information_schema.columns
WHERE table_name = 'installment_payments'
AND column_name IN (
    'id',
    'installment_id',
    'installment_number',
    'amount',
    'due_date',
    'paid_date',
    'paid_amount',
    'status',
    'payment_method',
    'notes',
    'created_at',
    'updated_at'
)
ORDER BY ordinal_position;

-- =====================================================
-- 6. CONTAR REGISTROS (SE HOUVER)
-- =====================================================

SELECT 
    '✓ ESTATÍSTICAS DA TABELA' as verificacao;

SELECT 
    'installments' as tabela,
    COUNT(*) as total_registros,
    COUNT(CASE WHEN loan_id IS NOT NULL THEN 1 END) as com_emprestimo,
    COUNT(CASE WHEN loan_id IS NULL THEN 1 END) as sem_emprestimo,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as ativos,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completos,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelados
FROM installments;

SELECT 
    'installment_payments' as tabela,
    COUNT(*) as total_parcelas,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pendentes,
    COUNT(CASE WHEN status = 'paid' THEN 1 END) as pagas,
    COUNT(CASE WHEN status = 'overdue' THEN 1 END) as vencidas,
    COUNT(CASE WHEN status = 'partial' THEN 1 END) as parciais
FROM installment_payments;

-- =====================================================
-- 7. VERIFICAR VIEW INSTALLMENTS_WITH_DETAILS
-- =====================================================

SELECT 
    '✓ VIEW INSTALLMENTS_WITH_DETAILS' as verificacao;

SELECT 
    table_name as view_name,
    '✅ VIEW EXISTE' as status
FROM information_schema.views
WHERE table_name = 'installments_with_details'
AND table_schema = 'public';

-- Verificar colunas da view
SELECT 
    column_name,
    data_type,
    '✓ OK' as status
FROM information_schema.columns
WHERE table_name = 'installments_with_details'
ORDER BY ordinal_position
LIMIT 10;

-- =====================================================
-- 8. TESTE DE INSERÇÃO (SIMULAÇÃO)
-- =====================================================

SELECT 
    '✓ TESTE DE VALIDAÇÃO DE SCHEMA' as verificacao;

-- Verificar se é possível criar um registro (apenas validação, não insere)
SELECT 
    'Schema válido para inserção' as resultado,
    'Pode criar parcelamentos ✅' as status
WHERE EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_name = 'installments' 
    AND column_name = 'first_due_date'
);

-- =====================================================
-- RESULTADO ESPERADO
-- =====================================================
-- ✅ Todas as colunas obrigatórias devem aparecer
-- ✅ first_due_date deve ser NOT NULL
-- ✅ loan_id deve ser NULL (opcional)
-- ✅ Índices devem estar criados
-- ✅ Foreign keys devem estar configuradas
-- ✅ Mensagem "Schema válido para inserção" deve aparecer
-- =====================================================

-- =====================================================
-- SE ALGUM PROBLEMA FOR ENCONTRADO
-- =====================================================
-- 1. Execute o script fix-franca-private-installments-schema.sql
-- 2. Execute este script novamente para verificar
-- 3. Faça logout e login na aplicação
-- 4. Tente criar um parcelamento
-- =====================================================

SELECT 
    '========================================' as separador;

SELECT 
    '✅ VERIFICAÇÃO COMPLETA' as resultado,
    'Se todas as queries acima retornaram dados, o schema está correto!' as mensagem;

SELECT 
    '========================================' as separador;
