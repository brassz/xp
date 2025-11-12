// ========================================
// TESTE RÁPIDO - Botão WhatsApp
// ========================================
// Cole este código no console do navegador (F12)

console.log('🧪 Iniciando testes do botão WhatsApp...\n');

// Teste 1: Verificar se o botão existe
console.log('📋 Teste 1: Verificar se o botão existe');
const btn = document.getElementById('connectWhatsAppBtn');
if (btn) {
    console.log('✅ Botão encontrado!');
    console.log('   ID:', btn.id);
    console.log('   Classe:', btn.className);
    console.log('   Texto:', btn.textContent);
    console.log('   Visível?', btn.offsetParent !== null);
} else {
    console.error('❌ Botão NÃO encontrado!');
}

// Teste 2: Verificar se a função existe
console.log('\n📋 Teste 2: Verificar se a função handleConnectWhatsApp existe');
if (typeof handleConnectWhatsApp === 'function') {
    console.log('✅ Função handleConnectWhatsApp encontrada!');
} else {
    console.error('❌ Função handleConnectWhatsApp NÃO encontrada!');
    console.log('   Definindo função de teste...');
    window.handleConnectWhatsApp = async function() {
        console.log('🧪 Função de teste chamada!');
        alert('Função de teste funcionou! Mas a função real não foi carregada.');
    };
}

// Teste 3: Verificar se o servidor está respondendo
console.log('\n📋 Teste 3: Verificar se o servidor está respondendo');
const WHATSAPP_SERVER_URL = 'http://localhost:3001';
fetch(`${WHATSAPP_SERVER_URL}/status`)
    .then(response => {
        console.log('✅ Servidor respondeu!');
        console.log('   Status:', response.status);
        return response.json();
    })
    .then(data => {
        console.log('✅ Dados recebidos:');
        console.log('   Conectado:', data.ready);
        console.log('   Tem QR Code:', data.hasQR);
        console.log('   QR Code disponível:', !!data.qrCode);
    })
    .catch(error => {
        console.error('❌ Servidor NÃO está respondendo!');
        console.error('   Erro:', error.message);
        console.error('   💡 Certifique-se de rodar: npm run start-whatsapp');
    });

// Teste 4: Verificar elementos relacionados
console.log('\n📋 Teste 4: Verificar outros elementos');
const elements = {
    'qrCodeContainer': document.getElementById('qrCodeContainer'),
    'qrCodeImage': document.getElementById('qrCodeImage'),
    'statusIndicator': document.getElementById('statusIndicator'),
    'statusText': document.getElementById('statusText'),
    'connectContainer': document.getElementById('connectContainer'),
    'connectedInfo': document.getElementById('connectedInfo'),
};

for (const [name, element] of Object.entries(elements)) {
    if (element) {
        console.log(`✅ ${name} encontrado`);
    } else {
        console.error(`❌ ${name} NÃO encontrado`);
    }
}

// Teste 5: Simular clique
console.log('\n📋 Teste 5: Simular clique no botão');
if (btn) {
    console.log('⏳ Simulando clique em 2 segundos...');
    console.log('   Observe se algo acontece...');
    setTimeout(() => {
        console.log('🖱️ CLICANDO NO BOTÃO AGORA!');
        btn.click();
    }, 2000);
} else {
    console.error('❌ Não foi possível simular clique (botão não encontrado)');
}

console.log('\n🏁 Testes concluídos!');
console.log('📝 Aguarde 2 segundos para o clique automático...');
console.log('💡 Se nada acontecer, copie TODOS os logs acima e me envie.');
