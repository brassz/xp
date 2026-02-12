-- =====================================================
-- FIX: PRESERVAR PAGAMENTOS QUANDO EMPRÉSTIMO É EXCLUÍDO
-- =====================================================
-- Problema: se existir algum fluxo/trigger que apaga registros de loans,
-- a FK de payments(loan_id) com ON DELETE CASCADE remove todos os pagamentos.
--
-- Solução:
-- 1) substituir a FK atual de payments.loan_id -> loans.id para ON DELETE RESTRICT
-- 2) adicionar trigger de proteção para bloquear delete de empréstimo com pagamentos
--
-- Execute este script no SQL Editor do Supabase.

DO $$
DECLARE
    fk_record RECORD;
BEGIN
    -- Remover qualquer FK de payments que referencie loans
    FOR fk_record IN
        SELECT con.conname AS constraint_name
        FROM pg_constraint con
        JOIN pg_class rel ON rel.oid = con.conrelid
        JOIN pg_namespace nsp ON nsp.oid = rel.relnamespace
        JOIN pg_class ref_rel ON ref_rel.oid = con.confrelid
        WHERE con.contype = 'f'
          AND nsp.nspname = 'public'
          AND rel.relname = 'payments'
          AND ref_rel.relname = 'loans'
    LOOP
        EXECUTE format('ALTER TABLE public.payments DROP CONSTRAINT IF EXISTS %I', fk_record.constraint_name);
        RAISE NOTICE 'Constraint removida: %', fk_record.constraint_name;
    END LOOP;

    -- Recriar FK com RESTRICT para impedir cascata em pagamentos
    ALTER TABLE public.payments
    ADD CONSTRAINT fk_payments_loan_id_preserve
    FOREIGN KEY (loan_id)
    REFERENCES public.loans(id)
    ON DELETE RESTRICT;

    RAISE NOTICE 'FK recriada com ON DELETE RESTRICT: fk_payments_loan_id_preserve';
END $$;


-- Trigger de proteção adicional para bloquear delete de empréstimo com pagamentos
CREATE OR REPLACE FUNCTION public.prevent_loan_delete_when_has_payments()
RETURNS trigger AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM public.payments p
        WHERE p.loan_id = OLD.id
    ) THEN
        RAISE EXCEPTION
            'Nao e permitido excluir o emprestimo % porque existem pagamentos vinculados. Preserve o historico.',
            OLD.id;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_prevent_loan_delete_when_has_payments ON public.loans;

CREATE TRIGGER trg_prevent_loan_delete_when_has_payments
BEFORE DELETE ON public.loans
FOR EACH ROW
EXECUTE FUNCTION public.prevent_loan_delete_when_has_payments();

-- Verificação rápida (opcional)
-- SELECT conname, pg_get_constraintdef(oid)
-- FROM pg_constraint
-- WHERE conname = 'fk_payments_loan_id_preserve';
