-- =============================================================================
-- SOLUÇÃO 1: DESABILITAR RLS NA EMPRESA LITORAL
-- =============================================================================
-- Este script desabilita o Row Level Security nas tabelas principais
-- Use apenas se o diagnóstico identificar que o RLS está causando o problema
-- =============================================================================

-- ATENÇÃO: Execute apenas após confirmar que o RLS é a causa do problema!

-- Desabilitar RLS na tabela de empréstimos
ALTER TABLE loans DISABLE ROW LEVEL SECURITY;

-- Desabilitar RLS em tabelas relacionadas (opcional, mas recomendado)
ALTER TABLE clients DISABLE ROW LEVEL SECURITY;
ALTER TABLE payments DISABLE ROW LEVEL SECURITY;
ALTER TABLE cancelled_loans DISABLE ROW LEVEL SECURITY;
ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;
ALTER TABLE overdue_loans DISABLE ROW LEVEL SECURITY;
ALTER TABLE partial_paid_loans DISABLE ROW LEVEL SECURITY;

-- Verificar status atual do RLS
SELECT 
    tablename,
    CASE 
        WHEN rowsecurity THEN '❌ RLS HABILITADO'
        ELSE '✅ RLS DESABILITADO'
    END as status
FROM pg_tables
WHERE schemaname = 'public' 
    AND tablename IN ('loans', 'clients', 'payments', 'cancelled_loans', 'paid_loans', 'overdue_loans', 'partial_paid_loans')
ORDER BY tablename;

-- Mensagem final
SELECT 
    '✅ RLS desabilitado com sucesso!' as status,
    'Os empréstimos agora devem estar visíveis para todos os usuários.' as mensagem,
    'Recarregue a aplicação para ver as mudanças.' as proximos_passos;
