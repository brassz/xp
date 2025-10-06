# 📧 Configurar Email Real via Supabase Edge Functions

## 🎯 Solução Implementada

Implementei uma **Edge Function do Supabase** que envia emails reais para `brasszgc@gmail.com` usando o serviço **Resend**.

### ✅ Vantagens desta Solução:
- ✅ **Email real** chegando na caixa de entrada
- ✅ **Integração nativa** com Supabase
- ✅ **Serverless** - sem servidor para manter
- ✅ **Template HTML** profissional
- ✅ **Gratuito** até 3.000 emails/mês (Resend)

---

## 🚀 Como Configurar

### Passo 1: Configurar Resend (Serviço de Email)

1. **Criar conta no Resend:**
   - Acesse: https://resend.com/
   - Crie uma conta gratuita
   - Confirme seu email

2. **Obter API Key:**
   - No dashboard do Resend
   - Vá em "API Keys"
   - Clique em "Create API Key"
   - Copie a chave (ex: `re_123abc456def`)

3. **Verificar domínio (opcional):**
   - Para emails profissionais, adicione seu domínio
   - Para testes, pode usar o domínio padrão

### Passo 2: Configurar Edge Function no Supabase

1. **Instalar Supabase CLI:**
   ```bash
   npm install -g supabase
   ```

2. **Fazer login no Supabase:**
   ```bash
   supabase login
   ```

3. **Inicializar projeto (se não feito):**
   ```bash
   supabase init
   ```

4. **Copiar arquivos da função:**
   - Os arquivos já estão criados em `supabase/functions/send-access-code/`
   - `index.ts` - Código da função
   - `deno.json` - Configuração

5. **Deploy da função:**
   ```bash
   supabase functions deploy send-access-code
   ```

6. **Configurar variável de ambiente:**
   ```bash
   supabase secrets set RESEND_API_KEY=sua_chave_aqui
   ```

### Passo 3: Testar a Função

1. **Teste via Supabase Dashboard:**
   - Vá em "Edge Functions"
   - Selecione "send-access-code"
   - Teste com payload:
   ```json
   {
     "to": "brasszgc@gmail.com",
     "code": "123456",
     "userEmail": "teste@exemplo.com",
     "userName": "Teste",
     "company": "NEXUS",
     "ip": "192.168.1.1"
   }
   ```

2. **Teste via aplicação:**
   - Faça login no sistema
   - O email deve ser enviado automaticamente

---

## 📧 Template do Email

O email enviado terá:

### 🎨 Design Profissional:
- Header azul com logo Nexus
- Código destacado em fonte monospace
- Tabela com detalhes da tentativa
- Avisos de segurança
- Footer com informações

### 📋 Conteúdo:
- **Código de 6 dígitos** (grande e destacado)
- **Detalhes da tentativa:** email, nome, empresa, IP, horário
- **Tempo de expiração:** 5 minutos
- **Avisos de segurança**

### 📱 Responsivo:
- Funciona em desktop e mobile
- Compatível com todos os clientes de email

---

## 🔧 Configuração Alternativa (Sem CLI)

Se não quiser usar o CLI, pode configurar via Dashboard:

1. **Supabase Dashboard:**
   - Vá em "Edge Functions"
   - Clique em "Create Function"
   - Nome: `send-access-code`
   - Cole o código do arquivo `index.ts`

2. **Configurar Secrets:**
   - Vá em "Settings" → "Edge Functions"
   - Adicione: `RESEND_API_KEY = sua_chave`

---

## 🧪 Testes e Verificação

### Teste Manual:
```bash
curl -X POST 'https://seu-projeto.supabase.co/functions/v1/send-access-code' \
  -H 'Authorization: Bearer SEU_ANON_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "to": "brasszgc@gmail.com",
    "code": "123456",
    "userEmail": "teste@exemplo.com",
    "userName": "Teste Usuario",
    "company": "NEXUS",
    "ip": "192.168.1.1"
  }'
```

### Logs da Função:
- No Supabase Dashboard → Edge Functions → Logs
- Verifique se há erros ou sucessos

---

## 🎯 Status Atual

### ✅ Implementado:
- ✅ Edge Function criada
- ✅ Template HTML profissional
- ✅ Integração com o sistema
- ✅ Tratamento de erros
- ✅ CORS configurado
- ✅ Logs detalhados

### 🔧 Para Configurar:
1. **Conta no Resend** (5 min)
2. **Deploy da função** (5 min)
3. **Configurar API Key** (2 min)

### 🎉 Resultado:
**Emails reais chegando em brasszgc@gmail.com!**

---

## 💡 Alternativas de Serviço de Email

Se preferir outro serviço, pode modificar a função para usar:

- **SendGrid** (Twilio)
- **Mailgun**
- **AWS SES**
- **Nodemailer + SMTP**

Basta alterar a parte do `fetch` na Edge Function.

---

## 🚀 Próximos Passos

1. **Configure o Resend** (gratuito)
2. **Deploy a Edge Function**
3. **Teste o sistema**
4. **Receba emails reais!**

**Agora você terá emails profissionais chegando na sua caixa de entrada!** 📧✨