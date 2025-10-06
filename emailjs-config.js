// Configuração do EmailJS
// Para configurar, substitua os valores abaixo pelas suas credenciais do EmailJS
// Obtenha suas credenciais em: https://www.emailjs.com/

window.EMAILJS_CONFIG = {
    // Substitua pela sua chave pública do EmailJS
    publicKey: "YOUR_PUBLIC_KEY_HERE",
    
    // Substitua pelo ID do seu serviço
    serviceId: "YOUR_SERVICE_ID_HERE", 
    
    // Substitua pelo ID do seu template
    templateId: "YOUR_TEMPLATE_ID_HERE"
};

// Exemplo de configuração (remova os comentários e substitua pelos valores reais):
/*
window.EMAILJS_CONFIG = {
    publicKey: "user_1234567890abcdef",
    serviceId: "service_gmail_123",
    templateId: "template_access_code"
};
*/

// IMPORTANTE: 
// - Mantenha suas credenciais seguras
// - Não commite este arquivo com credenciais reais em repositórios públicos
// - Para produção, considere usar variáveis de ambiente