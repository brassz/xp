#!/bin/bash

# Script de auto-inicialização para Linux/Mac
# Pode ser adicionado ao crontab ou usado como serviço

echo "🚀 Auto-inicializando Servidor WhatsApp..."

# Ir para o diretório do projeto
cd "$(dirname "$0")"

# Verificar se já está rodando
if [ -f .whatsapp-server.pid ]; then
    PID=$(cat .whatsapp-server.pid)
    if ps -p $PID > /dev/null; then
        echo "✅ Servidor já está rodando (PID: $PID)"
        exit 0
    else
        echo "⚠️  PID file inválido, removendo..."
        rm .whatsapp-server.pid
    fi
fi

# Iniciar servidor
echo "📱 Iniciando servidor WhatsApp..."
npm run start-whatsapp-bg

# Verificar se iniciou com sucesso
sleep 3
if [ -f .whatsapp-server.pid ]; then
    echo "✅ Servidor iniciado com sucesso!"
    npm run status-whatsapp
else
    echo "❌ Falha ao iniciar servidor"
    exit 1
fi
