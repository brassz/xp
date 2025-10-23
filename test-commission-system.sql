-- =====================================================
-- SCRIPT DE TESTE DO SISTEMA DE COMISSÕES
-- =====================================================
-- Execute este script para testar se o sistema de
-- comissões está funcionando corretamente
-- =====================================================

-- =====================================================
-- 1. VERIFICAR SE AS TABELAS FORAM CRIADAS
-- =====================================================
SELECT 
    'Verificando tabelas...' as status,
    table_name,
    CASE 
        WHEN table_name IN ('commission_settings', 'commissions', 'commission_payments') 
        THEN '✓ OK' 
        ELSE '✗ ERRO' 
    END as resultado
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('commission_settings', 'commissions', 'commission_payments')
ORDER BY table_name;

-- =====================================================
-- 2. VERIFICAR CONFIGURAÇÕES PADRÃO
-- =====================================================
SELECT 
    'Verificando configurações...' as status,
    name,
    commission_rate,
    applies_to,
    is_active,
    CASE WHEN is_active THEN '✓ ATIVA' ELSE '✗ INATIVA' END as resultado
FROM commission_settings
ORDER BY name;

-- =====================================================
-- 3. VERIFICAR TRIGGERS
-- =====================================================
SELECT 
    'Verificando triggers...' as status,
    trigger_name,
    event_object_table,
    CASE 
        WHEN trigger_name LIKE '%commission%' 
        THEN '✓ OK' 
        ELSE '✗ ERRO' 
    END as resultado
FROM information_schema.triggers 
WHERE trigger_name LIKE '%commission%'
ORDER BY trigger_name;

-- =====================================================
-- 4. VERIFICAR VIEWS
-- =====================================================
SELECT 
    'Verificando views...' as status,
    table_name,
    CASE 
        WHEN table_name IN ('commissions_with_details', 'commission_summary_by_period', 'pending_commissions') 
        THEN '✓ OK' 
        ELSE '✗ ERRO' 
    END as resultado
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_type = 'VIEW'
AND table_name LIKE '%commission%'
ORDER BY table_name;

-- =====================================================
-- 5. TESTE PRÁTICO - CRIAR EMPRÉSTIMO DE TESTE
-- =====================================================

-- Primeiro, vamos verificar se temos clientes e usuários
DO $$
DECLARE
    test_client_id UUID;
    test_user_id UUID;
    test_loan_id UUID;
    commission_count INTEGER;
BEGIN
    -- Buscar um cliente existente
    SELECT id INTO test_client_id FROM clients LIMIT 1;
    
    -- Buscar um usuário existente
    SELECT id INTO test_user_id FROM users LIMIT 1;
    
    IF test_client_id IS NULL THEN
        RAISE NOTICE '⚠️  AVISO: Nenhum cliente encontrado. Criando cliente de teste...';
        
        INSERT INTO clients (name, cpf, email, phone, address, created_by)
        VALUES (
            'Cliente Teste Comissão',
            '999.999.999-99',
            'teste.comissao@nexus.com',
            '(11) 99999-9999',
            'Endereço de Teste',
            test_user_id
        )
        RETURNING id INTO test_client_id;
        
        RAISE NOTICE '✓ Cliente de teste criado: %', test_client_id;
    END IF;
    
    IF test_user_id IS NULL THEN
        RAISE NOTICE '✗ ERRO: Nenhum usuário encontrado. Execute o script principal primeiro.';
        RETURN;
    END IF;
    
    -- Criar empréstimo de teste
    RAISE NOTICE '🧪 Criando empréstimo de teste...';
    
    INSERT INTO loans (
        client_id,
        amount,
        interest_rate,
        loan_date,
        due_date,
        created_by
    ) VALUES (
        test_client_id,
        5000.00,  -- R$ 5.000
        10.00,    -- 10% de juros
        CURRENT_DATE,
        CURRENT_DATE + INTERVAL '30 days',
        test_user_id
    )
    RETURNING id INTO test_loan_id;
    
    RAISE NOTICE '✓ Empréstimo de teste criado: %', test_loan_id;
    
    -- Aguardar um momento para o trigger processar
    PERFORM pg_sleep(1);
    
    -- Verificar se a comissão foi criada automaticamente
    SELECT COUNT(*) INTO commission_count
    FROM commissions 
    WHERE reference_id = test_loan_id AND reference_type = 'loan';
    
    IF commission_count > 0 THEN
        RAISE NOTICE '✓ Comissão criada automaticamente!';
        
        -- Mostrar detalhes da comissão
        RAISE NOTICE 'Detalhes da comissão:';
        PERFORM (
            SELECT RAISE(NOTICE, '  - Valor Principal: R$ %', principal_amount) FROM commissions WHERE reference_id = test_loan_id
        );
        PERFORM (
            SELECT RAISE(NOTICE, '  - Valor dos Juros: R$ %', interest_amount) FROM commissions WHERE reference_id = test_loan_id
        );
        PERFORM (
            SELECT RAISE(NOTICE, '  - Taxa de Comissão: %', commission_rate || '%') FROM commissions WHERE reference_id = test_loan_id
        );
        PERFORM (
            SELECT RAISE(NOTICE, '  - Valor da Comissão: R$ %', commission_amount) FROM commissions WHERE reference_id = test_loan_id
        );
    ELSE
        RAISE NOTICE '✗ ERRO: Comissão não foi criada automaticamente!';
    END IF;
    
END $$;

-- =====================================================
-- 6. VERIFICAR DADOS DE COMISSÕES CRIADAS
-- =====================================================
SELECT 
    'Comissões no sistema:' as status,
    COUNT(*) as total_comissoes,
    SUM(commission_amount) as valor_total_comissoes,
    AVG(commission_rate) as taxa_media_comissao
FROM commissions;

-- =====================================================
-- 7. TESTE DA FUNÇÃO DE RELATÓRIO
-- =====================================================
SELECT 
    'Testando função de relatório...' as status,
    *
FROM generate_commission_report(
    CURRENT_DATE - INTERVAL '30 days',
    CURRENT_DATE
);

-- =====================================================
-- 8. VERIFICAR VIEW DE COMISSÕES COM DETALHES
-- =====================================================
SELECT 
    'Testando view de comissões...' as status,
    client_name,
    reference_type,
    commission_amount,
    status
FROM commissions_with_details
LIMIT 5;

-- =====================================================
-- 9. TESTE DE PARCELAMENTO
-- =====================================================
DO $$
DECLARE
    test_client_id UUID;
    test_user_id UUID;
    test_installment_id UUID;
    commission_count INTEGER;
BEGIN
    -- Buscar cliente e usuário
    SELECT id INTO test_client_id FROM clients LIMIT 1;
    SELECT id INTO test_user_id FROM users LIMIT 1;
    
    IF test_client_id IS NOT NULL AND test_user_id IS NOT NULL THEN
        RAISE NOTICE '🧪 Criando parcelamento de teste...';
        
        INSERT INTO installments (
            client_id,
            total_amount,
            total_installments,
            installment_amount,
            first_due_date,
            interest_rate,
            created_by
        ) VALUES (
            test_client_id,
            12000.00,  -- R$ 12.000
            12,        -- 12 parcelas
            1000.00,   -- R$ 1.000 por parcela
            CURRENT_DATE + INTERVAL '30 days',
            5.00,      -- 5% de juros
            test_user_id
        )
        RETURNING id INTO test_installment_id;
        
        RAISE NOTICE '✓ Parcelamento de teste criado: %', test_installment_id;
        
        -- Aguardar processamento
        PERFORM pg_sleep(1);
        
        -- Verificar comissão
        SELECT COUNT(*) INTO commission_count
        FROM commissions 
        WHERE reference_id = test_installment_id AND reference_type = 'installment';
        
        IF commission_count > 0 THEN
            RAISE NOTICE '✓ Comissão de parcelamento criada automaticamente!';
        ELSE
            RAISE NOTICE '✗ ERRO: Comissão de parcelamento não foi criada!';
        END IF;
    END IF;
END $$;

-- =====================================================
-- 10. RESUMO FINAL DOS TESTES
-- =====================================================
SELECT 
    '=== RESUMO DOS TESTES ===' as titulo,
    (SELECT COUNT(*) FROM commission_settings WHERE is_active = true) as configuracoes_ativas,
    (SELECT COUNT(*) FROM commissions) as total_comissoes,
    (SELECT COUNT(*) FROM commissions WHERE status = 'pending') as comissoes_pendentes,
    (SELECT COALESCE(SUM(commission_amount), 0) FROM commissions) as valor_total_comissoes;

-- =====================================================
-- 11. VERIFICAÇÕES DE INTEGRIDADE
-- =====================================================

-- Verificar se todas as comissões têm referências válidas
SELECT 
    'Verificando integridade...' as status,
    CASE 
        WHEN COUNT(*) = 0 THEN '✓ Todas as comissões têm referências válidas'
        ELSE '✗ ' || COUNT(*) || ' comissões com referências inválidas'
    END as resultado
FROM commissions c
LEFT JOIN loans l ON c.reference_id = l.id AND c.reference_type = 'loan'
LEFT JOIN installments i ON c.reference_id = i.id AND c.reference_type = 'installment'
WHERE l.id IS NULL AND i.id IS NULL;

-- Verificar se todas as comissões têm clientes válidos
SELECT 
    'Verificando clientes...' as status,
    CASE 
        WHEN COUNT(*) = 0 THEN '✓ Todas as comissões têm clientes válidos'
        ELSE '✗ ' || COUNT(*) || ' comissões com clientes inválidos'
    END as resultado
FROM commissions c
LEFT JOIN clients cl ON c.client_id = cl.id
WHERE cl.id IS NULL;

-- =====================================================
-- MENSAGEM FINAL
-- =====================================================
SELECT 
    '🎉 TESTES CONCLUÍDOS!' as status,
    'Verifique os resultados acima para confirmar que tudo está funcionando.' as instrucoes,
    'Se houver erros, verifique se o script setup-commission-system.sql foi executado corretamente.' as dica;