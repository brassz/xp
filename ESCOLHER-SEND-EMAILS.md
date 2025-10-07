# 🎯 Escolha: "Send Emails" - Edge Function

## ✅ Edge Function Correta

**Na lista do Supabase, escolha:**

```
Send Emails
Send emails using the Resend API
```

**Esta é EXATAMENTE a função que precisamos!**

## 🚀 Após Escolher "Send Emails"

### Passo 1: Configurar Nome
- **Nome da função:** `send-verification`
- **Descrição:** Sistema de verificação Nexus

### Passo 2: Substituir Código
**O Supabase vai mostrar um código exemplo. SUBSTITUA TUDO pelo nosso código:**

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

### Passo 3: Deploy
1. **Clique em "Deploy"**
2. **Aguarde:** "Function deployed successfully"

### Passo 4: Testar
1. **Abra `index.html`**
2. **Clique em "Enviar Código"**
3. **Deve aparecer:** "Código enviado para brasszgc@gmail.com"
4. **Verifique email** em brasszgc@gmail.com

## 🎯 Resultado Esperado

### **Antes (atual):**
```
❌ Edge Function não configurada
```

### **Depois (após configurar):**
```
✅ Edge Function executada com sucesso
✅ Código enviado para brasszgc@gmail.com
📧 Email HTML profissional recebido
```

## 📧 Email que Chegará

**Design profissional com:**
- 🎨 Header com gradiente azul/roxo
- 🏢 Logo "Nexus Gestão Financeira"
- 🔢 Código destacado em fonte monospace
- ⏰ Aviso de expiração (5 minutos)
- 🔒 Informações de segurança

## 🚀 Resumo

1. **Escolha:** "Send Emails" na lista
2. **Nome:** `send-verification`
3. **Código:** Cole o código acima (substitua tudo)
4. **Deploy:** Clique em Deploy
5. **Teste:** Use o sistema principal

**Após isso, emails reais chegarão em brasszgc@gmail.com! 🎉**