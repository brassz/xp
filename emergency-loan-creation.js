// VERSÃO DE EMERGÊNCIA - Substituir a função handleNewLoan se necessário
// Esta versão usa uma abordagem completamente diferente

async function emergencyHandleNewLoan(e) {
    e.preventDefault();
    
    // Validar campos
    const clientId = document.getElementById('loanClient').value;
    const amount = parseFloat(document.getElementById('loanAmount').value);
    const interestRate = parseFloat(document.getElementById('loanInterest').value);
    const loanDate = document.getElementById('loanDate').value;
    const dueDate = document.getElementById('loanDueDate').value;
    
    if (!clientId || !amount || !loanDate || !dueDate || !currentUser?.id) {
        alert('Por favor, preencha todos os campos obrigatórios.');
        return;
    }
    
    try {
        console.log('EMERGÊNCIA: Tentando inserção com dados:', {
            client_id: clientId,
            amount: amount,
            interest_rate: interestRate || 0,
            loan_date: loanDate,
            due_date: dueDate,
            created_by: currentUser.id
        });
        
        // Abordagem 1: Usar upsert sem especificar constraint
        let result = await supabase
            .from('loans')
            .upsert({
                client_id: clientId,
                amount: amount,
                interest_rate: interestRate || 0,
                loan_date: loanDate,
                due_date: dueDate,
                created_by: currentUser.id,
                created_at: new Date().toISOString()
            }, {
                onConflict: 'id', // Usar ID como conflito
                ignoreDuplicates: false
            })
            .select();
        
        if (result.error) {
            console.log('Upsert falhou, tentando insert simples...');
            
            // Abordagem 2: Insert sem select
            result = await supabase
                .from('loans')
                .insert({
                    client_id: clientId,
                    amount: amount,
                    interest_rate: interestRate || 0,
                    loan_date: loanDate,
                    due_date: dueDate,
                    created_by: currentUser.id
                });
            
            if (!result.error) {
                // Buscar o registro criado
                const fetchResult = await supabase
                    .from('loans')
                    .select('*')
                    .eq('client_id', clientId)
                    .eq('amount', amount)
                    .eq('loan_date', loanDate)
                    .order('created_at', { ascending: false })
                    .limit(1);
                
                result.data = fetchResult.data;
            }
        }
        
        if (result.error) {
            throw result.error;
        }
        
        alert('Empréstimo criado com sucesso!');
        hideModal(newLoanModal);
        newLoanForm.reset();
        await loadLoans();
        await updateDashboard();
        
    } catch (error) {
        console.error('EMERGÊNCIA - Erro:', error);
        alert(`Erro: ${error.message}\n\nExecute o script disable-all-loans-security.sql no Supabase.`);
    }
}

// Para usar esta função de emergência, execute no console:
// handleNewLoan = emergencyHandleNewLoan;