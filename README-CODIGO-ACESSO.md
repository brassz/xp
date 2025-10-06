# Sistema de Código de Acesso - Nexus

## Funcionalidade Implementada

O sistema agora possui uma camada adicional de segurança que requer verificação por código de acesso para todos os logins.

### Como Funciona

1. **Login Normal**: O usuário insere suas credenciais (empresa, email, senha)
2. **Geração do Código**: Sistema gera um código de 6 dígitos aleatório
3. **Envio de Notificação**: Código é enviado para `brasszgc@gmail.com` com detalhes da tentativa de login
4. **Verificação**: Usuário deve inserir o código recebido para completar o login
5. **Acesso Liberado**: Após verificação bem-sucedida, usuário acessa o sistema

### Recursos de Segurança

- **Códigos Temporários**: Expiram em 5 minutos
- **Uso Único**: Cada código só pode ser usado uma vez
- **Rastreamento**: IP, user agent e horário são registrados
- **Limpeza Automática**: Códigos expirados são removidos automaticamente

### Configuração do EmailJS

Para que o envio de emails funcione, você precisa configurar o EmailJS:

1. **Criar Conta**: Acesse [EmailJS](https://www.emailjs.com/) e crie uma conta
2. **Configurar Serviço**: Adicione um serviço de email (Gmail, Outlook, etc.)
3. **Criar Template**: Crie um template com as seguintes variáveis:
   - `{{to_email}}` - Email de destino
   - `{{subject}}` - Assunto do email
   - `{{access_code}}` - Código de 6 dígitos
   - `{{user_email}}` - Email do usuário tentando fazer login
   - `{{user_name}}` - Nome do usuário
   - `{{company}}` - Empresa selecionada
   - `{{login_time}}` - Data/hora da tentativa
   - `{{user_ip}}` - IP do usuário

4. **Atualizar Configurações**: No arquivo `app.js`, substitua:
   ```javascript
   emailjs.init("YOUR_PUBLIC_KEY"); // Sua chave pública
   await emailjs.send('YOUR_SERVICE_ID', 'YOUR_TEMPLATE_ID', templateParams);
   ```

### Template de Email Sugerido

```html
<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
    <h2 style="color: #1e40af;">Solicitação de Acesso - Sistema Nexus</h2>
    <p>Uma tentativa de login foi realizada no sistema Nexus:</p>
    
    <div style="background-color: #f3f4f6; padding: 20px; border-radius: 8px; margin: 20px 0;">
        <h3 style="color: #374151; margin-top: 0;">Código de Acesso:</h3>
        <div style="font-size: 32px; font-weight: bold; color: #1e40af; text-align: center; background-color: white; padding: 15px; border-radius: 4px; letter-spacing: 4px;">
            {{access_code}}
        </div>
    </div>
    
    <div style="background-color: #fef3c7; padding: 15px; border-radius: 8px; margin: 20px 0;">
        <h4 style="color: #92400e; margin-top: 0;">Detalhes da Tentativa:</h4>
        <p><strong>Email:</strong> {{user_email}}</p>
        <p><strong>Nome:</strong> {{user_name}}</p>
        <p><strong>Empresa:</strong> {{company}}</p>
        <p><strong>Data/Hora:</strong> {{login_time}}</p>
        <p><strong>IP:</strong> {{user_ip}}</p>
    </div>
    
    <p style="color: #6b7280; font-size: 14px;">
        Este código expira em 5 minutos. Se você não autorizou esta tentativa de login, ignore este email.
    </p>
</div>
```

### Banco de Dados

Execute o arquivo `setup-access-codes-table.sql` para criar a tabela necessária:

```sql
-- Criar tabela para códigos de acesso
CREATE TABLE IF NOT EXISTS access_codes (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    code VARCHAR(6) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    ip_address VARCHAR(45),
    user_agent TEXT
);
```

### Interface do Usuário

- **Tela de Login**: Mantida igual, mas agora redireciona para verificação de código
- **Tela de Código**: Nova interface para inserir o código de 6 dígitos
- **Funcionalidades**: Reenviar código, voltar ao login, validação de entrada

### Fluxo de Segurança

1. Usuário faz login → Código gerado e enviado para brasszgc@gmail.com
2. Administrador recebe email com código e detalhes da tentativa
3. Administrador fornece código para o usuário (se autorizado)
4. Usuário insere código → Acesso liberado

### Manutenção

- Códigos expirados são limpos automaticamente
- Logs de tentativas são mantidos para auditoria
- Função `cleanup_expired_access_codes()` pode ser executada periodicamente

### Segurança Adicional

- Códigos são únicos e aleatórios
- Rastreamento de IP e user agent
- Expiração automática em 5 minutos
- Uso único por código
- Notificação em tempo real para o administrador