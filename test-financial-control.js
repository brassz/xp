// ============================================
// SCRIPT DE TESTE - CONTROLE FINANCEIRO
// ============================================
// Cole este código no Console do navegador (F12)
// após fazer login na Franca Private
// ============================================

console.log('\n🔍 ===== DIAGNÓSTICO CONTROLE FINANCEIRO =====\n');

// Teste 1: Verificar empresa atual
console.log('📊 TESTE 1: Empresa Atual');
console.log('- currentCompany:', currentCompany);
console.log('- É Franca Private?', currentCompany === 'brunoassoni');
if (currentCompany !== 'brunoassoni') {
    console.error('❌ ERRO: Você não está logado na Franca Private!');
    console.log('➡️ Solução: Faça logout, clique 3x em "Bruno Assoni" e faça login novamente');
} else {
    console.log('✅ OK: Logado na Franca Private');
}

console.log('\n');

// Teste 2: Verificar elemento no DOM
console.log('📊 TESTE 2: Elemento no DOM');
const tab = document.getElementById('financialControlTab');
console.log('- Tab encontrada:', tab !== null);
if (!tab) {
    console.error('❌ ERRO: Elemento #financialControlTab não encontrado!');
    console.log('➡️ Solução: Verifique se index.html foi atualizado e recarregue (Ctrl+F5)');
} else {
    console.log('✅ OK: Elemento encontrado no DOM');
    console.log('- Display atual:', tab.style.display);
    console.log('- Classes:', tab.className);
}

console.log('\n');

// Teste 3: Verificar seção de conteúdo
console.log('📊 TESTE 3: Seção de Conteúdo');
const section = document.getElementById('financialControl');
console.log('- Seção encontrada:', section !== null);
if (!section) {
    console.error('❌ ERRO: Seção #financialControl não encontrada!');
    console.log('➡️ Solução: Verifique se index.html foi atualizado completamente');
} else {
    console.log('✅ OK: Seção de conteúdo encontrada');
}

console.log('\n');

// Teste 4: Verificar função de inicialização
console.log('📊 TESTE 4: Função de Inicialização');
console.log('- initFinancialControl existe:', typeof initFinancialControl === 'function');
if (typeof initFinancialControl !== 'function') {
    console.error('❌ ERRO: Função initFinancialControl não encontrada!');
    console.log('➡️ Solução: Verifique se app.js foi atualizado e recarregue (Ctrl+F5)');
} else {
    console.log('✅ OK: Função existe');
}

console.log('\n');

// Teste 5: Verificar modais
console.log('📊 TESTE 5: Modais');
const modalEntry = document.getElementById('addCommissionEntryModal');
const modalExpense = document.getElementById('addExpenseModal');
console.log('- Modal de Entrada:', modalEntry !== null);
console.log('- Modal de Despesa:', modalExpense !== null);
if (!modalEntry || !modalExpense) {
    console.error('❌ ERRO: Modais não encontrados!');
    console.log('➡️ Solução: Verifique se index.html foi atualizado completamente');
} else {
    console.log('✅ OK: Modais encontrados');
}

console.log('\n');

// Teste 6: Verificar botões
console.log('📊 TESTE 6: Botões de Ação');
const btnEntry = document.getElementById('btnAddCommissionEntry');
const btnExpense = document.getElementById('btnAddExpense');
const btnReport = document.getElementById('btnGenerateFinancialReport');
console.log('- Botão Adicionar Comissão:', btnEntry !== null);
console.log('- Botão Adicionar Despesa:', btnExpense !== null);
console.log('- Botão Gerar Relatório:', btnReport !== null);

console.log('\n');

// Teste 7: Verificar cards do dashboard
console.log('📊 TESTE 7: Cards do Dashboard');
const cardBalance = document.getElementById('fcTotalBalance');
const cardEntries = document.getElementById('fcTotalEntries');
const cardExpenses = document.getElementById('fcTotalExpenses');
const cardReinvest = document.getElementById('fcReinvestment');
console.log('- Card Saldo:', cardBalance !== null);
console.log('- Card Entradas:', cardEntries !== null);
console.log('- Card Despesas:', cardExpenses !== null);
console.log('- Card Reinvestimento:', cardReinvest !== null);

console.log('\n');

// Resumo
console.log('📊 RESUMO DO DIAGNÓSTICO\n');

let errors = 0;
let warnings = 0;

if (currentCompany !== 'brunoassoni') {
    errors++;
    console.error('❌ Não está logado na Franca Private');
}

if (!tab) {
    errors++;
    console.error('❌ Aba não encontrada no DOM');
}

if (!section) {
    errors++;
    console.error('❌ Seção de conteúdo não encontrada');
}

if (typeof initFinancialControl !== 'function') {
    errors++;
    console.error('❌ Função de inicialização não encontrada');
}

if (!modalEntry || !modalExpense) {
    warnings++;
    console.warn('⚠️ Modais não encontrados');
}

if (!btnEntry || !btnExpense || !btnReport) {
    warnings++;
    console.warn('⚠️ Botões não encontrados');
}

console.log('\n');

if (errors === 0 && warnings === 0) {
    console.log('✅ ✅ ✅ TUDO OK! ✅ ✅ ✅');
    console.log('\n🔧 Tentando forçar exibição da aba...\n');
    
    if (currentCompany === 'brunoassoni' && tab) {
        tab.style.display = 'flex';
        console.log('✅ Aba forçada a aparecer!');
        console.log('➡️ Verifique o menu lateral agora');
    }
} else {
    console.error(`\n❌ Encontrados ${errors} erro(s) e ${warnings} aviso(s)`);
    console.log('\n📝 AÇÕES RECOMENDADAS:');
    console.log('1. Limpe o cache do navegador (Ctrl+Shift+Delete)');
    console.log('2. Recarregue a página com Ctrl+F5');
    console.log('3. Faça logout e login novamente na Franca Private');
    console.log('4. Verifique se os arquivos foram atualizados no servidor');
}

console.log('\n============================================\n');

// Teste automático de correção
if (currentCompany === 'brunoassoni' && tab && tab.style.display !== 'flex') {
    console.log('🔧 Aplicando correção automática...');
    tab.style.display = 'flex';
    console.log('✅ Aba de Controle Financeiro ativada!');
    console.log('📍 Verifique o menu lateral');
}
