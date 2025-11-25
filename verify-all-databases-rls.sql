-- =====================================================
-- VERIFICAÇÃO RÁPIDA DE RLS EM TODAS AS EMPRESAS
-- =====================================================
-- Execute este script em cada banco de dados para verificar
-- o status de RLS e se há problemas similares
-- =====================================================

-- Informações do banco atual
SELECT 
    current_database() as banco_atual,
    current_user as usuario_atual,
    NOW() as data_verificacao;

-- =====================================================
-- 1. VERIFICAR STATUS DE RLS
-- =====================================================
SELECT 
    '=== STATUS DE RLS ===' as secao,
    tablename,
    CASE 
        WHEN rowsecurity = true THEN '❌ RLS ATIVO (pode causar problemas)'
        ELSE '✅ RLS DESABILITADO'
    END as status
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('users', 'clients', 'loans', 'payments', 
                  'guarantors', 'emergency_contacts', 'client_documents',
                  'expenses', 'expense_categories', 'installments', 
                  'installment_payments', 'cash_transactions', 'cash_settings',
                  'paid_loans', 'cancelled_loans', 'client_pix_keys')
ORDER BY tablename;

-- =====================================================
-- 2. CONTAR POLÍTICAS ATIVAS
-- =====================================================
SELECT 
    '=== POLÍTICAS RLS ATIVAS ===' as secao,
    COUNT(*) as total_politicas,
    CASE 
        WHEN COUNT(*) > 0 THEN '⚠️ Há políticas ativas (podem causar problemas)'
        ELSE '✅ Nenhuma política ativa'
    END as status
FROM pg_policies 
WHERE schemaname = 'public';

-- =====================================================
-- 3. LISTAR POLÍTICAS POR TABELA
-- =====================================================
SELECT 
    '=== DETALHES DAS POLÍTICAS ===' as secao,
    tablename,
    COUNT(*) as num_politicas
FROM pg_policies 
WHERE schemaname = 'public'
GROUP BY tablename
ORDER BY num_politicas DESC;

-- =====================================================
-- 4. VERIFICAR DADOS EXISTENTES
-- =====================================================
SELECT '=== DADOS EXISTENTES ===' as secao;

SELECT 
    'users' as tabela,
    COUNT(*) as total_registros
FROM users
UNION ALL
SELECT 
    'clients' as tabela,
    COUNT(*) as total_registros
FROM clients
UNION ALL
SELECT 
    'loans' as tabela,
    COUNT(*) as total_registros
FROM loans
UNION ALL
SELECT 
    'payments' as tabela,
    COUNT(*) as total_registros
FROM payments
ORDER BY tabela;

-- =====================================================
-- 5. VERIFICAR CONSTRAINTS DE FOREIGN KEY
-- =====================================================
SELECT 
    '=== FOREIGN KEYS ===' as secao,
    conname AS constraint_name,
    conrelid::regclass AS tabela,
    pg_get_constraintdef(oid) AS definicao
FROM pg_constraint
WHERE contype = 'f'
AND conrelid::regclass::text IN ('loans', 'payments', 'installments')
ORDER BY conrelid::regclass::text, conname;

-- =====================================================
-- 6. VERIFICAR SE HÁ PROBLEMAS CONHECIDOS
-- =====================================================
SELECT '=== DIAGNÓSTICO ===' as secao;

-- Verificar se clients tem RLS ativo
SELECT 
    CASE 
        WHEN rowsecurity = true THEN 
            '❌ PROBLEMA: Tabela CLIENTS tem RLS ativo - pode impedir criação de empréstimos'
        ELSE 
            '✅ OK: Tabela CLIENTS não tem RLS ativo'
    END as diagnostico_clients
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename = 'clients';

-- Verificar se loans tem RLS ativo
SELECT 
    CASE 
        WHEN rowsecurity = true THEN 
            '❌ PROBLEMA: Tabela LOANS tem RLS ativo - pode impedir operações'
        ELSE 
            '✅ OK: Tabela LOANS não tem RLS ativo'
    END as diagnostico_loans
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename = 'loans';

-- Verificar se há clientes cadastrados
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 
            '⚠️ AVISO: Nenhum cliente cadastrado - cadastre clientes antes de criar empréstimos'
        ELSE 
            '✅ OK: ' || COUNT(*) || ' cliente(s) cadastrado(s)'
    END as diagnostico_clientes
FROM clients;

-- =====================================================
-- 7. RECOMENDAÇÃO FINAL
-- =====================================================
SELECT '=== RECOMENDAÇÃO ===' as secao;

SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM pg_tables WHERE schemaname = 'public' AND tablename = 'clients' AND rowsecurity = true) > 0
        OR (SELECT COUNT(*) FROM pg_tables WHERE schemaname = 'public' AND tablename = 'loans' AND rowsecurity = true) > 0
        OR (SELECT COUNT(*) FROM pg_policies WHERE schemaname = 'public') > 0
        THEN 
            '❌ AÇÃO NECESSÁRIA: Execute o script fix-mogiana-foreign-key.sql para desabilitar RLS e corrigir problemas'
        ELSE 
            '✅ TUDO OK: Este banco está configurado corretamente'
    END as recomendacao;

-- =====================================================
-- 8. EXEMPLO DE TESTE
-- =====================================================
SELECT '
=== TESTE SUGERIDO ===
Para testar se está tudo funcionando:

1. Tente criar um cliente:
   INSERT INTO clients (name, cpf, email, phone, address)
   VALUES (''Teste Cliente'', ''999.999.999-99'', ''teste@teste.com'', ''(11) 99999-9999'', ''Rua Teste'')
   RETURNING *;

2. Depois, tente criar um empréstimo usando o ID do cliente criado:
   INSERT INTO loans (client_id, amount, interest_rate, loan_date, due_date, status)
   VALUES (''[ID_DO_CLIENTE]'', 1000.00, 2.5, CURRENT_DATE, CURRENT_DATE + 30, ''active'')
   RETURNING *;

Se ambos funcionarem, o problema está resolvido!
' as instrucoes_teste;
