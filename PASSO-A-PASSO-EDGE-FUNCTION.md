# 📋 Passo a Passo: Configurar Edge Function

## ✅ Sistema Funcionando Corretamente!

**O erro que você viu é esperado:**
```
❌ Edge Function não configurada. Configure a função send-verification no Supabase.
```

**Isso confirma que:**
- ✅ Sistema NÃO mostra código na tela (como você pediu)
- ✅ Sistema tenta usar apenas email
- ✅ Precisa configurar Edge Function para funcionar

## 🚀 Configuração (5 minutos)

### Passo 1: Acessar Supabase
1. **Acesse:** https://supabase.com/dashboard
2. **Faça login** na sua conta
3. **Selecione seu projeto** (provavelmente o que tem URL: mhtxyxizfnxupwmilith.supabase.co)

### Passo 2: Criar Tabela
1. **No menu lateral, clique em "SQL Editor"**
2. **Clique em "New Query"**
3. **Cole este código:**

```sql
CREATE TABLE IF NOT EXISTS verification_codes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT NOT NULL,
  code TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() + INTERVAL '5 minutes'),
  used BOOLEAN DEFAULT FALSE
);

CREATE INDEX IF NOT EXISTS idx_verification_codes_email ON verification_codes(email);
ALTER TABLE verification_codes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all operations" ON verification_codes FOR ALL USING (true);
```

4. **Clique em "Run"**
5. **Deve aparecer:** "Success. No rows returned"

### Passo 3: Criar Edge Function
1. **No menu lateral, clique em "Edge Functions"**
2. **Clique em "Create Function"**
3. **Nome da função:** `send-verification` (exatamente assim)
4. **Cole TODO este código:**

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { 
      status: 200,
      headers: corsHeaders 
    })
  }

  try {
    const { email, code } = await req.json()
    
    console.log(`Enviando código ${code} para ${email}`)
    
    const emailResponse = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': 'Bearer re_fLRYWVd5_NJMbNNBZGrWPDBVLBkeaEn4Z',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: 'Nexus <noreply@resend.dev>',
        to: ['brasszgc@gmail.com'],
        subject: 'Código de Verificação - Nexus Gestão Financeira',
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background: #f5f5f5; padding: 20px;">
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; text-align: center; border-radius: 15px 15px 0 0;">
              <h1 style="color: white; margin: 0; font-size: 28px;">🏢 Nexus Gestão Financeira</h1>
              <p style="color: #e0e7ff; margin: 10px 0 0 0;">Sistema de Verificação Segura</p>
            </div>
            <div style="background: white; padding: 40px; border-radius: 0 0 15px 15px;">
              <h2 style="color: #333; text-align: center; margin-bottom: 20px;">🔐 Código de Verificação</h2>
              <p style="color: #666; text-align: center;">Para acessar o sistema Nexus, use o código:</p>
              <div style="background: #f8fafc; border: 3px solid #667eea; border-radius: 15px; padding: 30px; margin: 30px 0; text-align: center;">
                <div style="font-size: 48px; color: #667eea; margin: 0; letter-spacing: 12px; font-family: monospace; font-weight: bold;">${code}</div>
              </div>
              <div style="background: #fef3cd; border: 1px solid #fbbf24; border-radius: 8px; padding: 15px; margin: 20px 0;">
                <p style="color: #92400e; margin: 0; text-align: center;">⏰ Este código expira em <strong>5 minutos</strong></p>
              </div>
              <p style="color: #666; text-align: center;">Digite este código no campo de verificação.</p>
            </div>
          </div>
        `,
      }),
    })

    const result = await emailResponse.json()
    
    if (!emailResponse.ok) {
      throw new Error(`Resend error: ${result.message}`)
    }

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'Código enviado para brasszgc@gmail.com'
      }),
      { 
        status: 200, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' }}
    )
  }
})
```

5. **Clique em "Deploy"**
6. **Aguarde:** "Function deployed successfully"

### Passo 4: Testar
1. **Abra `index.html`**
2. **Tente fazer login**
3. **Clique em "Enviar Código"**
4. **Deve aparecer:** "Código enviado para brasszgc@gmail.com"
5. **Verifique email** (incluindo SPAM)

## 🎯 Resultado Esperado

### **Após configurar Edge Function:**
```
Console: ✅ Edge Function executada com sucesso
Notificação: Código enviado para brasszgc@gmail.com
Email: Chega em brasszgc@gmail.com com código
Sistema: Login funciona após digitar código
```

### **Email que chegará:**
- 🎨 Design profissional com gradiente
- 🔢 Código de 6 dígitos destacado
- ⏰ Aviso de expiração (5 minutos)
- 🔒 Informações de segurança

## ⚠️ Importante

**Sem Edge Function = Sistema não funciona**
**Com Edge Function = Sistema 100% funcional apenas via email**

## 🚀 Configure Agora!

**Siga os 4 passos acima e o sistema enviará emails reais para brasszgc@gmail.com! 🎯**