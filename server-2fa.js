const express = require('express');
const speakeasy = require('speakeasy');
const QRCode = require('qrcode');
const bodyParser = require('body-parser');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Servir arquivos estáticos
app.use(express.static('.'));

// Armazenamento temporário em memória (em produção, use banco de dados)
const tempSecrets = new Map();

/**
 * Rota para gerar secret e QR Code para configuração 2FA
 * POST /api/2fa/setup
 * Body: { userEmail: string, companyName?: string }
 */
app.post('/api/2fa/setup', async (req, res) => {
    try {
        const { userEmail, companyName = 'Nexus' } = req.body;
        
        if (!userEmail) {
            return res.status(400).json({ 
                success: false, 
                error: 'Email do usuário é obrigatório' 
            });
        }

        // Gerar secret usando speakeasy - Compatível com Google Authenticator
        const secret = speakeasy.generateSecret({
            name: `${companyName}:${userEmail}`,
            issuer: companyName,
            length: 20, // Google Authenticator usa 20 bytes (160 bits)
            algorithm: 'sha1' // Google Authenticator usa SHA1
        });

        // Gerar códigos de backup
        const backupCodes = generateBackupCodes();

        // Armazenar temporariamente (em produção, salvar no banco)
        tempSecrets.set(userEmail, {
            secret: secret.base32,
            backupCodes: backupCodes,
            verified: false,
            createdAt: new Date()
        });

        // Gerar QR Code
        const qrCodeDataURL = await QRCode.toDataURL(secret.otpauth_url);

        res.json({
            success: true,
            data: {
                secret: secret.base32,
                qrCode: qrCodeDataURL,
                manualEntryKey: secret.base32,
                backupCodes: backupCodes,
                otpauthUrl: secret.otpauth_url
            }
        });

    } catch (error) {
        console.error('Erro ao configurar 2FA:', error);
        res.status(500).json({ 
            success: false, 
            error: 'Erro interno do servidor' 
        });
    }
});

/**
 * Rota para verificar código TOTP durante a configuração
 * POST /api/2fa/verify-setup
 * Body: { userEmail: string, token: string }
 */
app.post('/api/2fa/verify-setup', (req, res) => {
    try {
        const { userEmail, token } = req.body;

        if (!userEmail || !token) {
            return res.status(400).json({ 
                success: false, 
                error: 'Email e token são obrigatórios' 
            });
        }

        const userData = tempSecrets.get(userEmail);
        if (!userData) {
            return res.status(400).json({ 
                success: false, 
                error: 'Configuração não encontrada. Inicie o processo novamente.' 
            });
        }

        // Verificar token usando speakeasy - Compatível com Google Authenticator
        const verified = speakeasy.totp.verify({
            secret: userData.secret,
            encoding: 'base32',
            token: token,
            window: 1, // Google Authenticator usa janela de ±30 segundos
            step: 30, // Período de 30 segundos (padrão do Google Authenticator)
            algorithm: 'sha1' // Google Authenticator usa SHA1
        });

        if (verified) {
            // Marcar como verificado
            userData.verified = true;
            tempSecrets.set(userEmail, userData);

            res.json({
                success: true,
                message: '2FA configurado com sucesso',
                data: {
                    secret: userData.secret,
                    backupCodes: userData.backupCodes
                }
            });
        } else {
            res.status(400).json({ 
                success: false, 
                error: 'Código inválido. Verifique o código no seu aplicativo autenticador.' 
            });
        }

    } catch (error) {
        console.error('Erro ao verificar configuração 2FA:', error);
        res.status(500).json({ 
            success: false, 
            error: 'Erro interno do servidor' 
        });
    }
});

/**
 * Rota para verificar código TOTP no login
 * POST /api/2fa/verify-login
 * Body: { secret: string, token: string }
 */
app.post('/api/2fa/verify-login', (req, res) => {
    try {
        const { secret, token } = req.body;

        if (!secret || !token) {
            return res.status(400).json({ 
                success: false, 
                error: 'Secret e token são obrigatórios' 
            });
        }

        // Verificar token usando speakeasy - Compatível com Google Authenticator
        const verified = speakeasy.totp.verify({
            secret: secret,
            encoding: 'base32',
            token: token,
            window: 1, // Google Authenticator usa janela de ±30 segundos
            step: 30, // Período de 30 segundos (padrão do Google Authenticator)
            algorithm: 'sha1' // Google Authenticator usa SHA1
        });

        res.json({
            success: true,
            verified: verified,
            message: verified ? 'Código válido' : 'Código inválido'
        });

    } catch (error) {
        console.error('Erro ao verificar login 2FA:', error);
        res.status(500).json({ 
            success: false, 
            error: 'Erro interno do servidor' 
        });
    }
});

/**
 * Rota para verificar código de backup
 * POST /api/2fa/verify-backup
 * Body: { userEmail: string, backupCode: string, allBackupCodes: string[] }
 */
app.post('/api/2fa/verify-backup', (req, res) => {
    try {
        const { userEmail, backupCode, allBackupCodes } = req.body;

        if (!userEmail || !backupCode || !allBackupCodes) {
            return res.status(400).json({ 
                success: false, 
                error: 'Todos os campos são obrigatórios' 
            });
        }

        // Verificar se o código está na lista
        const codeIndex = allBackupCodes.indexOf(backupCode);
        
        if (codeIndex === -1) {
            return res.status(400).json({ 
                success: false, 
                error: 'Código de backup inválido' 
            });
        }

        // Remover código usado da lista
        const updatedBackupCodes = [...allBackupCodes];
        updatedBackupCodes.splice(codeIndex, 1);

        res.json({
            success: true,
            verified: true,
            message: 'Código de backup válido',
            data: {
                updatedBackupCodes: updatedBackupCodes
            }
        });

    } catch (error) {
        console.error('Erro ao verificar código de backup:', error);
        res.status(500).json({ 
            success: false, 
            error: 'Erro interno do servidor' 
        });
    }
});

/**
 * Rota para gerar novo QR Code (caso necessário)
 * POST /api/2fa/generate-qr
 * Body: { secret: string, userEmail: string, companyName?: string }
 */
app.post('/api/2fa/generate-qr', async (req, res) => {
    try {
        const { secret, userEmail, companyName = 'Nexus' } = req.body;

        if (!secret || !userEmail) {
            return res.status(400).json({ 
                success: false, 
                error: 'Secret e email são obrigatórios' 
            });
        }

        // Criar URL otpauth - Compatível com Google Authenticator
        const otpauthUrl = speakeasy.otpauthURL({
            secret: secret,
            label: `${companyName}:${userEmail}`,
            issuer: companyName,
            encoding: 'base32',
            algorithm: 'sha1', // Google Authenticator usa SHA1
            digits: 6, // Google Authenticator usa 6 dígitos
            period: 30 // Google Authenticator usa período de 30 segundos
        });

        // Gerar QR Code
        const qrCodeDataURL = await QRCode.toDataURL(otpauthUrl);

        res.json({
            success: true,
            data: {
                qrCode: qrCodeDataURL,
                otpauthUrl: otpauthUrl,
                manualEntryKey: secret
            }
        });

    } catch (error) {
        console.error('Erro ao gerar QR Code:', error);
        res.status(500).json({ 
            success: false, 
            error: 'Erro interno do servidor' 
        });
    }
});

/**
 * Rota para limpar dados temporários
 * DELETE /api/2fa/cleanup/:userEmail
 */
app.delete('/api/2fa/cleanup/:userEmail', (req, res) => {
    try {
        const { userEmail } = req.params;
        
        if (tempSecrets.has(userEmail)) {
            tempSecrets.delete(userEmail);
        }

        res.json({
            success: true,
            message: 'Dados temporários removidos'
        });

    } catch (error) {
        console.error('Erro ao limpar dados:', error);
        res.status(500).json({ 
            success: false, 
            error: 'Erro interno do servidor' 
        });
    }
});

/**
 * Rota de status da API
 * GET /api/2fa/status
 */
app.get('/api/2fa/status', (req, res) => {
    res.json({
        success: true,
        message: 'API 2FA funcionando',
        timestamp: new Date().toISOString(),
        tempSecretsCount: tempSecrets.size
    });
});

// Função auxiliar para gerar códigos de backup
function generateBackupCodes(count = 10) {
    const codes = [];
    
    for (let i = 0; i < count; i++) {
        // Gerar código de 8 dígitos
        const code = Math.floor(Math.random() * 100000000).toString().padStart(8, '0');
        codes.push(code);
    }
    
    return codes;
}

// Limpeza automática de dados temporários (a cada hora)
setInterval(() => {
    const now = new Date();
    const oneHourAgo = new Date(now.getTime() - 60 * 60 * 1000);
    
    for (const [email, data] of tempSecrets.entries()) {
        if (data.createdAt < oneHourAgo) {
            tempSecrets.delete(email);
            console.log(`Dados temporários removidos para: ${email}`);
        }
    }
}, 60 * 60 * 1000); // A cada hora

// Rota para servir a página principal
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Iniciar servidor
app.listen(PORT, () => {
    console.log(`🚀 Servidor 2FA rodando na porta ${PORT}`);
    console.log(`📱 API 2FA disponível em: http://localhost:${PORT}/api/2fa/status`);
    console.log(`🌐 Interface web em: http://localhost:${PORT}`);
});

module.exports = app;