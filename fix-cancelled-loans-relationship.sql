-- Script para corrigir o relacionamento entre cancelled_loans e clients
-- Este script resolve o erro: "Could not find a relationship between 'cancelled_loans' and 'clients' in the schema cache"

-- Verificar se as tabelas existem
DO $$
BEGIN
    -- Verificar se a tabela cancelled_loans existe
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'cancelled_loans') THEN
        RAISE EXCEPTION 'Tabela cancelled_loans não encontrada. Execute primeiro o setup-cancelled-loans.sql';
    END IF;
    
    -- Verificar se a tabela clients existe
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'clients') THEN
        RAISE EXCEPTION 'Tabela clients não encontrada. Execute primeiro o database-setup.sql';
    END IF;
    
    RAISE NOTICE 'Ambas as tabelas encontradas. Verificando foreign keys...';
END $$;

-- Remover constraints existentes se houver (para evitar conflitos)
DO $$
BEGIN
    -- Tentar remover constraint se existir
    IF EXISTS (SELECT constraint_name FROM information_schema.table_constraints 
               WHERE constraint_name = 'fk_cancelled_loans_client_id' 
               AND table_name = 'cancelled_loans') THEN
        ALTER TABLE cancelled_loans DROP CONSTRAINT fk_cancelled_loans_client_id;
        RAISE NOTICE 'Constraint fk_cancelled_loans_client_id removida';
    END IF;
    
    IF EXISTS (SELECT constraint_name FROM information_schema.table_constraints 
               WHERE constraint_name = 'fk_cancelled_loans_loan_id' 
               AND table_name = 'cancelled_loans') THEN
        ALTER TABLE cancelled_loans DROP CONSTRAINT fk_cancelled_loans_loan_id;
        RAISE NOTICE 'Constraint fk_cancelled_loans_loan_id removida';
    END IF;
    
    IF EXISTS (SELECT constraint_name FROM information_schema.table_constraints 
               WHERE constraint_name = 'fk_cancelled_loans_cancelled_by' 
               AND table_name = 'cancelled_loans') THEN
        ALTER TABLE cancelled_loans DROP CONSTRAINT fk_cancelled_loans_cancelled_by;
        RAISE NOTICE 'Constraint fk_cancelled_loans_cancelled_by removida';
    END IF;
    
    IF EXISTS (SELECT constraint_name FROM information_schema.table_constraints 
               WHERE constraint_name = 'fk_cancelled_loans_created_by' 
               AND table_name = 'cancelled_loans') THEN
        ALTER TABLE cancelled_loans DROP CONSTRAINT fk_cancelled_loans_created_by;
        RAISE NOTICE 'Constraint fk_cancelled_loans_created_by removida';
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Aviso: Não foi possível remover algumas constraints: %', SQLERRM;
END $$;

-- Adicionar as foreign keys necessárias
-- Esta é a constraint crítica que estava faltando para resolver o erro de relacionamento
ALTER TABLE cancelled_loans 
ADD CONSTRAINT fk_cancelled_loans_client_id 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;

-- Adicionar outras foreign keys para integridade referencial
ALTER TABLE cancelled_loans 
ADD CONSTRAINT fk_cancelled_loans_loan_id 
FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;

-- Foreign keys para usuários (se a tabela users existir)
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users') THEN
        ALTER TABLE cancelled_loans 
        ADD CONSTRAINT fk_cancelled_loans_cancelled_by 
        FOREIGN KEY (cancelled_by) REFERENCES users(id);
        
        ALTER TABLE cancelled_loans 
        ADD CONSTRAINT fk_cancelled_loans_created_by 
        FOREIGN KEY (created_by) REFERENCES users(id);
        
        RAISE NOTICE 'Foreign keys para users adicionadas';
    ELSE
        RAISE NOTICE 'Tabela users não encontrada, foreign keys para usuários não foram criadas';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Aviso: Erro ao criar foreign keys para users: %', SQLERRM;
END $$;

-- Verificar se as constraints foram criadas com sucesso
SELECT 
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name = 'cancelled_loans'
ORDER BY tc.constraint_name;

-- Mensagem de sucesso
SELECT 'Foreign keys para cancelled_loans criadas com sucesso! O erro de relacionamento deve estar resolvido.' as status;