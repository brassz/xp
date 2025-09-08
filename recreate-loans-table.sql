-- Script para recriar a tabela loans do zero (USE APENAS SE NECESSÁRIO)
-- ATENÇÃO: Isso apagará todos os empréstimos existentes!

-- 1. FAZER BACKUP DOS DADOS (descomente se necessário)
/*
CREATE TABLE loans_backup AS 
SELECT * FROM loans;
*/

-- 2. REMOVER TABELA ATUAL
DROP TABLE IF EXISTS loans CASCADE;

-- 3. RECRIAR TABELA LIMPA
CREATE TABLE loans (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL DEFAULT 0,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    status TEXT DEFAULT 'active',
    total_amount DECIMAL(10,2) GENERATED ALWAYS AS (amount + (amount * interest_rate / 100)) STORED,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. CRIAR APENAS FOREIGN KEYS ESSENCIAIS
ALTER TABLE loans 
ADD CONSTRAINT fk_loans_client_id 
FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;

-- 5. CRIAR ÍNDICES BÁSICOS
CREATE INDEX idx_loans_client_id ON loans(client_id);
CREATE INDEX idx_loans_loan_date ON loans(loan_date);
CREATE INDEX idx_loans_due_date ON loans(due_date);
CREATE INDEX idx_loans_status ON loans(status);

-- 6. SEM RLS, SEM POLÍTICAS, SEM CONSTRAINTS COMPLEXAS
-- Tabela completamente simples

-- 7. TESTAR INSERÇÃO
INSERT INTO loans (client_id, amount, interest_rate, loan_date, due_date, created_by)
SELECT 
    (SELECT id FROM clients LIMIT 1),
    999.99,
    2.5,
    '2025-08-07',
    '2025-09-07',
    (SELECT id FROM users LIMIT 1)
WHERE EXISTS (SELECT 1 FROM clients) 
  AND EXISTS (SELECT 1 FROM users);

-- 8. VERIFICAR SE FUNCIONOU
SELECT 'TESTE CONCLUÍDO:' as info, COUNT(*) as emprestimos_teste
FROM loans 
WHERE amount = 999.99;

-- 9. RESTAURAR BACKUP SE NECESSÁRIO (descomente)
/*
INSERT INTO loans (id, client_id, amount, interest_rate, loan_date, due_date, status, created_by, created_at, updated_at)
SELECT id, client_id, amount, interest_rate, loan_date, due_date, status, created_by, created_at, updated_at
FROM loans_backup;

DROP TABLE loans_backup;
*/

SELECT 'Tabela loans recriada com sucesso!' as resultado;