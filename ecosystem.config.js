/**
 * Configuração PM2 para gerenciamento de processos
 * 
 * Para usar:
 * 1. Instalar PM2: npm install -g pm2
 * 2. Iniciar: pm2 start ecosystem.config.js
 * 3. Ver status: pm2 status
 * 4. Ver logs: pm2 logs whatsapp-server
 * 5. Parar: pm2 stop whatsapp-server
 * 6. Reiniciar: pm2 restart whatsapp-server
 */

module.exports = {
  apps: [{
    name: 'whatsapp-server',
    script: './whatsapp-server.js',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      PORT: 3001
    },
    error_file: './logs/whatsapp-error.log',
    out_file: './logs/whatsapp-out.log',
    log_file: './logs/whatsapp-combined.log',
    time: true,
    merge_logs: true,
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    
    // Reiniciar se crashar
    min_uptime: '10s',
    max_restarts: 10,
    
    // Aguardar antes de considerar "online"
    listen_timeout: 10000,
    kill_timeout: 5000,
  }]
};
