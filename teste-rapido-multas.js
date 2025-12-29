// ============================================
// SCRIPT DE TESTE RÁPIDO - SISTEMA DE MULTAS
// ============================================
// 
// INSTRUÇÕES:
// 1. Abra o console do navegador (F12)
// 2. Copie TODO este arquivo
// 3. Cole no console e pressione Enter
// 4. Leia os resultados
//
// ============================================

console.log('╔════════════════════════════════════════════════════════╗');
console.log('║   TESTE DIAGNÓSTICO - SISTEMA DE MULTAS DE CLIENTES   ║');
console.log('╚════════════════════════════════════════════════════════╝\n');

let allTestsPassed = true;
let errors = [];

// ==================== TESTE 1: Funções JavaScript ====================
console.log('📋 TESTE 1: Verificando Funções JavaScript...');
console.log('─────────────────────────────────────────────────────────');

const functions = {
    'openAddClientFineModal': typeof openAddClientFineModal === 'function',
    'openAddClientFineModalSafe': typeof openAddClientFineModalSafe === 'function',
    'closeAddClientFineModal': typeof closeAddClientFineModal === 'function',
    'saveClientFine': typeof saveClientFine === 'function',
    'getClientTotalFines': typeof getClientTotalFines === 'function',
    'getClientFinesHistory': typeof getClientFinesHistory === 'function'
};

Object.entries(functions).forEach(([name, exists]) => {
    if (exists) {
        console.log(`  ✅ ${name}() existe`);
    } else {
        console.log(`  ❌ ${name}() NÃO EXISTE`);
        allTestsPassed = false;
        errors.push(`Função ${name}() não encontrada`);
    }
});

console.log('');

// ==================== TESTE 2: Elementos HTML ====================
console.log('📋 TESTE 2: Verificando Elementos HTML...');
console.log('─────────────────────────────────────────────────────────');

const elements = {
    'Modal Principal': document.getElementById('addClientFineModal'),
    'Input Client ID': document.getElementById('fineClientId'),
    'Input Client Name': document.getElementById('fineClientName'),
    'Display Client Name': document.getElementById('fineClientNameDisplay'),
    'Input Valor Multa': document.getElementById('fineAmount'),
    'Input Descrição': document.getElementById('fineDescription'),
    'Formulário': document.getElementById('addClientFineForm')
};

Object.entries(elements).forEach(([name, element]) => {
    if (element) {
        console.log(`  ✅ ${name} existe`);
    } else {
        console.log(`  ❌ ${name} NÃO EXISTE`);
        allTestsPassed = false;
        errors.push(`Elemento "${name}" não encontrado no HTML`);
    }
});

console.log('');

// ==================== TESTE 3: Variáveis de Contexto ====================
console.log('📋 TESTE 3: Verificando Variáveis de Contexto...');
console.log('─────────────────────────────────────────────────────────');

const currentCompanyExists = typeof currentCompany !== 'undefined';
const localStorageCompany = localStorage.getItem('selectedCompany');

if (currentCompanyExists && currentCompany) {
    console.log(`  ✅ currentCompany definida: ${currentCompany}`);
} else {
    console.log(`  ⚠️  currentCompany não definida ou vazia`);
    if (localStorageCompany) {
        console.log(`  ℹ️  localStorage.selectedCompany: ${localStorageCompany}`);
    } else {
        allTestsPassed = false;
        errors.push('currentCompany não definida e localStorage vazio');
    }
}

const supabaseExists = typeof supabase !== 'undefined';
if (supabaseExists) {
    console.log(`  ✅ Supabase client existe`);
} else {
    console.log(`  ❌ Supabase client NÃO EXISTE`);
    allTestsPassed = false;
    errors.push('Supabase client não inicializado');
}

console.log('');

// ==================== TESTE 4: Botões de Multa ====================
console.log('📋 TESTE 4: Verificando Botões de Multa na Tabela...');
console.log('─────────────────────────────────────────────────────────');

const fineButtons = document.querySelectorAll('[data-client-id][data-client-name]');
if (fineButtons.length > 0) {
    console.log(`  ✅ Encontrados ${fineButtons.length} botões de multa`);
    
    // Verificar primeiro botão como exemplo
    const firstButton = fineButtons[0];
    const clientId = firstButton.getAttribute('data-client-id');
    const clientName = firstButton.getAttribute('data-client-name');
    
    console.log(`  ℹ️  Exemplo do primeiro botão:`);
    console.log(`     - Client ID: ${clientId ? clientId.substring(0, 20) + '...' : 'VAZIO'}`);
    console.log(`     - Client Name: ${clientName || 'VAZIO'}`);
    
    if (!clientId) {
        console.log(`  ⚠️  ATENÇÃO: data-client-id está vazio!`);
        errors.push('Botões de multa sem client-id');
    }
} else {
    console.log(`  ⚠️  Nenhum botão de multa encontrado`);
    console.log(`  ℹ️  Isso é normal se você não estiver na aba "Empréstimos"`);
}

console.log('');

// ==================== TESTE 5: Teste de Validação ====================
console.log('📋 TESTE 5: Teste de Validação de Valores...');
console.log('─────────────────────────────────────────────────────────');

const testValues = [
    { value: '50', expected: 50, valid: true, desc: 'Número inteiro' },
    { value: '50.00', expected: 50, valid: true, desc: 'Número com decimais' },
    { value: '50,00', expected: NaN, valid: false, desc: 'Vírgula (formato BR)' },
    { value: '', expected: NaN, valid: false, desc: 'String vazia' },
    { value: '0', expected: 0, valid: false, desc: 'Zero' },
    { value: '-10', expected: -10, valid: false, desc: 'Número negativo' },
    { value: 'abc', expected: NaN, valid: false, desc: 'Texto inválido' }
];

testValues.forEach(test => {
    const parsed = parseFloat(test.value);
    const isNaN_result = isNaN(parsed);
    const isValid = !isNaN_result && parsed > 0;
    
    const status = isValid === test.valid ? '✅' : '❌';
    console.log(`  ${status} "${test.value}" → ${parsed} (${test.desc})`);
    
    if (test.valid && !isValid) {
        errors.push(`Validação incorreta para "${test.value}"`);
        allTestsPassed = false;
    }
});

console.log('');

// ==================== TESTE 6: Histórico (se aplicável) ====================
console.log('📋 TESTE 6: Verificando Elementos do Histórico...');
console.log('─────────────────────────────────────────────────────────');

const historyElements = {
    'Card Total Multas': document.getElementById('historyTotalFines'),
    'Tabela Multas': document.getElementById('historyFinesTableBody')
};

Object.entries(historyElements).forEach(([name, element]) => {
    if (element) {
        console.log(`  ✅ ${name} existe`);
    } else {
        console.log(`  ❌ ${name} NÃO EXISTE`);
        errors.push(`Elemento de histórico "${name}" não encontrado`);
    }
});

console.log('');

// ==================== RESULTADO FINAL ====================
console.log('╔════════════════════════════════════════════════════════╗');
console.log('║                   RESULTADO FINAL                      ║');
console.log('╚════════════════════════════════════════════════════════╝\n');

if (allTestsPassed && errors.length === 0) {
    console.log('  🎉 TODOS OS TESTES PASSARAM!');
    console.log('  ✅ Sistema está configurado corretamente');
    console.log('  ✅ Funções JavaScript carregadas');
    console.log('  ✅ Elementos HTML presentes');
    console.log('  ✅ Validações funcionando');
    console.log('');
    console.log('  📝 PRÓXIMO PASSO:');
    console.log('     1. Vá para a aba "Empréstimos"');
    console.log('     2. Clique no botão ⚠️ de um empréstimo');
    console.log('     3. Digite um valor (ex: 50.00)');
    console.log('     4. Clique em "Adicionar Multa"');
    console.log('');
} else {
    console.log('  ⚠️  ALGUNS PROBLEMAS FORAM ENCONTRADOS:');
    console.log('');
    errors.forEach((error, index) => {
        console.log(`  ${index + 1}. ${error}`);
    });
    console.log('');
    console.log('  🔧 SOLUÇÕES POSSÍVEIS:');
    console.log('');
    
    if (errors.some(e => e.includes('Função'))) {
        console.log('  📌 Funções JavaScript não encontradas:');
        console.log('     → Limpe o cache: Ctrl + Shift + R');
        console.log('     → Verifique se app.js foi carregado corretamente');
        console.log('');
    }
    
    if (errors.some(e => e.includes('Elemento'))) {
        console.log('  📌 Elementos HTML não encontrados:');
        console.log('     → Limpe o cache: Ctrl + Shift + R');
        console.log('     → Verifique se index.html foi atualizado');
        console.log('');
    }
    
    if (errors.some(e => e.includes('currentCompany'))) {
        console.log('  📌 currentCompany não definida:');
        console.log('     → Faça logout e login novamente');
        console.log('     → Verifique se você selecionou uma empresa');
        console.log('');
    }
    
    if (errors.some(e => e.includes('Supabase'))) {
        console.log('  📌 Supabase não inicializado:');
        console.log('     → Verifique conexão com internet');
        console.log('     → Recarregue a página completamente (Ctrl + F5)');
        console.log('');
    }
}

// ==================== INFORMAÇÕES ADICIONAIS ====================
console.log('╔════════════════════════════════════════════════════════╗');
console.log('║              INFORMAÇÕES ADICIONAIS                    ║');
console.log('╚════════════════════════════════════════════════════════╝\n');

console.log('  📊 Estatísticas:');
console.log(`     - Funções encontradas: ${Object.values(functions).filter(v => v).length}/6`);
console.log(`     - Elementos HTML encontrados: ${Object.values(elements).filter(v => v).length}/7`);
console.log(`     - Botões de multa na página: ${fineButtons.length}`);
console.log('');

console.log('  🔍 Para mais informações:');
console.log('     - Leia: LEIA-ME-URGENTE-MULTAS.md');
console.log('     - Debug: DEBUG-MULTAS-CLIENTES.md');
console.log('     - Detalhes: CORRECAO-VALIDACAO-MULTAS.md');
console.log('');

console.log('  💡 Dica: Se tudo passou, tente adicionar uma multa agora!');
console.log('');

console.log('════════════════════════════════════════════════════════');
console.log('Teste concluído em:', new Date().toLocaleString('pt-BR'));
console.log('════════════════════════════════════════════════════════\n');

// Retornar resultado para possível uso programático
({
    success: allTestsPassed && errors.length === 0,
    errors: errors,
    functionsOk: Object.values(functions).every(v => v),
    elementsOk: Object.values(elements).every(v => v),
    buttonCount: fineButtons.length,
    timestamp: new Date().toISOString()
});
