-- =============================================================================
-- SOLUÇÃO 3: PREVENIR FUTUROS SUMIÇOS DE EMPRÉSTIMOS
-- =============================================================================
-- Este script cria mecanismos de auditoria e backup automático
-- para prevenir perda de dados no futuro
-- =============================================================================

-- =============================================================================
-- PARTE 1: CRIAR TABELA DE AUDITORIA
-- =============================================================================

CREATE TABLE IF NOT EXISTS loans_audit (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    loan_id UUID NOT NULL,
    operation TEXT NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE', 'RESTORE')),
    old_status TEXT,
    new_status TEXT,
    old_data JSONB,
    new_data JSONB,
    changed_by UUID,
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address TEXT,
    user_agent TEXT,
    notes TEXT
);

-- Índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_loans_audit_loan_id ON loans_audit(loan_id);
CREATE INDEX IF NOT EXISTS idx_loans_audit_operation ON loans_audit(operation);
CREATE INDEX IF NOT EXISTS idx_loans_audit_changed_at ON loans_audit(changed_at);

COMMENT ON TABLE loans_audit IS 'Tabela de auditoria para rastrear todas as mudanças em empréstimos';

-- =============================================================================
-- PARTE 2: CRIAR FUNÇÃO DE AUDITORIA
-- =============================================================================

CREATE OR REPLACE FUNCTION audit_loans_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO loans_audit (
            loan_id, 
            operation, 
            old_status,
            old_data,
            changed_by,
            notes
        ) VALUES (
            OLD.id,
            'DELETE',
            OLD.status,
            row_to_json(OLD)::jsonb,
            OLD.created_by,
            'Empréstimo foi deletado da tabela loans'
        );
        RETURN OLD;
        
    ELSIF TG_OP = 'UPDATE' THEN
        -- Registrar apenas se houver mudança significativa
        IF OLD.status IS DISTINCT FROM NEW.status 
           OR OLD.amount IS DISTINCT FROM NEW.amount
           OR OLD.due_date IS DISTINCT FROM NEW.due_date THEN
            
            INSERT INTO loans_audit (
                loan_id,
                operation,
                old_status,
                new_status,
                old_data,
                new_data,
                changed_by,
                notes
            ) VALUES (
                NEW.id,
                'UPDATE',
                OLD.status,
                NEW.status,
                row_to_json(OLD)::jsonb,
                row_to_json(NEW)::jsonb,
                COALESCE(NEW.created_by, OLD.created_by),
                CASE 
                    WHEN OLD.status != NEW.status THEN 'Status alterado de ' || OLD.status || ' para ' || NEW.status
                    ELSE 'Dados do empréstimo atualizados'
                END
            );
        END IF;
        RETURN NEW;
        
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO loans_audit (
            loan_id,
            operation,
            new_status,
            new_data,
            changed_by,
            notes
        ) VALUES (
            NEW.id,
            'INSERT',
            NEW.status,
            row_to_json(NEW)::jsonb,
            NEW.created_by,
            'Novo empréstimo criado'
        );
        RETURN NEW;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================================================
-- PARTE 3: ATIVAR TRIGGER DE AUDITORIA
-- =============================================================================

-- Remover trigger anterior se existir
DROP TRIGGER IF EXISTS loans_audit_trigger ON loans;

-- Criar novo trigger
CREATE TRIGGER loans_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON loans
FOR EACH ROW
EXECUTE FUNCTION audit_loans_changes();

COMMENT ON TRIGGER loans_audit_trigger ON loans IS 'Trigger para auditar todas as mudanças em empréstimos';

-- =============================================================================
-- PARTE 4: CRIAR TABELA DE BACKUP DIÁRIO
-- =============================================================================

CREATE TABLE IF NOT EXISTS loans_backup (
    backup_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    backup_date DATE DEFAULT CURRENT_DATE,
    loan_data JSONB NOT NULL,
    loan_id UUID NOT NULL,
    client_id UUID NOT NULL,
    status TEXT NOT NULL,
    amount DECIMAL(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_loans_backup_loan_id ON loans_backup(loan_id);
CREATE INDEX IF NOT EXISTS idx_loans_backup_date ON loans_backup(backup_date);

COMMENT ON TABLE loans_backup IS 'Backup diário de todos os empréstimos para recuperação de dados';

-- =============================================================================
-- PARTE 5: FUNÇÃO PARA CRIAR BACKUP MANUAL
-- =============================================================================

CREATE OR REPLACE FUNCTION create_loans_backup()
RETURNS TABLE(
    total_backed_up BIGINT,
    backup_date DATE
) AS $$
DECLARE
    backed_up_count BIGINT;
BEGIN
    -- Inserir snapshot de todos os empréstimos atuais
    INSERT INTO loans_backup (loan_id, client_id, status, amount, loan_data, backup_date)
    SELECT 
        id,
        client_id,
        status,
        amount,
        row_to_json(loans.*)::jsonb,
        CURRENT_DATE
    FROM loans;
    
    GET DIAGNOSTICS backed_up_count = ROW_COUNT;
    
    RETURN QUERY SELECT backed_up_count, CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION create_loans_backup() IS 'Cria um backup manual de todos os empréstimos';

-- =============================================================================
-- PARTE 6: VIEW PARA FACILITAR CONSULTAS DE AUDITORIA
-- =============================================================================

CREATE OR REPLACE VIEW loans_audit_summary AS
SELECT 
    DATE(changed_at) as data,
    operation as operacao,
    COUNT(*) as quantidade,
    COUNT(DISTINCT loan_id) as emprestimos_distintos
FROM loans_audit
GROUP BY DATE(changed_at), operation
ORDER BY DATE(changed_at) DESC, operation;

COMMENT ON VIEW loans_audit_summary IS 'Resumo diário de operações auditadas em empréstimos';

-- =============================================================================
-- PARTE 7: FUNÇÃO PARA RESTAURAR EMPRÉSTIMO DO BACKUP
-- =============================================================================

CREATE OR REPLACE FUNCTION restore_loan_from_backup(
    p_loan_id UUID,
    p_backup_date DATE DEFAULT CURRENT_DATE
)
RETURNS TABLE(
    success BOOLEAN,
    message TEXT
) AS $$
DECLARE
    v_loan_data JSONB;
    v_exists BOOLEAN;
BEGIN
    -- Verificar se o empréstimo já existe
    SELECT EXISTS(SELECT 1 FROM loans WHERE id = p_loan_id) INTO v_exists;
    
    IF v_exists THEN
        RETURN QUERY SELECT FALSE, 'Empréstimo já existe na tabela loans. Use UPDATE ao invés de restaurar.';
        RETURN;
    END IF;
    
    -- Buscar dados do backup
    SELECT loan_data INTO v_loan_data
    FROM loans_backup
    WHERE loan_id = p_loan_id
        AND backup_date = p_backup_date
    ORDER BY created_at DESC
    LIMIT 1;
    
    IF v_loan_data IS NULL THEN
        RETURN QUERY SELECT FALSE, 'Backup não encontrado para este empréstimo na data especificada.';
        RETURN;
    END IF;
    
    -- Restaurar empréstimo
    INSERT INTO loans (
        id, client_id, amount, interest_rate, loan_date, due_date, 
        status, total_amount, created_by, created_at, updated_at
    )
    SELECT 
        (v_loan_data->>'id')::UUID,
        (v_loan_data->>'client_id')::UUID,
        (v_loan_data->>'amount')::DECIMAL(10,2),
        (v_loan_data->>'interest_rate')::DECIMAL(5,2),
        (v_loan_data->>'loan_date')::DATE,
        (v_loan_data->>'due_date')::DATE,
        v_loan_data->>'status',
        (v_loan_data->>'total_amount')::DECIMAL(10,2),
        (v_loan_data->>'created_by')::UUID,
        (v_loan_data->>'created_at')::TIMESTAMP WITH TIME ZONE,
        NOW()
    ON CONFLICT (id) DO NOTHING;
    
    -- Registrar na auditoria
    INSERT INTO loans_audit (loan_id, operation, new_data, notes)
    VALUES (p_loan_id, 'RESTORE', v_loan_data, 'Restaurado do backup de ' || p_backup_date);
    
    RETURN QUERY SELECT TRUE, 'Empréstimo restaurado com sucesso do backup!';
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION restore_loan_from_backup IS 'Restaura um empréstimo específico do backup';

-- =============================================================================
-- PARTE 8: CRIAR BACKUP INICIAL
-- =============================================================================

-- Criar primeiro backup
SELECT * FROM create_loans_backup();

-- =============================================================================
-- PARTE 9: VERIFICAÇÕES FINAIS
-- =============================================================================

SELECT 
    '✅ Sistema de auditoria e backup instalado!' as status,
    '' as info;

SELECT 
    'Tabelas criadas:' as tipo,
    '' as info;

SELECT 'loans_audit' as tabela, COUNT(*) as registros FROM loans_audit
UNION ALL
SELECT 'loans_backup' as tabela, COUNT(*) as registros FROM loans_backup;

SELECT 
    '' as separador,
    'Triggers ativos:' as tipo;

SELECT 
    trigger_name as nome,
    'Ativo' as status
FROM information_schema.triggers
WHERE event_object_table = 'loans'
    AND trigger_name = 'loans_audit_trigger';

SELECT 
    '' as separador,
    'Funções disponíveis:' as tipo;

SELECT 
    '1. create_loans_backup() - Criar backup manual' as funcao
UNION ALL
SELECT 
    '2. restore_loan_from_backup(loan_id, backup_date) - Restaurar empréstimo' as funcao;

-- =============================================================================
-- INSTRUÇÕES DE USO
-- =============================================================================

SELECT 
    '' as separador,
    '📖 INSTRUÇÕES DE USO' as titulo,
    '' as info;

SELECT 
    'Para criar backup manual:' as titulo,
    'SELECT * FROM create_loans_backup();' as comando
UNION ALL
SELECT 
    'Para ver auditoria de um empréstimo:' as titulo,
    'SELECT * FROM loans_audit WHERE loan_id = ''SEU_LOAN_ID'' ORDER BY changed_at DESC;' as comando
UNION ALL
SELECT 
    'Para ver resumo diário:' as titulo,
    'SELECT * FROM loans_audit_summary;' as comando
UNION ALL
SELECT 
    'Para restaurar empréstimo:' as titulo,
    'SELECT * FROM restore_loan_from_backup(''LOAN_ID'', ''2025-12-01'');' as comando;

-- =============================================================================
-- RECOMENDAÇÃO FINAL
-- =============================================================================

SELECT 
    '' as separador,
    '⚠️ IMPORTANTE' as tipo,
    'Agora todos os empréstimos deletados/modificados serão registrados na auditoria.' as mensagem_1,
    'Crie backups diários executando: SELECT * FROM create_loans_backup();' as mensagem_2,
    'Considere automatizar o backup usando Supabase Edge Functions ou Cron Jobs.' as mensagem_3;
