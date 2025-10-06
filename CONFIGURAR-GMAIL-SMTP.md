# 📧 Configurar Gmail SMTP para Envio Real de Emails

## 🎯 Solução Mais Simples

Implementei uma **Edge Function SMTP** que usa o Gmail para enviar emails reais para `brasszgc@gmail.com`.

### ✅ Vantagens:
- ✅ **Usa seu próprio Gmail** (familiar e confiável)
- ✅ **Gratuito** (sem custos adicionais)
- ✅ **Fácil configuração** (5 minutos)
- ✅ **Email real** na caixa de entrada
- ✅ **Template HTML profissional**

---

## 🚀 Configuração Rápida (5 minutos)

### Passo 1: Configurar Gmail (2 minutos)

1. **Ativar verificação em 2 etapas:**
   - Vá em: https://myaccount.google.com/security
   - Clique em "Verificação em duas etapas"
   - Siga as instruções para ativar

2. **Gerar senha de app:**
   - Na mesma página de segurança
   - Clique em "Senhas de app"
   - Selecione "Email" e "Outro"
   - Digite "Nexus Sistema"
   - **Copie a senha gerada** (16 caracteres)

### Passo 2: Configurar Supabase (3 minutos)

1. **Abrir Supabase Dashboard:**
   - Vá em: https://supabase.com/dashboard
   - Selecione seu projeto

2. **Configurar Edge Function:**
   - Vá em "Edge Functions"
   - Clique em "Create Function"
   - Nome: `send-email-smtp`
   - Cole o código do arquivo `supabase/functions/send-email-smtp/index.ts`

3. **Configurar variáveis de ambiente:**
   - Vá em "Settings" → "Edge Functions"
   - Adicione as variáveis:
   ```
   SMTP_HOST = smtp.gmail.com
   SMTP_PORT = 587
   SMTP_USER = seu-email@gmail.com
   SMTP_PASS = senha-de-app-de-16-caracteres
   ```

### Passo 3: Testar (1 minuto)

1. **Faça login no sistema**
2. **Verifique o console** - deve mostrar "✅ Email enviado via Supabase SMTP Function"
3. **Verifique seu email** brasszgc@gmail.com

---

## 📧 Como Ficará o Email

### 🎨 Design Profissional:
```
┌─────────────────────────────────────┐
│  🔐 Sistema Nexus                   │
│  Código de Acesso Solicitado        │
├─────────────────────────────────────┤
│                                     │
│  Código de Verificação              │
│  ┌─────────────────────────────────┐ │
│  │        1 2 3 4 5 6              │ │
│  └─────────────────────────────────┘ │
│  ⏰ Expira em 5 minutos             │
│                                     │
│  📋 Detalhes da Solicitação         │
│  👤 Email: usuario@exemplo.com      │
│  📝 Nome: João Silva                │
│  🏢 Empresa: NEXUS                  │
│  🕐 Horário: 06/10/2025 20:30      │
│  🌐 IP: 192.168.1.100               │
│                                     │
│  📱 Como usar:                      │
│  1. Volte para o sistema            │
│  2. Digite o código                 │
│  3. Clique em "Verificar"           │
│                                     │
│  ⚠️ Aviso de Segurança              │
│                                     │
└─────────────────────────────────────┘
```

---

## 🔧 Configuração Alternativa (Via CLI)

Se preferir usar o Supabase CLI:

```bash
# 1. Instalar CLI
npm install -g supabase

# 2. Login
supabase login

# 3. Deploy função
supabase functions deploy send-email-smtp

# 4. Configurar secrets
supabase secrets set SMTP_HOST=smtp.gmail.com
supabase secrets set SMTP_PORT=587
supabase secrets set SMTP_USER=seu-email@gmail.com
supabase secrets set SMTP_PASS=sua-senha-de-app
```

---

## 🧪 Teste Manual

Teste a função diretamente:

```bash
curl -X POST 'https://seu-projeto.supabase.co/functions/v1/send-email-smtp' \
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

---

## 🔍 Solução de Problemas

### ❌ Erro: "Credenciais SMTP não configuradas"
- Verifique se as variáveis estão configuradas no Supabase
- Certifique-se de usar a senha de app, não a senha normal

### ❌ Erro: "Authentication failed"
- Confirme que a verificação em 2 etapas está ativa
- Gere uma nova senha de app
- Verifique se o email está correto

### ❌ Email não chega
- Verifique a pasta de spam
- Confirme o endereço brasszgc@gmail.com
- Verifique os logs da Edge Function

---

## 🎯 Status Atual

### ✅ Implementado:
- ✅ **2 Edge Functions** (Resend + SMTP)
- ✅ **Template HTML profissional**
- ✅ **Integração completa** com o sistema
- ✅ **Fallback múltiplo** (6 métodos diferentes)
- ✅ **Logs detalhados**

### 🔧 Para Configurar:
1. **Senha de app Gmail** (2 min)
2. **Deploy Edge Function** (3 min)
3. **Teste** (1 min)

### 🎉 Resultado:
**Emails HTML profissionais chegando em brasszgc@gmail.com!**

---

## 💡 Outras Opções de SMTP

Pode usar qualquer provedor SMTP:

- **Gmail** (gratuito, 500 emails/dia)
- **Outlook/Hotmail** (gratuito)
- **Yahoo Mail** (gratuito)
- **SendGrid** (100 emails/dia grátis)
- **Mailgun** (5.000 emails/mês grátis)

Basta alterar as configurações SMTP na Edge Function.

---

## 🚀 Próximos Passos

1. **Configure Gmail** (ative 2FA + senha de app)
2. **Deploy Edge Function** no Supabase
3. **Configure variáveis** SMTP
4. **Teste o sistema**
5. **Receba emails reais!**

**Agora você terá emails profissionais chegando diretamente na sua caixa de entrada!** 📧✨