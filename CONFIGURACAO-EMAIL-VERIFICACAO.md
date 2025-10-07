# Configuração do Sistema de Verificação por Email

## Visão Geral

O sistema de verificação por email foi implementado para adicionar uma camada extra de segurança ao login. Quando um usuário tenta fazer login, um código de 6 dígitos é enviado para o email `brasszgc@gmail.com` e deve ser inserido para completar o processo de autenticação.

## Funcionalidades Implementadas

1. **Geração de Código**: Código aleatório de 6 dígitos
2. **Envio por Email**: Integração com EmailJS (configurável)
3. **Validação**: Verificação do código antes do login
4. **Expiração**: Códigos expiram em 5 minutos
5. **Interface**: Campo de código e botão de envio na tela de login

## Como Funciona

1. Usuário preenche email e senha
2. Clica em "Enviar Código" para receber o código de verificação
3. Código é enviado para `brasszgc@gmail.com`
4. Usuário digita o código recebido
5. Sistema valida o código antes de permitir o login

## Configuração do EmailJS (Para Produção)

### Passo 1: Criar Conta no EmailJS
1. Acesse https://www.emailjs.com/
2. Crie uma conta gratuita
3. Confirme seu email

### Passo 2: Configurar Serviço de Email
1. No dashboard, vá em "Email Services"
2. Adicione um novo serviço (Gmail, Outlook, etc.)
3. Configure com suas credenciais de email
4. Anote o **Service ID**

### Passo 3: Criar Template de Email
1. Vá em "Email Templates"
2. Crie um novo template com o conteúdo:

```
Assunto: Código de Verificação - {{system_name}}

Olá,

Seu código de verificação para acessar o {{system_name}} é:

**{{verification_code}}**

Este código expira em {{expiry_time}}.

Se você não solicitou este código, ignore este email.

Atenciosamente,
Equipe {{system_name}}
```

3. Anote o **Template ID**

### Passo 4: Obter Chave Pública
1. Vá em "Account" > "General"
2. Copie sua **Public Key**

### Passo 5: Configurações Aplicadas ✅
As configurações do EmailJS já foram aplicadas no sistema:

```javascript
const EMAILJS_CONFIG = {
    serviceId: 'service_0ap0m1k',
    templateId: 'template_z3n0654',
    publicKey: 'UsJiG8it4NxqAcHkW'
};
```

**Status:** ✅ CONFIGURADO E ATIVO

## Modo Demonstração

Atualmente, o sistema está configurado em modo demonstração. Se o EmailJS não estiver configurado, o código será exibido na tela através de uma notificação, permitindo testar a funcionalidade sem configuração de email.

## Segurança

- Códigos são válidos por apenas 5 minutos
- Cada código só pode ser usado uma vez
- Códigos são gerados aleatoriamente
- Email de destino é fixo (`brasszgc@gmail.com`)

## Personalização

Para alterar o email de destino, modifique a variável no `app.js`:

```javascript
let verificationEmail = 'seu_email@exemplo.com';
```

## Teste

1. Abra o sistema no navegador
2. Tente fazer login
3. Clique em "Enviar Código"
4. Se em modo demo, o código aparecerá na notificação
5. Digite o código e complete o login

## Limitações da Versão Gratuita do EmailJS

- 200 emails por mês
- Branding do EmailJS nos emails
- Limite de templates

Para uso em produção com alto volume, considere:
- Plano pago do EmailJS
- Serviço próprio de email (SendGrid, AWS SES, etc.)
- Backend próprio para envio de emails