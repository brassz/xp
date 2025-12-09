// =====================================================
// TESTE DIRETO: Inserção em paid_loans
// =====================================================
// Cole no Console (F12) quando estiver logado
// =====================================================

console.log('🧪 TESTE DIRETO DE INSERÇÃO EM PAID_LOANS\n');

// Teste 1: Verificar se supabase existe
if (!supabase) {
    console.error('❌ ERRO CRÍTICO: supabase não existe!');
    console.error('   Recarregue a página com Ctrl + Shift + R');
    throw new Error('Supabase não inicializado');
}
console.log('✅ Supabase OK');

// Teste 2: Verificar empresa
console.log('Empresa atual:', currentCompany);
if (currentCompany !== 'imperatriz') {
    console.error('❌ VOCÊ NÃO ESTÁ NA IMPERATRIZ CRED!');
    console.error('   Faça logout e login na IMPERATRIZ CRED');
    throw new Error('Empresa errada');
}
console.log('✅ IMPERATRIZ CRED OK');

// Teste 3: Tentar inserir registro de teste
console.log('\n🔄 Tentando inserir registro de teste...\n');

supabase
    .from('paid_loans')
    .insert([{
        loan_id: crypto.randomUUID(),
        client_id: crypto.randomUUID(),
        original_amount: 1000.00,
        interest_rate: 10.00,
        total_with_interest: 1100.00,
        loan_date: '2025-01-01',
        due_date: '2025-12-31',
        paid_date: new Date().toISOString().split('T')[0],
        total_paid: 1100.00,
        payment_method: 'TESTE DIRETO',
        notes: 'TESTE - PODE DELETAR',
        created_by: currentUser?.id
    }])
    .select()
    .then(({ data, error }) => {
        if (error) {
            console.error('❌ ❌ ❌ ERRO AO INSERIR ❌ ❌ ❌\n');
            console.error('Código do erro:', error.code);
            console.error('Mensagem:', error.message);
            console.error('Detalhes:', error.details);
            console.error('Hint:', error.hint);
            console.error('\nObjeto completo do erro:');
            console.error(error);
            
            // Análise do erro
            console.log('\n🔍 ANÁLISE DO ERRO:\n');
            
            if (error.code === '42P01') {
                console.error('🔧 PROBLEMA: Tabela paid_loans NÃO EXISTE!');
                console.error('\n📋 SOLUÇÃO:');
                console.error('1. Acesse Supabase SQL Editor');
                console.error('2. Execute o script setup-paid-loans.sql');
                console.error('3. Ou execute este SQL:');
                console.log(`
CREATE TABLE paid_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID NOT NULL,
    client_id UUID NOT NULL,
    original_amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    total_with_interest DECIMAL(10,2) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    paid_date DATE NOT NULL,
    total_paid DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    notes TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all" ON paid_loans FOR ALL USING (true) WITH CHECK (true);

GRANT ALL ON paid_loans TO authenticated;
                `);
            } else if (error.code === '42501' || error.message.includes('row-level security')) {
                console.error('🔧 PROBLEMA: SEM PERMISSÃO (RLS bloqueando)!');
                console.error('\n📋 SOLUÇÃO:');
                console.error('Execute no SQL Editor:');
                console.log(`
-- Opção 1: Política permissiva (temporária para teste)
DROP POLICY IF EXISTS "allow_all" ON paid_loans;
CREATE POLICY "allow_all" ON paid_loans 
    FOR ALL 
    USING (true) 
    WITH CHECK (true);

-- Opção 2: Desabilitar RLS (NÃO RECOMENDADO EM PRODUÇÃO)
ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;

-- Conceder permissões
GRANT ALL ON paid_loans TO authenticated;
                `);
            } else if (error.code === '23503') {
                console.error('🔧 PROBLEMA: Chave estrangeira (Foreign Key)');
                console.error('   Os UUIDs de teste não existem nas tabelas relacionadas');
                console.error('   MAS A PERMISSÃO DE INSERT ESTÁ OK! ✅');
                console.log('\n✅ PERMISSÃO DE INSERT FUNCIONANDO!');
                console.log('   O erro é esperado por usar UUIDs fictícios');
            } else if (error.code === '23505') {
                console.error('🔧 PROBLEMA: Registro duplicado');
                console.error('   MAS A PERMISSÃO DE INSERT ESTÁ OK! ✅');
                console.log('\n✅ PERMISSÃO DE INSERT FUNCIONANDO!');
            } else {
                console.error('🔧 PROBLEMA: Erro desconhecido');
                console.error('   Código:', error.code);
                console.error('   Veja detalhes acima');
            }
            
        } else {
            console.log('✅ ✅ ✅ INSERÇÃO FUNCIONOU! ✅ ✅ ✅\n');
            console.log('Dados inseridos:', data);
            console.log('\n🎉 SUCESSO! A tabela e permissões estão OK!');
            console.log('\n🧹 Deletando registro de teste...');
            
            // Deletar registro de teste
            supabase
                .from('paid_loans')
                .delete()
                .eq('notes', 'TESTE - PODE DELETAR')
                .then(({ error: delError }) => {
                    if (delError) {
                        console.warn('⚠️ Erro ao deletar teste:', delError);
                        console.warn('   Delete manualmente se necessário');
                    } else {
                        console.log('✅ Registro de teste deletado');
                    }
                });
        }
    })
    .catch(err => {
        console.error('❌ ERRO FATAL:', err);
    });
