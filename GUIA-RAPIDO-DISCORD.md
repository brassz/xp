# 🚀 Guia Rápido - Configurar Discord para Receber Códigos

## ⚡ Solução Mais Rápida (5 minutos)

O Discord Webhook é a forma mais confiável de receber as notificações de código de acesso.

### Passo 1: Criar Servidor Discord (se não tiver)
1. Abra o Discord
2. Clique no "+" para criar servidor
3. Escolha "Criar Meu Próprio"
4. Dê um nome (ex: "Nexus Códigos")

### Passo 2: Configurar Webhook
1. **Clique com botão direito** no canal onde quer receber as notificações
2. Selecione **"Editar Canal"**
3. Vá em **"Integrações"** → **"Webhooks"**
4. Clique em **"Criar Webhook"**
5. Dê um nome (ex: "Nexus Login")
6. **COPIE A URL DO WEBHOOK** (algo como: `https://discord.com/api/webhooks/1234567890/abcdef...`)

### Passo 3: Configurar no Sistema
1. Abra o arquivo `notification-config.js`
2. Substitua esta linha:
   ```javascript
   webhookUrl: "YOUR_WEBHOOK_URL_HERE",
   ```
   
   Por:
   ```javascript
   webhookUrl: "https://discord.com/api/webhooks/SUA_URL_AQUI",
   ```

### Passo 4: Testar
1. Faça login no sistema
2. Você deve receber uma mensagem no Discord com o código!

---

## 📱 Exemplo da Mensagem no Discord

```
🔐 **CÓDIGO DE ACESSO NEXUS**

**Código:** `123456`
**Email:** usuario@exemplo.com
**Nome:** João Silva
**Empresa:** NEXUS
**Horário:** 06/10/2025 20:30:15
**IP:** 192.168.1.100

⏰ Expira em 5 minutos
```

---

## 🔧 Alternativa: Formspree (Email)

Se preferir email, use o Formspree:

1. Acesse: https://formspree.io/
2. Crie conta gratuita
3. Crie novo formulário
4. Configure email de destino: `brasszgc@gmail.com`
5. Copie o endpoint (ex: `https://formspree.io/f/xpzgkjqw`)
6. No arquivo `notification-config.js`, substitua:
   ```javascript
   formspreeUrl: "https://formspree.io/f/SEU_ID_AQUI",
   ```

---

## ✅ Status Atual

- ✅ Sistema de códigos funcionando
- ✅ Múltiplos métodos de notificação
- ✅ Painel visual para ver códigos
- ✅ Console do navegador mostra códigos
- ✅ Fallback para desenvolvimento

**Agora você tem 4 formas de receber os códigos:**
1. 💬 Discord Webhook (recomendado)
2. 📧 Formspree Email
3. 🤖 Telegram Bot
4. 🖥️ Painel visual no sistema

Configure pelo menos um método e os códigos chegaram até você! 🎉