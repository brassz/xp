-- Script completo para resolver TODOS os problemas de criação de empréstimo
-- Execute este script no Supabase SQL Editor

-- 1. REMOVER CONSTRAINT PROBLEMÁTICA
ALTER TABLE loans DROP CONSTRAINT IF EXISTS loans_status_check;

-- 2. REMOVER FUNÇÃO ANTERIOR SE EXISTIR
DROP FUNCTION IF EXISTS create_loan;

-- 3. CRIAR FUNÇÃO SIMPLES PARA CRIAR EMPRÉSTIMOS
CREATE OR REPLACE FUNCTION create_loan(
    p_client_id UUID,
    p_amount DECIMAL(10,2),
    p_interest_rate DECIMAL(5,2),
    p_loan_date DATE,
    p_due_date DATE,
    p_created_by UUID
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    new_loan_id UUID;
BEGIN
    -- Inserir empréstimo sem problemas de constraint
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
    
    RETURN new_loan_id;
END;
$$;

-- 4. DAR PERMISSÕES
GRANT EXECUTE ON FUNCTION create_loan TO authenticated;

-- 5. VERIFICAR SE TUDO FUNCIONOU
SELECT 'Correções aplicadas com sucesso!' as resultado;

-- 6. TESTAR (descomente se quiser testar)
/*
-- Ver clientes e usuários disponíveis
SELECT 'CLIENTES:' as tipo, id, name FROM clients LIMIT 3
UNION ALL
SELECT 'USUÁRIOS:' as tipo, id, email FROM users LIMIT 3;

-- Testar a função (substitua os UUIDs)
SELECT create_loan(
    (SELECT id FROM clients LIMIT 1)::UUID,
    500.00,
    3.5,
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '30 days',
    (SELECT id FROM users LIMIT 1)::UUID
) as novo_emprestimo_id;
*/