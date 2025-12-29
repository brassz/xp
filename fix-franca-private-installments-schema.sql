-- =====================================================
-- CORREÇÃO DA TABELA INSTALLMENTS - FRANCA PRIVATE
-- =====================================================
-- Este script corrige o erro: "Could not find the 'first_due_date' 
-- column of 'installments' in the schema cache"
-- =====================================================

-- IMPORTANTE: Execute este script no SQL Editor do Supabase
-- da Franca Private (https://pebwoerzslfzhjptyjwh.supabase.co)

-- =====================================================
-- PASSO 1: Adicionar colunas faltantes
-- =====================================================

-- Adicionar coluna first_due_date (se não existir)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'installments' 
        AND column_name = 'first_due_date'
    ) THEN
        -- Se start_date existe, usar como base para first_due_date
        IF EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'installments' 
            AND column_name = 'start_date'
        ) THEN
            ALTER TABLE installments ADD COLUMN first_due_date DATE;
            -- Copiar dados de start_date para first_due_date
            UPDATE installments SET first_due_date = start_date WHERE first_due_date IS NULL;
            -- Tornar NOT NULL depois de copiar os dados
            ALTER TABLE installments ALTER COLUMN first_due_date SET NOT NULL;
        ELSE
            -- Se start_date não existe, criar com default
            ALTER TABLE installments ADD COLUMN first_due_date DATE NOT NULL DEFAULT CURRENT_DATE;
            -- Remover o default depois de criar
            ALTER TABLE installments ALTER COLUMN first_due_date DROP DEFAULT;
        END IF;
    END IF;
END $$;

-- Adicionar coluna loan_id (se não existir) - permite NULL para parcelamentos independentes
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'installments' 
        AND column_name = 'loan_id'
    ) THEN
        ALTER TABLE installments ADD COLUMN loan_id UUID REFERENCES loans(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Adicionar coluna total_installments (se não existir)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'installments' 
        AND column_name = 'total_installments'
    ) THEN
        -- Se installment_count existe, usar como base
        IF EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'installments' 
            AND column_name = 'installment_count'
        ) THEN
            ALTER TABLE installments ADD COLUMN total_installments INTEGER;
            -- Copiar dados de installment_count
            UPDATE installments SET total_installments = installment_count WHERE total_installments IS NULL;
            -- Adicionar constraint
            ALTER TABLE installments ALTER COLUMN total_installments SET NOT NULL;
            ALTER TABLE installments ADD CONSTRAINT check_total_installments CHECK (total_installments > 0);
        ELSE
            ALTER TABLE installments ADD COLUMN total_installments INTEGER NOT NULL CHECK (total_installments > 0);
        END IF;
    END IF;
END $$;

-- Adicionar coluna installment_amount (se não existir)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'installments' 
        AND column_name = 'installment_amount'
    ) THEN
        -- Se installment_value existe, usar como base
        IF EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'installments' 
            AND column_name = 'installment_value'
        ) THEN
            ALTER TABLE installments ADD COLUMN installment_amount DECIMAL(15,2);
            -- Copiar dados de installment_value
            UPDATE installments SET installment_amount = installment_value WHERE installment_amount IS NULL;
            -- Tornar NOT NULL
            ALTER TABLE installments ALTER COLUMN installment_amount SET NOT NULL;
        ELSE
            ALTER TABLE installments ADD COLUMN installment_amount DECIMAL(15,2) NOT NULL;
        END IF;
    END IF;
END $$;

-- =====================================================
-- PASSO 2: Atualizar comentários das colunas
-- =====================================================

COMMENT ON COLUMN installments.first_due_date IS 'Data de vencimento da primeira parcela';
COMMENT ON COLUMN installments.loan_id IS 'Referência ao empréstimo original (opcional - pode ser NULL para parcelamentos independentes)';
COMMENT ON COLUMN installments.total_installments IS 'Número total de parcelas';
COMMENT ON COLUMN installments.installment_amount IS 'Valor de cada parcela';

-- =====================================================
-- PASSO 3: Verificar tipos de dados das colunas existentes
-- =====================================================

-- Garantir que total_amount suporta valores maiores
DO $$ 
BEGIN
    -- Verificar se total_amount é DECIMAL(10,2) e converter para DECIMAL(15,2)
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'installments' 
        AND column_name = 'total_amount'
        AND numeric_precision = 10
    ) THEN
        ALTER TABLE installments ALTER COLUMN total_amount TYPE DECIMAL(15,2);
    END IF;
END $$;

-- =====================================================
-- PASSO 4: Criar índices para performance (se não existirem)
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_installments_loan_id ON installments(loan_id);
CREATE INDEX IF NOT EXISTS idx_installments_client_id ON installments(client_id);
CREATE INDEX IF NOT EXISTS idx_installments_status ON installments(status);
CREATE INDEX IF NOT EXISTS idx_installments_first_due_date ON installments(first_due_date);
CREATE INDEX IF NOT EXISTS idx_installments_created_at ON installments(created_at);

-- =====================================================
-- PASSO 5: Resetar o cache de schema do Supabase
-- =====================================================

-- Notificar o Supabase para atualizar o cache de schema
NOTIFY pgrst, 'reload schema';

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar se todas as colunas necessárias existem
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'installments'
AND column_name IN (
    'first_due_date',
    'loan_id', 
    'total_installments',
    'installment_amount',
    'total_amount',
    'client_id',
    'interest_rate',
    'status',
    'notes',
    'created_by',
    'created_at',
    'updated_at'
)
ORDER BY column_name;

-- =====================================================
-- RESULTADO ESPERADO
-- =====================================================
-- Você deverá ver todas as colunas listadas acima.
-- A coluna 'first_due_date' deve estar com is_nullable = 'NO'
-- A coluna 'loan_id' pode estar com is_nullable = 'YES'
-- =====================================================

-- =====================================================
-- INSTRUÇÕES APÓS EXECUTAR
-- =====================================================
-- 1. Execute este script no SQL Editor do Supabase
-- 2. Verifique se não há erros
-- 3. Na aplicação, faça logout e login novamente
-- 4. Tente criar um novo parcelamento
-- 5. O erro deve estar corrigido!
-- =====================================================
