// Script para identificar e corrigir o erro "loanId is not defined"
// Execute este código no console do navegador

console.log('🔍 Verificando possíveis problemas com loanId...');

// 1. Verificar se há event listeners problemáticos
try {
    // Simular criação de parcelamento
    const testForm = document.getElementById('newInstallmentForm');
    if (testForm) {
        console.log('✅ Formulário de parcelamento encontrado');
        
        // Verificar se o modal existe
        const modal = document.getElementById('newInstallmentModal');
        if (modal) {
            console.log('✅ Modal de parcelamento encontrado');
            
            // Testar se o dataset funciona
            modal.dataset.loanId = 'test-loan-id';
            const testLoanId = modal.dataset.loanId || null;
            console.log('✅ Dataset funcionando:', testLoanId);
            
            // Limpar teste
            delete modal.dataset.loanId;
            console.log('✅ Dataset limpo');
            
        } else {
            console.log('❌ Modal não encontrado');
        }
    } else {
        console.log('❌ Formulário não encontrado');
    }
    
    console.log('🎉 Teste concluído sem erros!');
    
} catch (error) {
    console.error('❌ Erro encontrado:', error);
    console.log('🔧 Possível solução: Recarregue a página e tente novamente');
}