// Versão simplificada da função handleNewLoan
// Substitua a função atual por esta se o problema persistir

async function handleNewLoan(e) {
    e.preventDefault();
    
    // Validar campos obrigatórios
    const clientId = document.getElementById('loanClient').value;
    const amount = parseFloat(document.getElementById('loanAmount').value);
    const interestRate = parseFloat(document.getElementById('loanInterest').value);
    const loanDate = document.getElementById('loanDate').value;
    const dueDate = document.getElementById('loanDueDate').value;
    
    if (!clientId || !amount || !interestRate || !loanDate || !dueDate) {
        alert('Por favor, preencha todos os campos obrigatórios.');
        return;
    }
    
    if (!currentUser || !currentUser.id) {
        alert('Erro: Usuário não está logado.');
        return;
    }
    
    try {
        // Inserção mais simples possível - sem status
        const { data, error } = await supabase
            .from('loans')
            .insert([{
                client_id: clientId,
                amount: amount,
                interest_rate: interestRate,
                loan_date: loanDate,
                due_date: dueDate,
                created_by: currentUser.id
                // SEM campo status - deixar usar padrão do banco
            }])
            .select();
        
        if (error) throw error;
        
        hideModal(newLoanModal);
        newLoanForm.reset();
        await loadLoans();
        await updateDashboard();
        
        // Perguntar se deseja gerar contrato
        const generateContractNow = confirm('Empréstimo criado com sucesso! Deseja gerar o contrato agora?');
        if (generateContractNow && data && data[0]) {
            await generateContract(data[0].id);
        }
        
        // Mostrar modal do WhatsApp
        if (data && data[0]) {
            setTimeout(() => {
                showWhatsAppSummaryModal(data[0].id);
            }, 500);
        }
        
    } catch (error) {
        console.error('Erro:', error);
        alert('Erro ao criar empréstimo: ' + error.message + '\n\nExecute o script disable-status-constraint.sql no Supabase para resolver.');
    }
}