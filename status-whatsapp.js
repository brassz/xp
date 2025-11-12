#!/usr/bin/env node

/**
 * Script para verificar status do servidor WhatsApp
 */

const fs = require('fs');
const path = require('path');

const PID_FILE = path.join(__dirname, '.whatsapp-server.pid');
const WHATSAPP_SERVER_URL = 'http://localhost:3001';

console.log('\n📊 Status do Servidor WhatsApp\n');
console.log('━'.repeat(50));

// Verificar PID
let processRunning = false;
let pid = null;

if (fs.existsSync(PID_FILE)) {
    pid = fs.readFileSync(PID_FILE, 'utf8').trim();
    try {
        process.kill(pid, 0);
        processRunning = true;
        console.log(`✅ Processo: Rodando (PID: ${pid})`);
    } catch (e) {
        console.log('❌ Processo: Não encontrado (PID inválido)');
        fs.unlinkSync(PID_FILE);
    }
} else {
    console.log('❌ Processo: Não iniciado');
}

// Verificar se o servidor está respondendo
(async () => {
    try {
        const fetch = (await import('node-fetch')).default;
        const response = await fetch(`${WHATSAPP_SERVER_URL}/status`);
        const data = await response.json();
        
        console.log('✅ Servidor: Respondendo');
        console.log('━'.repeat(50));
        console.log('\n📱 Status do WhatsApp:\n');
        console.log(`   ${data.ready ? '✅' : '❌'} Conectado: ${data.ready ? 'Sim' : 'Não'}`);
        console.log(`   ${data.hasQR ? '📱' : '❌'} QR Code: ${data.hasQR ? 'Disponível' : 'Não disponível'}`);
        
        if (data.ready) {
            console.log('\n🎉 WhatsApp está conectado e pronto para uso!');
        } else if (data.hasQR) {
            console.log('\n⏳ WhatsApp aguardando QR Code ser escaneado');
            console.log('💡 Abra a aba Atendimento e clique em "Conectar WhatsApp"');
        } else {
            console.log('\n⏳ WhatsApp está inicializando...');
        }
        
    } catch (error) {
        console.log('❌ Servidor: Não está respondendo');
        console.log(`   URL: ${WHATSAPP_SERVER_URL}`);
        console.log(`   Erro: ${error.message}`);
        
        if (processRunning) {
            console.log('\n⚠️  Processo rodando mas servidor não responde');
            console.log('💡 Tente reiniciar: npm run restart-whatsapp');
        } else {
            console.log('\n💡 Inicie o servidor: npm run start-whatsapp-bg');
        }
    }
    
    console.log('\n' + '━'.repeat(50) + '\n');
})();
