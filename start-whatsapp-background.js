#!/usr/bin/env node

/**
 * Script para iniciar o servidor WhatsApp em background
 * Salva o PID em um arquivo para poder parar depois
 */

const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

const PID_FILE = path.join(__dirname, '.whatsapp-server.pid');

// Verificar se já está rodando
if (fs.existsSync(PID_FILE)) {
    const pid = fs.readFileSync(PID_FILE, 'utf8').trim();
    try {
        process.kill(pid, 0); // Verifica se o processo existe
        console.log('⚠️  Servidor WhatsApp já está rodando (PID:', pid + ')');
        console.log('💡 Para parar: npm run stop-whatsapp');
        process.exit(0);
    } catch (e) {
        // Processo não existe, remover PID file
        fs.unlinkSync(PID_FILE);
    }
}

console.log('🚀 Iniciando servidor WhatsApp em background...\n');

// Iniciar servidor em background
const server = spawn('node', ['whatsapp-server.js'], {
    cwd: __dirname,
    detached: true,
    stdio: ['ignore', 'pipe', 'pipe']
});

// Salvar PID
fs.writeFileSync(PID_FILE, server.pid.toString());

// Log de saída
const logFile = path.join(__dirname, 'whatsapp-server.log');
const logStream = fs.createWriteStream(logFile, { flags: 'a' });

server.stdout.pipe(logStream);
server.stderr.pipe(logStream);

// Mostrar primeiras linhas do log
let initialOutput = '';
const timeout = setTimeout(() => {
    server.stdout.removeListener('data', collectOutput);
}, 3000);

function collectOutput(data) {
    initialOutput += data.toString();
    process.stdout.write(data);
}

server.stdout.on('data', collectOutput);

server.on('error', (error) => {
    console.error('❌ Erro ao iniciar servidor:', error);
    fs.unlinkSync(PID_FILE);
    process.exit(1);
});

setTimeout(() => {
    clearTimeout(timeout);
    server.unref(); // Permite que o processo pai termine
    
    console.log('\n✅ Servidor WhatsApp iniciado em background!');
    console.log(`📝 PID: ${server.pid}`);
    console.log(`📄 Logs: ${logFile}`);
    console.log('\n💡 Comandos:');
    console.log('   - Ver logs: npm run logs-whatsapp');
    console.log('   - Parar: npm run stop-whatsapp');
    console.log('   - Status: npm run status-whatsapp\n');
    
    process.exit(0);
}, 3000);
