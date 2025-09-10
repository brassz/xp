// =====================================================
// GERENCIADOR MULTI-EMPRESA - SISTEMA NEXUS
// =====================================================

class MultiCompanyManager {
    constructor() {
        this.currentCompany = null;
        this.supabaseClient = null;
        this.uploadcareClient = null;
        this.initialized = false;
    }

    // Inicializar o gerenciador
    async initialize() {
        try {
            // Carregar empresa selecionada
            const selectedCompany = getCurrentCompanyId();
            await this.switchToCompany(selectedCompany);
            this.initialized = true;
            console.log(`✅ Multi-Company Manager inicializado para: ${this.currentCompany.name}`);
            return true;
        } catch (error) {
            console.error('❌ Erro ao inicializar Multi-Company Manager:', error);
            return false;
        }
    }

    // Trocar para uma empresa específica
    async switchToCompany(companyId) {
        try {
            const companyConfig = COMPANIES_CONFIG[companyId];
            if (!companyConfig) {
                throw new Error(`Empresa não encontrada: ${companyId}`);
            }

            // Atualizar empresa atual
            this.currentCompany = companyConfig;
            setCurrentCompany(companyId);

            // Inicializar cliente Supabase
            await this.initializeSupabase();

            // Inicializar Uploadcare
            this.initializeUploadcare();

            // Aplicar tema da empresa
            this.applyCompanyTheme();

            // Atualizar interface
            this.updateUI();

            console.log(`✅ Conectado à empresa: ${companyConfig.name}`);
            return true;

        } catch (error) {
            console.error('❌ Erro ao trocar empresa:', error);
            throw error;
        }
    }

    // Inicializar cliente Supabase
    async initializeSupabase() {
        try {
            const config = this.currentCompany.supabase;
            this.supabaseClient = window.supabase.createClient(config.url, config.anonKey);

            // Testar conexão
            const { data, error } = await this.supabaseClient.from('users').select('count').limit(1);
            if (error) {
                console.warn('⚠️ Aviso na conexão Supabase:', error);
            }

            return this.supabaseClient;
        } catch (error) {
            console.error('❌ Erro ao inicializar Supabase:', error);
            throw error;
        }
    }

    // Inicializar Uploadcare
    initializeUploadcare() {
        try {
            const publicKey = this.currentCompany.uploadcare.publicKey;
            if (window.uploadcare) {
                window.uploadcare.start({
                    publicKey: publicKey,
                    multiple: true,
                    crop: false,
                    tabs: 'file camera url'
                });
            }
            this.uploadcareClient = { publicKey };
            console.log(`✅ Uploadcare configurado para: ${this.currentCompany.name}`);
        } catch (error) {
            console.error('❌ Erro ao configurar Uploadcare:', error);
        }
    }

    // Aplicar tema da empresa
    applyCompanyTheme() {
        try {
            const theme = this.currentCompany.theme;
            const root = document.documentElement;

            // Definir variáveis CSS customizadas
            root.style.setProperty('--primary-color', theme.primaryColor);
            root.style.setProperty('--secondary-color', theme.secondaryColor);
            root.style.setProperty('--accent-color', theme.accentColor);

            // Atualizar elementos específicos se necessário
            const elements = document.querySelectorAll('.company-themed');
            elements.forEach(element => {
                element.style.color = theme.primaryColor;
            });

        } catch (error) {
            console.error('❌ Erro ao aplicar tema:', error);
        }
    }

    // Atualizar interface com informações da empresa
    updateUI() {
        try {
            // Atualizar título da página
            document.title = `${this.currentCompany.name} - Sistema de Gestão`;

            // Atualizar logos
            const logos = document.querySelectorAll('.company-logo');
            logos.forEach(logo => {
                logo.src = this.currentCompany.logo;
                logo.alt = `${this.currentCompany.name} Logo`;
            });

            // Atualizar nome da empresa na interface
            const companyNames = document.querySelectorAll('.company-name');
            companyNames.forEach(element => {
                element.textContent = this.currentCompany.name;
            });

            // Atualizar seletor de empresa se existir
            const companySelector = document.getElementById('currentCompanyName');
            if (companySelector) {
                companySelector.textContent = this.currentCompany.name;
            }

        } catch (error) {
            console.error('❌ Erro ao atualizar UI:', error);
        }
    }

    // Obter cliente Supabase atual
    getSupabaseClient() {
        if (!this.supabaseClient) {
            throw new Error('Supabase não inicializado. Chame initialize() primeiro.');
        }
        return this.supabaseClient;
    }

    // Obter configuração de upload atual
    getUploadcareConfig() {
        return this.uploadcareClient;
    }

    // Obter informações da empresa atual
    getCurrentCompany() {
        return this.currentCompany;
    }

    // Verificar se está inicializado
    isInitialized() {
        return this.initialized;
    }

    // Abrir seletor de empresa
    openCompanySelector() {
        window.location.href = 'company-selector.html';
    }

    // Método para executar query no banco atual
    async executeQuery(table, operation, data = null, filters = null) {
        try {
            const client = this.getSupabaseClient();
            let query = client.from(table);

            switch (operation) {
                case 'select':
                    query = query.select(data || '*');
                    if (filters) {
                        Object.keys(filters).forEach(key => {
                            query = query.eq(key, filters[key]);
                        });
                    }
                    break;

                case 'insert':
                    query = query.insert(data);
                    break;

                case 'update':
                    query = query.update(data);
                    if (filters) {
                        Object.keys(filters).forEach(key => {
                            query = query.eq(key, filters[key]);
                        });
                    }
                    break;

                case 'delete':
                    if (filters) {
                        Object.keys(filters).forEach(key => {
                            query = query.eq(key, filters[key]);
                        });
                    }
                    query = query.delete();
                    break;

                default:
                    throw new Error(`Operação não suportada: ${operation}`);
            }

            const result = await query;
            if (result.error) {
                throw result.error;
            }

            return result;

        } catch (error) {
            console.error(`❌ Erro na operação ${operation} na tabela ${table}:`, error);
            throw error;
        }
    }

    // Método para upload de arquivo
    async uploadFile(fileInput, metadata = {}) {
        try {
            const config = this.getUploadcareConfig();
            
            // Implementar upload usando Uploadcare
            // Este é um exemplo básico - pode ser expandido conforme necessário
            
            if (!fileInput.files || fileInput.files.length === 0) {
                throw new Error('Nenhum arquivo selecionado');
            }

            const file = fileInput.files[0];
            const formData = new FormData();
            formData.append('UPLOADCARE_PUB_KEY', config.publicKey);
            formData.append('file', file);

            // Adicionar metadata se fornecido
            Object.keys(metadata).forEach(key => {
                formData.append(key, metadata[key]);
            });

            const response = await fetch('https://upload.uploadcare.com/base/', {
                method: 'POST',
                body: formData
            });

            if (!response.ok) {
                throw new Error('Erro no upload do arquivo');
            }

            const result = await response.json();
            return result;

        } catch (error) {
            console.error('❌ Erro no upload de arquivo:', error);
            throw error;
        }
    }
}

// Instância global do gerenciador
const companyManager = new MultiCompanyManager();

// Função de conveniência para obter o cliente Supabase
function getSupabase() {
    return companyManager.getSupabaseClient();
}

// Função de conveniência para executar queries
async function executeQuery(table, operation, data = null, filters = null) {
    return await companyManager.executeQuery(table, operation, data, filters);
}

// Função para inicializar o sistema multi-empresa
async function initializeMultiCompany() {
    try {
        const success = await companyManager.initialize();
        if (success) {
            console.log('✅ Sistema multi-empresa inicializado com sucesso');
            return companyManager;
        } else {
            throw new Error('Falha na inicialização');
        }
    } catch (error) {
        console.error('❌ Erro ao inicializar sistema multi-empresa:', error);
        
        // Redirecionar para seletor de empresa em caso de erro
        if (window.location.pathname !== '/company-selector.html') {
            window.location.href = 'company-selector.html';
        }
        
        throw error;
    }
}