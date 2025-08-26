-- Arquivo para configurar foreign keys e permissões
-- Execute este arquivo APÓS executar loan-status-tables.sql
-- e APÓS verificar que as tabelas principais existem

-- Verificar se as tabelas principais existem
DO $$
BEGIN
    -- Verificar se a tabela loans existe
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'loans') THEN
        RAISE EXCEPTION 'Tabela loans não encontrada. Execute primeiro o database-setup.sql';
    END IF;
    
    -- Verificar se a tabela clients existe
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'clients') THEN
        RAISE EXCEPTION 'Tabela clients não encontrada. Execute primeiro o database-setup.sql';
    END IF;
    
    -- Verificar se a tabela users existe
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users') THEN
        RAISE EXCEPTION 'Tabela users não encontrada. Execute primeiro o database-setup.sql';
    END IF;
    
    RAISE NOTICE 'Todas as tabelas principais encontradas. Configurando foreign keys...';
END $$;

-- Adicionar constraints de foreign key para paid_loans
ALTER TABLE paid_loans 
ADD CONSTRAINT fk_paid_loans_loan_id 
FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;

ALTER TABLE paid_loans 
ADD CONSTRAINT fk_paid_loans_client_id 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;

ALTER TABLE paid_loans 
ADD CONSTRAINT fk_paid_loans_created_by 
FOREIGN KEY (created_by) REFERENCES users(id);

-- Adicionar constraints de foreign key para overdue_loans
ALTER TABLE overdue_loans 
ADD CONSTRAINT fk_overdue_loans_loan_id 
FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;

ALTER TABLE overdue_loans 
ADD CONSTRAINT fk_overdue_loans_client_id 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;

ALTER TABLE overdue_loans 
ADD CONSTRAINT fk_overdue_loans_created_by 
FOREIGN KEY (created_by) REFERENCES users(id);

-- Adicionar constraints de foreign key para partial_paid_loans
ALTER TABLE partial_paid_loans 
ADD CONSTRAINT fk_partial_paid_loans_loan_id 
FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;

ALTER TABLE partial_paid_loans 
ADD CONSTRAINT fk_partial_paid_loans_client_id 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;

ALTER TABLE partial_paid_loans 
ADD CONSTRAINT fk_partial_paid_loans_created_by 
FOREIGN KEY (created_by) REFERENCES users(id);

-- Adicionar constraints de foreign key para cancelled_loans
ALTER TABLE cancelled_loans 
ADD CONSTRAINT fk_cancelled_loans_loan_id 
FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE;

ALTER TABLE cancelled_loans 
ADD CONSTRAINT fk_cancelled_loans_client_id 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;

ALTER TABLE cancelled_loans 
ADD CONSTRAINT fk_cancelled_loans_cancelled_by 
FOREIGN KEY (cancelled_by) REFERENCES users(id);

ALTER TABLE cancelled_loans 
ADD CONSTRAINT fk_cancelled_loans_created_by 
FOREIGN KEY (created_by) REFERENCES users(id);

-- Configurar permissões
-- Descomente e ajuste conforme necessário para seu sistema

-- Para usuários autenticados (Supabase)
GRANT SELECT, INSERT, UPDATE, DELETE ON paid_loans TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON overdue_loans TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON partial_paid_loans TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON cancelled_loans TO authenticated;

-- Para usuários anônimos (se necessário)
-- GRANT SELECT ON paid_loans TO anon;
-- GRANT SELECT ON overdue_loans TO anon;
-- GRANT SELECT ON partial_paid_loans TO anon;
-- GRANT SELECT ON cancelled_loans TO anon;

-- Para usuários de serviço (se necessário)
-- GRANT ALL ON paid_loans TO service_role;
-- GRANT ALL ON overdue_loans TO service_role;
-- GRANT ALL ON partial_paid_loans TO service_role;
-- GRANT ALL ON cancelled_loans TO service_role;

-- Verificar se as foreign keys foram criadas corretamente
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name IN ('paid_loans', 'overdue_loans', 'partial_paid_loans', 'cancelled_loans')
ORDER BY tc.table_name, kcu.column_name;

-- Verificar se os triggers foram criados
SELECT 
    trigger_name,
    event_manipulation,
    event_object_table,
    action_statement
FROM information_schema.triggers 
WHERE trigger_schema = 'public' 
    AND event_object_table IN ('loans')
ORDER BY trigger_name;

RAISE NOTICE 'Configuração de foreign keys e permissões concluída!'; 