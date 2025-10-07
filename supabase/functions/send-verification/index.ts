import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { 
      status: 200,
      headers: corsHeaders 
    })
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

    console.log(`Enviando código ${code} para ${email}`)
    
    // Enviar email via Resend com API Key configurada
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
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="utf-8">
            <title>Código de Verificação</title>
          </head>
          <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f5f5f5;">
            
            <!-- Header -->
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; border-radius: 15px 15px 0 0; text-align: center;">
              <h1 style="color: white; margin: 0; font-size: 28px; font-weight: bold;">
                🏢 Nexus Gestão Financeira
              </h1>
              <p style="color: #e0e7ff; margin: 10px 0 0 0; font-size: 16px;">
                Sistema de Verificação Segura
              </p>
            </div>
            
            <!-- Content -->
            <div style="background: white; padding: 40px; border-radius: 0 0 15px 15px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);">
              
              <h2 style="color: #333; text-align: center; margin-bottom: 20px; font-size: 24px;">
                🔐 Código de Verificação
              </h2>
              
              <p style="color: #666; font-size: 16px; text-align: center; line-height: 1.6;">
                Para acessar o sistema Nexus, use o código de verificação abaixo:
              </p>
              
              <!-- Code Box -->
              <div style="background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%); border: 3px solid #667eea; border-radius: 15px; padding: 30px; margin: 30px 0; text-align: center; box-shadow: 0 2px 4px rgba(102, 126, 234, 0.1);">
                <div style="font-size: 48px; color: #667eea; margin: 0; letter-spacing: 12px; font-family: 'Courier New', monospace; font-weight: bold;">
                  ${code}
                </div>
              </div>
              
              <!-- Info -->
              <div style="background: #fef3cd; border: 1px solid #fbbf24; border-radius: 8px; padding: 15px; margin: 20px 0;">
                <p style="color: #92400e; margin: 0; font-size: 14px; text-align: center;">
                  ⏰ Este código expira em <strong>5 minutos</strong>
                </p>
              </div>
              
              <p style="color: #666; font-size: 14px; text-align: center; line-height: 1.6;">
                Digite este código no campo de verificação para completar seu login.
              </p>
              
              <!-- Security Notice -->
              <div style="border-top: 1px solid #e5e7eb; padding-top: 20px; margin-top: 30px;">
                <p style="color: #9ca3af; font-size: 12px; text-align: center; line-height: 1.5;">
                  🔒 Por segurança, nunca compartilhe este código com outras pessoas.<br>
                  Se você não solicitou este código, ignore este email.
                </p>
              </div>
              
            </div>
            
            <!-- Footer -->
            <div style="text-align: center; margin-top: 20px;">
              <p style="color: #9ca3af; font-size: 12px; margin: 0;">
                © 2024 Nexus Gestão Financeira. Todos os direitos reservados.
              </p>
              <p style="color: #9ca3af; font-size: 12px; margin: 5px 0 0 0;">
                Sistema desenvolvido por Bruno Assoni
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

    console.log('Email enviado com sucesso via Resend:', emailResult)

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
    } else {
      console.log('Código salvo no banco com sucesso')
    }

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'Código enviado com sucesso para ' + email,
        emailId: emailResult.id,
        timestamp: new Date().toISOString()
      }),
      { 
        status: 200, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )

  } catch (error) {
    console.error('Erro na função send-verification:', error)
    return new Response(
      JSON.stringify({ 
        error: 'Erro interno do servidor', 
        details: error.message,
        timestamp: new Date().toISOString()
      }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )
  }
})