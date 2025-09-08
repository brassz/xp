-- Função SQL simples para criar empréstimos sem conflitos
-- Execute este script no Supabase SQL Editor

-- Remover função anterior se existir
DROP FUNCTION IF EXISTS create_loan;

-- Criar função simples
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
    -- Inserir empréstimo e obter ID
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
    
    -- Retornar apenas o ID
    RETURN new_loan_id;
END;
$$;

-- Dar permissões
GRANT EXECUTE ON FUNCTION create_loan TO authenticated;