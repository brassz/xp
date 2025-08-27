-- Script completo para corrigir todos os relacionamentos das tabelas de status de empréstimos
-- Este script resolve erros como: "Could not find a relationship between 'table' and 'clients' in the schema cache"

-- Verificar se todas as tabelas principais existem
DO $$
BEGIN
    -- Verificar tabelas principais
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'clients') THEN
        RAISE EXCEPTION 'Tabela clients não encontrada. Execute primeiro o database-setup.sql';
    END IF;
    
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'loans') THEN
        RAISE EXCEPTION 'Tabela loans não encontrada. Execute primeiro o database-setup.sql';
    END IF;
    
    RAISE NOTICE 'Tabelas principais encontradas. Verificando tabelas de status...';
END $$;

-- Função para remover constraint se existir
CREATE OR REPLACE FUNCTION drop_constraint_if_exists(table_name text, constraint_name text)
RETURNS void AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints 
               WHERE constraint_name = constraint_name 
               AND table_name = table_name) THEN
        EXECUTE 'ALTER TABLE ' || table_name || ' DROP CONSTRAINT ' || constraint_name;
        RAISE NOTICE 'Constraint % removida da tabela %', constraint_name, table_name;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- CORRIGIR RELACIONAMENTOS - PAID_LOANS
-- ========================================
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'paid_loans') THEN
        RAISE NOTICE 'Configurando relacionamentos para paid_loans...';
        
        -- Remover constraints existentes
        PERFORM drop_constraint_if_exists('paid_loans', 'fk_paid_loans_client_id');
        PERFORM drop_constraint_if_exists('paid_loans', 'fk_paid_loans_loan_id');
        PERFORM drop_constraint_if_exists('paid_loans', 'fk_paid_loans_created_by');
        
        -- Adicionar constraints
        ALTER TABLE paid_loans 
        ADD CONSTRAINT fk_paid_loans_client_id 
        FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;
        
        ALTER TABLE paid_loans 
        ADD CONSTRAINT fk_paid_loans_loan_id 
        FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;
        
        -- Foreign key para users (se existir)
        IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users') THEN
            ALTER TABLE paid_loans 
            ADD CONSTRAINT fk_paid_loans_created_by 
            FOREIGN KEY (created_by) REFERENCES users(id);
        END IF;
        
        RAISE NOTICE 'Relacionamentos de paid_loans configurados com sucesso';
    END IF;
END $$;

-- ========================================
-- CORRIGIR RELACIONAMENTOS - OVERDUE_LOANS
-- ========================================
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'overdue_loans') THEN
        RAISE NOTICE 'Configurando relacionamentos para overdue_loans...';
        
        -- Remover constraints existentes
        PERFORM drop_constraint_if_exists('overdue_loans', 'fk_overdue_loans_client_id');
        PERFORM drop_constraint_if_exists('overdue_loans', 'fk_overdue_loans_loan_id');
        PERFORM drop_constraint_if_exists('overdue_loans', 'fk_overdue_loans_created_by');
        
        -- Adicionar constraints
        ALTER TABLE overdue_loans 
        ADD CONSTRAINT fk_overdue_loans_client_id 
        FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;
        
        ALTER TABLE overdue_loans 
        ADD CONSTRAINT fk_overdue_loans_loan_id 
        FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;
        
        -- Foreign key para users (se existir)
        IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users') THEN
            ALTER TABLE overdue_loans 
            ADD CONSTRAINT fk_overdue_loans_created_by 
            FOREIGN KEY (created_by) REFERENCES users(id);
        END IF;
        
        RAISE NOTICE 'Relacionamentos de overdue_loans configurados com sucesso';
    END IF;
END $$;

-- ========================================
-- CORRIGIR RELACIONAMENTOS - PARTIAL_PAID_LOANS
-- ========================================
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'partial_paid_loans') THEN
        RAISE NOTICE 'Configurando relacionamentos para partial_paid_loans...';
        
        -- Remover constraints existentes
        PERFORM drop_constraint_if_exists('partial_paid_loans', 'fk_partial_paid_loans_client_id');
        PERFORM drop_constraint_if_exists('partial_paid_loans', 'fk_partial_paid_loans_loan_id');
        PERFORM drop_constraint_if_exists('partial_paid_loans', 'fk_partial_paid_loans_created_by');
        
        -- Adicionar constraints
        ALTER TABLE partial_paid_loans 
        ADD CONSTRAINT fk_partial_paid_loans_client_id 
        FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;
        
        ALTER TABLE partial_paid_loans 
        ADD CONSTRAINT fk_partial_paid_loans_loan_id 
        FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;
        
        -- Foreign key para users (se existir)
        IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users') THEN
            ALTER TABLE partial_paid_loans 
            ADD CONSTRAINT fk_partial_paid_loans_created_by 
            FOREIGN KEY (created_by) REFERENCES users(id);
        END IF;
        
        RAISE NOTICE 'Relacionamentos de partial_paid_loans configurados com sucesso';
    END IF;
END $$;

-- ========================================
-- CORRIGIR RELACIONAMENTOS - CANCELLED_LOANS (PRINCIPAL)
-- ========================================
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'cancelled_loans') THEN
        RAISE NOTICE 'Configurando relacionamentos para cancelled_loans...';
        
        -- Remover constraints existentes
        PERFORM drop_constraint_if_exists('cancelled_loans', 'fk_cancelled_loans_client_id');
        PERFORM drop_constraint_if_exists('cancelled_loans', 'fk_cancelled_loans_loan_id');
        PERFORM drop_constraint_if_exists('cancelled_loans', 'fk_cancelled_loans_cancelled_by');
        PERFORM drop_constraint_if_exists('cancelled_loans', 'fk_cancelled_loans_created_by');
        
        -- Adicionar constraints (CRÍTICO para resolver o erro original)
        ALTER TABLE cancelled_loans 
        ADD CONSTRAINT fk_cancelled_loans_client_id 
        FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;
        
        ALTER TABLE cancelled_loans 
        ADD CONSTRAINT fk_cancelled_loans_loan_id 
        FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;
        
        -- Foreign keys para users (se existir)
        IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users') THEN
            ALTER TABLE cancelled_loans 
            ADD CONSTRAINT fk_cancelled_loans_cancelled_by 
            FOREIGN KEY (cancelled_by) REFERENCES users(id);
            
            ALTER TABLE cancelled_loans 
            ADD CONSTRAINT fk_cancelled_loans_created_by 
            FOREIGN KEY (created_by) REFERENCES users(id);
        END IF;
        
        RAISE NOTICE 'Relacionamentos de cancelled_loans configurados com sucesso';
    ELSE
        RAISE NOTICE 'Tabela cancelled_loans não encontrada';
    END IF;
END $$;

-- Limpar função temporária
DROP FUNCTION drop_constraint_if_exists(text, text);

-- Verificar todas as foreign keys criadas
SELECT 
    tc.table_name,
    tc.constraint_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name IN ('paid_loans', 'overdue_loans', 'partial_paid_loans', 'cancelled_loans')
ORDER BY tc.table_name, tc.constraint_name;

-- Mensagem final
SELECT 'SUCESSO: Todos os relacionamentos das tabelas de status foram configurados corretamente!' as status,
       'O erro "Could not find a relationship between ''cancelled_loans'' and ''clients''" deve estar resolvido.' as observacao;