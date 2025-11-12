#!/usr/bin/env node

/**
 * Script para parar o servidor WhatsApp em background
 */

const fs = require('fs');
const path = require('path');

const PID_FILE = path.join(__dirname, '.whatsapp-server.pid');

if (!fs.existsSync(PID_FILE)) {
    console.log('ℹ️  Servidor WhatsApp não está rodando');
    process.exit(0);
}

const pid = fs.readFileSync(PID_FILE, 'utf8').trim();

try {
    console.log(`⏹️  Parando servidor WhatsApp (PID: ${pid})...`);
    process.kill(pid, 'SIGTERM');
    
    // Aguardar até 5 segundos
    let attempts = 0;
    const checkInterval = setInterval(() => {
        try {
            process.kill(pid, 0);
            attempts++;
            if (attempts >= 10) {
                console.log('⚠️  Forçando encerramento...');
                process.kill(pid, 'SIGKILL');
            }
        } catch (e) {
            clearInterval(checkInterval);
            fs.unlinkSync(PID_FILE);
            console.log('✅ Servidor WhatsApp parado com sucesso!\n');
            process.exit(0);
        }
    }, 500);
    
} catch (error) {
    if (error.code === 'ESRCH') {
        console.log('ℹ️  Processo não encontrado, removendo PID file');
        fs.unlinkSync(PID_FILE);
    } else {
        console.error('❌ Erro ao parar servidor:', error);
        process.exit(1);
    }
}
