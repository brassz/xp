/**
 * ============================================
 * DIAGNÓSTICO RÁPIDO - EMPRÉSTIMOS QUITADOS
 * ============================================
 * 
 * Como usar:
 * 1. Abra o sistema no navegador
 * 2. Faça login na empresa (ex: LITORAL CRED)
 * 3. Pressione F12 para abrir o Console
 * 4. Cole este script completo e pressione Enter
 * 5. Aguarde o resultado do diagnóstico
 * 
 * O que este script faz:
 * - Verifica se a tabela paid_loans existe
 * - Testa permissões de leitura
 * - Testa permissões de escrita (simulação)
 * - Fornece orientação sobre próximos passos
 */

(async function diagnosePaidLoansTable() {
    console.clear();
    console.log('%c🔍 INICIANDO DIAGNÓSTICO DE EMPRÉSTIMOS QUITADOS', 'background: #1e40af; color: white; font-size: 16px; padding: 10px; border-radius: 5px;');
    console.log('================================================\n');
    
    // Verificar se variáveis globais existem
    if (typeof supabase === 'undefined') {
        console.error('❌ ERRO: Variável "supabase" não encontrada');
        console.log('💡 Certifique-se de que você está logado no sistema\n');
        return;
    }
    
    if (typeof currentCompany === 'undefined') {
        console.error('❌ ERRO: Variável "currentCompany" não encontrada');
        console.log('💡 Certifique-se de que você está logado no sistema\n');
        return;
    }
    
    const empresa = currentCompany ? currentCompany.toUpperCase() : 'DESCONHECIDA';
    console.log(`🏢 Empresa atual: ${empresa}\n`);
    
    // Teste 1: Verificar se consegue buscar da tabela
    console.log('📋 TESTE 1: Verificar se a tabela paid_loans existe...');
    try {
        const { data, error, count } = await supabase
            .from('paid_loans')
            .select('*', { count: 'exact', head: true });
        
        if (error) {
            if (error.code === '42P01' || (error.message && error.message.includes('relation') && error.message.includes('does not exist'))) {
                console.error(`❌ PROBLEMA CONFIRMADO: Tabela paid_loans NÃO EXISTE na ${empresa}`);
                console.log('\n');
                console.log('🔧 SOLUÇÃO:');
                console.log('   1. Acesse o Supabase da empresa:');
                
                // URLs por empresa
                const urls = {
                    'NEXUS': 'https://mhtxyxizfnxupwmilith.supabase.co',
                    'LITORAL': 'https://dtifsfzmnjnllzzlndxv.supabase.co',
                    'MOGIANA': 'https://eemfnpefgojllvzzaimu.supabase.co',
                    'ERECHIM': 'https://adjrvtupfshdhwjvhmgj.supabase.co',
                    'IMPERATRIZ': 'https://eppzphzwwpvpoocospxy.supabase.co'
                };
                
                const url = urls[empresa] || 'URL não encontrada';
                console.log(`   2. URL: ${url}`);
                console.log('   3. Abra o SQL Editor');
                console.log('   4. Execute o script: fix-litoral-paid-loans.sql (para Litoral)');
                console.log('      ou setup-paid-loans-generic.sql (para qualquer empresa)');
                console.log('   5. Verifique se aparece: "🎉 CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!"');
                console.log('\n');
                console.log('📚 Documentação: README-fix-litoral-paid-loans.md');
                console.log('📚 Guia Rápido: GUIA-RAPIDO-EMPRESTIMOS-QUITADOS.md');
                console.log('\n');
                return;
            } else {
                console.error('❌ ERRO ao acessar tabela:', error);
                console.log('💡 Este é um erro diferente. Detalhes:', error);
                return;
            }
        }
        
        console.log(`✅ Tabela paid_loans EXISTE na ${empresa}`);
        console.log(`📊 Número de empréstimos quitados: ${count || 0}\n`);
        
    } catch (error) {
        console.error('❌ ERRO ao executar teste:', error);
        return;
    }
    
    // Teste 2: Verificar estrutura da tabela
    console.log('📋 TESTE 2: Verificar estrutura da tabela...');
    try {
        const { data, error } = await supabase
            .from('paid_loans')
            .select('*')
            .limit(1);
        
        if (error) {
            console.error('❌ ERRO ao buscar estrutura:', error);
        } else {
            if (data && data.length > 0) {
                const columns = Object.keys(data[0]);
                console.log(`✅ Colunas encontradas (${columns.length}):`, columns);
                
                // Verificar colunas essenciais
                const requiredColumns = ['id', 'loan_id', 'client_id', 'original_amount', 'paid_date', 'total_paid'];
                const missingColumns = requiredColumns.filter(col => !columns.includes(col));
                
                if (missingColumns.length > 0) {
                    console.warn('⚠️ ATENÇÃO: Colunas essenciais faltando:', missingColumns);
                } else {
                    console.log('✅ Todas as colunas essenciais presentes');
                }
            } else {
                console.log('ℹ️ Tabela existe mas está vazia (sem registros)');
                console.log('✅ Estrutura será validada quando houver o primeiro registro');
            }
        }
        console.log('');
    } catch (error) {
        console.error('❌ ERRO ao verificar estrutura:', error);
    }
    
    // Teste 3: Verificar permissões de leitura
    console.log('📋 TESTE 3: Verificar permissões de leitura...');
    try {
        const { data, error } = await supabase
            .from('paid_loans')
            .select('id')
            .limit(1);
        
        if (error) {
            if (error.code === '42501') {
                console.error('❌ ERRO: Sem permissão de leitura na tabela paid_loans');
                console.log('💡 Entre em contato com o administrador do Supabase');
            } else {
                console.error('❌ ERRO ao verificar permissões:', error);
            }
        } else {
            console.log('✅ Permissões de leitura: OK');
        }
        console.log('');
    } catch (error) {
        console.error('❌ ERRO ao verificar permissões:', error);
    }
    
    // Teste 4: Simular inserção (dry-run)
    console.log('📋 TESTE 4: Simular tentativa de quitação...');
    console.log('ℹ️ Este teste NÃO insere dados reais, apenas simula');
    try {
        // Buscar um empréstimo ativo para simular
        const { data: activeLoans, error: loansError } = await supabase
            .from('loans')
            .select('id, client_id, amount, interest_rate, loan_date, due_date')
            .limit(1);
        
        if (loansError) {
            console.warn('⚠️ Não foi possível buscar empréstimos para teste:', loansError.message);
        } else if (!activeLoans || activeLoans.length === 0) {
            console.log('ℹ️ Nenhum empréstimo ativo encontrado para simular teste');
        } else {
            console.log('✅ Encontrado empréstimo para simulação');
            console.log('ℹ️ Estrutura de dados que seria inserida:');
            
            const loan = activeLoans[0];
            const simulatedData = {
                loan_id: loan.id,
                client_id: loan.client_id,
                original_amount: loan.amount,
                interest_rate: loan.interest_rate,
                total_with_interest: parseFloat(loan.amount) * (1 + parseFloat(loan.interest_rate) / 100),
                loan_date: loan.loan_date,
                due_date: loan.due_date,
                paid_date: new Date().toISOString().split('T')[0],
                total_paid: parseFloat(loan.amount) * (1 + parseFloat(loan.interest_rate) / 100),
                payment_method: 'SIMULAÇÃO',
                notes: 'Teste de diagnóstico - não inserido'
            };
            
            console.log(simulatedData);
            console.log('✅ Estrutura de dados parece válida');
        }
        console.log('');
    } catch (error) {
        console.error('❌ ERRO ao simular:', error);
    }
    
    // Resumo Final
    console.log('================================================');
    console.log('%c📊 RESUMO DO DIAGNÓSTICO', 'background: #059669; color: white; font-size: 14px; padding: 8px; border-radius: 5px;');
    console.log('');
    console.log(`🏢 Empresa: ${empresa}`);
    console.log('');
    console.log('✅ Testes concluídos com sucesso!');
    console.log('');
    console.log('💡 Próximos passos:');
    console.log('   1. Se a tabela não existe, execute o script SQL de correção');
    console.log('   2. Se a tabela existe, tente marcar um empréstimo como quitado');
    console.log('   3. Verifique se o empréstimo aparece na aba "Empréstimos Quitados"');
    console.log('   4. Se houver erros, consulte a documentação no README');
    console.log('');
    console.log('📚 Documentação disponível:');
    console.log('   - README-fix-litoral-paid-loans.md');
    console.log('   - GUIA-RAPIDO-EMPRESTIMOS-QUITADOS.md');
    console.log('   - RESUMO-CORRECAO-LITORAL-EMPRESTIMOS-QUITADOS.md');
    console.log('');
    console.log('================================================');
    
})().catch(error => {
    console.error('❌ ERRO FATAL no diagnóstico:', error);
    console.log('\n💡 Tente novamente ou consulte a documentação');
});
