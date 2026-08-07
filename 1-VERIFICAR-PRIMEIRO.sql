-- =====================================================
-- VERIFICAÇÃO RÁPIDA - EXECUTE ESTE PRIMEIRO
-- =====================================================
-- Este script verifica se a tabela paid_loans existe
-- =====================================================

-- Ver qual banco de dados você está
SELECT 
    '🔍 Banco de dados atual:' as info,
    current_database() as banco;

-- Verificar se a tabela existe
SELECT 
    '🔍 Tabela paid_loans:' as info,
    CASE 
        WHEN EXISTS (
            SELECT FROM information_schema.tables 
            WHERE table_name = 'paid_loans'
        )
        THEN '✅ EXISTE'
        ELSE '❌ NÃO EXISTE - PRECISA CRIAR!'
    END as status;

-- Se existir, ver quantas linhas tem
DO $$ 
DECLARE
    total INTEGER;
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'paid_loans') THEN
        SELECT COUNT(*) INTO total FROM paid_loans;
        RAISE NOTICE '✅ Tabela existe com % registro(s)', total;
    ELSE
        RAISE NOTICE '❌ TABELA NÃO EXISTE - Execute o script 2-CRIAR-TABELA.sql';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '❌ Erro ao acessar tabela: %', SQLERRM;
END $$;
