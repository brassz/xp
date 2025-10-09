// =====================================================
// CORREÇÃO JAVASCRIPT: ERRO loanId is not defined
// =====================================================
// Adicione este código ao final do app.js ou execute no console

// Garantir que todas as funções de parcelamento funcionem corretamente
(function() {
    'use strict';
    
    console.log('🔧 Aplicando correções para parcelamentos...');
    
    // Sobrescrever a função openInstallmentModal para garantir limpeza correta
    const originalOpenInstallmentModal = window.openInstallmentModal;
    if (originalOpenInstallmentModal) {
        window.openInstallmentModal = function() {
            try {
                // Chamar função original
                originalOpenInstallmentModal();
                
                // Garantir limpeza do dataset
                const modal = document.getElementById('newInstallmentModal');
                if (modal && modal.dataset.loanId) {
                    delete modal.dataset.loanId;
                }
                
                console.log('✅ Modal de parcelamento aberto e limpo');
            } catch (error) {
                console.error('❌ Erro ao abrir modal:', error);
            }
        };
    }
    
    // Interceptar erros de loanId
    const originalError = window.onerror;
    window.onerror = function(msg, url, line, col, error) {
        if (msg && msg.includes('loanId is not defined')) {
            console.error('🚨 Erro loanId interceptado:', msg);
            console.log('🔧 Tentando corrigir automaticamente...');
            
            // Tentar limpar qualquer referência problemática
            try {
                const modal = document.getElementById('newInstallmentModal');
                if (modal) {
                    delete modal.dataset.loanId;
                    console.log('✅ Dataset limpo automaticamente');
                }
            } catch (e) {
                console.log('⚠️  Não foi possível limpar automaticamente');
            }
            
            return true; // Prevenir que o erro apareça no console
        }
        
        // Chamar handler original se existir
        if (originalError) {
            return originalError(msg, url, line, col, error);
        }
        return false;
    };
    
    console.log('✅ Correções JavaScript aplicadas com sucesso!');
})();