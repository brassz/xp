/**
 * Módulo para gerenciamento de 2FA (Two-Factor Authentication)
 * Utiliza TOTP (Time-based One-Time Password) compatível com Google Authenticator, Authy, etc.
 */

class TwoFactorAuth {
    constructor() {
        this.appName = 'Nexus Financial';
        this.issuer = 'Nexus';
    }

    /**
     * Gera um secret aleatório para o usuário
     * @returns {string} Secret em base32
     */
    generateSecret() {
        // Gerar 20 bytes aleatórios e converter para base32
        const buffer = new Uint8Array(20);
        crypto.getRandomValues(buffer);
        return this.base32Encode(buffer);
    }

    /**
     * Converte bytes para base32
     * @param {Uint8Array} bytes 
     * @returns {string}
     */
    base32Encode(bytes) {
        const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
        let result = '';
        let bits = 0;
        let value = 0;

        for (let i = 0; i < bytes.length; i++) {
            value = (value << 8) | bytes[i];
            bits += 8;

            while (bits >= 5) {
                result += alphabet[(value >>> (bits - 5)) & 31];
                bits -= 5;
            }
        }

        if (bits > 0) {
            result += alphabet[(value << (5 - bits)) & 31];
        }

        return result;
    }

    /**
     * Converte base32 para bytes
     * @param {string} base32 
     * @returns {Uint8Array}
     */
    base32Decode(base32) {
        const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
        const cleanInput = base32.toUpperCase().replace(/[^A-Z2-7]/g, '');
        
        let bits = 0;
        let value = 0;
        const output = [];

        for (let i = 0; i < cleanInput.length; i++) {
            const index = alphabet.indexOf(cleanInput[i]);
            if (index === -1) continue;

            value = (value << 5) | index;
            bits += 5;

            if (bits >= 8) {
                output.push((value >>> (bits - 8)) & 255);
                bits -= 8;
            }
        }

        return new Uint8Array(output);
    }

    /**
     * Gera código TOTP de 6 dígitos
     * @param {string} secret - Secret em base32
     * @param {number} timeStep - Timestamp (opcional, usa atual se não fornecido)
     * @returns {string} Código de 6 dígitos
     */
    async generateTOTP(secret, timeStep = null) {
        const time = timeStep || Math.floor(Date.now() / 1000 / 30);
        const secretBytes = this.base32Decode(secret);
        
        // Converter time para 8 bytes big-endian
        const timeBuffer = new ArrayBuffer(8);
        const timeView = new DataView(timeBuffer);
        timeView.setUint32(4, time, false); // big-endian

        // HMAC-SHA1
        const key = await crypto.subtle.importKey(
            'raw',
            secretBytes,
            { name: 'HMAC', hash: 'SHA-1' },
            false,
            ['sign']
        );

        const signature = await crypto.subtle.sign('HMAC', key, timeBuffer);
        const signatureArray = new Uint8Array(signature);

        // Dynamic truncation
        const offset = signatureArray[19] & 0xf;
        const code = (
            ((signatureArray[offset] & 0x7f) << 24) |
            ((signatureArray[offset + 1] & 0xff) << 16) |
            ((signatureArray[offset + 2] & 0xff) << 8) |
            (signatureArray[offset + 3] & 0xff)
        ) % 1000000;

        return code.toString().padStart(6, '0');
    }

    /**
     * Verifica se um código TOTP é válido
     * @param {string} token - Código de 6 dígitos fornecido pelo usuário
     * @param {string} secret - Secret em base32
     * @param {number} window - Janela de tolerância (padrão: 1 = ±30s)
     * @returns {boolean}
     */
    async verifyTOTP(token, secret, window = 1) {
        const currentTime = Math.floor(Date.now() / 1000 / 30);
        
        for (let i = -window; i <= window; i++) {
            const timeStep = currentTime + i;
            const validToken = await this.generateTOTP(secret, timeStep);
            
            if (token === validToken) {
                return true;
            }
        }
        
        return false;
    }

    /**
     * Gera URL para QR Code compatível com Google Authenticator
     * @param {string} secret - Secret em base32
     * @param {string} userEmail - Email do usuário
     * @param {string} companyName - Nome da empresa (opcional)
     * @returns {string} URL otpauth://
     */
    generateQRCodeURL(secret, userEmail, companyName = '') {
        const label = companyName ? `${companyName}:${userEmail}` : userEmail;
        const params = new URLSearchParams({
            secret: secret,
            issuer: this.issuer,
            algorithm: 'SHA1',
            digits: '6',
            period: '30'
        });

        return `otpauth://totp/${encodeURIComponent(label)}?${params.toString()}`;
    }

    /**
     * Gera códigos de backup para recuperação
     * @param {number} count - Número de códigos (padrão: 10)
     * @returns {string[]} Array de códigos de backup
     */
    generateBackupCodes(count = 10) {
        const codes = [];
        
        for (let i = 0; i < count; i++) {
            // Gerar código de 8 dígitos
            const code = Math.floor(Math.random() * 100000000).toString().padStart(8, '0');
            codes.push(code);
        }
        
        return codes;
    }

    /**
     * Renderiza QR Code no canvas
     * @param {string} text - Texto para o QR Code
     * @param {HTMLCanvasElement} canvas - Elemento canvas
     */
    async renderQRCode(text, canvas) {
        try {
            const size = 200;
            canvas.width = size;
            canvas.height = size;

            // Usar a biblioteca QRCode.js
            await QRCode.toCanvas(canvas, text, {
                width: size,
                margin: 2,
                color: {
                    dark: '#000000',
                    light: '#FFFFFF'
                }
            });
        } catch (error) {
            console.error('Erro ao gerar QR Code:', error);
            
            // Fallback em caso de erro
            const ctx = canvas.getContext('2d');
            const size = 200;
            canvas.width = size;
            canvas.height = size;

            ctx.fillStyle = '#f0f0f0';
            ctx.fillRect(0, 0, size, size);
            
            ctx.fillStyle = '#333';
            ctx.font = '12px Arial';
            ctx.textAlign = 'center';
            ctx.fillText('Erro ao gerar QR Code', size/2, size/2 - 10);
            ctx.fillText('Use o código manual', size/2, size/2 + 10);
        }
    }
}

// Instância global
window.twoFactorAuth = new TwoFactorAuth();