import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { SMTPClient } from "https://deno.land/x/denomailer@1.6.0/mod.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface EmailRequest {
  to: string
  code: string
  userEmail: string
  userName: string
  company: string
  ip: string
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { to, code, userEmail, userName, company, ip }: EmailRequest = await req.json()

    // Validar dados obrigatórios
    if (!to || !code || !userEmail) {
      return new Response(
        JSON.stringify({ error: 'Dados obrigatórios: to, code, userEmail' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Configurações SMTP (usando Gmail como exemplo)
    const SMTP_HOST = Deno.env.get('SMTP_HOST') || 'smtp.gmail.com'
    const SMTP_PORT = parseInt(Deno.env.get('SMTP_PORT') || '587')
    const SMTP_USER = Deno.env.get('SMTP_USER') // seu email
    const SMTP_PASS = Deno.env.get('SMTP_PASS') // senha de app do Gmail
    
    if (!SMTP_USER || !SMTP_PASS) {
      console.error('Credenciais SMTP não configuradas')
      return new Response(
        JSON.stringify({ error: 'Serviço de email não configurado' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Configurar cliente SMTP
    const client = new SMTPClient({
      connection: {
        hostname: SMTP_HOST,
        port: SMTP_PORT,
        tls: true,
        auth: {
          username: SMTP_USER,
          password: SMTP_PASS,
        },
      },
    })

    // Template do email
    const emailHtml = `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Código de Acesso - Sistema Nexus</title>
      </head>
      <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f5f5f5;">
        <div style="background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);">
          <!-- Header -->
          <div style="background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%); padding: 30px; text-align: center;">
            <h1 style="color: white; margin: 0; font-size: 28px; font-weight: bold;">🔐 Sistema Nexus</h1>
            <p style="color: #e0e7ff; margin: 10px 0 0 0; font-size: 16px;">Código de Acesso Solicitado</p>
          </div>
          
          <!-- Código -->
          <div style="padding: 30px;">
            <div style="background: #f8fafc; padding: 25px; border-radius: 8px; margin-bottom: 25px; border-left: 4px solid #1e40af;">
              <h2 style="color: #1e40af; margin-top: 0; font-size: 20px; text-align: center;">Código de Verificação</h2>
              <div style="background: white; padding: 25px; border-radius: 6px; text-align: center; margin: 20px 0; border: 2px dashed #1e40af;">
                <div style="font-size: 42px; font-weight: bold; color: #1e40af; letter-spacing: 12px; font-family: 'Courier New', monospace;">
                  ${code}
                </div>
              </div>
              <p style="margin: 0; color: #64748b; font-size: 14px; text-align: center;">
                ⏰ Este código expira em <strong style="color: #dc2626;">5 minutos</strong>
              </p>
            </div>
            
            <!-- Detalhes -->
            <div style="background: #fef3c7; padding: 20px; border-radius: 8px; margin-bottom: 25px; border: 1px solid #fbbf24;">
              <h3 style="color: #92400e; margin-top: 0; font-size: 16px; display: flex; align-items: center;">
                📋 Detalhes da Solicitação
              </h3>
              <table style="width: 100%; border-collapse: collapse;">
                <tr>
                  <td style="padding: 8px 0; color: #92400e; font-weight: bold; width: 30%;">👤 Email:</td>
                  <td style="padding: 8px 0; color: #451a03; font-family: monospace;">${userEmail}</td>
                </tr>
                <tr>
                  <td style="padding: 8px 0; color: #92400e; font-weight: bold;">📝 Nome:</td>
                  <td style="padding: 8px 0; color: #451a03;">${userName || 'N/A'}</td>
                </tr>
                <tr>
                  <td style="padding: 8px 0; color: #92400e; font-weight: bold;">🏢 Empresa:</td>
                  <td style="padding: 8px 0; color: #451a03;">${company || 'N/A'}</td>
                </tr>
                <tr>
                  <td style="padding: 8px 0; color: #92400e; font-weight: bold;">🕐 Horário:</td>
                  <td style="padding: 8px 0; color: #451a03;">${new Date().toLocaleString('pt-BR', { timeZone: 'America/Sao_Paulo' })}</td>
                </tr>
                <tr>
                  <td style="padding: 8px 0; color: #92400e; font-weight: bold;">🌐 IP:</td>
                  <td style="padding: 8px 0; color: #451a03; font-family: monospace;">${ip || 'N/A'}</td>
                </tr>
              </table>
            </div>
            
            <!-- Instruções -->
            <div style="background: #dbeafe; padding: 20px; border-radius: 8px; margin-bottom: 25px; border: 1px solid #3b82f6;">
              <h3 style="color: #1e40af; margin-top: 0; font-size: 16px;">📱 Como usar o código:</h3>
              <ol style="color: #1e40af; margin: 0; padding-left: 20px;">
                <li style="margin-bottom: 8px;">Volte para a tela de login do sistema</li>
                <li style="margin-bottom: 8px;">Digite o código de 6 dígitos acima</li>
                <li style="margin-bottom: 8px;">Clique em "Verificar Código"</li>
                <li>Acesso será liberado automaticamente</li>
              </ol>
            </div>
            
            <!-- Aviso de Segurança -->
            <div style="background: #fee2e2; padding: 15px; border-radius: 8px; margin-bottom: 25px; border: 1px solid #f87171;">
              <p style="margin: 0; color: #991b1b; font-size: 14px;">
                <strong>⚠️ Segurança:</strong> Se você não autorizou esta tentativa de login, ignore este email. 
                O código expirará automaticamente em 5 minutos por segurança.
              </p>
            </div>
          </div>
          
          <!-- Footer -->
          <div style="background: #f8fafc; text-align: center; padding: 20px; border-top: 1px solid #e2e8f0;">
            <p style="margin: 0; color: #64748b; font-size: 14px; font-weight: bold;">Sistema Nexus - Gestão Financeira</p>
            <p style="margin: 5px 0 0 0; color: #94a3b8; font-size: 12px;">Desenvolvido por Bruno Assoni</p>
          </div>
        </div>
        
        <!-- Rodapé externo -->
        <div style="text-align: center; margin-top: 20px; color: #94a3b8; font-size: 11px;">
          <p>Este é um email automático do Sistema Nexus. Não responda este email.</p>
        </div>
      </body>
      </html>
    `

    // Enviar email
    await client.send({
      from: `Sistema Nexus <${SMTP_USER}>`,
      to: to,
      subject: "🔐 Código de Acesso - Sistema Nexus",
      content: emailHtml,
      html: emailHtml,
    })

    await client.close()

    console.log('Email enviado com sucesso via SMTP')

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'Email enviado com sucesso via SMTP',
        timestamp: new Date().toISOString()
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Erro na função SMTP:', error)
    return new Response(
      JSON.stringify({ error: 'Erro interno do servidor', details: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})