# 🚀 Início Automático do Servidor WhatsApp

## 📋 Opções de Inicialização

### 🔷 Opção 1: Início Simples (Recomendado)

Inicia tudo junto (sistema + WhatsApp):

```bash
npm start
```

### 🔷 Opção 2: Background (Daemon)

Inicia o servidor em background e continua rodando:

```bash
# Iniciar em background
npm run start-whatsapp-bg

# Verificar status
npm run status-whatsapp

# Ver logs em tempo real
npm run logs-whatsapp

# Parar servidor
npm run stop-whatsapp

# Reiniciar
npm run restart-whatsapp
```

### 🔷 Opção 3: PM2 (Produção)

Para ambientes de produção com auto-restart e gerenciamento avançado:

```bash
# 1. Instalar PM2 globalmente
npm install -g pm2

# 2. Iniciar com PM2
pm2 start ecosystem.config.js

# 3. Salvar configuração para iniciar no boot
pm2 save
pm2 startup

# Comandos úteis:
pm2 status              # Ver status
pm2 logs whatsapp-server  # Ver logs
pm2 restart whatsapp-server  # Reiniciar
pm2 stop whatsapp-server     # Parar
pm2 delete whatsapp-server   # Remover
```

## 🎯 Qual Escolher?

| Opção | Quando Usar |
|-------|-------------|
| **npm start** | Desenvolvimento, testes rápidos |
| **Background** | Servidor local, não quer terminal aberto |
| **PM2** | Produção, servidor remoto, precisa de auto-restart |

## 📊 Verificar Status

```bash
# Ver se está rodando
npm run status-whatsapp
```

Saída esperada:
```
📊 Status do Servidor WhatsApp

✅ Processo: Rodando (PID: 12345)
✅ Servidor: Respondendo
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📱 Status do WhatsApp:

   ✅ Conectado: Sim
   ❌ QR Code: Não disponível

🎉 WhatsApp está conectado e pronto para uso!
```

## 🔧 Comandos Disponíveis

```bash
# INICIAR
npm start                    # Tudo junto (sistema + WhatsApp)
npm run start-whatsapp       # Só WhatsApp (foreground)
npm run start-whatsapp-bg    # Só WhatsApp (background)

# PARAR
npm run stop-whatsapp        # Parar servidor background
Ctrl+C                       # Parar foreground

# STATUS & LOGS
npm run status-whatsapp      # Ver status completo
npm run logs-whatsapp        # Ver logs em tempo real
npm run test-whatsapp        # Testar conexão

# GERENCIAMENTO
npm run restart-whatsapp     # Reiniciar servidor
```

## 🐛 Solução de Problemas

### ❌ Erro: Porta 3001 já está em uso

```bash
# Ver o que está usando a porta
lsof -i :3001

# Ou parar o servidor
npm run stop-whatsapp
```

### ❌ Servidor não inicia

```bash
# 1. Verificar se já está rodando
npm run status-whatsapp

# 2. Parar processo antigo
npm run stop-whatsapp

# 3. Limpar sessão
rm -rf .wwebjs_auth .wwebjs_cache .whatsapp-server.pid

# 4. Reiniciar
npm run start-whatsapp-bg
```

### ❌ PID file inválido

```bash
# Remover PID file
rm .whatsapp-server.pid

# Iniciar novamente
npm run start-whatsapp-bg
```

## 🔄 Auto-Iniciar no Boot do Sistema

### Linux (systemd)

1. Criar arquivo de serviço:

```bash
sudo nano /etc/systemd/system/nexus-whatsapp.service
```

2. Adicionar conteúdo:

```ini
[Unit]
Description=Nexus WhatsApp Server
After=network.target

[Service]
Type=simple
User=seu-usuario
WorkingDirectory=/caminho/para/workspace
ExecStart=/usr/bin/node /caminho/para/workspace/whatsapp-server.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

3. Ativar:

```bash
sudo systemctl enable nexus-whatsapp
sudo systemctl start nexus-whatsapp
sudo systemctl status nexus-whatsapp
```

### Windows

1. Instalar node-windows:

```bash
npm install -g node-windows
```

2. Criar serviço (script separado necessário)

### macOS

1. Criar arquivo LaunchAgent:

```bash
nano ~/Library/LaunchAgents/com.nexus.whatsapp.plist
```

2. Adicionar configuração XML (LaunchAgent format)

## 📝 Logs

### Localização dos Logs

- **Background:** `whatsapp-server.log`
- **PM2:** `logs/whatsapp-*.log`

### Ver logs:

```bash
# Background
tail -f whatsapp-server.log

# PM2
pm2 logs whatsapp-server

# Últimas 100 linhas
tail -100 whatsapp-server.log
```

## ⚡ Quick Start

**Para começar rapidamente:**

```bash
# 1. Instalar dependências (apenas primeira vez)
npm install

# 2. Iniciar servidor em background
npm run start-whatsapp-bg

# 3. Verificar se está rodando
npm run status-whatsapp

# 4. Abrir o sistema no navegador
# 5. Ir na aba Atendimento
# 6. Clicar em "Conectar WhatsApp"
# 7. Escanear QR Code
```

## 🎉 Pronto!

O servidor agora pode ser iniciado automaticamente e gerenciado facilmente!

Para verificar se está tudo funcionando:
```bash
npm run status-whatsapp
```
