# 🔧 Como Corrigir o Erro 412 do Gmail no EmailJS

## ❌ Problema Atual
**Erro:** `412 Gmail_API: Request had insufficient authentication scopes`

## ✅ Solução Passo a Passo

### Passo 1: Acessar o Painel EmailJS
1. Acesse https://dashboard.emailjs.com/
2. Faça login na sua conta
3. Vá para "Email Services"

### Passo 2: Reconfigurar o Serviço Gmail
1. **Encontre o serviço** `service_0ap0m1k`
2. **Clique em "Edit"** ou "Configurar"
3. **Remova a conexão atual** com Gmail
4. **Adicione novamente** o Gmail

### Passo 3: Autorização Correta do Gmail
Durante a reconfiguração, quando o Gmail pedir permissões:

**✅ IMPORTANTE: Autorize TODOS os escopos solicitados:**
- ✅ Ver emails
- ✅ Enviar emails
- ✅ Gerenciar emails
- ✅ Acesso completo à conta Gmail

**❌ NÃO clique em "Permitir acesso limitado"**

### Passo 4: Verificar Template
1. Vá para "Email Templates"
2. Encontre o template `template_z3n0654`
3. Verifique se está **ATIVO**
4. Teste o template

### Passo 5: Testar Configuração
Use este código no console do navegador para testar:

```javascript
// Teste direto no console
emailjs.init('UsJiG8it4NxqAcHkW');
emailjs.send('service_0ap0m1k', 'template_z3n0654', {
    to_email: 'assonibrassz@gmail.com',
    verification_code: '123456',
    system_name: 'Teste',
    expiry_time: '5 minutos'
}).then(result => {
    console.log('✅ SUCESSO:', result);
}).catch(error => {
    console.error('❌ ERRO:', error);
});
```

## 🔄 Alternativa: Criar Novo Serviço

Se o problema persistir, crie um novo serviço:

### Opção A: Novo Serviço Gmail
1. Crie um **novo serviço** no EmailJS
2. Use uma **conta Gmail diferente**
3. Autorize **todas as permissões**
4. Anote o novo Service ID

### Opção B: Usar Outlook/Hotmail
1. Crie um serviço com **Outlook** em vez de Gmail
2. Outlook geralmente tem menos restrições
3. Configure com uma conta @outlook.com ou @hotmail.com

## 📧 Template Necessário

Certifique-se de que o template tenha:

**Assunto:**
```
Código de Verificação - {{system_name}}
```

**Corpo:**
```
Olá,

Seu código de verificação é: {{verification_code}}

Este código expira em {{expiry_time}}.

Atenciosamente,
{{system_name}}
```

**Variáveis obrigatórias:**
- `{{to_email}}`
- `{{verification_code}}`
- `{{system_name}}`
- `{{expiry_time}}`

## 🚨 Problemas Comuns

### Erro 412 - Insufficient Scopes
**Solução:** Reautorizar Gmail com todas as permissões

### Erro 400 - Bad Request
**Solução:** Verificar se template existe e está ativo

### Erro 401 - Unauthorized
**Solução:** Verificar Public Key

### Erro 404 - Not Found
**Solução:** Verificar Service ID e Template ID

## 📞 Próximos Passos

1. **Acesse o painel EmailJS**
2. **Reconfigure o Gmail** com todas as permissões
3. **Teste no console** com o código fornecido
4. **Me informe o resultado**

## 🔧 Se Precisar de Novos IDs

Caso crie um novo serviço, me forneça:
- Novo Service ID
- Novo Template ID (se criar novo)
- Confirme se a Public Key mudou

Vou atualizar o código com os novos valores.

## ⚡ Dica Importante

O Gmail às vezes é mais restritivo. Se continuar com problemas, recomendo:
1. Usar Outlook em vez de Gmail
2. Ou criar uma conta Gmail específica só para isso
3. Autorizar TODAS as permissões solicitadas