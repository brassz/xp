# 🔧 Configuração Obrigatória - Supabase Edge Function

## 🎯 Sistema Configurado para Email Apenas

**Sistema atualizado:** Código **NÃO aparece** na tela - apenas via email para `brasszgc@gmail.com`

## ⚡ Configuração Obrigatória (5 minutos)

### Passo 1: Criar Tabela no Supabase (1 minuto)

**No Supabase, vá em "SQL Editor" e execute:**

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
CREATE INDEX IF NOT EXISTS idx_verification_codes_expires ON verification_codes(expires_at);

ALTER TABLE verification_codes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all operations" ON verification_codes FOR ALL USING (true);
```

### Passo 2: Criar Edge Function (3 minutos)

**No Supabase, vá em "Edge Functions" → "Create Function":**

**Nome:** `send-verification`

**Código (copie TUDO):**

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { 
      status: 200,
      headers: corsHeaders 
    })
  }

  try {
    const { email, code } = await req.json()
    
    console.log(`Enviando código ${code} para ${email}`)
    
    // Enviar via Resend
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
            <div style="background: white; padding: 40px; border-radius: 0 0 15px 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
              <h2 style="color: #333; text-align: center; margin-bottom: 20px;">🔐 Código de Verificação</h2>
              <p style="color: #666; text-align: center;">Para acessar o sistema Nexus, use o código:</p>
              <div style="background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); border: 3px solid #667eea; border-radius: 15px; padding: 30px; margin: 30px 0; text-align: center;">
                <div style="font-size: 48px; color: #667eea; margin: 0; letter-spacing: 12px; font-family: monospace; font-weight: bold;">${code}</div>
              </div>
              <div style="background: #fef3cd; border: 1px solid #fbbf24; border-radius: 8px; padding: 15px; margin: 20px 0;">
                <p style="color: #92400e; margin: 0; text-align: center;">⏰ Este código expira em <strong>5 minutos</strong></p>
              </div>
              <p style="color: #666; text-align: center;">Digite este código no campo de verificação.</p>
              <div style="border-top: 1px solid #e5e7eb; padding-top: 20px; margin-top: 30px;">
                <p style="color: #9ca3af; font-size: 12px; text-align: center;">🔒 Nunca compartilhe este código.<br>Se não solicitou, ignore este email.</p>
              </div>
            </div>
            <div style="text-align: center; margin-top: 20px;">
              <p style="color: #9ca3af; font-size: 12px; margin: 0;">© 2024 Nexus Gestão Financeira</p>
            </div>
          </div>
        `,
      }),
    })

    const result = await emailResponse.json()
    
    if (!emailResponse.ok) {
      console.error('Erro Resend:', result)
      throw new Error(`Resend error: ${result.message}`)
    }

    console.log('Email enviado com sucesso:', result)

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'Código enviado para brasszgc@gmail.com',
        emailId: result.id 
      }),
      { 
        status: 200, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )

  } catch (error) {
    console.error('Erro na função:', error)
    return new Response(
      JSON.stringify({ 
        error: 'Erro ao enviar email', 
        details: error.message 
      }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )
  }
})
```

### Passo 3: Deploy da Função (1 minuto)

**Clique em "Deploy" na Edge Function**

## 🧪 Como Testar

### Teste no Sistema Principal:
1. **Abra `index.html`**
2. **Tente fazer login**
3. **Clique em "Enviar Código"**
4. **Aguarde mensagem:** "Código enviado para brasszgc@gmail.com"
5. **Verifique email** (incluindo pasta SPAM)
6. **Digite código** e complete login

### Se Der Erro:
- **"Function not found"** → Edge Function não foi criada
- **"CORS error"** → Edge Function não foi deployada
- **"Resend error"** → Problema na API Key

## 📧 Email que Chegará

**Design profissional com:**
- 🎨 **Header com gradiente** azul/roxo
- 🔢 **Código destacado** em fonte monospace
- ⏰ **Aviso de expiração** (5 minutos)
- 🔒 **Informações de segurança**

## ⚠️ Importante

**Sem a Edge Function configurada:**
- ❌ Sistema **NÃO funcionará**
- ❌ Código **NÃO aparecerá** na tela
- ❌ Login **será bloqueado**

**Com a Edge Function configurada:**
- ✅ **Emails reais** para brasszgc@gmail.com
- ✅ **Sistema 100% funcional**
- ✅ **Nenhum código na tela**

## 🚀 Configure Agora!

**Siga os 3 passos acima e o sistema funcionará apenas via email! 🎯**