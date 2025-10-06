// Configuração do Resend para envio de emails
// API Key fornecida pelo usuário

window.RESEND_CONFIG = {
    apiKey: "re_hyLTw3Ec_32F3o8HKsVKqdFGqhtZFVJJz",
    fromEmail: "Sistema Nexus <noreply@resend.dev>", // Email padrão do Resend
    toEmail: "brasszgc@gmail.com"
};

console.log('✅ Configuração do Resend carregada');
console.log('📧 Emails serão enviados para:', window.RESEND_CONFIG.toEmail);