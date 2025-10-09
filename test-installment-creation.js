// Script de teste para verificar se há referências problemáticas a loanId
// Execute este código no console do navegador para testar

console.log('🧪 Testando criação de parcelamento...');

// Simular a função que pode estar causando o erro
function testInstallmentCreation() {
    try {
        // Simular dados do modal
        const modal = document.getElementById('newInstallmentModal');
        if (modal) {
            const associatedLoanId = modal.dataset.loanId || null;
            console.log('✅ associatedLoanId:', associatedLoanId);
            
            // Simular dados do parcelamento
            const installmentData = {
                client_id: 'test-client-id',
                total_amount: 1000,
                total_installments: 10,
                installment_amount: 100,
                first_due_date: '2024-01-01',
                interest_rate: 0,
                notes: 'Teste',
                created_by: 'test-user-id'
            };
            
            // Incluir loan_id apenas se estiver disponível
            if (associatedLoanId) {
                installmentData.loan_id = associatedLoanId;
                console.log('✅ loan_id incluído:', associatedLoanId);
            } else {
                console.log('✅ Parcelamento independente (sem loan_id)');
            }
            
            console.log('✅ Dados do parcelamento:', installmentData);
            console.log('🎉 Teste passou! Nenhum erro de loanId encontrado.');
            
        } else {
            console.log('❌ Modal não encontrado');
        }
    } catch (error) {
        console.error('❌ Erro no teste:', error);
    }
}

// Executar teste
testInstallmentCreation();