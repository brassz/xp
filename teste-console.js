// SCRIPT DE DIAGNÓSTICO - Cole no console do navegador (F12)
// Este script verifica o estado atual do sistema e identifica problemas

console.log('='.repeat(60));
console.log('DIAGNÓSTICO DO SISTEMA DE LOGIN');
console.log('='.repeat(60));

// 1. Verificar se o script foi carregado
console.log('\n1. VERIFICAÇÃO DE CARREGAMENTO');
console.log('   window.appJsLoaded:', window.appJsLoaded);

// 2. Verificar elementos DOM essenciais
console.log('\n2. ELEMENTOS DOM ESSENCIAIS');
const elementos = {
    loginPage: document.getElementById('loginPage'),
    dashboard: document.getElementById('dashboard'),
    loginForm: document.getElementById('loginForm'),
    logoutBtn: document.getElementById('logoutBtn'),
    loginEmail: document.getElementById('loginEmail'),
    loginPassword: document.getElementById('loginPassword'),
    companySelect: document.getElementById('companySelect')
};

for (const [nome, elemento] of Object.entries(elementos)) {
    const existe = !!elemento;
    const simbolo = existe ? '✓' : '✗';
    console.log(`   ${simbolo} ${nome}: ${existe}`);
}

// 3. Verificar estado visual dos elementos principais
console.log('\n3. ESTADO VISUAL');
if (elementos.loginPage) {
    const loginClasses = elementos.loginPage.className;
    const loginDisplay = window.getComputedStyle(elementos.loginPage).display;
    console.log(`   loginPage classes: "${loginClasses}"`);
    console.log(`   loginPage display: ${loginDisplay}`);
    console.log(`   loginPage está visível: ${loginDisplay !== 'none'}`);
}

if (elementos.dashboard) {
    const dashClasses = elementos.dashboard.className;
    const dashDisplay = window.getComputedStyle(elementos.dashboard).display;
    console.log(`   dashboard classes: "${dashClasses}"`);
    console.log(`   dashboard display: ${dashDisplay}`);
    console.log(`   dashboard está visível: ${dashDisplay !== 'none'}`);
}

// 4. Verificar variáveis globais
console.log('\n4. VARIÁVEIS GLOBAIS');
console.log('   currentUser:', typeof currentUser !== 'undefined' ? (currentUser || 'null') : 'undefined');
console.log('   currentCompany:', typeof currentCompany !== 'undefined' ? (currentCompany || 'null') : 'undefined');
console.log('   supabase:', typeof supabase !== 'undefined' ? (supabase ? 'inicializado' : 'null') : 'undefined');

// 5. Verificar localStorage
console.log('\n5. LOCALSTORAGE');
console.log('   nexusUser:', localStorage.getItem('nexusUser') ? 'existe' : 'não existe');
console.log('   selectedCompany:', localStorage.getItem('selectedCompany') || 'não existe');
console.log('   brunoAssoniActivated:', localStorage.getItem('brunoAssoniActivated') || 'não existe');

// 6. Verificar event listeners
console.log('\n6. EVENT LISTENERS');
if (elementos.loginForm) {
    console.log('   ✓ loginForm existe');
} else {
    console.log('   ✗ loginForm NÃO existe');
}

// 7. Teste de funções
console.log('\n7. FUNÇÕES DISPONÍVEIS');
const funcoes = [
    'initializeCompany',
    'showLogin', 
    'showDashboard',
    'handleLogin',
    'handleLogout',
    'setupEventListeners',
    'initializeApp'
];

for (const funcao of funcoes) {
    const existe = typeof window[funcao] === 'function';
    const simbolo = existe ? '✓' : '✗';
    console.log(`   ${simbolo} ${funcao}: ${existe ? 'disponível' : 'NÃO ENCONTRADA'}`);
}

// 8. Diagnóstico final
console.log('\n' + '='.repeat(60));
console.log('DIAGNÓSTICO FINAL');
console.log('='.repeat(60));

let problemas = [];

if (!window.appJsLoaded) {
    problemas.push('❌ Script app.js não foi carregado corretamente');
}

if (!elementos.loginPage || !elementos.dashboard) {
    problemas.push('❌ Elementos essenciais (loginPage ou dashboard) não encontrados');
}

if (!elementos.loginForm) {
    problemas.push('❌ Formulário de login não encontrado');
}

if (typeof supabase === 'undefined' || supabase === null) {
    problemas.push('⚠️  Supabase não está inicializado (normal antes do login)');
}

if (problemas.length === 0) {
    console.log('✅ NENHUM PROBLEMA DETECTADO!');
    console.log('\nSe o login ainda não funciona, tente:');
    console.log('1. Fazer login normalmente');
    console.log('2. Observar os logs no console');
    console.log('3. Copiar toda a saída do console');
} else {
    console.log('🔴 PROBLEMAS DETECTADOS:\n');
    problemas.forEach(p => console.log('   ' + p));
    console.log('\nSOLUÇÕES:');
    console.log('1. Limpe o cache: Ctrl+Shift+Delete');
    console.log('2. Recarregue: Ctrl+F5');
    console.log('3. Verifique se o arquivo app.js existe');
    console.log('4. Verifique erros na aba Network do DevTools');
}

console.log('='.repeat(60));

// 9. Oferecer teste manual
console.log('\n📝 TESTES MANUAIS DISPONÍVEIS:');
console.log('\nPara testar showDashboard manualmente, cole no console:');
console.log('   document.getElementById("loginPage").classList.add("hidden");');
console.log('   document.getElementById("dashboard").classList.remove("hidden");');
console.log('\nPara testar showLogin manualmente, cole no console:');
console.log('   document.getElementById("loginPage").classList.remove("hidden");');
console.log('   document.getElementById("dashboard").classList.add("hidden");');

console.log('\n' + '='.repeat(60));
console.log('FIM DO DIAGNÓSTICO');
console.log('='.repeat(60));
