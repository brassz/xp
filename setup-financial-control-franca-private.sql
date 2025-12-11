-- ============================================================================
-- SETUP FINANCIAL CONTROL - FRANCA PRIVATE
-- ============================================================================
-- Este script cria a estrutura para o sistema de Controle Financeiro
-- que agrega comissões de todas as empresas e gerencia despesas
-- ============================================================================

-- Criar tabela de despesas do controle financeiro
CREATE TABLE IF NOT EXISTS financial_expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    description TEXT NOT NULL,
    category TEXT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    expense_date DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_financial_expenses_date ON financial_expenses(expense_date DESC);
CREATE INDEX IF NOT EXISTS idx_financial_expenses_category ON financial_expenses(category);
CREATE INDEX IF NOT EXISTS idx_financial_expenses_created ON financial_expenses(created_at DESC);

-- Adicionar comentários nas colunas
COMMENT ON TABLE financial_expenses IS 'Despesas registradas no controle financeiro consolidado';
COMMENT ON COLUMN financial_expenses.id IS 'Identificador único da despesa';
COMMENT ON COLUMN financial_expenses.description IS 'Descrição da despesa (ex: Água, Luz, etc)';
COMMENT ON COLUMN financial_expenses.category IS 'Categoria da despesa (agua, luz, internet, etc)';
COMMENT ON COLUMN financial_expenses.amount IS 'Valor da despesa em reais';
COMMENT ON COLUMN financial_expenses.expense_date IS 'Data em que a despesa foi realizada';
COMMENT ON COLUMN financial_expenses.notes IS 'Observações adicionais sobre a despesa';

-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_financial_expenses_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para atualizar updated_at
DROP TRIGGER IF EXISTS trigger_update_financial_expenses_updated_at ON financial_expenses;
CREATE TRIGGER trigger_update_financial_expenses_updated_at
    BEFORE UPDATE ON financial_expenses
    FOR EACH ROW
    EXECUTE FUNCTION update_financial_expenses_updated_at();

-- Habilitar Row Level Security (RLS)
ALTER TABLE financial_expenses ENABLE ROW LEVEL SECURITY;

-- Política de segurança: usuários autenticados podem fazer tudo
DROP POLICY IF EXISTS "Usuários autenticados podem gerenciar despesas financeiras" ON financial_expenses;
CREATE POLICY "Usuários autenticados podem gerenciar despesas financeiras"
    ON financial_expenses
    FOR ALL
    TO authenticated
    USING (true)
    WITH CHECK (true);

-- Inserir dados de exemplo (opcional - remover se não quiser dados de exemplo)
INSERT INTO financial_expenses (description, category, amount, expense_date, notes)
VALUES 
    ('Conta de Água - Janeiro', 'agua', 150.00, CURRENT_DATE - INTERVAL '5 days', 'Referente ao mês de Janeiro'),
    ('Energia Elétrica - Janeiro', 'luz', 350.00, CURRENT_DATE - INTERVAL '4 days', 'Referente ao mês de Janeiro'),
    ('Internet Fibra', 'internet', 120.00, CURRENT_DATE - INTERVAL '3 days', 'Plano de 500MB')
ON CONFLICT DO NOTHING;

-- Mensagem de sucesso
DO $$
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '====================================';
    RAISE NOTICE 'CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!';
    RAISE NOTICE '====================================';
    RAISE NOTICE '';
    RAISE NOTICE 'A tabela financial_expenses foi criada com:';
    RAISE NOTICE '   ✓ Estrutura completa';
    RAISE NOTICE '   ✓ Índices otimizados';
    RAISE NOTICE '   ✓ Triggers automáticos';
    RAISE NOTICE '   ✓ Row Level Security habilitado';
    RAISE NOTICE '   ✓ Dados de exemplo inseridos';
    RAISE NOTICE '';
    RAISE NOTICE 'Próximos passos:';
    RAISE NOTICE '   1. Faça login no sistema Franca Private';
    RAISE NOTICE '   2. Acesse a aba "Controle Financeiro"';
    RAISE NOTICE '   3. Clique em "Atualizar Caixa" para buscar comissões';
    RAISE NOTICE '   4. Registre despesas conforme necessário';
    RAISE NOTICE '';
    RAISE NOTICE 'Funcionalidades disponíveis:';
    RAISE NOTICE '   • Agregação automática de comissões de todas as empresas';
    RAISE NOTICE '   • Registro e gestão de despesas';
    RAISE NOTICE '   • Relatório financeiro com saldo e reinvestimento (15%)';
    RAISE NOTICE '';
END $$;
