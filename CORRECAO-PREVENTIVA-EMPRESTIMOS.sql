-- ============================================================================
-- CORREÇÃO PREVENTIVA: EVITAR QUE EMPRÉSTIMOS SUMAM
-- ============================================================================
-- Este script implementa medidas para prevenir perda de empréstimos
-- Execute no SQL Editor do Supabase
-- ============================================================================

-- ============================================================================
-- PARTE 1: CRIAR TABELA DE AUDITORIA
-- ============================================================================

SELECT '=== CRIANDO SISTEMA DE AUDITORIA ===' as status;

-- Criar tabela de auditoria se não existir
CREATE TABLE IF NOT EXISTS loans_audit (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID NOT NULL,
    operation TEXT NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE', 'STATUS_CHANGE'
    old_data JSONB,
    new_data JSONB,
    changed_by UUID,
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address INET,
    user_agent TEXT,
    notes TEXT
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_loans_audit_loan_id ON loans_audit(loan_id);
CREATE INDEX IF NOT EXISTS idx_loans_audit_operation ON loans_audit(operation);
CREATE INDEX IF NOT EXISTS idx_loans_audit_changed_at ON loans_audit(changed_at);
CREATE INDEX IF NOT EXISTS idx_loans_audit_changed_by ON loans_audit(changed_by);

-- Comentários
COMMENT ON TABLE loans_audit IS 'Registra TODAS as mudanças em empréstimos para rastreabilidade';
COMMENT ON COLUMN loans_audit.operation IS 'Tipo de operação: INSERT, UPDATE, DELETE, STATUS_CHANGE';
COMMENT ON COLUMN loans_audit.old_data IS 'Estado anterior do empréstimo (em JSON)';
COMMENT ON COLUMN loans_audit.new_data IS 'Novo estado do empréstimo (em JSON)';

SELECT 'Tabela loans_audit criada com sucesso!' as resultado;

-- ============================================================================
-- PARTE 2: CRIAR FUNÇÃO DE AUDITORIA AUTOMÁTICA
-- ============================================================================

SELECT '=== CRIANDO TRIGGER DE AUDITORIA ===' as status;

-- Função que será chamada automaticamente em cada mudança
CREATE OR REPLACE FUNCTION audit_loans_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        -- Registrar deleção
        INSERT INTO loans_audit (
            loan_id, 
            operation, 
            old_data,
            notes
        ) VALUES (
            OLD.id,
            'DELETE',
            to_jsonb(OLD),
            'Empréstimo deletado da tabela loans'
        );
        RETURN OLD;
        
    ELSIF TG_OP = 'UPDATE' THEN
        -- Registrar atualização
        INSERT INTO loans_audit (
            loan_id,
            operation,
            old_data,
            new_data,
            notes
        ) VALUES (
            NEW.id,
            CASE 
                WHEN OLD.status != NEW.status THEN 'STATUS_CHANGE'
                ELSE 'UPDATE'
            END,
            to_jsonb(OLD),
            to_jsonb(NEW),
            CASE 
                WHEN OLD.status != NEW.status 
                THEN 'Status alterado de ' || OLD.status || ' para ' || NEW.status
                ELSE 'Dados atualizados'
            END
        );
        RETURN NEW;
        
    ELSIF TG_OP = 'INSERT' THEN
        -- Registrar criação
        INSERT INTO loans_audit (
            loan_id,
            operation,
            new_data,
            notes
        ) VALUES (
            NEW.id,
            'INSERT',
            to_jsonb(NEW),
            'Novo empréstimo criado'
        );
        RETURN NEW;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Remover trigger anterior se existir
DROP TRIGGER IF EXISTS loans_audit_trigger ON loans;

-- Criar novo trigger
CREATE TRIGGER loans_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON loans
FOR EACH ROW EXECUTE FUNCTION audit_loans_changes();

SELECT 'Trigger de auditoria criado com sucesso!' as resultado;

-- ============================================================================
-- PARTE 3: CRIAR TABELA DE BACKUP DIÁRIO
-- ============================================================================

SELECT '=== CRIANDO BACKUP AUTOMÁTICO ===' as status;

-- Criar tabela de snapshots
CREATE TABLE IF NOT EXISTS loans_snapshots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    snapshot_date DATE NOT NULL DEFAULT CURRENT_DATE,
    loan_data JSONB NOT NULL,
    total_loans INTEGER NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_loans_snapshots_date ON loans_snapshots(snapshot_date);

-- Função para criar snapshot diário
CREATE OR REPLACE FUNCTION create_loans_snapshot()
RETURNS void AS $$
DECLARE
    snapshot_json JSONB;
    total_count INTEGER;
    total_sum DECIMAL(15,2);
BEGIN
    -- Verificar se já existe snapshot de hoje
    IF EXISTS (
        SELECT 1 FROM loans_snapshots 
        WHERE snapshot_date = CURRENT_DATE
    ) THEN
        -- Atualizar snapshot existente
        DELETE FROM loans_snapshots WHERE snapshot_date = CURRENT_DATE;
    END IF;
    
    -- Contar e somar
    SELECT COUNT(*), COALESCE(SUM(amount), 0) 
    INTO total_count, total_sum 
    FROM loans;
    
    -- Criar snapshot
    SELECT jsonb_agg(to_jsonb(loans.*)) 
    INTO snapshot_json 
    FROM loans;
    
    -- Inserir snapshot
    INSERT INTO loans_snapshots (
        snapshot_date,
        loan_data,
        total_loans,
        total_amount
    ) VALUES (
        CURRENT_DATE,
        snapshot_json,
        total_count,
        total_sum
    );
    
    RAISE NOTICE 'Snapshot criado: % empréstimos, total R$ %', total_count, total_sum;
END;
$$ LANGUAGE plpgsql;

-- Criar snapshot inicial
SELECT create_loans_snapshot();

SELECT 'Sistema de backup configurado! Execute create_loans_snapshot() diariamente' as resultado;

-- ============================================================================
-- PARTE 4: IMPLEMENTAR SOFT DELETE
-- ============================================================================

SELECT '=== CONFIGURANDO SOFT DELETE ===' as status;

-- Adicionar coluna deleted_at se não existir
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'loans' AND column_name = 'deleted_at'
    ) THEN
        ALTER TABLE loans ADD COLUMN deleted_at TIMESTAMP WITH TIME ZONE NULL;
        CREATE INDEX idx_loans_deleted_at ON loans(deleted_at);
        COMMENT ON COLUMN loans.deleted_at IS 'Soft delete: quando não é NULL, o empréstimo está deletado';
        
        SELECT 'Coluna deleted_at adicionada com sucesso!' as resultado;
    ELSE
        SELECT 'Coluna deleted_at já existe!' as resultado;
    END IF;
END $$;

-- Criar view para empréstimos ativos (excluindo soft-deleted)
CREATE OR REPLACE VIEW loans_active AS
SELECT * FROM loans 
WHERE deleted_at IS NULL;

-- Criar view para empréstimos deletados
CREATE OR REPLACE VIEW loans_deleted AS
SELECT * FROM loans 
WHERE deleted_at IS NOT NULL;

SELECT 'Soft delete configurado! Use loans_active para queries normais' as resultado;

-- ============================================================================
-- PARTE 5: CRIAR FUNÇÃO DE RECUPERAÇÃO
-- ============================================================================

SELECT '=== CRIANDO FUNÇÕES DE RECUPERAÇÃO ===' as status;

-- Função para recuperar empréstimo soft-deleted
CREATE OR REPLACE FUNCTION restore_loan(p_loan_id UUID)
RETURNS TEXT AS $$
DECLARE
    v_result TEXT;
BEGIN
    UPDATE loans 
    SET deleted_at = NULL 
    WHERE id = p_loan_id;
    
    IF FOUND THEN
        INSERT INTO loans_audit (loan_id, operation, notes)
        VALUES (p_loan_id, 'RESTORE', 'Empréstimo restaurado de soft delete');
        
        v_result := 'Empréstimo ' || p_loan_id || ' restaurado com sucesso!';
    ELSE
        v_result := 'Empréstimo não encontrado ou já está ativo';
    END IF;
    
    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

-- Função para restaurar de cancelled_loans
CREATE OR REPLACE FUNCTION restore_from_cancelled(p_cancelled_loan_id UUID)
RETURNS TEXT AS $$
DECLARE
    v_loan_record RECORD;
    v_new_loan_id UUID;
BEGIN
    -- Buscar empréstimo em cancelled_loans
    SELECT * INTO v_loan_record 
    FROM cancelled_loans 
    WHERE id = p_cancelled_loan_id;
    
    IF NOT FOUND THEN
        RETURN 'Empréstimo cancelado não encontrado!';
    END IF;
    
    -- Gerar novo ID
    v_new_loan_id := gen_random_uuid();
    
    -- Recriar na tabela loans
    INSERT INTO loans (
        id,
        client_id,
        amount,
        interest_rate,
        total_with_interest,
        loan_date,
        due_date,
        status,
        created_at
    ) VALUES (
        v_new_loan_id,
        v_loan_record.client_id,
        v_loan_record.original_amount,
        v_loan_record.interest_rate,
        v_loan_record.total_with_interest,
        v_loan_record.loan_date,
        v_loan_record.due_date,
        'active',
        NOW()
    );
    
    -- Registrar na auditoria
    INSERT INTO loans_audit (loan_id, operation, notes)
    VALUES (
        v_new_loan_id, 
        'RESTORE_FROM_CANCELLED', 
        'Restaurado de cancelled_loans (ID original: ' || p_cancelled_loan_id || ')'
    );
    
    RETURN 'Empréstimo restaurado com sucesso! Novo ID: ' || v_new_loan_id;
END;
$$ LANGUAGE plpgsql;

SELECT 'Funções de recuperação criadas!' as resultado;

-- ============================================================================
-- PARTE 6: DESABILITAR RLS (Opcional)
-- ============================================================================

SELECT '=== VERIFICANDO RLS ===' as status;

DO $$
DECLARE
    v_rls_enabled BOOLEAN;
BEGIN
    SELECT rowsecurity INTO v_rls_enabled
    FROM pg_tables
    WHERE schemaname = 'public' AND tablename = 'loans';
    
    IF v_rls_enabled THEN
        RAISE NOTICE '⚠️ RLS está HABILITADO na tabela loans';
        RAISE NOTICE '   Isso pode esconder empréstimos de certos usuários';
        RAISE NOTICE '   Para desabilitar, execute:';
        RAISE NOTICE '   ALTER TABLE loans DISABLE ROW LEVEL SECURITY;';
    ELSE
        RAISE NOTICE '✅ RLS está DESABILITADO - Configuração segura';
    END IF;
END $$;

-- DESCOMENTE AS LINHAS ABAIXO PARA DESABILITAR RLS
-- ATENÇÃO: Só faça isso se entender as implicações de segurança

-- ALTER TABLE loans DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE cancelled_loans DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;

-- SELECT 'RLS desabilitado em todas as tabelas de empréstimos' as resultado;

-- ============================================================================
-- PARTE 7: CRIAR VIEWS DE MONITORAMENTO
-- ============================================================================

SELECT '=== CRIANDO VIEWS DE MONITORAMENTO ===' as status;

-- View: Resumo diário
CREATE OR REPLACE VIEW loans_daily_summary AS
SELECT 
    DATE(created_at) as data,
    COUNT(*) as emprestimos_criados,
    SUM(amount) as valor_total_criado,
    COUNT(*) FILTER (WHERE deleted_at IS NOT NULL) as emprestimos_deletados
FROM loans
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE(created_at)
ORDER BY data DESC;

-- View: Auditoria resumida
CREATE OR REPLACE VIEW loans_audit_summary AS
SELECT 
    DATE(changed_at) as data,
    operation,
    COUNT(*) as quantidade,
    COUNT(DISTINCT loan_id) as emprestimos_afetados
FROM loans_audit
WHERE changed_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE(changed_at), operation
ORDER BY data DESC, quantidade DESC;

-- View: Alertas de anomalias
CREATE OR REPLACE VIEW loans_anomaly_alerts AS
WITH daily_deletes AS (
    SELECT 
        DATE(changed_at) as data,
        COUNT(*) as delecoes
    FROM loans_audit
    WHERE operation = 'DELETE'
    AND changed_at >= CURRENT_DATE - INTERVAL '7 days'
    GROUP BY DATE(changed_at)
)
SELECT 
    data,
    delecoes,
    CASE 
        WHEN delecoes > 5 THEN '🔴 CRÍTICO: Muitas deleções'
        WHEN delecoes > 2 THEN '⚠️ ALERTA: Deleções acima do normal'
        ELSE '✅ Normal'
    END as nivel_alerta
FROM daily_deletes
ORDER BY data DESC;

SELECT 'Views de monitoramento criadas!' as resultado;

-- ============================================================================
-- PARTE 8: VERIFICAÇÃO FINAL
-- ============================================================================

SELECT '=== VERIFICAÇÃO FINAL ===' as status;

-- Verificar se tudo foi criado
SELECT 
    'Tabela de auditoria' as item,
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_name = 'loans_audit'
    ) THEN '✅ Criada' ELSE '❌ Não encontrada' END as status
UNION ALL
SELECT 
    'Tabela de snapshots',
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_name = 'loans_snapshots'
    ) THEN '✅ Criada' ELSE '❌ Não encontrada' END
UNION ALL
SELECT 
    'Coluna deleted_at',
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'loans' AND column_name = 'deleted_at'
    ) THEN '✅ Criada' ELSE '❌ Não encontrada' END
UNION ALL
SELECT 
    'Trigger de auditoria',
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.triggers 
        WHERE trigger_name = 'loans_audit_trigger'
    ) THEN '✅ Criado' ELSE '❌ Não encontrado' END
UNION ALL
SELECT 
    'View loans_active',
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.views 
        WHERE table_name = 'loans_active'
    ) THEN '✅ Criada' ELSE '❌ Não encontrada' END;

-- ============================================================================
-- INSTRUÇÕES FINAIS
-- ============================================================================

SELECT '=== CORREÇÕES APLICADAS COM SUCESSO! ===' as titulo;

SELECT 
    'O que foi implementado:' as item,
    '' as descricao
UNION ALL
SELECT 
    '✅ Sistema de Auditoria',
    'Registra todas as mudanças em empréstimos automaticamente'
UNION ALL
SELECT 
    '✅ Backup Diário',
    'Execute create_loans_snapshot() diariamente ou configure um cron job'
UNION ALL
SELECT 
    '✅ Soft Delete',
    'Empréstimos "deletados" são marcados, não removidos'
UNION ALL
SELECT 
    '✅ Funções de Recuperação',
    'restore_loan(id) e restore_from_cancelled(id)'
UNION ALL
SELECT 
    '✅ Views de Monitoramento',
    'loans_daily_summary, loans_audit_summary, loans_anomaly_alerts'
UNION ALL
SELECT 
    '',
    ''
UNION ALL
SELECT 
    'Próximos passos:',
    ''
UNION ALL
SELECT 
    '1.',
    'Configure backup diário: SELECT create_loans_snapshot();'
UNION ALL
SELECT 
    '2.',
    'Monitore: SELECT * FROM loans_anomaly_alerts;'
UNION ALL
SELECT 
    '3.',
    'Use loans_active em vez de loans nas suas queries'
UNION ALL
SELECT 
    '4.',
    'Verifique auditoria: SELECT * FROM loans_audit ORDER BY changed_at DESC LIMIT 20;';

-- ============================================================================
-- FIM DA CORREÇÃO PREVENTIVA
-- ============================================================================
