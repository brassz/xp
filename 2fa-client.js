/**
 * Cliente JavaScript para integração com API 2FA
 * Compatível com Google Authenticator
 */

class TwoFactorClient {
    constructor(apiBaseUrl = 'http://localhost:3001/api/2fa') {
        this.apiBaseUrl = apiBaseUrl;
    }

    /**
     * Configurar 2FA para um usuário
     * @param {string} userEmail - Email do usuário
     * @param {string} companyName - Nome da empresa (opcional)
     * @returns {Promise<Object>} Dados de configuração incluindo QR Code
     */
    async setupTwoFactor(userEmail, companyName = 'Nexus') {
        try {
            const response = await fetch(`${this.apiBaseUrl}/setup`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    userEmail: userEmail,
                    companyName: companyName
                })
            });

            const data = await response.json();
            
            if (!data.success) {
                throw new Error(data.error || 'Erro ao configurar 2FA');
            }

            return data.data;
        } catch (error) {
            console.error('Erro ao configurar 2FA:', error);
            throw error;
        }
    }

    /**
     * Verificar código durante a configuração
     * @param {string} userEmail - Email do usuário
     * @param {string} token - Código de 6 dígitos
     * @returns {Promise<Object>} Resultado da verificação
     */
    async verifySetup(userEmail, token) {
        try {
            const response = await fetch(`${this.apiBaseUrl}/verify-setup`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    userEmail: userEmail,
                    token: token
                })
            });

            const data = await response.json();
            
            if (!data.success) {
                throw new Error(data.error || 'Erro ao verificar código');
            }

            return data;
        } catch (error) {
            console.error('Erro ao verificar configuração:', error);
            throw error;
        }
    }

    /**
     * Verificar código no login
     * @param {string} secret - Secret do usuário
     * @param {string} token - Código de 6 dígitos
     * @returns {Promise<boolean>} True se o código for válido
     */
    async verifyLogin(secret, token) {
        try {
            const response = await fetch(`${this.apiBaseUrl}/verify-login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    secret: secret,
                    token: token
                })
            });

            const data = await response.json();
            
            if (!data.success) {
                throw new Error(data.error || 'Erro ao verificar login');
            }

            return data.verified;
        } catch (error) {
            console.error('Erro ao verificar login:', error);
            throw error;
        }
    }

    /**
     * Verificar código de backup
     * @param {string} userEmail - Email do usuário
     * @param {string} backupCode - Código de backup
     * @param {string[]} allBackupCodes - Todos os códigos de backup
     * @returns {Promise<Object>} Resultado da verificação
     */
    async verifyBackupCode(userEmail, backupCode, allBackupCodes) {
        try {
            const response = await fetch(`${this.apiBaseUrl}/verify-backup`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    userEmail: userEmail,
                    backupCode: backupCode,
                    allBackupCodes: allBackupCodes
                })
            });

            const data = await response.json();
            
            if (!data.success) {
                throw new Error(data.error || 'Erro ao verificar código de backup');
            }

            return data;
        } catch (error) {
            console.error('Erro ao verificar código de backup:', error);
            throw error;
        }
    }

    /**
     * Gerar novo QR Code
     * @param {string} secret - Secret do usuário
     * @param {string} userEmail - Email do usuário
     * @param {string} companyName - Nome da empresa (opcional)
     * @returns {Promise<Object>} Dados do QR Code
     */
    async generateQRCode(secret, userEmail, companyName = 'Nexus') {
        try {
            const response = await fetch(`${this.apiBaseUrl}/generate-qr`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    secret: secret,
                    userEmail: userEmail,
                    companyName: companyName
                })
            });

            const data = await response.json();
            
            if (!data.success) {
                throw new Error(data.error || 'Erro ao gerar QR Code');
            }

            return data.data;
        } catch (error) {
            console.error('Erro ao gerar QR Code:', error);
            throw error;
        }
    }

    /**
     * Limpar dados temporários
     * @param {string} userEmail - Email do usuário
     * @returns {Promise<void>}
     */
    async cleanup(userEmail) {
        try {
            const response = await fetch(`${this.apiBaseUrl}/cleanup/${encodeURIComponent(userEmail)}`, {
                method: 'DELETE'
            });

            const data = await response.json();
            
            if (!data.success) {
                console.warn('Aviso ao limpar dados:', data.error);
            }
        } catch (error) {
            console.warn('Erro ao limpar dados temporários:', error);
        }
    }

    /**
     * Verificar status da API
     * @returns {Promise<Object>} Status da API
     */
    async getStatus() {
        try {
            const response = await fetch(`${this.apiBaseUrl}/status`);
            const data = await response.json();
            return data;
        } catch (error) {
            console.error('Erro ao verificar status da API:', error);
            throw error;
        }
    }

    /**
     * Renderizar QR Code em um elemento img
     * @param {string} qrCodeDataURL - Data URL do QR Code
     * @param {HTMLImageElement} imgElement - Elemento img
     */
    renderQRCodeToImage(qrCodeDataURL, imgElement) {
        imgElement.src = qrCodeDataURL;
        imgElement.alt = 'QR Code para Google Authenticator';
    }

    /**
     * Renderizar QR Code em um canvas
     * @param {string} qrCodeDataURL - Data URL do QR Code
     * @param {HTMLCanvasElement} canvasElement - Elemento canvas
     */
    renderQRCodeToCanvas(qrCodeDataURL, canvasElement) {
        const ctx = canvasElement.getContext('2d');
        const img = new Image();
        
        img.onload = function() {
            canvasElement.width = img.width;
            canvasElement.height = img.height;
            ctx.drawImage(img, 0, 0);
        };
        
        img.src = qrCodeDataURL;
    }

    /**
     * Validar formato do token (6 dígitos)
     * @param {string} token - Token a ser validado
     * @returns {boolean} True se o formato for válido
     */
    validateTokenFormat(token) {
        return /^\d{6}$/.test(token);
    }

    /**
     * Validar formato do código de backup (8 dígitos)
     * @param {string} code - Código a ser validado
     * @returns {boolean} True se o formato for válido
     */
    validateBackupCodeFormat(code) {
        return /^\d{8}$/.test(code);
    }

    /**
     * Formatar token (adicionar espaços para melhor legibilidade)
     * @param {string} token - Token a ser formatado
     * @returns {string} Token formatado
     */
    formatToken(token) {
        if (token.length === 6) {
            return `${token.slice(0, 3)} ${token.slice(3)}`;
        }
        return token;
    }
}

// Instância global para uso no frontend
window.twoFactorClient = new TwoFactorClient();

// Exportar para uso em módulos
if (typeof module !== 'undefined' && module.exports) {
    module.exports = TwoFactorClient;
}