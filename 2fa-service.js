// Serviço de 2FA para Nexus Gestão Financeira
// Integração com Supabase e Resend

const speakeasy = require('speakeasy');
const QRCode = require('qrcode');
const { Resend } = require('resend');

class TwoFactorAuthService {
    constructor(supabaseClient, config = {}) {
        this.supabase = supabaseClient;
        this.resend = new Resend(config.resendApiKey || process.env.RESEND_API_KEY);
        this.config = {
            issuer: config.issuer || process.env.TWO_FA_ISSUER || 'Nexus Gestão',
            codeExpiryMinutes: config.codeExpiryMinutes || parseInt(process.env.TWO_FA_CODE_EXPIRY_MINUTES) || 5,
            maxAttempts: config.maxAttempts || parseInt(process.env.TWO_FA_MAX_ATTEMPTS) || 3,
            fromEmail: config.fromEmail || process.env.FROM_EMAIL || 'noreply@nexusgestao.com',
            fromName: config.fromName || process.env.FROM_NAME || 'Nexus Gestão Financeira'
        };
    }

    // Gerar secret para TOTP (Google Authenticator, Authy, etc.)
    generateTOTPSecret(userEmail) {
        const secret = speakeasy.generateSecret({
            name: userEmail,
            issuer: this.config.issuer,
            length: 32
        });

        return {
            secret: secret.base32,
            otpauthUrl: secret.otpauth_url,
            qrCodeUrl: null // Será gerado separadamente
        };
    }

    // Gerar QR Code para configuração do TOTP
    async generateQRCode(otpauthUrl) {
        try {
            const qrCodeDataUrl = await QRCode.toDataURL(otpauthUrl);
            return qrCodeDataUrl;
        } catch (error) {
            console.error('Erro ao gerar QR Code:', error);
            throw new Error('Falha ao gerar QR Code');
        }
    }

    // Verificar código TOTP
    verifyTOTP(secret, token) {
        return speakeasy.totp.verify({
            secret: secret,
            encoding: 'base32',
            token: token,
            window: 2 // Permite uma janela de tempo de ±2 períodos (60 segundos)
        });
    }

    // Gerar código de 6 dígitos para email/SMS
    generateEmailCode() {
        return Math.floor(100000 + Math.random() * 900000).toString();
    }

    // Enviar código por email usando Resend
    async sendEmailCode(userEmail, userName = '') {
        try {
            const code = this.generateEmailCode();
            const expiresAt = new Date();
            expiresAt.setMinutes(expiresAt.getMinutes() + this.config.codeExpiryMinutes);

            // Salvar código no banco de dados
            const { data: user } = await this.supabase.auth.getUser();
            if (!user?.user?.id) {
                throw new Error('Usuário não autenticado');
            }

            const { error: dbError } = await this.supabase
                .from('temp_2fa_codes')
                .insert({
                    user_id: user.user.id,
                    code: code,
                    code_type: 'email',
                    expires_at: expiresAt.toISOString()
                });

            if (dbError) {
                console.error('Erro ao salvar código no banco:', dbError);
                throw new Error('Falha ao salvar código de verificação');
            }

            // Enviar email
            const emailResult = await this.resend.emails.send({
                from: `${this.config.fromName} <${this.config.fromEmail}>`,
                to: [userEmail],
                subject: 'Código de Verificação - Nexus Gestão',
                html: this.generateEmailTemplate(code, userName, this.config.codeExpiryMinutes)
            });

            if (emailResult.error) {
                console.error('Erro ao enviar email:', emailResult.error);
                throw new Error('Falha ao enviar email de verificação');
            }

            return {
                success: true,
                message: 'Código enviado por email',
                expiresAt: expiresAt
            };

        } catch (error) {
            console.error('Erro no envio de código por email:', error);
            throw error;
        }
    }

    // Template de email para código 2FA
    generateEmailTemplate(code, userName, expiryMinutes) {
        return `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Código de Verificação</title>
            <style>
                body { font-family: 'Inter', Arial, sans-serif; margin: 0; padding: 0; background-color: #0f172a; color: #ffffff; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { text-align: center; padding: 20px 0; border-bottom: 1px solid #1e293b; }
                .logo { font-size: 24px; font-weight: bold; color: #3b82f6; }
                .content { padding: 30px 0; text-align: center; }
                .code-box { background: linear-gradient(90deg, #1e40af 0%, #3b82f6 100%); padding: 20px; border-radius: 10px; margin: 20px 0; display: inline-block; }
                .code { font-size: 32px; font-weight: bold; letter-spacing: 5px; color: white; font-family: monospace; }
                .warning { background-color: #1e293b; padding: 15px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #f59e0b; }
                .footer { text-align: center; padding: 20px 0; border-top: 1px solid #1e293b; font-size: 12px; color: #64748b; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <div class="logo">🔐 ${this.config.fromName}</div>
                </div>
                
                <div class="content">
                    <h1>Código de Verificação</h1>
                    <p>Olá${userName ? ` ${userName}` : ''},</p>
                    <p>Use o código abaixo para completar sua autenticação:</p>
                    
                    <div class="code-box">
                        <div class="code">${code}</div>
                    </div>
                    
                    <p>Este código expira em <strong>${expiryMinutes} minutos</strong>.</p>
                    
                    <div class="warning">
                        <strong>⚠️ Importante:</strong><br>
                        • Nunca compartilhe este código com ninguém<br>
                        • Se você não solicitou este código, ignore este email<br>
                        • Este código só pode ser usado uma vez
                    </div>
                </div>
                
                <div class="footer">
                    <p>Este é um email automático. Não responda a esta mensagem.</p>
                    <p>&copy; 2025 ${this.config.fromName}. Todos os direitos reservados.</p>
                </div>
            </div>
        </body>
        </html>
        `;
    }

    // Verificar código de email
    async verifyEmailCode(code, userId = null) {
        try {
            // Se não foi fornecido userId, pegar do usuário autenticado
            if (!userId) {
                const { data: user } = await this.supabase.auth.getUser();
                if (!user?.user?.id) {
                    throw new Error('Usuário não autenticado');
                }
                userId = user.user.id;
            }

            // Buscar código válido no banco
            const { data: codeData, error } = await this.supabase
                .from('temp_2fa_codes')
                .select('*')
                .eq('user_id', userId)
                .eq('code', code)
                .eq('code_type', 'email')
                .is('used_at', null)
                .gt('expires_at', new Date().toISOString())
                .order('created_at', { ascending: false })
                .limit(1)
                .single();

            if (error || !codeData) {
                return { success: false, message: 'Código inválido ou expirado' };
            }

            // Marcar código como usado
            const { error: updateError } = await this.supabase
                .from('temp_2fa_codes')
                .update({ used_at: new Date().toISOString() })
                .eq('id', codeData.id);

            if (updateError) {
                console.error('Erro ao marcar código como usado:', updateError);
            }

            return { success: true, message: 'Código verificado com sucesso' };

        } catch (error) {
            console.error('Erro na verificação do código:', error);
            return { success: false, message: 'Erro interno na verificação' };
        }
    }

    // Configurar 2FA para um usuário
    async setup2FA(userId, userEmail) {
        try {
            // Gerar secret TOTP
            const totpData = this.generateTOTPSecret(userEmail);
            
            // Gerar códigos de backup
            const { data: backupCodes, error: backupError } = await this.supabase
                .rpc('generate_backup_codes', { user_uuid: userId });

            if (backupError) {
                console.error('Erro ao gerar códigos de backup:', backupError);
                throw new Error('Falha ao gerar códigos de backup');
            }

            // Gerar QR Code
            const qrCodeUrl = await this.generateQRCode(totpData.otpauthUrl);

            // Salvar configurações no banco (ainda não habilitado)
            const { error: dbError } = await this.supabase
                .from('user_2fa_settings')
                .upsert({
                    user_id: userId,
                    secret_key: totpData.secret,
                    backup_codes: backupCodes,
                    is_enabled: false // Será habilitado após verificação
                });

            if (dbError) {
                console.error('Erro ao salvar configurações 2FA:', dbError);
                throw new Error('Falha ao salvar configurações');
            }

            return {
                secret: totpData.secret,
                qrCodeUrl: qrCodeUrl,
                backupCodes: backupCodes,
                manualEntryKey: totpData.secret
            };

        } catch (error) {
            console.error('Erro no setup 2FA:', error);
            throw error;
        }
    }

    // Ativar 2FA após verificação
    async enable2FA(userId, verificationCode) {
        try {
            // Buscar configurações do usuário
            const { data: settings, error } = await this.supabase
                .from('user_2fa_settings')
                .select('secret_key')
                .eq('user_id', userId)
                .single();

            if (error || !settings) {
                throw new Error('Configurações 2FA não encontradas');
            }

            // Verificar código TOTP
            const isValid = this.verifyTOTP(settings.secret_key, verificationCode);
            
            if (!isValid) {
                return { success: false, message: 'Código de verificação inválido' };
            }

            // Ativar 2FA
            const { error: updateError } = await this.supabase
                .from('user_2fa_settings')
                .update({ is_enabled: true })
                .eq('user_id', userId);

            if (updateError) {
                console.error('Erro ao ativar 2FA:', updateError);
                throw new Error('Falha ao ativar 2FA');
            }

            return { success: true, message: '2FA ativado com sucesso' };

        } catch (error) {
            console.error('Erro ao ativar 2FA:', error);
            throw error;
        }
    }

    // Desativar 2FA
    async disable2FA(userId, verificationCode) {
        try {
            // Buscar configurações do usuário
            const { data: settings, error } = await this.supabase
                .from('user_2fa_settings')
                .select('*')
                .eq('user_id', userId)
                .eq('is_enabled', true)
                .single();

            if (error || !settings) {
                throw new Error('2FA não está ativado para este usuário');
            }

            // Verificar código (TOTP ou backup)
            let isValid = false;
            
            // Tentar TOTP primeiro
            if (verificationCode.length === 6 && /^\d+$/.test(verificationCode)) {
                isValid = this.verifyTOTP(settings.secret_key, verificationCode);
            }
            
            // Se não for TOTP válido, tentar código de backup
            if (!isValid && verificationCode.length === 8) {
                const { data: backupValid } = await this.supabase
                    .rpc('verify_backup_code', { 
                        user_uuid: userId, 
                        input_code: verificationCode 
                    });
                isValid = backupValid;
            }

            if (!isValid) {
                return { success: false, message: 'Código de verificação inválido' };
            }

            // Desativar 2FA e limpar dados
            const { error: updateError } = await this.supabase
                .from('user_2fa_settings')
                .update({ 
                    is_enabled: false,
                    secret_key: null,
                    backup_codes: null
                })
                .eq('user_id', userId);

            if (updateError) {
                console.error('Erro ao desativar 2FA:', updateError);
                throw new Error('Falha ao desativar 2FA');
            }

            return { success: true, message: '2FA desativado com sucesso' };

        } catch (error) {
            console.error('Erro ao desativar 2FA:', error);
            throw error;
        }
    }

    // Verificar se usuário tem 2FA ativado
    async is2FAEnabled(userId) {
        try {
            const { data, error } = await this.supabase
                .from('user_2fa_settings')
                .select('is_enabled')
                .eq('user_id', userId)
                .single();

            if (error) {
                return false;
            }

            return data?.is_enabled || false;
        } catch (error) {
            console.error('Erro ao verificar status 2FA:', error);
            return false;
        }
    }

    // Verificar qualquer tipo de código 2FA (TOTP, email, backup)
    async verify2FACode(userId, code, codeType = 'auto') {
        try {
            const { data: settings, error } = await this.supabase
                .from('user_2fa_settings')
                .select('*')
                .eq('user_id', userId)
                .eq('is_enabled', true)
                .single();

            if (error || !settings) {
                return { success: false, message: '2FA não está configurado' };
            }

            let isValid = false;
            let usedMethod = '';

            // Auto-detectar tipo de código ou usar tipo especificado
            if (codeType === 'auto' || codeType === 'totp') {
                if (code.length === 6 && /^\d+$/.test(code)) {
                    isValid = this.verifyTOTP(settings.secret_key, code);
                    if (isValid) usedMethod = 'totp';
                }
            }

            if (!isValid && (codeType === 'auto' || codeType === 'email')) {
                const emailResult = await this.verifyEmailCode(code, userId);
                if (emailResult.success) {
                    isValid = true;
                    usedMethod = 'email';
                }
            }

            if (!isValid && (codeType === 'auto' || codeType === 'backup')) {
                if (code.length === 8) {
                    const { data: backupValid } = await this.supabase
                        .rpc('verify_backup_code', { 
                            user_uuid: userId, 
                            input_code: code 
                        });
                    if (backupValid) {
                        isValid = true;
                        usedMethod = 'backup';
                    }
                }
            }

            // Registrar tentativa
            await this.supabase
                .from('user_2fa_attempts')
                .insert({
                    user_id: userId,
                    attempt_type: usedMethod || 'unknown',
                    success: isValid
                });

            return {
                success: isValid,
                message: isValid ? 'Código verificado com sucesso' : 'Código inválido',
                method: usedMethod
            };

        } catch (error) {
            console.error('Erro na verificação 2FA:', error);
            return { success: false, message: 'Erro interno na verificação' };
        }
    }

    // Limpar códigos expirados (função de manutenção)
    async cleanupExpiredCodes() {
        try {
            const { error } = await this.supabase
                .rpc('cleanup_expired_2fa_codes');

            if (error) {
                console.error('Erro ao limpar códigos expirados:', error);
            }
        } catch (error) {
            console.error('Erro na limpeza de códigos:', error);
        }
    }
}

// Exportar para uso no navegador e Node.js
if (typeof module !== 'undefined' && module.exports) {
    module.exports = TwoFactorAuthService;
} else {
    window.TwoFactorAuthService = TwoFactorAuthService;
}