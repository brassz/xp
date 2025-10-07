# 🚀 Implementação Resend + Supabase

## 📋 Plano de Implementação

### 1. **Configuração Resend**
- Criar conta no Resend (gratuito)
- Obter API Key
- Configurar domínio (opcional)

### 2. **Configuração Supabase**
- Usar Supabase existente
- Criar tabela para códigos de verificação
- Implementar Edge Function para envio

### 3. **Implementação Frontend**
- Atualizar sistema de verificação
- Integrar com Supabase
- Manter interface atual

## 🎯 Vantagens desta Solução

### Resend vs EmailJS:
- ✅ **Mais confiável** - 99.9% de entrega
- ✅ **Sem configuração complexa** - API simples
- ✅ **Melhor deliverability** - Emails chegam na caixa de entrada
- ✅ **Gratuito** - 3.000 emails/mês
- ✅ **Profissional** - Usado por empresas grandes

### Supabase Integration:
- ✅ **Já está configurado** no projeto
- ✅ **Edge Functions** - Serverless
- ✅ **Seguro** - API Key no backend
- ✅ **Escalável** - Suporta milhões de requests

## 🛠️ Implementação Passo a Passo

### Passo 1: Configurar Resend
1. Acesse https://resend.com/
2. Crie conta gratuita
3. Obtenha API Key
4. Configure domínio (opcional)

### Passo 2: Criar Edge Function no Supabase
```javascript
// supabase/functions/send-verification/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')

serve(async (req) => {
  const { email, code } = await req.json()
  
  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${RESEND_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      from: 'Nexus <noreply@yourdomain.com>',
      to: [email],
      subject: 'Código de Verificação - Nexus',
      html: `
        <h2>Código de Verificação</h2>
        <p>Seu código de verificação é:</p>
        <h1 style="font-size: 32px; color: #2563eb;">${code}</h1>
        <p>Este código expira em 5 minutos.</p>
      `,
    }),
  })

  return new Response(JSON.stringify({ success: true }), {
    headers: { 'Content-Type': 'application/json' },
  })
})
```

### Passo 3: Criar Tabela de Códigos
```sql
-- Tabela para armazenar códigos de verificação
CREATE TABLE verification_codes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT NOT NULL,
  code TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() + INTERVAL '5 minutes'),
  used BOOLEAN DEFAULT FALSE
);

-- Índice para performance
CREATE INDEX idx_verification_codes_email ON verification_codes(email);
CREATE INDEX idx_verification_codes_expires ON verification_codes(expires_at);
```

### Passo 4: Atualizar Frontend
```javascript
// Função para enviar código via Supabase + Resend
async function sendVerificationCodeResend() {
  try {
    const code = generateVerificationCode();
    
    // Chamar Edge Function do Supabase
    const { data, error } = await supabase.functions.invoke('send-verification', {
      body: {
        email: verificationEmail,
        code: code
      }
    });
    
    if (error) throw error;
    
    // Salvar código no Supabase para validação
    const { error: saveError } = await supabase
      .from('verification_codes')
      .insert({
        email: verificationEmail,
        code: code
      });
    
    if (saveError) throw saveError;
    
    verificationCode = code;
    isCodeSent = true;
    
    showNotification(`Código enviado para ${verificationEmail}`, 'success');
    return true;
    
  } catch (error) {
    console.error('Erro ao enviar código:', error);
    showNotification('Erro ao enviar código', 'error');
    return false;
  }
}

// Função para validar código
async function validateVerificationCodeResend(inputCode) {
  try {
    const { data, error } = await supabase
      .from('verification_codes')
      .select('*')
      .eq('email', verificationEmail)
      .eq('code', inputCode)
      .eq('used', false)
      .gt('expires_at', new Date().toISOString())
      .single();
    
    if (error || !data) return false;
    
    // Marcar código como usado
    await supabase
      .from('verification_codes')
      .update({ used: true })
      .eq('id', data.id);
    
    return true;
    
  } catch (error) {
    console.error('Erro ao validar código:', error);
    return false;
  }
}
```

## 🎯 Próximos Passos

1. **Configurar Resend** - Criar conta e obter API Key
2. **Implementar Edge Function** - Código para envio de email
3. **Criar tabela** - Armazenar códigos de verificação
4. **Atualizar frontend** - Integrar com nova solução
5. **Testar sistema** - Verificar funcionamento completo

## 💡 Benefícios Imediatos

- ✅ **100% confiável** - Resend tem excelente deliverability
- ✅ **Seguro** - API Key no backend, não exposta
- ✅ **Escalável** - Suporta milhares de usuários
- ✅ **Profissional** - Emails bonitos e confiáveis
- ✅ **Gratuito** - Até 3.000 emails/mês

## 🚀 Vamos Implementar?

Posso começar criando:
1. **Edge Function do Supabase** para envio via Resend
2. **Tabela de códigos** no banco de dados
3. **Frontend atualizado** para usar nova solução

**Quer que eu comece implementando? Precisa da API Key do Resend primeiro ou posso criar a estrutura?**