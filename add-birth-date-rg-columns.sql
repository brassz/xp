-- =====================================================
-- SCRIPT PARA ADICIONAR COLUNAS birth_date E rg NA TABELA clients
-- =====================================================
-- Execute este script no SQL Editor do Supabase
-- =====================================================

-- Verificar se a tabela clients existe antes de proceder
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'clients'
    ) THEN
        RAISE EXCEPTION 'Tabela clients não encontrada. Execute primeiro o database-setup.sql';
    END IF;
    
    RAISE NOTICE 'Tabela clients encontrada. Procedendo com a adição das colunas...';
END $$;

-- =====================================================
-- ADICIONAR COLUNA birth_date (Data de Nascimento)
-- =====================================================

-- Verificar se a coluna birth_date já existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'clients' 
        AND column_name = 'birth_date'
    ) THEN
        -- Adicionar a coluna birth_date
        ALTER TABLE clients ADD COLUMN birth_date DATE;
        
        -- Adicionar comentário explicativo
        COMMENT ON COLUMN clients.birth_date IS 'Data de nascimento do cliente';
        
        RAISE NOTICE 'Coluna birth_date adicionada com sucesso à tabela clients';
    ELSE
        RAISE NOTICE 'Coluna birth_date já existe na tabela clients';
    END IF;
END $$;

-- =====================================================
-- ADICIONAR COLUNA rg (Registro Geral)
-- =====================================================

-- Verificar se a coluna rg já existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'clients' 
        AND column_name = 'rg'
    ) THEN
        -- Adicionar a coluna rg
        ALTER TABLE clients ADD COLUMN rg TEXT;
        
        -- Adicionar comentário explicativo
        COMMENT ON COLUMN clients.rg IS 'Número do RG (Registro Geral) do cliente';
        
        RAISE NOTICE 'Coluna rg adicionada com sucesso à tabela clients';
    ELSE
        RAISE NOTICE 'Coluna rg já existe na tabela clients';
    END IF;
END $$;

-- =====================================================
-- ATUALIZAR COLUNA updated_at (Trigger)
-- =====================================================

-- Criar função para atualizar updated_at automaticamente (se não existir)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Verificar se o trigger já existe antes de criar
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger 
        WHERE tgname = 'update_clients_updated_at'
    ) THEN
        -- Criar trigger para atualizar updated_at automaticamente
        CREATE TRIGGER update_clients_updated_at
            BEFORE UPDATE ON clients
            FOR EACH ROW
            EXECUTE FUNCTION update_updated_at_column();
            
        RAISE NOTICE 'Trigger para updated_at criado com sucesso';
    ELSE
        RAISE NOTICE 'Trigger para updated_at já existe';
    END IF;
END $$;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Mostrar a estrutura atual da tabela clients
SELECT 
    'clients' as tabela,
    column_name as coluna,
    data_type as tipo,
    is_nullable as permite_null,
    column_default as valor_padrao
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'clients'
ORDER BY ordinal_position;

-- Mostrar mensagem de sucesso
SELECT 
    'Script executado com sucesso!' as status,
    'As colunas birth_date e rg foram adicionadas à tabela clients' as descricao,
    NOW() as executado_em;