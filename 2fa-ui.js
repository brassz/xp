// Interface de usuário para 2FA - Nexus Gestão Financeira

class TwoFactorUI {
    constructor() {
        this.twoFactorService = null;
        this.currentUser = null;
        this.setupEventListeners();
    }

    // Inicializar com o serviço de 2FA
    init(supabaseClient, config = {}) {
        this.twoFactorService = new TwoFactorAuthService(supabaseClient, config);
        this.loadUserStatus();
    }

    // Configurar event listeners
    setupEventListeners() {
        // Menu dropdown do usuário
        document.addEventListener('click', (e) => {
            if (e.target.closest('#userMenuBtn')) {
                this.toggleUserDropdown();
            } else if (!e.target.closest('#userDropdown')) {
                this.closeUserDropdown();
            }
        });

        // Botão de configurar 2FA
        document.addEventListener('click', (e) => {
            if (e.target.closest('#setup2FABtn')) {
                this.openSetup2FAModal();
            }
        });

        // Fechar modais com ESC
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.closeAllModals();
            }
        });
    }

    // Toggle do dropdown do usuário
    toggleUserDropdown() {
        const dropdown = document.getElementById('userDropdown');
        dropdown.classList.toggle('hidden');
    }

    // Fechar dropdown do usuário
    closeUserDropdown() {
        const dropdown = document.getElementById('userDropdown');
        dropdown.classList.add('hidden');
    }

    // Fechar todos os modais
    closeAllModals() {
        document.getElementById('twoFactorModal').classList.add('hidden');
        document.getElementById('setup2FAModal').classList.add('hidden');
    }

    // Carregar status do usuário
    async loadUserStatus() {
        if (!this.twoFactorService || !this.currentUser) return;

        try {
            const isEnabled = await this.twoFactorService.is2FAEnabled(this.currentUser.id);
            this.updateStatusIndicator(isEnabled);
        } catch (error) {
            console.error('Erro ao carregar status 2FA:', error);
        }
    }

    // Atualizar indicador de status
    updateStatusIndicator(isEnabled) {
        const statusElement = document.getElementById('twoFAStatus');
        if (statusElement) {
            if (isEnabled) {
                statusElement.textContent = 'Ativado';
                statusElement.className = 'ml-auto text-xs px-2 py-1 rounded-full bg-green-600 text-white';
            } else {
                statusElement.textContent = 'Desativado';
                statusElement.className = 'ml-auto text-xs px-2 py-1 rounded-full bg-gray-600 text-gray-300';
            }
        }
    }

    // Definir usuário atual
    setCurrentUser(user) {
        this.currentUser = user;
        this.updateUserInfo(user);
        this.loadUserStatus();
    }

    // Atualizar informações do usuário na interface
    updateUserInfo(user) {
        const userName = document.getElementById('userName');
        const userInitial = document.getElementById('userInitial');
        const dropdownUserName = document.getElementById('dropdownUserName');
        const dropdownUserEmail = document.getElementById('dropdownUserEmail');

        if (userName) userName.textContent = user.user_metadata?.full_name || user.email.split('@')[0];
        if (userInitial) userInitial.textContent = (user.user_metadata?.full_name || user.email)[0].toUpperCase();
        if (dropdownUserName) dropdownUserName.textContent = user.user_metadata?.full_name || user.email.split('@')[0];
        if (dropdownUserEmail) dropdownUserEmail.textContent = user.email;
    }

    // Abrir modal de configuração 2FA
    async openSetup2FAModal() {
        if (!this.twoFactorService || !this.currentUser) {
            this.showError('Erro: Serviço não inicializado');
            return;
        }

        const modal = document.getElementById('setup2FAModal');
        const content = document.getElementById('setup2FAContent');

        try {
            const isEnabled = await this.twoFactorService.is2FAEnabled(this.currentUser.id);
            
            if (isEnabled) {
                content.innerHTML = this.getDisable2FAContent();
            } else {
                content.innerHTML = this.getSetup2FAContent();
            }

            modal.classList.remove('hidden');
            this.closeUserDropdown();
        } catch (error) {
            console.error('Erro ao abrir modal 2FA:', error);
            this.showError('Erro ao carregar configurações de 2FA');
        }
    }

    // Conteúdo para configurar 2FA
    getSetup2FAContent() {
        return `
            <div id="setup2FAStep1">
                <div class="mb-6">
                    <h3 class="text-lg font-semibold text-white mb-2">Escolha o método de autenticação</h3>
                    <p class="text-gray-300 text-sm">Selecione como você deseja receber os códigos de verificação:</p>
                </div>

                <div class="space-y-4 mb-6">
                    <button onclick="twoFactorUI.setupTOTP()" class="w-full p-4 bg-gray-700 hover:bg-gray-600 rounded-lg border border-gray-600 transition-all">
                        <div class="flex items-center">
                            <div class="w-12 h-12 bg-blue-600 rounded-lg flex items-center justify-center mr-4">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z"></path>
                                </svg>
                            </div>
                            <div class="text-left">
                                <h4 class="text-white font-medium">App Autenticador</h4>
                                <p class="text-gray-400 text-sm">Google Authenticator, Authy, etc.</p>
                            </div>
                        </div>
                    </button>

                    <button onclick="twoFactorUI.setupEmail()" class="w-full p-4 bg-gray-700 hover:bg-gray-600 rounded-lg border border-gray-600 transition-all">
                        <div class="flex items-center">
                            <div class="w-12 h-12 bg-green-600 rounded-lg flex items-center justify-center mr-4">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                                </svg>
                            </div>
                            <div class="text-left">
                                <h4 class="text-white font-medium">Código por Email</h4>
                                <p class="text-gray-400 text-sm">Receber códigos no seu email</p>
                            </div>
                        </div>
                    </button>
                </div>

                <div class="flex space-x-3">
                    <button onclick="twoFactorUI.closeAllModals()" class="flex-1 px-4 py-2 bg-gray-600 hover:bg-gray-500 text-white rounded-lg transition-all">
                        Cancelar
                    </button>
                </div>
            </div>
        `;
    }

    // Conteúdo para desativar 2FA
    getDisable2FAContent() {
        return `
            <div class="mb-6">
                <h3 class="text-lg font-semibold text-white mb-2">Desativar Autenticação 2FA</h3>
                <p class="text-gray-300 text-sm">Para desativar a autenticação de dois fatores, digite um código de verificação:</p>
            </div>

            <form onsubmit="twoFactorUI.disable2FA(event)" class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-300 mb-2">Código de Verificação</label>
                    <input type="text" id="disable2FACode" class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg text-white placeholder-gray-400 focus:ring-2 focus:ring-blue-500 focus:border-transparent" placeholder="Digite o código de 6 dígitos ou código de backup" maxlength="8" required>
                    <p class="text-xs text-gray-400 mt-1">Use um código do seu app autenticador ou um código de backup</p>
                </div>

                <div class="flex space-x-3">
                    <button type="button" onclick="twoFactorUI.closeAllModals()" class="flex-1 px-4 py-2 bg-gray-600 hover:bg-gray-500 text-white rounded-lg transition-all">
                        Cancelar
                    </button>
                    <button type="submit" class="flex-1 px-4 py-2 bg-red-600 hover:bg-red-500 text-white rounded-lg transition-all">
                        Desativar 2FA
                    </button>
                </div>
            </form>
        `;
    }

    // Configurar TOTP (Google Authenticator)
    async setupTOTP() {
        const content = document.getElementById('setup2FAContent');
        content.innerHTML = '<div class="text-center py-8"><div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto"></div><p class="text-gray-300 mt-2">Gerando configuração...</p></div>';

        try {
            const setupData = await this.twoFactorService.setup2FA(this.currentUser.id, this.currentUser.email);
            
            content.innerHTML = `
                <div class="mb-6">
                    <h3 class="text-lg font-semibold text-white mb-2">Configurar App Autenticador</h3>
                    <p class="text-gray-300 text-sm">Escaneie o QR Code com seu app autenticador ou digite a chave manualmente:</p>
                </div>

                <div class="mb-6">
                    <div class="bg-white p-4 rounded-lg text-center mb-4">
                        <div id="qrcode"></div>
                    </div>
                    
                    <div class="bg-gray-700 p-3 rounded-lg">
                        <p class="text-xs text-gray-400 mb-1">Chave manual:</p>
                        <p class="text-white font-mono text-sm break-all">${setupData.manualEntryKey}</p>
                    </div>
                </div>

                <form onsubmit="twoFactorUI.verifyTOTPSetup(event)" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-300 mb-2">Código de Verificação</label>
                        <input type="text" id="totpVerificationCode" class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg text-white placeholder-gray-400 focus:ring-2 focus:ring-blue-500 focus:border-transparent" placeholder="Digite o código de 6 dígitos" maxlength="6" required>
                        <p class="text-xs text-gray-400 mt-1">Digite o código gerado pelo seu app autenticador</p>
                    </div>

                    <div class="flex space-x-3">
                        <button type="button" onclick="twoFactorUI.openSetup2FAModal()" class="flex-1 px-4 py-2 bg-gray-600 hover:bg-gray-500 text-white rounded-lg transition-all">
                            Voltar
                        </button>
                        <button type="submit" class="flex-1 px-4 py-2 bg-blue-600 hover:bg-blue-500 text-white rounded-lg transition-all">
                            Ativar 2FA
                        </button>
                    </div>
                </form>

                <div class="mt-6 p-4 bg-yellow-900 bg-opacity-50 border border-yellow-600 rounded-lg">
                    <h4 class="text-yellow-400 font-medium mb-2">Códigos de Backup</h4>
                    <p class="text-yellow-200 text-sm mb-3">Guarde estes códigos em local seguro. Você pode usá-los se perder acesso ao seu dispositivo:</p>
                    <div class="grid grid-cols-2 gap-2 text-xs font-mono">
                        ${setupData.backupCodes.map(code => `<span class="bg-yellow-800 px-2 py-1 rounded text-yellow-100">${code}</span>`).join('')}
                    </div>
                </div>
            `;

            // Gerar QR Code
            QRCode.toCanvas(document.getElementById('qrcode'), setupData.qrCodeUrl, {
                width: 200,
                margin: 2,
                color: {
                    dark: '#000000',
                    light: '#FFFFFF'
                }
            });

        } catch (error) {
            console.error('Erro ao configurar TOTP:', error);
            this.showError('Erro ao configurar autenticação. Tente novamente.');
        }
    }

    // Configurar autenticação por email
    async setupEmail() {
        const content = document.getElementById('setup2FAContent');
        
        content.innerHTML = `
            <div class="mb-6">
                <h3 class="text-lg font-semibold text-white mb-2">Autenticação por Email</h3>
                <p class="text-gray-300 text-sm">Você receberá códigos de verificação no email: <strong>${this.currentUser.email}</strong></p>
            </div>

            <div class="mb-6 p-4 bg-blue-900 bg-opacity-50 border border-blue-600 rounded-lg">
                <h4 class="text-blue-400 font-medium mb-2">Como funciona:</h4>
                <ul class="text-blue-200 text-sm space-y-1">
                    <li>• Códigos de 6 dígitos enviados por email</li>
                    <li>• Válidos por 5 minutos</li>
                    <li>• Solicitados a cada login</li>
                </ul>
            </div>

            <form onsubmit="twoFactorUI.enableEmail2FA(event)" class="space-y-4">
                <div class="flex space-x-3">
                    <button type="button" onclick="twoFactorUI.openSetup2FAModal()" class="flex-1 px-4 py-2 bg-gray-600 hover:bg-gray-500 text-white rounded-lg transition-all">
                        Voltar
                    </button>
                    <button type="submit" class="flex-1 px-4 py-2 bg-green-600 hover:bg-green-500 text-white rounded-lg transition-all">
                        Ativar Email 2FA
                    </button>
                </div>
            </form>
        `;
    }

    // Verificar configuração TOTP
    async verifyTOTPSetup(event) {
        event.preventDefault();
        
        const code = document.getElementById('totpVerificationCode').value;
        const submitBtn = event.target.querySelector('button[type="submit"]');
        
        submitBtn.disabled = true;
        submitBtn.textContent = 'Verificando...';

        try {
            const result = await this.twoFactorService.enable2FA(this.currentUser.id, code);
            
            if (result.success) {
                this.showSuccess('2FA ativado com sucesso!');
                this.updateStatusIndicator(true);
                this.closeAllModals();
            } else {
                this.showError(result.message || 'Código inválido');
            }
        } catch (error) {
            console.error('Erro ao verificar TOTP:', error);
            this.showError('Erro na verificação. Tente novamente.');
        } finally {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Ativar 2FA';
        }
    }

    // Ativar 2FA por email
    async enableEmail2FA(event) {
        event.preventDefault();
        
        const submitBtn = event.target.querySelector('button[type="submit"]');
        submitBtn.disabled = true;
        submitBtn.textContent = 'Ativando...';

        try {
            // Para email 2FA, apenas marcamos como ativado sem TOTP secret
            const { error } = await supabase
                .from('user_2fa_settings')
                .upsert({
                    user_id: this.currentUser.id,
                    is_enabled: true,
                    secret_key: null, // Sem TOTP para email
                    backup_codes: null
                });

            if (error) throw error;

            this.showSuccess('2FA por email ativado com sucesso!');
            this.updateStatusIndicator(true);
            this.closeAllModals();
        } catch (error) {
            console.error('Erro ao ativar email 2FA:', error);
            this.showError('Erro ao ativar 2FA por email');
        } finally {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Ativar Email 2FA';
        }
    }

    // Desativar 2FA
    async disable2FA(event) {
        event.preventDefault();
        
        const code = document.getElementById('disable2FACode').value;
        const submitBtn = event.target.querySelector('button[type="submit"]');
        
        submitBtn.disabled = true;
        submitBtn.textContent = 'Desativando...';

        try {
            const result = await this.twoFactorService.disable2FA(this.currentUser.id, code);
            
            if (result.success) {
                this.showSuccess('2FA desativado com sucesso!');
                this.updateStatusIndicator(false);
                this.closeAllModals();
            } else {
                this.showError(result.message || 'Código inválido');
            }
        } catch (error) {
            console.error('Erro ao desativar 2FA:', error);
            this.showError('Erro ao desativar 2FA. Tente novamente.');
        } finally {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Desativar 2FA';
        }
    }

    // Mostrar modal de verificação 2FA no login
    async show2FAVerification(onSuccess, onCancel) {
        const modal = document.getElementById('twoFactorModal');
        const content = document.getElementById('twoFactorContent');

        content.innerHTML = `
            <form onsubmit="twoFactorUI.verify2FALogin(event)" class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-blue-200 mb-2">Código de Verificação</label>
                    <input type="text" id="login2FACode" class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg text-white placeholder-gray-400 focus:ring-2 focus:ring-blue-500 focus:border-transparent" placeholder="Digite o código" maxlength="8" required>
                    <p class="text-xs text-gray-400 mt-1">Código do app autenticador, email ou código de backup</p>
                </div>

                <div class="flex space-x-3">
                    <button type="button" onclick="twoFactorUI.cancel2FALogin()" class="flex-1 px-4 py-2 bg-gray-600 hover:bg-gray-500 text-white rounded-lg transition-all">
                        Cancelar
                    </button>
                    <button type="button" onclick="twoFactorUI.requestEmailCode()" class="flex-1 px-4 py-2 bg-blue-600 hover:bg-blue-500 text-white rounded-lg transition-all">
                        Enviar por Email
                    </button>
                    <button type="submit" class="flex-1 px-4 py-2 bg-green-600 hover:bg-green-500 text-white rounded-lg transition-all">
                        Verificar
                    </button>
                </div>
            </form>
        `;

        this.onLoginSuccess = onSuccess;
        this.onLoginCancel = onCancel;
        modal.classList.remove('hidden');
    }

    // Verificar 2FA no login
    async verify2FALogin(event) {
        event.preventDefault();
        
        const code = document.getElementById('login2FACode').value;
        const submitBtn = event.target.querySelector('button[type="submit"]');
        
        submitBtn.disabled = true;
        submitBtn.textContent = 'Verificando...';

        try {
            const result = await this.twoFactorService.verify2FACode(this.currentUser.id, code);
            
            if (result.success) {
                this.closeAllModals();
                if (this.onLoginSuccess) this.onLoginSuccess();
            } else {
                this.showError(result.message || 'Código inválido');
            }
        } catch (error) {
            console.error('Erro na verificação 2FA:', error);
            this.showError('Erro na verificação. Tente novamente.');
        } finally {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Verificar';
        }
    }

    // Cancelar login 2FA
    cancel2FALogin() {
        this.closeAllModals();
        if (this.onLoginCancel) this.onLoginCancel();
    }

    // Solicitar código por email
    async requestEmailCode() {
        const btn = event.target;
        btn.disabled = true;
        btn.textContent = 'Enviando...';

        try {
            await this.twoFactorService.sendEmailCode(this.currentUser.email, this.currentUser.user_metadata?.full_name);
            this.showSuccess('Código enviado por email!');
        } catch (error) {
            console.error('Erro ao enviar código:', error);
            this.showError('Erro ao enviar código por email');
        } finally {
            btn.disabled = false;
            btn.textContent = 'Enviar por Email';
        }
    }

    // Mostrar mensagem de sucesso
    showSuccess(message) {
        // Implementar notificação de sucesso
        alert('✅ ' + message); // Temporário
    }

    // Mostrar mensagem de erro
    showError(message) {
        // Implementar notificação de erro
        alert('❌ ' + message); // Temporário
    }
}

// Instância global
const twoFactorUI = new TwoFactorUI();