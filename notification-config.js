// Configuração de Notificações - Sistema Nexus
// Configure pelo menos um método para receber as notificações de login

window.NOTIFICATION_CONFIG = {
    
    // ===== MÉTODO 1: WEBHOOK DISCORD/SLACK (RECOMENDADO) =====
    // Mais confiável e instantâneo
    // Para Discord: Configurações do Servidor > Integrações > Webhooks > Novo Webhook
    // Para Slack: https://api.slack.com/messaging/webhooks
    webhookUrl: "YOUR_WEBHOOK_URL_HERE",
    
    // ===== MÉTODO 2: FORMSPREE (EMAIL GRATUITO) =====
    // CONFIGURAÇÃO TEMPORÁRIA PARA TESTE - SUBSTITUA PELO SEU
    // Acesse https://formspree.io/brasszgc@gmail.com para criar um formulário
    formspreeUrl: "https://formspree.io/f/brasszgc@gmail.com",
    
    // ===== MÉTODO 3: TELEGRAM BOT =====
    // 1. Fale com @BotFather no Telegram para criar um bot
    // 2. Obtenha o token do bot
    // 3. Adicione o bot a um grupo ou chat privado
    // 4. Obtenha o chat_id (use @userinfobot para descobrir)
    telegram: {
        botToken: "YOUR_BOT_TOKEN_HERE",
        chatId: "YOUR_CHAT_ID_HERE"
    }
};

// ===== CONFIGURAÇÃO RÁPIDA - DISCORD WEBHOOK =====
// Exemplo de configuração para Discord (mais fácil de configurar):
/*
window.NOTIFICATION_CONFIG = {
    webhookUrl: "https://discord.com/api/webhooks/1234567890/abcdefghijklmnopqrstuvwxyz"
};
*/

// ===== CONFIGURAÇÃO RÁPIDA - FORMSPREE =====
// Exemplo para Formspree (email gratuito):
/*
window.NOTIFICATION_CONFIG = {
    formspreeUrl: "https://formspree.io/f/xpzgkjqw"
};
*/

// ===== CONFIGURAÇÃO RÁPIDA - TELEGRAM =====
// Exemplo para Telegram:
/*
window.NOTIFICATION_CONFIG = {
    telegram: {
        botToken: "1234567890:ABCdefGHIjklMNOpqrsTUVwxyz",
        chatId: "-1001234567890"
    }
};
*/

// INSTRUÇÕES DETALHADAS:

// 🔵 DISCORD WEBHOOK (MAIS FÁCIL):
// 1. Abra seu servidor Discord
// 2. Configurações do Servidor > Integrações > Webhooks
// 3. Clique em "Novo Webhook"
// 4. Escolha o canal onde quer receber as notificações
// 5. Copie a URL do webhook
// 6. Cole na variável webhookUrl acima

// 📧 FORMSPREE (EMAIL GRATUITO):
// 1. Acesse https://formspree.io/
// 2. Crie uma conta gratuita
// 3. Crie um novo formulário
// 4. Use o endpoint fornecido na variável formspreeUrl
// 5. Configure o email de destino como brasszgc@gmail.com

// 💬 TELEGRAM BOT:
// 1. Abra o Telegram e fale com @BotFather
// 2. Digite /newbot e siga as instruções
// 3. Copie o token fornecido
// 4. Adicione o bot ao seu chat/grupo
// 5. Use @userinfobot para descobrir o chat_id
// 6. Configure as variáveis acima

console.log('🔔 Configuração de notificações carregada');
console.log('📋 Métodos disponíveis:', Object.keys(window.NOTIFICATION_CONFIG || {}));