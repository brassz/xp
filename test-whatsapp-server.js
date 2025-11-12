// Script de teste para verificar se o servidor WhatsApp está funcionando

const WHATSAPP_SERVER_URL = 'http://localhost:3001';

console.log('🔍 Testando servidor WhatsApp...\n');

async function testServer() {
    try {
        console.log('1️⃣ Verificando se o servidor está respondendo...');
        const response = await fetch(`${WHATSAPP_SERVER_URL}/status`);
        
        if (!response.ok) {
            throw new Error(`Servidor retornou status ${response.status}`);
        }
        
        const data = await response.json();
        console.log('✅ Servidor está respondendo!\n');
        
        console.log('📊 Status do WhatsApp:');
        console.log(`   - Conectado: ${data.ready ? '✅' : '❌'}`);
        console.log(`   - Tem QR Code: ${data.hasQR ? '✅' : '❌'}`);
        console.log(`   - QR Code Image: ${data.qrCode ? '✅ Disponível' : '❌ Não disponível'}\n`);
        
        if (data.ready) {
            console.log('🎉 WhatsApp está conectado e pronto para uso!');
        } else if (data.hasQR) {
            console.log('📱 WhatsApp aguardando QR Code ser escaneado');
            if (data.qrCode) {
                console.log('   O QR Code está disponível no frontend');
            }
        } else {
            console.log('⏳ WhatsApp está inicializando...');
        }
        
    } catch (error) {
        console.error('❌ Erro ao conectar com o servidor:');
        console.error(`   ${error.message}\n`);
        console.log('💡 Dicas:');
        console.log('   1. Verifique se o servidor está rodando: npm run start-whatsapp');
        console.log('   2. Verifique se a porta 3001 está livre');
        console.log('   3. Verifique se não há firewall bloqueando a porta\n');
    }
}

testServer();
