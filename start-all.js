#!/usr/bin/env node

/**
 * Script para iniciar automaticamente o servidor WhatsApp
 * junto com o sistema Nexus
 */

const { spawn } = require('child_process');
const path = require('path');

console.log('\n========================================');
console.log('🚀 Iniciando Sistema Nexus + WhatsApp');
console.log('========================================\n');

// Iniciar servidor WhatsApp
console.log('📱 Iniciando servidor WhatsApp...\n');

const whatsappServer = spawn('node', ['whatsapp-server.js'], {
    cwd: __dirname,
    stdio: 'inherit',
    shell: true
});

whatsappServer.on('error', (error) => {
    console.error('❌ Erro ao iniciar servidor WhatsApp:', error);
    process.exit(1);
});

whatsappServer.on('exit', (code) => {
    if (code !== 0) {
        console.error(`❌ Servidor WhatsApp encerrado com código ${code}`);
        process.exit(code);
    }
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('\n\n⏹️  Encerrando servidores...');
    whatsappServer.kill('SIGINT');
    process.exit(0);
});

process.on('SIGTERM', () => {
    console.log('\n\n⏹️  Encerrando servidores...');
    whatsappServer.kill('SIGTERM');
    process.exit(0);
});

console.log('\n✅ Sistema iniciado com sucesso!');
console.log('📝 Para encerrar, pressione Ctrl+C\n');
