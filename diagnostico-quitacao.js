// =====================================================
// SCRIPT DE DIAGNÓSTICO: Quitação de Empréstimos
// =====================================================
// Cole este script no Console do navegador (F12)
// quando estiver logado na IMPERATRIZ CRED
// =====================================================

async function diagnosticarQuitacao() {
    console.log('🔍 INICIANDO DIAGNÓSTICO DE QUITAÇÃO...\n');
    
    // =====================================================
    // 1. VERIFICAR CONEXÃO COM SUPABASE
    // =====================================================
    console.log('1️⃣ Verificando conexão com Supabase...');
    if (!supabase) {
        console.error('❌ ERRO: Supabase não está inicializado!');
        return;
    }
    console.log('✅ Supabase está inicializado');
    
    // =====================================================
    // 2. VERIFICAR EMPRESA ATUAL
    // =====================================================
    console.log('\n2️⃣ Verificando empresa atual...');
    console.log('Empresa:', currentCompany);
    if (currentCompany !== 'imperatriz') {
        console.error('❌ ATENÇÃO: Você não está logado na IMPERATRIZ CRED!');
        console.error('   Empresa atual:', currentCompany);
        return;
    }
    console.log('✅ Logado na IMPERATRIZ CRED');
    
    // =====================================================
    // 3. VERIFICAR USUÁRIO AUTENTICADO
    // =====================================================
    console.log('\n3️⃣ Verificando autenticação...');
    console.log('Usuário atual:', currentUser);
    if (!currentUser || !currentUser.id) {
        console.error('❌ ERRO: Usuário não está autenticado!');
        return;
    }
    console.log('✅ Usuário autenticado:', currentUser.email || currentUser.full_name);
    console.log('   User ID:', currentUser.id);
    
    // =====================================================
    // 4. VERIFICAR SE TABELA paid_loans EXISTE
    // =====================================================
    console.log('\n4️⃣ Verificando tabela paid_loans...');
    try {
        const { data, error, count } = await supabase
            .from('paid_loans')
            .select('*', { count: 'exact', head: true });
        
        if (error) {
            console.error('❌ ERRO ao acessar tabela paid_loans:', error);
            console.error('   Código:', error.code);
            console.error('   Mensagem:', error.message);
            console.error('   Detalhes:', error.details);
            
            if (error.code === '42P01') {
                console.error('\n🔧 SOLUÇÃO: Tabela paid_loans não existe!');
                console.error('   Execute o script setup-paid-loans.sql no Supabase');
            }
            return;
        }
        
        console.log('✅ Tabela paid_loans existe');
        console.log('   Total de registros:', count);
    } catch (err) {
        console.error('❌ ERRO ao verificar tabela:', err);
        return;
    }
    
    // =====================================================
    // 5. TESTAR PERMISSÃO DE LEITURA
    // =====================================================
    console.log('\n5️⃣ Testando permissão de leitura (SELECT)...');
    try {
        const { data, error } = await supabase
            .from('paid_loans')
            .select('*')
            .limit(1);
        
        if (error) {
            console.error('❌ ERRO ao fazer SELECT:', error);
            console.error('   Código:', error.code);
            console.error('   Mensagem:', error.message);
            
            if (error.code === '42501') {
                console.error('\n🔧 SOLUÇÃO: Sem permissão de SELECT!');
                console.error('   Verifique as políticas RLS no Supabase');
            }
            return;
        }
        
        console.log('✅ Permissão de SELECT OK');
        console.log('   Dados:', data);
    } catch (err) {
        console.error('❌ ERRO:', err);
        return;
    }
    
    // =====================================================
    // 6. TESTAR PERMISSÃO DE INSERÇÃO
    // =====================================================
    console.log('\n6️⃣ Testando permissão de inserção (INSERT)...');
    
    // Criar um registro de teste
    const testData = {
        loan_id: '00000000-0000-0000-0000-000000000001', // UUID de teste
        client_id: '00000000-0000-0000-0000-000000000002', // UUID de teste
        original_amount: 999.99,
        interest_rate: 5.0,
        total_with_interest: 1049.99,
        loan_date: '2025-01-01',
        due_date: '2025-12-31',
        paid_date: new Date().toISOString().split('T')[0],
        total_paid: 1049.99,
        payment_method: 'Teste Diagnóstico',
        notes: 'REGISTRO DE TESTE - PODE DELETAR',
        created_by: currentUser.id
    };
    
    console.log('Tentando inserir registro de teste:', testData);
    
    try {
        const { data, error } = await supabase
            .from('paid_loans')
            .insert([testData])
            .select();
        
        if (error) {
            console.error('❌ ERRO ao fazer INSERT:', error);
            console.error('   Código:', error.code);
            console.error('   Mensagem:', error.message);
            console.error('   Detalhes:', error.details);
            
            if (error.code === '42501') {
                console.error('\n🔧 SOLUÇÃO: Sem permissão de INSERT!');
                console.error('   Verifique as políticas RLS no Supabase');
                console.error('   Execute: GRANT INSERT ON paid_loans TO authenticated;');
            } else if (error.code === '23503') {
                console.error('\n⚠️ AVISO: Erro de chave estrangeira (normal para teste)');
                console.error('   Mas isso significa que a PERMISSÃO DE INSERT está OK!');
                console.log('\n✅ Permissão de INSERT OK (erro de FK é esperado no teste)');
            } else if (error.code === '23505') {
                console.error('\n⚠️ AVISO: Registro duplicado (normal se teste foi executado antes)');
                console.log('\n✅ Permissão de INSERT OK (erro de duplicata é esperado)');
            }
            
            // Se for erro de FK ou duplicata, consideramos que a permissão está OK
            if (error.code === '23503' || error.code === '23505') {
                console.log('\n📊 Permissão de INSERT está funcionando!');
            } else {
                return;
            }
        } else {
            console.log('✅ Permissão de INSERT OK');
            console.log('   Registro inserido:', data);
            
            // Deletar o registro de teste
            console.log('\n🧹 Deletando registro de teste...');
            const { error: deleteError } = await supabase
                .from('paid_loans')
                .delete()
                .eq('notes', 'REGISTRO DE TESTE - PODE DELETAR');
            
            if (deleteError) {
                console.warn('⚠️ Não foi possível deletar registro de teste:', deleteError);
                console.warn('   Delete manualmente no Supabase se necessário');
            } else {
                console.log('✅ Registro de teste deletado');
            }
        }
    } catch (err) {
        console.error('❌ ERRO:', err);
        return;
    }
    
    // =====================================================
    // 7. VERIFICAR EMPRÉSTIMOS DISPONÍVEIS
    // =====================================================
    console.log('\n7️⃣ Verificando empréstimos disponíveis para quitar...');
    if (!loans || loans.length === 0) {
        console.warn('⚠️ AVISO: Nenhum empréstimo carregado na variável loans');
        console.warn('   Isso é normal se você acabou de fazer login');
    } else {
        const activeLoans = loans.filter(l => l.status !== 'paid');
        console.log('✅ Empréstimos ativos:', activeLoans.length);
        console.log('   Total de empréstimos:', loans.length);
        
        if (activeLoans.length > 0) {
            console.log('\n📋 Exemplo de empréstimo ativo:');
            const example = activeLoans[0];
            console.log('   ID:', example.id);
            console.log('   Cliente:', example.clients?.name || 'N/A');
            console.log('   Valor:', example.amount);
            console.log('   Status:', example.status);
        }
    }
    
    // =====================================================
    // 8. VERIFICAR FUNÇÃO markLoanAsPaid
    // =====================================================
    console.log('\n8️⃣ Verificando função markLoanAsPaid...');
    if (typeof markLoanAsPaid === 'function') {
        console.log('✅ Função markLoanAsPaid existe');
    } else {
        console.error('❌ ERRO: Função markLoanAsPaid não foi encontrada!');
        return;
    }
    
    // =====================================================
    // 9. VERIFICAR POLÍTICAS RLS
    // =====================================================
    console.log('\n9️⃣ Instruções para verificar políticas RLS:');
    console.log('Execute no SQL Editor do Supabase:');
    console.log(`
SELECT 
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'paid_loans';
    `);
    
    // =====================================================
    // 10. TESTE COMPLETO DE QUITAÇÃO (SIMULADO)
    // =====================================================
    console.log('\n🔟 Simulação de quitação (sem executar realmente)...');
    
    if (loans && loans.length > 0) {
        const testLoan = loans.find(l => l.status !== 'paid');
        
        if (testLoan) {
            console.log('📝 Empréstimo para teste:', testLoan.id);
            console.log('   Cliente:', testLoan.clients?.name || 'N/A');
            console.log('   Valor:', testLoan.amount);
            
            const totalWithInterest = parseFloat(testLoan.amount) + 
                (parseFloat(testLoan.amount) * parseFloat(testLoan.interest_rate) / 100);
            
            const testPaidLoan = {
                loan_id: testLoan.id,
                client_id: testLoan.client_id,
                original_amount: testLoan.amount,
                interest_rate: testLoan.interest_rate,
                total_with_interest: totalWithInterest,
                loan_date: testLoan.loan_date,
                due_date: testLoan.due_date,
                paid_date: new Date().toISOString().split('T')[0],
                total_paid: 0, // Seria calculado dos payments
                payment_method: 'Sistema',
                notes: 'Quitado pelo sistema',
                created_by: testLoan.created_by
            };
            
            console.log('\n📊 Dados que seriam inseridos:');
            console.log(testPaidLoan);
            
            console.log('\n⚠️ PARA TESTAR REALMENTE, execute:');
            console.log('markLoanAsPaid(\'' + testLoan.id + '\')');
        } else {
            console.warn('⚠️ Nenhum empréstimo ativo encontrado para teste');
        }
    }
    
    // =====================================================
    // RESUMO FINAL
    // =====================================================
    console.log('\n' + '='.repeat(50));
    console.log('📊 RESUMO DO DIAGNÓSTICO');
    console.log('='.repeat(50));
    console.log('✅ Supabase: OK');
    console.log('✅ Empresa: IMPERATRIZ CRED');
    console.log('✅ Usuário: Autenticado');
    console.log('✅ Tabela paid_loans: Existe');
    console.log('✅ Permissões: Verificadas');
    console.log('\n🔧 PRÓXIMO PASSO:');
    console.log('Tente marcar um empréstimo como quitado e observe o Console');
    console.log('Os logs devem aparecer com 🔄 e ✅ ou ❌');
    console.log('\n💡 Se ainda não salvar, capture TODO o erro do Console e envie');
}

// Executar diagnóstico
diagnosticarQuitacao().catch(err => {
    console.error('❌ ERRO FATAL no diagnóstico:', err);
});
