import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

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
  userAgent: string
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { to, code, userEmail, userName, company, ip, userAgent }: EmailRequest = await req.json()

    // Validar dados obrigatórios
    if (!to || !code || !userEmail) {
      return new Response(
        JSON.stringify({ error: 'Dados obrigatórios: to, code, userEmail' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Configurar cliente de email (usando Resend como exemplo)
    const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')
    
    if (!RESEND_API_KEY) {
      console.error('RESEND_API_KEY não configurada')
      return new Response(
        JSON.stringify({ error: 'Serviço de email não configurado' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Template do email
    const emailHtml = `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Código de Acesso - Sistema Nexus</title>
      </head>
      <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
        <div style="background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%); padding: 30px; border-radius: 10px; text-align: center; margin-bottom: 30px;">
          <h1 style="color: white; margin: 0; font-size: 28px;">🔐 Sistema Nexus</h1>
          <p style="color: #e0e7ff; margin: 10px 0 0 0; font-size: 16px;">Código de Acesso Solicitado</p>
        </div>
        
        <div style="background: #f8fafc; padding: 25px; border-radius: 8px; margin-bottom: 25px; border-left: 4px solid #1e40af;">
          <h2 style="color: #1e40af; margin-top: 0; font-size: 20px;">Código de Verificação</h2>
          <div style="background: white; padding: 20px; border-radius: 6px; text-align: center; margin: 20px 0;">
            <div style="font-size: 36px; font-weight: bold; color: #1e40af; letter-spacing: 8px; font-family: 'Courier New', monospace;">
              ${code}
            </div>
          </div>
          <p style="margin: 0; color: #64748b; font-size: 14px; text-align: center;">
            Este código expira em <strong>5 minutos</strong>
          </p>
        </div>
        
        <div style="background: #fef3c7; padding: 20px; border-radius: 8px; margin-bottom: 25px;">
          <h3 style="color: #92400e; margin-top: 0; font-size: 16px;">📋 Detalhes da Solicitação</h3>
          <table style="width: 100%; border-collapse: collapse;">
            <tr>
              <td style="padding: 8px 0; color: #92400e; font-weight: bold; width: 30%;">Email:</td>
              <td style="padding: 8px 0; color: #451a03;">${userEmail}</td>
            </tr>
            <tr>
              <td style="padding: 8px 0; color: #92400e; font-weight: bold;">Nome:</td>
              <td style="padding: 8px 0; color: #451a03;">${userName || 'N/A'}</td>
            </tr>
            <tr>
              <td style="padding: 8px 0; color: #92400e; font-weight: bold;">Empresa:</td>
              <td style="padding: 8px 0; color: #451a03;">${company || 'N/A'}</td>
            </tr>
            <tr>
              <td style="padding: 8px 0; color: #92400e; font-weight: bold;">Horário:</td>
              <td style="padding: 8px 0; color: #451a03;">${new Date().toLocaleString('pt-BR', { timeZone: 'America/Sao_Paulo' })}</td>
            </tr>
            <tr>
              <td style="padding: 8px 0; color: #92400e; font-weight: bold;">IP:</td>
              <td style="padding: 8px 0; color: #451a03;">${ip || 'N/A'}</td>
            </tr>
          </table>
        </div>
        
        <div style="background: #fee2e2; padding: 15px; border-radius: 8px; margin-bottom: 25px;">
          <p style="margin: 0; color: #991b1b; font-size: 14px;">
            <strong>⚠️ Segurança:</strong> Se você não autorizou esta tentativa de login, ignore este email. 
            O código expirará automaticamente em 5 minutos.
          </p>
        </div>
        
        <div style="text-align: center; padding: 20px 0; border-top: 1px solid #e2e8f0; color: #64748b; font-size: 12px;">
          <p style="margin: 0;">Sistema Nexus - Gestão Financeira</p>
          <p style="margin: 5px 0 0 0;">Desenvolvido por Bruno Assoni</p>
        </div>
      </body>
      </html>
    `

    // Enviar email usando Resend
    const emailResponse = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${RESEND_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: 'Nexus Sistema <noreply@nexus.com>',
        to: [to],
        subject: '🔐 Código de Acesso - Sistema Nexus',
        html: emailHtml,
      }),
    })

    if (!emailResponse.ok) {
      const error = await emailResponse.text()
      console.error('Erro ao enviar email:', error)
      return new Response(
        JSON.stringify({ error: 'Falha ao enviar email', details: error }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const result = await emailResponse.json()
    console.log('Email enviado com sucesso:', result)

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'Email enviado com sucesso',
        emailId: result.id 
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Erro na função:', error)
    return new Response(
      JSON.stringify({ error: 'Erro interno do servidor', details: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})