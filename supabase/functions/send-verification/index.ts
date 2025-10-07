import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { email, code } = await req.json()
    
    // Validar parâmetros
    if (!email || !code) {
      return new Response(
        JSON.stringify({ error: 'Email e código são obrigatórios' }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        }
      )
    }

    // Configurar Resend
    const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')
    
    if (!RESEND_API_KEY) {
      console.error('RESEND_API_KEY não configurada')
      return new Response(
        JSON.stringify({ error: 'Configuração de email não encontrada' }),
        { 
          status: 500, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        }
      )
    }

    // Enviar email via Resend
    console.log(`Enviando código ${code} para ${email}`)
    
    const emailResponse = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${RESEND_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: 'Nexus <noreply@nexus.com>',
        to: [email],
        subject: 'Código de Verificação - Nexus Gestão Financeira',
        html: `
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="utf-8">
            <title>Código de Verificação</title>
          </head>
          <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; border-radius: 10px; text-align: center;">
              <h1 style="color: white; margin: 0;">Nexus Gestão Financeira</h1>
            </div>
            
            <div style="background: #f8f9fa; padding: 30px; border-radius: 10px; margin-top: 20px;">
              <h2 style="color: #333; text-align: center;">Código de Verificação</h2>
              
              <p style="color: #666; font-size: 16px; text-align: center;">
                Seu código de verificação para acessar o sistema é:
              </p>
              
              <div style="background: #fff; border: 2px solid #667eea; border-radius: 10px; padding: 20px; margin: 20px 0; text-align: center;">
                <h1 style="font-size: 48px; color: #667eea; margin: 0; letter-spacing: 8px; font-family: 'Courier New', monospace;">
                  ${code}
                </h1>
              </div>
              
              <p style="color: #666; font-size: 14px; text-align: center;">
                Este código expira em <strong>5 minutos</strong>.
              </p>
              
              <p style="color: #999; font-size: 12px; text-align: center; margin-top: 30px;">
                Se você não solicitou este código, ignore este email.
              </p>
            </div>
            
            <div style="text-align: center; margin-top: 20px;">
              <p style="color: #999; font-size: 12px;">
                © 2024 Nexus Gestão Financeira. Todos os direitos reservados.
              </p>
            </div>
          </body>
          </html>
        `,
      }),
    })

    const emailResult = await emailResponse.json()
    
    if (!emailResponse.ok) {
      console.error('Erro do Resend:', emailResult)
      return new Response(
        JSON.stringify({ error: 'Falha ao enviar email', details: emailResult }),
        { 
          status: 500, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        }
      )
    }

    console.log('Email enviado com sucesso:', emailResult)

    // Salvar código no banco de dados
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseKey)

    const { error: dbError } = await supabase
      .from('verification_codes')
      .insert({
        email: email,
        code: code,
        expires_at: new Date(Date.now() + 5 * 60 * 1000).toISOString() // 5 minutos
      })

    if (dbError) {
      console.error('Erro ao salvar no banco:', dbError)
      // Não falhar se não conseguir salvar no banco, email já foi enviado
    }

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'Código enviado com sucesso',
        emailId: emailResult.id 
      }),
      { 
        status: 200, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )

  } catch (error) {
    console.error('Erro na função:', error)
    return new Response(
      JSON.stringify({ error: 'Erro interno do servidor', details: error.message }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )
  }
})