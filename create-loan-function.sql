-- Função SQL para criar empréstimos contornando problemas de constraint
-- Execute este script no Supabase SQL Editor

-- 1. Primeiro, vamos criar uma função que insere o empréstimo
CREATE OR REPLACE FUNCTION create_loan(
    p_client_id UUID,
    p_amount DECIMAL(10,2),
    p_interest_rate DECIMAL(5,2),
    p_loan_date DATE,
    p_due_date DATE,
    p_created_by UUID
)
RETURNS TABLE(
    id UUID,
    client_id UUID,
    amount DECIMAL(10,2),
    interest_rate DECIMAL(5,2),
    loan_date DATE,
    due_date DATE,
    status TEXT,
    total_amount DECIMAL(10,2),
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    new_loan_id UUID;
BEGIN
    -- Gerar novo ID
    new_loan_id := gen_random_uuid();
    
    -- Inserir o empréstimo diretamente, sem ON CONFLICT
    INSERT INTO loans (
        client_id, 
        amount, 
        interest_rate, 
        loan_date, 
        due_date, 
        status, 
        created_by
    )
    VALUES (
        p_client_id,
        p_amount,
        p_interest_rate,
        p_loan_date,
        p_due_date,
        'active',
        p_created_by
    )
    RETURNING id INTO new_loan_id;
    
    -- Retornar o registro criado
    RETURN QUERY
    SELECT 
        l.id,
        l.client_id,
        l.amount,
        l.interest_rate,
        l.loan_date,
        l.due_date,
        l.status,
        l.total_amount,
        l.created_by,
        l.created_at,
        l.updated_at
    FROM loans l
    WHERE l.id = new_loan_id;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Em caso de erro, tentar sem status (deixar usar padrão)        
        INSERT INTO loans (
            client_id, 
            amount, 
            interest_rate, 
            loan_date, 
            due_date, 
            created_by
        )
        VALUES (
            p_client_id,
            p_amount,
            p_interest_rate,
            p_loan_date,
            p_due_date,
            p_created_by
        )
        RETURNING id INTO new_loan_id;
        
        -- Retornar o registro criado
        RETURN QUERY
        SELECT 
            l.id,
            l.client_id,
            l.amount,
            l.interest_rate,
            l.loan_date,
            l.due_date,
            l.status,
            l.total_amount,
            l.created_by,
            l.created_at,
            l.updated_at
        FROM loans l
        WHERE l.id = new_loan_id;
END;
$$;

-- 2. Dar permissões para usar a função
GRANT EXECUTE ON FUNCTION create_loan TO authenticated;

-- 3. Teste da função (descomente para testar)
/*
-- Verificar clientes e usuários disponíveis
SELECT 'Clientes:' as tipo, id, name as nome FROM clients LIMIT 3
UNION ALL
SELECT 'Usuários:' as tipo, id, email as nome FROM users LIMIT 3;

-- Testar a função (substitua os UUIDs pelos valores reais)
SELECT * FROM create_loan(
    (SELECT id FROM clients LIMIT 1)::UUID,  -- client_id
    1000.00,                                  -- amount
    5.0,                                      -- interest_rate
    CURRENT_DATE,                            -- loan_date
    CURRENT_DATE + INTERVAL '30 days',       -- due_date
    (SELECT id FROM users LIMIT 1)::UUID     -- created_by
);
*/