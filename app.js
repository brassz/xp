// Função para obter variáveis de ambiente (compatível com Vercel)
function getEnvVar(name, fallback = '') {
    // Tentar process.env primeiro (Node.js/Vercel)
    if (typeof process !== 'undefined' && process.env && process.env[name]) {
        return process.env[name];
    }
    
    // Tentar window para variáveis públicas (browser)
    if (typeof window !== 'undefined' && window.process && window.process.env && window.process.env[name]) {
        return window.process.env[name];
    }
    
    // Fallback para valores hardcoded (desenvolvimento local)
    const fallbacks = {
        'NEXT_PUBLIC_SUPABASE_URL_EMPRESA1': 'https://mhtxyxizfnxupwmilith.supabase.co',
        'NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA1': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1odHh5eGl6Zm54dXB3bWlsaXRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYxMzIzMDYsImV4cCI6MjA3MTcwODMwNn0.s1Y9kk2Va5EMcwAEGQmhTxo70Zv0o9oR6vrJixwEkWI',
        'NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA1': '5bb6bf6b98f6d36060dc',
        'NEXT_PUBLIC_SUPABASE_URL_EMPRESA2': 'https://dtifsfzmnjnllzzlndxv.supabase.co',
        'NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA2': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR0aWZzZnptbmpubGx6emxuZHh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxNjQ5NzUsImV4cCI6MjA3Mjc0MDk3NX0.V40szmRzuvni2J4GK5-qZUR7nBWeUy7ikYy9B7iHxkA',
        'NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA2': '026feb50f83d7cdfe4ea',
        'NEXT_PUBLIC_SUPABASE_URL_EMPRESA3': 'https://eemfnpefgojllvzzaimu.supabase.co',
        'NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA3': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVlbWZucGVmZ29qbGx2enphaW11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxNjUyNjIsImV4cCI6MjA3Mjc0MTI2Mn0.PKJJ-scljbF3CFrFtMz6Rq03lVt36NQxooEH3kOcr5Y',
        'NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA3': '72349b0b9769d2be0d8c',
        'NEXT_PUBLIC_SUPABASE_URL_EMPRESA4': 'https://adjrvtupfshdhwjvhmgj.supabase.co',
        'NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA4': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFkanJ2dHVwZnNoZGh3anZobWdqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc2MDAyMDUsImV4cCI6MjA3MzE3NjIwNX0.iSl7bECBz8yl5HHcBwL6gp5Pd5Y06nNFWgLTzvLgVSY',
        'NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA4': 'CONFIGURE_UPLOADCARE_KEY_HERE',
        'NEXT_PUBLIC_SUPABASE_URL_EMPRESA5': 'https://eppzphzwwpvpoocospxy.supabase.co',
        'NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA5': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVwcHpwaHp3d3B2cG9vY29zcHh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0NTc1MDEsImV4cCI6MjA3NTAzMzUwMX0.QwiFlP-h3sk0-pDBmrOMkQmhWZtewD2wDMPYbXAATXI',
        'NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA5': 'CONFIGURE_UPLOADCARE_KEY_HERE'
    };
    
    return fallbacks[name] || fallback;
}

// Configurações das empresas usando variáveis de ambiente
const COMPANIES_CONFIG = {
    nexus: {
        name: 'FRANCA CRED',
        supabase: {
            url: getEnvVar('NEXT_PUBLIC_SUPABASE_URL_EMPRESA1'),
            key: getEnvVar('NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA1')
        },
        uploadcare: {
            publicKey: getEnvVar('NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA1')
        }
    },
    litoral: {
        name: 'LITORAL CRED',
        supabase: {
            url: getEnvVar('NEXT_PUBLIC_SUPABASE_URL_EMPRESA2'),
            key: getEnvVar('NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA2')
        },
        uploadcare: {
            publicKey: getEnvVar('NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA2')
        }
    },
    mogiana: {
        name: 'MOGIANA CRED',
        supabase: {
            url: getEnvVar('NEXT_PUBLIC_SUPABASE_URL_EMPRESA3'),
            key: getEnvVar('NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA3')
        },
        uploadcare: {
            publicKey: getEnvVar('NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA3')
        }
    },
    erechim: {
        name: 'ERECHIM',
        supabase: {
            url: getEnvVar('NEXT_PUBLIC_SUPABASE_URL_EMPRESA4'),
            key: getEnvVar('NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA4')
        },
        uploadcare: {
            publicKey: getEnvVar('NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA4')
        }
    },
    imperatriz: {
        name: 'IMPERATRIZ CRED',
        supabase: {
            url: getEnvVar('NEXT_PUBLIC_SUPABASE_URL_EMPRESA5'),
            key: getEnvVar('NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA5')
        },
        uploadcare: {
            publicKey: getEnvVar('NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA5')
        }
    }
};

// Variáveis globais para configuração atual
let currentCompany = null;
let supabase = null;

// Função para inicializar empresa
function initializeCompany(companyId) {
    if (!COMPANIES_CONFIG[companyId]) {
        throw new Error(`Empresa ${companyId} não encontrada na configuração`);
    }
    
    currentCompany = companyId;
    const config = COMPANIES_CONFIG[companyId];
    
    // Inicializar Supabase para a empresa selecionada
    supabase = window.supabase.createClient(config.supabase.url, config.supabase.key);
    
    // Atualizar configuração do Uploadcare
    if (window.uploadcare) {
        window.uploadcare.publicKey = config.uploadcare.publicKey;
    }
    
    // Salvar empresa selecionada no localStorage
    localStorage.setItem('selectedCompany', companyId);
    
    console.log(`Empresa inicializada: ${config.name}`);
    return config;
}

// Função para obter configuração da empresa atual
function getCurrentCompanyConfig() {
    if (!currentCompany) {
        return null;
    }
    return COMPANIES_CONFIG[currentCompany];
}

// Estado global da aplicação
let currentUser = null;
let clients = [];
let filteredClients = [];
let currentPage = 1;
const itemsPerPage = 50; // Limitar a 50 clientes por página
let clientsLastLoaded = null; // Timestamp do último carregamento
const CACHE_DURATION = 30000; // Cache por 30 segundos
let loans = [];
let filteredLoans = [];
let expenses = [];
let expenseCategories = [];
let installments = [];
let filteredInstallments = [];
let installmentPayments = [];
let guarantors = [];

// Sistema de timeout para todos os usuários (5 minutos de inatividade)
let userTimeoutId = null;
let lastActivityTime = Date.now();
const USER_TIMEOUT_DURATION = 5 * 60 * 1000; // 5 minutos em milissegundos

// Função para teste - permite definir timeout menor para demonstração
function setTestTimeout(minutes = 5) {
    const testDuration = minutes * 60 * 1000;
    console.log(`Timeout de teste definido para ${minutes} minuto(s)`);
    
    // Limpar timeout atual se existir
    clearUserTimeout();
    
    // Definir novo timeout com duração personalizada
    if (currentUser) {
        userTimeoutId = setTimeout(() => {
            showNotification('Sessão expirada por inatividade. Você será desconectado em 10 segundos...', 'warning');
            
            setTimeout(() => {
                if (currentUser) {
                    showNotification('Desconectado por inatividade.', 'error');
                    handleLogout();
                }
            }, 10000);
        }, testDuration);
    }
}
let emergencyContacts = [];
let cashTransactions = [];
let cashSettings = null;
let capitalRaisings = [];
let capitalRaisingClients = [];

let charts = {};
let isLoadingData = false; // Flag para evitar carregamento múltiplo


// Elementos DOM
const loginPage = document.getElementById('loginPage');
const dashboard = document.getElementById('dashboard');
const loginForm = document.getElementById('loginForm');
const logoutBtn = document.getElementById('logoutBtn');

// Navegação
const navLinks = document.querySelectorAll('.nav-link');
const contentSections = document.querySelectorAll('.content-section');

// Modais
const newClientModal = document.getElementById('newClientModal');
const newLoanModal = document.getElementById('newLoanModal');
const paymentModal = document.getElementById('paymentModal');
const paymentMessageModal = document.getElementById('paymentMessageModal');
const editClientModal = document.getElementById('editClientModal');
const editLoanModal = document.getElementById('editLoanModal');
const confirmationModal = document.getElementById('confirmationModal');
const paymentHistoryModal = document.getElementById('paymentHistoryModal');
const paidLoanDetailsModal = document.getElementById('paidLoanDetailsModal');
const newExpenseModal = document.getElementById('newExpenseModal');
const newInstallmentModal = document.getElementById('newInstallmentModal');
const installmentDetailsModal = document.getElementById('installmentDetailsModal');
const installmentPaymentModal = document.getElementById('installmentPaymentModal');
const newCapitalRaisingModal = document.getElementById('newCapitalRaisingModal');
const capitalRaisingDetailsModal = document.getElementById('capitalRaisingDetailsModal');
const addCapitalClientModal = document.getElementById('addCapitalClientModal');
const guarantorModal = document.getElementById('guarantorModal');
const emergencyContactModal = document.getElementById('emergencyContactModal');
const whatsappSummaryModal = document.getElementById('whatsappSummaryModal');
const renewalOptionsModal = document.getElementById('renewalOptionsModal');


// Botões
const newClientBtn = document.getElementById('newClientBtn');
const newLoanBtn = document.getElementById('newLoanBtn');
const newExpenseBtn = document.getElementById('newExpenseBtn');
const newCapitalRaisingBtn = document.getElementById('newCapitalRaisingBtn');

const generatePdfBtn = document.getElementById('generatePdfBtn');
const generateExpensesPDFBtn = document.getElementById('generateExpensesPDFBtn');
const generateTotalPDFBtn = document.getElementById('generateTotalPDFBtn');
const generateWeeklyPDFBtn = document.getElementById('generateWeeklyPDFBtn');
const generateMonthlyPDFBtn = document.getElementById('generateMonthlyPDFBtn');

// Formulários
const newClientForm = document.getElementById('newClientForm');
const newLoanForm = document.getElementById('newLoanForm');
const paymentForm = document.getElementById('paymentForm');
const newExpenseForm = document.getElementById('newExpenseForm');
const newCapitalRaisingForm = document.getElementById('newCapitalRaisingForm');
const addCapitalClientForm = document.getElementById('addCapitalClientForm');


// Inicialização da aplicação
document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
    setupEventListeners();
    setupUploadcare();
});

// Inicializar aplicação
async function initializeApp() {
    // Verificar se há usuário logado no localStorage
    const savedUser = localStorage.getItem('nexusUser');
    const savedCompany = localStorage.getItem('selectedCompany');
    
    if (savedUser && savedCompany) {
        try {
            // Restaurar empresa selecionada
            initializeCompany(savedCompany);
            
            currentUser = JSON.parse(savedUser);
            showDashboard();
            // Verificar e criar tabelas se necessário
            await createTablesIfNotExist();
            
            // Aguardar um pouco para garantir que o DOM esteja pronto
            setTimeout(async () => {
                await loadData();
                // Inicializar sistema de PDFs semanais automáticos
                initializeWeeklyPDFCheck();
            }, 100);
        } catch (error) {
            localStorage.removeItem('nexusUser');
            localStorage.removeItem('selectedCompany');
            showLogin();
        }
    } else {
        showLogin();
    }
}

// Configurar event listeners
function setupEventListeners() {
    // Login
    loginForm.addEventListener('submit', handleLogin);
    logoutBtn.addEventListener('click', handleLogout);
    
    // Navegação
    navLinks.forEach(link => {
        link.addEventListener('click', handleNavigation);
    });

    // Navegação do submenu
    const submenuLinks = document.querySelectorAll('.submenu-item');
    submenuLinks.forEach(link => {
        link.addEventListener('click', handleNavigation);
    });
    
    // Botões
    newClientBtn.addEventListener('click', () => showModal(newClientModal));
    newLoanBtn.addEventListener('click', () => showModal(newLoanModal));
    newExpenseBtn.addEventListener('click', () => {
        showModal(newExpenseModal);
        setDefaultExpenseDate();
    });
    
    if (newCapitalRaisingBtn) {
        newCapitalRaisingBtn.addEventListener('click', () => showModal(newCapitalRaisingModal));
    }

    generatePdfBtn.addEventListener('click', generateMonthlyLoansPDF);
    
    // Event listener para o botão de PDF de pagamentos semanais
    const generateWeeklyPaymentsPdfBtn = document.getElementById('generateWeeklyPaymentsPdfBtn');
    if (generateWeeklyPaymentsPdfBtn) {
        generateWeeklyPaymentsPdfBtn.addEventListener('click', generateWeeklyPaymentsPDF);
    }

    // Event listeners para a nova seção de histórico de pagamentos
    const generateWeeklyPaymentsPDFBtn = document.getElementById('generateWeeklyPaymentsPDFBtn');
    if (generateWeeklyPaymentsPDFBtn) {
        generateWeeklyPaymentsPDFBtn.addEventListener('click', generateWeeklyPaymentsPDFForSelectedWeek);
    }

    const refreshPaymentsBtn = document.getElementById('refreshPaymentsBtn');
    if (refreshPaymentsBtn) {
        refreshPaymentsBtn.addEventListener('click', () => {
            if (selectedWeekData) {
                loadWeekData(selectedWeekData.startDate, selectedWeekData.endDate);
            } else {
                populateWeekSelector();
            }
        });
    }

    const showPDFHistoryBtn = document.getElementById('showPDFHistoryBtn');
    if (showPDFHistoryBtn) {
        showPDFHistoryBtn.addEventListener('click', showPDFHistoryModal);
    }

    const showWeekClientsBtn = document.getElementById('showWeekClientsBtn');
    if (showWeekClientsBtn) {
        showWeekClientsBtn.addEventListener('click', showWeekClientsModal);
    }

    // Event listeners para fechar modais
    const closeWeekClientsModal = document.getElementById('closeWeekClientsModal');
    if (closeWeekClientsModal) {
        closeWeekClientsModal.addEventListener('click', () => hideModal(document.getElementById('weekClientsModal')));
    }

    const closePdfHistoryModal = document.getElementById('closePdfHistoryModal');
    if (closePdfHistoryModal) {
        closePdfHistoryModal.addEventListener('click', () => hideModal(document.getElementById('pdfHistoryModal')));
    }

    // Event listener para o botão de calcular comissões
    const calculateCommissionsBtn = document.getElementById('calculateCommissionsBtn');
    if (calculateCommissionsBtn) {
        calculateCommissionsBtn.addEventListener('click', calculateCommissions);
    }

    // Event listener para o botão de gerar PDF das comissões
    const generateCommissionsPDFBtn = document.getElementById('generateCommissionsPDFBtn');
    if (generateCommissionsPDFBtn) {
        generateCommissionsPDFBtn.addEventListener('click', generateCommissionsPDF);
    }

    // Event listener para mudança de semana
    const weekSelector = document.getElementById('weekSelector');
    if (weekSelector) {
        weekSelector.addEventListener('change', handleWeekChange);
    }
    
    // Adicionar event listener para o botão de PDF das despesas
    if (generateExpensesPDFBtn) {
        generateExpensesPDFBtn.addEventListener('click', generateMonthlyExpensesPDF);
    }
    
    // Event listeners para os novos botões de PDF de relatórios
    if (generateTotalPDFBtn) {
        generateTotalPDFBtn.addEventListener('click', generateTotalReportPDF);
    }
    
    if (generateWeeklyPDFBtn) {
        generateWeeklyPDFBtn.addEventListener('click', generateWeeklyReportPDF);
    }
    
    if (generateMonthlyPDFBtn) {
        generateMonthlyPDFBtn.addEventListener('click', generateMonthlyReportPDF);
    }
    
    // Fechar modais
    document.getElementById('closeClientModal').addEventListener('click', () => hideModal(newClientModal));
    document.getElementById('closeLoanModal').addEventListener('click', () => hideModal(newLoanModal));
    document.getElementById('closePaymentModal').addEventListener('click', () => hideModal(paymentModal));
    document.getElementById('closeEditClientModal').addEventListener('click', () => hideModal(editClientModal));
    document.getElementById('closeViewClientModal').addEventListener('click', () => hideModal(document.getElementById('viewClientModal')));
    document.getElementById('closeViewClientBtn').addEventListener('click', () => hideModal(document.getElementById('viewClientModal')));
    document.getElementById('closeEditLoanModal').addEventListener('click', () => hideModal(editLoanModal));
    document.getElementById('closePaymentHistoryModal').addEventListener('click', () => hideModal(paymentHistoryModal));
    document.getElementById('closePaidLoanDetailsModal').addEventListener('click', () => hideModal(paidLoanDetailsModal));
    document.getElementById('closeExpenseModal').addEventListener('click', () => hideModal(newExpenseModal));
    document.getElementById('closeGuarantorModal').addEventListener('click', () => hideModal(guarantorModal));
    document.getElementById('closeEmergencyContactModal').addEventListener('click', () => hideModal(emergencyContactModal));
    document.getElementById('closeClientDocumentsModal').addEventListener('click', () => hideModal(document.getElementById('clientDocumentsModal')));
    
    // Configurar modal de mensagens de pagamento
    setupPaymentMessageEventListeners();
    
    // WhatsApp Summary modal
    document.getElementById('cancelWhatsAppBtn').addEventListener('click', () => hideModal(whatsappSummaryModal));
    document.getElementById('confirmWhatsAppBtn').addEventListener('click', () => {
        hideModal(whatsappSummaryModal);
        const loanId = whatsappSummaryModal.dataset.loanId;
        if (loanId) {
            sendLoanSummaryWhatsApp(loanId);
        }
    });
    
    // Capital Raising modals
    if (document.getElementById('closeCapitalRaisingModal')) {
        document.getElementById('closeCapitalRaisingModal').addEventListener('click', () => hideModal(newCapitalRaisingModal));
    }
    if (document.getElementById('closeCapitalRaisingDetailsModal')) {
        document.getElementById('closeCapitalRaisingDetailsModal').addEventListener('click', () => hideModal(capitalRaisingDetailsModal));
    }
    if (document.getElementById('closeCapitalClientModal')) {
        document.getElementById('closeCapitalClientModal').addEventListener('click', () => hideModal(addCapitalClientModal));
    }

    
    // Cancelar modais
    document.getElementById('cancelClientBtn').addEventListener('click', () => hideModal(newClientModal));
    document.getElementById('cancelLoanBtn').addEventListener('click', () => hideModal(newLoanModal));
    document.getElementById('cancelPaymentBtn').addEventListener('click', () => hideModal(paymentModal));
    document.getElementById('cancelEditClientBtn').addEventListener('click', () => hideModal(editClientModal));
    document.getElementById('cancelEditLoanBtn').addEventListener('click', () => hideModal(editLoanModal));
    document.getElementById('cancelConfirmationBtn').addEventListener('click', () => hideModal(confirmationModal));
    document.getElementById('closePaymentHistoryBtn').addEventListener('click', () => hideModal(paymentHistoryModal));
    document.getElementById('closePaidLoanDetailsBtn').addEventListener('click', () => hideModal(paidLoanDetailsModal));
    document.getElementById('cancelExpense').addEventListener('click', () => hideModal(newExpenseModal));
    document.getElementById('cancelGuarantorBtn').addEventListener('click', () => hideModal(guarantorModal));
    document.getElementById('cancelEmergencyContactBtn').addEventListener('click', () => hideModal(emergencyContactModal));
    
    // Botão de abrir modal de renovação
    document.getElementById('openRenewalModalBtn').addEventListener('click', () => openRenewalOptionsModal());
    
    // Event listeners para o modal de opções de renovação
    document.getElementById('closeRenewalOptionsModal').addEventListener('click', () => hideModal(renewalOptionsModal));
    document.getElementById('cancelRenewalBtn').addEventListener('click', () => hideModal(renewalOptionsModal));
    document.getElementById('renewalCapitalJuros').addEventListener('click', () => handleNewRenewalPayment('capital_juros'));
    document.getElementById('renewalSomenteJuros').addEventListener('click', () => handleNewRenewalPayment('somente_juros'));
    document.getElementById('renewalSomenteCapital').addEventListener('click', () => handleNewRenewalPayment('somente_capital'));
    
    // Capital Raising cancel buttons
    if (document.getElementById('cancelCapitalRaising')) {
        document.getElementById('cancelCapitalRaising').addEventListener('click', () => hideModal(newCapitalRaisingModal));
    }
    if (document.getElementById('cancelCapitalClient')) {
        document.getElementById('cancelCapitalClient').addEventListener('click', () => hideModal(addCapitalClientModal));
    }

    
    // Botões do modal de histórico de pagamentos
    document.getElementById('newPaymentBtn').addEventListener('click', () => showNewPaymentFromHistory());
    
    // Checkbox para alterar data de vencimento no modal de pagamento
    document.getElementById('changeDueDateCheckbox').addEventListener('change', function() {
        const container = document.getElementById('dueDateContainer');
        if (this.checked) {
            container.classList.remove('hidden');
        } else {
            container.classList.add('hidden');
            document.getElementById('newDueDate').value = '';
        }
    });

    // Checkbox para incluir multa no modal de pagamento
    document.getElementById('includeFineCheckbox').addEventListener('change', function() {
        const container = document.getElementById('fineContainer');
        if (this.checked) {
            container.classList.remove('hidden');
        } else {
            container.classList.add('hidden');
            document.getElementById('fineAmount').value = '';
        }
    });
    
    // Botão de carregar histórico
    document.getElementById('loadHistoryBtn').addEventListener('click', () => loadClientHistory());
    
    // Campo de busca de clientes no histórico
    document.getElementById('historyClientSearch').addEventListener('input', function(e) {
        const searchTerm = e.target.value;
        if (searchTerm.length >= 2) {
            const results = searchHistoryClients(searchTerm);
            renderHistorySearchResults(results);
        } else {
            document.getElementById('historyClientResults').classList.add('hidden');
        }
    });

    // Campo de busca de clientes na aba principal
    document.getElementById('clientSearchInput').addEventListener('input', function(e) {
        const searchTerm = e.target.value;
        searchClients(searchTerm);
    });

    // Botão de limpar busca de clientes
    document.getElementById('clearClientSearch').addEventListener('click', clearClientSearch);

    // Campo de busca de empréstimos
    document.getElementById('loanSearchInput').addEventListener('input', function(e) {
        const searchTerm = e.target.value;
        saveLoanFilters();
        searchLoans(searchTerm);
    });

    // Botão de limpar busca de empréstimos
    document.getElementById('clearLoanSearch').addEventListener('click', clearLoanSearch);
    
    // Restaurar filtros salvos dos empréstimos ao carregar a página
    restoreLoanFilters();
    
    // Event listeners para os novos filtros
    const creationDateFrom = document.getElementById('creationDateFrom');
    const creationDateTo = document.getElementById('creationDateTo');
    const dueDateFrom = document.getElementById('dueDateFrom');
    const dueDateTo = document.getElementById('dueDateTo');
    const sortBy = document.getElementById('sortBy');
    const sortOrder = document.getElementById('sortOrder');
    const clearAllFiltersBtn = document.getElementById('clearAllFilters');
    
    if (creationDateFrom) creationDateFrom.addEventListener('change', () => { saveLoanFilters(); applyFiltersAndSort(); });
    if (creationDateTo) creationDateTo.addEventListener('change', () => { saveLoanFilters(); applyFiltersAndSort(); });
    if (dueDateFrom) dueDateFrom.addEventListener('change', () => { saveLoanFilters(); applyFiltersAndSort(); });
    if (dueDateTo) dueDateTo.addEventListener('change', () => { saveLoanFilters(); applyFiltersAndSort(); });
    if (sortBy) sortBy.addEventListener('change', () => { saveLoanFilters(); applyFiltersAndSort(); });
    if (sortOrder) sortOrder.addEventListener('change', () => { saveLoanFilters(); applyFiltersAndSort(); });
    if (clearAllFiltersBtn) clearAllFiltersBtn.addEventListener('click', clearAllFilters);
    
    // Event listeners para os filtros de parcelamentos
    const installmentSearchInput = document.getElementById('installmentSearchInput');
    const clearInstallmentSearchBtn = document.getElementById('clearInstallmentSearch');
    const installmentCreationDateFrom = document.getElementById('installmentCreationDateFrom');
    const installmentCreationDateTo = document.getElementById('installmentCreationDateTo');
    const installmentDueDateFrom = document.getElementById('installmentDueDateFrom');
    const installmentDueDateTo = document.getElementById('installmentDueDateTo');
    const installmentSortBy = document.getElementById('installmentSortBy');
    const installmentSortOrder = document.getElementById('installmentSortOrder');
    const clearAllInstallmentFiltersBtn = document.getElementById('clearAllInstallmentFilters');
    
    if (installmentSearchInput) installmentSearchInput.addEventListener('input', applyInstallmentFiltersAndSort);
    if (clearInstallmentSearchBtn) clearInstallmentSearchBtn.addEventListener('click', clearInstallmentSearch);
    if (installmentCreationDateFrom) installmentCreationDateFrom.addEventListener('change', applyInstallmentFiltersAndSort);
    if (installmentCreationDateTo) installmentCreationDateTo.addEventListener('change', applyInstallmentFiltersAndSort);
    if (installmentDueDateFrom) installmentDueDateFrom.addEventListener('change', applyInstallmentFiltersAndSort);
    if (installmentDueDateTo) installmentDueDateTo.addEventListener('change', applyInstallmentFiltersAndSort);
    if (installmentSortBy) installmentSortBy.addEventListener('change', applyInstallmentFiltersAndSort);
    if (installmentSortOrder) installmentSortOrder.addEventListener('change', applyInstallmentFiltersAndSort);
    if (clearAllInstallmentFiltersBtn) clearAllInstallmentFiltersBtn.addEventListener('click', clearAllInstallmentFilters);
    
    // Esconder resultados ao clicar fora
    document.addEventListener('click', function(e) {
        const searchInput = document.getElementById('historyClientSearch');
        const resultsContainer = document.getElementById('historyClientResults');
        
        if (!searchInput.contains(e.target) && !resultsContainer.contains(e.target)) {
            resultsContainer.classList.add('hidden');
        }
    });
    
    // Formulários
    newClientForm.addEventListener('submit', handleNewClient);
    newLoanForm.addEventListener('submit', handleNewLoan);
    // paymentForm.addEventListener('submit', handlePayment); // REMOVIDO: Agora usa apenas RENOVAR 30+
    document.getElementById('editClientForm').addEventListener('submit', handleEditClient);
    document.getElementById('editLoanForm').addEventListener('submit', handleEditLoan);
    newExpenseForm.addEventListener('submit', handleNewExpense);
    document.getElementById('guarantorForm').addEventListener('submit', handleGuarantorForm);
    document.getElementById('emergencyContactForm').addEventListener('submit', handleEmergencyContactForm);
    document.getElementById('uploadDocumentForm').addEventListener('submit', handleDocumentUpload);
    
    // Filtro de documentos
    document.getElementById('documentFilter').addEventListener('change', renderClientDocuments);
    
    // Botão de adicionar avalista
    document.getElementById('addGuarantorBtn').addEventListener('click', () => {
        openGuarantorModal();
    });
    
    // Botão de adicionar contato de emergência
    document.getElementById('addEmergencyContactBtn').addEventListener('click', () => {
        openEmergencyContactModal();
    });
    
    // Checkbox para incluir avalista no novo cliente
    document.getElementById('includeGuarantor').addEventListener('change', function() {
        const guarantorSection = document.getElementById('guarantorSection');
        if (this.checked) {
            guarantorSection.classList.remove('hidden');
        } else {
            guarantorSection.classList.add('hidden');
            // Limpar campos do avalista quando desmarcado
            clearNewClientGuarantorForm();
        }
    });
    
    // Checkbox para incluir contato de emergência no novo cliente
    document.getElementById('includeEmergencyContact').addEventListener('change', function() {
        const emergencyContactSection = document.getElementById('emergencyContactSection');
        if (this.checked) {
            emergencyContactSection.classList.remove('hidden');
        } else {
            emergencyContactSection.classList.add('hidden');
            // Limpar campos do contato de emergência quando desmarcado
            clearNewClientEmergencyContactForm();
        }
    });
    
    // Capital Raising forms
    if (newCapitalRaisingForm) {
        newCapitalRaisingForm.addEventListener('submit', handleNewCapitalRaising);
    }
    if (addCapitalClientForm) {
        addCapitalClientForm.addEventListener('submit', handleAddCapitalClient);
    }
    
    // Auto-calculate total value for capital raising
    const capitalRaisingAmount = document.getElementById('capitalRaisingAmount');
    const capitalRaisingInterest = document.getElementById('capitalRaisingInterest');
    const capitalRaisingTotal = document.getElementById('capitalRaisingTotal');
    
    if (capitalRaisingAmount && capitalRaisingInterest && capitalRaisingTotal) {
        [capitalRaisingAmount, capitalRaisingInterest].forEach(input => {
            input.addEventListener('input', () => {
                const amount = parseFloat(capitalRaisingAmount.value) || 0;
                const interest = parseFloat(capitalRaisingInterest.value) || 0;
                const total = amount + (amount * interest / 100);
                capitalRaisingTotal.value = total.toFixed(2);
            });
        });
    }

    
    // Assinatura

    
    // Cálculos em tempo real
    document.getElementById('loanAmount').addEventListener('input', updateLoanSummary);
    document.getElementById('loanInterest').addEventListener('input', updateLoanSummary);
    document.getElementById('editLoanAmount').addEventListener('input', updateEditLoanSummary);
    document.getElementById('editLoanInterest').addEventListener('input', updateEditLoanSummary);
    
    // Validação do valor de pagamento - REMOVIDO: Agora usa apenas RENOVAR 30+
    // document.getElementById('paymentAmount').addEventListener('input', validatePaymentAmount);
    

}

// Configurar Uploadcare
function setupUploadcare() {
    if (window.uploadcare) {
        // Configurar Uploadcare globalmente
        // A publicKey será definida dinamicamente quando a empresa for selecionada
        uploadcare.start({
            publicKey: '5bb6bf6b98f6d36060dc', // Key padrão, será substituída
            locale: 'pt',
            tabs: 'file camera url facebook gdrive gphotos dropbox instagram',
            multiple: true,
            multipleMax: 10,
            imageShrink: '1024x1024',
            crop: '1:1',
            effects: 'crop,rotate,enhance,grayscale',
            clearable: true
        });


        
        // Widget para edição de cliente - múltiplas fotos (commented out - elements don't exist in modal)
        // const editWidget = uploadcare.Widget('#editClientPhotosUploader');
        // editWidget.onChange(function(group) {
        //     if (group) {
        //         group.done(function(groupInfo) {
        //             const photoUrls = [];
        //             groupInfo.files.forEach(function(fileInfo) {
        //                 photoUrls.push(fileInfo.cdnUrl);
        //             });
        //             
        //             // Armazenar URLs no campo hidden como JSON
        //             document.getElementById('editClientPhotos').value = JSON.stringify(photoUrls);
        //             
        //             // Mostrar preview das múltiplas fotos
        //             showPhotosPreview(photoUrls, 'editPhotosPreviewGrid', 'editPhotosUploadPreview');
        //         });
        //     } else {
        //         // Limpar quando arquivos forem removidos
        //         document.getElementById('editClientPhotos').value = '';
        //         document.getElementById('editPhotosUploadPreview').classList.add('hidden');
        //         document.getElementById('editPhotosPreviewGrid').innerHTML = '';
        //     }
        // });
        
        // Widget para foto de avalista
        const guarantorWidget = uploadcare.Widget('#guarantorPhotoUploader');
        guarantorWidget.onChange(function(file) {
            if (file) {
                file.done(function(fileInfo) {
                    // Armazenar URL no campo hidden
                    document.getElementById('guarantorPhoto').value = fileInfo.cdnUrl;
                    
                    // Mostrar preview
                    const previewDiv = document.getElementById('guarantorPhotoUploadPreview');
                    const previewImg = document.getElementById('guarantorPhotoPreviewImg');
                    
                    previewImg.src = fileInfo.cdnUrl;
                    previewDiv.classList.remove('hidden');
                });
            } else {
                // Limpar quando arquivo for removido
                document.getElementById('guarantorPhoto').value = '';
                document.getElementById('guarantorPhotoUploadPreview').classList.add('hidden');
            }
        });
        
        // Widget para foto de avalista no novo cliente
        const newClientGuarantorWidget = uploadcare.Widget('#newClientGuarantorPhotoUploader');
        newClientGuarantorWidget.onChange(function(file) {
            if (file) {
                file.done(function(fileInfo) {
                    // Armazenar URL no campo hidden
                    document.getElementById('newClientGuarantorPhoto').value = fileInfo.cdnUrl;
                    
                    // Mostrar preview
                    const previewDiv = document.getElementById('newClientGuarantorPhotoUploadPreview');
                    const previewImg = document.getElementById('newClientGuarantorPhotoPreviewImg');
                    
                    previewImg.src = fileInfo.cdnUrl;
                    previewDiv.classList.remove('hidden');
                });
            } else {
                // Limpar quando arquivo for removido
                document.getElementById('newClientGuarantorPhoto').value = '';
                document.getElementById('newClientGuarantorPhotoUploadPreview').classList.add('hidden');
            }
        });
    } else {
        console.warn('Uploadcare library not loaded');
    }
}



// Handlers de autenticação
async function handleLogin(e) {
    e.preventDefault();
    
    const companyId = document.getElementById('companySelect').value;
    const email = document.getElementById('loginEmail').value;
    const password = document.getElementById('loginPassword').value;
    
    if (!companyId) {
        alert('Por favor, selecione uma empresa');
        return;
    }
    
    try {
        // Inicializar empresa selecionada
        initializeCompany(companyId);
        
        // Primeiro, verificar se o usuário existe na nossa tabela
        const { data: userData, error: userError } = await supabase
            .from('users')
            .select('*')
            .eq('email', email)
            .eq('is_active', true)
            .single();
        
        if (userError || !userData) {
            throw new Error('Usuário não encontrado ou inativo');
        }
        
        // Verificar senha contra o banco de dados
        // Em produção, implementar hash de senha (bcrypt)
        if (password === userData.password_hash) {
            currentUser = userData;
            
            // Salvar usuário no localStorage
            localStorage.setItem('nexusUser', JSON.stringify(currentUser));
            
            showDashboard();
            await loadData();
            // Inicializar sistema de PDFs semanais automáticos
            initializeWeeklyPDFCheck();
            
            // Atualizar último login
            await supabase
                .from('users')
                .update({ last_login: new Date().toISOString() })
                .eq('id', currentUser.id);
                
        } else {
            throw new Error('Senha incorreta');
        }
        
    } catch (error) {
        alert('Erro no login: ' + error.message);
    }
}

async function handleLogout() {
    // Limpar timeout do usuário se existir
    clearUserTimeout();
    
    currentUser = null;
    currentCompany = null;
    supabase = null;
    localStorage.removeItem('nexusUser');
    localStorage.removeItem('selectedCompany');
    showLogin();
}

// Funções para gerenciar timeout de usuários
function startUserTimeout() {
    // Só iniciar timeout se houver usuário logado
    if (!currentUser) {
        return;
    }
    
    // Limpar timeout anterior se existir
    clearUserTimeout();
    
    console.log('Timeout de usuário iniciado - 5 minutos para logout automático');
    
    // Definir novo timeout
    userTimeoutId = setTimeout(() => {
        showNotification('Sessão expirada por inatividade. Você será desconectado em 10 segundos...', 'warning');
        
        // Dar 10 segundos de aviso antes de desconectar
        setTimeout(() => {
            if (currentUser) {
                showNotification('Desconectado por inatividade de 5 minutos.', 'error');
                handleLogout();
            }
        }, 10000);
    }, USER_TIMEOUT_DURATION);
}

function clearUserTimeout() {
    if (userTimeoutId) {
        clearTimeout(userTimeoutId);
        userTimeoutId = null;
    }
}

function resetUserTimeout() {
    // Só resetar se houver usuário logado
    if (!currentUser) {
        return;
    }
    
    lastActivityTime = Date.now();
    console.log('Timeout de usuário resetado devido à atividade');
    startUserTimeout();
}

// Variável para controlar se os listeners já foram adicionados
let activityListenersAdded = false;
let activityHandler = null;

function setupActivityListeners() {
    // Só configurar listeners se houver usuário logado
    if (!currentUser) {
        return;
    }
    
    // Remover listeners anteriores se existirem
    removeActivityListeners();
    
    // Eventos que indicam atividade do usuário
    const activityEvents = ['mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart', 'click'];
    
    // Função para lidar com atividade (com throttling para evitar muitas chamadas)
    let lastResetTime = 0;
    activityHandler = () => {
        const now = Date.now();
        // Só resetar o timeout se passou pelo menos 1 segundo desde o último reset
        if (now - lastResetTime > 1000) {
            resetUserTimeout();
            lastResetTime = now;
        }
    };
    
    // Adicionar listeners para todos os eventos de atividade
    activityEvents.forEach(event => {
        document.addEventListener(event, activityHandler, true);
    });
    
    activityListenersAdded = true;
    
    // Iniciar o timeout
    startUserTimeout();
}

function removeActivityListeners() {
    if (activityListenersAdded && activityHandler) {
        const activityEvents = ['mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart', 'click'];
        
        activityEvents.forEach(event => {
            document.removeEventListener(event, activityHandler, true);
        });
        
        activityListenersAdded = false;
        activityHandler = null;
    }
}

// Navegação
function handleNavigation(e) {
    e.preventDefault();
    
    const target = e.currentTarget.getAttribute('href').substring(1);
    
    // Atualizar navegação ativa
    navLinks.forEach(link => link.classList.remove('active'));
    const submenuLinks = document.querySelectorAll('.submenu-item');
    submenuLinks.forEach(link => link.classList.remove('active'));
    e.currentTarget.classList.add('active');
    
    // Mostrar seção correspondente
    contentSections.forEach(section => {
        section.classList.add('hidden');
        if (section.id === target) {
            section.classList.remove('hidden');
            section.classList.add('fade-in');
            
            // Atualizar gráficos apenas quando a seção de relatórios for exibida
            if (target === 'reports') {
                console.log('Seção de relatórios ativada, atualizando gráficos...');
                setTimeout(() => {
                    updateLoans7DaysChart();
                    updateOverdueLoansChart();
                    updateGrowthChart();
                    updateDistributionChart();
                }, 100);
            }
            
            // Carregar histórico de pagamentos quando a seção for exibida
            if (target === 'payment-history') {
                setTimeout(() => {
                    // Carregar dados
                    
                    populateWeekSelector();
                }, 100);
            }
            
            // Carregar dados das despesas quando a seção for exibida
            if (target === 'expenses') {
                console.log('Seção de despesas ativada, carregando dados...');
                loadExpenses();
            }
            
            // Atualizar lista de clientes quando a seção de histórico for exibida
            if (target === 'history') {
                console.log('Seção de histórico ativada, atualizando lista de clientes...');
                setTimeout(() => {
                    populateHistoryClientSelect();
                }, 100);
            }
            
            // Carregar dados dos parcelamentos quando a seção for exibida
            if (target === 'installments') {
                console.log('Seção de parcelamentos ativada, carregando dados...');
                loadInstallments();
            }
            
            // Carregar dados dos empréstimos vencidos quando a seção for exibida
            if (target === 'overdueLoans') {
                console.log('Seção de empréstimos vencidos ativada, carregando dados...');
                loadOverdueLoans();
            }
            
            // Inicializar seção de comissões quando for exibida
            if (target === 'commissions') {
                console.log('Seção de comissões ativada, inicializando...');
                initializeCommissionsSection();
            }
            

        }
    });
}

// Carregar dados
async function loadData() {
    if (isLoadingData) {
        console.log('Dados já estão sendo carregados, ignorando chamada duplicada');
        return;
    }
    
    isLoadingData = true;
    console.log('Iniciando carregamento de dados...');
    
    try {
        // Primeiro, testar a conectividade com categorias
        await testCategoriesConnection();
        
        await Promise.all([
            loadClients(),
            loadLoans(),
            loadExpenses(),
            loadExpenseCategories(),
            loadGuarantors(),
            loadEmergencyContacts(),
            loadCashTransactions(),
            loadCashSettings(),
            loadCapitalRaisings(),

        ]);
        
        // Carregar empréstimos quitados separadamente
        await renderPaidLoansTable();
        
        await updateDashboard();
        await updateCharts();
        
        console.log('Dados carregados com sucesso');
    } catch (error) {
        console.error('Erro ao carregar dados:', error);
    } finally {
        isLoadingData = false;
    }
}

// Carregar clientes com otimizações de performance e cache
async function loadClients(forceReload = false) {
    const now = Date.now();
    
    // Verificar se os dados ainda estão válidos no cache
    if (!forceReload && clientsLastLoaded && (now - clientsLastLoaded) < CACHE_DURATION && clients.length > 0) {
        console.log('Usando dados do cache para clientes');
        renderClientsTable();
        return;
    }
    
    const loadingIndicator = document.getElementById('clientsLoadingIndicator');
    
    try {
        // Mostrar indicador de carregamento
        if (loadingIndicator) {
            loadingIndicator.classList.remove('hidden');
        }
        
        console.log('Carregando clientes do servidor...');
        
        // Carregar campos essenciais incluindo RG e data de nascimento
        const { data, error } = await supabase
            .from('clients')
            .select('id, name, cpf, rg, phone, email, address, birth_date, created_at')
            .order('created_at', { ascending: false });
        
        if (error) throw error;
        
        clients = data || [];
        filteredClients = [...clients];
        currentPage = 1; // Resetar para primeira página
        clientsLastLoaded = now; // Atualizar timestamp do cache
        
        console.log(`${clients.length} clientes carregados`);
        
        // Debug: Log dos primeiros clientes para verificar se RG e birth_date estão sendo carregados
        if (clients.length > 0) {
            console.log('Exemplo de cliente carregado:', {
                name: clients[0].name,
                cpf: clients[0].cpf,
                rg: clients[0].rg,
                birth_date: clients[0].birth_date
            });
        }
        
        // Renderizar tabela e popular select do histórico de forma assíncrona
        renderClientsTable();
        
        // Popular select do histórico de forma não-bloqueante
        setTimeout(() => {
            populateHistoryClientSelect();
        }, 100);
        
    } catch (error) {
        console.error('Erro ao carregar clientes:', error);
        clients = [];
        filteredClients = [];
        
        // Mostrar erro na tabela
        const tbody = document.getElementById('clientsTableBody');
        if (tbody) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="6" class="px-6 py-8 text-center text-red-400">
                        Erro ao carregar clientes. Tente novamente.
                        <br>
                        <button onclick="loadClients(true)" class="mt-2 text-blue-400 hover:text-blue-300 underline">
                            Tentar novamente
                        </button>
                    </td>
                </tr>
            `;
        }
    } finally {
        // Esconder indicador de carregamento
        if (loadingIndicator) {
            loadingIndicator.classList.add('hidden');
        }
    }
}

// Carregar avalistas
async function loadGuarantors() {
    try {
        const { data, error } = await supabase
            .from('guarantors')
            .select('*')
            .order('created_at', { ascending: false });
        
        if (error) throw error;
        
        guarantors = data || [];
        
    } catch (error) {
        console.error('Erro ao carregar avalistas:', error);
        guarantors = [];
    }
}

// Carregar contatos de emergência
async function loadEmergencyContacts() {
    try {
        const { data, error } = await supabase
            .from('emergency_contacts')
            .select('*')
            .order('created_at', { ascending: false });
        
        if (error) throw error;
        
        emergencyContacts = data || [];
        
    } catch (error) {
        console.error('Erro ao carregar contatos de emergência:', error);
        emergencyContacts = [];
    }
}

// Carregar avalistas de um cliente específico
async function loadClientGuarantors(clientId) {
    try {
        const { data, error } = await supabase
            .from('guarantors')
            .select('*')
            .eq('client_id', clientId)
            .order('created_at', { ascending: false });
        
        if (error) throw error;
        
        return data || [];
        
    } catch (error) {
        console.error('Erro ao carregar avalistas do cliente:', error);
        return [];
    }
}

// Carregar contatos de emergência de um cliente específico
async function loadClientEmergencyContacts(clientId) {
    try {
        const { data, error } = await supabase
            .from('emergency_contacts')
            .select('*')
            .eq('client_id', clientId)
            .order('created_at', { ascending: false });
        
        if (error) throw error;
        
        return data || [];
        
    } catch (error) {
        console.error('Erro ao carregar contatos de emergência do cliente:', error);
        return [];
    }
}

// Carregar empréstimos
async function loadLoans() {
    try {
        const { data, error } = await supabase
            .from('loans')
            .select(`
                *,
                clients (
                    name,
                    cpf,
                    email,
                    phone
                )
            `)
            .order('created_at', { ascending: false });
        
        if (error) throw error;
        
        loans = data || [];
        filteredLoans = [...loans]; // Inicializar filteredLoans
        
        // Aplicar filtros restaurados (se houver) ao invés de renderizar diretamente
        applyFiltersAndSort();
        
    } catch (error) {
        console.error('Erro ao carregar empréstimos:', error);
        loans = [];
    }
}

// Renderizar tabela de clientes com paginação
function renderClientsTable() {
    const tbody = document.getElementById('clientsTableBody');
    const loadingIndicator = document.getElementById('clientsLoadingIndicator');
    
    // Mostrar indicador de carregamento
    if (loadingIndicator) {
        loadingIndicator.classList.remove('hidden');
    }
    
    // Usar setTimeout para não bloquear a UI durante a renderização
    setTimeout(() => {
        if (filteredClients.length === 0) {
            const message = clients.length === 0 
                ? 'Nenhum cliente cadastrado ainda'
                : 'Nenhum cliente encontrado com os critérios de busca';
            
            tbody.innerHTML = `
                <tr>
                    <td colspan="6" class="px-6 py-8 text-center text-gray-400">
                        ${message}
                    </td>
                </tr>
            `;
            updatePaginationControls(0);
            if (loadingIndicator) {
                loadingIndicator.classList.add('hidden');
            }
            return;
        }
        
        // Calcular índices para paginação
        const startIndex = (currentPage - 1) * itemsPerPage;
        const endIndex = Math.min(startIndex + itemsPerPage, filteredClients.length);
        const clientsToShow = filteredClients.slice(startIndex, endIndex);
        
        // Renderizar apenas os clientes da página atual
        tbody.innerHTML = clientsToShow.map(client => `
            <tr class="table-row">
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                        <div class="flex-shrink-0 h-10 w-10">
                            <div class="h-10 w-10 rounded-full bg-gray-600 flex items-center justify-center">
                                <span class="text-white font-semibold">${client.name.charAt(0).toUpperCase()}</span>
                            </div>
                        </div>
                        <div class="ml-4">
                            <div class="text-sm font-medium text-white">${client.name}</div>
                        </div>
                    </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${client.cpf}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${client.phone || ''}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${client.email || ''}</td>
                <td class="px-6 py-4 text-sm text-gray-300 max-w-xs truncate">${client.address || ''}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    <button class="text-blue-400 hover:text-blue-300 mr-3" onclick="editClient('${client.id}')" title="Ver informações">👁️</button>
                    <button class="text-yellow-400 hover:text-yellow-300 mr-3" onclick="openEditClientModal('${client.id}')" title="Editar cliente">✏️</button>
                    <button class="text-green-400 hover:text-green-300 mr-3" onclick="openClientDocuments('${client.id}', '${client.name}')" title="Documentos">📄</button>
                    <button class="text-red-400 hover:text-red-300" onclick="deleteClient('${client.id}')" title="Excluir cliente">🗑️</button>
                </td>
            </tr>
        `).join('');
        
        // Atualizar controles de paginação
        updatePaginationControls(filteredClients.length);
        
        // Esconder indicador de carregamento
        if (loadingIndicator) {
            loadingIndicator.classList.add('hidden');
        }
    }, 10);
}

// Função para buscar clientes com debounce para melhor performance
let searchTimeout;
function searchClients(searchTerm) {
    // Limpar timeout anterior para implementar debounce
    clearTimeout(searchTimeout);
    
    searchTimeout = setTimeout(() => {
        currentPage = 1; // Resetar para primeira página ao buscar
        
        if (!searchTerm || searchTerm.trim() === '') {
            filteredClients = [...clients];
        } else {
            const term = searchTerm.toLowerCase().trim();
            filteredClients = clients.filter(client => {
                return (
                    client.name.toLowerCase().includes(term) ||
                    client.cpf.toLowerCase().includes(term) ||
                    (client.rg && client.rg.toLowerCase().includes(term)) ||
                    (client.phone && client.phone.toLowerCase().includes(term)) ||
                    (client.email && client.email.toLowerCase().includes(term)) ||
                    (client.address && client.address.toLowerCase().includes(term))
                );
            });
        }
        renderClientsTable();
    }, 300); // Aguardar 300ms após parar de digitar
}

// Função para limpar busca de clientes
function clearClientSearch() {
    const searchInput = document.getElementById('clientSearchInput');
    if (searchInput) {
        searchInput.value = '';
        filteredClients = [...clients];
        currentPage = 1;
        renderClientsTable();
    }
}

// Função para atualizar controles de paginação
function updatePaginationControls(totalItems) {
    const totalPages = Math.ceil(totalItems / itemsPerPage);
    const paginationContainer = document.getElementById('clientsPagination');
    
    if (!paginationContainer) return;
    
    if (totalPages <= 1) {
        paginationContainer.classList.add('hidden');
        return;
    }
    
    paginationContainer.classList.remove('hidden');
    
    const startItem = totalItems === 0 ? 0 : (currentPage - 1) * itemsPerPage + 1;
    const endItem = Math.min(currentPage * itemsPerPage, totalItems);
    
    paginationContainer.innerHTML = `
        <div class="flex items-center justify-between">
            <div class="text-sm text-gray-400">
                Mostrando ${startItem} a ${endItem} de ${totalItems} clientes
            </div>
            <div class="flex items-center space-x-2">
                <button 
                    class="px-3 py-1 text-sm bg-gray-700 text-white rounded hover:bg-gray-600 disabled:opacity-50 disabled:cursor-not-allowed"
                    onclick="changePage(${currentPage - 1})"
                    ${currentPage <= 1 ? 'disabled' : ''}
                >
                    Anterior
                </button>
                
                <div class="flex space-x-1">
                    ${generatePageNumbers(currentPage, totalPages)}
                </div>
                
                <button 
                    class="px-3 py-1 text-sm bg-gray-700 text-white rounded hover:bg-gray-600 disabled:opacity-50 disabled:cursor-not-allowed"
                    onclick="changePage(${currentPage + 1})"
                    ${currentPage >= totalPages ? 'disabled' : ''}
                >
                    Próximo
                </button>
            </div>
        </div>
    `;
}

// Função para gerar números das páginas
function generatePageNumbers(current, total) {
    const pages = [];
    const maxVisible = 5;
    let start = Math.max(1, current - Math.floor(maxVisible / 2));
    let end = Math.min(total, start + maxVisible - 1);
    
    if (end - start < maxVisible - 1) {
        start = Math.max(1, end - maxVisible + 1);
    }
    
    for (let i = start; i <= end; i++) {
        const isActive = i === current;
        pages.push(`
            <button 
                class="px-3 py-1 text-sm rounded ${isActive 
                    ? 'bg-blue-600 text-white' 
                    : 'bg-gray-700 text-gray-300 hover:bg-gray-600'}"
                onclick="changePage(${i})"
            >
                ${i}
            </button>
        `);
    }
    
    return pages.join('');
}

// Função para mudar página
function changePage(newPage) {
    const totalPages = Math.ceil(filteredClients.length / itemsPerPage);
    
    if (newPage < 1 || newPage > totalPages) return;
    
    currentPage = newPage;
    renderClientsTable();
}

// Função para buscar empréstimos
function searchLoans(searchTerm) {
    applyFiltersAndSort();
}

// Função para salvar filtros de empréstimos no localStorage
function saveLoanFilters() {
    const filters = {
        searchTerm: document.getElementById('loanSearchInput')?.value || '',
        creationDateFrom: document.getElementById('creationDateFrom')?.value || '',
        creationDateTo: document.getElementById('creationDateTo')?.value || '',
        dueDateFrom: document.getElementById('dueDateFrom')?.value || '',
        dueDateTo: document.getElementById('dueDateTo')?.value || '',
        sortBy: document.getElementById('sortBy')?.value || 'loan_date',
        sortOrder: document.getElementById('sortOrder')?.value || 'desc'
    };
    
    localStorage.setItem('loanFilters', JSON.stringify(filters));
}

// Função para restaurar filtros de empréstimos do localStorage
function restoreLoanFilters() {
    try {
        const savedFilters = localStorage.getItem('loanFilters');
        
        if (savedFilters) {
            const filters = JSON.parse(savedFilters);
            
            // Restaurar valores nos campos
            const searchInput = document.getElementById('loanSearchInput');
            const creationDateFrom = document.getElementById('creationDateFrom');
            const creationDateTo = document.getElementById('creationDateTo');
            const dueDateFrom = document.getElementById('dueDateFrom');
            const dueDateTo = document.getElementById('dueDateTo');
            const sortBy = document.getElementById('sortBy');
            const sortOrder = document.getElementById('sortOrder');
            
            if (searchInput) searchInput.value = filters.searchTerm || '';
            if (creationDateFrom) creationDateFrom.value = filters.creationDateFrom || '';
            if (creationDateTo) creationDateTo.value = filters.creationDateTo || '';
            if (dueDateFrom) dueDateFrom.value = filters.dueDateFrom || '';
            if (dueDateTo) dueDateTo.value = filters.dueDateTo || '';
            if (sortBy) sortBy.value = filters.sortBy || 'loan_date';
            if (sortOrder) sortOrder.value = filters.sortOrder || 'desc';
            
            console.log('Filtros de empréstimos restaurados:', filters);
        }
    } catch (error) {
        console.error('Erro ao restaurar filtros de empréstimos:', error);
    }
}

// Função principal para aplicar filtros e ordenação
function applyFiltersAndSort() {
    let result = [...loans];
    
    // Se não há empréstimos, não continuar
    if (result.length === 0) {
        filteredLoans = result;
        renderLoansTable();
        return;
    }
    
    // Aplicar filtro de busca por texto
    const searchInput = document.getElementById('loanSearchInput');
    const searchTerm = searchInput ? searchInput.value.trim() : '';
    
    if (searchTerm !== '') {
        const term = searchTerm.toLowerCase().trim();
        result = result.filter(loan => {
            // Encontrar o cliente associado ao empréstimo
            const client = clients.find(c => c.id === loan.client_id);
            const clientName = client ? client.name.toLowerCase() : '';
            
            return (
                clientName.includes(term) ||
                loan.amount.toString().includes(term) ||
                loan.interest_rate.toString().includes(term) ||
                loan.status.toLowerCase().includes(term) ||
                (loan.loan_date && loan.loan_date.includes(term)) ||
                (loan.due_date && loan.due_date.includes(term))
            );
        });
    }
    
    // Aplicar filtro por data de criação
    const creationDateFrom = document.getElementById('creationDateFrom')?.value;
    const creationDateTo = document.getElementById('creationDateTo')?.value;
    
    if (creationDateFrom) {
        result = result.filter(loan => {
            if (!loan.loan_date) return false;
            const loanDate = new Date(loan.loan_date);
            const fromDate = new Date(creationDateFrom);
            return !isNaN(loanDate.getTime()) && !isNaN(fromDate.getTime()) && loanDate >= fromDate;
        });
    }
    
    if (creationDateTo) {
        result = result.filter(loan => {
            if (!loan.loan_date) return false;
            const loanDate = new Date(loan.loan_date);
            const toDate = new Date(creationDateTo);
            toDate.setHours(23, 59, 59, 999); // Incluir o dia inteiro
            return !isNaN(loanDate.getTime()) && !isNaN(toDate.getTime()) && loanDate <= toDate;
        });
    }
    
    // Aplicar filtro por data de vencimento
    const dueDateFrom = document.getElementById('dueDateFrom')?.value;
    const dueDateTo = document.getElementById('dueDateTo')?.value;
    
    if (dueDateFrom) {
        result = result.filter(loan => {
            if (!loan.due_date) return false;
            const dueDate = new Date(loan.due_date);
            const fromDate = new Date(dueDateFrom);
            return !isNaN(dueDate.getTime()) && !isNaN(fromDate.getTime()) && dueDate >= fromDate;
        });
    }
    
    if (dueDateTo) {
        result = result.filter(loan => {
            if (!loan.due_date) return false;
            const dueDate = new Date(loan.due_date);
            const toDate = new Date(dueDateTo);
            toDate.setHours(23, 59, 59, 999); // Incluir o dia inteiro
            return !isNaN(dueDate.getTime()) && !isNaN(toDate.getTime()) && dueDate <= toDate;
        });
    }
    
    // Aplicar ordenação
    const sortBy = document.getElementById('sortBy')?.value || 'loan_date';
    const sortOrder = document.getElementById('sortOrder')?.value || 'desc';
    
    result.sort((a, b) => {
        let valueA, valueB;
        
        switch (sortBy) {
            case 'loan_date':
                valueA = a.loan_date ? new Date(a.loan_date) : new Date(0);
                valueB = b.loan_date ? new Date(b.loan_date) : new Date(0);
                break;
            case 'due_date':
                valueA = a.due_date ? new Date(a.due_date) : new Date(0);
                valueB = b.due_date ? new Date(b.due_date) : new Date(0);
                break;
            case 'vence_hoje':
                // Ordenar por empréstimos que vencem hoje primeiro
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                
                const dueDateA = a.due_date ? new Date(a.due_date) : new Date(0);
                const dueDateB = b.due_date ? new Date(b.due_date) : new Date(0);
                dueDateA.setHours(0, 0, 0, 0);
                dueDateB.setHours(0, 0, 0, 0);
                
                const venceHojeA = dueDateA.getTime() === today.getTime() ? 1 : 0;
                const venceHojeB = dueDateB.getTime() === today.getTime() ? 1 : 0;
                
                // Se ambos vencem hoje ou ambos não vencem hoje, ordenar por data de vencimento
                if (venceHojeA === venceHojeB) {
                    valueA = dueDateA;
                    valueB = dueDateB;
                } else {
                    // Priorizar os que vencem hoje
                    valueA = venceHojeA;
                    valueB = venceHojeB;
                }
                break;
            case 'amount':
                valueA = parseFloat(a.amount) || 0;
                valueB = parseFloat(b.amount) || 0;
                break;
            case 'client_name':
                const clientA = clients.find(c => c.id === a.client_id);
                const clientB = clients.find(c => c.id === b.client_id);
                valueA = clientA ? clientA.name.toLowerCase() : '';
                valueB = clientB ? clientB.name.toLowerCase() : '';
                break;
            default:
                valueA = a[sortBy] || '';
                valueB = b[sortBy] || '';
        }
        
        if (sortOrder === 'asc') {
            return valueA > valueB ? 1 : valueA < valueB ? -1 : 0;
        } else {
            return valueA < valueB ? 1 : valueA > valueB ? -1 : 0;
        }
    });
    
    filteredLoans = result;
    renderLoansTable();
}

// Função para limpar busca de empréstimos
function clearLoanSearch() {
    const searchInput = document.getElementById('loanSearchInput');
    if (searchInput) {
        searchInput.value = '';
        saveLoanFilters();
        applyFiltersAndSort();
    }
}

// Função para limpar todos os filtros
function clearAllFilters() {
    // Limpar campo de busca
    const searchInput = document.getElementById('loanSearchInput');
    if (searchInput) searchInput.value = '';
    
    // Limpar filtros de data
    const creationDateFrom = document.getElementById('creationDateFrom');
    const creationDateTo = document.getElementById('creationDateTo');
    const dueDateFrom = document.getElementById('dueDateFrom');
    const dueDateTo = document.getElementById('dueDateTo');
    
    if (creationDateFrom) creationDateFrom.value = '';
    if (creationDateTo) creationDateTo.value = '';
    if (dueDateFrom) dueDateFrom.value = '';
    if (dueDateTo) dueDateTo.value = '';
    
    // Resetar ordenação
    const sortBy = document.getElementById('sortBy');
    const sortOrder = document.getElementById('sortOrder');
    
    if (sortBy) sortBy.value = 'loan_date';
    if (sortOrder) sortOrder.value = 'desc';
    
    // Limpar filtros salvos do localStorage
    localStorage.removeItem('loanFilters');
    
    // Aplicar filtros
    applyFiltersAndSort();
}

// ===== FUNÇÕES DE FILTRO PARA PARCELAMENTOS =====

// Função para buscar parcelamentos
function searchInstallments(searchTerm) {
    applyInstallmentFiltersAndSort();
}

// Função principal para aplicar filtros e ordenação nos parcelamentos
function applyInstallmentFiltersAndSort() {
    let result = [...installments];
    
    // Se não há parcelamentos, não continuar
    if (result.length === 0) {
        filteredInstallments = result;
        renderInstallmentsTable();
        return;
    }
    
    // Aplicar filtro de busca por texto
    const searchInput = document.getElementById('installmentSearchInput');
    const searchTerm = searchInput ? searchInput.value.trim() : '';
    
    if (searchTerm !== '') {
        const term = searchTerm.toLowerCase().trim();
        result = result.filter(installment => {
            // Encontrar o cliente associado ao parcelamento
            const client = clients.find(c => c.id === installment.client_id);
            const clientName = client ? client.name.toLowerCase() : '';
            
            return clientName.includes(term);
        });
    }
    
    // Aplicar filtro por data de criação
    const creationDateFrom = document.getElementById('installmentCreationDateFrom')?.value;
    const creationDateTo = document.getElementById('installmentCreationDateTo')?.value;
    
    if (creationDateFrom) {
        result = result.filter(installment => {
            if (!installment.created_at) return false;
            const installmentDate = new Date(installment.created_at);
            const fromDate = new Date(creationDateFrom);
            return installmentDate >= fromDate;
        });
    }
    
    if (creationDateTo) {
        result = result.filter(installment => {
            if (!installment.created_at) return false;
            const installmentDate = new Date(installment.created_at);
            const toDate = new Date(creationDateTo);
            toDate.setHours(23, 59, 59, 999); // Incluir todo o dia
            return installmentDate <= toDate;
        });
    }
    
    // Aplicar filtro por próximo vencimento
    const dueDateFrom = document.getElementById('installmentDueDateFrom')?.value;
    const dueDateTo = document.getElementById('installmentDueDateTo')?.value;
    
    if (dueDateFrom || dueDateTo) {
        result = result.filter(installment => {
            // Calcular próximo vencimento
            const unpaidPayments = installment.installment_payments?.filter(p => p.status === 'pending') || [];
            if (unpaidPayments.length === 0) return false;
            
            const nextDueDate = new Date(Math.min(...unpaidPayments.map(p => new Date(p.due_date))));
            
            if (dueDateFrom) {
                const fromDate = new Date(dueDateFrom);
                if (nextDueDate < fromDate) return false;
            }
            
            if (dueDateTo) {
                const toDate = new Date(dueDateTo);
                toDate.setHours(23, 59, 59, 999);
                if (nextDueDate > toDate) return false;
            }
            
            return true;
        });
    }
    
    // Aplicar ordenação
    const sortBy = document.getElementById('installmentSortBy')?.value || 'created_at';
    const sortOrder = document.getElementById('installmentSortOrder')?.value || 'desc';
    
    result.sort((a, b) => {
        let aValue, bValue;
        
        switch (sortBy) {
            case 'created_at':
                aValue = new Date(a.created_at || 0);
                bValue = new Date(b.created_at || 0);
                break;
            case 'next_due_date':
                // Calcular próximo vencimento para ordenação
                const aUnpaid = a.installment_payments?.filter(p => p.status === 'pending') || [];
                const bUnpaid = b.installment_payments?.filter(p => p.status === 'pending') || [];
                
                aValue = aUnpaid.length > 0 ? new Date(Math.min(...aUnpaid.map(p => new Date(p.due_date)))) : new Date(0);
                bValue = bUnpaid.length > 0 ? new Date(Math.min(...bUnpaid.map(p => new Date(p.due_date)))) : new Date(0);
                break;
            case 'vence_hoje':
                // Priorizar parcelamentos que vencem hoje
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                
                const aUnpaidToday = a.installment_payments?.filter(p => p.status === 'pending') || [];
                const bUnpaidToday = b.installment_payments?.filter(p => p.status === 'pending') || [];
                
                const aNextDue = aUnpaidToday.length > 0 ? new Date(Math.min(...aUnpaidToday.map(p => new Date(p.due_date)))) : null;
                const bNextDue = bUnpaidToday.length > 0 ? new Date(Math.min(...bUnpaidToday.map(p => new Date(p.due_date)))) : null;
                
                if (aNextDue) aNextDue.setHours(0, 0, 0, 0);
                if (bNextDue) bNextDue.setHours(0, 0, 0, 0);
                
                const aVenceHoje = aNextDue && aNextDue.getTime() === today.getTime();
                const bVenceHoje = bNextDue && bNextDue.getTime() === today.getTime();
                
                if (aVenceHoje && !bVenceHoje) {
                    aValue = 1; bValue = 0; // a vence hoje, prioridade
                } else if (!aVenceHoje && bVenceHoje) {
                    aValue = 0; bValue = 1; // b vence hoje, prioridade
                } else if (aVenceHoje && bVenceHoje) {
                    // Ambos vencem hoje, ordenar por data de criação
                    aValue = new Date(a.created_at || 0);
                    bValue = new Date(b.created_at || 0);
                } else {
                    // Nenhum vence hoje, ordenar por próximo vencimento
                    aValue = aNextDue || new Date(0);
                    bValue = bNextDue || new Date(0);
                }
                break;
            case 'total_amount':
                aValue = parseFloat(a.total_amount || 0);
                bValue = parseFloat(b.total_amount || 0);
                break;
            case 'client_name':
                const clientA = clients.find(c => c.id === a.client_id);
                const clientB = clients.find(c => c.id === b.client_id);
                aValue = clientA ? clientA.name.toLowerCase() : '';
                bValue = clientB ? clientB.name.toLowerCase() : '';
                break;
            default:
                aValue = a[sortBy] || '';
                bValue = b[sortBy] || '';
        }
        
        if (sortOrder === 'asc') {
            return aValue > bValue ? 1 : aValue < bValue ? -1 : 0;
        } else {
            return aValue < bValue ? 1 : aValue > bValue ? -1 : 0;
        }
    });
    
    filteredInstallments = result;
    renderInstallmentsTable();
}

// Função para limpar busca de parcelamentos
function clearInstallmentSearch() {
    const searchInput = document.getElementById('installmentSearchInput');
    if (searchInput) {
        searchInput.value = '';
        applyInstallmentFiltersAndSort();
    }
}

// Função para limpar todos os filtros de parcelamentos
function clearAllInstallmentFilters() {
    // Limpar campo de busca
    const searchInput = document.getElementById('installmentSearchInput');
    if (searchInput) searchInput.value = '';
    
    // Limpar filtros de data
    const creationDateFrom = document.getElementById('installmentCreationDateFrom');
    const creationDateTo = document.getElementById('installmentCreationDateTo');
    const dueDateFrom = document.getElementById('installmentDueDateFrom');
    const dueDateTo = document.getElementById('installmentDueDateTo');
    
    if (creationDateFrom) creationDateFrom.value = '';
    if (creationDateTo) creationDateTo.value = '';
    if (dueDateFrom) dueDateFrom.value = '';
    if (dueDateTo) dueDateTo.value = '';
    
    // Resetar ordenação
    const sortBy = document.getElementById('installmentSortBy');
    const sortOrder = document.getElementById('installmentSortOrder');
    
    if (sortBy) sortBy.value = 'created_at';
    if (sortOrder) sortOrder.value = 'desc';
    
    // Aplicar filtros
    applyInstallmentFiltersAndSort();
}

// Renderizar tabela de empréstimos
async function renderLoansTable() {
    const tbody = document.getElementById('loansTableBody');
    
    // Verificar se há filtros ativos
    const searchInput = document.getElementById('loanSearchInput');
    const creationDateFrom = document.getElementById('creationDateFrom');
    const creationDateTo = document.getElementById('creationDateTo');
    const dueDateFrom = document.getElementById('dueDateFrom');
    const dueDateTo = document.getElementById('dueDateTo');
    const sortBy = document.getElementById('sortBy');
    
    const hasActiveFilters = (searchInput && searchInput.value.trim() !== '') ||
                           (creationDateFrom && creationDateFrom.value !== '') ||
                           (creationDateTo && creationDateTo.value !== '') ||
                           (dueDateFrom && dueDateFrom.value !== '') ||
                           (dueDateTo && dueDateTo.value !== '') ||
                           (sortBy && sortBy.value !== 'loan_date');
    
    const loansToShow = hasActiveFilters ? filteredLoans : loans;
    
    // Filtrar apenas empréstimos ativos (não quitados)
    const activeLoans = loansToShow.filter(loan => loan.status !== 'paid');
    
    if (activeLoans.length === 0) {
        const message = hasActiveFilters 
            ? 'Nenhum empréstimo encontrado com os filtros aplicados'
            : 'Nenhum empréstimo ativo';
        tbody.innerHTML = `
            <tr>
                <td colspan="8" class="px-6 py-8 text-center text-gray-400">
                    ${message}
                </td>
            </tr>
        `;
        return;
    }
    
    // Renderizar linhas com valores atualizados usando cálculo em lote
    const loanIds = activeLoans.map(loan => loan.id);
    const remainingAmounts = await calculateBatchLoanRemainingAmounts(loanIds);
    
    let tableHTML = '';
    for (let i = 0; i < activeLoans.length; i++) {
        const loan = activeLoans[i];
        const originalTotal = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
        const remainingAmount = remainingAmounts[i];
        const status = getLoanStatus(loan.due_date, loan.status);
        
        tableHTML += `
            <tr class="table-row">
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm font-medium text-white">${loan.clients?.name || 'Cliente não encontrado'}</div>
                    <div class="text-sm text-gray-300">${loan.clients?.cpf || ''}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">R$ ${parseFloat(loan.amount).toFixed(2)}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${loan.interest_rate}%</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(loan.loan_date)}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(loan.due_date)}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-white">
                    <div>Original: R$ ${originalTotal.toFixed(2)}</div>
                    <div class="text-blue-300">Restante: R$ ${remainingAmount.toFixed(2)}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                    <span class="status-badge ${getStatusClass(status)}">${getStatusText(status)}</span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    <button class="text-blue-400 hover:text-blue-300 mr-3" onclick="editLoan('${loan.id}')">✏️</button>
                    <button class="text-purple-400 hover:text-purple-300 mr-3" onclick="showPaymentHistory('${loan.id}')">💰</button>
                    <button class="text-orange-400 hover:text-orange-300 mr-3" onclick="generateContract('${loan.id}')" title="Gerar Contrato">📄</button>
                    <button class="text-green-400 hover:text-green-300 mr-3" onclick="markLoanAsPaid('${loan.id}')" ${loan.status === 'paid' ? 'disabled' : ''}>✅</button>
                    <button class="text-yellow-400 hover:text-yellow-300 mr-3" onclick="showPixKeySelector('${loan.id}')" title="Enviar cobrança via WhatsApp">📞</button>
                    <button class="text-cyan-400 hover:text-cyan-300 mr-3" onclick="contactGuarantorOrEmergency('${loan.id}')" title="Contatar Avalista ou Emergência">👥</button>
                    <button class="text-red-400 hover:text-red-300" onclick="deleteLoan('${loan.id}')">🗑️</button>
                </td>
            </tr>
        `;
    }
    
    tbody.innerHTML = tableHTML;
}



// Renderizar tabela de empréstimos quitados
async function renderPaidLoansTable() {
    try {
        console.log('Iniciando carregamento de empréstimos quitados...');
        
        // Verificar se o elemento tbody existe
        const tbody = document.getElementById('paidLoansTableBody');
        if (!tbody) {
            console.error('Elemento paidLoansTableBody não encontrado');
            return;
        }
        
        // Buscar empréstimos quitados da tabela paid_loans
        const { data: paidLoans, error } = await supabase
            .from('paid_loans')
            .select('*')
            .order('paid_date', { ascending: false });
        
        if (error) {
            console.error('Erro ao buscar empréstimos quitados:', error);
            throw error;
        }
        
        // Buscar dados dos clientes separadamente
        let clientsData = {};
        if (paidLoans && paidLoans.length > 0) {
            const clientIds = [...new Set(paidLoans.map(loan => loan.client_id))];
            const { data: clients, error: clientsError } = await supabase
                .from('clients')
                .select('id, name, cpf, email, phone')
                .in('id', clientIds);
            
            if (!clientsError && clients) {
                clientsData = clients.reduce((acc, client) => {
                    acc[client.id] = client;
                    return acc;
                }, {});
            }
        }
        
        if (error) {
            console.error('Erro na consulta Supabase:', error);
            throw error;
        }
        
        console.log('Dados recebidos:', paidLoans);
        
        if (!paidLoans || paidLoans.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="8" class="px-6 py-8 text-center text-gray-400">
                        Nenhum empréstimo quitado
                    </td>
                </tr>
            `;
            return;
        }
        
        // Renderizar linhas com valores atualizados
        let tableHTML = '';
        for (const paidLoan of paidLoans) {
            try {
                // Verificar se os dados necessários existem
                if (!paidLoan) {
                    console.warn('Empréstimo quitado inválido:', paidLoan);
                    continue;
                }
                
                // Função auxiliar para formatar valores com segurança
                const safeFormatNumber = (value, defaultValue = '0.00') => {
                    try {
                        if (value === null || value === undefined) return defaultValue;
                        const num = parseFloat(value);
                        return isNaN(num) ? defaultValue : num.toFixed(2);
                    } catch (e) {
                        return defaultValue;
                    }
                };
                
                // Função auxiliar para formatar datas com segurança
                const safeFormatDate = (dateString) => {
                    try {
                        if (!dateString) return 'N/A';
                        return formatDate(dateString);
                    } catch (e) {
                        console.warn('Erro ao formatar data:', dateString, e);
                        return 'Data inválida';
                    }
                };
                
                tableHTML += `
                    <tr class="table-row">
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm font-medium text-white">${clientsData[paidLoan.client_id]?.name || 'Cliente não encontrado'}</div>
                            <div class="text-sm text-gray-300">${clientsData[paidLoan.client_id]?.cpf || ''}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">R$ ${safeFormatNumber(paidLoan.original_amount)}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${paidLoan.interest_rate || 0}%</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${safeFormatDate(paidLoan.loan_date)}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${safeFormatDate(paidLoan.due_date)}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-green-300">
                            R$ ${safeFormatNumber(paidLoan.total_paid)}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                            ${safeFormatDate(paidLoan.paid_date)}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            <button class="text-blue-400 hover:text-blue-300 mr-3" onclick="showPaidLoanDetails('${paidLoan.id}')">ℹ️</button>
                            <button class="text-green-400 hover:text-green-300 mr-3" onclick="restorePaidLoan('${paidLoan.id}')">🔄</button>
                            <button class="text-red-400 hover:text-red-300" onclick="deletePaidLoan('${paidLoan.id}')">🗑️</button>
                        </td>
                    </tr>
                `;
            } catch (rowError) {
                console.error('Erro ao processar linha:', paidLoan, rowError);
                // Continuar com a próxima linha
            }
        }
        
        tbody.innerHTML = tableHTML;
        console.log('Tabela de empréstimos quitados renderizada com sucesso');
        
    } catch (error) {
        console.error('Erro ao carregar empréstimos quitados:', error);
        
        // Tentar mostrar o erro de forma mais detalhada
        const tbody = document.getElementById('paidLoansTableBody');
        if (tbody) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="8" class="px-6 py-8 text-center text-gray-400">
                        <div class="text-red-400 mb-2">Erro ao carregar empréstimos quitados</div>
                        <div class="text-xs text-gray-500">${error.message || 'Erro desconhecido'}</div>
                    </td>
                </tr>
            `;
        }
    }
}



// Handlers de formulários
async function handleNewClient(e) {
    e.preventDefault();
    

    
    const formData = {
        name: document.getElementById('clientName').value,
        cpf: document.getElementById('clientCPF').value,
        email: document.getElementById('clientEmail').value,
        phone: document.getElementById('clientPhone').value,
        address: document.getElementById('clientAddress').value,
        rg: document.getElementById('clientRG').value || null,
        birth_date: document.getElementById('clientBirthDate').value || null,
        created_by: currentUser.id,
        created_at: new Date().toISOString()
    };
    
    // Verificar se deve incluir avalista
    const includeGuarantor = document.getElementById('includeGuarantor').checked;
    let guarantorData = null;
    
    if (includeGuarantor) {
        const guarantorName = document.getElementById('newClientGuarantorName').value.trim();
        const guarantorCPF = document.getElementById('newClientGuarantorCPF').value.trim();
        const guarantorPhone = document.getElementById('newClientGuarantorPhone').value.trim();
        
        // Validar campos obrigatórios do avalista
        if (!guarantorName || !guarantorCPF || !guarantorPhone) {
            alert('Por favor, preencha pelo menos o nome, CPF e telefone do avalista.');
            return;
        }
        
        guarantorData = {
            name: guarantorName,
            cpf: guarantorCPF,
            rg: document.getElementById('newClientGuarantorRG').value.trim(),
            email: document.getElementById('newClientGuarantorEmail').value.trim(),
            phone: guarantorPhone,
            address: document.getElementById('newClientGuarantorAddress').value.trim(),
            birth_date: document.getElementById('newClientGuarantorBirthDate').value || null,
            relationship: document.getElementById('newClientGuarantorRelationship').value,
            photo: document.getElementById('newClientGuarantorPhoto').value,
            created_by: currentUser.id,
            created_at: new Date().toISOString()
        };
    }
    
    // Verificar se deve incluir contato de emergência
    const includeEmergencyContact = document.getElementById('includeEmergencyContact').checked;
    let emergencyContactData = null;
    
    if (includeEmergencyContact) {
        const emergencyContactName = document.getElementById('newClientEmergencyContactName').value.trim();
        const emergencyContactPhone = document.getElementById('newClientEmergencyContactPhone').value.trim();
        
        // Só criar contato de emergência se pelo menos um campo estiver preenchido
        if (emergencyContactName || emergencyContactPhone) {
            emergencyContactData = {
                name: emergencyContactName || null,
                phone: emergencyContactPhone || null,
                created_by: currentUser.id,
                created_at: new Date().toISOString()
            };
        }
    }
    
    try {
        console.log('Inserting client data:', formData); // Debug log
        const { data, error } = await supabase
            .from('clients')
            .insert([formData])
            .select();
        
        if (error) {
            console.error('Database error:', error);
            throw error;
        }
        
        console.log('Client created successfully:', data); // Debug log
        
        const newClient = data[0];
        
        // Se incluir avalista, criar o registro do avalista
        if (includeGuarantor && guarantorData && newClient) {
            guarantorData.client_id = newClient.id;
            
            console.log('Inserting guarantor data:', guarantorData); // Debug log
            const { data: guarantorResult, error: guarantorError } = await supabase
                .from('guarantors')
                .insert([guarantorData])
                .select();
            
            if (guarantorError) {
                console.error('Guarantor database error:', guarantorError);
                // Não falhar a criação do cliente se o avalista falhar
                console.warn('Cliente criado, mas houve erro ao criar avalista:', guarantorError.message);
            } else {
                console.log('Guarantor created successfully:', guarantorResult);
            }
        }
        
        // Se incluir contato de emergência, criar o registro do contato
        if (includeEmergencyContact && emergencyContactData && newClient) {
            emergencyContactData.client_id = newClient.id;
            
            console.log('Inserting emergency contact data:', emergencyContactData); // Debug log
            const { data: emergencyContactResult, error: emergencyContactError } = await supabase
                .from('emergency_contacts')
                .insert([emergencyContactData])
                .select();
            
            if (emergencyContactError) {
                console.error('Emergency contact database error:', emergencyContactError);
                // Não falhar a criação do cliente se o contato de emergência falhar
                console.warn('Cliente criado, mas houve erro ao criar contato de emergência:', emergencyContactError.message);
            } else {
                console.log('Emergency contact created successfully:', emergencyContactResult);
            }
        }
        
        hideModal(newClientModal);
        newClientForm.reset();
        
        // Resetar seção de avalista
        document.getElementById('includeGuarantor').checked = false;
        document.getElementById('guarantorSection').classList.add('hidden');
        document.getElementById('newClientGuarantorPhoto').value = '';
        document.getElementById('newClientGuarantorPhotoUploadPreview').classList.add('hidden');
        
        // Resetar seção de contato de emergência
        document.getElementById('includeEmergencyContact').checked = false;
        document.getElementById('emergencyContactSection').classList.add('hidden');
        clearNewClientEmergencyContactForm();
        
        await loadClients(true); // Forçar reload para invalidar cache
        await loadGuarantors();
        await loadEmergencyContacts();
        await updateDashboard();
        
        // Criar mensagem de sucesso dinâmica
        let successMessage = 'Cliente criado com sucesso!';
        if (includeGuarantor && guarantorData && includeEmergencyContact && emergencyContactData) {
            successMessage = 'Cliente, avalista e contato de emergência criados com sucesso!';
        } else if (includeGuarantor && guarantorData) {
            successMessage = 'Cliente e avalista criados com sucesso!';
        } else if (includeEmergencyContact && emergencyContactData) {
            successMessage = 'Cliente e contato de emergência criados com sucesso!';
        }
        showSuccessMessage(successMessage);
        
    } catch (error) {
        alert('Erro ao criar cliente: ' + error.message);
    }
}

async function handleNewLoan(e) {
    e.preventDefault();
    
    const loanAmount = parseFloat(document.getElementById('loanAmount').value);
    
    const formData = {
        client_id: document.getElementById('loanClient').value,
        amount: loanAmount,
        original_amount: loanAmount, // Preservar valor original do empréstimo
        interest_rate: parseFloat(document.getElementById('loanInterest').value),
        loan_date: document.getElementById('loanDate').value,
        due_date: document.getElementById('loanDueDate').value,
        status: 'active',
        created_by: currentUser.id,
        created_at: new Date().toISOString()
    };
    
    try {
        const { data, error } = await supabase
            .from('loans')
            .insert([formData])
            .select();
        
        if (error) throw error;
        
        hideModal(newLoanModal);
        newLoanForm.reset();
        
        invalidateLoanRemainingAmountsCache();
        await loadLoans();
        await updateDashboard();
        
        // Perguntar se deseja gerar contrato
        const generateContractNow = confirm('Empréstimo criado com sucesso! Deseja gerar o contrato agora?');
        if (generateContractNow && data && data[0]) {
            await generateContract(data[0].id);
        }
        
        // Mostrar modal para enviar resumo via WhatsApp
        if (data && data[0]) {
            // Aguardar um pouco para garantir que os dados estejam atualizados
            setTimeout(() => {
                showWhatsAppSummaryModal(data[0].id);
            }, 500);
        }
        
    } catch (error) {
        alert('Erro ao criar empréstimo: ' + error.message);
    }
}

// FUNÇÃO ANTIGA REMOVIDA: Substituída por handleNewRenewalPayment com opções
/*
async function handleLoanRenewal() {
    try {
        const loanId = document.getElementById('paymentForm').dataset.loanId;
        const paymentAmount = parseFloat(document.getElementById('paymentAmount').value);
        const paymentDate = document.getElementById('paymentDate').value;
        const paymentType = document.getElementById('paymentType').value;
        const paymentNotes = document.getElementById('paymentNotes').value;
        
        // Obter valores do modal para validação
        const interestText = document.getElementById('paymentInterestAmount').textContent;
        const currentInterestAmount = parseMonetaryValue(interestText);
        
        // Validar que o pagamento é exatamente o valor dos juros
        if (Math.abs(paymentAmount - currentInterestAmount) > 0.01) {
            alert('O valor do pagamento deve ser exatamente o valor dos juros para renovar o empréstimo.');
            return;
        }
        
        // Obter o empréstimo atual
        const loan = loans.find(l => l.id === loanId);
        if (!loan) {
            alert('Empréstimo não encontrado.');
            return;
        }
        
        // Confirmar com o usuário
        const confirmMsg = `Confirmar renovação do empréstimo por +30 dias?\n\nValor do pagamento (juros): R$ ${paymentAmount.toFixed(2)}\nNova data de vencimento: ${formatDateToAdd30Days(loan.due_date)}`;
        if (!confirm(confirmMsg)) {
            return;
        }
        
        // Registrar o pagamento dos juros
        const paymentMethodNote = `Método: ${paymentType}`;
        const combinedNotes = paymentNotes 
            ? `RENOVAÇÃO +30 DIAS | ${paymentNotes} | ${paymentMethodNote}`
            : `RENOVAÇÃO +30 DIAS | ${paymentMethodNote}`;
        
        const { data: paymentData, error: paymentError } = await supabase
            .from('payments')
            .insert({
                loan_id: loanId,
                amount: paymentAmount,
                payment_date: paymentDate,
                payment_type: 'interest_renewal',
                notes: combinedNotes,
                fine_amount: 0
            })
            .select();
        
        if (paymentError) throw paymentError;
        
        // Calcular nova data de vencimento (atual + 30 dias)
        const currentDueDate = new Date(loan.due_date);
        const newDueDate = new Date(currentDueDate);
        newDueDate.setDate(newDueDate.getDate() + 30);
        const newDueDateStr = newDueDate.toISOString().split('T')[0];
        
        // Atualizar o empréstimo com a nova data de vencimento
        const { error: loanError } = await supabase
            .from('loans')
            .update({
                due_date: newDueDateStr,
                status: 'active'
            })
            .eq('id', loanId);
        
        if (loanError) throw loanError;
        
        // Registrar a renovação nos pagamentos
        const renewalNote = `EMPRÉSTIMO RENOVADO: Data de vencimento estendida em +30 dias. Nova data: ${formatDate(newDueDateStr)}. Pagamento de juros: R$ ${paymentAmount.toFixed(2)}`;
        await supabase
            .from('payments')
            .insert({
                loan_id: loanId,
                amount: 0,
                payment_date: paymentDate,
                payment_type: 'loan_renewal',
                notes: renewalNote,
                fine_amount: 0
            });
        
        // Fechar modal e atualizar interface
        hideModal(paymentModal);
        document.getElementById('paymentForm').reset();
        await loadLoans();
        
        // Mostrar mensagem de sucesso
        alert(`✅ Empréstimo renovado com sucesso!\n\nPagamento de juros: R$ ${paymentAmount.toFixed(2)}\nNova data de vencimento: ${formatDate(newDueDateStr)}\n(+30 dias)`);
        
    } catch (error) {
        console.error('Erro ao renovar empréstimo:', error);
        alert('Erro ao renovar empréstimo: ' + error.message);
    }
}
*/

// Função auxiliar para converter valor monetário brasileiro para número
function parseMonetaryValue(text) {
    // Remove "R$" e espaços
    let cleanText = text.replace('R$', '').trim();
    
    // Se tem vírgula, assume formato brasileiro (1.234,56)
    if (cleanText.includes(',')) {
        // Remove pontos (separadores de milhares) e substitui vírgula por ponto
        cleanText = cleanText.replace(/\./g, '').replace(',', '.');
    }
    
    return parseFloat(cleanText);
}

// Função auxiliar para formatar data + 30 dias
function formatDateToAdd30Days(dateStr) {
    const date = new Date(dateStr);
    date.setDate(date.getDate() + 30);
    return formatDate(date.toISOString().split('T')[0]);
}

// Função para abrir modal de opções de renovação
async function openRenewalOptionsModal() {
    try {
        const loanId = document.getElementById('paymentForm').dataset.loanId;
        const paymentAmount = parseFloat(document.getElementById('paymentAmount').value);
        
        // Validar se há um valor de pagamento
        if (!paymentAmount || paymentAmount <= 0) {
            alert('Por favor, insira um valor de pagamento válido antes de renovar.');
            return;
        }
        
        // Obter o empréstimo atual
        const loan = loans.find(l => l.id === loanId);
        if (!loan) {
            alert('Empréstimo não encontrado.');
            return;
        }
        
        // Preencher informações no modal
        document.getElementById('renewalClientName').textContent = loan.clients?.name || 'Cliente não encontrado';
        document.getElementById('renewalPaymentAmount').textContent = `R$ ${paymentAmount.toFixed(2)}`;
        
        // Calcular nova data de vencimento (atual + 30 dias)
        const currentDueDate = new Date(loan.due_date);
        const newDueDate = new Date(currentDueDate);
        newDueDate.setDate(newDueDate.getDate() + 30);
        document.getElementById('renewalNewDueDate').textContent = formatDate(newDueDate.toISOString().split('T')[0]);
        
        // Mostrar modal
        showModal(renewalOptionsModal);
    } catch (error) {
        console.error('Erro ao abrir modal de renovação:', error);
        alert('Erro ao abrir modal de renovação: ' + error.message);
    }
}

// Função para lidar com renovação com pagamento
async function handleNewRenewalPayment(paymentOption) {
    try {
        const loanId = document.getElementById('paymentForm').dataset.loanId;
        const paymentAmount = parseFloat(document.getElementById('paymentAmount').value);
        const paymentDate = document.getElementById('paymentDate').value;
        const paymentType = document.getElementById('paymentType').value;
        const paymentNotes = document.getElementById('paymentNotes').value;
        
        // Obter o empréstimo atual
        const loan = loans.find(l => l.id === loanId);
        if (!loan) {
            alert('Empréstimo não encontrado.');
            return;
        }
        
        // Obter valores do modal para cálculos
        const capitalText = document.getElementById('paymentCapitalAmount').textContent;
        const interestText = document.getElementById('paymentInterestAmount').textContent;
        const capitalAmount = parseMonetaryValue(capitalText);
        const interestAmount = parseMonetaryValue(interestText);
        
        // Determinar tipo de pagamento e notas baseado na opção selecionada
        let finalPaymentType = '';
        let paymentDescription = '';
        
        switch(paymentOption) {
            case 'capital_juros':
                finalPaymentType = 'capital_interest_renewal';
                paymentDescription = 'RENOVAÇÃO +30 DIAS - Capital + Juros';
                break;
            case 'somente_juros':
                finalPaymentType = 'interest_renewal';
                paymentDescription = 'RENOVAÇÃO +30 DIAS - Somente Juros';
                break;
            case 'somente_capital':
                finalPaymentType = 'capital_renewal';
                paymentDescription = 'RENOVAÇÃO +30 DIAS - Somente Capital';
                break;
        }
        
        // Confirmar com o usuário
        const confirmMsg = `Confirmar renovação do empréstimo por +30 dias?\n\nTipo: ${paymentDescription}\nValor do pagamento: R$ ${paymentAmount.toFixed(2)}\nNova data de vencimento: ${formatDateToAdd30Days(loan.due_date)}`;
        if (!confirm(confirmMsg)) {
            return;
        }
        
        // Registrar o pagamento
        const paymentMethodNote = `Método: ${paymentType}`;
        const combinedNotes = paymentNotes 
            ? `${paymentDescription} | ${paymentNotes} | ${paymentMethodNote}`
            : `${paymentDescription} | ${paymentMethodNote}`;
        
        const { data: paymentData, error: paymentError } = await supabase
            .from('payments')
            .insert({
                loan_id: loanId,
                amount: paymentAmount,
                payment_date: paymentDate,
                payment_type: finalPaymentType,
                notes: combinedNotes,
                fine_amount: 0
            })
            .select();
        
        if (paymentError) throw paymentError;
        
        // Calcular nova data de vencimento (atual + 30 dias)
        const currentDueDate = new Date(loan.due_date);
        const newDueDate = new Date(currentDueDate);
        newDueDate.setDate(newDueDate.getDate() + 30);
        const newDueDateStr = newDueDate.toISOString().split('T')[0];
        
        // Atualizar o empréstimo com a nova data de vencimento
        const { error: loanError } = await supabase
            .from('loans')
            .update({
                due_date: newDueDateStr,
                status: 'active'
            })
            .eq('id', loanId);
        
        if (loanError) throw loanError;
        
        // Registrar a renovação nos pagamentos
        const renewalNote = `EMPRÉSTIMO RENOVADO: Data de vencimento estendida em +30 dias. Nova data: ${formatDate(newDueDateStr)}. ${paymentDescription}: R$ ${paymentAmount.toFixed(2)}`;
        await supabase
            .from('payments')
            .insert({
                loan_id: loanId,
                amount: 0,
                payment_date: paymentDate,
                payment_type: 'loan_renewal',
                notes: renewalNote,
                fine_amount: 0
            });
        
        // Fechar modais e atualizar interface
        hideModal(renewalOptionsModal);
        hideModal(paymentModal);
        document.getElementById('paymentForm').reset();
        
        // Invalidar cache e recarregar dados
        invalidateLoanRemainingAmountsCache();
        await loadLoans();
        await updateDashboard();
        
        // Preparar informações do pagamento para o modal de mensagens
        const paymentInfo = {
            amount: paymentAmount,
            type: finalPaymentType,
            date: paymentDate,
            newDueDate: newDueDateStr,
            isFullyPaid: false,
            isRenewal: true,
            paymentDescription: paymentDescription,
            recalcInfo: {
                isInterestOnlyRenewal: paymentOption === 'somente_juros',
                isCapitalAndInterest: paymentOption === 'capital_juros',
                isCapitalOnly: paymentOption === 'somente_capital'
            }
        };
        
        // Mostrar modal de mensagens ao cliente
        await showPaymentMessageModal(loanId, paymentInfo);
        
    } catch (error) {
        console.error('Erro ao renovar empréstimo:', error);
        alert('Erro ao renovar empréstimo: ' + error.message);
    }
}

// FUNÇÃO REMOVIDA: Agora usa apenas RENOVAR 30+
// Esta função foi substituída pela nova lógica de renovação com opções
/*
async function handlePayment(e) {
    e.preventDefault();
    
    const paymentAmount = parseFloat(document.getElementById('paymentAmount').value);
    const paymentDate = document.getElementById('paymentDate').value;
    const paymentType = document.getElementById('paymentType').value;
    const paymentNotes = document.getElementById('paymentNotes').value;
    const loanId = document.getElementById('paymentForm').dataset.loanId;
    const paymentId = document.getElementById('paymentForm').dataset.paymentId; // Verificar se é edição
    
    // Verificar se deve alterar a data de vencimento
    const changeDueDate = document.getElementById('changeDueDateCheckbox').checked;
    const newDueDate = changeDueDate ? document.getElementById('newDueDate').value : null;
    
    // Verificar se deve incluir multa
    const includeFine = document.getElementById('includeFineCheckbox').checked;
    const fineAmount = includeFine ? parseFloat(document.getElementById('fineAmount').value) || 0 : 0;
    
    try {
        // Validar se o valor não está abaixo do mínimo
        const minimumText = document.getElementById('paymentMinimumAmount').textContent;
        
        // Função auxiliar para converter valor monetário brasileiro para número
        function parseMonetaryValue(text) {
            let cleanText = text.replace('R$', '').trim();
            if (cleanText.includes(',')) {
                cleanText = cleanText.replace(/\./g, '').replace(',', '.');
            }
            return parseFloat(cleanText);
        }
        
        const minimumAmount = parseMonetaryValue(minimumText);
        
        if (paymentAmount < minimumAmount) {
            alert(`Valor do pagamento (R$ ${paymentAmount.toFixed(2)}) está abaixo do valor mínimo permitido (R$ ${minimumAmount.toFixed(2)})`);
            return;
        }
        
        // Se é uma edição, não recalcular o empréstimo (manter lógica original)
        let recalcInfo = { shouldRecalculate: false };
        if (!paymentId) {
            // REATIVADO: Identificar tipo de pagamento (renovação, capital, etc)
            // IMPORTANTE: Não altera o valor original do empréstimo (campo amount)
            // Apenas identifica o tipo para registrar corretamente nos pagamentos
            // Funciona tanto para empréstimos ativos quanto vencidos
            recalcInfo = await checkAndRecalculateLoan(loanId, paymentAmount, paymentType);
        }
        
        // Determinar o tipo correto de pagamento baseado na análise do recalcInfo
        let finalPaymentType = paymentType; // Por padrão, usa o método de pagamento
        let paymentMethodNote = `Método: ${paymentType}`; // Salvar método nas notas
        
        // Se foi identificado um tipo especial de pagamento (renovação, capital, etc), usar esse tipo
        if (recalcInfo.shouldRecalculate) {
            if (recalcInfo.isInterestOnlyRenewal) {
                finalPaymentType = 'interest_renewal';
            } else if (recalcInfo.isEarlyPaymentPartialInterest) {
                finalPaymentType = 'early_payment_partial_interest';
            } else if (recalcInfo.isEarlyPaymentInterestRenewal) {
                finalPaymentType = 'early_payment_interest_renewal';
            } else if (recalcInfo.isEarlyPaymentCapitalReduction) {
                finalPaymentType = 'early_payment_capital_reduction';
            } else if (recalcInfo.isCapitalReduction) {
                finalPaymentType = 'capital_payment';
            } else if (recalcInfo.isPartialInterestPayment) {
                finalPaymentType = 'partial_interest';
            }
        }
        
        // Combinar notas do usuário com método de pagamento
        const combinedNotes = paymentNotes 
            ? `${paymentNotes} | ${paymentMethodNote}`
            : paymentMethodNote;
        
        // Registrar ou atualizar o pagamento
        let paymentError;
        if (paymentId) {
            // Editar pagamento existente
            const { error } = await supabase
                .from('payments')
                .update({
                    amount: paymentAmount,
                    payment_date: paymentDate,
                    payment_type: finalPaymentType,
                    notes: combinedNotes,
                    fine_amount: fineAmount,
                    updated_at: new Date().toISOString()
                })
                .eq('id', paymentId);
            paymentError = error;
        } else {
            // Criar novo pagamento
            const { error } = await supabase
                .from('payments')
                .insert([{
                    loan_id: loanId,
                    amount: paymentAmount,
                    payment_date: paymentDate,
                    payment_type: finalPaymentType,
                    notes: combinedNotes,
                    fine_amount: fineAmount,
                    created_by: currentUser.id,
                    created_at: new Date().toISOString()
                }]);
            paymentError = error;
        }
        
        if (paymentError) throw paymentError;
        
        // Declarar updateData no escopo da função para uso posterior
        let updateData = null;
        
        // Se precisa recalcular, atualizar APENAS status e data de vencimento (NUNCA o valor original)
        if (recalcInfo.shouldRecalculate) {
            // Preparar dados para atualização - NUNCA alterar o campo amount (valor original)
            updateData = {
                updated_at: new Date().toISOString(),
                status: recalcInfo.isFullyPaid ? 'paid' : 'active'
            };
            
            // Se for renovação de juros, atualizar data de vencimento
            if (recalcInfo.isInterestOnlyRenewal) {
                updateData.due_date = recalcInfo.newDueDate;
            }
            
            // IMPORTANTE: NÃO atualizar o campo 'amount' para preservar valor original
            const { error: loanUpdateError } = await supabase
                .from('loans')
                .update(updateData)
                .eq('id', loanId);
            
            if (loanUpdateError) throw loanUpdateError;
            
            // Nota: O tipo de operação já foi registrado no pagamento principal com o payment_type correto
            // Não é mais necessário criar um segundo registro de pagamento
        } else {
            // Atualizar status do empréstimo baseado no valor do pagamento
            // Como agora o tipo representa método de pagamento, vamos verificar se o pagamento quita o empréstimo
            const loan = loans.find(l => l.id === loanId);
            const totalLoanAmount = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
            const remainingAmount = await calculateLoanRemainingAmount(loanId);
            
            let newStatus = 'partial_paid';
            if (paymentAmount >= remainingAmount) {
                newStatus = 'paid';
            }
            
            // Preparar dados de atualização
            updateData = {
                status: newStatus,
                updated_at: new Date().toISOString()
            };
            
            // NOVA LÓGICA: Se o empréstimo estava vencido (overdue) e recebeu um pagamento,
            // atualizar status para 'active' e estender data de vencimento para 30 dias
            const currentLoanStatus = getLoanStatus(loan.due_date, loan.status);
            if (currentLoanStatus === 'overdue') {
                // Calcular valor restante considerando o pagamento que acabou de ser feito
                const remainingAmountAfterPayment = await calculateLoanRemainingAmount(loanId);
                
                if (remainingAmountAfterPayment <= 0) {
                    // Empréstimo quitado completamente
                    updateData.status = 'paid';
                } else {
                    // Empréstimo parcialmente pago - reativar SEM alterar data de vencimento original
                    updateData.status = 'active';
                    
                    // Alterar data de vencimento APENAS se o usuário solicitou explicitamente
                    if (changeDueDate && newDueDate) {
                        // Usuário escolheu alterar a data manualmente - usar a data fornecida
                        updateData.due_date = newDueDate;
                        
                        // Registrar nota sobre a reativação do empréstimo com nova data
                        const reactivationNote = `EMPRÉSTIMO REATIVADO: Status alterado de 'vencido' para 'ativo'. Nova data de vencimento: ${updateData.due_date} (definida manualmente pelo usuário). Valor restante: R$ ${remainingAmountAfterPayment.toFixed(2)}`;
                        
                        const { error: reactivationNoteError } = await supabase
                            .from('payments')
                            .insert([{
                                loan_id: loanId,
                                amount: 0,
                                payment_date: paymentDate,
                                payment_type: 'loan_reactivation',
                                notes: reactivationNote,
                                created_by: currentUser.id,
                                created_at: new Date().toISOString()
                            }]);
                        
                        if (reactivationNoteError) console.warn('Erro ao registrar nota de reativação:', reactivationNoteError);
                    }
                    // NÃO alterar automaticamente a data de vencimento - manter a data original
                }
            } else {
                // Se o empréstimo NÃO está vencido, alterar data de vencimento APENAS se o usuário solicitou
                if (changeDueDate && newDueDate) {
                    // Usuário escolheu alterar a data manualmente - usar a data fornecida
                    updateData.due_date = newDueDate;
                }
                // NÃO alterar automaticamente a data de vencimento em pagamentos normais
            }
            
            const { error: loanError } = await supabase
                .from('loans')
                .update(updateData)
                .eq('id', loanId);
            
            if (loanError) throw loanError;
        }
        
        // Fechar o modal imediatamente
        hideModal(paymentModal);
        paymentForm.reset();
        
        // Limpar dataset do formulário
        delete paymentForm.dataset.paymentId;
        
        // Invalidar cache e recarregar dados APÓS fechar o modal
        invalidateLoanRemainingAmountsCache();
        await loadLoans();
        await updateDashboard();
        
        // Se o modal de histórico estiver aberto, recarregar os dados
        if (!paymentHistoryModal.classList.contains('hidden')) {
            await loadPaymentHistory(loanId);
        }
        
        // Mostrar mensagem de sucesso com informações sobre a operação
        let successMessage = paymentId 
            ? `Pagamento de R$ ${paymentAmount.toFixed(2)} editado com sucesso!`
            : `Pagamento de R$ ${paymentAmount.toFixed(2)} registrado com sucesso!`;
        
        // Adicionar informação sobre alteração de data de vencimento (APENAS se o usuário alterou manualmente)
        if (changeDueDate && newDueDate) {
            successMessage += `\n\n📅 DATA DE VENCIMENTO ALTERADA!\n• Nova data: ${formatDate(newDueDate)}`;
        }
        
        if (recalcInfo.shouldRecalculate) {
            if (recalcInfo.isInterestOnlyRenewal) {
                successMessage += `\n\n🔄 RENOVAÇÃO POR PAGAMENTO DE JUROS!\n` +
                                `• Capital mantido: R$ ${recalcInfo.newAmount.toFixed(2)}\n` +
                                `• Próximos juros: R$ ${recalcInfo.newInterestAmount.toFixed(2)}\n` +
                                `• Próximo total: R$ ${recalcInfo.newTotalAmount.toFixed(2)}\n` +
                                `• Nova data de vencimento: ${formatDate(recalcInfo.newDueDate)}`;
            } else if (recalcInfo.isEarlyPaymentPartialInterest) {
                successMessage += `\n\n⚡ PAGAMENTO ANTECIPADO PARCIAL DE JUROS!\n` +
                                `• Capital mantido: R$ ${recalcInfo.newAmount.toFixed(2)}\n` +
                                `• Juros pagos: R$ ${recalcInfo.paidInterest.toFixed(2)}\n` +
                                `• Juros acumulados: R$ ${recalcInfo.newInterestAmount.toFixed(2)}\n` +
                                `• Próximo total: R$ ${recalcInfo.newTotalAmount.toFixed(2)}`;
            } else if (recalcInfo.isEarlyPaymentInterestRenewal) {
                successMessage += `\n\n⚡ PAGAMENTO ANTECIPADO - RENOVAÇÃO!\n` +
                                `• Capital mantido: R$ ${recalcInfo.newAmount.toFixed(2)}\n` +
                                `• Juros pagos: R$ ${recalcInfo.paidInterest.toFixed(2)}\n` +
                                `• Próximos juros: R$ ${recalcInfo.newInterestAmount.toFixed(2)}\n` +
                                `• Próximo total: R$ ${recalcInfo.newTotalAmount.toFixed(2)}`;
            } else if (recalcInfo.isEarlyPaymentCapitalReduction) {
                successMessage += `\n\n⚡ PAGAMENTO ANTECIPADO COM REDUÇÃO DE CAPITAL!\n` +
                                `• Capital anterior: R$ ${recalcInfo.originalAmount.toFixed(2)}\n` +
                                `• Juros pagos: R$ ${recalcInfo.paidInterest.toFixed(2)}\n` +
                                `• Capital pago: R$ ${recalcInfo.paidCapital.toFixed(2)}\n` +
                                `• Novo capital: R$ ${recalcInfo.newAmount.toFixed(2)}\n` +
                                `• Novos juros: R$ ${recalcInfo.newInterestAmount.toFixed(2)}\n` +
                                `• Próximo total: R$ ${recalcInfo.newTotalAmount.toFixed(2)}`;
            } else if (recalcInfo.isCapitalReduction) {
                successMessage += `\n\n💰 PAGAMENTO DE CAPITAL APLICADO!\n` +
                                `• Capital pago: R$ ${recalcInfo.paidCapital.toFixed(2)}\n` +
                                `• Juros pagos: R$ ${recalcInfo.paidInterest.toFixed(2)}\n` +
                                `• Novo capital: R$ ${recalcInfo.newAmount.toFixed(2)}\n` +
                                `• Próximos juros: R$ ${recalcInfo.newInterestAmount.toFixed(2)}`;
            } else if (recalcInfo.isPartialInterestPayment) {
                successMessage += `\n\n⚠️ PAGAMENTO PARCIAL DE JUROS!\n` +
                                `• Capital mantido: R$ ${recalcInfo.newAmount.toFixed(2)}\n` +
                                `• Juros acumulados: R$ ${recalcInfo.newInterestAmount.toFixed(2)}\n` +
                                `• Próximo total: R$ ${recalcInfo.newTotalAmount.toFixed(2)}`;
            } else if (recalcInfo.isFullyPaid) {
                successMessage += `\n\n✅ EMPRÉSTIMO QUITADO COMPLETAMENTE!`;
            }
        }
        
        // Preparar informações do pagamento para o modal de mensagens
        const paymentInfo = {
            amount: paymentAmount,
            type: paymentType,
            date: paymentDate,
            newDueDate: newDueDate,
            isFullyPaid: recalcInfo.isFullyPaid,
            isRenewal: recalcInfo.isInterestOnlyRenewal || recalcInfo.isEarlyPaymentInterestRenewal,
            recalcInfo: recalcInfo
        };

        // Mostrar modal de mensagens em vez da notificação simples
        await showPaymentMessageModal(loanId, paymentInfo);
        
    } catch (error) {
        alert('Erro ao registrar pagamento: ' + error.message);
    }
}
*/

async function handleEditClient(e) {
    e.preventDefault();
    
    const clientId = document.getElementById('editClientId').value;
    
    const formData = {
        name: document.getElementById('editClientName').value,
        cpf: document.getElementById('editClientCPF').value,
        email: document.getElementById('editClientEmail').value,
        phone: document.getElementById('editClientPhone').value,
        address: document.getElementById('editClientAddress').value,
        rg: document.getElementById('editClientRG').value || null,
        birth_date: document.getElementById('editClientBirthDate').value || null,
        updated_at: new Date().toISOString()
    };
    
    try {
        console.log('Updating client data:', formData); // Debug log
        const { data, error } = await supabase
            .from('clients')
            .update(formData)
            .eq('id', clientId)
            .select();
        
        if (error) {
            console.error('Database update error:', error);
            throw error;
        }
        
        console.log('Client updated successfully:', data); // Debug log
        
        hideModal(editClientModal);
        
        // Recarregar dados
        await loadClients(true); // Forçar reload para invalidar cache
        await updateDashboard();
        
        // Mostrar mensagem de sucesso
        showSuccessMessage(`Cliente "${formData.name}" atualizado com sucesso!`);
        
    } catch (error) {
        alert('Erro ao atualizar cliente: ' + error.message);
    }
}

async function handleEditLoan(e) {
    e.preventDefault();
    
    const loanId = document.getElementById('editLoanId').value;
    const formData = {
        client_id: document.getElementById('editLoanClient').value,
        amount: parseFloat(document.getElementById('editLoanAmount').value),
        interest_rate: parseFloat(document.getElementById('editLoanInterest').value),
        loan_date: document.getElementById('editLoanDate').value,
        due_date: document.getElementById('editLoanDueDate').value,
        status: document.getElementById('editLoanStatus').value,
        updated_at: new Date().toISOString()
    };
    
    try {
        const { data, error } = await supabase
            .from('loans')
            .update(formData)
            .eq('id', loanId)
            .select();
        
        if (error) throw error;
        
        hideModal(editLoanModal);
        
        // Recarregar dados
        invalidateLoanRemainingAmountsCache();
        await loadLoans();
        await updateDashboard();
        
        // Mostrar mensagem de sucesso
        const client = clients.find(c => c.id === formData.client_id);
        const clientName = client ? client.name : 'Cliente não encontrado';
        const total = formData.amount + (formData.amount * formData.interest_rate / 100);
        
        showSuccessMessage(`Empréstimo de "${clientName}" atualizado com sucesso! Valor: R$ ${formData.amount.toFixed(2)}, Total: R$ ${total.toFixed(2)}`);
        
    } catch (error) {
        alert('Erro ao atualizar empréstimo: ' + error.message);
    }
}

// Funções auxiliares
function showModal(modal) {
    modal.classList.remove('hidden');
    modal.classList.add('fade-in');
    
    // Preencher dados se necessário
    if (modal === newLoanModal) {
        populateClientSelect();
        setDefaultDates();
        // Configurar busca de clientes
        setupClientSearch(
            'loanClientSearch',
            'loanClient', 
            'loanClientResultsList', 
            'loanClientResults'
        );
    }
    
    // Configurar busca para modal de parcelamentos
    if (modal === newInstallmentModal) {
        setupClientSearch(
            'installmentClientSearch',
            'installmentClientId',
            'installmentClientResultsList',
            'installmentClientResults'
        );
    }
}

function hideModal(modal) {
    modal.classList.add('hidden');
    modal.classList.remove('fade-in');
    
    // Limpar formulários específicos
    if (modal === editClientModal) {
        document.getElementById('editClientForm').reset();
        // Limpar preview das fotos de edição (commented out - elements don't exist in modal)
        // document.getElementById('editPhotosUploadPreview').classList.add('hidden');
        // document.getElementById('editClientPhotos').value = '';
        // document.getElementById('editPhotosPreviewGrid').innerHTML = '';
        // // Limpar widget do Uploadcare
        // if (window.uploadcare) {
        //     const editWidget = uploadcare.Widget('#editClientPhotosUploader');
        //     editWidget.value(null);
        // }
    } else if (modal === editLoanModal) {
        document.getElementById('editLoanForm').reset();
    } else if (modal === newClientModal) {
        document.getElementById('newClientForm').reset();
        // Resetar seção de avalista
        document.getElementById('includeGuarantor').checked = false;
        document.getElementById('guarantorSection').classList.add('hidden');
        clearNewClientGuarantorForm();
        // Resetar seção de contato de emergência
        document.getElementById('includeEmergencyContact').checked = false;
        document.getElementById('emergencyContactSection').classList.add('hidden');
        clearNewClientEmergencyContactForm();
    } else if (modal === newLoanModal) {
        document.getElementById('newLoanForm').reset();
    } else if (modal === paymentModal) {
        document.getElementById('paymentForm').reset();
        document.getElementById('paymentDate').value = formatDateForInput(new Date());
        document.getElementById('paymentType').value = 'dinheiro';
    } else if (modal === paymentHistoryModal) {
        // Limpar dados do histórico
        document.getElementById('paymentHistoryTableBody').innerHTML = '';
        document.getElementById('paymentHistoryTotalPaid').textContent = 'R$ 0,00';
        document.getElementById('paymentHistoryRemainingAmount').textContent = 'R$ 0,00';
        document.getElementById('paymentHistoryTotalWithInterest').textContent = 'R$ 0,00';
        
        // Restaurar título padrão
        const titleElement = document.querySelector('#paymentHistoryModal h3');
        if (titleElement) {
            titleElement.textContent = 'Histórico de Pagamentos';
        }
    } else if (modal === paidLoanDetailsModal) {
        // Limpar dados do empréstimo quitado
        document.getElementById('paidLoanClientName').textContent = '-';
        document.getElementById('paidLoanClientCpf').textContent = '-';
        document.getElementById('paidLoanClientEmail').textContent = '-';
        document.getElementById('paidLoanClientPhone').textContent = '-';
        document.getElementById('paidLoanOriginalAmount').textContent = 'R$ 0,00';
        document.getElementById('paidLoanInterestRate').textContent = '0%';
        document.getElementById('paidLoanTotalWithInterest').textContent = 'R$ 0,00';
        document.getElementById('paidLoanDate').textContent = '-';
        document.getElementById('paidLoanDueDate').textContent = '-';
        document.getElementById('paidLoanPaidDate').textContent = '-';
        document.getElementById('paidLoanTotalPaid').textContent = 'R$ 0,00';
        document.getElementById('paidLoanPaymentMethod').textContent = '-';
        document.getElementById('paidLoanNotes').textContent = '-';
    }
}

function showLogin() {
    loginPage.classList.remove('hidden');
    dashboard.classList.add('hidden');
    
    // Limpar timeout do usuário e remover listeners
    clearUserTimeout();
    removeActivityListeners();
}

function showDashboard() {
    loginPage.classList.add('hidden');
    dashboard.classList.remove('hidden');
    
    // Atualizar indicador da empresa
    const companyIndicator = document.getElementById('companyIndicator');
    if (companyIndicator && currentCompany) {
        const config = getCurrentCompanyConfig();
        companyIndicator.textContent = config ? config.name : 'Empresa não identificada';
    }
    
    // Configurar timeout para usuário logado
    setupActivityListeners();
}

function populateClientSelect() {
    const select = document.getElementById('loanClient');
    select.innerHTML = '<option value="">Ou selecione da lista completa</option>';
    
    clients.forEach(client => {
        const option = document.createElement('option');
        option.value = client.id;
        option.textContent = `${client.name} - ${client.cpf}`;
        select.appendChild(option);
    });
}

function setDefaultDates() {
    const today = new Date();
    const nextMonth = new Date(today.getFullYear(), today.getMonth() + 1, today.getDate());
    
    // Usar a função auxiliar para formatar datas
    
    document.getElementById('loanDate').value = formatDateForInput(today);
    document.getElementById('loanDueDate').value = formatDateForInput(nextMonth);
}

function updateLoanSummary() {
    const amount = parseFloat(document.getElementById('loanAmount').value) || 0;
    const interestRate = parseFloat(document.getElementById('loanInterest').value) || 0;
    
    const interestAmount = amount * (interestRate / 100);
    const total = amount + interestAmount;
    
    document.getElementById('summaryPrincipal').textContent = `R$ ${amount.toFixed(2)}`;
    document.getElementById('summaryInterest').textContent = `R$ ${interestAmount.toFixed(2)}`;
    document.getElementById('summaryTotal').textContent = `R$ ${total.toFixed(2)}`;
}

// FUNÇÃO REMOVIDA: Agora usa apenas RENOVAR 30+
// Esta função foi substituída pela nova lógica de renovação com opções
/*
function validatePaymentAmount() {
    const paymentAmount = parseFloat(document.getElementById('paymentAmount').value);
    const feedbackDiv = document.getElementById('paymentValidationFeedback');
    
    if (isNaN(paymentAmount) || paymentAmount <= 0) {
        feedbackDiv.className = 'mt-2 text-sm hidden';
        return;
    }
    
    // Obter valores do modal
    const capitalText = document.getElementById('paymentCapitalAmount').textContent;
    const interestText = document.getElementById('paymentInterestAmount').textContent;
    const remainingText = document.getElementById('paymentRemainingAmount').textContent;
    const minimumText = document.getElementById('paymentMinimumAmount').textContent;
    
    // Verificar se é pagamento antecipado
    const loanId = document.getElementById('paymentForm').dataset.loanId;
    const loan = loans.find(l => l.id === loanId);
    let isEarlyPayment = false;
    
    if (loan) {
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const dueDate = new Date(loan.due_date);
        dueDate.setHours(0, 0, 0, 0);
        isEarlyPayment = today < dueDate;
    }
    
    if (!remainingText || !minimumText) {
        feedbackDiv.className = 'mt-2 text-sm hidden';
        return;
    }
    
    const currentCapital = parseMonetaryValue(capitalText);
    const currentInterestAmount = parseMonetaryValue(interestText);
    const remainingAmount = parseMonetaryValue(remainingText);
    const minimumAmount = parseMonetaryValue(minimumText);
    
    // Simular o que acontecerá após este pagamento
    let newRemainingAmount = remainingAmount;
    let feedbackText = '';
    let feedbackColor = '';
    
    feedbackDiv.classList.remove('hidden');
    
    if (paymentAmount < minimumAmount) {
        feedbackText = `⚠️ Valor abaixo do mínimo (R$ ${minimumAmount.toFixed(2)}). Pagamento não permitido.`;
        feedbackColor = 'text-red-400';
        document.getElementById('paymentAmount').classList.add('border-red-500');
    } else if (Math.abs(paymentAmount - minimumAmount) <= (minimumAmount * 0.01)) {
        // Pagamento apenas de juros - valor restante permanece igual
        newRemainingAmount = currentCapital + currentInterestAmount;
        feedbackText = `🔄 PAGAMENTO DE JUROS: Capital permanece R$ ${currentCapital.toFixed(2)}, próximo valor total: R$ ${newRemainingAmount.toFixed(2)}`;
        feedbackColor = 'text-yellow-400';
        document.getElementById('paymentAmount').classList.remove('border-red-500');
        document.getElementById('paymentAmount').classList.add('border-yellow-500');
    } else if (paymentAmount < remainingAmount) {
        if (isEarlyPayment) {
            // PAGAMENTO ANTECIPADO: Verificar se valor é maior que juros
            if (paymentAmount <= currentInterestAmount) {
                // Paga apenas juros (parcial ou total)
                const remainingInterest = Math.max(0, currentInterestAmount - paymentAmount);
                const interestRate = currentInterestAmount / currentCapital;
                
                if (remainingInterest > 0) {
                    // Pagamento parcial de juros
                    const newInterest = remainingInterest + (currentCapital * interestRate);
                    newRemainingAmount = currentCapital + newInterest;
                    feedbackText = `⚡ PAGAMENTO ANTECIPADO PARCIAL DE JUROS: Capital mantido R$ ${currentCapital.toFixed(2)}, juros acumulados R$ ${newInterest.toFixed(2)}, próximo total: R$ ${newRemainingAmount.toFixed(2)}`;
                } else {
                    // Pagamento exato dos juros (renovação antecipada)
                    const newInterest = currentCapital * interestRate;
                    newRemainingAmount = currentCapital + newInterest;
                    feedbackText = `⚡ PAGAMENTO ANTECIPADO - RENOVAÇÃO: Capital mantido R$ ${currentCapital.toFixed(2)}, próximos juros R$ ${newInterest.toFixed(2)}, próximo total: R$ ${newRemainingAmount.toFixed(2)}`;
                }
                feedbackColor = 'text-purple-400';
            } else {
                // Paga juros + parte do capital
                const paidCapital = paymentAmount - currentInterestAmount;
                const newCapital = Math.max(0, currentCapital - paidCapital);
                const interestRate = currentInterestAmount / currentCapital;
                const newInterest = newCapital * interestRate;
                newRemainingAmount = newCapital + newInterest;
                
                feedbackText = `⚡ PAGAMENTO ANTECIPADO COM REDUÇÃO DE CAPITAL: Novo capital R$ ${newCapital.toFixed(2)}, novos juros R$ ${newInterest.toFixed(2)}, próximo total: R$ ${newRemainingAmount.toFixed(2)}`;
                feedbackColor = 'text-purple-400';
            }
        } else if (paymentAmount > currentInterestAmount) {
            // Pagamento de capital + juros (pagamento normal após vencimento)
            const paidCapital = paymentAmount - currentInterestAmount;
            const newCapital = Math.max(0, currentCapital - paidCapital);
            const interestRate = currentInterestAmount / currentCapital;
            const newInterest = newCapital * interestRate;
            newRemainingAmount = newCapital + newInterest;
            
            feedbackText = `💰 PAGAMENTO DE CAPITAL: Novo capital R$ ${newCapital.toFixed(2)}, próximo valor total: R$ ${newRemainingAmount.toFixed(2)}`;
            feedbackColor = 'text-blue-400';
        } else {
            // Pagamento parcial de juros
            const unpaidInterest = currentInterestAmount - paymentAmount;
            const interestRate = currentInterestAmount / currentCapital;
            const newInterest = currentCapital * interestRate;
            newRemainingAmount = currentCapital + unpaidInterest + newInterest;
            
            feedbackText = `⚠️ PAGAMENTO PARCIAL DE JUROS: Juros pendentes R$ ${unpaidInterest.toFixed(2)}, próximo valor total: R$ ${newRemainingAmount.toFixed(2)}`;
            feedbackColor = 'text-orange-400';
        }
        document.getElementById('paymentAmount').classList.remove('border-red-500', 'border-yellow-500');
        document.getElementById('paymentAmount').classList.add(isEarlyPayment ? 'border-purple-500' : 'border-blue-500');
    } else if (paymentAmount >= remainingAmount) {
        newRemainingAmount = 0;
        feedbackText = `✅ Pagamento quitará o empréstimo completamente. Valor restante: R$ 0,00`;
        feedbackColor = 'text-green-400';
        document.getElementById('paymentAmount').classList.remove('border-red-500', 'border-yellow-500', 'border-blue-500', 'border-purple-500');
        document.getElementById('paymentAmount').classList.add('border-green-500');
    } else {
        feedbackDiv.className = 'mt-2 text-sm hidden';
        document.getElementById('paymentAmount').classList.remove('border-red-500', 'border-yellow-500', 'border-blue-500', 'border-green-500', 'border-purple-500');
        return;
    }
    
    feedbackDiv.textContent = feedbackText;
    feedbackDiv.className = `mt-2 text-sm ${feedbackColor}`;
}
*/

async function showPaymentModal(loanId) {
    const loan = loans.find(l => l.id === loanId);
    if (!loan) return;
    
    // Preencher dados do empréstimo
    document.getElementById('paymentClientName').textContent = loan.clients?.name || 'Cliente não encontrado';
    
    // Calcular valor restante considerando pagamentos já feitos (AGUARDAR o cálculo)
    await calculateAndShowRemainingAmount(loanId);
    
    // Definir data padrão como hoje
    document.getElementById('paymentDate').value = formatDateForInput(new Date());
    
    // Limpar outros campos
    document.getElementById('paymentAmount').value = '';
    document.getElementById('paymentType').value = 'dinheiro';
    document.getElementById('paymentNotes').value = '';
    
    // Resetar campos de alteração de data de vencimento
    document.getElementById('changeDueDateCheckbox').checked = false;
    document.getElementById('dueDateContainer').classList.add('hidden');
    document.getElementById('newDueDate').value = '';
    
    // Limpar validação anterior
    const feedbackDiv = document.getElementById('paymentValidationFeedback');
    feedbackDiv.className = 'mt-2 text-sm hidden';
    document.getElementById('paymentAmount').classList.remove('border-red-500', 'border-yellow-500', 'border-blue-500', 'border-green-500', 'border-purple-500');
    
    // Armazenar ID do empréstimo
    document.getElementById('paymentForm').dataset.loanId = loanId;
    
    showModal(paymentModal);
}

async function calculateAndShowRemainingAmount(loanId) {
    try {
        // Buscar loan diretamente do banco para garantir dados atualizados
        const { data: loanData, error: loanError } = await supabase
            .from('loans')
            .select('*')
            .eq('id', loanId)
            .single();
        
        let loan;
        if (loanError || !loanData) {
            console.error('Erro ao buscar loan:', loanError);
            // Fallback: tentar usar loan da variável global
            loan = loans.find(l => l.id === loanId);
            if (!loan) return;
        } else {
            loan = loanData;
        }
        
        if (!loan) return;
        
        // SEMPRE usar o valor original do empréstimo (nunca o valor alterado)
        const originalCapital = parseFloat(loan.original_amount || loan.amount);
        const interestRate = parseFloat(loan.interest_rate);
        
        // Validação: se a taxa for muito alta, pode estar em formato incorreto
        let finalInterestRate = interestRate;
        if (interestRate > 100) {
            finalInterestRate = interestRate / 100;
        }
        
        const originalInterestAmount = originalCapital * (finalInterestRate / 100);
        const originalTotal = originalCapital + originalInterestAmount;
        
        // Buscar pagamentos já feitos
        const { data: payments, error } = await supabase
            .from('payments')
            .select('amount, payment_type, created_at, fine_amount')
            .eq('loan_id', loanId)
            .order('created_at', { ascending: true });
        
        if (error) throw error;
        
        // Separar pagamentos reais de ajustes/notificações
        const realPayments = payments.filter(p => parseFloat(p.amount) > 0);
        
        // Calcular total pago até agora (todos os pagamentos reais + multas)
        const totalPaid = realPayments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        const totalFinesPaid = realPayments.reduce((sum, payment) => sum + (parseFloat(payment.fine_amount) || 0), 0);
        
        // CORREÇÃO: Calcular quanto foi pago de capital e juros baseado no payment_type
        // Tipos de pagamento que NÃO reduzem o capital (apenas juros)
        const interestOnlyTypes = ['renewal', 'interest_renewal', 'early_payment_partial_interest', 
                                  'early_payment_interest_renewal', 'partial_interest'];
        
        let capitalPaid = 0;
        let interestPaid = 0;
        let currentCapital = originalCapital;
        
        // Processar cada pagamento em ordem para calcular corretamente
        for (const payment of realPayments) {
            const paymentAmount = parseFloat(payment.amount);
            const paymentType = payment.payment_type;
            
            // Se for pagamento apenas de juros (renovação), não reduz capital
            if (interestOnlyTypes.includes(paymentType)) {
                interestPaid += paymentAmount;
                // Capital permanece o mesmo
            } else {
                // Para outros tipos, calcular quanto foi de capital
                const currentInterest = currentCapital * (finalInterestRate / 100);
                
                if (paymentAmount > currentInterest) {
                    // Pagou mais que os juros, a diferença reduziu o capital
                    interestPaid += currentInterest;
                    const capitalReduction = paymentAmount - currentInterest;
                    capitalPaid += capitalReduction;
                    currentCapital = Math.max(0, currentCapital - capitalReduction);
                } else {
                    // Pagou menos ou igual aos juros
                    interestPaid += paymentAmount;
                }
            }
        }
        
        // Calcular capital restante
        const remainingCapital = Math.max(0, originalCapital - capitalPaid);
        
        // Calcular juros restantes baseado no capital restante
        const remainingInterest = remainingCapital * (finalInterestRate / 100);
        
        // Valor total restante
        const remainingAmount = remainingCapital + remainingInterest;
        
        // O pagamento mínimo é sempre o valor dos juros do capital restante
        const minimumPayment = remainingInterest;
        
        console.log('=== CÁLCULO CORRETO DE VALOR RESTANTE ===');
        console.log('Valores originais:', {
            originalCapital,
            originalInterestAmount,
            originalTotal,
            interestRate: finalInterestRate * 100 + '%'
        });
        console.log('Pagamentos analisados:', {
            totalPaid,
            capitalPaid,
            interestPaid
        });
        console.log('Valores restantes:', {
            remainingCapital,
            remainingInterest,
            remainingAmount,
            minimumPayment
        });
        console.log('=== ATUALIZAÇÃO DOS VALORES NO MODAL ===');
        console.log('✅ JUROS: R$', originalInterestAmount.toFixed(2), '→ R$', remainingInterest.toFixed(2));
        console.log('✅ CAPITAL: R$', originalCapital.toFixed(2), '→ R$', remainingCapital.toFixed(2));
        console.log('✅ PAGAMENTO MÍNIMO: R$', remainingInterest.toFixed(2));
        console.log('✅ VALOR RESTANTE TOTAL: R$', remainingAmount.toFixed(2));
        
        // Mostrar informações detalhadas
        document.getElementById('paymentCapitalAmount').textContent = `R$ ${remainingCapital.toFixed(2)}`;
        document.getElementById('paymentInterestRate').textContent = `${finalInterestRate.toFixed(2)}%`;
        document.getElementById('paymentInterestAmount').textContent = `R$ ${remainingInterest.toFixed(2)}`;
        // Total com Juros = Capital Restante + Juros Restantes (não usar originalTotal)
        document.getElementById('paymentTotalAmount').textContent = `R$ ${remainingAmount.toFixed(2)}`;
        document.getElementById('paymentRemainingAmount').textContent = `R$ ${Math.max(0, remainingAmount).toFixed(2)}`;
        document.getElementById('paymentMinimumAmount').textContent = `R$ ${minimumPayment.toFixed(2)}`;
        
        console.log('=== VALORES ATUALIZADOS NO HTML ===');
        console.log('Element paymentCapitalAmount:', document.getElementById('paymentCapitalAmount').textContent);
        console.log('Element paymentInterestAmount:', document.getElementById('paymentInterestAmount').textContent);
        console.log('Element paymentMinimumAmount:', document.getElementById('paymentMinimumAmount').textContent);
        console.log('=========================================');
        
        // Mostrar separação de pagamentos já realizados
        document.getElementById('paymentCapitalPaid').textContent = `R$ ${capitalPaid.toFixed(2)}`;
        document.getElementById('paymentInterestPaid').textContent = `R$ ${interestPaid.toFixed(2)}`;
        document.getElementById('paymentFinesPaid').textContent = `R$ ${totalFinesPaid.toFixed(2)}`;
        document.getElementById('paymentTotalPaid').textContent = `R$ ${(totalPaid + totalFinesPaid).toFixed(2)}`;
        
    } catch (error) {
        console.error('Erro ao calcular valor restante:', error);
        // Em caso de erro, mostrar valores básicos (sempre usar valor original)
        const loan = loans.find(l => l.id === loanId);
        if (loan) {
            const capitalAmount = parseFloat(loan.original_amount || loan.amount);
            let interestRate = parseFloat(loan.interest_rate);
            
            if (interestRate > 100) {
                interestRate = interestRate / 100;
            }
            
            const interestAmount = capitalAmount * (interestRate / 100);
            const totalWithInterest = capitalAmount + interestAmount;
            
            // Fallback: usar valores originais se houver erro
            document.getElementById('paymentCapitalAmount').textContent = `R$ ${capitalAmount.toFixed(2)}`;
            document.getElementById('paymentInterestRate').textContent = `${interestRate.toFixed(2)}%`;
            document.getElementById('paymentInterestAmount').textContent = `R$ ${interestAmount.toFixed(2)}`;
            document.getElementById('paymentTotalAmount').textContent = `R$ ${totalWithInterest.toFixed(2)}`;
            document.getElementById('paymentRemainingAmount').textContent = `R$ ${totalWithInterest.toFixed(2)}`;
            document.getElementById('paymentMinimumAmount').textContent = `R$ ${interestAmount.toFixed(2)}`;
            
            // Limpar informações de pagamentos (fallback)
            document.getElementById('paymentCapitalPaid').textContent = `R$ 0,00`;
            document.getElementById('paymentInterestPaid').textContent = `R$ 0,00`;
            document.getElementById('paymentFinesPaid').textContent = `R$ 0,00`;
            document.getElementById('paymentTotalPaid').textContent = `R$ 0,00`;
        }
    }
}

// Função para calcular o pagamento mínimo baseado no valor restante
function calculateMinimumPayment(capitalAmount, interestAmount, totalPaid, remainingAmount) {
    // O valor mínimo é sempre o valor dos juros do CAPITAL RESTANTE
    // Isso garante que pelo menos os juros atuais sejam pagos
    
    if (!interestAmount || interestAmount <= 0 || isNaN(interestAmount)) {
        return 0;
    }
    
    // Calcular quanto foi pago de capital
    const capitalPaid = Math.max(0, totalPaid - interestAmount);
    const remainingCapital = Math.max(0, capitalAmount - capitalPaid);
    
    // Calcular juros sobre o capital restante
    const interestRate = interestAmount / capitalAmount;
    const minimumPayment = remainingCapital * interestRate;
    
    return minimumPayment;
}

// Função para verificar se o pagamento requer recálculo e aplicar juros
async function checkAndRecalculateLoan(loanId, paymentAmount, paymentType) {
    try {
        const loan = loans.find(l => l.id === loanId);
        if (!loan) return { shouldRecalculate: false };
        
        const currentCapital = parseFloat(loan.amount);
        let interestRate = parseFloat(loan.interest_rate);
        
        // Ajustar taxa se necessário
        if (interestRate > 100) {
            interestRate = interestRate / 100;
        }
        
        const currentInterestAmount = currentCapital * (interestRate / 100);
        const currentTotal = currentCapital + currentInterestAmount;
        
        // Verificar se é pagamento antecipado (antes da data de vencimento)
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const dueDate = new Date(loan.due_date);
        dueDate.setHours(0, 0, 0, 0);
        const isEarlyPayment = today < dueDate;
        
        // Buscar pagamentos anteriores para entender o estado atual
        const { data: payments, error } = await supabase
            .from('payments')
            .select('amount, payment_type, notes, fine_amount')
            .eq('loan_id', loanId);
        
        if (error) throw error;
        
        // Separar pagamentos reais de ajustes
        const realPayments = payments.filter(p => parseFloat(p.amount) > 0);
        const totalPaidSoFar = realPayments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        
        // Calcular quanto foi pago de capital e quanto de juros até agora
        // Se já pagou mais que os juros atuais, a diferença foi do capital
        const capitalPaidSoFar = Math.max(0, totalPaidSoFar - currentInterestAmount);
        const remainingCapital = Math.max(0, currentCapital - capitalPaidSoFar);
        const pendingInterest = Math.max(0, currentInterestAmount - Math.min(totalPaidSoFar, currentInterestAmount));
        
        console.log('=== DEBUG RECÁLCULO DO PAGAMENTO ===');
        console.log('Estado antes do pagamento:', {
            currentCapital,
            currentInterestAmount,
            currentTotal,
            totalPaidSoFar,
            paymentAmount,
            paymentType
        });
        
        console.log('Análise do que será pago:', {
            isEarlyPayment,
            paidMoreThanInterest: paymentAmount > currentInterestAmount,
            paidLessThanInterest: paymentAmount < currentInterestAmount,
            tolerance: currentInterestAmount * 0.01,
            difference: Math.abs(paymentAmount - currentInterestAmount)
        });
        
        // LÓGICA PARA PAGAMENTO ANTECIPADO
        if (isEarlyPayment) {
            console.log('=== PROCESSANDO PAGAMENTO ANTECIPADO ===');
            console.log('Pagamento antes do vencimento detectado:', {
                paymentAmount,
                currentCapital,
                currentInterestAmount,
                interestRate: interestRate * 100 + '%'
            });
            
            // Para pagamento antecipado: verificar se valor é maior que os juros
            if (paymentAmount <= currentInterestAmount) {
                // PAGAMENTO ANTECIPADO APENAS DE JUROS (valor <= juros)
                // Capital permanece o mesmo, apenas paga parte ou todos os juros
                const paidInterest = paymentAmount;
                const remainingInterest = currentInterestAmount - paidInterest;
                
                if (remainingInterest > 0) {
                    // Pagamento parcial de juros - juros restantes + novos juros do próximo período
                    const newInterestAmount = remainingInterest + (currentCapital * (interestRate / 100));
                    const newTotal = currentCapital + newInterestAmount;
                    
                    console.log('Pagamento antecipado parcial de juros:', {
                        paidInterest,
                        remainingInterest,
                        newInterestAmount,
                        newTotal
                    });
                    
                    return {
                        shouldRecalculate: true,
                        isEarlyPaymentPartialInterest: true,
                        newAmount: currentCapital, // Capital permanece igual
                        newInterestAmount: newInterestAmount,
                        newTotalAmount: newTotal,
                        originalAmount: currentCapital,
                        paidAmount: paymentAmount,
                        paidInterest: paidInterest,
                        paidCapital: 0,
                        interestRate: interestRate
                    };
                } else {
                    // Pagamento exato dos juros - renovação antecipada
                    const newInterestAmount = currentCapital * (interestRate / 100);
                    const newTotal = currentCapital + newInterestAmount;
                    
                    console.log('Pagamento antecipado exato dos juros (renovação):', {
                        paidInterest,
                        newInterestAmount,
                        newTotal
                    });
                    
                    return {
                        shouldRecalculate: true,
                        isEarlyPaymentInterestRenewal: true,
                        newAmount: currentCapital, // Capital permanece igual
                        newInterestAmount: newInterestAmount,
                        newTotalAmount: newTotal,
                        originalAmount: currentCapital,
                        paidAmount: paymentAmount,
                        paidInterest: paidInterest,
                        paidCapital: 0,
                        interestRate: interestRate
                    };
                }
            } else {
                // PAGAMENTO ANTECIPADO COM REDUÇÃO DE CAPITAL (valor > juros)
                const paidInterest = currentInterestAmount;
                const paidCapital = paymentAmount - currentInterestAmount;
                const newCapital = Math.max(0, currentCapital - paidCapital);
                
                if (newCapital > 0) {
                    // Capital parcialmente pago
                    const newInterestAmount = newCapital * (interestRate / 100);
                    const newTotal = newCapital + newInterestAmount;
                    
                    console.log('Pagamento antecipado com redução de capital:', {
                        paidInterest,
                        paidCapital,
                        newCapital,
                        newInterestAmount,
                        newTotal
                    });
                    
                    return {
                        shouldRecalculate: true,
                        isEarlyPaymentCapitalReduction: true,
                        newAmount: newCapital,
                        newInterestAmount: newInterestAmount,
                        newTotalAmount: newTotal,
                        originalAmount: currentCapital,
                        paidAmount: paymentAmount,
                        paidInterest: paidInterest,
                        paidCapital: paidCapital,
                        interestRate: interestRate
                    };
                } else {
                    // Capital totalmente pago com pagamento antecipado
                    console.log('Capital totalmente quitado com pagamento antecipado!');
                    return { shouldRecalculate: false, isFullyPaid: true };
                }
            }
        }
        
        // Verificar se o pagamento é apenas os juros pendentes (renovação)
        const isInterestOnlyPayment = Math.abs(paymentAmount - currentInterestAmount) <= (currentInterestAmount * 0.01);
        
        if (isInterestOnlyPayment) {
            // PAGAMENTO APENAS DE JUROS: Capital permanece o mesmo
            // Próximo mês: mesmo capital + novos juros
            // Não há recálculo, apenas renovação da data
            const currentDueDate = parseLocalDate(loan.due_date);
            const newDueDate = new Date(currentDueDate.getFullYear(), currentDueDate.getMonth() + 1, currentDueDate.getDate());
            
            return {
                shouldRecalculate: true,
                isInterestOnlyRenewal: true,
                newAmount: currentCapital, // Capital permanece igual
                newInterestAmount: currentInterestAmount, // Juros recalculados iguais
                newTotalAmount: currentTotal, // Total permanece igual
                newDueDate: newDueDate.toISOString().split('T')[0],
                originalAmount: currentCapital,
                interestRate: interestRate,
                paidAmount: paymentAmount
            };
        }
        
        // Se pagou mais que apenas juros, parte foi do capital
        if (paymentAmount > currentInterestAmount) {
            // PAGAMENTO PARCIAL DE CAPITAL: Reduzir capital
            const paidInterest = currentInterestAmount;
            const paidCapital = paymentAmount - currentInterestAmount;
            const newCapital = Math.max(0, currentCapital - paidCapital);
            
            console.log('Processando pagamento de capital:', {
                paymentAmount,
                currentInterestAmount,
                paidInterest,
                paidCapital,
                currentCapital,
                newCapital,
                willBeFullyPaid: newCapital <= 0
            });
            
            if (newCapital > 0) {
                const newInterestAmount = newCapital * (interestRate / 100);
                const newTotal = newCapital + newInterestAmount;
                
                console.log('Resultado do recálculo:', {
                    newCapital,
                    newInterestAmount,
                    newTotal,
                    interestRate
                });
                
                return {
                    shouldRecalculate: true,
                    isCapitalReduction: true,
                    newAmount: newCapital,
                    newInterestAmount: newInterestAmount,
                    newTotalAmount: newTotal,
                    originalAmount: currentCapital,
                    paidCapital: paidCapital,
                    paidInterest: paidInterest,
                    interestRate: interestRate,
                    paidAmount: paymentAmount
                };
            } else {
                // Capital totalmente pago
                console.log('Capital totalmente quitado!');
                return { shouldRecalculate: false, isFullyPaid: true };
            }
        }
        
        // Se pagou menos que os juros, mas mais que zero
        if (paymentAmount < currentInterestAmount && paymentAmount > 0) {
            // PAGAMENTO PARCIAL DE JUROS: Juros pendentes continuam acumulando
            const remainingInterest = currentInterestAmount - paymentAmount;
            const newInterestAmount = remainingInterest + (currentCapital * (interestRate / 100));
            const newTotal = currentCapital + newInterestAmount;
            
            return {
                shouldRecalculate: true,
                isPartialInterestPayment: true,
                newAmount: currentCapital, // Capital igual
                newInterestAmount: newInterestAmount, // Juros antigos + novos
                newTotalAmount: newTotal,
                originalAmount: currentCapital,
                interestRate: interestRate,
                paidAmount: paymentAmount
            };
        }
        
        return { shouldRecalculate: false };
        
    } catch (error) {
        console.error('Erro ao verificar recálculo:', error);
        return { shouldRecalculate: false };
    }
}

function getLoanStatus(dueDate, dbStatus = null) {
    // Se o status no banco for 'paid', retornar 'paid' independente da data
    if (dbStatus === 'paid') return 'paid';
    
    const due = parseLocalDate(dueDate);
    const today = new Date();
    
    // Normalizar as datas para comparar apenas dia, mês e ano
    const dueNormalized = new Date(due.getFullYear(), due.getMonth(), due.getDate());
    const todayNormalized = new Date(today.getFullYear(), today.getMonth(), today.getDate());
    
    if (dueNormalized < todayNormalized) return 'overdue';
    if (dueNormalized.getTime() === todayNormalized.getTime()) return 'due_today';
    return 'active';
}

function getStatusClass(status) {
    switch (status) {
        case 'active': return 'status-active';
        case 'overdue': return 'status-overdue';
        case 'due_today': return 'status-pending';
        case 'paid': return 'status-paid';
        default: return 'status-active';
    }
}

function getStatusText(status) {
    switch (status) {
        case 'active': return 'Ativo';
        case 'overdue': return 'Vencido';
        case 'due_today': return 'Vence Hoje';
        case 'paid': return 'Quitado';
        default: return 'Ativo';
    }
}

// Função auxiliar para parsing seguro de datas (evita problemas de fuso horário)
function parseLocalDate(dateString) {
    if (!dateString) return null;
    
    // Se a string já contém horário, usar diretamente
    if (dateString.includes('T') || dateString.includes(' ')) {
        return new Date(dateString);
    }
    
    // Para datas no formato YYYY-MM-DD, criar data local sem conversão de fuso horário
    const [year, month, day] = dateString.split('-').map(num => parseInt(num, 10));
    return new Date(year, month - 1, day); // month é 0-indexado
}

// Função auxiliar para formatar data para campos de input (YYYY-MM-DD)
function formatDateForInput(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

function formatDate(dateString) {
    try {
        if (!dateString) return 'N/A';
        
        const date = parseLocalDate(dateString);
        if (!date || isNaN(date.getTime())) {
            return 'Data inválida';
        }
        
        return date.toLocaleDateString('pt-BR');
    } catch (error) {
        console.warn('Erro ao formatar data:', dateString, error);
        return 'Data inválida';
    }
}

// Atualizar dashboard
async function updateDashboard() {
    document.getElementById('totalClients').textContent = clients.length;
    
    const totalLoaned = loans.reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
    document.getElementById('totalLoaned').textContent = `R$ ${totalLoaned.toFixed(2)}`;
    
    const totalInterest = loans.reduce((sum, loan) => {
        return sum + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
    }, 0);
    document.getElementById('totalInterest').textContent = `R$ ${totalInterest.toFixed(2)}`;
    
    // Calcular valores restantes de todos os empréstimos em lote
    const loanIds = loans.map(loan => loan.id);
    const remainingAmounts = await calculateBatchLoanRemainingAmounts(loanIds);
    
    // Calcular total restante considerando pagamentos
    const totalRemaining = remainingAmounts.reduce((sum, amount) => sum + amount, 0);
    document.getElementById('totalRemaining').textContent = `R$ ${totalRemaining.toFixed(2)}`;
    
    const activeLoans = loans.filter(loan => loan.status !== 'paid').length;
    document.getElementById('activeLoans').textContent = activeLoans;
    
    // Contar empréstimos quitados da tabela paid_loans
    let paidLoansCount = 0;
    try {
        const { count, error } = await supabase
            .from('paid_loans')
            .select('*', { count: 'exact', head: true });
        
        if (!error) {
            paidLoansCount = count || 0;
        }
    } catch (error) {
        console.error('Erro ao contar empréstimos quitados:', error);
    }
    document.getElementById('paidLoans').textContent = paidLoansCount;
    
    // Calcular total em caixa
    const totalCash = cashSettings ? parseFloat(cashSettings.current_balance) : 0;
    document.getElementById('totalCash').textContent = `R$ ${totalCash.toFixed(2)}`;
    
    // Calcular total de empréstimos vencidos usando os valores já calculados
    const overdueLoans = loans.filter(loan => {
        const dueDate = new Date(loan.due_date);
        const today = new Date();
        return dueDate < today && loan.status !== 'paid';
    });
    
    let totalOverdue = 0;
    for (const loan of overdueLoans) {
        const loanIndex = loans.findIndex(l => l.id === loan.id);
        if (loanIndex !== -1) {
            totalOverdue += remainingAmounts[loanIndex];
        }
    }
    document.getElementById('overdueLoans').textContent = `R$ ${totalOverdue.toFixed(2)}`;

    
    // Atualizar informações do usuário no header
    updateUserInfo();
}

// Atualizar gráficos
async function updateCharts() {
    console.log('Atualizando gráficos...');
    
    // Verificar se os elementos existem antes de tentar criar os gráficos
    if (document.getElementById('clientsChart')) {
        updateClientsChart();
    }
    if (document.getElementById('loansChart')) {
        updateLoansChart();
    }
    if (document.getElementById('growthChart')) {
        updateGrowthChart();
    }
    if (document.getElementById('distributionChart')) {
        updateDistributionChart();
    }
    if (document.getElementById('loans7DaysChart')) {
        updateLoans7DaysChart();
    }
    if (document.getElementById('loansMonthlyChart')) {
        updateOverdueLoansChart();
    }
    
    updateFinancialSummary();
    
    console.log('Gráficos atualizados com sucesso');
}

function updateClientsChart() {
    const ctx = document.getElementById('clientsChart');
    if (!ctx) {
        console.log('Elemento clientsChart não encontrado');
        return;
    }
    
    console.log('Atualizando gráfico de clientes...');
    
    if (charts.clients) {
        charts.clients.destroy();
    }
    
    const last6Months = getLast6Months();
    const clientCounts = last6Months.map(month => {
        return clients.filter(client => {
            const clientDate = new Date(client.created_at);
            return clientDate.getMonth() === month.getMonth() && 
                   clientDate.getFullYear() === month.getFullYear();
        }).length;
    });
    
    // Verificar se há dados para mostrar
    if (clientCounts.every(count => count === 0)) {
        console.log('Sem dados de clientes para mostrar no gráfico');
        return;
    }
    
    charts.clients = new Chart(ctx, {
        type: 'line',
        data: {
            labels: last6Months.map(date => date.toLocaleDateString('pt-BR', { month: 'short', year: '2-digit' })),
            datasets: [{
                label: 'Novos Clientes',
                data: clientCounts,
                borderColor: '#3b82f6',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    labels: { color: '#ffffff' }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: { color: 'rgba(255, 255, 255, 0.1)' },
                    ticks: { color: '#ffffff' }
                },
                x: {
                    grid: { color: 'rgba(255, 255, 255, 0.1)' },
                    ticks: { color: '#ffffff' }
                }
            }
        }
    });
}

function updateLoansChart() {
    const ctx = document.getElementById('loansChart');
    if (!ctx) {
        console.log('Elemento loansChart não encontrado');
        return;
    }
    
    console.log('Atualizando gráfico de empréstimos...');
    
    if (charts.loans) {
        charts.loans.destroy();
    }
    
    const last6Months = getLast6Months();
    const loanAmounts = last6Months.map(month => {
        return loans.filter(loan => {
            const loanDate = new Date(loan.created_at);
            return loanDate.getMonth() === month.getMonth() && 
                   loanDate.getFullYear() === month.getFullYear();
        }).reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
    });
    
    // Verificar se há dados para mostrar
    if (loanAmounts.every(amount => amount === 0)) {
        console.log('Sem dados de empréstimos para mostrar no gráfico');
        return;
    }
    
    charts.loans = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: last6Months.map(date => date.toLocaleDateString('pt-BR', { month: 'short', year: '2-digit' })),
            datasets: [{
                label: 'Valor Emprestado',
                data: loanAmounts,
                backgroundColor: 'rgba(34, 197, 94, 0.8)',
                borderColor: '#22c55e',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    labels: { color: '#ffffff' }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: { color: 'rgba(255, 255, 255, 0.1)' },
                    ticks: { color: '#ffffff' }
                },
                x: {
                    grid: { color: 'rgba(255, 255, 255, 0.1)' },
                    ticks: { color: '#ffffff' }
                }
            }
        }
    });
}

function updateGrowthChart() {
    const ctx = document.getElementById('growthChart');
    if (!ctx) {
        console.log('Elemento growthChart não encontrado');
        return;
    }
    
    console.log('Atualizando gráfico de crescimento...');
    
    if (charts.growth) {
        charts.growth.destroy();
    }
    
    const last12Months = getLast12Months();
    const growthData = last12Months.map(month => {
        return clients.filter(client => {
            const clientDate = new Date(client.created_at);
            return clientDate.getMonth() === month.getMonth() && 
                   clientDate.getFullYear() === month.getFullYear();
        }).length;
    });
    
    charts.growth = new Chart(ctx, {
        type: 'line',
        data: {
            labels: last12Months.map(date => date.toLocaleDateString('pt-BR', { month: 'short', year: '2-digit' })),
            datasets: [{
                label: 'Crescimento',
                data: growthData,
                borderColor: '#8b5cf6',
                backgroundColor: 'rgba(139, 92, 246, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    labels: { color: '#ffffff' }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: { color: 'rgba(255, 255, 255, 0.1)' },
                    ticks: { color: '#ffffff' }
                },
                x: {
                    grid: { color: 'rgba(255, 255, 255, 0.1)' },
                    ticks: { color: '#ffffff' }
                }
            }
        }
    });
}

async function updateDistributionChart() {
    const ctx = document.getElementById('distributionChart');
    if (!ctx) {
        console.log('Elemento distributionChart não encontrado');
        return;
    }
    
    console.log('Atualizando gráfico de distribuição...');
    
    if (charts.distribution) {
        charts.distribution.destroy();
    }
    
    const statusCounts = {
        'Ativo': loans.filter(loan => getLoanStatus(loan.due_date, loan.status) === 'active').length,
        'Vencido': loans.filter(loan => getLoanStatus(loan.due_date, loan.status) === 'overdue').length,
        'Pago': 0 // Será atualizado dinamicamente da tabela paid_loans
    };
    
    // Buscar contagem de empréstimos quitados da tabela paid_loans
    try {
        const { count, error } = await supabase
            .from('paid_loans')
            .select('*', { count: 'exact', head: true });
        
        if (!error) {
            statusCounts['Pago'] = count || 0;
        }
    } catch (error) {
        console.error('Erro ao contar empréstimos quitados:', error);
    }
    
    charts.distribution = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: Object.keys(statusCounts),
            datasets: [{
                data: Object.values(statusCounts),
                backgroundColor: [
                    'rgba(34, 197, 94, 0.8)',
                    'rgba(239, 68, 68, 0.8)',
                    'rgba(59, 130, 246, 0.8)'
                ],
                borderColor: [
                    '#22c55e',
                    '#ef4444',
                    '#3b82f6'
                ],
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    labels: { color: '#ffffff' }
                }
            }
        }
    });
}

function updateLoans7DaysChart() {
    const ctx = document.getElementById('loans7DaysChart');
    if (!ctx) {
        console.log('Elemento loans7DaysChart não encontrado');
        return;
    }
    
    console.log('Atualizando gráfico de empréstimos dos últimos 7 dias...');
    
    if (charts.loans7Days) {
        charts.loans7Days.destroy();
    }
    
    const last7Days = getLast7Days();
    const loansData = last7Days.map(day => {
        const dayLoans = loans.filter(loan => {
            const loanDate = new Date(loan.created_at);
            return loanDate.toDateString() === day.toDateString();
        });
        return {
            date: day,
            count: dayLoans.length,
            total: dayLoans.reduce((sum, loan) => sum + parseFloat(loan.amount), 0)
        };
    });
    
    charts.loans7Days = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: last7Days.map(date => date.toLocaleDateString('pt-BR', { day: '2-digit', month: '2-digit' })),
            datasets: [{
                label: 'Quantidade',
                data: loansData.map(d => d.count),
                backgroundColor: 'rgba(59, 130, 246, 0.6)',
                borderColor: '#3b82f6',
                borderWidth: 2,
                yAxisID: 'y'
            }, {
                label: 'Valor Total (R$)',
                data: loansData.map(d => d.total),
                backgroundColor: 'rgba(34, 197, 94, 0.6)',
                borderColor: '#22c55e',
                borderWidth: 2,
                type: 'line',
                yAxisID: 'y1',
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    labels: { color: '#ffffff' }
                }
            },
            scales: {
                y: {
                    type: 'linear',
                    display: true,
                    position: 'left',
                    beginAtZero: true,
                    grid: { color: 'rgba(255, 255, 255, 0.1)' },
                    ticks: { color: '#ffffff' },
                    title: {
                        display: true,
                        text: 'Quantidade',
                        color: '#ffffff'
                    }
                },
                y1: {
                    type: 'linear',
                    display: true,
                    position: 'right',
                    beginAtZero: true,
                    grid: { drawOnChartArea: false },
                    ticks: { 
                        color: '#ffffff',
                        callback: function(value) {
                            return 'R$ ' + value.toLocaleString('pt-BR', { minimumFractionDigits: 2 });
                        }
                    },
                    title: {
                        display: true,
                        text: 'Valor (R$)',
                        color: '#ffffff'
                    }
                },
                x: {
                    grid: { color: 'rgba(255, 255, 255, 0.1)' },
                    ticks: { color: '#ffffff' }
                }
            }
        }
    });
}

function updateOverdueLoansChart() {
    const ctx = document.getElementById('loansMonthlyChart');
    if (!ctx) {
        console.log('Elemento loansMonthlyChart não encontrado');
        return;
    }
    
    console.log('Atualizando gráfico de empréstimos vencidos do último mês...');
    
    if (charts.loansMonthly) {
        charts.loansMonthly.destroy();
    }
    
    // Obter os últimos 30 dias
    const today = new Date();
    const thirtyDaysAgo = new Date(today.getTime() - (30 * 24 * 60 * 60 * 1000));
    
    // Gerar array com os últimos 30 dias
    const last30Days = [];
    for (let i = 29; i >= 0; i--) {
        const date = new Date(today.getTime() - (i * 24 * 60 * 60 * 1000));
        last30Days.push(date);
    }
    
    // Filtrar empréstimos vencidos no último mês
    const overdueLoansData = last30Days.map(day => {
        const dayStr = day.toISOString().split('T')[0];
        
        // Contar empréstimos que venceram neste dia
        const dayOverdueLoans = loans.filter(loan => {
            if (!loan.due_date) return false;
            const dueDate = new Date(loan.due_date);
            const dueDateStr = dueDate.toISOString().split('T')[0];
            return dueDateStr === dayStr && dueDate < today && (loan.status === 'active' || loan.status === 'overdue');
        });
        
        // Contar empréstimos que já estavam vencidos neste dia
        const alreadyOverdueLoans = loans.filter(loan => {
            if (!loan.due_date) return false;
            const dueDate = new Date(loan.due_date);
            return dueDate < day && (loan.status === 'active' || loan.status === 'overdue');
        });
        
        return {
            date: day,
            newOverdue: dayOverdueLoans.length,
            newOverdueValue: dayOverdueLoans.reduce((sum, loan) => sum + parseFloat(loan.total_amount || loan.amount), 0),
            totalOverdue: alreadyOverdueLoans.length,
            totalOverdueValue: alreadyOverdueLoans.reduce((sum, loan) => sum + parseFloat(loan.total_amount || loan.amount), 0)
        };
    });
    
    charts.loansMonthly = new Chart(ctx, {
        type: 'line',
        data: {
            labels: last30Days.map(date => date.toLocaleDateString('pt-BR', { day: '2-digit', month: '2-digit' })),
            datasets: [{
                label: 'Novos Vencimentos',
                data: overdueLoansData.map(d => d.newOverdue),
                borderColor: '#ef4444',
                backgroundColor: 'rgba(239, 68, 68, 0.1)',
                tension: 0.4,
                fill: false,
                yAxisID: 'y'
            }, {
                label: 'Valor Novos Vencimentos (R$)',
                data: overdueLoansData.map(d => d.newOverdueValue),
                borderColor: '#f59e0b',
                backgroundColor: 'rgba(245, 158, 11, 0.1)',
                tension: 0.4,
                fill: true,
                yAxisID: 'y1'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    labels: { color: '#ffffff' }
                }
            },
            scales: {
                y: {
                    type: 'linear',
                    display: true,
                    position: 'left',
                    beginAtZero: true,
                    grid: { color: 'rgba(255, 255, 255, 0.1)' },
                    ticks: { color: '#ffffff' },
                    title: {
                        display: true,
                        text: 'Quantidade',
                        color: '#ffffff'
                    }
                },
                y1: {
                    type: 'linear',
                    display: true,
                    position: 'right',
                    beginAtZero: true,
                    grid: { drawOnChartArea: false },
                    ticks: { 
                        color: '#ffffff',
                        callback: function(value) {
                            return 'R$ ' + value.toLocaleString('pt-BR', { minimumFractionDigits: 2 });
                        }
                    },
                    title: {
                        display: true,
                        text: 'Valor (R$)',
                        color: '#ffffff'
                    }
                },
                x: {
                    grid: { color: 'rgba(255, 255, 255, 0.1)' },
                    ticks: { color: '#ffffff' }
                }
            }
        }
    });
}

function updateFinancialSummary() {
    const now = new Date();
    const last7Days = new Date(now.getTime() - (7 * 24 * 60 * 60 * 1000));
    const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
    const last6Months = new Date(now.getFullYear(), now.getMonth() - 6, 1);
    const last12Months = new Date(now.getFullYear(), now.getMonth() - 12, 1);
    
    const last7DaysTotal = loans.filter(loan => {
        const loanDate = new Date(loan.created_at);
        return loanDate >= last7Days;
    }).reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
    
    const lastMonthTotal = loans.filter(loan => {
        const loanDate = new Date(loan.created_at);
        return loanDate >= lastMonth;
    }).reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
    
    const last6MonthsTotal = loans.filter(loan => {
        const loanDate = new Date(loan.created_at);
        return loanDate >= last6Months;
    }).reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
    
    const last12MonthsTotal = loans.filter(loan => {
        const loanDate = new Date(loan.created_at);
        return loanDate >= last12Months;
    }).reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
    
    const last7DaysElement = document.getElementById('last7DaysTotal');
    const lastMonthElement = document.getElementById('lastMonthTotal');
    const last6MonthsElement = document.getElementById('last6MonthsTotal');
    const last12MonthsElement = document.getElementById('last12MonthsTotal');
    
    if (last7DaysElement) last7DaysElement.textContent = `R$ ${last7DaysTotal.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`;
    if (lastMonthElement) lastMonthElement.textContent = `R$ ${lastMonthTotal.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`;
    if (last6MonthsElement) last6MonthsElement.textContent = `R$ ${last6MonthsTotal.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`;
    if (last12MonthsElement) last12MonthsElement.textContent = `R$ ${last12MonthsTotal.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`;
}

// Funções auxiliares para datas
function getLast7Days() {
    const days = [];
    const now = new Date();
    
    for (let i = 6; i >= 0; i--) {
        const day = new Date(now);
        day.setDate(now.getDate() - i);
        days.push(day);
    }
    
    return days;
}

function getLast6Months() {
    const months = [];
    const now = new Date();
    
    for (let i = 5; i >= 0; i--) {
        const month = new Date(now.getFullYear(), now.getMonth() - i, 1);
        months.push(month);
    }
    
    return months;
}

function getLast12Months() {
    const months = [];
    const now = new Date();
    
    for (let i = 11; i >= 0; i--) {
        const month = new Date(now.getFullYear(), now.getMonth() - i, 1);
        months.push(month);
    }
    
    return months;
}

// Funções de visualização e exclusão
function editClient(clientId) {
    const client = clients.find(c => c.id === clientId);
    if (!client) return;
    
    // Preencher as informações do cliente para visualização
    const viewClientName = document.getElementById('viewClientName');
    const viewClientCPF = document.getElementById('viewClientCPF');
    const viewClientEmail = document.getElementById('viewClientEmail');
    const viewClientPhone = document.getElementById('viewClientPhone');
    const viewClientAddress = document.getElementById('viewClientAddress');
    const viewClientRG = document.getElementById('viewClientRG');
    const viewClientBirthDate = document.getElementById('viewClientBirthDate');
    
    // Verificar se todos os elementos existem antes de definir valores
    if (!viewClientName || !viewClientCPF || !viewClientEmail || 
        !viewClientPhone || !viewClientAddress || !viewClientRG || !viewClientBirthDate) {
        console.error('Erro: Alguns elementos do modal de visualização não foram encontrados');
        return;
    }
    
    viewClientName.textContent = client.name || 'Não informado';
    viewClientCPF.textContent = client.cpf || 'Não informado';
    viewClientEmail.textContent = client.email || 'Não informado';
    viewClientPhone.textContent = client.phone || 'Não informado';
    viewClientAddress.textContent = client.address || 'Não informado';
    viewClientRG.textContent = client.rg || 'Não informado';
    
    // Formatar data de nascimento
    if (client.birth_date) {
        const date = new Date(client.birth_date);
        viewClientBirthDate.textContent = date.toLocaleDateString('pt-BR');
    } else {
        viewClientBirthDate.textContent = 'Não informado';
    }
    
    // Carregar e exibir avalistas e contatos de emergência do cliente
    loadAndDisplayClientGuarantorsView(clientId);
    loadAndDisplayClientEmergencyContactsView(clientId);
    
    showModal(document.getElementById('viewClientModal'));
    
    // Mostrar mensagem informativa
    showInfoMessage(`Visualizando informações do cliente: ${client.name}`);
}

// Função para abrir modal de edição de cliente
function openEditClientModal(clientId) {
    const client = clients.find(c => c.id === clientId);
    if (!client) return;
    
    // Preencher os campos do formulário de edição
    document.getElementById('editClientId').value = client.id;
    document.getElementById('editClientName').value = client.name || '';
    document.getElementById('editClientCPF').value = client.cpf || '';
    document.getElementById('editClientEmail').value = client.email || '';
    document.getElementById('editClientPhone').value = client.phone || '';
    document.getElementById('editClientRG').value = client.rg || '';
    document.getElementById('editClientBirthDate').value = client.birth_date || '';
    document.getElementById('editClientAddress').value = client.address || '';
    
    // Carregar e exibir avalistas e contatos de emergência do cliente
    loadAndDisplayClientGuarantors(clientId);
    loadAndDisplayClientEmergencyContacts(clientId);
    
    showModal(document.getElementById('editClientModal'));
    
    // Mostrar mensagem informativa
    showInfoMessage(`Editando informações do cliente: ${client.name}`);
}

function deleteClient(clientId) {
    const client = clients.find(c => c.id === clientId);
    if (!client) return;
    
    // Verificar se o cliente tem empréstimos ativos
    const hasActiveLoans = loans.some(loan => loan.client_id === clientId && loan.status === 'active');
    const hasAnyLoans = loans.some(loan => loan.client_id === clientId);
    const clientLoans = loans.filter(loan => loan.client_id === clientId);
    
    if (hasActiveLoans) {
        alert('Não é possível excluir um cliente com empréstimos ativos. Cancele os empréstimos primeiro.');
        return;
    }
    
    if (hasAnyLoans) {
        const totalLoans = clientLoans.length;
        const totalAmount = clientLoans.reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
        
        showConfirmationModal(
            'Excluir Cliente',
            `O cliente "${client.name}" possui histórico de ${totalLoans} empréstimo(s) totalizando R$ ${totalAmount.toFixed(2)}. Tem certeza que deseja excluí-lo? Esta ação não pode ser desfeita.`,
            () => performDeleteClient(clientId),
            'Excluir'
        );
    } else {
        showConfirmationModal(
            'Excluir Cliente',
            `Tem certeza que deseja excluir o cliente "${client.name}"? Esta ação não pode ser desfeita.`,
            () => performDeleteClient(clientId),
            'Excluir'
        );
    }
}

function editLoan(loanId) {
    const loan = loans.find(l => l.id === loanId);
    if (!loan) return;
    
    // Preencher o formulário de edição
    document.getElementById('editLoanId').value = loan.id;
    document.getElementById('editLoanAmount').value = loan.amount;
    document.getElementById('editLoanInterest').value = loan.interest_rate;
    document.getElementById('editLoanDate').value = loan.loan_date;
    document.getElementById('editLoanDueDate').value = loan.due_date;
    document.getElementById('editLoanStatus').value = loan.status || 'active';
    
    // Preencher o select de clientes
    populateEditLoanClientSelect(loan.client_id);
    
    // Atualizar o resumo
    updateEditLoanSummary();
    
    showModal(document.getElementById('editLoanModal'));
    
    // Configurar busca de clientes
    setupClientSearch(
        'editLoanClientSearch',
        'editLoanClient',
        'editLoanClientResultsList',
        'editLoanClientResults'
    );
    
    // Preencher campo de busca com o cliente atual
    const client = clients.find(c => c.id === loan.client_id);
    if (client) {
        document.getElementById('editLoanClientSearch').value = `${client.name} - ${client.cpf}`;
    }
    
    // Mostrar mensagem informativa
    const clientName = loan.clients?.name || 'Cliente não encontrado';
    const total = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
    showInfoMessage(`Editando empréstimo de ${clientName} - Valor: R$ ${parseFloat(loan.amount).toFixed(2)}, Total: R$ ${total.toFixed(2)}`);
}

function deleteLoan(loanId) {
    const loan = loans.find(l => l.id === loanId);
    if (!loan) return;
    
    const clientName = loan.clients?.name || 'Cliente não encontrado';
    const total = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
    const dueDate = new Date(loan.due_date);
    const today = new Date();
    const daysOverdue = Math.floor((today - dueDate) / (1000 * 60 * 60 * 24));
    
    let statusInfo = '';
    if (dueDate < today && loan.status !== 'paid') {
        statusInfo = ` (Vencido há ${daysOverdue} dias)`;
    } else if (loan.status === 'active') {
        statusInfo = ' (Ativo)';
    } else if (loan.status === 'paid') {
        statusInfo = ' (Pago)';
    }
    
    showConfirmationModal(
        'Cancelar Empréstimo',
        `Tem certeza que deseja cancelar o empréstimo de "${clientName}" no valor de R$ ${parseFloat(loan.amount).toFixed(2)} com juros de ${loan.interest_rate}% (Total: R$ ${total.toFixed(2)})${statusInfo}? Esta ação não pode ser desfeita.`,
        () => cancelLoan(loanId),
        'Excluir'
    );
}

function showPaymentHistory(loanId) {
    const loan = loans.find(l => l.id === loanId);
    if (!loan) {
        console.error('Loan not found:', loanId);
        return;
    }
    
    const clientName = loan.clients?.name || 'Cliente não encontrado';
    
    // Atualizar título do modal
    const titleElement = document.querySelector('#paymentHistoryModal h3');
    if (titleElement) {
        titleElement.textContent = `Histórico de Pagamentos - ${clientName}`;
    }
    
    // Preencher dados do empréstimo
    document.getElementById('paymentHistoryLoanId').value = loanId;
    document.getElementById('paymentHistoryLoanAmount').textContent = `R$ ${parseFloat(loan.amount).toFixed(2)}`;
    document.getElementById('paymentHistoryLoanInterestRate').textContent = `${parseFloat(loan.interest_rate).toFixed(2)}%`;
    document.getElementById('paymentHistoryLoanDate').textContent = formatDate(loan.loan_date);
    document.getElementById('paymentHistoryLoanDueDate').textContent = formatDate(loan.due_date);
    document.getElementById('paymentHistoryLoanStatus').textContent = getStatusText(getLoanStatus(loan.due_date));
    
    // Carregar histórico de pagamentos
    loadPaymentHistory(loanId);
    
    showModal(paymentHistoryModal);
    
    // Mostrar mensagem informativa
    showInfoMessage(`Visualizando histórico de pagamentos de ${clientName}`);
}

// =====================================================
// FUNÇÕES DE GERENCIAMENTO DE AVALISTAS
// =====================================================

// Carregar e exibir avalistas de um cliente
async function loadAndDisplayClientGuarantors(clientId) {
    try {
        const clientGuarantors = await loadClientGuarantors(clientId);
        renderGuarantorsList(clientGuarantors, clientId);
    } catch (error) {
        console.error('Erro ao carregar avalistas do cliente:', error);
    }
}

// Renderizar lista de avalistas
function renderGuarantorsList(clientGuarantors, clientId) {
    const guarantorsList = document.getElementById('guarantorsList');
    
    if (clientGuarantors.length === 0) {
        guarantorsList.innerHTML = `
            <div class="text-center py-6 text-gray-400">
                <p>Nenhum avalista cadastrado para este cliente.</p>
            </div>
        `;
        return;
    }
    
    const guarantorsHTML = clientGuarantors.map(guarantor => `
        <div class="bg-gray-800 rounded-lg p-4 border border-gray-600">
            <div class="flex items-start justify-between">
                <div class="flex items-start space-x-4">
                    ${guarantor.photo ? `
                        <img src="${guarantor.photo}" alt="${guarantor.name}" class="w-12 h-12 rounded-full object-cover border-2 border-blue-500">
                    ` : `
                        <div class="w-12 h-12 rounded-full bg-gray-600 flex items-center justify-center border-2 border-gray-500">
                            <span class="text-white font-semibold">${guarantor.name.charAt(0).toUpperCase()}</span>
                        </div>
                    `}
                    <div class="flex-1">
                        <h5 class="text-white font-semibold">${guarantor.name}</h5>
                        <p class="text-gray-300 text-sm">CPF: ${guarantor.cpf}</p>
                        <p class="text-gray-300 text-sm">Telefone: ${guarantor.phone}</p>
                        ${guarantor.relationship ? `<p class="text-blue-300 text-sm">Relacionamento: ${getRelationshipText(guarantor.relationship)}</p>` : ''}
                        ${guarantor.email ? `<p class="text-gray-400 text-xs">${guarantor.email}</p>` : ''}
                        ${guarantor.address ? `<p class="text-gray-400 text-xs">Endereço: ${guarantor.address}</p>` : ''}
                    </div>
                </div>
                <div class="flex space-x-2">
                    <button onclick="editGuarantor('${guarantor.id}')" class="text-blue-400 hover:text-blue-300 p-1" title="Editar avalista">
                        ✏️
                    </button>
                    <button onclick="deleteGuarantor('${guarantor.id}', '${guarantor.name}')" class="text-red-400 hover:text-red-300 p-1" title="Remover avalista">
                        🗑️
                    </button>
                </div>
            </div>
        </div>
    `).join('');
    
    guarantorsList.innerHTML = guarantorsHTML;
}

// Carregar e exibir avalistas de um cliente para visualização
async function loadAndDisplayClientGuarantorsView(clientId) {
    try {
        const clientGuarantors = await loadClientGuarantors(clientId);
        renderGuarantorsListView(clientGuarantors);
    } catch (error) {
        console.error('Erro ao carregar avalistas do cliente para visualização:', error);
    }
}

// Renderizar lista de avalistas para visualização (somente leitura)
function renderGuarantorsListView(clientGuarantors) {
    const guarantorsList = document.getElementById('viewGuarantorsList');
    
    if (clientGuarantors.length === 0) {
        guarantorsList.innerHTML = `
            <div class="text-center py-6 text-gray-400">
                <p>Nenhum avalista cadastrado para este cliente.</p>
            </div>
        `;
        return;
    }
    
    const guarantorsHTML = clientGuarantors.map(guarantor => `
        <div class="bg-gray-800 rounded-lg p-4 border border-gray-600">
            <div class="flex items-start space-x-4">
                ${guarantor.photo ? `
                    <img src="${guarantor.photo}" alt="${guarantor.name}" class="w-12 h-12 rounded-full object-cover border-2 border-blue-500">
                ` : `
                    <div class="w-12 h-12 rounded-full bg-gray-600 flex items-center justify-center border-2 border-gray-500">
                        <span class="text-white font-semibold">${guarantor.name.charAt(0).toUpperCase()}</span>
                    </div>
                `}
                <div class="flex-1">
                    <h5 class="text-white font-semibold">${guarantor.name}</h5>
                    <p class="text-gray-300 text-sm">CPF: ${guarantor.cpf}</p>
                    <p class="text-gray-300 text-sm">Telefone: ${guarantor.phone}</p>
                    ${guarantor.relationship ? `<p class="text-blue-300 text-sm">Relacionamento: ${getRelationshipText(guarantor.relationship)}</p>` : ''}
                    ${guarantor.email ? `<p class="text-gray-400 text-xs">${guarantor.email}</p>` : ''}
                    ${guarantor.rg ? `<p class="text-gray-400 text-xs">RG: ${guarantor.rg}</p>` : ''}
                    ${guarantor.birth_date ? `<p class="text-gray-400 text-xs">Data de Nascimento: ${new Date(guarantor.birth_date).toLocaleDateString('pt-BR')}</p>` : ''}
                    ${guarantor.address ? `<p class="text-gray-400 text-xs">Endereço: ${guarantor.address}</p>` : ''}
                </div>
            </div>
        </div>
    `).join('');
    
    guarantorsList.innerHTML = guarantorsHTML;
}

// =====================================================
// FUNÇÕES DE GERENCIAMENTO DE CONTATOS DE EMERGÊNCIA
// =====================================================

// Carregar e exibir contatos de emergência de um cliente
async function loadAndDisplayClientEmergencyContacts(clientId) {
    try {
        const clientEmergencyContacts = await loadClientEmergencyContacts(clientId);
        renderEmergencyContactsList(clientEmergencyContacts, clientId);
    } catch (error) {
        console.error('Erro ao carregar contatos de emergência do cliente:', error);
    }
}

// Renderizar lista de contatos de emergência
function renderEmergencyContactsList(clientEmergencyContacts, clientId) {
    const emergencyContactsList = document.getElementById('emergencyContactsList');
    
    if (clientEmergencyContacts.length === 0) {
        emergencyContactsList.innerHTML = `
            <div class="text-center py-6 text-gray-400">
                <p>Nenhum contato de emergência cadastrado para este cliente.</p>
            </div>
        `;
        return;
    }
    
    const emergencyContactsHTML = clientEmergencyContacts.map(contact => {
        const displayName = contact.name || 'Nome não informado';
        const displayPhone = contact.phone || 'Telefone não informado';
        const initial = contact.name ? contact.name.charAt(0).toUpperCase() : '?';
        
        return `
        <div class="bg-gray-800 rounded-lg p-4 border border-gray-600">
            <div class="flex items-start justify-between">
                <div class="flex items-start space-x-4">
                    <div class="w-12 h-12 rounded-full bg-green-600 flex items-center justify-center border-2 border-green-500">
                        <span class="text-white font-semibold">${initial}</span>
                    </div>
                    <div class="flex-1">
                        <h5 class="font-semibold text-white mb-1">${displayName}</h5>
                        <p class="text-sm text-blue-300">📞 ${displayPhone}</p>
                    </div>
                </div>
                <div class="flex space-x-2">
                    <button onclick="editEmergencyContact('${contact.id}')" class="text-blue-400 hover:text-blue-300 p-1 rounded" title="Editar">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                        </svg>
                    </button>
                    <button onclick="deleteEmergencyContact('${contact.id}')" class="text-red-400 hover:text-red-300 p-1 rounded" title="Excluir">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                        </svg>
                    </button>
                </div>
            </div>
        </div>
        `;
    }).join('');
    
    emergencyContactsList.innerHTML = emergencyContactsHTML;
}

// Renderizar lista de contatos de emergência para visualização (somente leitura)
function renderEmergencyContactsListView(clientEmergencyContacts) {
    const emergencyContactsList = document.getElementById('viewEmergencyContactsList');
    
    if (clientEmergencyContacts.length === 0) {
        emergencyContactsList.innerHTML = `
            <div class="text-center py-6 text-gray-400">
                <p>Nenhum contato de emergência cadastrado para este cliente.</p>
            </div>
        `;
        return;
    }
    
    const emergencyContactsHTML = clientEmergencyContacts.map(contact => {
        const displayName = contact.name || 'Nome não informado';
        const displayPhone = contact.phone || 'Telefone não informado';
        const initial = contact.name ? contact.name.charAt(0).toUpperCase() : '?';
        
        return `
        <div class="bg-gray-800 rounded-lg p-4 border border-gray-600">
            <div class="flex items-start space-x-4">
                <div class="w-12 h-12 rounded-full bg-green-600 flex items-center justify-center border-2 border-green-500">
                    <span class="text-white font-semibold">${initial}</span>
                </div>
                <div class="flex-1">
                    <h5 class="font-semibold text-white mb-1">${displayName}</h5>
                    <p class="text-sm text-blue-300">📞 ${displayPhone}</p>
                </div>
            </div>
        </div>
        `;
    }).join('');
    
    emergencyContactsList.innerHTML = emergencyContactsHTML;
}

// Carregar e exibir contatos de emergência de um cliente para visualização
async function loadAndDisplayClientEmergencyContactsView(clientId) {
    try {
        const clientEmergencyContacts = await loadClientEmergencyContacts(clientId);
        renderEmergencyContactsListView(clientEmergencyContacts);
    } catch (error) {
        console.error('Erro ao carregar contatos de emergência do cliente para visualização:', error);
    }
}

// Editar contato de emergência
function editEmergencyContact(emergencyContactId) {
    openEmergencyContactModal(emergencyContactId);
}

// Excluir contato de emergência
async function deleteEmergencyContact(emergencyContactId) {
    const emergencyContact = emergencyContacts.find(ec => ec.id === emergencyContactId);
    if (!emergencyContact) return;
    
    const displayName = emergencyContact.name || emergencyContact.phone || 'este contato';
    if (!confirm(`Tem certeza que deseja excluir o contato de emergência "${displayName}"?`)) {
        return;
    }
    
    try {
        const { error } = await supabase
            .from('emergency_contacts')
            .delete()
            .eq('id', emergencyContactId);
        
        if (error) throw error;
        
        // Recarregar dados
        await loadEmergencyContacts();
        const clientId = document.getElementById('editClientId').value;
        if (clientId) {
            await loadAndDisplayClientEmergencyContacts(clientId);
        }
        
        showSuccessMessage('Contato de emergência excluído com sucesso!');
        
    } catch (error) {
        console.error('Erro ao excluir contato de emergência:', error);
        alert('Erro ao excluir contato de emergência: ' + error.message);
    }
}

// Limpar formulário de avalista no novo cliente
function clearNewClientGuarantorForm() {
    document.getElementById('newClientGuarantorName').value = '';
    document.getElementById('newClientGuarantorCPF').value = '';
    document.getElementById('newClientGuarantorEmail').value = '';
    document.getElementById('newClientGuarantorPhone').value = '';
    document.getElementById('newClientGuarantorRG').value = '';
    document.getElementById('newClientGuarantorBirthDate').value = '';
    document.getElementById('newClientGuarantorRelationship').value = '';
    document.getElementById('newClientGuarantorAddress').value = '';
    document.getElementById('newClientGuarantorPhoto').value = '';
    document.getElementById('newClientGuarantorPhotoUploadPreview').classList.add('hidden');
    
    // Limpar widget do Uploadcare se existir
    if (window.uploadcare) {
        const widget = uploadcare.Widget('#newClientGuarantorPhotoUploader');
        if (widget) {
            widget.value(null);
        }
    }
}

// Limpar formulário de contato de emergência no novo cliente
function clearNewClientEmergencyContactForm() {
    document.getElementById('newClientEmergencyContactName').value = '';
    document.getElementById('newClientEmergencyContactPhone').value = '';
}

// Abrir modal para adicionar avalista
function openGuarantorModal(guarantorId = null) {
    const clientId = document.getElementById('editClientId').value;
    if (!clientId) {
        alert('Erro: ID do cliente não encontrado');
        return;
    }
    
    // Limpar formulário
    document.getElementById('guarantorForm').reset();
    document.getElementById('guarantorPhoto').value = '';
    document.getElementById('guarantorPhotoUploadPreview').classList.add('hidden');
    
    // Configurar modal para adição ou edição
    if (guarantorId) {
        document.getElementById('guarantorModalTitle').textContent = 'Editar Avalista';
        document.getElementById('guarantorId').value = guarantorId;
        
        // Carregar dados do avalista
        const guarantor = guarantors.find(g => g.id === guarantorId);
        if (guarantor) {
            fillGuarantorForm(guarantor);
        }
    } else {
        document.getElementById('guarantorModalTitle').textContent = 'Adicionar Avalista';
        document.getElementById('guarantorId').value = '';
    }
    
    document.getElementById('guarantorClientId').value = clientId;
    showModal(guarantorModal);
}

// Abrir modal para adicionar contato de emergência
function openEmergencyContactModal(emergencyContactId = null) {
    const clientId = document.getElementById('editClientId').value;
    if (!clientId) {
        alert('Erro: ID do cliente não encontrado');
        return;
    }
    
    // Limpar formulário
    document.getElementById('emergencyContactForm').reset();
    
    // Configurar modal para adição ou edição
    if (emergencyContactId) {
        document.getElementById('emergencyContactModalTitle').textContent = 'Editar Contato de Emergência';
        document.getElementById('emergencyContactId').value = emergencyContactId;
        
        // Carregar dados do contato de emergência
        const emergencyContact = emergencyContacts.find(ec => ec.id === emergencyContactId);
        if (emergencyContact) {
            fillEmergencyContactForm(emergencyContact);
        }
    } else {
        document.getElementById('emergencyContactModalTitle').textContent = 'Adicionar Contato de Emergência';
        document.getElementById('emergencyContactId').value = '';
    }
    
    document.getElementById('emergencyContactClientId').value = clientId;
    showModal(emergencyContactModal);
}

// Preencher formulário de avalista com dados existentes
function fillGuarantorForm(guarantor) {
    document.getElementById('guarantorName').value = guarantor.name || '';
    document.getElementById('guarantorCPF').value = guarantor.cpf || '';
    document.getElementById('guarantorRG').value = guarantor.rg || '';
    document.getElementById('guarantorBirthDate').value = guarantor.birth_date || '';
    document.getElementById('guarantorEmail').value = guarantor.email || '';
    document.getElementById('guarantorPhone').value = guarantor.phone || '';
    document.getElementById('guarantorRelationship').value = guarantor.relationship || '';
    document.getElementById('guarantorAddress').value = guarantor.address || '';
    document.getElementById('guarantorPhoto').value = guarantor.photo || '';
    
    // Atualizar preview da foto se existir
    if (guarantor.photo) {
        const previewDiv = document.getElementById('guarantorPhotoUploadPreview');
        const previewImg = document.getElementById('guarantorPhotoPreviewImg');
        
        previewImg.src = guarantor.photo;
        previewDiv.classList.remove('hidden');
        
        // Configurar o widget com a foto atual se disponível
        if (window.uploadcare) {
            const guarantorWidget = uploadcare.Widget('#guarantorPhotoUploader');
            guarantorWidget.value(guarantor.photo);
        }
    }
}

// Gerenciar formulário de avalista
async function handleGuarantorForm(e) {
    e.preventDefault();
    
    const guarantorId = document.getElementById('guarantorId').value;
    const clientId = document.getElementById('guarantorClientId').value;
    
    const formData = {
        client_id: clientId,
        name: document.getElementById('guarantorName').value,
        cpf: document.getElementById('guarantorCPF').value,
        rg: document.getElementById('guarantorRG').value,
        birth_date: document.getElementById('guarantorBirthDate').value || null,
        email: document.getElementById('guarantorEmail').value || null,
        phone: document.getElementById('guarantorPhone').value,
        relationship: document.getElementById('guarantorRelationship').value || null,
        address: document.getElementById('guarantorAddress').value || null,
        photo: document.getElementById('guarantorPhoto').value || null,
        updated_at: new Date().toISOString()
    };
    
    try {
        if (guarantorId) {
            // Editar avalista existente
            const { data, error } = await supabase
                .from('guarantors')
                .update(formData)
                .eq('id', guarantorId)
                .select();
            
            if (error) throw error;
            
            showSuccessMessage(`Avalista "${formData.name}" atualizado com sucesso!`);
        } else {
            // Criar novo avalista
            formData.created_at = new Date().toISOString();
            
            const { data, error } = await supabase
                .from('guarantors')
                .insert([formData])
                .select();
            
            if (error) throw error;
            
            showSuccessMessage(`Avalista "${formData.name}" adicionado com sucesso!`);
        }
        
        // Fechar modal e recarregar dados
        hideModal(guarantorModal);
        await loadGuarantors();
        await loadAndDisplayClientGuarantors(clientId);
        
    } catch (error) {
        console.error('Erro ao salvar avalista:', error);
        alert('Erro ao salvar avalista: ' + error.message);
    }
}

// Preencher formulário de contato de emergência com dados existentes
function fillEmergencyContactForm(emergencyContact) {
    document.getElementById('emergencyContactName').value = emergencyContact.name || '';
    document.getElementById('emergencyContactPhone').value = emergencyContact.phone || '';
}

// Gerenciar formulário de contato de emergência
async function handleEmergencyContactForm(e) {
    e.preventDefault();
    
    const emergencyContactId = document.getElementById('emergencyContactId').value;
    const clientId = document.getElementById('emergencyContactClientId').value;
    
    const name = document.getElementById('emergencyContactName').value.trim();
    const phone = document.getElementById('emergencyContactPhone').value.trim();
    
    // Validar que pelo menos um campo esteja preenchido
    if (!name && !phone) {
        alert('Por favor, preencha pelo menos o nome ou o celular do contato de emergência.');
        return;
    }
    
    const formData = {
        client_id: clientId,
        name: name || null,
        phone: phone || null,
        updated_at: new Date().toISOString()
    };
    
    try {
        if (emergencyContactId) {
            // Editar contato de emergência existente
            const { data, error } = await supabase
                .from('emergency_contacts')
                .update(formData)
                .eq('id', emergencyContactId)
                .select();
            
            if (error) throw error;
            
            const displayName = formData.name || formData.phone || 'Contato';
            showSuccessMessage(`Contato de emergência "${displayName}" atualizado com sucesso!`);
        } else {
            // Criar novo contato de emergência
            formData.created_by = currentUser.id;
            formData.created_at = new Date().toISOString();
            
            const { data, error } = await supabase
                .from('emergency_contacts')
                .insert([formData])
                .select();
            
            if (error) throw error;
            
            const displayName = formData.name || formData.phone || 'Contato';
            showSuccessMessage(`Contato de emergência "${displayName}" adicionado com sucesso!`);
        }
        
        // Fechar modal e recarregar dados
        hideModal(emergencyContactModal);
        await loadEmergencyContacts();
        await loadAndDisplayClientEmergencyContacts(clientId);
        
    } catch (error) {
        console.error('Erro ao salvar contato de emergência:', error);
        alert('Erro ao salvar contato de emergência: ' + error.message);
    }
}

// Editar avalista
function editGuarantor(guarantorId) {
    openGuarantorModal(guarantorId);
}

// Excluir avalista
function deleteGuarantor(guarantorId, guarantorName) {
    showConfirmationModal(
        'Excluir Avalista',
        `Tem certeza que deseja excluir o avalista "${guarantorName}"? Esta ação não pode ser desfeita.`,
        () => performDeleteGuarantor(guarantorId),
        'Excluir'
    );
}

// Executar exclusão do avalista
async function performDeleteGuarantor(guarantorId) {
    try {
        const { error } = await supabase
            .from('guarantors')
            .delete()
            .eq('id', guarantorId);
        
        if (error) throw error;
        
        // Recarregar dados
        await loadGuarantors();
        const clientId = document.getElementById('editClientId').value;
        if (clientId) {
            await loadAndDisplayClientGuarantors(clientId);
        }
        
        showSuccessMessage('Avalista excluído com sucesso!');
        
    } catch (error) {
        console.error('Erro ao excluir avalista:', error);
        alert('Erro ao excluir avalista: ' + error.message);
    }
}

// Obter texto do relacionamento
function getRelationshipText(relationship) {
    const relationships = {
        'conjuge': 'Cônjuge',
        'pai': 'Pai',
        'mae': 'Mãe',
        'filho': 'Filho(a)',
        'irmao': 'Irmão/Irmã',
        'parente': 'Parente',
        'amigo': 'Amigo(a)',
        'conhecido': 'Conhecido(a)',
        'outro': 'Outro'
    };
    return relationships[relationship] || relationship;
}

async function showNewPaymentFromHistory() {
    const loanId = document.getElementById('paymentHistoryLoanId').value;
    if (!loanId) return;
    
    // Fechar modal de histórico
    hideModal(paymentHistoryModal);
    
    // Mostrar modal de pagamento (aguardar cálculo dos valores)
    await showPaymentModal(loanId);
}

// Função para mostrar o modal de confirmação do WhatsApp
function showWhatsAppSummaryModal(loanId) {
    whatsappSummaryModal.dataset.loanId = loanId;
    showModal(whatsappSummaryModal);
}

// Função para enviar resumo do empréstimo via WhatsApp (para novos empréstimos)
async function sendLoanSummaryWhatsApp(loanId) {
    try {
        // Buscar dados atualizados do empréstimo diretamente do banco
        const { data: loanData, error: loanError } = await supabase
            .from('loans')
            .select('*, clients(*)')
            .eq('id', loanId)
            .single();

        if (loanError) throw loanError;
        
        const loan = loanData;
        if (!loan) {
            showErrorMessage('Empréstimo não encontrado!');
            return;
        }

        const client = loan.clients;
        if (!client) {
            showErrorMessage('Dados do cliente não encontrados!');
            return;
        }

        // Verificar se o cliente tem telefone
        if (!client.phone) {
            showErrorMessage('Cliente não possui telefone cadastrado!');
            return;
        }

        // Calcular valores do empréstimo
        const principalAmount = parseFloat(loan.amount);
        const interestRate = parseFloat(loan.interest_rate);
        const interestAmount = principalAmount * (interestRate / 100);
        const totalAmount = principalAmount + interestAmount;
        
        // Formatar datas
        const formattedLoanDate = formatDate(loan.loan_date);
        const formattedDueDate = formatDate(loan.due_date);

        // Montar mensagem do resumo do empréstimo
        const message = `🎯 RESUMO DO EMPRÉSTIMO

👤 CLIENTE: ${client.name}
📅 DATA DO EMPRÉSTIMO: ${formattedLoanDate}
📅 DATA DE VENCIMENTO: ${formattedDueDate}

💰 VALORES:
💵 Capital: R$ ${principalAmount.toFixed(2)}
📊 Valor dos Juros: R$ ${interestAmount.toFixed(2)}
💎 VALOR TOTAL: R$ ${totalAmount.toFixed(2)}

⚠️ IMPORTANTE:
• Pagamento deve ser realizado até a data de vencimento
• Após vencimento: multa diária de R$ 50,00
• Mantenha este comprovante para consulta

Obrigado pela confiança! 🤝`;

        // Limpar o número de telefone (remover caracteres especiais)
        const cleanPhone = client.phone.replace(/\D/g, '');
        
        // Verificar se o número tem o código do país
        const phoneNumber = cleanPhone.startsWith('55') ? cleanPhone : '55' + cleanPhone;

        // Criar URL do WhatsApp
        const whatsappUrl = `https://wa.me/${phoneNumber}?text=${encodeURIComponent(message)}`;

        // Abrir WhatsApp em nova aba
        window.open(whatsappUrl, '_blank');

        // Mostrar mensagem de sucesso
        showSuccessMessage(`Resumo do empréstimo enviado para ${client.name} (${client.phone})`);

    } catch (error) {
        console.error('Erro ao enviar resumo via WhatsApp:', error);
        showErrorMessage('Erro ao preparar resumo do WhatsApp: ' + error.message);
    }
}

// Variáveis globais para armazenar o ID do empréstimo/parcelamento atual
let currentLoanIdForPix = null;
let currentInstallmentIdForPix = null;

// Função para mostrar o modal de seleção de chave PIX
async function showPixKeySelector(loanId) {
    currentLoanIdForPix = loanId;
    currentInstallmentIdForPix = null; // Limpar parcelamento
    
    // Mostrar o modal
    document.getElementById('pixKeyModal').classList.remove('hidden');
    
    // Carregar as chaves PIX disponíveis
    await loadPixKeys();
}

// Função para mostrar o modal de seleção de chave PIX para parcelamentos
async function showPixKeySelectorForInstallment(installmentId) {
    currentInstallmentIdForPix = installmentId;
    currentLoanIdForPix = null; // Limpar o ID do empréstimo
    
    // Mostrar o modal
    document.getElementById('pixKeyModal').classList.remove('hidden');
    
    // Carregar as chaves PIX disponíveis
    await loadPixKeys();
}

// Função para fechar o modal de seleção de chave PIX
function closePixKeyModal() {
    document.getElementById('pixKeyModal').classList.add('hidden');
    currentLoanIdForPix = null;
    currentInstallmentIdForPix = null;
}

// Função para carregar as chaves PIX do banco de dados
async function loadPixKeys() {
    try {
        let pixKeys;
        
        // Tentar carregar do banco de dados
        try {
            const { data, error } = await supabase
                .from('pix_keys')
                .select('*')
                .eq('is_active', true)
                .order('bank_name', { ascending: true });

            if (error) throw error;
            pixKeys = data;
        } catch (dbError) {
            console.warn('Tabela pix_keys não encontrada, usando dados de exemplo:', dbError);
            // Usar dados de exemplo se a tabela não existir
            pixKeys = [
                {
                    id: '1',
                    bank_name: 'Banco do Brasil',
                    pix_key: '12345678901',
                    pix_key_type: 'cpf',
                    account_holder: 'João Silva',
                    is_active: true
                },
                {
                    id: '2',
                    bank_name: 'Itaú',
                    pix_key: 'joao@email.com',
                    pix_key_type: 'email',
                    account_holder: 'João Silva',
                    is_active: true
                },
                {
                    id: '3',
                    bank_name: 'Nubank',
                    pix_key: '11987654321',
                    pix_key_type: 'phone',
                    account_holder: 'João Silva',
                    is_active: true
                }
            ];
        }

        const pixKeysList = document.getElementById('pixKeysList');
        
        if (pixKeys.length === 0) {
            pixKeysList.innerHTML = `
                <div class="text-center py-4">
                    <p class="text-gray-400 text-sm">Nenhuma chave PIX cadastrada.</p>
                    <p class="text-gray-500 text-xs mt-1">Clique em "Nova Chave PIX" para adicionar uma.</p>
                </div>
            `;
            return;
        }

        pixKeysList.innerHTML = pixKeys.map(pixKey => `
            <div class="pix-key-item border border-gray-600 rounded-lg p-3 hover:border-blue-500 cursor-pointer transition-colors"
                 data-pix-id="${pixKey.id}" 
                 data-bank-name="${pixKey.bank_name.replace(/"/g, '&quot;')}" 
                 data-pix-key="${pixKey.pix_key.replace(/"/g, '&quot;')}"
                 data-account-holder="${pixKey.account_holder.replace(/"/g, '&quot;')}">
                <div class="flex justify-between items-start">
                    <div class="flex-1">
                        <div class="font-medium text-white">${pixKey.bank_name}</div>
                        <div class="text-sm text-gray-300">${pixKey.account_holder}</div>
                        <div class="text-xs text-gray-400 mt-1">
                            <span class="inline-block bg-gray-700 px-2 py-1 rounded text-xs uppercase">
                                ${getPixKeyTypeLabel(pixKey.pix_key_type)}
                            </span>
                            <span class="ml-2">${maskPixKey(pixKey.pix_key, pixKey.pix_key_type)}</span>
                        </div>
                    </div>
                    <div class="text-blue-400 text-sm">Selecionar</div>
                </div>
            </div>
        `).join('');

        // Adicionar event listeners para os itens de chave PIX
        document.querySelectorAll('.pix-key-item').forEach(item => {
            item.addEventListener('click', function() {
                const pixId = this.getAttribute('data-pix-id');
                const bankName = this.getAttribute('data-bank-name');
                const pixKey = this.getAttribute('data-pix-key');
                const accountHolder = this.getAttribute('data-account-holder');
                selectPixKey(pixId, bankName, pixKey, accountHolder);
            });
        });

    } catch (error) {
        console.error('Erro ao carregar chaves PIX:', error);
        showErrorMessage('Erro ao carregar chaves PIX: ' + error.message);
        
        document.getElementById('pixKeysList').innerHTML = `
            <div class="text-center py-4">
                <p class="text-red-400 text-sm">Erro ao carregar chaves PIX</p>
                <p class="text-gray-500 text-xs mt-1">Tente novamente ou adicione uma nova chave.</p>
            </div>
        `;
    }
}

// Função para obter o label do tipo de chave PIX
function getPixKeyTypeLabel(type) {
    const labels = {
        'cpf': 'CPF',
        'cnpj': 'CNPJ', 
        'email': 'E-mail',
        'phone': 'Telefone',
        'random': 'Aleatória'
    };
    return labels[type] || type.toUpperCase();
}

// Função para mascarar a chave PIX para exibição
function maskPixKey(key, type) {
    if (type === 'cpf') {
        return key.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.***.**$4');
    } else if (type === 'cnpj') {
        return key.replace(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, '$1.***.***/$4-$5');
    } else if (type === 'email') {
        const [local, domain] = key.split('@');
        return `${local.substring(0, 2)}***@${domain}`;
    } else if (type === 'phone') {
        return key.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-****');
    } else if (type === 'random') {
        return key.substring(0, 8) + '***';
    }
    return key;
}

// Função para selecionar uma chave PIX e enviar a cobrança
async function selectPixKey(pixKeyId, bankName, pixKey, accountHolder) {
    try {
        // Salvar os IDs antes de fechar o modal
        const loanId = currentLoanIdForPix;
        const installmentId = currentInstallmentIdForPix;
        
        // Fechar o modal
        closePixKeyModal();
        
        // Mostrar mensagem de processamento
        showSuccessMessage(`Enviando cobrança via ${bankName}...`);
        
        // Verificar se é para empréstimo ou parcelamento
        if (loanId) {
            // Enviar cobrança de empréstimo
            await sendWhatsAppMessageWithPixKey(loanId, pixKeyId, bankName, pixKey, accountHolder);
        } else if (installmentId) {
            // Enviar cobrança de parcelamento
            await sendInstallmentWhatsAppMessageWithPixKey(installmentId, pixKeyId, bankName, pixKey, accountHolder);
        } else {
            throw new Error('Nenhum empréstimo ou parcelamento selecionado');
        }
        
    } catch (error) {
        console.error('Erro ao selecionar chave PIX:', error);
        showErrorMessage('Erro ao processar cobrança: ' + error.message);
    }
}

// Função para mostrar o formulário de adicionar nova chave PIX
function showAddPixKeyForm() {
    document.getElementById('addPixKeyModal').classList.remove('hidden');
}

// Função para fechar o modal de adicionar chave PIX
function closeAddPixKeyModal() {
    document.getElementById('addPixKeyModal').classList.add('hidden');
    // Limpar o formulário
    document.getElementById('addPixKeyForm').reset();
}

// Função para adicionar nova chave PIX
document.addEventListener('DOMContentLoaded', function() {
    const addPixKeyForm = document.getElementById('addPixKeyForm');
    if (addPixKeyForm) {
        addPixKeyForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const bankName = document.getElementById('newPixBankName').value.trim();
            const pixKeyType = document.getElementById('newPixKeyType').value;
            const pixKey = document.getElementById('newPixKey').value.trim();
            const accountHolder = document.getElementById('newPixAccountHolder').value.trim();
            
            if (!bankName || !pixKeyType || !pixKey || !accountHolder) {
                showErrorMessage('Todos os campos são obrigatórios!');
                return;
            }
            
            try {
                const { data, error } = await supabase
                    .from('pix_keys')
                    .insert([{
                        bank_name: bankName,
                        pix_key_type: pixKeyType,
                        pix_key: pixKey,
                        account_holder: accountHolder,
                        is_active: true
                    }]);
                
                if (error) throw error;
                
                showSuccessMessage('Chave PIX adicionada com sucesso!');
                closeAddPixKeyModal();
                
                // Recarregar a lista de chaves PIX
                await loadPixKeys();
                
            } catch (error) {
                console.error('Erro ao adicionar chave PIX:', error);
                showErrorMessage('Erro ao adicionar chave PIX: ' + error.message);
            }
        });
    }
});

// Função para enviar mensagem de cobrança via WhatsApp com chave PIX selecionada
async function sendWhatsAppMessageWithPixKey(loanId, pixKeyId, bankName, pixKey, accountHolder) {
    try {
        // Buscar dados atualizados do empréstimo diretamente do banco
        const { data: loanData, error: loanError } = await supabase
            .from('loans')
            .select('*, clients(*)')
            .eq('id', loanId)
            .single();

        if (loanError) throw loanError;
        
        const loan = loanData;
        if (!loan) {
            showErrorMessage('Empréstimo não encontrado!');
            return;
        }

        const client = loan.clients;
        if (!client) {
            showErrorMessage('Dados do cliente não encontrados!');
            return;
        }

        // Verificar se o cliente tem telefone
        if (!client.phone) {
            showErrorMessage('Cliente não possui telefone cadastrado!');
            return;
        }

        // Calcular valores atuais do empréstimo usando a mesma lógica da tabela
        const principalAmount = parseFloat(loan.amount);
        const interestRate = parseFloat(loan.interest_rate);
        
        // Buscar histórico de pagamentos
        const { data: payments, error: paymentsError } = await supabase
            .from('payments')
            .select('amount, payment_date, payment_type, fine_amount')
            .eq('loan_id', loanId)
            .order('payment_date', { ascending: true });

        if (paymentsError) throw paymentsError;

        // Calcular valor restante usando a mesma lógica da tabela
        const originalCapital = parseFloat(loan.original_amount || loan.amount);
        const originalInterest = originalCapital * (interestRate / 100);
        const originalTotal = originalCapital + originalInterest;
        
        // Separar pagamentos reais
        const realPayments = payments.filter(p => parseFloat(p.amount) > 0);
        
        // Tipos de pagamento que NÃO reduzem o capital (apenas juros)
        const interestOnlyTypes = ['renewal', 'interest_renewal', 'early_payment_partial_interest', 
                                  'early_payment_interest_renewal', 'partial_interest'];
        
        // Calcular capital pago acumulado
        let capitalPaid = 0;
        let currentCapital = originalCapital;
        
        // Processar cada pagamento em ordem
        for (const payment of realPayments) {
            const paymentAmount = parseFloat(payment.amount);
            const paymentType = payment.payment_type;
            
            // Se for pagamento apenas de juros, não reduz capital
            if (interestOnlyTypes.includes(paymentType)) {
                continue;
            }
            
            // Para outros tipos de pagamento, calcular quanto foi de capital
            const currentInterest = currentCapital * (interestRate / 100);
            
            if (paymentAmount > currentInterest) {
                // Pagou mais que os juros, a diferença reduziu o capital
                const capitalReduction = paymentAmount - currentInterest;
                capitalPaid += capitalReduction;
                currentCapital = Math.max(0, currentCapital - capitalReduction);
            }
        }
        
        // Calcular valor restante correto
        const remainingCapital = Math.max(0, originalCapital - capitalPaid);
        const remainingInterest = remainingCapital * (interestRate / 100);
        const remainingAmount = remainingCapital + remainingInterest;
        
        const totalPaid = realPayments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        
        // Calcular multa se estiver vencido
        const dueDate = new Date(loan.due_date);
        const today = new Date();
        const daysOverdue = Math.floor((today - dueDate) / (1000 * 60 * 60 * 24));
        const dailyFine = 50.00; // Multa diária de R$ 50,00
        const currentFine = daysOverdue > 0 ? daysOverdue * dailyFine : 0;

        // Formatar data de vencimento
        const formattedDueDate = formatDate(loan.due_date);

        // Montar mensagem do WhatsApp com informações da chave PIX (usando valores RESTANTES, não originais)
        const message = `📢 *COBRANÇA – Grupo Creditas*
📅 *Venc.: ${formattedDueDate}*

Cliente: ${client.name}  
Valor: R$ ${remainingAmount.toFixed(2).replace('.', ',')} (Cap.: ${remainingCapital.toFixed(2).replace('.', ',')} • Juros: ${remainingInterest.toFixed(2).replace('.', ',')} • Multa: ${currentFine.toFixed(2).replace('.', ',')})

💸 *PIX – ${bankName}*  
Titular: ${accountHolder}  
Chave: ${pixKey}

⚠ Após vencimento: multa diária R$ 50.  
Enviar comprovante (obrigatório se pago em outra titularidade).`;

        // Limpar o número de telefone (remover caracteres especiais)
        const cleanPhone = client.phone.replace(/\D/g, '');
        
        // Verificar se o número tem o código do país
        const phoneNumber = cleanPhone.startsWith('55') ? cleanPhone : '55' + cleanPhone;

        // Criar URL do WhatsApp
        const whatsappUrl = `https://wa.me/${phoneNumber}?text=${encodeURIComponent(message)}`;

        // Abrir WhatsApp em nova aba
        window.open(whatsappUrl, '_blank');

        // Mostrar mensagem de sucesso
        showSuccessMessage(`Cobrança enviada para ${client.name} via ${bankName}`);

        // Atualizar a tabela de empréstimos para refletir valores atualizados
        await loadLoans();

    } catch (error) {
        console.error('Erro ao enviar mensagem do WhatsApp:', error);
        showErrorMessage('Erro ao preparar mensagem do WhatsApp: ' + error.message);
    }
}

// Função para contatar avalista ou contato de emergência
async function contactGuarantorOrEmergency(loanId) {
    const loan = loans.find(l => l.id === loanId);
    if (!loan) {
        showErrorMessage('Empréstimo não encontrado!');
        return;
    }

    // Usar client_id diretamente do loan
    const clientId = loan.client_id;
    if (!clientId) {
        showErrorMessage('Cliente não encontrado para este empréstimo!');
        return;
    }

    // Buscar dados completos do cliente
    const { data: clientData, error: clientError } = await supabase
        .from('clients')
        .select('id, name, cpf, phone')
        .eq('id', clientId)
        .single();

    if (clientError || !clientData) {
        showErrorMessage('Erro ao buscar dados do cliente!');
        return;
    }

    const client = clientData;

    try {
        // Buscar avalistas do cliente
        const { data: guarantors, error: guarantorError } = await supabase
            .from('guarantors')
            .select('*')
            .eq('client_id', clientId);

        if (guarantorError) throw guarantorError;

        // Buscar contatos de emergência do cliente
        const { data: emergencyContacts, error: emergencyError } = await supabase
            .from('emergency_contacts')
            .select('*')
            .eq('client_id', clientId);

        if (emergencyError) throw emergencyError;

        // Verificar se existe pelo menos um contato disponível
        if ((!guarantors || guarantors.length === 0) && (!emergencyContacts || emergencyContacts.length === 0)) {
            showErrorMessage('Este cliente não possui avalista ou contato de emergência cadastrado!');
            return;
        }

        // Se existe mais de um contato, mostrar modal para seleção
        if ((guarantors && guarantors.length > 0) && (emergencyContacts && emergencyContacts.length > 0)) {
            showContactSelectionModal(loanId, client, guarantors, emergencyContacts);
        } else if (guarantors && guarantors.length > 0) {
            // Se existe apenas avalista
            if (guarantors.length === 1) {
                await sendContactMessageById(loanId, guarantors[0].id, 'guarantor');
            } else {
                showContactSelectionModal(loanId, client, guarantors, []);
            }
        } else if (emergencyContacts && emergencyContacts.length > 0) {
            // Se existe apenas contato de emergência
            if (emergencyContacts.length === 1) {
                await sendContactMessageById(loanId, emergencyContacts[0].id, 'emergency');
            } else {
                showContactSelectionModal(loanId, client, [], emergencyContacts);
            }
        }

    } catch (error) {
        console.error('Erro ao buscar contatos:', error);
        showErrorMessage('Erro ao buscar contatos do cliente: ' + error.message);
    }
}

// Função para mostrar modal de seleção de contato
function showContactSelectionModal(loanId, client, guarantors, emergencyContacts) {
    const modalHTML = `
        <div id="contactSelectionModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-6">
            <div class="modal-content max-w-3xl w-full max-h-[85vh] overflow-y-auto p-8">
                <div class="flex justify-between items-center mb-8">
                    <h3 class="text-2xl font-bold text-white">Selecione o Contato</h3>
                    <button onclick="closeContactSelectionModal()" class="text-gray-400 hover:text-white text-3xl leading-none">×</button>
                </div>
                
                <div class="space-y-8">
                    ${guarantors && guarantors.length > 0 ? `
                        <div>
                            <h4 class="text-xl font-semibold text-blue-300 mb-4">Avalistas</h4>
                            <div class="space-y-3">
                                ${guarantors.map(guarantor => `
                                    <button 
                                        onclick="sendContactMessageById('${loanId}', '${guarantor.id}', 'guarantor')"
                                        class="w-full p-5 bg-gray-700 hover:bg-gray-600 rounded-lg text-left transition-colors shadow-lg hover:shadow-xl"
                                    >
                                        <div class="flex items-center space-x-5">
                                            ${guarantor.photo ? `
                                                <img src="${guarantor.photo}" alt="${guarantor.name}" class="w-12 h-12 rounded-full object-cover border-2 border-blue-500">
                                            ` : `
                                                <div class="w-12 h-12 rounded-full bg-blue-600 flex items-center justify-center">
                                                    <span class="text-white font-semibold">${guarantor.name.charAt(0).toUpperCase()}</span>
                                                </div>
                                            `}
                                            <div class="flex-1">
                                                <h5 class="text-white font-semibold">${guarantor.name}</h5>
                                                <p class="text-gray-300 text-sm">📱 ${guarantor.phone}</p>
                                                ${guarantor.relationship ? `<p class="text-blue-300 text-sm">Relacionamento: ${getRelationshipText(guarantor.relationship)}</p>` : ''}
                                            </div>
                                            <span class="text-blue-400">👥 Avalista</span>
                                        </div>
                                    </button>
                                `).join('')}
                            </div>
                        </div>
                    ` : ''}
                    
                    ${emergencyContacts && emergencyContacts.length > 0 ? `
                        <div>
                            <h4 class="text-xl font-semibold text-yellow-300 mb-4">Contatos de Emergência</h4>
                            <div class="space-y-3">
                                ${emergencyContacts.map(contact => `
                                    <button 
                                        onclick="sendContactMessageById('${loanId}', '${contact.id}', 'emergency')"
                                        class="w-full p-5 bg-gray-700 hover:bg-gray-600 rounded-lg text-left transition-colors shadow-lg hover:shadow-xl"
                                    >
                                        <div class="flex items-center space-x-5">
                                            <div class="w-12 h-12 rounded-full bg-yellow-600 flex items-center justify-center">
                                                <span class="text-white font-semibold">${contact.name ? contact.name.charAt(0).toUpperCase() : '?'}</span>
                                            </div>
                                            <div class="flex-1">
                                                <h5 class="text-white font-semibold">${contact.name || 'Sem nome'}</h5>
                                                <p class="text-gray-300 text-sm">📱 ${contact.phone}</p>
                                                ${contact.relationship ? `<p class="text-yellow-300 text-sm">Relacionamento: ${getRelationshipText(contact.relationship)}</p>` : ''}
                                            </div>
                                            <span class="text-yellow-400">🚨 Emergência</span>
                                        </div>
                                    </button>
                                `).join('')}
                            </div>
                        </div>
                    ` : ''}
                </div>
            </div>
        </div>
    `;
    
    document.body.insertAdjacentHTML('beforeend', modalHTML);
}

// Função para fechar modal de seleção de contato
function closeContactSelectionModal() {
    const modal = document.getElementById('contactSelectionModal');
    if (modal) {
        modal.remove();
    }
}

// Função auxiliar para enviar mensagem buscando dados pelo ID
async function sendContactMessageById(loanId, contactId, contactType) {
    try {
        // Buscar dados do contato
        const tableName = contactType === 'guarantor' ? 'guarantors' : 'emergency_contacts';
        const { data: contact, error: contactError } = await supabase
            .from(tableName)
            .select('*')
            .eq('id', contactId)
            .single();

        if (contactError || !contact) {
            showErrorMessage('Erro ao buscar dados do contato!');
            return;
        }

        // Buscar dados do empréstimo e cliente
        const loan = loans.find(l => l.id === loanId);
        if (!loan) {
            showErrorMessage('Empréstimo não encontrado!');
            return;
        }

        const { data: client, error: clientError } = await supabase
            .from('clients')
            .select('id, name, cpf, phone')
            .eq('id', loan.client_id)
            .single();

        if (clientError || !client) {
            showErrorMessage('Erro ao buscar dados do cliente!');
            return;
        }

        // Chamar função principal de envio
        await sendGuarantorOrEmergencyMessage(loanId, client, contact, contactType);

    } catch (error) {
        console.error('Erro ao enviar mensagem:', error);
        showErrorMessage('Erro ao preparar mensagem: ' + error.message);
    }
}

// Função para enviar mensagem para avalista ou contato de emergência
async function sendGuarantorOrEmergencyMessage(loanId, client, contact, contactType) {
    // Fechar modal se estiver aberto
    closeContactSelectionModal();
    
    const loan = loans.find(l => l.id === loanId);
    if (!loan) {
        showErrorMessage('Empréstimo não encontrado!');
        return;
    }

    // Verificar se o contato tem telefone
    if (!contact.phone) {
        showErrorMessage('Este contato não possui telefone cadastrado!');
        return;
    }

    try {
        // Calcular valores atuais do empréstimo usando a mesma lógica da tabela
        const principalAmount = parseFloat(loan.amount);
        const interestRate = parseFloat(loan.interest_rate);
        
        // Buscar histórico de pagamentos
        const { data: payments, error: paymentsError } = await supabase
            .from('payments')
            .select('amount, payment_date, payment_type, fine_amount')
            .eq('loan_id', loanId)
            .order('payment_date', { ascending: true });

        if (paymentsError) throw paymentsError;

        // Calcular valor restante usando a mesma lógica da tabela
        const originalCapital = parseFloat(loan.original_amount || loan.amount);
        const originalInterest = originalCapital * (interestRate / 100);
        const originalTotal = originalCapital + originalInterest;
        
        // Separar pagamentos reais
        const realPayments = payments.filter(p => parseFloat(p.amount) > 0);
        
        // Tipos de pagamento que NÃO reduzem o capital (apenas juros)
        const interestOnlyTypes = ['renewal', 'interest_renewal', 'early_payment_partial_interest', 
                                  'early_payment_interest_renewal', 'partial_interest'];
        
        // Calcular capital pago acumulado
        let capitalPaid = 0;
        let currentCapital = originalCapital;
        
        // Processar cada pagamento em ordem
        for (const payment of realPayments) {
            const paymentAmount = parseFloat(payment.amount);
            const paymentType = payment.payment_type;
            
            // Se for pagamento apenas de juros, não reduz capital
            if (interestOnlyTypes.includes(paymentType)) {
                continue;
            }
            
            // Para outros tipos de pagamento, calcular quanto foi de capital
            const currentInterest = currentCapital * (interestRate / 100);
            
            if (paymentAmount > currentInterest) {
                // Pagou mais que os juros, a diferença reduziu o capital
                const capitalReduction = paymentAmount - currentInterest;
                capitalPaid += capitalReduction;
                currentCapital = Math.max(0, currentCapital - capitalReduction);
            }
        }
        
        // Calcular valor restante correto
        const remainingCapital = Math.max(0, originalCapital - capitalPaid);
        const remainingInterest = remainingCapital * (interestRate / 100);
        const remainingAmount = remainingCapital + remainingInterest;
        
        const totalPaid = realPayments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        
        // Calcular multa se estiver vencido
        const dueDate = new Date(loan.due_date);
        const today = new Date();
        const daysOverdue = Math.floor((today - dueDate) / (1000 * 60 * 60 * 24));
        const dailyFine = 50.00; // Multa diária de R$ 50,00
        const currentFine = daysOverdue > 0 ? daysOverdue * dailyFine : 0;

        // Formatar data de vencimento
        const formattedDueDate = formatDate(loan.due_date);
        
        // Definir texto do tipo de contato
        const contactTypeText = contactType === 'guarantor' ? 'avalista' : 'contato de emergência';
        const contactIcon = contactType === 'guarantor' ? '👥' : '🚨';

        // Montar mensagem do WhatsApp personalizada (usando valores RESTANTES, não originais)
        const message = `${contactIcon} ATENÇÃO - CONTATO SOBRE EMPRÉSTIMO

Olá, ${contact.name}!

Estamos entrando em contato com você como ${contactTypeText} do(a) cliente ${client.name}.

📋 INFORMAÇÕES DO EMPRÉSTIMO:
👤 Cliente: ${client.name}
📅 Data de Vencimento: ${formattedDueDate}
💰 Capital Restante: R$ ${remainingCapital.toFixed(2)}
📈 Juros Restantes: R$ ${remainingInterest.toFixed(2)}
💸 Valor Restante: R$ ${remainingAmount.toFixed(2)}
${daysOverdue > 0 ? `⚠️ Multa acumulada: R$ ${currentFine.toFixed(2)} (${daysOverdue} dias em atraso)` : ''}

${daysOverdue > 0 ? 
`⏰ O empréstimo está VENCIDO há ${daysOverdue} dia(s).
É fundamental que você entre em contato com o(a) ${client.name} para regularizar a situação o mais breve possível.` : 
`⏰ O empréstimo está próximo do vencimento.
Por favor, entre em contato com o(a) ${client.name} para garantir que o pagamento seja realizado até a data estabelecida.`}

⚠️ IMPORTANTE:
${contactType === 'guarantor' ? 
`Como avalista deste empréstimo, você é corresponsável pelo pagamento caso o cliente não honre o compromisso.` : 
`Como contato de emergência, pedimos sua ajuda para localizar ou alertar o(a) cliente sobre a necessidade de regularização.`}

Após o vencimento, incide uma multa diária de R$ 50,00.

📱 Por favor, entre em contato com ${client.name}${client.phone ? ` pelo telefone ${client.phone}` : ''} com urgência.

Agradecemos sua colaboração!`;

        // Limpar o número de telefone (remover caracteres especiais)
        const cleanPhone = contact.phone.replace(/\D/g, '');
        
        // Verificar se o número tem o código do país
        const phoneNumber = cleanPhone.startsWith('55') ? cleanPhone : '55' + cleanPhone;

        // Criar URL do WhatsApp
        const whatsappUrl = `https://wa.me/${phoneNumber}?text=${encodeURIComponent(message)}`;

        // Abrir WhatsApp em nova aba
        window.open(whatsappUrl, '_blank');

        // Mostrar mensagem de sucesso
        const successMsg = `Mensagem enviada para ${contact.name} (${contactTypeText}) via WhatsApp`;
        showSuccessMessage(successMsg);

    } catch (error) {
        console.error('Erro ao enviar mensagem do WhatsApp:', error);
        showErrorMessage('Erro ao preparar mensagem do WhatsApp: ' + error.message);
    }
}

// Função para enviar mensagem de cobrança de parcelamento via WhatsApp com chave PIX selecionada
async function sendInstallmentWhatsAppMessageWithPixKey(installmentId, pixKeyId, bankName, pixKey, accountHolder) {
    try {
        // Buscar dados do parcelamento com relacionamentos
        const { data: installment, error } = await supabase
            .from('installments')
            .select(`
                *,
                clients (name, phone, cpf),
                loans (amount, due_date),
                installment_payments (*)
            `)
            .eq('id', installmentId)
            .single();

        if (error) throw error;

        if (!installment) {
            showErrorMessage('Parcelamento não encontrado!');
            return;
        }

        const client = installment.clients;
        if (!client) {
            showErrorMessage('Dados do cliente não encontrados!');
            return;
        }

        // Verificar se o cliente tem telefone
        if (!client.phone) {
            showErrorMessage('Cliente não possui telefone cadastrado!');
            return;
        }

        // Calcular informações das parcelas
        const allPayments = installment.installment_payments || [];
        const paidPayments = allPayments.filter(p => p.status === 'paid');
        const pendingPayments = allPayments.filter(p => p.status === 'pending');
        
        // Encontrar próxima parcela vencida ou a vencer
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        const nextPayment = pendingPayments
            .sort((a, b) => new Date(a.due_date) - new Date(b.due_date))[0];

        if (!nextPayment) {
            showErrorMessage('Não há parcelas pendentes para este parcelamento');
            return;
        }

        // Calcular informações relevantes
        const remainingInstallments = pendingPayments.length;
        const totalRemaining = pendingPayments.reduce((sum, p) => sum + parseFloat(p.amount), 0);
        const nextDueDate = formatDate(nextPayment.due_date);
        const installmentAmount = parseFloat(nextPayment.amount);
        
        // Verificar se está vencida
        const paymentDueDate = new Date(nextPayment.due_date);
        paymentDueDate.setHours(0, 0, 0, 0);
        const isOverdue = today > paymentDueDate;
        const daysOverdue = isOverdue ? Math.floor((today - paymentDueDate) / (1000 * 60 * 60 * 24)) : 0;

        // Calcular multa se estiver vencida
        const dailyFine = 50.00;
        const currentFine = daysOverdue > 0 ? daysOverdue * dailyFine : 0;
        
        // Montar mensagem do WhatsApp com informações da chave PIX
        const message = `📢 *COBRANÇA – Grupo Creditas*
📅 *Venc.: ${nextDueDate}*

Cliente: ${client.name}  
Valor: R$ ${installmentAmount.toFixed(2).replace('.', ',')} (Parcela ${installment.total_installments - remainingInstallments + 1}/${installment.total_installments} • Multa: ${currentFine.toFixed(2).replace('.', ',')})
Total Restante: R$ ${totalRemaining.toFixed(2).replace('.', ',')}

💸 *PIX – ${bankName}*  
Titular: ${accountHolder}  
Chave: ${pixKey}

⚠ Após vencimento: multa diária R$ 50.  
Enviar comprovante (obrigatório se pago em outra titularidade).`;

        // Limpar o número de telefone (remover caracteres especiais)
        const cleanPhone = client.phone.replace(/\D/g, '');

        // Verificar se o número tem o código do país
        const phoneNumber = cleanPhone.startsWith('55') ? cleanPhone : '55' + cleanPhone;

        // Criar URL do WhatsApp
        const whatsappUrl = `https://wa.me/${phoneNumber}?text=${encodeURIComponent(message)}`;

        // Abrir WhatsApp em nova aba
        window.open(whatsappUrl, '_blank');

        // Mostrar mensagem de sucesso
        showSuccessMessage(`Cobrança de parcela enviada para ${client.name} via ${bankName}`);

        // Atualizar a tabela de parcelamentos para refletir valores atualizados
        await loadInstallments();

    } catch (error) {
        console.error('Erro ao enviar mensagem do WhatsApp:', error);
        showErrorMessage('Erro ao preparar mensagem do WhatsApp: ' + error.message);
    }
}

// Função para enviar mensagem de cobrança via WhatsApp
async function sendWhatsAppMessage(loanId) {
    try {
        // Buscar dados atualizados do empréstimo diretamente do banco
        const { data: loanData, error: loanError } = await supabase
            .from('loans')
            .select('*, clients(*)')
            .eq('id', loanId)
            .single();

        if (loanError) throw loanError;
        
        const loan = loanData;
        if (!loan) {
            showErrorMessage('Empréstimo não encontrado!');
            return;
        }

        const client = loan.clients;
        if (!client) {
            showErrorMessage('Dados do cliente não encontrados!');
            return;
        }

        // Verificar se o cliente tem telefone
        if (!client.phone) {
            showErrorMessage('Cliente não possui telefone cadastrado!');
            return;
        }

        // Calcular valores atuais do empréstimo usando a mesma lógica da tabela
        const principalAmount = parseFloat(loan.amount);
        const interestRate = parseFloat(loan.interest_rate);
        
        // Buscar histórico de pagamentos
        const { data: payments, error: paymentsError } = await supabase
            .from('payments')
            .select('amount, payment_date, payment_type, fine_amount')
            .eq('loan_id', loanId)
            .order('payment_date', { ascending: true });

        if (paymentsError) throw paymentsError;

        // Calcular valor restante usando a mesma lógica da tabela
        const originalCapital = parseFloat(loan.original_amount || loan.amount);
        const originalInterest = originalCapital * (interestRate / 100);
        const originalTotal = originalCapital + originalInterest;
        
        // Separar pagamentos reais
        const realPayments = payments.filter(p => parseFloat(p.amount) > 0);
        
        // Tipos de pagamento que NÃO reduzem o capital (apenas juros)
        const interestOnlyTypes = ['renewal', 'interest_renewal', 'early_payment_partial_interest', 
                                  'early_payment_interest_renewal', 'partial_interest'];
        
        // Calcular capital pago acumulado
        let capitalPaid = 0;
        let currentCapital = originalCapital;
        
        // Processar cada pagamento em ordem
        for (const payment of realPayments) {
            const paymentAmount = parseFloat(payment.amount);
            const paymentType = payment.payment_type;
            
            // Se for pagamento apenas de juros, não reduz capital
            if (interestOnlyTypes.includes(paymentType)) {
                continue;
            }
            
            // Para outros tipos de pagamento, calcular quanto foi de capital
            const currentInterest = currentCapital * (interestRate / 100);
            
            if (paymentAmount > currentInterest) {
                // Pagou mais que os juros, a diferença reduziu o capital
                const capitalReduction = paymentAmount - currentInterest;
                capitalPaid += capitalReduction;
                currentCapital = Math.max(0, currentCapital - capitalReduction);
            }
        }
        
        // Calcular valor restante correto
        const remainingCapital = Math.max(0, originalCapital - capitalPaid);
        const remainingInterest = remainingCapital * (interestRate / 100);
        const remainingAmount = remainingCapital + remainingInterest;
        
        const totalPaid = realPayments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        
        // Calcular multa se estiver vencido
        const dueDate = new Date(loan.due_date);
        const today = new Date();
        const daysOverdue = Math.floor((today - dueDate) / (1000 * 60 * 60 * 24));
        const dailyFine = 50.00; // Multa diária de R$ 50,00
        const currentFine = daysOverdue > 0 ? daysOverdue * dailyFine : 0;

        // Formatar data de vencimento
        const formattedDueDate = formatDate(loan.due_date);

        // Montar histórico de pagamentos para a mensagem
        let paymentHistory = '';
        
        if (realPayments.length > 0) {
            paymentHistory = '\n\n📋 *HISTÓRICO DE PAGAMENTOS:*\n';
            realPayments.forEach((payment, index) => {
                const paymentDate = formatDate(payment.payment_date);
                paymentHistory += `${index + 1}. R$ ${parseFloat(payment.amount).toFixed(2)} - ${paymentDate}\n`;
            });
            paymentHistory += `\n💰 *Total Pago:* R$ ${totalPaid.toFixed(2)}`;
        } else {
            paymentHistory = '\n\n📋 *HISTÓRICO DE PAGAMENTOS:*\nNenhum pagamento registrado ainda.';
        }

        // Montar mensagem do WhatsApp (usando valores RESTANTES, não originais)
        const message = ` VENCIMENTO: ${formattedDueDate}

  CLIENTE: ${client.name}
  Capital Restante: R$ ${remainingCapital.toFixed(2)}
  Juros Restantes: R$ ${remainingInterest.toFixed(2)}
  Valor Restante: R$ ${remainingAmount.toFixed(2)}
  Multa atual: R$ ${currentFine.toFixed(2)}
  
   ATENÇÃO!
O pagamento DEVE ser realizado SEM FALTA até a data do vencimento.
Após o vencimento, será aplicada uma multa diária de R$ 50,00.`;

        // Limpar o número de telefone (remover caracteres especiais)
        const cleanPhone = client.phone.replace(/\D/g, '');
        
        // Verificar se o número tem o código do país
        const phoneNumber = cleanPhone.startsWith('55') ? cleanPhone : '55' + cleanPhone;

        // Criar URL do WhatsApp
        const whatsappUrl = `https://wa.me/${phoneNumber}?text=${encodeURIComponent(message)}`;

        // Abrir WhatsApp em nova aba
        window.open(whatsappUrl, '_blank');

        // Mostrar mensagem de sucesso
        showSuccessMessage(`Mensagem de cobrança enviada para ${client.name} (${client.phone})`);

        // Atualizar a tabela de empréstimos para refletir valores atualizados
        await loadLoans();

    } catch (error) {
        console.error('Erro ao enviar mensagem do WhatsApp:', error);
        showErrorMessage('Erro ao preparar mensagem do WhatsApp: ' + error.message);
    }
}

// Função para enviar mensagem de cobrança de parcela via WhatsApp
async function sendInstallmentWhatsAppMessage(installmentId) {
    try {
        // Buscar dados do parcelamento com relacionamentos
        const { data: installment, error } = await supabase
            .from('installments')
            .select(`
                *,
                clients (name, phone, cpf),
                loans (amount, due_date),
                installment_payments (*)
            `)
            .eq('id', installmentId)
            .single();

        if (error) throw error;

        if (!installment) {
            showNotification('Parcelamento não encontrado!', 'error');
            return;
        }

        const client = installment.clients;
        if (!client) {
            showNotification('Dados do cliente não encontrados!', 'error');
            return;
        }

        // Verificar se o cliente tem telefone
        if (!client.phone) {
            showNotification('Cliente não possui telefone cadastrado!', 'error');
            return;
        }

        // Calcular informações das parcelas
        const allPayments = installment.installment_payments || [];
        const paidPayments = allPayments.filter(p => p.status === 'paid');
        const pendingPayments = allPayments.filter(p => p.status === 'pending');
        
        // Encontrar próxima parcela vencida ou a vencer
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        const nextPayment = pendingPayments
            .sort((a, b) => new Date(a.due_date) - new Date(b.due_date))[0];

        if (!nextPayment) {
            showNotification('Não há parcelas pendentes para este parcelamento', 'info');
            return;
        }

        // Calcular informações relevantes
        const remainingInstallments = pendingPayments.length;
        const totalRemaining = pendingPayments.reduce((sum, p) => sum + parseFloat(p.amount), 0);
        const nextDueDate = formatDate(nextPayment.due_date);
        const installmentAmount = parseFloat(nextPayment.amount);
        
        // Verificar se está vencida
        const paymentDueDate = new Date(nextPayment.due_date);
        paymentDueDate.setHours(0, 0, 0, 0);
        const isOverdue = today > paymentDueDate;
        const daysOverdue = isOverdue ? Math.floor((today - paymentDueDate) / (1000 * 60 * 60 * 24)) : 0;

        // Montar mensagem do WhatsApp
        let message = `📋 *PARCELAMENTO* - ${client.name}

💰 *Valor da Parcela:* R$ ${installmentAmount.toFixed(2)}
📅 *Vencimento:* ${nextDueDate}
📊 *Parcelas Restantes:* ${remainingInstallments} de ${installment.total_installments}
💵 *Valor Total Restante:* R$ ${totalRemaining.toFixed(2)}`;

        if (isOverdue) {
            message += `\n\n⚠️ *ATENÇÃO - PARCELA VENCIDA*
🚨 Venceu há ${daysOverdue} dia${daysOverdue > 1 ? 's' : ''}
📞 Entre em contato conosco para regularizar sua situação`;
        } else {
            message += `\n\n✅ Parcela ainda dentro do prazo
📞 Entre em contato para efetuar o pagamento`;
        }

        message += `\n\n💳 *Formas de pagamento disponíveis:*
• PIX
• Dinheiro

📱 *Nexus Gestão Financeira*`;

        // Limpar o número de telefone (remover caracteres especiais)
        const cleanPhone = client.phone.replace(/\D/g, '');

        // Verificar se o número tem o código do país
        const phoneNumber = cleanPhone.startsWith('55') ? cleanPhone : '55' + cleanPhone;

        // Criar URL do WhatsApp
        const whatsappUrl = `https://wa.me/${phoneNumber}?text=${encodeURIComponent(message)}`;

        // Abrir WhatsApp em nova aba
        window.open(whatsappUrl, '_blank');

        // Mostrar mensagem de sucesso
        showNotification(`Mensagem de cobrança da parcela enviada para ${client.name} (${client.phone})`, 'success');

        // Atualizar a tabela de parcelamentos para refletir valores atualizados
        await loadInstallments();

    } catch (error) {
        console.error('Erro ao enviar mensagem do WhatsApp do parcelamento:', error);
        showNotification('Erro ao preparar mensagem do WhatsApp: ' + error.message, 'error');
    }
}

async function loadPaymentHistory(loanId) {
    try {
        const { data, error } = await supabase
            .from('payments')
            .select('*')
            .eq('loan_id', loanId)
            .order('payment_date', { ascending: false });
        
        if (error) throw error;
        
        const tbody = document.getElementById('paymentHistoryTableBody');
        tbody.innerHTML = ''; // Limpar tabela antes de renderizar
        
        if (data.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="6" class="px-6 py-8 text-center text-gray-400">
                        Nenhum pagamento registrado para este empréstimo.
                    </td>
                </tr>
            `;
            updatePaymentHistorySummary(loanId, []);
            return;
        }
        
        // Renderizar pagamentos
        data.forEach(payment => {
            const paymentDate = new Date(payment.payment_date);
            const paymentAmount = parseFloat(payment.amount);
            const fineAmount = parseFloat(payment.fine_amount) || 0;
            const paymentType = getPaymentTypeText(payment.payment_type);
            const paymentNotes = payment.notes || 'Sem notas';
            
            tbody.innerHTML += `
                <tr class="table-row">
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(payment.payment_date)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">R$ ${paymentAmount.toFixed(2)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm ${fineAmount > 0 ? 'text-red-400 font-semibold' : 'text-gray-500'}">
                        ${fineAmount > 0 ? 'R$ ' + fineAmount.toFixed(2) : '-'}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${paymentType}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${paymentNotes}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <button class="text-green-400 hover:text-green-300 mr-3" onclick="generatePaymentReceipt('${payment.id}', '${loanId}')" title="Gerar comprovante via WhatsApp">📄</button>
                        <button class="text-red-400 hover:text-red-300" onclick="deletePayment('${payment.id}')">🗑️</button>
                    </td>
                </tr>
            `;
        });
        
        // Atualizar resumo financeiro
        updatePaymentHistorySummary(loanId, data);
        
    } catch (error) {
        console.error('Erro ao carregar histórico de pagamentos:', error);
    }
}

function updatePaymentHistorySummary(loanId, payments) {
    const loan = loans.find(l => l.id === loanId);
    if (!loan) return;
    
    const originalAmount = parseFloat(loan.original_amount || loan.amount);
    const interestRate = parseFloat(loan.interest_rate);
    const originalInterest = originalAmount * (interestRate / 100);
    const originalTotal = originalAmount + originalInterest;
    const totalPaid = payments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
    
    // Calcular valor restante considerando tipos de pagamento
    let remainingAmount;
    
    // Tipos de pagamento que NÃO reduzem o capital (apenas juros)
    const interestOnlyTypes = ['renewal', 'interest_renewal', 'early_payment_partial_interest', 
                              'early_payment_interest_renewal', 'partial_interest'];
    
    // Calcular capital pago acumulado
    let capitalPaid = 0;
    let currentCapital = originalAmount;
    
    // Processar cada pagamento em ordem
    for (const payment of payments) {
        const paymentAmount = parseFloat(payment.amount);
        const paymentType = payment.payment_type;
        
        // Se for pagamento apenas de juros, não reduz capital
        if (interestOnlyTypes.includes(paymentType)) {
            continue;
        }
        
        // Para outros tipos de pagamento, calcular quanto foi de capital
        const currentInterest = currentCapital * (interestRate / 100);
        
        if (paymentAmount > currentInterest) {
            // Pagou mais que os juros, a diferença reduziu o capital
            const capitalReduction = paymentAmount - currentInterest;
            capitalPaid += capitalReduction;
            currentCapital = Math.max(0, currentCapital - capitalReduction);
        }
    }
    
    // Calcular capital e juros restantes
    const remainingCapital = Math.max(0, originalAmount - capitalPaid);
    const remainingInterest = remainingCapital * (interestRate / 100);
    remainingAmount = remainingCapital + remainingInterest;
    
    document.getElementById('paymentHistoryTotalPaid').textContent = `R$ ${totalPaid.toFixed(2)}`;
    document.getElementById('paymentHistoryRemainingAmount').textContent = `R$ ${remainingAmount.toFixed(2)}`;
    document.getElementById('paymentHistoryTotalWithInterest').textContent = `R$ ${originalTotal.toFixed(2)}`;
}

function getPaymentTypeText(type) {
    switch (type) {
        case 'dinheiro': return 'Dinheiro';
        case 'pix': return 'Pix';
        case 'cartao': return 'Cartão';
        case 'partial': return 'Parcial';
        case 'full': return 'Total';
        case 'interest': return 'Apenas Juros';
        case 'principal': return 'Apenas Principal';
        case 'adjustment': return 'Ajuste/Recálculo';
        case 'renewal': return '🔄 Renovação';
        case 'interest_renewal': return '🔄 Renovação +30 Dias (Somente Juros)';
        case 'capital_interest_renewal': return '💰 Renovação +30 Dias (Capital + Juros)';
        case 'capital_renewal': return '🏦 Renovação +30 Dias (Somente Capital)';
        case 'loan_renewal': return '📅 Renovação de Prazo';
        case 'capital_payment': return '💰 Pagamento Capital';
        case 'partial_interest': return '⚠️ Juros Parcial';
        case 'early_payment_partial_interest': return '⚡ Pagamento Antecipado (Juros Parcial)';
        case 'early_payment_interest_renewal': return '⚡ Renovação Antecipada (Juros)';
        case 'early_payment_capital_reduction': return '⚡ Pagamento Antecipado (Redução Capital)';
        case 'loan_reactivation': return '🔓 Reativação de Empréstimo';
        case 'loan_payoff': return '✅ Quitação Total';
        default: return type;
    }
}

async function editPayment(paymentId) {
    try {
        // Buscar o pagamento do banco de dados
        const { data: payment, error } = await supabase
            .from('payments')
            .select('*')
            .eq('id', paymentId)
            .single();
        
        if (error) throw error;
        if (!payment) {
            alert('Pagamento não encontrado!');
            return;
        }

        const paymentForm = document.getElementById('paymentForm');
        if (!paymentForm) return;

        // Definir o ID do pagamento no dataset para indicar que é uma edição
        paymentForm.dataset.paymentId = paymentId;
        paymentForm.dataset.loanId = payment.loan_id;

        // Preencher o formulário com os dados do pagamento
        document.getElementById('paymentAmount').value = payment.amount;
        document.getElementById('paymentDate').value = payment.payment_date;
        document.getElementById('paymentType').value = payment.payment_type;
        document.getElementById('paymentNotes').value = payment.notes || '';
        
        // Preencher campo de multa se existir
        const fineAmount = payment.fine_amount || 0;
        if (fineAmount > 0) {
            document.getElementById('includeFineCheckbox').checked = true;
            document.getElementById('fineContainer').classList.remove('hidden');
            document.getElementById('fineAmount').value = fineAmount;
        } else {
            document.getElementById('includeFineCheckbox').checked = false;
            document.getElementById('fineContainer').classList.add('hidden');
            document.getElementById('fineAmount').value = '';
        }

        // Mostrar o modal de pagamento
        showModal(paymentModal);
        
    } catch (error) {
        console.error('Erro ao carregar pagamento para edição:', error);
        alert('Erro ao carregar dados do pagamento: ' + error.message);
    }
}

async function deletePayment(paymentId) {
    try {
        // Buscar o pagamento do banco de dados
        const { data: payment, error } = await supabase
            .from('payments')
            .select('*')
            .eq('id', paymentId)
            .single();
        
        if (error) throw error;
        if (!payment) {
            alert('Pagamento não encontrado!');
            return;
        }

        showConfirmationModal(
            'Excluir Pagamento',
            `Tem certeza que deseja excluir o pagamento de R$ ${parseFloat(payment.amount).toFixed(2)} registrado em ${formatDate(payment.payment_date)}? Esta ação não pode ser desfeita.`,
            () => performDeletePayment(paymentId),
            'Excluir'
        );
        
    } catch (error) {
        console.error('Erro ao carregar pagamento para exclusão:', error);
        alert('Erro ao carregar dados do pagamento: ' + error.message);
    }
}

async function performDeletePayment(paymentId) {
    try {
        const { error } = await supabase
            .from('payments')
            .delete()
            .eq('id', paymentId);
        
        if (error) throw error;
        
        hideModal(document.getElementById('confirmationModal'));
        
        // Recarregar dados principais
        invalidateLoanRemainingAmountsCache();
        await loadLoans();
        await updateDashboard();
        
        // Recarregar histórico de pagamentos
        const loanId = document.getElementById('paymentHistoryLoanId').value;
        if (loanId) {
            await loadPaymentHistory(loanId);
        }
        
        // Mostrar mensagem de sucesso
        showSuccessMessage('Pagamento excluído com sucesso! Valores atualizados.');
        
    } catch (error) {
        console.error('Erro ao excluir pagamento:', error);
        alert('Erro ao excluir pagamento: ' + error.message);
    }
}

// Função para gerar comprovante de pagamento e enviar via WhatsApp
async function generatePaymentReceipt(paymentId, loanId) {
    try {
        // Buscar dados do pagamento
        const { data: payment, error: paymentError } = await supabase
            .from('payments')
            .select('*')
            .eq('id', paymentId)
            .single();
        
        if (paymentError) throw paymentError;
        if (!payment) {
            alert('Pagamento não encontrado!');
            return;
        }

        // Buscar dados do empréstimo com informações do cliente
        const { data: loan, error: loanError } = await supabase
            .from('loans')
            .select(`
                *,
                clients (
                    name,
                    cpf,
                    phone
                )
            `)
            .eq('id', loanId)
            .single();
        
        if (loanError) throw loanError;
        if (!loan) {
            alert('Empréstimo não encontrado!');
            return;
        }

        // Buscar todos os pagamentos do empréstimo para calcular totais
        const { data: allPayments, error: allPaymentsError } = await supabase
            .from('payments')
            .select('*')
            .eq('loan_id', loanId)
            .order('payment_date', { ascending: true });
        
        if (allPaymentsError) throw allPaymentsError;

        // Calcular valores usando a mesma lógica da tabela
        const loanAmount = parseFloat(loan.amount);
        const interestRate = parseFloat(loan.interest_rate);
        
        const originalCapital = parseFloat(loan.original_amount || loan.amount);
        const originalInterest = originalCapital * (interestRate / 100);
        const totalWithInterest = originalCapital + originalInterest;
        
        // Separar pagamentos reais
        const realPayments = allPayments.filter(p => parseFloat(p.amount) > 0);
        
        // Tipos de pagamento que NÃO reduzem o capital (apenas juros)
        const interestOnlyTypes = ['renewal', 'interest_renewal', 'early_payment_partial_interest', 
                                  'early_payment_interest_renewal', 'partial_interest'];
        
        // Calcular capital pago acumulado
        let capitalPaid = 0;
        let currentCapital = originalCapital;
        
        // Processar cada pagamento em ordem
        for (const pmt of realPayments) {
            const pAmount = parseFloat(pmt.amount);
            const pType = pmt.payment_type;
            
            // Se for pagamento apenas de juros, não reduz capital
            if (interestOnlyTypes.includes(pType)) {
                continue;
            }
            
            // Para outros tipos de pagamento, calcular quanto foi de capital
            const currentInterest = currentCapital * (interestRate / 100);
            
            if (pAmount > currentInterest) {
                // Pagou mais que os juros, a diferença reduziu o capital
                const capitalReduction = pAmount - currentInterest;
                capitalPaid += capitalReduction;
                currentCapital = Math.max(0, currentCapital - capitalReduction);
            }
        }
        
        // Calcular valor restante correto
        const remainingCapital = Math.max(0, originalCapital - capitalPaid);
        const remainingInterest = remainingCapital * (interestRate / 100);
        const remainingAmount = remainingCapital + remainingInterest;
        
        const totalPaid = realPayments.reduce((sum, p) => sum + parseFloat(p.amount), 0);
        const paymentAmount = parseFloat(payment.amount);

        // Calcular próxima data de vencimento (30 dias a partir de hoje)
        const today = new Date();
        const nextDueDate = new Date(today);
        nextDueDate.setDate(today.getDate() + 30); // 30 dias a partir de hoje
        
        // Converter para string no formato correto
        const nextDueDateString = formatDateForInput(nextDueDate);

        // Formatar dados do cliente
        const clientName = loan.clients?.name || 'Cliente não encontrado';
        const clientCPF = loan.clients?.cpf || 'CPF não informado';
        const clientPhone = loan.clients?.phone || '';

        // Gerar mensagem do comprovante
        const receiptMessage = `🧾 *COMPROVANTE DE PAGAMENTO*
━━━━━━━━━━━━━━━━━━━━━━━━━━━

👤 *Cliente:* ${clientName}
📋 *CPF:* ${clientCPF}
📅 *Data do Pagamento:* ${formatDate(payment.payment_date)}

💰 *VALORES:*
• Valor Total do Empréstimo: R$ ${totalWithInterest.toFixed(2)}
• Valor Restante: R$ ${remainingAmount.toFixed(2)}

━━━━━━━━━━━━━━━━━━━━━━━━━━━
Obrigado pela confiança! 💙`;

        // Abrir WhatsApp com a mensagem
        if (clientPhone) {
            const phoneNumber = clientPhone.replace(/\D/g, ''); // Remove caracteres não numéricos
            const whatsappUrl = `https://wa.me/55${phoneNumber}?text=${encodeURIComponent(receiptMessage)}`;
            window.open(whatsappUrl, '_blank');
        } else {
            // Se não tiver telefone, copiar mensagem para clipboard
            navigator.clipboard.writeText(receiptMessage).then(() => {
                alert('Comprovante copiado para área de transferência!\n\nO cliente não possui telefone cadastrado. Cole a mensagem no WhatsApp manualmente.');
            }).catch(() => {
                // Fallback: mostrar mensagem em um modal
                alert('Comprovante gerado:\n\n' + receiptMessage);
            });
        }

        showSuccessMessage('Comprovante gerado com sucesso!');
        
    } catch (error) {
        console.error('Erro ao gerar comprovante:', error);
        alert('Erro ao gerar comprovante: ' + error.message);
    }
}

// Cache para valores restantes dos empréstimos
let loanRemainingAmountsCache = {};
let lastCacheUpdate = 0;
const LOAN_AMOUNTS_CACHE_DURATION = 30000; // 30 segundos

// Função para invalidar cache de valores restantes
function invalidateLoanRemainingAmountsCache() {
    loanRemainingAmountsCache = {};
    lastCacheUpdate = 0;
    console.log('Cache de valores restantes invalidado');
}

// Função otimizada para calcular valores restantes de múltiplos empréstimos em lote
async function calculateBatchLoanRemainingAmounts(loanIds) {
    if (!loanIds || loanIds.length === 0) return [];
    
    // Verificar se o cache é válido
    const now = Date.now();
    const cacheIsValid = (now - lastCacheUpdate) < LOAN_AMOUNTS_CACHE_DURATION;
    
    // Se o cache é válido e contém todos os loan IDs necessários, usar o cache
    if (cacheIsValid && loanIds.every(id => loanRemainingAmountsCache.hasOwnProperty(id))) {
        console.log('Usando cache para valores restantes dos empréstimos');
        return loanIds.map(id => loanRemainingAmountsCache[id] || 0);
    }
    
    try {
        // Buscar todos os pagamentos de uma vez
        const { data: allPayments, error: paymentsError } = await supabase
            .from('payments')
            .select('loan_id, amount, payment_type, fine_amount')
            .in('loan_id', loanIds);
        
        if (paymentsError) throw paymentsError;
        
        // Organizar pagamentos por loan_id
        const paymentsByLoan = {};
        allPayments.forEach(payment => {
            if (!paymentsByLoan[payment.loan_id]) {
                paymentsByLoan[payment.loan_id] = [];
            }
            paymentsByLoan[payment.loan_id].push(payment);
        });
        
        // Calcular valor restante para cada empréstimo
        const remainingAmounts = [];
        
        for (const loanId of loanIds) {
            const loan = loans.find(l => l.id === loanId);
            if (!loan) {
                remainingAmounts.push(0);
                continue;
            }
            
            // SEMPRE usar o valor original (nunca o valor alterado)
            const originalCapital = parseFloat(loan.original_amount || loan.amount);
            let interestRate = parseFloat(loan.interest_rate);
            
            // Ajustar taxa se necessário
            if (interestRate > 100) {
                interestRate = interestRate / 100;
            }
            
            const originalInterest = originalCapital * (interestRate / 100);
            const originalTotal = originalCapital + originalInterest;
            
            const payments = paymentsByLoan[loanId] || [];
            
            // Separar pagamentos reais de ajustes
            const realPayments = payments.filter(p => parseFloat(p.amount) > 0);
            
            // Calcular total pago (todos os pagamentos reais)
            const totalPaid = realPayments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
            
            // Calcular valor restante baseado no valor original
            let remaining;
            if (totalPaid === 0) {
                remaining = originalTotal;
            } else {
                // Calcular quanto foi pago de capital
                // Tipos de pagamento que NÃO reduzem o capital (apenas juros)
                const interestOnlyTypes = ['renewal', 'interest_renewal', 'early_payment_partial_interest', 
                                          'early_payment_interest_renewal', 'partial_interest'];
                
                // Calcular capital pago acumulado
                let capitalPaid = 0;
                let currentCapital = originalCapital;
                
                // Processar cada pagamento em ordem
                for (const payment of realPayments) {
                    const paymentAmount = parseFloat(payment.amount);
                    const paymentType = payment.payment_type;
                    
                    // Se for pagamento apenas de juros, não reduz capital
                    if (interestOnlyTypes.includes(paymentType)) {
                        // Capital permanece o mesmo
                        continue;
                    }
                    
                    // Para outros tipos de pagamento, calcular quanto foi de capital
                    // Juros atuais baseados no capital atual
                    const currentInterest = currentCapital * (interestRate / 100);
                    
                    if (paymentAmount > currentInterest) {
                        // Pagou mais que os juros, a diferença reduziu o capital
                        const capitalReduction = paymentAmount - currentInterest;
                        capitalPaid += capitalReduction;
                        currentCapital = Math.max(0, currentCapital - capitalReduction);
                    }
                    // Se pagou menos ou igual aos juros, não reduziu capital
                }
                
                // Calcular capital restante
                const remainingCapital = Math.max(0, originalCapital - capitalPaid);
                
                // Calcular juros restantes baseado no capital restante
                const remainingInterest = remainingCapital * (interestRate / 100);
                
                // Valor total restante
                remaining = remainingCapital + remainingInterest;
            }
            remainingAmounts.push(remaining);
            
            // Atualizar cache
            loanRemainingAmountsCache[loanId] = remaining;
        }
        
        // Atualizar timestamp do cache
        lastCacheUpdate = now;
        console.log(`Calculados valores restantes para ${loanIds.length} empréstimos`);
        
        return remainingAmounts;
        
    } catch (error) {
        console.error('Erro ao calcular valores restantes em lote:', error);
        // Fallback: retornar array com valores zero
        return new Array(loanIds.length).fill(0);
    }
}

// Função para calcular valor restante de um empréstimo
async function calculateLoanRemainingAmount(loanId) {
    try {
        const loan = loans.find(l => l.id === loanId);
        if (!loan) return 0;
        
        // SEMPRE usar o valor original (nunca o valor alterado)
        const originalCapital = parseFloat(loan.original_amount || loan.amount);
        let interestRate = parseFloat(loan.interest_rate);
        
        // Ajustar taxa se necessário
        if (interestRate > 100) {
            interestRate = interestRate / 100;
        }
        
        const originalInterest = originalCapital * (interestRate / 100);
        const originalTotal = originalCapital + originalInterest;
        
        // Buscar pagamentos já feitos
        const { data: payments, error } = await supabase
            .from('payments')
            .select('amount, payment_type, fine_amount')
            .eq('loan_id', loanId);
        
        if (error) throw error;
        
        // Separar pagamentos reais (com valor > 0)
        const realPayments = payments.filter(p => parseFloat(p.amount) > 0);
        
        // Calcular total pago (todos os pagamentos reais)
        const totalPaid = realPayments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        
        // Calcular valor restante baseado no valor original (NUNCA alterado)
        let remainingAmount;
        
        if (totalPaid === 0) {
            // Nenhum pagamento feito
            remainingAmount = originalTotal;
        } else {
            // Calcular quanto foi pago de capital
            // Tipos de pagamento que NÃO reduzem o capital (apenas juros)
            const interestOnlyTypes = ['renewal', 'interest_renewal', 'early_payment_partial_interest', 
                                      'early_payment_interest_renewal', 'partial_interest'];
            
            // Calcular capital pago acumulado
            let capitalPaid = 0;
            let currentCapital = originalCapital;
            
            // Processar cada pagamento em ordem
            for (const payment of realPayments) {
                const paymentAmount = parseFloat(payment.amount);
                const paymentType = payment.payment_type;
                
                // Se for pagamento apenas de juros, não reduz capital
                if (interestOnlyTypes.includes(paymentType)) {
                    // Capital permanece o mesmo
                    continue;
                }
                
                // Para outros tipos de pagamento, calcular quanto foi de capital
                // Juros atuais baseados no capital atual
                const currentInterest = currentCapital * (interestRate / 100);
                
                if (paymentAmount > currentInterest) {
                    // Pagou mais que os juros, a diferença reduziu o capital
                    const capitalReduction = paymentAmount - currentInterest;
                    capitalPaid += capitalReduction;
                    currentCapital = Math.max(0, currentCapital - capitalReduction);
                }
                // Se pagou menos ou igual aos juros, não reduziu capital
            }
            
            // Calcular capital restante
            const remainingCapital = Math.max(0, originalCapital - capitalPaid);
            
            // Calcular juros restantes baseado no capital restante
            const remainingInterest = remainingCapital * (interestRate / 100);
            
            // Valor total restante
            remainingAmount = remainingCapital + remainingInterest;
        }
        
        return Math.max(0, remainingAmount);
        
    } catch (error) {
        console.error('Erro ao calcular valor restante:', error);
        // Em caso de erro, retornar valor total com juros
        const loan = loans.find(l => l.id === loanId);
        if (loan) {
            const capitalAmount = parseFloat(loan.amount);
            let interestRate = parseFloat(loan.interest_rate);
            if (interestRate > 100) {
                interestRate = interestRate / 100;
            }
            return capitalAmount + (capitalAmount * (interestRate / 100));
        }
        return 0;
    }
}

// Funções auxiliares para edição e exclusão
async function performDeleteClient(clientId) {
    try {
        const { error } = await supabase
            .from('clients')
            .delete()
            .eq('id', clientId);
        
        if (error) throw error;
        
        hideModal(document.getElementById('confirmationModal'));
        
        // Recarregar dados
        await loadClients(true); // Forçar reload para invalidar cache
        await updateDashboard();
        
        // Mostrar mensagem de sucesso
        showSuccessMessage('Cliente excluído com sucesso!');
        
    } catch (error) {
        console.error('Erro ao excluir cliente:', error);
        alert('Erro ao excluir cliente: ' + error.message);
    }
}

async function performDeleteLoan(loanId) {
    try {
        const { error } = await supabase
            .from('loans')
            .delete()
            .eq('id', loanId);
        
        if (error) throw error;
        
        hideModal(document.getElementById('confirmationModal'));
        
        // Recarregar dados
        invalidateLoanRemainingAmountsCache();
        await loadLoans();
        await updateDashboard();
        
        // Mostrar mensagem de sucesso
        showSuccessMessage('Empréstimo excluído com sucesso!');
        
    } catch (error) {
        console.error('Erro ao excluir empréstimo:', error);
        alert('Erro ao excluir empréstimo: ' + error.message);
    }
}

// ====== FUNÇÕES DE DOCUMENTOS DO CLIENTE ======

// Variáveis globais para documentos
let currentClientId = null;
let clientDocuments = [];

// Abrir modal de documentos do cliente
function openClientDocuments(clientId, clientName) {
    currentClientId = clientId;
    document.getElementById('clientDocumentsName').textContent = clientName;
    
    // Limpar formulário
    document.getElementById('uploadDocumentForm').reset();
    
    // Carregar documentos do cliente
    loadClientDocuments(clientId);
    
    // Mostrar modal
    showModal(document.getElementById('clientDocumentsModal'));
}

// Carregar documentos do cliente
async function loadClientDocuments(clientId) {
    console.log(`🔄 Carregando documentos para cliente: ${clientId}`);
    
    try {
        if (!clientId) {
            throw new Error('ID do cliente não fornecido');
        }
        
        const { data, error } = await supabase
            .from('client_documents')
            .select('*')
            .eq('client_id', clientId)
            .order('created_at', { ascending: false });
        
        if (error) {
            console.error('❌ Erro do Supabase ao carregar documentos:', error);
            throw error;
        }
        
        console.log(`✅ Documentos carregados: ${data?.length || 0} encontrados`);
        
        clientDocuments = data || [];
        renderClientDocuments();
        
    } catch (error) {
        console.error('❌ Erro ao carregar documentos:', error);
        
        // Mostrar erro específico se for problema de tabela
        if (error.message.includes('relation "client_documents" does not exist')) {
            alert('Erro: Tabela de documentos não existe. Execute o script setup-client-documents-table.sql');
        } else if (error.message.includes('permission')) {
            alert('Erro: Sem permissão para acessar documentos. Verifique as políticas RLS.');
        }
        
        clientDocuments = [];
        renderClientDocuments();
    }
}

// Renderizar lista de documentos
function renderClientDocuments() {
    const container = document.getElementById('documentsContainer');
    const filter = document.getElementById('documentFilter').value;
    const counter = document.getElementById('documentCounter');
    const uploadForm = document.getElementById('uploadDocumentForm');
    const submitBtn = uploadForm.querySelector('button[type="submit"]');
    
    // Atualizar contador
    counter.textContent = `${clientDocuments.length}/15 documentos`;
    
    // Desabilitar formulário se atingir limite
    if (clientDocuments.length >= 15) {
        counter.classList.add('text-red-400');
        counter.classList.remove('text-gray-400');
        submitBtn.disabled = true;
        submitBtn.textContent = 'Limite de 15 documentos atingido';
        submitBtn.classList.add('opacity-50', 'cursor-not-allowed');
    } else {
        counter.classList.remove('text-red-400');
        counter.classList.add('text-gray-400');
        submitBtn.disabled = false;
        submitBtn.textContent = 'Fazer Upload';
        submitBtn.classList.remove('opacity-50', 'cursor-not-allowed');
    }
    
    // Filtrar documentos se necessário
    const filteredDocs = filter ? 
        clientDocuments.filter(doc => doc.category === filter) : 
        clientDocuments;
    
    if (filteredDocs.length === 0) {
        container.innerHTML = `
            <div class="text-center py-8 text-gray-400">
                ${filter ? 'Nenhum documento encontrado nesta categoria' : 'Nenhum documento encontrado'}
            </div>
        `;
        return;
    }
    
    container.innerHTML = filteredDocs.map(doc => {
        const categoryNames = {
            'identificacao': 'Identificação',
            'comprovante_renda': 'Comprovante de Renda',
            'comprovante_residencia': 'Comprovante de Residência',
            'referencias': 'Referências',
            'outros': 'Outros'
        };
        
        const isImage = doc.file_type && doc.file_type.startsWith('image/');
        const isPDF = doc.file_type === 'application/pdf';
        
        return `
            <div class="bg-gray-800 rounded-lg p-4 border border-gray-700">
                <div class="flex items-start justify-between">
                    <div class="flex-1">
                        <div class="flex items-center space-x-3 mb-2">
                            <div class="flex-shrink-0">
                                ${isImage ? '🖼️' : isPDF ? '📄' : '📎'}
                            </div>
                            <div>
                                <h5 class="text-white font-medium">${doc.name}</h5>
                                <p class="text-sm text-gray-400">${categoryNames[doc.category] || doc.category}</p>
                            </div>
                        </div>
                        
                        ${doc.notes ? `<p class="text-sm text-gray-300 mb-2">${doc.notes}</p>` : ''}
                        
                        <div class="text-xs text-gray-500">
                            Enviado em: ${new Date(doc.created_at).toLocaleDateString('pt-BR')} às ${new Date(doc.created_at).toLocaleTimeString('pt-BR')}
                        </div>
                    </div>
                    
                    <div class="flex space-x-2 ml-4">
                        <button onclick="viewDocument('${doc.id}')" 
                                class="text-blue-400 hover:text-blue-300 px-3 py-1 rounded text-sm"
                                title="Visualizar">
                            👁️ Ver
                        </button>
                        <button onclick="downloadDocument('${doc.id}')" 
                                class="text-green-400 hover:text-green-300 px-3 py-1 rounded text-sm"
                                title="Baixar">
                            ⬇️ Baixar
                        </button>
                        <button onclick="deleteDocument('${doc.id}')" 
                                class="text-red-400 hover:text-red-300 px-3 py-1 rounded text-sm"
                                title="Excluir">
                            🗑️
                        </button>
                    </div>
                </div>
            </div>
        `;
    }).join('');
}

// Fazer upload de documento
async function handleDocumentUpload(e) {
    e.preventDefault();
    
    console.log('🔄 Iniciando upload de documento...');
    
    // Capturar dados do formulário
    const name = document.getElementById('documentName').value.trim();
    const category = document.getElementById('documentCategory').value;
    const file = document.getElementById('documentFile').files[0];
    const notes = document.getElementById('documentNotes').value.trim();
    
    // Validações básicas
    if (!name) {
        alert('Por favor, informe o nome do documento');
        return;
    }
    
    if (!category) {
        alert('Por favor, selecione uma categoria');
        return;
    }
    
    if (!file) {
        alert('Por favor, selecione um arquivo');
        return;
    }
    
    if (!currentClientId) {
        alert('Erro: Cliente não identificado. Feche e abra novamente o modal.');
        return;
    }
    
    // Verificar limite de 15 documentos
    if (clientDocuments.length >= 15) {
        alert('Limite máximo de 15 documentos por cliente atingido');
        return;
    }
    
    // Validar tamanho do arquivo (10MB)
    if (file.size > 10 * 1024 * 1024) {
        alert('O arquivo deve ter no máximo 10MB');
        return;
    }
    
    // Validar tipo de arquivo
    const allowedTypes = ['application/pdf', 'image/jpeg', 'image/jpg', 'image/png', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
    if (!allowedTypes.includes(file.type)) {
        alert('Tipo de arquivo não permitido. Use: PDF, JPG, PNG, DOC ou DOCX');
        return;
    }
    
    console.log(`📋 Dados do upload:`, {
        clientId: currentClientId,
        name: name,
        category: category,
        fileType: file.type,
        fileSize: file.size,
        fileName: file.name
    });
    
    try {
        // Mostrar loading
        const submitBtn = e.target.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        submitBtn.textContent = 'Enviando...';
        submitBtn.disabled = true;
        
        console.log('📤 Iniciando upload para Uploadcare...');
        
        // Upload do arquivo para o Uploadcare
        const formData = new FormData();
        formData.append('UPLOADCARE_PUB_KEY', '5bb6bf6b98f6d36060dc');
        formData.append('file', file);
        
        const uploadResponse = await fetch('https://upload.uploadcare.com/base/', {
            method: 'POST',
            body: formData
        });
        
        if (!uploadResponse.ok) {
            const errorText = await uploadResponse.text();
            console.error('❌ Erro no Uploadcare:', errorText);
            throw new Error(`Erro no upload para Uploadcare: ${uploadResponse.status} - ${errorText}`);
        }
        
        const uploadResult = await uploadResponse.json();
        console.log('✅ Upload Uploadcare concluído:', uploadResult);
        
        if (!uploadResult.file) {
            throw new Error('Resposta inválida do Uploadcare: arquivo não encontrado');
        }
        
        const fileUrl = `https://ucarecdn.com/${uploadResult.file}/`;
        console.log(`🔗 URL do arquivo: ${fileUrl}`);
        
        console.log('💾 Salvando no banco de dados...');
        
        // Salvar informações do documento no banco
        const documentData = {
            client_id: currentClientId,
            name: name,
            category: category,
            file_path: fileUrl,
            file_type: file.type,
            file_size: file.size,
            notes: notes || null
        };
        
        console.log('📊 Dados para inserção:', documentData);
        
        const { data, error } = await supabase
            .from('client_documents')
            .insert([documentData])
            .select();
        
        if (error) {
            console.error('❌ Erro do Supabase:', error);
            throw new Error(`Erro ao salvar no banco: ${error.message}`);
        }
        
        console.log('✅ Documento salvo no banco:', data);
        
        // Limpar formulário
        document.getElementById('uploadDocumentForm').reset();
        
        // Recarregar documentos
        console.log('🔄 Recarregando lista de documentos...');
        await loadClientDocuments(currentClientId);
        
        showSuccessMessage('Documento enviado com sucesso!');
        console.log('🎉 Upload concluído com sucesso!');
        
    } catch (error) {
        console.error('❌ Erro completo no upload:', error);
        
        // Mensagem de erro mais específica
        let errorMessage = 'Erro desconhecido ao fazer upload';
        
        if (error.message.includes('Uploadcare')) {
            errorMessage = 'Erro no serviço de upload de arquivos. Tente novamente.';
        } else if (error.message.includes('banco')) {
            errorMessage = 'Erro ao salvar informações no banco de dados.';
        } else if (error.message.includes('network') || error.message.includes('fetch')) {
            errorMessage = 'Erro de conexão. Verifique sua internet e tente novamente.';
        } else {
            errorMessage = error.message;
        }
        
        alert(`Erro ao fazer upload do documento: ${errorMessage}`);
        
    } finally {
        // Restaurar botão
        const submitBtn = e.target.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.textContent = originalText || 'Fazer Upload';
            submitBtn.disabled = false;
        }
    }
}

// Visualizar documento
async function viewDocument(documentId) {
    try {
        const doc = clientDocuments.find(d => d.id === documentId);
        if (!doc) return;
        
        // Abrir documento do Uploadcare em nova aba
        window.open(doc.file_path, '_blank');
        
    } catch (error) {
        console.error('Erro ao visualizar documento:', error);
        alert('Erro ao visualizar documento: ' + error.message);
    }
}

// Baixar documento
async function downloadDocument(documentId) {
    try {
        const doc = clientDocuments.find(d => d.id === documentId);
        if (!doc) return;
        
        // Baixar arquivo do Uploadcare
        const response = await fetch(doc.file_path);
        const blob = await response.blob();
        
        // Criar link para download
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = doc.name + '.' + doc.file_path.split('.').pop();
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        
    } catch (error) {
        console.error('Erro ao baixar documento:', error);
        alert('Erro ao baixar documento: ' + error.message);
    }
}

// Excluir documento
async function deleteDocument(documentId) {
    if (!confirm('Tem certeza que deseja excluir este documento?')) return;
    
    try {
        // Excluir registro do banco
        const { error } = await supabase
            .from('client_documents')
            .delete()
            .eq('id', documentId);
        
        if (error) throw error;
        
        // Recarregar documentos
        await loadClientDocuments(currentClientId);
        
        showSuccessMessage('Documento excluído com sucesso!');
        
    } catch (error) {
        console.error('Erro ao excluir documento:', error);
        alert('Erro ao excluir documento: ' + error.message);
    }
}

function populateEditLoanClientSelect(selectedClientId) {
    const select = document.getElementById('editLoanClient');
    select.innerHTML = '<option value="">Ou selecione da lista completa</option>';
    
    clients.forEach(client => {
        const option = document.createElement('option');
        option.value = client.id;
        option.textContent = `${client.name} - ${client.cpf}`;
        if (client.id === selectedClientId) {
            option.selected = true;
        }
        select.appendChild(option);
    });
}

function updateEditLoanSummary() {
    const amount = parseFloat(document.getElementById('editLoanAmount').value) || 0;
    const interestRate = parseFloat(document.getElementById('editLoanInterest').value) || 0;
    
    const interestAmount = amount * (interestRate / 100);
    const total = amount + interestAmount;
    
    document.getElementById('editSummaryPrincipal').textContent = `R$ ${amount.toFixed(2)}`;
    document.getElementById('editSummaryInterest').textContent = `R$ ${interestAmount.toFixed(2)}`;
    document.getElementById('editSummaryTotal').textContent = `R$ ${total.toFixed(2)}`;
}

function showConfirmationModal(title, message, onConfirm, confirmButtonText = 'Confirmar', isPayment = false) {
    document.getElementById('confirmationTitle').textContent = title;
    document.getElementById('confirmationMessage').textContent = message;
    
    // Configurar o botão de confirmação
    const confirmBtn = document.getElementById('confirmDeleteBtn');
    
    // Configurar estilo do botão baseado no tipo de ação
    if (isPayment) {
        // Para marcar como quitado - botão verde
        confirmBtn.className = 'px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors';
    } else {
        // Para outras ações - botão vermelho (padrão)
        confirmBtn.className = 'px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors';
    }
    
    // Configurar o onclick para fechar o modal automaticamente após a ação
    confirmBtn.onclick = async () => {
        try {
            await onConfirm();
            // Fechar o modal automaticamente após a ação
            hideModal(document.getElementById('confirmationModal'));
        } catch (error) {
            console.error('Erro ao executar ação:', error);
            // Ainda assim fechar o modal em caso de erro
            hideModal(document.getElementById('confirmationModal'));
        }
    };
    
    confirmBtn.textContent = confirmButtonText;
    
    showModal(document.getElementById('confirmationModal'));
}

function showSuccessMessage(message) {
    // Criar uma notificação de sucesso
    const notification = document.createElement('div');
    notification.className = 'fixed top-4 right-4 bg-green-600 text-white px-6 py-3 rounded-lg shadow-lg z-50 transform transition-all duration-300 translate-x-full';
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    // Animar entrada
    setTimeout(() => {
        notification.classList.remove('translate-x-full');
    }, 100);
    
    // Remover após 3 segundos
    setTimeout(() => {
        notification.classList.add('translate-x-full');
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// Função para mostrar o modal de mensagens de pagamento
async function showPaymentMessageModal(loanId, paymentInfo) {
    try {
        // Buscar dados do empréstimo e cliente
        const { data: loan, error: loanError } = await supabase
            .from('loans')
            .select(`
                *,
                clients (name, phone)
            `)
            .eq('id', loanId)
            .single();

        if (loanError) throw loanError;

        // Calcular valor restante do empréstimo
        const remainingAmount = await calculateLoanRemainingAmount(loanId);
        
        // Calcular valores do empréstimo
        const originalCapital = parseFloat(loan.original_amount || loan.amount);
        const interestRate = parseFloat(loan.interest_rate);
        const originalInterest = originalCapital * (interestRate / 100);
        const totalAmount = originalCapital + originalInterest;

        // Calcular próxima data de pagamento
        let nextPaymentDate = '';
        if (paymentInfo.newDueDate) {
            nextPaymentDate = formatDate(paymentInfo.newDueDate);
        } else if (loan.due_date) {
            nextPaymentDate = formatDate(loan.due_date);
        } else {
            // Se não há data específica, calcular 30 dias a partir de hoje
            const today = new Date();
            const nextDate = new Date(today);
            nextDate.setDate(nextDate.getDate() + 30);
            nextPaymentDate = formatDate(nextDate.toISOString().split('T')[0]);
        }

        // Determinar tipo de pagamento
        let paymentTypeDescription = '';
        if (paymentInfo.recalcInfo) {
            if (paymentInfo.recalcInfo.isInterestOnlyRenewal) {
                paymentTypeDescription = 'Somente Juros';
            } else if (paymentInfo.recalcInfo.isCapitalAndInterest) {
                paymentTypeDescription = 'Capital + Juros';
            } else if (paymentInfo.recalcInfo.isCapitalOnly) {
                paymentTypeDescription = 'Somente Capital';
            }
        }

        // Atualizar o modal com as informações
        document.getElementById('nextPaymentDate').textContent = nextPaymentDate;

        // Armazenar dados para uso nas mensagens
        window.currentPaymentMessageData = {
            clientName: loan.clients.name,
            clientPhone: loan.clients.phone,
            nextPaymentDate: nextPaymentDate,
            loanStatus: loan.status,
            paymentInfo: paymentInfo,
            paymentAmount: paymentInfo.amount,
            remainingAmount: remainingAmount,
            paymentTypeDescription: paymentTypeDescription,
            totalLoanAmount: totalAmount
        };

        // Determinar tipo de mensagem automaticamente e pré-selecionar
        let suggestedMessageType = 'lembrete'; // padrão
        
        if (paymentInfo.isFullyPaid || loan.status === 'paid' || remainingAmount <= 0) {
            suggestedMessageType = 'quitacao';
        } else if (paymentInfo.isRenewal || paymentInfo.recalcInfo?.isInterestOnlyRenewal) {
            suggestedMessageType = 'renovacao';
        }

        // Mostrar o modal
        showModal(document.getElementById('paymentMessageModal'));

        // Pré-selecionar o tipo de mensagem sugerido
        setTimeout(() => {
            const radioButton = document.querySelector(`input[name="messageType"][value="${suggestedMessageType}"]`);
            if (radioButton) {
                radioButton.checked = true;
                radioButton.dispatchEvent(new Event('change'));
            }
        }, 100);

        // Configurar event listeners se ainda não foram configurados
        setupPaymentMessageEventListeners();

    } catch (error) {
        console.error('Erro ao mostrar modal de mensagem:', error);
        alert('Erro ao carregar dados para mensagem: ' + error.message);
    }
}

// Templates de mensagens
const messageTemplates = {
    quitacao: (data) => {
        const isInstallment = data.paymentInfo?.isInstallment;
        const productType = isInstallment ? 'parcelamento' : 'empréstimo';
        
        let paymentDetails = '';
        if (!isInstallment && data.paymentAmount) {
            paymentDetails = `\n💰 *Valor do último pagamento:* R$ ${data.paymentAmount.toFixed(2).replace('.', ',')}`;
        }
        
        return `🎉 *Parabéns, ${data.clientName}!*

Seu ${productType} foi *QUITADO COMPLETAMENTE*! ${paymentDetails}

✅ Agradecemos pela confiança em nossos serviços
✅ Seu nome está limpo e livre de pendências  
✅ Estamos sempre à disposição para futuras necessidades

Muito obrigado pela parceria e pontualidade! 🤝

_Equipe Grupo Creditas_`;
    },

    renovacao: (data) => {
        const isInstallment = data.paymentInfo?.isInstallment;
        let paymentDetails = '';
        
        if (!isInstallment && data.paymentAmount) {
            paymentDetails = `\n💰 *DETALHES DO PAGAMENTO:*`;
            paymentDetails += `\n💵 Valor pago: R$ ${data.paymentAmount.toFixed(2).replace('.', ',')}`;
            
            if (data.paymentTypeDescription) {
                paymentDetails += `\n📋 Tipo de pagamento: ${data.paymentTypeDescription}`;
            }
            
            if (data.remainingAmount !== undefined) {
                paymentDetails += `\n💎 Saldo restante: R$ ${data.remainingAmount.toFixed(2).replace('.', ',')}`;
            }
        }
        
        return `✅ *Pagamento recebido, ${data.clientName}!*

Seu pagamento foi registrado com sucesso!${paymentDetails}

📅 *Próximo vencimento:* ${data.nextPaymentDate}

Agradecemos pela confiança e pontualidade. Estamos sempre à disposição para esclarecer dúvidas.

Tenha um ótimo dia! 😊

_Equipe Grupo Creditas_`;
    },

    lembrete: (data) => {
        const isInstallment = data.paymentInfo?.isInstallment;
        let nextDateText = '';
        let paymentDetails = '';
        
        if (data.nextPaymentDate === 'Parcelamento quitado') {
            nextDateText = `🎉 *Parabéns! Seu parcelamento foi quitado completamente!*`;
        } else {
            nextDateText = `📅 *Próximo vencimento:* ${data.nextPaymentDate}`;
        }
        
        if (!isInstallment && data.paymentAmount) {
            paymentDetails = `\n💰 *DETALHES DO PAGAMENTO:*`;
            paymentDetails += `\n💵 Valor pago: R$ ${data.paymentAmount.toFixed(2).replace('.', ',')}`;
            
            if (data.paymentTypeDescription) {
                paymentDetails += `\n📋 Tipo de pagamento: ${data.paymentTypeDescription}`;
            }
            
            if (data.remainingAmount !== undefined) {
                paymentDetails += `\n💎 Saldo restante: R$ ${data.remainingAmount.toFixed(2).replace('.', ',')}`;
            }
        }
        
        return `✅ *Pagamento recebido, ${data.clientName}!*

Recebemos seu pagamento com sucesso!${paymentDetails}

${nextDateText}

Agradecemos pela confiança. Para dúvidas ou negociações, estamos sempre disponíveis.

Conte conosco! 🤝

_Equipe Grupo Creditas_`;
    }
};

// Configurar event listeners do modal de mensagens
function setupPaymentMessageEventListeners() {
    // Evitar múltiplos listeners
    if (window.paymentMessageListenersSetup) return;
    window.paymentMessageListenersSetup = true;

    const modal = document.getElementById('paymentMessageModal');
    const messageTextArea = document.getElementById('paymentMessageText');
    const copyBtn = document.getElementById('copyPaymentMessage');
    const sendBtn = document.getElementById('sendPaymentMessage');
    const closeBtn = document.getElementById('closePaymentMessageBtn');
    const closeModalBtn = document.getElementById('closePaymentMessageModal');

    // Listener para mudança no tipo de mensagem
    document.addEventListener('change', function(e) {
        if (e.target.name === 'messageType' && window.currentPaymentMessageData) {
            const messageType = e.target.value;
            const template = messageTemplates[messageType];
            
            if (template) {
                const message = template(window.currentPaymentMessageData);
                messageTextArea.value = message;
                copyBtn.disabled = false;
                sendBtn.disabled = false;
            }
        }
    });

    // Copiar mensagem
    copyBtn.addEventListener('click', async function() {
        try {
            await navigator.clipboard.writeText(messageTextArea.value);
            showSuccessMessage('Mensagem copiada para a área de transferência!');
        } catch (error) {
            console.error('Erro ao copiar:', error);
            // Fallback para navegadores mais antigos
            messageTextArea.select();
            document.execCommand('copy');
            showSuccessMessage('Mensagem copiada!');
        }
    });

    // Enviar via WhatsApp
    sendBtn.addEventListener('click', function() {
        if (window.currentPaymentMessageData && window.currentPaymentMessageData.clientPhone) {
            let phone = window.currentPaymentMessageData.clientPhone.replace(/\D/g, '');
            
            // Garantir que o telefone tenha o formato correto
            if (phone.length === 11 && phone.startsWith('0')) {
                phone = phone.substring(1); // Remove o 0 inicial se houver
            }
            if (phone.length === 10) {
                phone = phone.substring(0, 2) + '9' + phone.substring(2); // Adiciona o 9 para celulares
            }
            
            const message = encodeURIComponent(messageTextArea.value);
            const whatsappUrl = `https://wa.me/55${phone}?text=${message}`;
            window.open(whatsappUrl, '_blank');
            showSuccessMessage('Abrindo WhatsApp...');
        } else {
            alert('Número de telefone do cliente não encontrado.');
        }
    });

    // Fechar modal
    function closeModal() {
        hideModal(modal);
        // Limpar dados
        window.currentPaymentMessageData = null;
        messageTextArea.value = '';
        copyBtn.disabled = true;
        sendBtn.disabled = true;
        // Desmarcar radio buttons
        document.querySelectorAll('input[name="messageType"]').forEach(radio => {
            radio.checked = false;
        });
    }

    closeBtn.addEventListener('click', closeModal);
    closeModalBtn.addEventListener('click', closeModal);
}

function showErrorMessage(message) {
    // Criar uma notificação de erro
    const notification = document.createElement('div');
    notification.className = 'fixed top-4 right-4 bg-red-600 text-white px-6 py-3 rounded-lg shadow-lg z-50 transform transition-all duration-300 translate-x-full';
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    // Animar entrada
    setTimeout(() => {
        notification.classList.remove('translate-x-full');
    }, 100);
    
    // Remover após 4 segundos (um pouco mais para erros)
    setTimeout(() => {
        notification.classList.add('translate-x-full');
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 4000);
}

function showInfoMessage(message) {
    // Criar uma notificação informativa
    const notification = document.createElement('div');
    notification.className = 'fixed top-4 right-4 bg-blue-600 text-white px-6 py-3 rounded-lg shadow-lg z-50 transform transition-all duration-300 translate-x-full';
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    // Animar entrada
    setTimeout(() => {
        notification.classList.remove('translate-x-full');
    }, 100);
    
    // Remover após 4 segundos
    setTimeout(() => {
        notification.classList.add('translate-x-full');
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 4000);
}

// Função unificada para notificações (compatibilidade com código existente)
function showNotification(message, type = 'info') {
    switch(type) {
        case 'success':
            showSuccessMessage(message);
            break;
        case 'error':
            showErrorMessage(message);
            break;
        case 'info':
        default:
            showInfoMessage(message);
            break;
    }
}

// Função para tratar erros de autenticação
function handleAuthError(error) {
    console.error('Erro de autenticação:', error);
    
    if (error.message && error.message.includes('401')) {
        showNotification('Sessão expirada. Redirecionando para login...', 'error');
        setTimeout(() => {
            handleLogout();
        }, 2000);
        return true;
    } else if (error.code === 'PGRST301' || error.message?.includes('JWT')) {
        showNotification('Erro de autenticação. Faça login novamente.', 'error');
        setTimeout(() => {
            handleLogout();
        }, 2000);
        return true;
    }
    
    return false;
}

// Criar tabelas no Supabase se não existirem
async function createTablesIfNotExist() {
    try {
        console.log('Verificando se as tabelas necessárias existem...');
        
        // Verificar se a tabela clients existe tentando fazer uma consulta
        try {
            const { data: clientsCheck, error: clientsCheckError } = await supabase
                .from('clients')
                .select('id')
                .limit(1);
            
            if (clientsCheckError) {
                console.log('Tabela clients não encontrada. Execute o script database-setup.sql no Supabase.');
            } else {
                console.log('✓ Tabela clients encontrada');
            }
    } catch (error) {
            console.log('Erro ao verificar tabela clients:', error);
        }
        
        // Verificar se a tabela loans existe
        try {
            const { data: loansCheck, error: loansCheckError } = await supabase
                .from('loans')
                .select('id')
                .limit(1);
            
            if (loansCheckError) {
                console.log('Tabela loans não encontrada. Execute o script database-setup.sql no Supabase.');
            } else {
                console.log('✓ Tabela loans encontrada');
            }
        } catch (error) {
            console.log('Erro ao verificar tabela loans:', error);
        }
        
        // Verificar se a tabela payments existe
        try {
            const { data: paymentsCheck, error: paymentsCheckError } = await supabase
                .from('payments')
                .select('id')
                .limit(1);
            
            if (paymentsCheckError) {
                console.log('Tabela payments não encontrada. Execute o script database-setup.sql no Supabase.');
            } else {
                console.log('✓ Tabela payments encontrada');
            }
        } catch (error) {
            console.log('Erro ao verificar tabela payments:', error);
        }
        
        // Verificar se a tabela users existe
        try {
            const { data: usersCheck, error: usersCheckError } = await supabase
                .from('users')
                .select('id')
                .limit(1);
            
            if (usersCheckError) {
                console.log('Tabela users não encontrada. Execute o script database-setup.sql no Supabase.');
            } else {
                console.log('✓ Tabela users encontrada');
            }
        } catch (error) {
            console.log('Erro ao verificar tabela users:', error);
        }
        
        // Verificar se a tabela expenses existe
        try {
            const { data: expensesCheck, error: expensesCheckError } = await supabase
                .from('expenses')
                .select('id')
                .limit(1);
            
            if (expensesCheckError) {
                console.log('Tabela expenses não encontrada. Execute o script database-setup.sql no Supabase.');
            } else {
                console.log('✓ Tabela expenses encontrada');
            }
        } catch (error) {
            console.log('Erro ao verificar tabela expenses:', error);
        }
        
        // Verificar se a tabela capital_raising existe
        try {
            const { data: capitalRaisingCheck, error: capitalRaisingCheckError } = await supabase
                .from('capital_raising')
                .select('id')
                .limit(1);
            
            if (capitalRaisingCheckError) {
                console.log('Tabela capital_raising não encontrada. Execute o script capital-raising-setup.sql no Supabase.');
            } else {
                console.log('✓ Tabela capital_raising encontrada');
            }
        } catch (error) {
            console.log('Erro ao verificar tabela capital_raising:', error);
        }
        
        // Verificar se a tabela capital_raising_clients existe
        try {
            const { data: capitalClientsCheck, error: capitalClientsCheckError } = await supabase
                .from('capital_raising_clients')
                .select('id')
                .limit(1);
            
            if (capitalClientsCheckError) {
                console.log('Tabela capital_raising_clients não encontrada. Execute o script capital-raising-setup.sql no Supabase.');
            } else {
                console.log('✓ Tabela capital_raising_clients encontrada');
            }
        } catch (error) {
            console.log('Erro ao verificar tabela capital_raising_clients:', error);
        }
        
        console.log('Verificação de tabelas concluída!');
        console.log('Se alguma tabela não foi encontrada, execute os scripts SQL apropriados no SQL Editor do Supabase.');
        
    } catch (error) {
        console.log('Erro ao verificar tabelas:', error);
        console.log('Execute o script database-setup.sql no SQL Editor do Supabase para criar todas as tabelas necessárias.');
    }
}

// Função para marcar empréstimo como quitado
async function markLoanAsPaid(loanId) {
    try {
        // Verificar se o empréstimo já está quitado
        const loan = loans.find(l => l.id === loanId);
        if (!loan) {
            showInfoMessage('Empréstimo não encontrado');
            return;
        }
        
        if (loan.status === 'paid') {
            showInfoMessage('Este empréstimo já está quitado');
            return;
        }
        
        // Mostrar confirmação
        showConfirmationModal(
            'Confirmar Quitação',
            `Deseja realmente marcar este empréstimo como quitado?\n\nCliente: ${loan.clients?.name || 'Cliente não encontrado'}\nValor: R$ ${parseFloat(loan.amount).toFixed(2)}\nJuros: ${loan.interest_rate}%`,
            async () => {
                // Calcular valores
                const totalWithInterest = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
                
                // Buscar total pago
                const { data: payments, error: paymentsError } = await supabase
                    .from('payments')
                    .select('amount')
                    .eq('loan_id', loanId);
                
                if (paymentsError) throw paymentsError;
                
                const totalPaid = payments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
                
                // Inserir na tabela paid_loans
                const { error: insertError } = await supabase
                    .from('paid_loans')
                    .insert([{
                        loan_id: loanId,
                        client_id: loan.client_id,
                        original_amount: loan.amount,
                        interest_rate: loan.interest_rate,
                        total_with_interest: totalWithInterest,
                        loan_date: loan.loan_date,
                        due_date: loan.due_date,
                        paid_date: new Date().toISOString().split('T')[0],
                        total_paid: totalPaid,
                        payment_method: 'Sistema',
                        notes: 'Quitado pelo sistema',
                        created_by: loan.created_by
                    }]);
                
                if (insertError) throw insertError;
                
                // Remover da tabela loans
                const { error: deleteError } = await supabase
                    .from('loans')
                    .delete()
                    .eq('id', loanId);
                
                if (deleteError) throw deleteError;
                
                // Remover da lista local
                const loanIndex = loans.findIndex(l => l.id === loanId);
                if (loanIndex > -1) {
                    loans.splice(loanIndex, 1);
                }
                
                // Remover da lista filtrada
                const filteredLoanIndex = filteredLoans.findIndex(l => l.id === loanId);
                if (filteredLoanIndex > -1) {
                    filteredLoans.splice(filteredLoanIndex, 1);
                }
                
                // Mostrar mensagem de sucesso
                showSuccessMessage('Empréstimo quitado com sucesso e movido para histórico de quitados!');
                
                // Invalidar cache e atualizar interface imediatamente
                invalidateLoanRemainingAmountsCache();
                await renderLoansTable();
                await renderPaidLoansTable();
                await updateDashboard();
                await updateCharts();
            },
            'Marcar como Quitado',
            true  // isPayment = true para usar botão verde
        );
        
    } catch (error) {
        console.error('Erro ao marcar empréstimo como quitado:', error);
        showInfoMessage('Erro ao marcar empréstimo como quitado: ' + error.message);
    }
}

// Função para atualizar informações do usuário no header
function updateUserInfo() {
    if (currentUser) {
        const userNameElement = document.getElementById('userName');
        const userInitialElement = document.getElementById('userInitial');
        
        if (userNameElement) {
            userNameElement.textContent = currentUser.full_name || currentUser.email;
        }
        
        if (userInitialElement) {
            userInitialElement.textContent = (currentUser.full_name || currentUser.email).charAt(0).toUpperCase();
        }
    }
}

// Inicializar tabelas quando necessário
document.addEventListener('DOMContentLoaded', function() {
    // Tentar criar tabelas se necessário
    createTablesIfNotExist();
});

// Função para popular o select de clientes na aba de histórico
function populateHistoryClientSelect() {
    const select = document.getElementById('historyClientSelect');
    select.innerHTML = '<option value="">Ou selecione da lista completa</option>';
    
    if (!clients || clients.length === 0) {
        console.log('Nenhum cliente carregado para o histórico');
        const option = document.createElement('option');
        option.value = "";
        option.textContent = "Nenhum cliente encontrado";
        option.disabled = true;
        select.appendChild(option);
        return;
    }
    
    clients.forEach(client => {
        const option = document.createElement('option');
        option.value = client.id;
        option.textContent = `${client.name} - ${client.cpf}`;
        select.appendChild(option);
    });
}

// Função para buscar clientes por nome
function searchHistoryClients(searchTerm) {
    if (!clients || clients.length === 0) {
        return [];
    }
    
    if (!searchTerm || searchTerm.trim().length < 2) {
        return [];
    }
    
    const term = searchTerm.toLowerCase().trim();
    return clients.filter(client => 
        client.name.toLowerCase().includes(term) ||
        client.cpf.includes(term) ||
        (client.rg && client.rg.toLowerCase().includes(term)) ||
        (client.email && client.email.toLowerCase().includes(term))
    );
}

// Função para renderizar resultados da busca
function renderHistorySearchResults(results) {
    const resultsList = document.getElementById('historyClientResultsList');
    const resultsContainer = document.getElementById('historyClientResults');
    
    if (!results || results.length === 0) {
        resultsContainer.classList.add('hidden');
        return;
    }
    
    resultsList.innerHTML = '';
    
    results.forEach(client => {
        const resultItem = document.createElement('div');
        resultItem.className = 'p-3 hover:bg-gray-700 cursor-pointer transition-colors';
        resultItem.innerHTML = `
            <div class="text-white font-medium">${client.name}</div>
            <div class="text-gray-400 text-sm">${client.cpf}</div>
            ${client.email ? `<div class="text-gray-400 text-sm">${client.email}</div>` : ''}
        `;
        
        resultItem.addEventListener('click', () => {
            selectHistoryClient(client);
        });
        
        resultsList.appendChild(resultItem);
    });
    
    resultsContainer.classList.remove('hidden');
}

// Função para selecionar um cliente
function selectHistoryClient(client) {
    // Atualizar o campo de busca
    document.getElementById('historyClientSearch').value = `${client.name} - ${client.cpf}`;
    
    // Atualizar o select
    document.getElementById('historyClientSelect').value = client.id;
    
    // Esconder resultados
    document.getElementById('historyClientResults').classList.add('hidden');
    
    // Carregar histórico automaticamente
    loadClientHistory();
}

// Função para carregar o histórico completo de um cliente
async function loadClientHistory() {
    const clientId = document.getElementById('historyClientSelect').value;
    
    if (!clientId) {
        showInfoMessage('Por favor, selecione um cliente primeiro');
        return;
    }
    
    try {
        const client = clients.find(c => c.id === clientId);
        if (!client) {
            showInfoMessage('Cliente não encontrado');
            return;
        }
        
        // Buscar todos os empréstimos ativos do cliente
        const { data: clientLoans, error: loansError } = await supabase
            .from('loans')
            .select(`
                *,
                clients (
                    name,
                    cpf,
                    email,
                    phone
                )
            `)
            .eq('client_id', clientId)
            .order('created_at', { ascending: false });
        
        if (loansError) throw loansError;
        
        // Buscar empréstimos quitados do cliente
        const { data: paidLoans, error: paidLoansError } = await supabase
            .from('paid_loans')
            .select('*')
            .eq('client_id', clientId)
            .order('paid_date', { ascending: false });
        
        if (paidLoansError) throw paidLoansError;
        
        // Adicionar dados do cliente aos empréstimos quitados
        const paidLoansWithClient = (paidLoans || []).map(paidLoan => ({
            ...paidLoan,
            clients: client // Usar os dados do cliente já carregados
        }));
        
        // Combinar empréstimos ativos e quitados
        const allClientLoans = [...(clientLoans || []), ...paidLoansWithClient];
        
        // Buscar todos os pagamentos dos empréstimos ativos do cliente
        const activeLoanIds = (clientLoans || []).map(loan => loan.id);
        let clientPayments = [];
        
        if (activeLoanIds.length > 0) {
            const { data: payments, error: paymentsError } = await supabase
                .from('payments')
                .select('*')
                .in('loan_id', activeLoanIds)
                .order('payment_date', { ascending: false });
            
            if (paymentsError) throw paymentsError;
            clientPayments = payments || [];
        }
        
        // Calcular resumo financeiro
        const totalLoans = allClientLoans.length;
        const totalActiveAmount = (clientLoans || []).reduce((sum, loan) => sum + parseFloat(loan.amount || 0), 0);
        const totalPaidAmount = (paidLoansWithClient || []).reduce((sum, loan) => sum + parseFloat(loan.original_amount || 0), 0);
        const totalAmount = totalActiveAmount + totalPaidAmount;
        
        // Total pago inclui pagamentos de empréstimos ativos + total pago de empréstimos quitados
        const totalPaidFromActive = clientPayments.reduce((sum, payment) => sum + parseFloat(payment.amount || 0), 0);
        const totalPaidFromSettled = (paidLoansWithClient || []).reduce((sum, loan) => sum + parseFloat(loan.total_paid || 0), 0);
        const totalPaid = totalPaidFromActive + totalPaidFromSettled;
        
        // Calcular valores restantes em lote para melhor performance
        const clientLoanIds = (clientLoans || []).map(loan => loan.id);
        const clientRemainingAmounts = await calculateBatchLoanRemainingAmounts(clientLoanIds);
        const totalRemaining = clientRemainingAmounts.reduce((sum, amount) => sum + amount, 0);
        
        // Atualizar resumo do cliente
        document.getElementById('historyTotalLoans').textContent = totalLoans;
        document.getElementById('historyTotalAmount').textContent = `R$ ${totalAmount.toFixed(2)}`;
        document.getElementById('historyTotalPaid').textContent = `R$ ${totalPaid.toFixed(2)}`;
        document.getElementById('historyRemainingAmount').textContent = `R$ ${totalRemaining.toFixed(2)}`;
        
        // Mostrar resumo do cliente
        document.getElementById('clientSummary').classList.remove('hidden');
        
        // Renderizar tabela de empréstimos (ativos e quitados)
        renderHistoryLoansTable(allClientLoans, paidLoansWithClient || []);
        
        // Renderizar tabela de pagamentos
        renderHistoryPaymentsTable(clientPayments, clientLoans || [], paidLoansWithClient || []);
        
        showSuccessMessage(`Histórico carregado para ${client.name}`);
        
    } catch (error) {
        console.error('Erro ao carregar histórico:', error);
        showInfoMessage('Erro ao carregar histórico: ' + error.message);
    }
}

// Função para renderizar tabela de empréstimos do histórico
function renderHistoryLoansTable(allClientLoans, paidLoans) {
    const tbody = document.getElementById('historyLoansTableBody');
    
    if (allClientLoans.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="8" class="px-6 py-8 text-center text-gray-400">
                    Nenhum empréstimo encontrado para este cliente
                </td>
            </tr>
        `;
        return;
    }
    
    let tableHTML = '';
    for (const loan of allClientLoans) {
        // Verificar se é empréstimo quitado
        const isPaidLoan = paidLoans.some(pl => pl.loan_id === loan.id || pl.id === loan.id);
        const loanAmount = isPaidLoan ? parseFloat(loan.original_amount || loan.amount || 0) : parseFloat(loan.amount || 0);
        const interestRate = parseFloat(loan.interest_rate || 0);
        const originalTotal = loanAmount + (loanAmount * interestRate / 100);
        
        let status, statusClass, statusText;
        if (isPaidLoan) {
            status = 'paid';
            statusClass = 'bg-green-100 text-green-800';
            statusText = 'Quitado';
        } else {
            status = getLoanStatus(loan.due_date, loan.status);
            statusClass = getStatusClass(status);
            statusText = getStatusText(status);
        }
        
        // Data do empréstimo e vencimento
        const loanDate = isPaidLoan ? (loan.loan_date || loan.created_at) : loan.loan_date;
        const dueDate = isPaidLoan ? loan.due_date : loan.due_date;
        const paidDate = isPaidLoan ? loan.paid_date : null;
        
        tableHTML += `
            <tr class="table-row ${isPaidLoan ? 'bg-green-900 bg-opacity-20' : ''}">
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm font-medium text-white">${loan.clients?.name || 'Cliente não encontrado'}</div>
                    <div class="text-sm text-gray-300">${loan.clients?.cpf || ''}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">R$ ${loanAmount.toFixed(2)}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${interestRate}%</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(loanDate)}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(dueDate)}</td>
                <td class="px-6 py-4 whitespace-nowrap">
                    <span class="status-badge ${statusClass}">${statusText}</span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                    <div class="text-blue-300">R$ ${originalTotal.toFixed(2)}</div>
                    ${isPaidLoan ? `<div class="text-green-400 text-xs">Pago: R$ ${parseFloat(loan.total_paid || 0).toFixed(2)}</div>` : ''}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                    ${isPaidLoan && paidDate ? `
                        <button class="text-green-400 hover:text-green-300 mr-2" onclick="showPaidLoanPaymentHistory('${loan.loan_id || loan.id}')" title="Ver histórico de pagamentos">
                            💰
                        </button>
                        <button class="text-blue-400 hover:text-blue-300 mr-2" onclick="showPaidLoanDetails('${loan.id}')" title="Ver detalhes da quitação">
                            ℹ️
                        </button>
                    ` : `
                        <button class="text-purple-400 hover:text-purple-300 mr-3" onclick="showPaymentHistory('${loan.id}')" title="Ver histórico de pagamentos">💰</button>
                    `}
                </td>
            </tr>
        `;
    }
    
    tbody.innerHTML = tableHTML;
}

// Função para renderizar tabela de pagamentos do histórico
function renderHistoryPaymentsTable(clientPayments, clientLoans, paidLoans) {
    const tbody = document.getElementById('historyPaymentsTableBody');
    
    // Combinar pagamentos de empréstimos ativos com informações de empréstimos quitados
    const allPaymentInfo = [];
    
    // Adicionar pagamentos de empréstimos ativos
    for (const payment of clientPayments) {
        const loan = clientLoans.find(l => l.id === payment.loan_id);
        if (loan) {
            allPaymentInfo.push({
                type: 'payment',
                date: payment.payment_date,
                amount: parseFloat(payment.amount),
                fineAmount: parseFloat(payment.fine_amount || 0),
                paymentType: payment.payment_type,
                notes: payment.notes || 'Sem notas',
                loanAmount: parseFloat(loan.amount),
                loanInterest: parseFloat(loan.interest_rate),
                isFromPaidLoan: false
            });
        }
    }
    
    // Adicionar informações de quitação de empréstimos pagos
    for (const paidLoan of paidLoans) {
        allPaymentInfo.push({
            type: 'settlement',
            date: paidLoan.paid_date,
            amount: parseFloat(paidLoan.total_paid || 0),
            fineAmount: 0, // Empréstimos quitados não têm multa separada
            paymentType: paidLoan.payment_method || 'Quitação',
            notes: paidLoan.notes || 'Empréstimo quitado completamente',
            loanAmount: parseFloat(paidLoan.original_amount || 0),
            loanInterest: parseFloat(paidLoan.interest_rate || 0),
            isFromPaidLoan: true
        });
    }
    
    // Ordenar por data (mais recente primeiro)
    allPaymentInfo.sort((a, b) => new Date(b.date) - new Date(a.date));
    
    if (allPaymentInfo.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="6" class="px-6 py-8 text-center text-gray-400">
                    Nenhum pagamento encontrado para este cliente
                </td>
            </tr>
        `;
        return;
    }
    
    let tableHTML = '';
    for (const info of allPaymentInfo) {
        const loanTotal = info.loanAmount + (info.loanAmount * info.loanInterest / 100);
        const rowClass = info.isFromPaidLoan ? 'bg-green-900 bg-opacity-20' : '';
        const typeDisplay = info.type === 'settlement' ? 'Quitação Total' : getPaymentTypeText(info.paymentType);
        
        tableHTML += `
            <tr class="table-row ${rowClass}">
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(info.date)}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm ${info.isFromPaidLoan ? 'text-green-400 font-semibold' : 'text-gray-300'}">
                    R$ ${info.amount.toFixed(2)}
                    ${info.isFromPaidLoan ? '<div class="text-xs text-green-300">Quitação</div>' : ''}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm ${(info.fineAmount > 0) ? 'text-red-400' : 'text-gray-500'}">
                    ${(info.fineAmount > 0) ? `R$ ${info.fineAmount.toFixed(2)}` : '-'}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                    ${typeDisplay}
                    ${info.isFromPaidLoan ? '<div class="text-xs text-green-400">✅ Empréstimo Quitado</div>' : ''}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                    <div>R$ ${info.loanAmount.toFixed(2)}</div>
                    <div class="text-xs text-gray-400">Total: R$ ${loanTotal.toFixed(2)}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${info.notes}</td>
            </tr>
        `;
    }
    
    tbody.innerHTML = tableHTML;
}

// Função para cancelar empréstimo
async function cancelLoan(loanId) {
    try {
        const loan = loans.find(l => l.id === loanId);
        if (!loan) {
            showInfoMessage('Empréstimo não encontrado');
            return;
        }
        
        if (loan.status === 'cancelled') {
            showInfoMessage('Este empréstimo já está cancelado');
            return;
        }
        
        // Calcular valor total pago antes do cancelamento
        const { data: payments, error: paymentsError } = await supabase
            .from('payments')
            .select('amount')
            .eq('loan_id', loanId);
        
        if (paymentsError) throw paymentsError;
        
        const totalPaidBeforeCancellation = payments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        const totalWithInterest = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
        
        // Inserir na tabela cancelled_loans
        const { error: insertError } = await supabase
            .from('cancelled_loans')
            .insert([{
                loan_id: loanId,
                client_id: loan.client_id,
                original_amount: loan.amount,
                interest_rate: loan.interest_rate,
                total_with_interest: totalWithInterest,
                loan_date: loan.loan_date,
                due_date: loan.due_date,
                cancellation_date: new Date().toISOString().split('T')[0],
                cancellation_reason: 'Cancelado pelo usuário',
                total_paid_before_cancellation: totalPaidBeforeCancellation,
                refund_amount: totalPaidBeforeCancellation, // Valor a ser reembolsado
                cancellation_fee: 0, // Taxa de cancelamento (pode ser configurável)
                cancelled_by: currentUser.id,
                created_by: loan.created_by
            }]);
        
        if (insertError) throw insertError;
        
        // Remover da tabela loans
        const { error: deleteError } = await supabase
            .from('loans')
            .delete()
            .eq('id', loanId);
        
        if (deleteError) throw deleteError;
        
        // Remover da lista local
        const loanIndex = loans.findIndex(l => l.id === loanId);
        if (loanIndex > -1) {
            loans.splice(loanIndex, 1);
        }
        
        // Remover da lista filtrada
        const filteredLoanIndex = filteredLoans.findIndex(l => l.id === loanId);
        if (filteredLoanIndex > -1) {
            filteredLoans.splice(filteredLoanIndex, 1);
        }
        
        // Fechar modal de confirmação
        hideModal(document.getElementById('confirmationModal'));
        
        // Mostrar mensagem de sucesso
        showSuccessMessage('Empréstimo cancelado com sucesso e movido para histórico de cancelamentos!');
        
        // Invalidar cache e atualizar interface imediatamente
        invalidateLoanRemainingAmountsCache();
        await renderLoansTable();
        await updateDashboard();
        await updateCharts();
        
    } catch (error) {
        console.error('Erro ao cancelar empréstimo:', error);
        showInfoMessage('Erro ao cancelar empréstimo: ' + error.message);
    }
}




// Função para mostrar histórico de pagamentos de um empréstimo quitado
async function showPaidLoanPaymentHistory(originalLoanId) {
    try {
        // Buscar dados do empréstimo quitado usando o loan_id original
        const { data: paidLoan, error: paidLoanError } = await supabase
            .from('paid_loans')
            .select('*')
            .eq('loan_id', originalLoanId)
            .single();
        
        if (paidLoanError) throw paidLoanError;
        
        // Buscar dados do cliente
        const { data: client, error: clientError } = await supabase
            .from('clients')
            .select('id, name, cpf, email, phone')
            .eq('id', paidLoan.client_id)
            .single();
        
        if (clientError) {
            console.warn('Cliente não encontrado:', clientError);
        }
        
        const clientName = client?.name || 'Cliente não encontrado';
        
        // Atualizar título do modal
        const titleElement = document.querySelector('#paymentHistoryModal h3');
        if (titleElement) {
            titleElement.textContent = `Histórico de Pagamentos - ${clientName} (QUITADO)`;
        }
        
        // Preencher informações do empréstimo
        document.getElementById('paymentHistoryLoanId').value = originalLoanId;
        document.getElementById('paymentHistoryLoanAmount').textContent = `R$ ${parseFloat(paidLoan.original_amount || 0).toFixed(2)}`;
        document.getElementById('paymentHistoryLoanInterestRate').textContent = `${parseFloat(paidLoan.interest_rate || 0).toFixed(2)}%`;
        document.getElementById('paymentHistoryLoanDate').textContent = formatDate(paidLoan.loan_date);
        document.getElementById('paymentHistoryLoanDueDate').textContent = formatDate(paidLoan.due_date);
        document.getElementById('paymentHistoryLoanStatus').textContent = 'QUITADO';
        
        // Carregar histórico de pagamentos
        await loadPaidLoanPaymentHistory(originalLoanId, paidLoan);
        
        showModal(paymentHistoryModal);
        
        showInfoMessage(`Visualizando histórico de pagamentos de ${clientName} (Empréstimo Quitado)`);
        
    } catch (error) {
        console.error('Erro ao carregar histórico do empréstimo quitado:', error);
        showInfoMessage('Erro ao carregar histórico: ' + error.message);
    }
}

// Função para carregar histórico de pagamentos de empréstimo quitado
async function loadPaidLoanPaymentHistory(originalLoanId, paidLoan) {
    try {
        // Buscar todos os pagamentos feitos durante o período do empréstimo
        const { data: payments, error } = await supabase
            .from('payments')
            .select('*')
            .eq('loan_id', originalLoanId)
            .order('payment_date', { ascending: false });
        
        if (error) throw error;
        
        const tbody = document.getElementById('paymentHistoryTableBody');
        tbody.innerHTML = ''; // Limpar tabela antes de renderizar
        
        // Combinar pagamentos parciais com quitação final
        const allPayments = [...(payments || [])];
        
        // Adicionar a quitação final como último pagamento
        if (paidLoan.paid_date) {
            const totalPaidInPartialPayments = (payments || []).reduce((sum, p) => sum + parseFloat(p.amount || 0), 0);
            const finalPaymentAmount = parseFloat(paidLoan.total_paid || 0) - totalPaidInPartialPayments;
            
            if (finalPaymentAmount > 0) {
                allPayments.unshift({
                    id: 'final_payment',
                    payment_date: paidLoan.paid_date,
                    amount: finalPaymentAmount,
                    payment_type: paidLoan.payment_method || 'quitacao',
                    notes: 'Pagamento final - Quitação total do empréstimo',
                    is_final_payment: true
                });
            }
        }
        
        if (allPayments.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="6" class="px-6 py-8 text-center text-gray-400">
                        Nenhum pagamento registrado para este empréstimo.
                    </td>
                </tr>
            `;
            updatePaidLoanPaymentSummary(paidLoan, []);
            return;
        }
        
        // Renderizar pagamentos
        allPayments.forEach(payment => {
            const paymentAmount = parseFloat(payment.amount);
            const fineAmount = parseFloat(payment.fine_amount) || 0;
            const paymentType = payment.is_final_payment ? 'Quitação Final' : getPaymentTypeText(payment.payment_type);
            const paymentNotes = payment.notes || 'Sem notas';
            const rowClass = payment.is_final_payment ? 'bg-green-900 bg-opacity-30' : '';
            const amountClass = payment.is_final_payment ? 'text-green-400 font-semibold' : 'text-gray-300';
            
            tbody.innerHTML += `
                <tr class="table-row ${rowClass}">
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(payment.payment_date)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm ${amountClass}">
                        R$ ${paymentAmount.toFixed(2)}
                        ${payment.is_final_payment ? '<div class="text-xs text-green-300">Quitação</div>' : ''}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm ${fineAmount > 0 ? 'text-red-400 font-semibold' : 'text-gray-500'}">
                        ${fineAmount > 0 ? 'R$ ' + fineAmount.toFixed(2) : '-'}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                        ${paymentType}
                        ${payment.is_final_payment ? '<div class="text-xs text-green-400">✅ Final</div>' : ''}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${paymentNotes}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        ${payment.is_final_payment ? '<span class="text-green-400">✅</span>' : `<button class="text-gray-500" disabled title="Empréstimo já quitado">🔒</button>`}
                    </td>
                </tr>
            `;
        });
        
        // Atualizar resumo financeiro
        updatePaidLoanPaymentSummary(paidLoan, payments || []);
        
    } catch (error) {
        console.error('Erro ao carregar histórico de pagamentos do empréstimo quitado:', error);
        const tbody = document.getElementById('paymentHistoryTableBody');
        tbody.innerHTML = `
            <tr>
                <td colspan="6" class="px-6 py-8 text-center text-red-400">
                    Erro ao carregar histórico de pagamentos
                </td>
            </tr>
        `;
    }
}

// Função para atualizar resumo de pagamentos de empréstimo quitado
function updatePaidLoanPaymentSummary(paidLoan, payments) {
    const originalAmount = parseFloat(paidLoan.original_amount || 0);
    const interestRate = parseFloat(paidLoan.interest_rate || 0);
    const totalWithInterest = originalAmount + (originalAmount * interestRate / 100);
    const totalPaid = parseFloat(paidLoan.total_paid || 0);
    
    document.getElementById('paymentHistoryTotalPaid').textContent = `R$ ${totalPaid.toFixed(2)}`;
    document.getElementById('paymentHistoryRemainingAmount').textContent = 'R$ 0,00 (QUITADO)';
    document.getElementById('paymentHistoryTotalWithInterest').textContent = `R$ ${totalWithInterest.toFixed(2)}`;
}

// Função para mostrar detalhes de um empréstimo quitado
async function showPaidLoanDetails(paidLoanId) {
    try {
        const { data: paidLoan, error } = await supabase
            .from('paid_loans')
            .select('*')
            .eq('id', paidLoanId)
            .single();
        
        if (error) throw error;
        
        // Buscar dados do cliente separadamente
        const { data: client, error: clientError } = await supabase
            .from('clients')
            .select('id, name, cpf, email, phone')
            .eq('id', paidLoan.client_id)
            .single();
        
        if (clientError) {
            console.warn('Cliente não encontrado:', clientError);
        }
        
        // Preencher dados do cliente
        document.getElementById('paidLoanClientName').textContent = client?.name || 'Cliente não encontrado';
        document.getElementById('paidLoanClientCpf').textContent = client?.cpf || 'N/A';
        document.getElementById('paidLoanClientEmail').textContent = client?.email || 'N/A';
        document.getElementById('paidLoanClientPhone').textContent = client?.phone || 'N/A';
        
        // Preencher dados do empréstimo
        document.getElementById('paidLoanOriginalAmount').textContent = `R$ ${parseFloat(paidLoan.original_amount || 0).toFixed(2)}`;
        document.getElementById('paidLoanInterestRate').textContent = `${parseFloat(paidLoan.interest_rate || 0).toFixed(2)}%`;
        document.getElementById('paidLoanTotalWithInterest').textContent = `R$ ${parseFloat(paidLoan.total_with_interest || 0).toFixed(2)}`;
        document.getElementById('paidLoanDate').textContent = formatDate(paidLoan.loan_date);
        document.getElementById('paidLoanDueDate').textContent = formatDate(paidLoan.due_date);
        
        // Preencher dados da quitação
        document.getElementById('paidLoanPaidDate').textContent = formatDate(paidLoan.paid_date);
        document.getElementById('paidLoanTotalPaid').textContent = `R$ ${parseFloat(paidLoan.total_paid || 0).toFixed(2)}`;
        document.getElementById('paidLoanPaymentMethod').textContent = paidLoan.payment_method || 'N/A';
        document.getElementById('paidLoanNotes').textContent = paidLoan.notes || 'Sem observações';
        
        // Mostrar modal
        showModal(paidLoanDetailsModal);
        
    } catch (error) {
        console.error('Erro ao buscar detalhes do empréstimo quitado:', error);
        showInfoMessage('Erro ao buscar detalhes: ' + error.message);
    }
}

// Função para restaurar um empréstimo quitado
async function restorePaidLoan(paidLoanId) {
    try {
        // Buscar dados do empréstimo quitado
        const { data: paidLoan, error: fetchError } = await supabase
            .from('paid_loans')
            .select('*')
            .eq('id', paidLoanId)
            .single();
            
        if (fetchError) throw fetchError;
        
        // Buscar dados do cliente separadamente
        const { data: client, error: clientError } = await supabase
            .from('clients')
            .select('id, name, cpf, email, phone')
            .eq('id', paidLoan.client_id)
            .single();
        
        if (clientError) {
            console.warn('Cliente não encontrado:', clientError);
        }
        
        // Mostrar confirmação
        const confirmMessage = `Deseja restaurar o empréstimo quitado?\n\nCliente: ${client?.name || 'Cliente não encontrado'}\nValor: R$ ${parseFloat(paidLoan.original_amount).toFixed(2)}\nJuros: ${paidLoan.interest_rate}%\n\nEsta ação irá recriar o empréstimo na tabela principal.`;
        
        if (!confirm(confirmMessage)) return;
        
        // Recriar o empréstimo na tabela loans
        const { error: insertError } = await supabase
            .from('loans')
            .insert([{
                id: paidLoan.loan_id, // Manter o ID original
                client_id: paidLoan.client_id,
                amount: paidLoan.original_amount,
                original_amount: paidLoan.original_amount, // Preservar valor original
                interest_rate: paidLoan.interest_rate,
                loan_date: paidLoan.loan_date,
                due_date: paidLoan.due_date,
                status: 'active', // Status ativo
                created_by: paidLoan.created_by,
                created_at: paidLoan.created_at
            }]);
        
        if (insertError) throw insertError;
        
        // Remover da tabela paid_loans
        const { error: deleteError } = await supabase
            .from('paid_loans')
            .delete()
            .eq('id', paidLoanId);
        
        if (deleteError) throw deleteError;
        
        // Recarregar dados
        invalidateLoanRemainingAmountsCache();
        await loadLoans();
        await updateDashboard();
        await updateCharts();
        
        showSuccessMessage('Empréstimo restaurado com sucesso!');
        
    } catch (error) {
        console.error('Erro ao restaurar empréstimo:', error);
        showInfoMessage('Erro ao restaurar empréstimo: ' + error.message);
    }
}

// Função para excluir um empréstimo quitado permanentemente
async function deletePaidLoan(paidLoanId) {
    try {
        // Buscar dados do empréstimo quitado
        const { data: paidLoan, error: fetchError } = await supabase
            .from('paid_loans')
            .select('*')
            .eq('id', paidLoanId)
            .single();
            
        if (fetchError) throw fetchError;
        
        // Buscar dados do cliente separadamente
        const { data: client, error: clientError } = await supabase
            .from('clients')
            .select('id, name, cpf, email, phone')
            .eq('id', paidLoan.client_id)
            .single();
        
        if (clientError) {
            console.warn('Cliente não encontrado:', clientError);
        }
        
        // Mostrar confirmação
        const confirmMessage = `ATENÇÃO: Esta ação é irreversível!\n\nDeseja excluir permanentemente o empréstimo quitado?\n\nCliente: ${client?.name || 'Cliente não encontrado'}\nValor: R$ ${parseFloat(paidLoan.original_amount).toFixed(2)}\nJuros: ${paidLoan.interest_rate}%\n\nTodos os dados serão perdidos para sempre.`;
        
        if (!confirm(confirmMessage)) return;
        
        // Excluir da tabela paid_loans
        const { error: deleteError } = await supabase
            .from('paid_loans')
            .delete()
            .eq('id', paidLoanId);
        
        if (deleteError) throw deleteError;
        
        // Invalidar cache e atualizar interface
        invalidateLoanRemainingAmountsCache();
        await renderPaidLoansTable();
        await updateDashboard();
        await updateCharts();
        
        showSuccessMessage('Empréstimo quitado excluído permanentemente!');
        
    } catch (error) {
        console.error('Erro ao excluir empréstimo quitado:', error);
        showInfoMessage('Erro ao excluir empréstimo: ' + error.message);
    }
}

// ================================
// GESTÃO DE DESPESAS
// ================================





// Definir data padrão para hoje
function setDefaultExpenseDate() {
    document.getElementById('expenseDate').value = formatDateForInput(new Date());
}





// Manipular envio de nova despesa
async function handleNewExpense(e) {
    e.preventDefault();
    
    try {
        const formData = new FormData(e.target);
        const description = document.getElementById('expenseDescription').value;
        const category = document.getElementById('expenseCategory').value;
        const amount = parseFloat(document.getElementById('expenseAmount').value);
        const date = document.getElementById('expenseDate').value;
        const notes = document.getElementById('expenseNotes').value;
        

        
        const expenseData = {
            title: description,
            description: description,
            category_id: category, // Este será o ID da categoria
            amount: amount,
            date: date,
            notes: notes,
            payment_method: 'cash', // valor padrão
            status: 'pending',
            user_id: currentUser.id,
            created_by: currentUser.id
        };
        
        // Inserir no banco de dados
        const { data, error } = await supabase
            .from('expenses')
            .insert([expenseData])
            .select();
            
        if (error) throw error;
        
        // Atualizar lista local
        expenses.push(data[0]);
        
        // Atualizar interface
        await loadExpenses();
        updateExpensesSummary();
        
        // Fechar modal e limpar formulário
        hideModal(newExpenseModal);
        newExpenseForm.reset();

        
        showSuccessMessage('Despesa criada com sucesso!');
        
    } catch (error) {
        console.error('Erro ao criar despesa:', error);
        showInfoMessage('Erro ao criar despesa: ' + error.message);
    }
}

// Carregar despesas
async function loadExpenses() {
    try {
        // First, get the expenses with user information
        let expensesQuery = supabase.from('expenses')
            .select(`
                *,
                users!expenses_user_id_fkey(full_name, email, role),
                created_by_user:users!expenses_created_by_fkey(full_name, email, role)
            `);
        
        // Se não for admin ou manager, filtrar apenas despesas próprias
        if (currentUser.role !== 'admin' && currentUser.role !== 'manager') {
            expensesQuery = expensesQuery.eq('user_id', currentUser.id);
        }
        
        const { data: expensesData, error: expensesError } = await expensesQuery
            .order('date', { ascending: false });
            
        if (expensesError) throw expensesError;
        
        // Then, get all categories
        const { data: categoriesData, error: categoriesError } = await supabase
            .from('expense_categories')
            .select('id, name, color, icon')
            .eq('is_active', true);
            
        if (categoriesError) throw categoriesError;
        
        // Create a map of categories for quick lookup
        const categoriesMap = {};
        (categoriesData || []).forEach(category => {
            categoriesMap[category.id] = category;
        });
        
        // Join expenses with categories
        expenses = (expensesData || []).map(expense => ({
            ...expense,
            expense_categories: expense.category_id ? categoriesMap[expense.category_id] : null
        }));
        
        displayExpenses();
        updateExpensesSummary();
        
    } catch (error) {
        console.error('Erro ao carregar despesas:', error);
        showInfoMessage('Erro ao carregar despesas: ' + error.message);
    }
}

// Exibir despesas na tabela
function displayExpenses() {
    const tbody = document.getElementById('expensesTableBody');
    
    if (expenses.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="6" class="px-6 py-8 text-center text-gray-400">
                    <div class="flex flex-col items-center">
                        <svg class="w-12 h-12 text-gray-600 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                        </svg>
                        <p class="text-lg font-medium">Nenhuma despesa encontrada</p>
                        <p class="text-sm">Clique em "Nova Despesa" para adicionar sua primeira despesa</p>
                    </div>
                </td>
            </tr>
        `;
        return;
    }
    
    tbody.innerHTML = expenses.map(expense => `
        <tr class="table-row">
            <td class="px-6 py-4">
                <div>
                    <p class="text-white font-medium">${expense.title || expense.description}</p>
                    ${expense.notes ? `<p class="text-gray-400 text-sm">${expense.notes}</p>` : ''}
                </div>
            </td>
            <td class="px-6 py-4">
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getCategoryBadge(expense.expense_categories?.name || 'outros')}">
                    ${getCategoryName(expense.expense_categories?.name || 'outros')}
                </span>
            </td>
            <td class="px-6 py-4">
                <span class="text-white font-semibold">R$ ${expense.amount.toFixed(2).replace('.', ',')}</span>
            </td>
            <td class="px-6 py-4">
                <span class="text-gray-300">${formatDate(expense.date)}</span>
            </td>
            <td class="px-6 py-4">
                <div>
                    <p class="text-white text-sm">${expense.users?.full_name || expense.created_by_user?.full_name || 'N/A'}</p>
                    <p class="text-gray-400 text-xs">${expense.users?.email || expense.created_by_user?.email || ''}</p>
                </div>
            </td>
            <td class="px-6 py-4">
                <div class="flex space-x-2">
                    <button onclick="deleteExpense('${expense.id}')" class="text-red-400 hover:text-red-300 p-1" title="Excluir despesa">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                        </svg>
                    </button>
                </div>
            </td>
        </tr>
    `).join('');
}

// Obter classe CSS para badge da categoria
function getCategoryBadge(categoryName) {
    const badges = {
        'Alimentação': 'bg-green-100 text-green-800',
        'Transporte': 'bg-blue-100 text-blue-800',
        'Escritório': 'bg-purple-100 text-purple-800',
        'Marketing': 'bg-yellow-100 text-yellow-800',
        'Tecnologia': 'bg-teal-100 text-teal-800',
        'Saúde': 'bg-pink-100 text-pink-800',
        'Educação': 'bg-indigo-100 text-indigo-800',
        'Limpeza': 'bg-cyan-100 text-cyan-800',
        'Manutenção': 'bg-orange-100 text-orange-800',
        'Outros': 'bg-gray-100 text-gray-800'
    };
    return badges[categoryName] || badges['Outros'];
}

// Obter nome da categoria (retorna o próprio nome já que vem da tabela)
function getCategoryName(categoryName) {
    return categoryName || 'Outros';
}

// Atualizar resumo de despesas
function updateExpensesSummary() {
    const now = new Date();
    const currentMonth = now.getMonth();
    const currentYear = now.getFullYear();
    
    // Total do mês atual
    const monthlyTotal = expenses
        .filter(expense => {
            const expenseDate = new Date(expense.date);
            return expenseDate.getMonth() === currentMonth && expenseDate.getFullYear() === currentYear;
        })
        .reduce((sum, expense) => sum + expense.amount, 0);
    
    // Total do ano atual
    const yearlyTotal = expenses
        .filter(expense => {
            const expenseDate = new Date(expense.date);
            return expenseDate.getFullYear() === currentYear;
        })
        .reduce((sum, expense) => sum + expense.amount, 0);
    
    // Atualizar elementos da interface
    document.getElementById('monthlyExpensesTotal').textContent = `R$ ${monthlyTotal.toFixed(2).replace('.', ',')}`;
    document.getElementById('yearlyExpensesTotal').textContent = `R$ ${yearlyTotal.toFixed(2).replace('.', ',')}`;
    document.getElementById('expensesCount').textContent = expenses.length;
}

// Visualizar assinatura


// Excluir despesa
async function deleteExpense(expenseId) {
    try {
        console.log('deleteExpense chamada com ID:', expenseId, 'Tipo:', typeof expenseId);
        
        // Garantir que o ID seja uma string
        const id = String(expenseId);
        
        const expense = expenses.find(e => String(e.id) === id);
        if (!expense) {
            console.error('Despesa não encontrada. ID procurado:', id);
            console.log('Despesas disponíveis:', expenses.map(e => ({ id: e.id, title: e.title || e.description })));
            showInfoMessage('Despesa não encontrada.');
            return;
        }
        
        console.log('Despesa encontrada:', expense);
        
        // Usar modal de confirmação ao invés de confirm simples
        const title = expense.title || expense.description || 'esta despesa';
        showConfirmationModal(
            'Excluir Despesa',
            `Tem certeza que deseja excluir a despesa "${title}"? Esta ação não pode ser desfeita.`,
            () => performDeleteExpense(id),
            'Excluir'
        );
        
    } catch (error) {
        console.error('Erro ao excluir despesa:', error);
        showInfoMessage('Erro ao excluir despesa: ' + error.message);
    }
}

// Executar exclusão da despesa
async function performDeleteExpense(expenseId) {
    try {
        console.log('Tentando excluir despesa com ID:', expenseId, 'Tipo:', typeof expenseId);
        
        // Garantir que o ID seja uma string
        const id = String(expenseId);
        
        // Verificar se a despesa existe antes de tentar excluir
        const expense = expenses.find(e => String(e.id) === id);
        if (!expense) {
            console.error('Despesa não encontrada para exclusão. ID:', id);
            showErrorMessage('Despesa não encontrada.');
            return;
        }
        
        console.log('Excluindo despesa:', expense);
        
        const { data, error } = await supabase
            .from('expenses')
            .delete()
            .eq('id', id)
            .select();
            
        if (error) {
            console.error('Erro do Supabase ao excluir despesa:', error);
            throw error;
        }
        
        console.log('Despesa excluída do banco de dados com sucesso. Dados retornados:', data);
        
        // Remover da lista local usando filter para garantir que funcione
        const originalLength = expenses.length;
        expenses = expenses.filter(e => String(e.id) !== id);
        
        if (expenses.length < originalLength) {
            console.log('Despesa removida da lista local. Quantidade antes:', originalLength, 'Depois:', expenses.length);
        } else {
            console.warn('Despesa não foi removida da lista local. Pode haver problema com o ID.');
        }
        
        // Atualizar interface
        displayExpenses();
        updateExpensesSummary();
        
        showSuccessMessage('Despesa excluída com sucesso!');
        
    } catch (error) {
        console.error('Erro ao excluir despesa:', error);
        showErrorMessage('Erro ao excluir despesa: ' + error.message);
    }
}

// Função para gerar contrato PDF
async function generateContract(loanId) {
    try {
        // Buscar dados do empréstimo
        const loan = loans.find(l => l.id === loanId);
        if (!loan) {
            showInfoMessage('Empréstimo não encontrado!');
            return;
        }

        // Buscar dados do cliente
        const client = clients.find(c => c.id === loan.client_id);
        if (!client) {
            showInfoMessage('Cliente não encontrado!');
            return;
        }

        // Buscar avalistas do cliente
        const clientGuarantors = await loadClientGuarantors(loan.client_id);

        // Criar novo documento PDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // Configurações do documento
        doc.setFont('helvetica');
        
        // Título
        doc.setFontSize(16);
        doc.setFont('helvetica', 'bold');
        doc.text('CONTRATO DE MÚTUO', 105, 20, { align: 'center' });
        
        // Reset font
        doc.setFontSize(11);
        doc.setFont('helvetica', 'normal');
        
        // Texto do contrato
        let yPosition = 30;
        const lineHeight = 5;
        const margin = 20;
        const pageWidth = doc.internal.pageSize.width;
        const maxWidth = pageWidth - (margin * 2);

        // Função para adicionar texto com quebra de linha
        function addWrappedText(text, x, y, maxWidth) {
            const lines = doc.splitTextToSize(text, maxWidth);
            doc.text(lines, x, y);
            return y + (lines.length * lineHeight);
        }

        // Parágrafo inicial
        const introText = "Pelo presente instrumento particular, as partes abaixo qualificadas:";
        yPosition = addWrappedText(introText, margin, yPosition, maxWidth) + 3;

        // Mutuante
        doc.setFont('helvetica', 'bold');
        yPosition = addWrappedText("MUTUANTE:", margin, yPosition, maxWidth);
        doc.setFont('helvetica', 'normal');
        const mutuanteText = "VALORUM, pessoa jurídica de direito privado, inscrita no CNPJ sob nº 52.496.899/0001-89, com sede à AV Presidente Vargas 700, Franca/SP.";
        yPosition = addWrappedText(mutuanteText, margin, yPosition, maxWidth) + 3;

        // Mutuário
        doc.setFont('helvetica', 'bold');
        yPosition = addWrappedText("MUTUÁRIO:", margin, yPosition, maxWidth);
        doc.setFont('helvetica', 'normal');
        const mutuarioText = `${client.name}, brasileiro, portador do CPF nº ${client.cpf}, RG nº ${client.rg || 'N/A'}, residente e domiciliada à ${client.address || 'Endereço não informado'}.`;
        yPosition = addWrappedText(mutuarioText, margin, yPosition, maxWidth) + 3;

        // Avalista (se existir)
        if (clientGuarantors && clientGuarantors.length > 0) {
            const guarantor = clientGuarantors[0]; // Usando o primeiro avalista
            doc.setFont('helvetica', 'bold');
            yPosition = addWrappedText("AVALISTA:", margin, yPosition, maxWidth);
            doc.setFont('helvetica', 'normal');
            const avalistaText = `${guarantor.name}, brasileiro, portador do CPF nº ${guarantor.cpf}, RG nº ${guarantor.rg || 'N/A'}, residente e domiciliado à ${guarantor.address || 'Endereço não informado'}, que neste ato assume a responsabilidade solidária pelo pagamento da dívida.`;
            yPosition = addWrappedText(avalistaText, margin, yPosition, maxWidth) + 5;
        } else {
            yPosition += 2;
        }

        // Acordo
        const acordoText = "Têm entre si justo e acordado o presente contrato de mútuo, que se regerá pelas seguintes cláusulas e condições:";
        yPosition = addWrappedText(acordoText, margin, yPosition, maxWidth) + 5;

        // Cláusula Primeira
        doc.setFont('helvetica', 'bold');
        yPosition = addWrappedText("CLÁUSULA PRIMEIRA - DO OBJETO DO CONTRATO", margin, yPosition, maxWidth);
        doc.setFont('helvetica', 'normal');
        const clausula1Text = `1.1. Pelo presente instrumento, o MUTUANTE empresta ao MUTUÁRIO, que aceita, a quantia de R$ ${parseFloat(loan.amount).toFixed(2).replace('.', ',')}, que será utilizada conforme acordado entre as partes. O MUTUÁRIO declara ter recebido o valor nesta data.`;
        yPosition = addWrappedText(clausula1Text, margin, yPosition, maxWidth) + 3;

        // Cláusula Segunda
        doc.setFont('helvetica', 'bold');
        yPosition = addWrappedText("CLÁUSULA SEGUNDA - DO PRAZO E FORMA DE PAGAMENTO", margin, yPosition, maxWidth);
        doc.setFont('helvetica', 'normal');
        const clausula2Text = `2.1. O valor do mútuo será devolvido em uma parcela única, com vencimento em ${formatDate(loan.due_date)}, podendo ser renegociado por escrito. O pagamento deverá ser feito por transferência bancária ou outro meio acordado.`;
        yPosition = addWrappedText(clausula2Text, margin, yPosition, maxWidth) + 3;

        // Cláusula Terceira
        doc.setFont('helvetica', 'bold');
        yPosition = addWrappedText("CLÁUSULA TERCEIRA - DOS ENCARGOS PELO EMPRÉSTIMO", margin, yPosition, maxWidth);
        doc.setFont('helvetica', 'normal');
        const clausula3Text = `3.1. O mútuo será acrescido de juros de 1% ao mês e multa de 10% sobre o valor da parcela vencida, além de correção monetária pelo IGPM/FGV.`;
        yPosition = addWrappedText(clausula3Text, margin, yPosition, maxWidth) + 3;

        // Verificar se precisa de nova página (mais permissivo)
        if (yPosition > 270) {
            doc.addPage();
            yPosition = 20;
        }

        // Cláusula Quarta
        doc.setFont('helvetica', 'bold');
        yPosition = addWrappedText("CLÁUSULA QUARTA - DA CONFISSÃO DE DÍVIDA", margin, yPosition, maxWidth);
        doc.setFont('helvetica', 'normal');
        const clausula4Text = "4.1. O MUTUÁRIO confessa que a dívida é líquida, certa e exigível, não podendo contestar sua existência ou valor. Em caso de inadimplemento, o MUTUANTE poderá exigir o pagamento imediato do saldo devedor, acrescido de encargos.";
        yPosition = addWrappedText(clausula4Text, margin, yPosition, maxWidth) + 3;

        // Cláusula Quinta
        doc.setFont('helvetica', 'bold');
        yPosition = addWrappedText("CLÁUSULA QUINTA - DA GARANTIA E DA EXECUÇÃO", margin, yPosition, maxWidth);
        doc.setFont('helvetica', 'normal');
        const clausula5Text = "5.1. O contrato é título executivo extrajudicial, conforme artigo 784, III do CPC, podendo o MUTUANTE requerer judicialmente a penhora de bens do MUTUÁRIO em caso de inadimplência.";
        yPosition = addWrappedText(clausula5Text, margin, yPosition, maxWidth) + 3;

        // Adicionar cláusula sobre avalista se existir
        if (clientGuarantors && clientGuarantors.length > 0) {
            const clausula5_2Text = "5.2. O AVALISTA assume responsabilidade solidária pelo pagamento integral da dívida, juros, multa e demais encargos, podendo ser executado diretamente pelo MUTUANTE em caso de inadimplemento do MUTUÁRIO, independentemente de ordem de preferência ou benefício de ordem.";
            yPosition = addWrappedText(clausula5_2Text, margin, yPosition, maxWidth) + 3;
        }

        // Cláusula Sexta
        doc.setFont('helvetica', 'bold');
        yPosition = addWrappedText("CLÁUSULA SEXTA - DA NOTIFICAÇÃO", margin, yPosition, maxWidth);
        doc.setFont('helvetica', 'normal');
        const clausula6Text = "6.1. Em caso de inadimplemento, o MUTUANTE notificará o MUTUÁRIO por carta registrada ou e-mail, concedendo-lhe 10 dias para regularizar o pagamento.";
        yPosition = addWrappedText(clausula6Text, margin, yPosition, maxWidth) + 3;

        // Cláusula Sétima
        doc.setFont('helvetica', 'bold');
        yPosition = addWrappedText("CLÁUSULA SÉTIMA - DO FORO", margin, yPosition, maxWidth);
        doc.setFont('helvetica', 'normal');
        const clausula7Text = "7.1. Fica eleito o foro da Comarca de Franca/SP para dirimir qualquer litígio decorrente deste contrato.";
        yPosition = addWrappedText(clausula7Text, margin, yPosition, maxWidth) + 5;

        // Verificar se precisa de nova página para as assinaturas (mais permissivo)
        if (yPosition > 240) {
            doc.addPage();
            yPosition = 20;
        }

        // Encerramento
        const encerramentoText = "E por estarem assim justos e contratados, firmam o presente instrumento em duas vias de igual teor e forma, para que produza seus jurídicos e legais efeitos.";
        yPosition = addWrappedText(encerramentoText, margin, yPosition, maxWidth) + 6;

        // Data e local
        const dataEmprestimo = formatDate(loan.loan_date);
        yPosition = addWrappedText(`Franca, ${dataEmprestimo}.`, margin, yPosition, maxWidth) + 8;

        // Assinaturas
        doc.setFont('helvetica', 'bold');
        yPosition = addWrappedText("Assinaturas:", margin, yPosition, maxWidth) + 8;

        // Espaço para assinatura do mutuante
        yPosition += 12;
        doc.line(margin, yPosition, 90, yPosition);
        yPosition += 4;
        doc.text("VALORUM", margin, yPosition);
        yPosition += 4;
        doc.text("Mutuante", margin, yPosition);

        // Espaço para assinatura do mutuário
        yPosition -= 16;
        doc.line(120, yPosition + 12, 190, yPosition + 12);
        yPosition += 16;
        doc.text(client.name, 120, yPosition);
        yPosition += 4;
        doc.text("Mutuário", 120, yPosition);

        // Espaço para assinatura do avalista (se existir)
        if (clientGuarantors && clientGuarantors.length > 0) {
            const guarantor = clientGuarantors[0];
            yPosition += 12;
            
            // Verificar se precisa de nova página para assinatura do avalista
            if (yPosition > 260) {
                doc.addPage();
                yPosition = 20;
                doc.setFont('helvetica', 'bold');
                yPosition = addWrappedText("Assinaturas (continuação):", margin, yPosition, maxWidth) + 8;
            }
            
            doc.line(margin, yPosition, 90, yPosition);
            yPosition += 4;
            doc.text(guarantor.name, margin, yPosition);
            yPosition += 4;
            doc.text("Avalista", margin, yPosition);
        }



        // Salvar o PDF
        const hasGuarantor = clientGuarantors && clientGuarantors.length > 0;
        const guarantorInfo = hasGuarantor ? '_com_avalista' : '';
        const fileName = `Contrato_${client.name.replace(/\s+/g, '_')}${guarantorInfo}_${new Date().toISOString().split('T')[0]}.pdf`;
        doc.save(fileName);

        const successMessage = hasGuarantor ? 
            'Contrato gerado com sucesso! Inclui dados e assinatura do avalista.' : 
            'Contrato gerado com sucesso!';
        showSuccessMessage(successMessage);

    } catch (error) {
        console.error('Erro ao gerar contrato:', error);
        showInfoMessage('Erro ao gerar contrato: ' + error.message);
    }
}

// Função para gerar PDF dos empréstimos do último mês
async function generateMonthlyLoansPDF() {
    try {
        // Calcular data de um mês atrás
        const oneMonthAgo = new Date();
        oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);
        
        // Filtrar empréstimos do último mês
        const monthlyLoans = loans.filter(loan => {
            const loanDate = new Date(loan.created_at);
            return loanDate >= oneMonthAgo;
        });
        
        // Buscar empréstimos quitados no último mês
        const { data: monthlyPaidLoans, error: paidLoansError } = await supabase
            .from('paid_loans')
            .select('*')
            .gte('paid_date', oneMonthAgo.toISOString().split('T')[0])
            .order('paid_date', { ascending: true });
            
        if (paidLoansError) throw paidLoansError;

        if (monthlyLoans.length === 0 && (!monthlyPaidLoans || monthlyPaidLoans.length === 0)) {
            showInfoMessage('Nenhum empréstimo ou quitação foi encontrada no último mês.');
            return;
        }

        // Criar novo documento PDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // Configurações do documento
        doc.setFont('helvetica');
        
        // Título
        doc.setFontSize(18);
        doc.setFont('helvetica', 'bold');
        doc.text('RELATÓRIO DE EMPRÉSTIMOS - ÚLTIMO MÊS', 105, 20, { align: 'center' });
        
        // Período
        doc.setFontSize(12);
        doc.setFont('helvetica', 'normal');
        const periodText = `Período: ${oneMonthAgo.toLocaleDateString('pt-BR')} a ${new Date().toLocaleDateString('pt-BR')}`;
        doc.text(periodText, 105, 30, { align: 'center' });
        
        // Data de geração
        doc.setFontSize(10);
        doc.text(`Gerado em: ${new Date().toLocaleDateString('pt-BR')} às ${new Date().toLocaleTimeString('pt-BR')}`, 20, 40);
        
        // Linha divisória
        doc.line(20, 45, 190, 45);
        
        let yPosition = 55;
        
        // Resumo
        doc.setFontSize(14);
        doc.setFont('helvetica', 'bold');
        doc.text('RESUMO', 20, yPosition);
        yPosition += 10;
        
        const totalAmount = monthlyLoans.reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
        const totalInterest = monthlyLoans.reduce((sum, loan) => sum + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100), 0);
        const totalWithInterest = totalAmount + totalInterest;
        
        // Calcular totais de quitações no mês
        const totalPaidAmount = (monthlyPaidLoans || []).reduce((sum, paidLoan) => sum + parseFloat(paidLoan.total_paid || 0), 0);
        const totalSettlements = (monthlyPaidLoans || []).length;
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Total de empréstimos: ${monthlyLoans.length}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total emprestado: R$ ${totalAmount.toFixed(2).replace('.', ',')}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Total de juros: R$ ${totalInterest.toFixed(2).replace('.', ',')}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total com juros: R$ ${totalWithInterest.toFixed(2).replace('.', ',')}`, 20, yPosition);
        yPosition += 8;
        
        // Adicionar informações sobre quitações
        if (totalSettlements > 0) {
            doc.setFont('helvetica', 'bold');
            doc.text(`QUITAÇÕES NO PERÍODO:`, 20, yPosition);
            yPosition += 6;
            doc.setFont('helvetica', 'normal');
            doc.text(`Total de quitações: ${totalSettlements}`, 20, yPosition);
            yPosition += 6;
            doc.text(`Valor total quitado: R$ ${totalPaidAmount.toFixed(2).replace('.', ',')}`, 20, yPosition);
            yPosition += 8;
        }
        yPosition += 7;
        
        // Cabeçalho da tabela
        doc.setFontSize(12);
        doc.setFont('helvetica', 'bold');
        doc.text('DETALHAMENTO DOS EMPRÉSTIMOS E QUITAÇÕES', 20, yPosition);
        yPosition += 10;
        
        // Cabeçalhos das colunas
        doc.setFontSize(8);
        doc.setFont('helvetica', 'bold');
        doc.text('Data', 20, yPosition);
        doc.text('Cliente', 40, yPosition);
        doc.text('Valor', 95, yPosition);
        doc.text('Juros%', 120, yPosition);
        doc.text('Total', 140, yPosition);
        doc.text('Status/Tipo', 165, yPosition);
        yPosition += 5;
        
        // Linha divisória
        doc.line(20, yPosition, 190, yPosition);
        yPosition += 5;
        
        // Dados dos empréstimos
        doc.setFont('helvetica', 'normal');
        
        for (const loan of monthlyLoans) {
            // Verificar se precisa de nova página
            if (yPosition > 270) {
                doc.addPage();
                yPosition = 20;
                
                // Repetir cabeçalho na nova página
                doc.setFontSize(8);
                doc.setFont('helvetica', 'bold');
                doc.text('Data', 20, yPosition);
                doc.text('Cliente', 40, yPosition);
                doc.text('Valor', 95, yPosition);
                doc.text('Juros%', 120, yPosition);
                doc.text('Total', 140, yPosition);
                doc.text('Status/Tipo', 165, yPosition);
                yPosition += 5;
                doc.line(20, yPosition, 190, yPosition);
                yPosition += 5;
                doc.setFont('helvetica', 'normal');
            }
            
            const loanDate = formatDate(loan.created_at);
            const clientName = loan.clients ? loan.clients.name : 'Cliente não encontrado';
            const amount = parseFloat(loan.amount);
            const interestRate = parseFloat(loan.interest_rate);
            const totalWithInterestLoan = amount + (amount * interestRate / 100);
            
            // Truncar nome do cliente se for muito longo
            const truncatedName = clientName.length > 25 ? clientName.substring(0, 22) + '...' : clientName;
            
            doc.text(loanDate, 20, yPosition);
            doc.text(truncatedName, 40, yPosition);
            doc.text(`R$ ${amount.toFixed(2).replace('.', ',')}`, 95, yPosition);
            doc.text(`${interestRate.toFixed(1)}%`, 120, yPosition);
            doc.text(`R$ ${totalWithInterestLoan.toFixed(2).replace('.', ',')}`, 140, yPosition);
            doc.text(loan.status === 'active' ? 'Ativo' : loan.status === 'paid' ? 'Pago' : 'Cancelado', 165, yPosition);
            
            yPosition += 6;
        }
        
        // Adicionar quitações do mês
        if (monthlyPaidLoans && monthlyPaidLoans.length > 0) {
            // Adicionar separador se houver empréstimos anteriores
            if (monthlyLoans.length > 0) {
                yPosition += 5;
                doc.setFont('helvetica', 'bold');
                doc.text('--- QUITAÇÕES DO PERÍODO ---', 20, yPosition);
                yPosition += 8;
                doc.setFont('helvetica', 'normal');
            }
            
            // Buscar dados dos clientes para as quitações
            const clientIds = monthlyPaidLoans.map(pl => pl.client_id);
            const { data: paidLoanClients } = await supabase
                .from('clients')
                .select('id, name, phone')
                .in('id', clientIds);
            
            for (const paidLoan of monthlyPaidLoans) {
                // Verificar se precisa de nova página
                if (yPosition > 270) {
                    doc.addPage();
                    yPosition = 20;
                    
                    // Repetir cabeçalho na nova página
                    doc.setFontSize(8);
                    doc.setFont('helvetica', 'bold');
                    doc.text('Data', 20, yPosition);
                    doc.text('Cliente', 40, yPosition);
                    doc.text('Valor', 95, yPosition);
                    doc.text('Juros%', 120, yPosition);
                    doc.text('Total', 140, yPosition);
                    doc.text('Status/Tipo', 165, yPosition);
                    yPosition += 5;
                    doc.line(20, yPosition, 190, yPosition);
                    yPosition += 5;
                    doc.setFont('helvetica', 'normal');
                }
                
                const client = paidLoanClients?.find(c => c.id === paidLoan.client_id);
                const paidDate = formatDate(paidLoan.paid_date);
                const clientName = client ? client.name : 'Cliente não encontrado';
                const originalAmount = parseFloat(paidLoan.original_amount || 0);
                const interestRate = parseFloat(paidLoan.interest_rate || 0);
                const totalPaid = parseFloat(paidLoan.total_paid || 0);
                
                // Truncar nome do cliente se for muito longo
                const truncatedName = clientName.length > 25 ? clientName.substring(0, 22) + '...' : clientName;
                
                doc.text(paidDate, 20, yPosition);
                doc.text(truncatedName, 40, yPosition);
                doc.text(`R$ ${originalAmount.toFixed(2).replace('.', ',')}`, 95, yPosition);
                doc.text(`${interestRate.toFixed(1)}%`, 120, yPosition);
                doc.text(`R$ ${totalPaid.toFixed(2).replace('.', ',')}`, 140, yPosition);
                doc.text('QUITAÇÃO', 165, yPosition);
                
                yPosition += 6;
            }
        }
        
        // Rodapé
        const pageCount = doc.internal.getNumberOfPages();
        for (let i = 1; i <= pageCount; i++) {
            doc.setPage(i);
            doc.setFontSize(8);
            doc.setFont('helvetica', 'normal');
            doc.text(`Página ${i} de ${pageCount}`, 190, 290, { align: 'right' });
            doc.text('Nexus Gestão Financeira', 20, 290);
        }
        
        // Salvar o PDF
        const fileName = `Emprestimos_Ultimo_Mes_${new Date().toISOString().split('T')[0]}.pdf`;
        doc.save(fileName);

        let message = `PDF gerado com sucesso! ${monthlyLoans.length} empréstimos encontrados`;
        if (totalSettlements > 0) {
            message += ` e ${totalSettlements} quitações`;
        }
        message += '.';
        showSuccessMessage(message);

    } catch (error) {
        console.error('Erro ao gerar PDF dos empréstimos:', error);
        showInfoMessage('Erro ao gerar PDF: ' + error.message);
    }
}

// Função para gerar PDF dos pagamentos da semana (segunda a domingo)
async function generateWeeklyPaymentsPDF() {
    try {
        // Usar a função getWeekInfo para obter as datas corretas da semana atual
        const now = new Date();
        const weekInfo = getWeekInfo(now);
        
        const startOfWeek = new Date(weekInfo.startDate);
        startOfWeek.setHours(0, 0, 0, 0);
        
        const endOfWeek = new Date(weekInfo.endDate);
        endOfWeek.setHours(23, 59, 59, 999);

        // Buscar todos os pagamentos da semana
        const { data: weeklyPayments, error } = await supabase
            .from('payments')
            .select(`
                *,
                loans!inner (
                    id,
                    amount,
                    interest_rate,
                    clients!inner (
                        name,
                        phone
                    )
                )
            `)
            .gte('payment_date', startOfWeek.toISOString().split('T')[0])
            .lte('payment_date', endOfWeek.toISOString().split('T')[0])
            .order('payment_date', { ascending: true });

        // Buscar empréstimos quitados na semana
        const { data: weeklyPaidLoans, error: paidLoansError } = await supabase
            .from('paid_loans')
            .select('*')
            .gte('paid_date', startOfWeek.toISOString().split('T')[0])
            .lte('paid_date', endOfWeek.toISOString().split('T')[0])
            .order('paid_date', { ascending: true });

        if (error) throw error;
        if (paidLoansError) throw paidLoansError;

        // Combinar pagamentos regulares com quitações
        const allWeeklyPayments = [...(weeklyPayments || [])];
        
        // Adicionar quitações como pagamentos especiais
        if (weeklyPaidLoans && weeklyPaidLoans.length > 0) {
            // Buscar dados dos clientes para as quitações
            const clientIds = weeklyPaidLoans.map(pl => pl.client_id);
            const { data: paidLoanClients } = await supabase
                .from('clients')
                .select('id, name, phone')
                .in('id', clientIds);
            
            for (const paidLoan of weeklyPaidLoans) {
                const client = paidLoanClients?.find(c => c.id === paidLoan.client_id);
                allWeeklyPayments.push({
                    id: `quitacao_${paidLoan.id}`,
                    payment_date: paidLoan.paid_date,
                    amount: paidLoan.total_paid,
                    payment_type: 'quitacao',
                    loans: {
                        id: paidLoan.loan_id,
                        amount: paidLoan.original_amount,
                        interest_rate: paidLoan.interest_rate,
                        clients: client || { name: 'Cliente não encontrado', phone: '' }
                    },
                    is_settlement: true
                });
            }
        }
        
        // Ordenar por data
        allWeeklyPayments.sort((a, b) => new Date(a.payment_date) - new Date(b.payment_date));

        if (!allWeeklyPayments || allWeeklyPayments.length === 0) {
            showInfoMessage('Nenhum pagamento ou quitação foi encontrada na semana atual.');
            return;
        }

        // Criar novo documento PDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // Configurações do documento
        doc.setFont('helvetica');
        
        // Título
        doc.setFontSize(18);
        doc.setFont('helvetica', 'bold');
        doc.text('RELATÓRIO DE PAGAMENTOS SEMANAIS', 105, 20, { align: 'center' });
        
        // Período
        doc.setFontSize(12);
        doc.setFont('helvetica', 'normal');
        const periodText = `Período: ${startOfWeek.toLocaleDateString('pt-BR')} a ${endOfWeek.toLocaleDateString('pt-BR')}`;
        doc.text(periodText, 105, 30, { align: 'center' });
        
        // Data de geração
        doc.setFontSize(10);
        doc.text(`Gerado em: ${new Date().toLocaleDateString('pt-BR')} às ${new Date().toLocaleTimeString('pt-BR')}`, 20, 40);
        
        // Linha divisória
        doc.line(20, 45, 190, 45);
        
        let yPosition = 55;
        
        // Resumo
        doc.setFontSize(14);
        doc.setFont('helvetica', 'bold');
        doc.text('RESUMO SEMANAL', 20, yPosition);
        yPosition += 10;
        
        // Calcular totais
        const totalPayments = allWeeklyPayments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        const totalCapital = allWeeklyPayments.reduce((sum, payment) => {
            const loan = payment.loans;
            const loanAmount = parseFloat(loan.amount);
            const interestAmount = loanAmount * parseFloat(loan.interest_rate) / 100;
            const capitalPortion = parseFloat(payment.amount) > interestAmount ? 
                parseFloat(payment.amount) - interestAmount : 0;
            return sum + capitalPortion;
        }, 0);
        const totalInterest = totalPayments - totalCapital;
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Total de Pagamentos: ${allWeeklyPayments.length}`, 20, yPosition);
        yPosition += 8;
        doc.text(`Total Recebido: R$ ${totalPayments.toFixed(2)}`, 20, yPosition);
        yPosition += 8;
        doc.text(`Total em Juros: R$ ${totalInterest.toFixed(2)}`, 20, yPosition);
        yPosition += 8;
        doc.text(`Total em Capital: R$ ${totalCapital.toFixed(2)}`, 20, yPosition);
        yPosition += 15;
        
        // Linha divisória
        doc.line(20, yPosition, 190, yPosition);
        yPosition += 10;
        
        // Adicionar total de multas antes da tabela
        const totalFines = allWeeklyPayments.reduce((sum, payment) => sum + (parseFloat(payment.fine_amount) || 0), 0);
        yPosition -= 15; // Voltar para adicionar a linha de multas
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Total em Multas: R$ ${totalFines.toFixed(2)}`, 20, yPosition);
        yPosition += 15;
        
        // Cabeçalho da tabela
        doc.setFontSize(12);
        doc.setFont('helvetica', 'bold');
        doc.text('DETALHAMENTO DOS PAGAMENTOS', 20, yPosition);
        yPosition += 10;
        
        // Cabeçalhos das colunas
        doc.setFontSize(9);
        doc.setFont('helvetica', 'bold');
        doc.text('Data', 20, yPosition);
        doc.text('Cliente', 45, yPosition);
        doc.text('Valor Pago', 100, yPosition);
        doc.text('Multa', 130, yPosition);
        doc.text('Juros', 160, yPosition);
        doc.text('Capital', 180, yPosition);
        yPosition += 8;
        
        // Linha dos cabeçalhos
        doc.line(20, yPosition - 2, 190, yPosition - 2);
        yPosition += 5;
        
        // Dados dos pagamentos
        doc.setFont('helvetica', 'normal');
        
        for (const payment of allWeeklyPayments) {
            if (yPosition > 270) {
                doc.addPage();
                yPosition = 20;
                
                // Repetir cabeçalhos na nova página
                doc.setFontSize(9);
                doc.setFont('helvetica', 'bold');
                doc.text('Data', 20, yPosition);
                doc.text('Cliente', 45, yPosition);
                doc.text('Valor Pago', 100, yPosition);
                doc.text('Multa', 130, yPosition);
                doc.text('Juros', 160, yPosition);
                doc.text('Capital', 180, yPosition);
                yPosition += 8;
                doc.line(20, yPosition - 2, 190, yPosition - 2);
                yPosition += 5;
                doc.setFont('helvetica', 'normal');
            }
            
            const loan = payment.loans;
            const client = loan.clients;
            const loanAmount = parseFloat(loan.amount);
            const interestRate = parseFloat(loan.interest_rate);
            const interestAmount = loanAmount * interestRate / 100;
            const paymentAmount = parseFloat(payment.amount);
            
            // Calcular quanto foi de juros e quanto foi de capital
            let interestPaid = 0;
            let capitalPaid = 0;
            let paymentTypeText = '';
            
            if (payment.is_settlement) {
                // Quitação total
                interestPaid = interestAmount;
                capitalPaid = paymentAmount - interestAmount;
                paymentTypeText = 'QUITAÇÃO';
            } else if (paymentAmount <= interestAmount) {
                // Pagamento apenas de juros
                interestPaid = paymentAmount;
                capitalPaid = 0;
                paymentTypeText = 'JUROS';
            } else {
                // Pagamento de juros + capital
                interestPaid = interestAmount;
                capitalPaid = paymentAmount - interestAmount;
                paymentTypeText = 'PGTO';
            }
            
            const fineAmount = parseFloat(payment.fine_amount) || 0;
            
            doc.text(formatDate(payment.payment_date), 20, yPosition);
            doc.text(client.name.substring(0, 18), 45, yPosition);
            doc.text(`R$ ${paymentAmount.toFixed(2)}`, 100, yPosition);
            doc.text(fineAmount > 0 ? `R$ ${fineAmount.toFixed(2)}` : '-', 130, yPosition);
            doc.text(`R$ ${interestPaid.toFixed(2)}`, 160, yPosition);
            doc.text(`R$ ${capitalPaid.toFixed(2)}`, 180, yPosition);
            
            yPosition += 8;
        }
        
        // Rodapé com totais
        yPosition += 10;
        doc.line(20, yPosition, 190, yPosition);
        yPosition += 8;
        
        doc.setFont('helvetica', 'bold');
        doc.text('TOTAIS DA SEMANA:', 20, yPosition);
        doc.text(`R$ ${totalPayments.toFixed(2)}`, 100, yPosition);
        doc.text(`R$ ${totalFines.toFixed(2)}`, 130, yPosition);
        doc.text(`R$ ${totalInterest.toFixed(2)}`, 160, yPosition);
        doc.text(`R$ ${totalCapital.toFixed(2)}`, 180, yPosition);
        
        // Informações da empresa no rodapé
        const pageCount = doc.internal.getNumberOfPages();
        for (let i = 1; i <= pageCount; i++) {
            doc.setPage(i);
            doc.setFontSize(8);
            doc.setFont('helvetica', 'normal');
            doc.text(`Página ${i} de ${pageCount}`, 190, 290, { align: 'right' });
            doc.text('Nexus Gestão Financeira', 20, 290);
        }
        
        // Salvar o PDF
        const fileName = `Pagamentos_Semana_${startOfWeek.toLocaleDateString('pt-BR').replace(/\//g, '-')}_a_${endOfWeek.toLocaleDateString('pt-BR').replace(/\//g, '-')}.pdf`;
        doc.save(fileName);

        // Adicionar ao histórico
        const currentWeek = getWeekNumber(now);
        const currentYear = now.getFullYear();
        const currentWeekKey = `${currentYear}-W${currentWeek}`;
        addToWeeklyPDFHistory(currentWeekKey);

        const regularPayments = allWeeklyPayments.filter(p => !p.is_settlement).length;
        const settlements = allWeeklyPayments.filter(p => p.is_settlement).length;
        let message = `PDF gerado com sucesso! ${allWeeklyPayments.length} registros encontrados na semana`;
        if (settlements > 0) {
            message += ` (${regularPayments} pagamentos + ${settlements} quitações)`;
        }
        showSuccessMessage(message);

    } catch (error) {
        console.error('Erro ao gerar PDF dos pagamentos semanais:', error);
        showInfoMessage('Erro ao gerar PDF: ' + error.message);
    }
}

// Função para gerar PDF das despesas do último mês
async function generateMonthlyExpensesPDF() {
    try {
        // Calcular data de um mês atrás
        const oneMonthAgo = new Date();
        oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);
        
        // Filtrar despesas do último mês
        const monthlyExpenses = expenses.filter(expense => {
            const expenseDate = new Date(expense.date);
            return expenseDate >= oneMonthAgo;
        });

        if (monthlyExpenses.length === 0) {
            showInfoMessage('Nenhuma despesa foi encontrada no último mês.');
            return;
        }

        // Criar novo documento PDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // Configurações do documento
        doc.setFont('helvetica');
        
        // Título
        doc.setFontSize(18);
        doc.setFont('helvetica', 'bold');
        doc.text('RELATÓRIO DE DESPESAS - ÚLTIMO MÊS', 105, 20, { align: 'center' });
        
        // Período
        doc.setFontSize(12);
        doc.setFont('helvetica', 'normal');
        const periodText = `Período: ${oneMonthAgo.toLocaleDateString('pt-BR')} a ${new Date().toLocaleDateString('pt-BR')}`;
        doc.text(periodText, 105, 30, { align: 'center' });
        
        // Data de geração
        doc.setFontSize(10);
        doc.text(`Gerado em: ${new Date().toLocaleDateString('pt-BR')} às ${new Date().toLocaleTimeString('pt-BR')}`, 20, 40);
        
        // Linha divisória
        doc.line(20, 45, 190, 45);
        
        let yPosition = 55;
        
        // Resumo
        doc.setFontSize(14);
        doc.setFont('helvetica', 'bold');
        doc.text('RESUMO', 20, yPosition);
        yPosition += 10;
        
        const totalAmount = monthlyExpenses.reduce((sum, expense) => sum + parseFloat(expense.amount), 0);
        
        // Agrupar por categoria
        const categoryTotals = {};
        monthlyExpenses.forEach(expense => {
            const categoryName = expense.expense_categories?.name || 'Outros';
            categoryTotals[categoryName] = (categoryTotals[categoryName] || 0) + parseFloat(expense.amount);
        });
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Total de despesas: ${monthlyExpenses.length}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total: R$ ${totalAmount.toFixed(2).replace('.', ',')}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor médio por despesa: R$ ${(totalAmount / monthlyExpenses.length).toFixed(2).replace('.', ',')}`, 20, yPosition);
        yPosition += 10;
        
        // Resumo por categoria
        doc.setFontSize(12);
        doc.setFont('helvetica', 'bold');
        doc.text('RESUMO POR CATEGORIA', 20, yPosition);
        yPosition += 8;
        
        doc.setFontSize(9);
        doc.setFont('helvetica', 'normal');
        Object.entries(categoryTotals).sort((a, b) => b[1] - a[1]).forEach(([category, total]) => {
            const percentage = ((total / totalAmount) * 100).toFixed(1);
            doc.text(`${category}: R$ ${total.toFixed(2).replace('.', ',')} (${percentage}%)`, 20, yPosition);
            yPosition += 5;
        });
        
        yPosition += 10;
        
        // Cabeçalho da tabela
        doc.setFontSize(12);
        doc.setFont('helvetica', 'bold');
        doc.text('DETALHAMENTO DAS DESPESAS', 20, yPosition);
        yPosition += 10;
        
        // Cabeçalhos das colunas
        doc.setFontSize(8);
        doc.setFont('helvetica', 'bold');
        doc.text('Data', 20, yPosition);
        doc.text('Descrição', 45, yPosition);
        doc.text('Categoria', 110, yPosition);
        doc.text('Valor', 145, yPosition);
        doc.text('Método', 170, yPosition);
        yPosition += 5;
        
        // Linha divisória
        doc.line(20, yPosition, 190, yPosition);
        yPosition += 5;
        
        // Dados das despesas
        doc.setFont('helvetica', 'normal');
        
        for (const expense of monthlyExpenses) {
            // Verificar se precisa de nova página
            if (yPosition > 270) {
                doc.addPage();
                yPosition = 20;
                
                // Repetir cabeçalho na nova página
                doc.setFontSize(8);
                doc.setFont('helvetica', 'bold');
                doc.text('Data', 20, yPosition);
                doc.text('Descrição', 45, yPosition);
                doc.text('Categoria', 110, yPosition);
                doc.text('Valor', 145, yPosition);
                doc.text('Método', 170, yPosition);
                yPosition += 5;
                doc.line(20, yPosition, 190, yPosition);
                yPosition += 5;
                doc.setFont('helvetica', 'normal');
            }
            
            const expenseDate = formatDate(expense.date);
            const description = expense.title || expense.description || 'Sem descrição';
            const categoryName = expense.expense_categories?.name || 'Outros';
            const amount = parseFloat(expense.amount);
            const paymentMethod = expense.payment_method || 'N/A';
            
            // Truncar descrição se for muito longa
            const truncatedDescription = description.length > 30 ? description.substring(0, 27) + '...' : description;
            const truncatedCategory = categoryName.length > 15 ? categoryName.substring(0, 12) + '...' : categoryName;
            
            doc.text(expenseDate, 20, yPosition);
            doc.text(truncatedDescription, 45, yPosition);
            doc.text(truncatedCategory, 110, yPosition);
            doc.text(`R$ ${amount.toFixed(2).replace('.', ',')}`, 145, yPosition);
            doc.text(paymentMethod, 170, yPosition);
            
            yPosition += 6;
        }
        
        // Rodapé
        const pageCount = doc.internal.getNumberOfPages();
        for (let i = 1; i <= pageCount; i++) {
            doc.setPage(i);
            doc.setFontSize(8);
            doc.setFont('helvetica', 'normal');
            doc.text(`Página ${i} de ${pageCount}`, 190, 290, { align: 'right' });
            doc.text('Nexus Gestão Financeira', 20, 290);
        }
        
        // Salvar o PDF
        const fileName = `Despesas_Ultimo_Mes_${new Date().toISOString().split('T')[0]}.pdf`;
        doc.save(fileName);

        showSuccessMessage(`PDF gerado com sucesso! ${monthlyExpenses.length} despesas encontradas.`);

    } catch (error) {
        console.error('Erro ao gerar PDF das despesas:', error);
        showInfoMessage('Erro ao gerar PDF das despesas: ' + error.message);
    }
}

// Função para gerar PDF das comissões da semana selecionada
async function generateCommissionsPDF() {
    try {
        // Obter as datas do período selecionado
        const startDate = document.getElementById('commissionStartDate').value;
        const endDate = document.getElementById('commissionEndDate').value;
        const loanStatus = document.getElementById('commissionLoanStatus').value;

        if (!startDate || !endDate) {
            showErrorMessage('Por favor, selecione o período inicial e final para gerar o PDF.');
            return;
        }

        console.log('Gerando PDF das comissões para:', { startDate, endDate, loanStatus });

        // Buscar todos os pagamentos para comissões
        const allPayments = await fetchAllPaymentsForCommissions(startDate, endDate, loanStatus);

        if (!allPayments || allPayments.length === 0) {
            showInfoMessage('Nenhum pagamento encontrado para o período selecionado.');
            return;
        }

        // Calcular comissões baseado nos pagamentos
        const commissionsData = calculateCommissionsFromPayments(allPayments);

        // Criar novo documento PDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // Configurações do documento
        doc.setFont('helvetica');
        
        // Título
        doc.setFontSize(18);
        doc.setFont('helvetica', 'bold');
        doc.text('RELATÓRIO DE COMISSÕES', 105, 20, { align: 'center' });
        
        // Período
        doc.setFontSize(12);
        doc.setFont('helvetica', 'normal');
        const startDateFormatted = new Date(startDate + 'T00:00:00').toLocaleDateString('pt-BR');
        const endDateFormatted = new Date(endDate + 'T00:00:00').toLocaleDateString('pt-BR');
        doc.text(`Período: ${startDateFormatted} a ${endDateFormatted}`, 105, 30, { align: 'center' });

        // Status do filtro
        const statusText = loanStatus === 'all' ? 'Todos os Status' : 
                          loanStatus === 'active' ? 'Ativos' :
                          loanStatus === 'due_today' ? 'Vence Hoje' :
                          loanStatus === 'overdue' ? 'Vencidos' :
                          loanStatus === 'paid' ? 'Quitados' : loanStatus;
        doc.text(`Filtro: ${statusText}`, 105, 38, { align: 'center' });

        // Verificar tipo de empresa
        const isErechim = currentCompany === 'erechim';
        const isImperatriz = currentCompany === 'imperatriz';
        
        // Resumo das comissões
        doc.setFontSize(14);
        doc.setFont('helvetica', 'bold');
        doc.text('RESUMO DAS COMISSÕES', 20, 55);

        doc.setFontSize(11);
        doc.setFont('helvetica', 'normal');
        doc.text(`Total de Juros (Base para Comissão): R$ ${commissionsData.summary.totalInterest.toFixed(2)}`, 20, 65);
        
        if (isErechim) {
            // ERECHIM: Mostrar 3 comissões (Bruno, Vinicius, Douglas)
            doc.text(`Comissão Bruno (33,3%): R$ ${commissionsData.summary.totalBrunoCommission.toFixed(2)}`, 20, 73);
            doc.text(`Comissão Vinicius (33,3%): R$ ${commissionsData.summary.totalViniciusCommission.toFixed(2)}`, 20, 81);
            doc.text(`Comissão Douglas (33,3%): R$ ${commissionsData.summary.totalDouglasCommission.toFixed(2)}`, 20, 89);
            doc.text(`Total de Pagamentos Processados: ${commissionsData.summary.totalPayments}`, 20, 97);
        } else if (isImperatriz) {
            // IMPERATRIZ CRED: Mostrar 2 comissões (Vinicius e Alex)
            doc.text(`Comissão Vinicius (50%): R$ ${commissionsData.summary.totalViniciusCommission.toFixed(2)}`, 20, 73);
            doc.text(`Comissão Alex (50%): R$ ${commissionsData.summary.totalAlexCommission.toFixed(2)}`, 20, 81);
            doc.text(`Total de Pagamentos Processados: ${commissionsData.summary.totalPayments}`, 20, 89);
        } else {
            // Outras empresas: Mostrar 2 comissões (Vinicius e Douglas)
            doc.text(`Comissão Vinicius (66,6%): R$ ${commissionsData.summary.totalViniciusCommission.toFixed(2)}`, 20, 73);
            doc.text(`Comissão Douglas (33,3%): R$ ${commissionsData.summary.totalDouglasCommission.toFixed(2)}`, 20, 81);
            doc.text(`Total de Pagamentos Processados: ${commissionsData.summary.totalPayments}`, 20, 89);
        }

        // Linha separadora
        doc.setLineWidth(0.5);
        const separatorY = isErechim ? 103 : 95;
        doc.line(20, separatorY, 190, separatorY);

        // Cabeçalho da tabela
        doc.setFontSize(12);
        doc.setFont('helvetica', 'bold');
        const tableHeaderY = isErechim ? 113 : 105;
        doc.text('DETALHAMENTO POR PAGAMENTO', 20, tableHeaderY);

        // Cabeçalhos das colunas
        doc.setFontSize(9);
        let yPos = isErechim ? 123 : 115;
        doc.text('Cliente', 20, yPos);
        doc.text('Data', 60, yPos);
        doc.text('Pago', 85, yPos);
        doc.text('Base', 108, yPos);
        
        if (isErechim) {
            // ERECHIM: 3 colunas de comissão
            doc.text('Bruno', 130, yPos);
            doc.text('Vinicius', 152, yPos);
            doc.text('Douglas', 175, yPos);
        } else if (isImperatriz) {
            // IMPERATRIZ CRED: 2 colunas de comissão (Vinicius e Alex)
            doc.text('Vinicius (50%)', 155, yPos);
            doc.text('Alex (50%)', 180, yPos);
        } else {
            // Outras empresas: 2 colunas de comissão (Vinicius e Douglas)
            doc.text('Vinicius (66%)', 155, yPos);
            doc.text('Douglas (33%)', 180, yPos);
        }

        // Linha do cabeçalho
        doc.setLineWidth(0.3);
        doc.line(20, yPos + 2, 200, yPos + 2);

        // Dados da tabela
        doc.setFont('helvetica', 'normal');
        doc.setFontSize(8);
        yPos += 8;

        for (let i = 0; i < commissionsData.details.length; i++) {
            const item = commissionsData.details[i];
            
            // Verificar se precisa de nova página
            if (yPos > 270) {
                doc.addPage();
                yPos = 20;
                
                // Repetir cabeçalho na nova página
                doc.setFontSize(9);
                doc.setFont('helvetica', 'bold');
                doc.text('Cliente', 20, yPos);
                doc.text('Data', 60, yPos);
                doc.text('Pago', 85, yPos);
                doc.text('Base', 108, yPos);
                
                if (isErechim) {
                    doc.text('Bruno', 130, yPos);
                    doc.text('Vinicius', 152, yPos);
                    doc.text('Douglas', 175, yPos);
                } else if (isImperatriz) {
                    doc.text('Vinicius (50%)', 155, yPos);
                    doc.text('Alex (50%)', 180, yPos);
                } else {
                    doc.text('Vinicius (66%)', 155, yPos);
                    doc.text('Douglas (33%)', 180, yPos);
                }
                
                doc.setLineWidth(0.3);
                doc.line(20, yPos + 2, 200, yPos + 2);
                
                doc.setFont('helvetica', 'normal');
                doc.setFontSize(8);
                yPos += 8;
            }

            const clientName = item.client?.name || 'Cliente não encontrado';
            const paymentDate = new Date(item.paymentDate).toLocaleDateString('pt-BR');
            
            // Truncar nome do cliente se for muito longo
            const truncatedName = clientName.length > 15 ? clientName.substring(0, 12) + '...' : clientName;
            
            doc.text(truncatedName, 20, yPos);
            doc.text(paymentDate, 60, yPos);
            doc.text(`${item.paymentAmount.toFixed(0)}`, 85, yPos);
            doc.text(`${item.commissionableAmount.toFixed(0)}`, 108, yPos);
            
            if (isErechim) {
                // ERECHIM: Mostrar 3 comissões
                doc.text(`${item.brunoCommission.toFixed(2)}`, 130, yPos);
                doc.text(`${item.viniciusCommission.toFixed(2)}`, 152, yPos);
                doc.text(`${item.douglasCommission.toFixed(2)}`, 175, yPos);
            } else if (isImperatriz) {
                // IMPERATRIZ CRED: Mostrar 2 comissões (Vinicius e Alex)
                doc.text(`${item.viniciusCommission.toFixed(2)}`, 155, yPos);
                doc.text(`${item.alexCommission.toFixed(2)}`, 180, yPos);
            } else {
                // Outras empresas: Mostrar 2 comissões (Vinicius e Douglas)
                doc.text(`${item.viniciusCommission.toFixed(2)}`, 155, yPos);
                doc.text(`${item.douglasCommission.toFixed(2)}`, 180, yPos);
            }

            yPos += 6;
        }

        // Rodapé
        const pageCount = doc.internal.getNumberOfPages();
        for (let i = 1; i <= pageCount; i++) {
            doc.setPage(i);
            doc.setFontSize(8);
            doc.setFont('helvetica', 'normal');
            doc.text(`Página ${i} de ${pageCount}`, 105, 285, { align: 'center' });
            doc.text(`Gerado em: ${new Date().toLocaleString('pt-BR')}`, 20, 290);
            doc.text('Nexus Gestão Financeira', 20, 295);
        }

        // Salvar o PDF
        const fileName = `Comissoes_${startDateFormatted.replace(/\//g, '-')}_a_${endDateFormatted.replace(/\//g, '-')}.pdf`;
        doc.save(fileName);

        showSuccessMessage(`PDF gerado com sucesso! ${commissionsData.details.length} pagamentos processados.`);

    } catch (error) {
        console.error('Erro ao gerar PDF das comissões:', error);
        showErrorMessage('Erro ao gerar PDF das comissões: ' + error.message);
    }
}

// Carregar categorias de despesas
async function loadExpenseCategories() {
    console.log('🔄 Iniciando carregamento de categorias de despesas...');
    try {
        const { data, error } = await supabase
            .from('expense_categories')
            .select('*')
            .eq('is_active', true)
            .order('name');
            
        if (error) {
            console.error('❌ Erro na consulta do Supabase:', error);
            throw error;
        }
        
        console.log('✅ Dados recebidos do Supabase:', data);
        expenseCategories = data || [];
        console.log('📊 Categorias carregadas:', expenseCategories.length);
        updateExpenseCategorySelect();
        
    } catch (error) {
        console.error('❌ Erro ao carregar categorias de despesas:', error);
        
        // Tentar criar as categorias se a tabela não existir
        const created = await createDefaultCategories();
        if (created) {
            console.log('✅ Categorias criadas com sucesso, tentando carregar novamente...');
            // Tentar carregar novamente após criar
            try {
                const { data: retryData, error: retryError } = await supabase
                    .from('expense_categories')
                    .select('*')
                    .eq('is_active', true)
                    .order('name');
                
                if (!retryError && retryData) {
                    expenseCategories = retryData;
                    updateExpenseCategorySelect();
                    return;
                }
            } catch (retryError) {
                console.log('❌ Erro na segunda tentativa:', retryError);
            }
        }
        
        console.log('🔄 Usando categorias padrão locais...');
        // Se não conseguir carregar, usar categorias padrão
        expenseCategories = [
            { id: 'default-alimentacao', name: 'Alimentação' },
            { id: 'default-transporte', name: 'Transporte' },
            { id: 'default-escritorio', name: 'Escritório' },
            { id: 'default-marketing', name: 'Marketing' },
            { id: 'default-outros', name: 'Outros' }
        ];
        updateExpenseCategorySelect();
    }
}

// Atualizar select de categorias
function updateExpenseCategorySelect() {
    console.log('🔄 Atualizando select de categorias...');
    const select = document.getElementById('expenseCategory');
    if (!select) {
        console.error('❌ Elemento expenseCategory não encontrado!');
        return;
    }
    
    console.log('📋 Select encontrado, limpando opções existentes...');
    // Limpar opções existentes (exceto a primeira)
    while (select.children.length > 1) {
        select.removeChild(select.lastChild);
    }
    
    console.log('📝 Adicionando', expenseCategories.length, 'categorias...');
    // Adicionar categorias carregadas
    expenseCategories.forEach(category => {
        console.log('➕ Adicionando categoria:', category.name, '(ID:', category.id, ')');
        const option = document.createElement('option');
        option.value = category.id;
        option.textContent = category.name;
        select.appendChild(option);
    });
    
    console.log('✅ Select de categorias atualizado com sucesso! Total de opções:', select.children.length);
}

// Função para forçar reload das categorias (pode ser chamada do console)
window.reloadCategories = async function() {
    console.log('🔄 Forçando reload das categorias...');
    try {
        await loadExpenseCategories();
        console.log('✅ Categorias recarregadas com sucesso!');
    } catch (error) {
        console.error('❌ Erro ao recarregar categorias:', error);
    }
}

// Função para testar conectividade com categorias
async function testCategoriesConnection() {
    console.log('🧪 Testando conectividade com tabela expense_categories...');
    try {
        // Primeiro, verificar se a tabela existe
        const { data: tables, error: tablesError } = await supabase
            .from('information_schema.tables')
            .select('table_name')
            .eq('table_schema', 'public')
            .eq('table_name', 'expense_categories');
            
        if (tablesError) {
            console.error('❌ Erro ao verificar tabelas:', tablesError);
            return false;
        }
        
        console.log('📋 Verificação de tabela:', tables);
        
        // Tentar consultar todas as categorias (sem filtro is_active)
        const { data: allCategories, error: allError } = await supabase
            .from('expense_categories')
            .select('*');
            
        if (allError) {
            console.error('❌ Erro ao consultar todas as categorias:', allError);
            return false;
        }
        
        console.log('📊 Todas as categorias encontradas:', allCategories);
        
        // Tentar consultar apenas categorias ativas
        const { data: activeCategories, error: activeError } = await supabase
            .from('expense_categories')
            .select('*')
            .eq('is_active', true)
            .order('name');
            
        if (activeError) {
            console.error('❌ Erro ao consultar categorias ativas:', activeError);
            return false;
        }
        
        console.log('✅ Categorias ativas encontradas:', activeCategories);
        return true;
        
    } catch (error) {
        console.error('❌ Erro no teste de conectividade:', error);
        return false;
    }
}

// Função para criar categorias padrão se não existirem
async function createDefaultCategories() {
    console.log('🔄 Tentando criar categorias padrão...');
    try {
        // Tentar inserir categorias padrão (a tabela deve existir)
        const defaultCategories = [
            { name: 'Alimentação', description: 'Despesas com comida e bebidas', color: '#EF4444', icon: 'utensils' },
            { name: 'Transporte', description: 'Despesas com locomoção', color: '#3B82F6', icon: 'car' },
            { name: 'Escritório', description: 'Material de escritório e equipamentos', color: '#8B5CF6', icon: 'briefcase' },
            { name: 'Marketing', description: 'Despesas com publicidade e marketing', color: '#F59E0B', icon: 'megaphone' },
            { name: 'Tecnologia', description: 'Equipamentos e software', color: '#10B981', icon: 'laptop' },
            { name: 'Saúde', description: 'Despesas médicas e farmácia', color: '#EC4899', icon: 'heart' },
            { name: 'Educação', description: 'Cursos, livros e treinamentos', color: '#6366F1', icon: 'book' },
            { name: 'Limpeza', description: 'Produtos de limpeza e higiene', color: '#14B8A6', icon: 'spray' },
            { name: 'Manutenção', description: 'Reparos e manutenções', color: '#F97316', icon: 'wrench' },
            { name: 'Outros', description: 'Despesas diversas', color: '#6B7280', icon: 'folder' }
        ];
        
        // Tentar inserir uma categoria por vez para evitar conflitos
        let insertedCount = 0;
        for (const category of defaultCategories) {
            try {
                const { data, error } = await supabase
                    .from('expense_categories')
                    .insert([category])
                    .select();
                    
                if (!error && data) {
                    insertedCount++;
                    console.log(`✅ Categoria "${category.name}" criada`);
                } else if (error.code === '23505') {
                    // Erro de duplicata - categoria já existe
                    console.log(`ℹ️ Categoria "${category.name}" já existe`);
                } else {
                    console.log(`⚠️ Erro ao criar categoria "${category.name}":`, error);
                }
            } catch (catError) {
                console.log(`❌ Erro ao processar categoria "${category.name}":`, catError);
            }
        }
        
        console.log(`📊 Processo concluído. ${insertedCount} categorias criadas.`);
        return insertedCount > 0;
        
    } catch (error) {
        console.error('❌ Erro ao criar categorias padrão:', error);
        return false;
    }
}

// ===================================================
// FUNCIONALIDADES DE PARCELAMENTO
// ===================================================

// Variáveis globais para parcelamento
let currentInstallmentId = null;
let currentInstallmentPaymentId = null;

// Abrir modal de novo parcelamento
function openInstallmentModal() {
    // Limpar formulário
    document.getElementById('newInstallmentForm').reset();
    document.getElementById('installmentSummary').classList.add('hidden');
    
    // Carregar clientes
    loadClientsForInstallment();
    
    // Definir data padrão como próximo mês
    const nextMonth = new Date();
    nextMonth.setMonth(nextMonth.getMonth() + 1);
    document.getElementById('installmentFirstDueDate').value = nextMonth.toISOString().split('T')[0];
    
    // Limpar dataset do modal (será definido pela função createInstallmentForClient se necessário)
    const modal = document.getElementById('newInstallmentModal');
    delete modal.dataset.loanId;
    
    newInstallmentModal.classList.remove('hidden');
}

// Carregar clientes para parcelamento
async function loadClientsForInstallment() {
    try {
        const { data: allClients, error } = await supabase
            .from('clients')
            .select('id, name, cpf')
            .order('name', { ascending: true });

        if (error) throw error;

        const clientSelect = document.getElementById('installmentClientId');
        clientSelect.innerHTML = '<option value="">Ou selecione da lista completa</option>';

        allClients.forEach(client => {
            const option = document.createElement('option');
            option.value = client.id;
            const cpfText = client.cpf ? ` - CPF: ${client.cpf}` : '';
            option.textContent = `${client.name}${cpfText}`;
            clientSelect.appendChild(option);
        });

    } catch (error) {
        console.error('Erro ao carregar clientes:', error);
        showNotification('Erro ao carregar clientes', 'error');
    }
}



// Atualizar informações quando um cliente é selecionado
document.getElementById('installmentClientId').addEventListener('change', function() {
    // Esconder o resumo quando os dados mudarem
    document.getElementById('installmentSummary').classList.add('hidden');
});

// Calcular parcelamento
document.getElementById('calculateInstallment').addEventListener('click', function() {
    const totalAmount = parseFloat(document.getElementById('installmentTotalAmount').value);
    const totalInstallments = parseInt(document.getElementById('installmentTotalInstallments').value);
    const interestRate = parseFloat(document.getElementById('installmentInterestRate').value) || 0;

    if (!totalAmount || !totalInstallments) {
        showNotification('Preencha o valor total e número de parcelas', 'error');
        return;
    }

    // Calcular com juros compostos
    let installmentAmount, totalWithInterest, totalInterest;

    if (interestRate > 0) {
        const monthlyRate = interestRate / 100;
        const factor = Math.pow(1 + monthlyRate, totalInstallments);
        installmentAmount = totalAmount * (monthlyRate * factor) / (factor - 1);
        totalWithInterest = installmentAmount * totalInstallments;
        totalInterest = totalWithInterest - totalAmount;
    } else {
        installmentAmount = totalAmount / totalInstallments;
        totalWithInterest = totalAmount;
        totalInterest = 0;
    }

    // Atualizar resumo
    document.getElementById('calculatedInstallmentAmount').textContent = `R$ ${installmentAmount.toFixed(2)}`;
    document.getElementById('calculatedTotalWithInterest').textContent = `R$ ${totalWithInterest.toFixed(2)}`;
    document.getElementById('calculatedTotalInterest').textContent = `R$ ${totalInterest.toFixed(2)}`;

    // Mostrar resumo
    document.getElementById('installmentSummary').classList.remove('hidden');
});

// Criar parcelamento - VERSÃO CORRIGIDA SEM REFERÊNCIAS A loanId
document.getElementById('newInstallmentForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    const clientId = document.getElementById('installmentClientId').value;
    const totalAmount = parseFloat(document.getElementById('installmentTotalAmount').value);
    const totalInstallments = parseInt(document.getElementById('installmentTotalInstallments').value);
    const interestRate = parseFloat(document.getElementById('installmentInterestRate').value) || 0;
    const firstDueDate = document.getElementById('installmentFirstDueDate').value;
    const notes = document.getElementById('installmentNotes').value;

    if (!clientId || !totalAmount || !totalInstallments || !firstDueDate) {
        showNotification('Preencha todos os campos obrigatórios', 'error');
        return;
    }

    try {
        // Verificar se o usuário está autenticado
        if (!currentUser || !currentUser.id) {
            showNotification('Usuário não autenticado. Faça login novamente.', 'error');
            return;
        }

        // Verificar se o Supabase está inicializado
        if (!supabase) {
            showNotification('Erro de configuração. Recarregue a página.', 'error');
            return;
        }

        // Calcular valor da parcela
        let installmentAmount;
        if (interestRate > 0) {
            const monthlyRate = interestRate / 100;
            const factor = Math.pow(1 + monthlyRate, totalInstallments);
            installmentAmount = totalAmount * (monthlyRate * factor) / (factor - 1);
        } else {
            installmentAmount = totalAmount / totalInstallments;
        }

        // Verificar se há um loan_id associado (parcelamento de empréstimo específico)
        const modal = document.getElementById('newInstallmentModal');
        let associatedLoanId = null;
        
        // Verificar se o modal existe e tem dataset
        if (modal && modal.dataset && modal.dataset.loanId) {
            associatedLoanId = modal.dataset.loanId;
        }

        // Criar parcelamento - SEMPRE INDEPENDENTE POR PADRÃO
        const installmentData = {
            client_id: clientId,
            total_amount: totalAmount,
            total_installments: totalInstallments,
            installment_amount: installmentAmount,
            first_due_date: firstDueDate,
            interest_rate: interestRate,
            notes: notes,
            created_by: currentUser.id
            // loan_id será NULL por padrão (parcelamento independente)
        };

        // APENAS incluir loan_id se explicitamente fornecido
        if (associatedLoanId) {
            installmentData.loan_id = associatedLoanId;
        }

        const { data: installmentResult, error: installmentError } = await supabase
            .from('installments')
            .insert([installmentData])
            .select()
            .single();

        if (installmentError) throw installmentError;

        // Criar parcelas individuais
        const installmentPaymentsData = [];
        const firstDate = new Date(firstDueDate);

        for (let i = 1; i <= totalInstallments; i++) {
            const dueDate = new Date(firstDate);
            dueDate.setMonth(dueDate.getMonth() + (i - 1));

            installmentPaymentsData.push({
                installment_id: installmentResult.id,
                installment_number: i,
                amount: installmentAmount,
                due_date: dueDate.toISOString().split('T')[0]
            });
        }

        const { error: paymentsError } = await supabase
            .from('installment_payments')
            .insert(installmentPaymentsData);

        if (paymentsError) throw paymentsError;

        // APENAS atualizar empréstimo se houver loan_id associado
        if (associatedLoanId) {
            try {
                const { error: loanUpdateError } = await supabase
                    .from('loans')
                    .update({ status: 'partial_paid' })
                    .eq('id', associatedLoanId);

                if (loanUpdateError) {
                    console.warn('Aviso: Não foi possível atualizar o status do empréstimo:', loanUpdateError);
                }
            } catch (loanError) {
                console.warn('Erro ao atualizar empréstimo:', loanError);
                // Não falhar a criação do parcelamento por causa disso
            }
        }

        closeInstallmentModal();
        showNotification('Parcelamento criado com sucesso!', 'success');
        loadInstallments();
        
    } catch (error) {
        console.error('Erro ao criar parcelamento:', error);
        
        // Tratar erros de autenticação primeiro
        if (handleAuthError(error)) {
            return;
        }
        
        // Tratar outros tipos de erro
        if (error.message) {
            showNotification(`Erro ao criar parcelamento: ${error.message}`, 'error');
        } else {
            showNotification('Erro ao criar parcelamento. Tente novamente.', 'error');
        }
    }
});

// Fechar modal de parcelamento
function closeInstallmentModal() {
    newInstallmentModal.classList.add('hidden');
}

// Carregar parcelamentos ativos
async function loadInstallments() {
    try {
        const { data, error } = await supabase
            .from('installments')
            .select(`
                *,
                clients (name),
                loans (amount, due_date),
                installment_payments (status, due_date, paid_date)
            `)
            .eq('status', 'active')
            .order('created_at', { ascending: false });

        if (error) throw error;

        installments = data || [];
        filteredInstallments = [...installments]; // Inicializar filteredInstallments
        renderInstallmentsTable();

    } catch (error) {
        console.error('Erro ao carregar parcelamentos:', error);
        showNotification('Erro ao carregar parcelamentos', 'error');
    }
}

// Renderizar tabela de parcelamentos ativos
function renderInstallmentsTable() {
    const tableBody = document.getElementById('activeInstallmentsTableBody');
    
    if (!tableBody) return;

    // Verificar se há filtros ativos
    const searchInput = document.getElementById('installmentSearchInput');
    const creationDateFrom = document.getElementById('installmentCreationDateFrom');
    const creationDateTo = document.getElementById('installmentCreationDateTo');
    const dueDateFrom = document.getElementById('installmentDueDateFrom');
    const dueDateTo = document.getElementById('installmentDueDateTo');
    const sortBy = document.getElementById('installmentSortBy');
    
    const hasActiveFilters = (searchInput && searchInput.value.trim() !== '') ||
                           (creationDateFrom && creationDateFrom.value !== '') ||
                           (creationDateTo && creationDateTo.value !== '') ||
                           (dueDateFrom && dueDateFrom.value !== '') ||
                           (dueDateTo && dueDateTo.value !== '') ||
                           (sortBy && sortBy.value !== 'created_at');
    
    const installmentsToShow = hasActiveFilters ? filteredInstallments : installments;

    if (installmentsToShow.length === 0) {
        const message = installments.length === 0 
            ? 'Nenhum parcelamento ativo encontrado'
            : 'Nenhum parcelamento encontrado com os critérios de busca';
        
        tableBody.innerHTML = `
            <tr>
                <td colspan="7" class="px-6 py-4 text-center text-gray-400">
                    ${message}
                </td>
            </tr>
        `;
        return;
    }

    tableBody.innerHTML = installmentsToShow.map(installment => {
        // Calcular próximo vencimento
        const unpaidPayments = installment.installment_payments.filter(p => p.status === 'pending');
        const nextDueDate = unpaidPayments.length > 0 
            ? formatDate(unpaidPayments[0].due_date) 
            : 'Todas pagas';

        // Calcular progresso
        const paidCount = installment.installment_payments.filter(p => p.status === 'paid').length;
        const progress = `${paidCount}/${installment.total_installments}`;

        const statusClass = installment.status === 'completed' ? 'bg-green-900 text-green-300' : 'bg-blue-900 text-blue-300';

        return `
            <tr class="table-row hover:bg-gray-700 transition-colors">
                <td class="px-6 py-4 text-white">${installment.clients.name}</td>
                <td class="px-6 py-4 text-white">R$ ${installment.total_amount.toFixed(2)}</td>
                <td class="px-6 py-4 text-white">${progress}</td>
                <td class="px-6 py-4 text-white">R$ ${installment.installment_amount.toFixed(2)}</td>
                <td class="px-6 py-4 text-white">${nextDueDate}</td>
                <td class="px-6 py-4">
                    <span class="px-2 py-1 text-xs font-medium rounded-full ${statusClass}">
                        ${installment.status === 'completed' ? 'Concluído' : 'Ativo'}
                    </span>
                </td>
                <td class="px-6 py-4">
                    <button onclick="viewInstallmentDetails('${installment.id}')" 
                            class="text-blue-400 hover:text-blue-300 text-sm font-medium mr-3">
                        Ver Detalhes
                    </button>
                    <button onclick="showPixKeySelectorForInstallment('${installment.id}')" 
                            class="text-green-400 hover:text-green-300 text-sm font-medium mr-3" 
                            title="Enviar cobrança via WhatsApp">
                        💬 WhatsApp
                    </button>
                    <button onclick="cancelInstallment('${installment.id}')" 
                            class="text-red-400 hover:text-red-300 text-sm font-medium">
                        Cancelar
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

// Ver detalhes do parcelamento
async function viewInstallmentDetails(installmentId) {
    try {
        const { data, error } = await supabase
            .from('installments')
            .select(`
                *,
                clients (name, cpf),
                loans (amount, due_date),
                installment_payments (*)
            `)
            .eq('id', installmentId)
            .single();

        if (error) throw error;

        currentInstallmentId = installmentId;
        populateInstallmentDetailsModal(data);
        installmentDetailsModal.classList.remove('hidden');

    } catch (error) {
        console.error('Erro ao carregar detalhes do parcelamento:', error);
        showNotification('Erro ao carregar detalhes do parcelamento', 'error');
    }
}

// Preencher modal de detalhes do parcelamento
function populateInstallmentDetailsModal(installmentData) {
    const header = document.getElementById('installmentDetailsHeader');
    
    const paidCount = installmentData.installment_payments.filter(p => p.status === 'paid').length;
    const totalPaid = installmentData.installment_payments
        .filter(p => p.status === 'paid')
        .reduce((sum, p) => sum + (p.paid_amount || 0), 0);

    header.innerHTML = `
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
                <h4 class="text-lg font-semibold text-white mb-2">${installmentData.clients.name}</h4>
                <p class="text-blue-300 text-sm">CPF: ${installmentData.clients.cpf}</p>
            </div>
            <div>
                <p class="text-blue-300 text-sm">Valor Total</p>
                <p class="text-white font-semibold">R$ ${installmentData.total_amount.toFixed(2)}</p>
            </div>
            <div>
                <p class="text-blue-300 text-sm">Progresso</p>
                <p class="text-white font-semibold">${paidCount}/${installmentData.total_installments} parcelas</p>
            </div>
            <div>
                <p class="text-blue-300 text-sm">Total Pago</p>
                <p class="text-white font-semibold">R$ ${totalPaid.toFixed(2)}</p>
            </div>
        </div>
        ${installmentData.notes ? `<div class="mt-4"><p class="text-gray-300 text-sm"><strong>Observações:</strong> ${installmentData.notes}</p></div>` : ''}
    `;

    // Renderizar tabela de parcelas
    const tableBody = document.getElementById('installmentPaymentsTableBody');
    tableBody.innerHTML = installmentData.installment_payments.map(payment => {
        const statusColors = {
            'pending': 'bg-yellow-900 text-yellow-300',
            'paid': 'bg-green-900 text-green-300',
            'overdue': 'bg-red-900 text-red-300',
            'partial': 'bg-orange-900 text-orange-300'
        };

        const statusLabels = {
            'pending': 'Pendente',
            'paid': 'Paga',
            'overdue': 'Vencida',
            'partial': 'Parcial'
        };

        // Verificar se está vencida
        const isOverdue = payment.status === 'pending' && new Date(payment.due_date) < new Date();
        const currentStatus = isOverdue ? 'overdue' : payment.status;

        return `
            <tr class="table-row hover:bg-gray-700 transition-colors">
                <td class="px-6 py-4 text-white">${payment.installment_number}ª</td>
                <td class="px-6 py-4 text-white">R$ ${payment.amount.toFixed(2)}</td>
                <td class="px-6 py-4 text-white">${formatDate(payment.due_date)}</td>
                <td class="px-6 py-4">
                    <span class="px-2 py-1 text-xs font-medium rounded-full ${statusColors[currentStatus]}">
                        ${statusLabels[currentStatus]}
                    </span>
                </td>
                <td class="px-6 py-4 text-white">${payment.paid_date ? formatDate(payment.paid_date) : '-'}</td>
                <td class="px-6 py-4 text-white">${payment.paid_amount ? `R$ ${payment.paid_amount.toFixed(2)}` : '-'}</td>
                <td class="px-6 py-4">
                    ${payment.status !== 'paid' ? 
                        `<button onclick="openInstallmentPaymentModal('${payment.id}')" 
                                class="text-blue-400 hover:text-blue-300 text-sm font-medium">
                            Pagar
                        </button>` : 
                        `<span class="text-gray-500 text-sm">Paga</span>`
                    }
                </td>
            </tr>
        `;
    }).join('');
}

// Abrir modal de pagamento de parcela
async function openInstallmentPaymentModal(paymentId) {
    try {
        const { data, error } = await supabase
            .from('installment_payments')
            .select(`
                *,
                installments (
                    clients (name),
                    installment_amount
                )
            `)
            .eq('id', paymentId)
            .single();

        if (error) throw error;

        currentInstallmentPaymentId = paymentId;

        // Preencher informações da parcela
        const paymentInfo = document.getElementById('installmentPaymentInfo');
        paymentInfo.innerHTML = `
            <h4 class="text-white font-semibold mb-2">${data.installments.clients.name}</h4>
            <div class="grid grid-cols-2 gap-4 text-sm">
                <div>
                    <span class="text-blue-300">Parcela:</span>
                    <p class="text-white">${data.installment_number}ª de ${data.installments.total_installments}</p>
                </div>
                <div>
                    <span class="text-blue-300">Valor:</span>
                    <p class="text-white">R$ ${data.amount.toFixed(2)}</p>
                </div>
                <div>
                    <span class="text-blue-300">Vencimento:</span>
                    <p class="text-white">${formatDate(data.due_date)}</p>
                </div>
                <div>
                    <span class="text-blue-300">Status:</span>
                    <p class="text-white">${data.status === 'pending' ? 'Pendente' : data.status === 'overdue' ? 'Vencida' : data.status}</p>
                </div>
            </div>
        `;

        // Definir valor padrão
        document.getElementById('installmentPaidAmount').value = data.amount.toFixed(2);
        
        // Definir data padrão como hoje
        document.getElementById('installmentPaidDate').value = formatDateForInput(new Date());
        
        // Definir método de pagamento padrão como dinheiro
        document.getElementById('installmentPaymentMethod').value = 'dinheiro';

        installmentPaymentModal.classList.remove('hidden');

    } catch (error) {
        console.error('Erro ao carregar dados da parcela:', error);
        showNotification('Erro ao carregar dados da parcela', 'error');
    }
}

// Registrar pagamento de parcela
document.getElementById('installmentPaymentForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    const paidAmount = parseFloat(document.getElementById('installmentPaidAmount').value);
    const paidDate = document.getElementById('installmentPaidDate').value;
    const paymentMethod = document.getElementById('installmentPaymentMethod').value;
    const notes = document.getElementById('installmentPaymentNotes').value;

    if (!paidAmount || !paidDate) {
        showNotification('Preencha o valor pago e a data', 'error');
        return;
    }
    
    // Validar método de pagamento permitido para parcelamentos
    const allowedPaymentMethods = ['dinheiro', 'pix'];
    if (!paymentMethod || !allowedPaymentMethods.includes(paymentMethod)) {
        showNotification('Selecione um método de pagamento válido (Dinheiro ou PIX)', 'error');
        return;
    }

    try {
        // Buscar dados da parcela para comparar valores
        const { data: paymentData, error: fetchError } = await supabase
            .from('installment_payments')
            .select('amount')
            .eq('id', currentInstallmentPaymentId)
            .single();

        if (fetchError) throw fetchError;

        // Determinar status do pagamento
        let paymentStatus = 'paid';
        if (paidAmount < paymentData.amount) {
            paymentStatus = 'partial';
        }

        // Atualizar pagamento
        const { error } = await supabase
            .from('installment_payments')
            .update({
                paid_amount: paidAmount,
                paid_date: paidDate,
                status: paymentStatus,
                payment_method: paymentMethod,
                notes: notes,
                updated_at: new Date().toISOString()
            })
            .eq('id', currentInstallmentPaymentId);

        if (error) throw error;

        closeInstallmentPaymentModal();
        
        // Buscar dados do cliente para o modal de mensagens
        const { data: installmentData, error: installmentError } = await supabase
            .from('installments')
            .select(`
                *,
                clients (name, phone)
            `)
            .eq('id', currentInstallmentId)
            .single();

        if (!installmentError && installmentData) {
            // Calcular próxima data de pagamento (próxima parcela)
            const { data: nextPayment, error: nextError } = await supabase
                .from('installment_payments')
                .select('due_date')
                .eq('installment_id', currentInstallmentId)
                .eq('status', 'pending')
                .order('due_date', { ascending: true })
                .limit(1)
                .single();

            let nextPaymentDate = '';
            if (!nextError && nextPayment) {
                nextPaymentDate = formatDate(nextPayment.due_date);
            } else {
                // Se não há próxima parcela, o parcelamento foi quitado
                nextPaymentDate = 'Parcelamento quitado';
            }

            // Preparar informações do pagamento para o modal
            const paymentInfo = {
                amount: paidAmount,
                type: paymentMethod,
                date: paidDate,
                isFullyPaid: paymentStatus === 'paid' && !nextPayment,
                isInstallment: true
            };

            // Configurar dados para o modal
            window.currentPaymentMessageData = {
                clientName: installmentData.clients.name,
                clientPhone: installmentData.clients.phone,
                nextPaymentDate: nextPaymentDate,
                paymentInfo: paymentInfo
            };

            // Mostrar modal de mensagens
            showModal(document.getElementById('paymentMessageModal'));

            // Pré-selecionar tipo de mensagem
            setTimeout(() => {
                const messageType = paymentInfo.isFullyPaid ? 'quitacao' : 'lembrete';
                const radioButton = document.querySelector(`input[name="messageType"][value="${messageType}"]`);
                if (radioButton) {
                    radioButton.checked = true;
                    radioButton.dispatchEvent(new Event('change'));
                }
            }, 100);
        } else {
            showNotification('Pagamento registrado com sucesso!', 'success');
        }
        
        // Recarregar detalhes do parcelamento
        if (currentInstallmentId) {
            viewInstallmentDetails(currentInstallmentId);
        }
        
        loadInstallments();

    } catch (error) {
        console.error('Erro ao registrar pagamento:', error);
        showNotification('Erro ao registrar pagamento', 'error');
    }
});

// Fechar modais
function closeInstallmentDetailsModal() {
    installmentDetailsModal.classList.add('hidden');
}

function closeInstallmentPaymentModal() {
    installmentPaymentModal.classList.add('hidden');
    document.getElementById('installmentPaymentForm').reset();
}

// Cancelar parcelamento
async function cancelInstallment(installmentId) {
    if (!confirm('Tem certeza que deseja cancelar este parcelamento?')) {
        return;
    }

    try {
        const { error } = await supabase
            .from('installments')
            .update({ status: 'cancelled' })
            .eq('id', installmentId);

        if (error) throw error;

        showNotification('Parcelamento cancelado com sucesso!', 'success');
        loadInstallments();

    } catch (error) {
        console.error('Erro ao cancelar parcelamento:', error);
        showNotification('Erro ao cancelar parcelamento', 'error');
    }
}

// Carregar empréstimos vencidos para a tabela de parcelamento
async function loadOverdueLoansForInstallmentTable() {
    try {
        const { data: overdueLoans, error } = await supabase
            .from('loans')
            .select(`
                id,
                client_id,
                amount,
                total_amount,
                due_date,
                clients (name)
            `)
            .lt('due_date', new Date().toISOString())
            .eq('status', 'active')
            .order('due_date', { ascending: true });

        if (error) throw error;

        const tableBody = document.getElementById('overdueForInstallmentTableBody');
        
        if (!tableBody) return;

        if (overdueLoans.length === 0) {
            tableBody.innerHTML = `
                <tr>
                    <td colspan="5" class="px-6 py-4 text-center text-gray-400">
                        Nenhum empréstimo vencido encontrado
                    </td>
                </tr>
            `;
            return;
        }

        tableBody.innerHTML = overdueLoans.map(loan => {
            const daysOverdue = Math.floor((new Date() - new Date(loan.due_date)) / (1000 * 60 * 60 * 24));
            
            return `
                <tr class="table-row hover:bg-gray-700 transition-colors">
                    <td class="px-6 py-4 text-white">${loan.clients.name}</td>
                    <td class="px-6 py-4 text-white">R$ ${loan.amount.toFixed(2)}</td>
                    <td class="px-6 py-4 text-white">R$ ${loan.total_amount.toFixed(2)}</td>
                    <td class="px-6 py-4">
                        <span class="px-2 py-1 text-xs font-medium rounded-full bg-red-900 text-red-300">
                            ${daysOverdue} dias
                        </span>
                    </td>
                    <td class="px-6 py-4">
                        <button onclick="createInstallmentForClient('${loan.client_id}')" 
                                class="text-blue-400 hover:text-blue-300 text-sm font-medium">
                            Parcelar
                        </button>
                    </td>
                </tr>
            `;
        }).join('');

    } catch (error) {
        console.error('Erro ao carregar empréstimos vencidos:', error);
        showNotification('Erro ao carregar empréstimos vencidos', 'error');
    }
}

// Criar parcelamento para um cliente específico
function createInstallmentForClient(clientId, loanId = null) {
    openInstallmentModal();
    
    // Armazenar o loanId no modal para usar na criação do parcelamento
    const modal = document.getElementById('newInstallmentModal');
    if (loanId) {
        modal.dataset.loanId = loanId;
    } else {
        delete modal.dataset.loanId;
    }
    
    // Aguardar um pouco para o modal carregar
    setTimeout(() => {
        // Selecionar o cliente
        const clientSelect = document.getElementById('installmentClientId');
        clientSelect.value = clientId;
        
        // Trigger change event
        const clientChangeEvent = new Event('change');
        clientSelect.dispatchEvent(clientChangeEvent);
    }, 100);
}

// Event listeners para modais
document.getElementById('closeInstallmentModal').addEventListener('click', closeInstallmentModal);
document.getElementById('cancelInstallment').addEventListener('click', closeInstallmentModal);
document.getElementById('closeInstallmentDetailsModal').addEventListener('click', closeInstallmentDetailsModal);
document.getElementById('closeInstallmentPaymentModal').addEventListener('click', closeInstallmentPaymentModal);
document.getElementById('cancelInstallmentPayment').addEventListener('click', closeInstallmentPaymentModal);

// Fechar modais ao clicar fora
newInstallmentModal.addEventListener('click', function(e) {
    if (e.target === this) closeInstallmentModal();
});

installmentDetailsModal.addEventListener('click', function(e) {
    if (e.target === this) closeInstallmentDetailsModal();
});

installmentPaymentModal.addEventListener('click', function(e) {
    if (e.target === this) closeInstallmentPaymentModal();
});

// ===================================================
// FIM DAS FUNCIONALIDADES DE PARCELAMENTO
// ===================================================

// ===================================================
// FUNCIONALIDADES DE EMPRÉSTIMOS VENCIDOS
// ===================================================

// Carregar empréstimos vencidos para a aba dedicada
async function loadOverdueLoans() {
    try {
        const { data: overdueLoans, error } = await supabase
            .from('loans')
            .select(`
                id,
                client_id,
                amount,
                total_amount,
                due_date,
                interest_rate,
                created_at,
                clients (name, phone)
            `)
            .lt('due_date', new Date().toISOString())
            .eq('status', 'active')
            .order('due_date', { ascending: true });

        if (error) throw error;

        const tableBody = document.getElementById('overdueLoansTableBody');
        
        if (!tableBody) return;

        if (overdueLoans.length === 0) {
            tableBody.innerHTML = `
                <tr>
                    <td colspan="7" class="px-6 py-4 text-center text-gray-400">
                        Nenhum empréstimo vencido encontrado
                    </td>
                </tr>
            `;
            return;
        }

        tableBody.innerHTML = overdueLoans.map(loan => {
            const daysOverdue = Math.floor((new Date() - new Date(loan.due_date)) / (1000 * 60 * 60 * 24));
            const dailyInterestRate = (loan.interest_rate || 0) / 30; // Juros diário aproximado
            const accumulatedInterest = (loan.total_amount * dailyInterestRate * daysOverdue) / 100;
            
            return `
                <tr class="table-row hover:bg-gray-700 transition-colors">
                    <td class="px-6 py-4 text-white">
                        <div>
                            <div class="font-medium">${loan.clients.name}</div>
                            <div class="text-sm text-gray-400">${loan.clients.phone || ''}</div>
                        </div>
                    </td>
                    <td class="px-6 py-4 text-white">R$ ${loan.amount.toFixed(2)}</td>
                    <td class="px-6 py-4 text-white">R$ ${loan.total_amount.toFixed(2)}</td>
                    <td class="px-6 py-4 text-white">${formatDate(loan.due_date)}</td>
                    <td class="px-6 py-4">
                        <span class="px-2 py-1 text-xs font-medium rounded-full ${
                            daysOverdue <= 30 ? 'bg-yellow-900 text-yellow-300' : 
                            daysOverdue <= 60 ? 'bg-orange-900 text-orange-300' : 
                            'bg-red-900 text-red-300'
                        }">
                            ${daysOverdue} dias
                        </span>
                    </td>
                    <td class="px-6 py-4 text-white">R$ ${accumulatedInterest.toFixed(2)}</td>
                    <td class="px-6 py-4">
                        <div class="flex space-x-2">
                            <button onclick="sendToInstallment('${loan.id}')" 
                                    class="bg-blue-600 hover:bg-blue-500 text-white px-3 py-1 rounded text-sm font-medium transition-colors">
                                Parcelar
                            </button>
                            <button onclick="contactClient('${loan.client_id}', '${loan.clients.phone || ''}')" 
                                    class="bg-green-600 hover:bg-green-500 text-white px-3 py-1 rounded text-sm font-medium transition-colors">
                                Contatar
                            </button>
                        </div>
                    </td>
                </tr>
            `;
        }).join('');

    } catch (error) {
        console.error('Erro ao carregar empréstimos vencidos:', error);
        showNotification('Erro ao carregar empréstimos vencidos', 'error');
    }
}

// Enviar cliente para a aba de parcelamento
function sendToInstallment(loanId) {
    // Encontrar o empréstimo para obter o client_id
    const loan = loans.find(l => l.id === loanId);
    if (!loan) {
        showNotification('Empréstimo não encontrado', 'error');
        return;
    }
    
    // Navegar para a aba de parcelamentos
    const installmentsLink = document.querySelector('a[href="#installments"]');
    if (installmentsLink) {
        installmentsLink.click();
    }
    
    // Aguardar um pouco para a aba carregar e abrir o modal de parcelamento
    setTimeout(() => {
        createInstallmentForClient(loan.client_id, loanId);
        showNotification('Cliente selecionado para parcelamento', 'success');
    }, 300);
}

// Função para contatar cliente (pode abrir WhatsApp ou mostrar informações)
function contactClient(clientId, phone) {
    if (phone && phone.trim()) {
        // Remover caracteres não numéricos do telefone
        const cleanPhone = phone.replace(/\D/g, '');
        
        // Criar mensagem padrão
        const message = encodeURIComponent('Olá! Entramos em contato sobre seu empréstimo em atraso. Podemos conversar sobre as opções de pagamento?');
        
        // Abrir WhatsApp
        const whatsappUrl = `https://wa.me/55${cleanPhone}?text=${message}`;
        window.open(whatsappUrl, '_blank');
        
        showNotification('Abrindo WhatsApp para contato', 'success');
    } else {
        showNotification('Telefone não cadastrado para este cliente', 'error');
    }
}

// ===================================================
// FIM DAS FUNCIONALIDADES DE EMPRÉSTIMOS VENCIDOS
// ===================================================

// ===================================================
// GESTÃO DE CAIXA
// ===================================================

// Carregar transações de caixa
async function loadCashTransactions() {
    try {
        const { data, error } = await supabase
            .from('cash_transactions')
            .select('*')
            .order('created_at', { ascending: false });
        
        if (error) throw error;
        
        cashTransactions = data || [];
        renderCashTransactionsTable();
        updateCashSummary();
        updateCashFlowChart();
        
    } catch (error) {
        console.error('Erro ao carregar transações de caixa:', error);
        cashTransactions = [];
    }
}

// Carregar configurações de caixa
async function loadCashSettings() {
    try {
        const { data, error } = await supabase
            .from('cash_settings')
            .select('*')
            .limit(1);
        
        if (error) throw error;
        
        cashSettings = data && data.length > 0 ? data[0] : null;
        updateCashBalance();
        
    } catch (error) {
        console.error('Erro ao carregar configurações de caixa:', error);
        cashSettings = null;
    }
}

// Atualizar saldo do caixa na interface
function updateCashBalance() {
    const balanceElement = document.getElementById('currentCashBalance');
    if (balanceElement && cashSettings) {
        balanceElement.textContent = `R$ ${cashSettings.current_balance.toFixed(2).replace('.', ',')}`;
    }
}

// Atualizar resumo mensal de caixa
function updateCashSummary() {
    const now = new Date();
    const firstDayOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    
    const monthlyTransactions = cashTransactions.filter(transaction => {
        const transactionDate = new Date(transaction.created_at);
        return transactionDate >= firstDayOfMonth;
    });
    
    const monthlyDeposits = monthlyTransactions
        .filter(t => t.transaction_type === 'deposit')
        .reduce((sum, t) => sum + parseFloat(t.amount), 0);
    
    const monthlyWithdrawals = monthlyTransactions
        .filter(t => t.transaction_type === 'withdrawal')
        .reduce((sum, t) => sum + parseFloat(t.amount), 0);
    
    const depositsElement = document.getElementById('monthlyDeposits');
    const withdrawalsElement = document.getElementById('monthlyWithdrawals');
    
    if (depositsElement) {
        depositsElement.textContent = `R$ ${monthlyDeposits.toFixed(2).replace('.', ',')}`;
    }
    
    if (withdrawalsElement) {
        withdrawalsElement.textContent = `R$ ${monthlyWithdrawals.toFixed(2).replace('.', ',')}`;
    }
}

// Renderizar tabela de transações de caixa
function renderCashTransactionsTable() {
    const tbody = document.getElementById('cashTransactionsTableBody');
    if (!tbody) return;
    
    tbody.innerHTML = '';
    
    if (cashTransactions.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="5" class="px-6 py-8 text-center text-gray-400">
                    Nenhuma transação encontrada
                </td>
            </tr>
        `;
        return;
    }
    
    cashTransactions.forEach(transaction => {
        const row = document.createElement('tr');
        row.className = 'table-row hover:bg-gray-800/50';
        
        const date = new Date(transaction.created_at);
        const formattedDate = date.toLocaleDateString('pt-BR') + ' ' + date.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' });
        const typeColor = transaction.transaction_type === 'deposit' ? 'text-green-400' : 'text-red-400';
        const typeIcon = transaction.transaction_type === 'deposit' ? '↗' : '↙';
        const typeText = transaction.transaction_type === 'deposit' ? 'Entrada' : 'Saída';
        
        row.innerHTML = `
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formattedDate}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm ${typeColor}">
                <span class="inline-flex items-center">
                    <span class="mr-2">${typeIcon}</span>
                    ${typeText}
                </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium ${typeColor}">
                R$ ${parseFloat(transaction.amount).toFixed(2).replace('.', ',')}
            </td>
            <td class="px-6 py-4 text-sm text-gray-300">${transaction.description || '-'}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                R$ ${parseFloat(transaction.balance_after).toFixed(2).replace('.', ',')}
            </td>
        `;
        
        tbody.appendChild(row);
    });
}

// Atualizar gráfico de fluxo de caixa
function updateCashFlowChart() {
    const ctx = document.getElementById('cashFlowChart');
    if (!ctx) return;
    
    // Destruir gráfico existente se houver
    if (charts.cashFlow) {
        charts.cashFlow.destroy();
    }
    
    // Preparar dados dos últimos 7 dias
    const last7Days = [];
    const today = new Date();
    
    for (let i = 6; i >= 0; i--) {
        const date = new Date(today);
        date.setDate(date.getDate() - i);
        last7Days.push({
            date: date.toISOString().split('T')[0],
            label: date.toLocaleDateString('pt-BR', { day: '2-digit', month: '2-digit' })
        });
    }
    
    const dailyData = last7Days.map(day => {
        const dayTransactions = cashTransactions.filter(transaction => {
            const transactionDate = new Date(transaction.created_at);
            return transactionDate.toISOString().split('T')[0] === day.date;
        });
        
        const deposits = dayTransactions
            .filter(t => t.transaction_type === 'deposit')
            .reduce((sum, t) => sum + parseFloat(t.amount), 0);
        
        const withdrawals = dayTransactions
            .filter(t => t.transaction_type === 'withdrawal')
            .reduce((sum, t) => sum + parseFloat(t.amount), 0);
        
        return {
            label: day.label,
            deposits,
            withdrawals,
            net: deposits - withdrawals
        };
    });
    
    charts.cashFlow = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: dailyData.map(d => d.label),
            datasets: [
                {
                    label: 'Entradas',
                    data: dailyData.map(d => d.deposits),
                    backgroundColor: 'rgba(34, 197, 94, 0.8)',
                    borderColor: 'rgba(34, 197, 94, 1)',
                    borderWidth: 1
                },
                {
                    label: 'Saídas',
                    data: dailyData.map(d => d.withdrawals),
                    backgroundColor: 'rgba(239, 68, 68, 0.8)',
                    borderColor: 'rgba(239, 68, 68, 1)',
                    borderWidth: 1
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    labels: {
                        color: 'white'
                    }
                }
            },
            scales: {
                x: {
                    ticks: {
                        color: 'white'
                    },
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)'
                    }
                },
                y: {
                    ticks: {
                        color: 'white',
                        callback: function(value) {
                            return 'R$ ' + value.toFixed(0);
                        }
                    },
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)'
                    }
                }
            }
        }
    });
}

// Adicionar dinheiro ao caixa
async function addMoney(amount, description) {
    try {
        const currentBalance = cashSettings ? parseFloat(cashSettings.current_balance) : 0;
        const newBalance = currentBalance + parseFloat(amount);
        
        // Inserir transação
        const { data, error } = await supabase
            .from('cash_transactions')
            .insert([{
                transaction_type: 'deposit',
                amount: parseFloat(amount),
                description: description || 'Depósito manual',
                reference_type: 'manual',
                balance_after: newBalance,
                created_by: currentUser?.id
            }])
            .select();
        
        if (error) throw error;
        
        // Atualizar manualmente o saldo na tabela cash_settings
        if (cashSettings) {
            const { error: updateError } = await supabase
                .from('cash_settings')
                .update({ 
                    current_balance: newBalance,
                    last_updated: new Date().toISOString(),
                    updated_by: currentUser?.id
                })
                .eq('id', cashSettings.id);
            
            if (updateError) {
                console.error('Erro ao atualizar saldo:', updateError);
            }
        } else {
            // Se não existe configuração, criar uma nova
            const { error: createError } = await supabase
                .from('cash_settings')
                .insert([{
                    current_balance: newBalance,
                    initial_balance: 0,
                    updated_by: currentUser?.id
                }]);
            
            if (createError) {
                console.error('Erro ao criar configuração de caixa:', createError);
            }
        }
        
        // Atualizar dados locais
        await loadCashTransactions();
        await loadCashSettings();
        
        showInfoMessage('Dinheiro adicionado com sucesso!');
        return true;
        
    } catch (error) {
        console.error('Erro ao adicionar dinheiro:', error);
        showInfoMessage('Erro ao adicionar dinheiro: ' + error.message);
        return false;
    }
}

// Retirar dinheiro do caixa
async function withdrawMoney(amount, description) {
    try {
        const currentBalance = cashSettings ? parseFloat(cashSettings.current_balance) : 0;
        
        if (parseFloat(amount) > currentBalance) {
            showInfoMessage('Saldo insuficiente para esta operação!');
            return false;
        }
        
        const newBalance = currentBalance - parseFloat(amount);
        
        // Inserir transação
        const { data, error } = await supabase
            .from('cash_transactions')
            .insert([{
                transaction_type: 'withdrawal',
                amount: parseFloat(amount),
                description: description || 'Saque manual',
                reference_type: 'manual',
                balance_after: newBalance,
                created_by: currentUser?.id
            }])
            .select();
        
        if (error) throw error;
        
        // Atualizar manualmente o saldo na tabela cash_settings
        if (cashSettings) {
            const { error: updateError } = await supabase
                .from('cash_settings')
                .update({ 
                    current_balance: newBalance,
                    last_updated: new Date().toISOString(),
                    updated_by: currentUser?.id
                })
                .eq('id', cashSettings.id);
            
            if (updateError) {
                console.error('Erro ao atualizar saldo:', updateError);
            }
        }
        
        // Atualizar dados locais
        await loadCashTransactions();
        await loadCashSettings();
        
        showInfoMessage('Dinheiro retirado com sucesso!');
        return true;
        
    } catch (error) {
        console.error('Erro ao retirar dinheiro:', error);
        showInfoMessage('Erro ao retirar dinheiro: ' + error.message);
        return false;
    }
}

// Gerar extrato do último mês
async function generateMonthlyStatement() {
    try {
        const now = new Date();
        const firstDayOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
        const lastDayOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0);
        
        const monthlyTransactions = cashTransactions.filter(transaction => {
            const transactionDate = new Date(transaction.created_at);
            return transactionDate >= firstDayOfMonth && transactionDate <= lastDayOfMonth;
        });
        
        if (monthlyTransactions.length === 0) {
            showInfoMessage('Não há transações no mês atual para gerar extrato.');
            return;
        }
        
        // Calcular totais
        const totalDeposits = monthlyTransactions
            .filter(t => t.transaction_type === 'deposit')
            .reduce((sum, t) => sum + parseFloat(t.amount), 0);
        
        const totalWithdrawals = monthlyTransactions
            .filter(t => t.transaction_type === 'withdrawal')
            .reduce((sum, t) => sum + parseFloat(t.amount), 0);
        
        const netBalance = totalDeposits - totalWithdrawals;
        
        // Preparar dados para o PDF
        const monthName = now.toLocaleDateString('pt-BR', { month: 'long', year: 'numeric' });
        
        // Criar PDF usando jsPDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();
        
        // Título
        doc.setFontSize(18);
        doc.text('EXTRATO DE CAIXA', 20, 20);
        doc.setFontSize(14);
        doc.text(`Período: ${monthName}`, 20, 30);
        
        // Resumo
        doc.setFontSize(12);
        doc.text('RESUMO DO MÊS:', 20, 45);
        doc.text(`Total de Entradas: R$ ${totalDeposits.toFixed(2).replace('.', ',')}`, 20, 55);
        doc.text(`Total de Saídas: R$ ${totalWithdrawals.toFixed(2).replace('.', ',')}`, 20, 65);
        doc.text(`Saldo Líquido: R$ ${netBalance.toFixed(2).replace('.', ',')}`, 20, 75);
        doc.text(`Saldo Atual: R$ ${(cashSettings?.current_balance || 0).toFixed(2).replace('.', ',')}`, 20, 85);
        
        // Linha separadora
        doc.line(20, 95, 190, 95);
        
        // Cabeçalho da tabela
        doc.text('DETALHAMENTO DAS TRANSAÇÕES:', 20, 105);
        doc.setFontSize(10);
        doc.text('Data/Hora', 20, 115);
        doc.text('Tipo', 60, 115);
        doc.text('Valor', 90, 115);
        doc.text('Descrição', 120, 115);
        
        // Linha do cabeçalho
        doc.line(20, 118, 190, 118);
        
        // Transações
        let yPosition = 125;
        monthlyTransactions.forEach((transaction, index) => {
            if (yPosition > 270) { // Nova página se necessário
                doc.addPage();
                yPosition = 20;
            }
            
            const date = new Date(transaction.created_at);
            const formattedDate = date.toLocaleDateString('pt-BR') + ' ' + date.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' });
            const type = transaction.transaction_type === 'deposit' ? 'Entrada' : 'Saída';
            const amount = `R$ ${parseFloat(transaction.amount).toFixed(2).replace('.', ',')}`;
            const description = transaction.description || '-';
            
            doc.text(formattedDate, 20, yPosition);
            doc.text(type, 60, yPosition);
            doc.text(amount, 90, yPosition);
            doc.text(description.substring(0, 25), 120, yPosition);
            
            yPosition += 8;
        });
        
        // Rodapé
        const totalPages = doc.internal.getNumberOfPages();
        for (let i = 1; i <= totalPages; i++) {
            doc.setPage(i);
            doc.setFontSize(8);
            doc.text(`Página ${i} de ${totalPages}`, 170, 285);
            doc.text(`Gerado em: ${new Date().toLocaleString('pt-BR')}`, 20, 285);
        }
        
        // Salvar o PDF
        doc.save(`Extrato_Caixa_${monthName.replace(' ', '_')}.pdf`);
        
        showInfoMessage('Extrato gerado com sucesso!');
        
    } catch (error) {
        console.error('Erro ao gerar extrato:', error);
        showInfoMessage('Erro ao gerar extrato: ' + error.message);
    }
}

// Event listeners para os formulários de caixa
document.addEventListener('DOMContentLoaded', function() {
    // Formulário de adicionar dinheiro
    const addMoneyForm = document.getElementById('addMoneyForm');
    if (addMoneyForm) {
        addMoneyForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const amount = document.getElementById('depositAmount').value;
            const description = document.getElementById('depositDescription').value;
            
            if (!amount || parseFloat(amount) <= 0) {
                showInfoMessage('Por favor, insira um valor válido.');
                return;
            }
            
            const success = await addMoney(amount, description);
            if (success) {
                addMoneyForm.reset();
            }
        });
    }
    
    // Formulário de retirar dinheiro
    const withdrawMoneyForm = document.getElementById('withdrawMoneyForm');
    if (withdrawMoneyForm) {
        withdrawMoneyForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const amount = document.getElementById('withdrawalAmount').value;
            const description = document.getElementById('withdrawalDescription').value;
            
            if (!amount || parseFloat(amount) <= 0) {
                showInfoMessage('Por favor, insira um valor válido.');
                return;
            }
            
            const success = await withdrawMoney(amount, description);
            if (success) {
                withdrawMoneyForm.reset();
            }
        });
    }
    
    // Filtros da tabela de transações
    const typeFilter = document.getElementById('transactionTypeFilter');
    const dateFilter = document.getElementById('transactionDateFilter');
    
    if (typeFilter) {
        typeFilter.addEventListener('change', filterCashTransactions);
    }
    
    if (dateFilter) {
        dateFilter.addEventListener('change', filterCashTransactions);
    }
});

// Filtrar transações de caixa
function filterCashTransactions() {
    const typeFilter = document.getElementById('transactionTypeFilter')?.value;
    const dateFilter = document.getElementById('transactionDateFilter')?.value;
    
    let filteredTransactions = [...cashTransactions];
    
    if (typeFilter) {
        filteredTransactions = filteredTransactions.filter(t => t.transaction_type === typeFilter);
    }
    
    if (dateFilter) {
        filteredTransactions = filteredTransactions.filter(t => {
            const transactionDate = new Date(t.created_at).toISOString().split('T')[0];
            return transactionDate === dateFilter;
        });
    }
    
    // Renderizar tabela filtrada
    const tbody = document.getElementById('cashTransactionsTableBody');
    if (!tbody) return;
    
    tbody.innerHTML = '';
    
    if (filteredTransactions.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="5" class="px-6 py-8 text-center text-gray-400">
                    Nenhuma transação encontrada com os filtros aplicados
                </td>
            </tr>
        `;
        return;
    }
    
    filteredTransactions.forEach(transaction => {
        const row = document.createElement('tr');
        row.className = 'table-row hover:bg-gray-800/50';
        
        const date = new Date(transaction.created_at);
        const formattedDate = date.toLocaleDateString('pt-BR') + ' ' + date.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' });
        const typeColor = transaction.transaction_type === 'deposit' ? 'text-green-400' : 'text-red-400';
        const typeIcon = transaction.transaction_type === 'deposit' ? '↗' : '↙';
        const typeText = transaction.transaction_type === 'deposit' ? 'Entrada' : 'Saída';
        
        row.innerHTML = `
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formattedDate}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm ${typeColor}">
                <span class="inline-flex items-center">
                    <span class="mr-2">${typeIcon}</span>
                    ${typeText}
                </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium ${typeColor}">
                R$ ${parseFloat(transaction.amount).toFixed(2).replace('.', ',')}
            </td>
            <td class="px-6 py-4 text-sm text-gray-300">${transaction.description || '-'}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                R$ ${parseFloat(transaction.balance_after).toFixed(2).replace('.', ',')}
            </td>
        `;
        
        tbody.appendChild(row);
    });
}

// Zerar caixa (resetar saldo e transações)
async function resetCash() {
    try {
        // Mostrar confirmação com aviso
        showConfirmationModal(
            'Zerar Caixa',
            'ATENÇÃO: Esta ação é irreversível!\n\nTodas as transações de caixa serão excluídas permanentemente e o saldo será zerado.\n\nDeseja realmente continuar?',
            async () => {
                try {
                    // Primeiro, excluir todas as transações de caixa
                    const { error: deleteTransactionsError } = await supabase
                        .from('cash_transactions')
                        .delete()
                        .neq('id', '00000000-0000-0000-0000-000000000000'); // Deleta todos os registros
                    
                    if (deleteTransactionsError) throw deleteTransactionsError;
                    
                    // Depois, resetar o saldo para zero
                    if (cashSettings) {
                        const { error: resetBalanceError } = await supabase
                            .from('cash_settings')
                            .update({ 
                                current_balance: 0,
                                last_updated: new Date().toISOString(),
                                updated_by: currentUser?.id
                            })
                            .eq('id', cashSettings.id);
                        
                        if (resetBalanceError) throw resetBalanceError;
                    } else {
                        // Se não existe configuração, criar uma nova com saldo zero
                        const { error: createError } = await supabase
                            .from('cash_settings')
                            .insert([{
                                current_balance: 0,
                                initial_balance: 0,
                                updated_by: currentUser?.id
                            }]);
                        
                        if (createError) throw createError;
                    }
                    
                    // Atualizar dados locais
                    await loadCashTransactions();
                    await loadCashSettings();
                    
                    showInfoMessage('Caixa zerado com sucesso! Todas as transações foram excluídas.');
                    
                } catch (error) {
                    console.error('Erro ao zerar caixa:', error);
                    showInfoMessage('Erro ao zerar caixa: ' + error.message);
                }
            },
            'Zerar Caixa'
        );
        
    } catch (error) {
        console.error('Erro ao preparar reset do caixa:', error);
        showInfoMessage('Erro ao preparar reset do caixa: ' + error.message);
    }
}

// ===================================================
// FIM DA GESTÃO DE CAIXA
// ===================================================

// ===================================================
// INÍCIO DA GESTÃO DE LEVANTAMENTO DE CAPITAL
// ===================================================

// Carregar levantamentos de capital
async function loadCapitalRaisings() {
    try {
        const { data, error } = await supabase
            .from('capital_raising')
            .select('*')
            .eq('user_id', currentUser.email)
            .order('data_criacao', { ascending: false });
        
        if (error) throw error;
        
        capitalRaisings = data || [];
        renderCapitalRaisingsTable();
        updateCapitalRaisingSummary();
        
    } catch (error) {
        console.error('Erro ao carregar levantamentos de capital:', error);
        capitalRaisings = [];
    }
}

// Carregar clientes de levantamento de capital
async function loadCapitalRaisingClients(capitalRaisingId = null) {
    try {
        let query = supabase
            .from('capital_raising_clients')
            .select('*')
            .order('data_entrada', { ascending: false });
            
        if (capitalRaisingId) {
            query = query.eq('capital_raising_id', capitalRaisingId);
        }
        
        const { data, error } = await query;
        
        if (error) throw error;
        
        if (capitalRaisingId) {
            return data || [];
        } else {
            capitalRaisingClients = data || [];
        }
        
    } catch (error) {
        console.error('Erro ao carregar clientes de levantamento de capital:', error);
        return [];
    }
}

// Renderizar tabela de levantamentos de capital
function renderCapitalRaisingsTable() {
    const tbody = document.getElementById('capitalRaisingsTableBody');
    if (!tbody) return;
    
    tbody.innerHTML = '';
    
    // Aplicar filtros
    const statusFilter = document.getElementById('capitalRaisingStatusFilter')?.value || '';
    
    let filteredRaisings = capitalRaisings;
    
    if (statusFilter) {
        filteredRaisings = capitalRaisings.filter(raising => 
            statusFilter === 'active' ? raising.ativo : !raising.ativo
        );
    }
    
    filteredRaisings.forEach(raising => {
        const row = document.createElement('tr');
        row.className = 'table-row';
        
        const formattedDate = formatDate(raising.data_criacao);
        let statusClass, statusText;
        
        if (raising.data_baixa) {
            statusClass = 'status-cancelled';
            statusText = 'Baixa Dada';
        } else if (raising.ativo) {
            statusClass = 'status-active';
            statusText = 'Ativo';
        } else {
            statusClass = 'status-pending';
            statusText = 'Inativo';
        }
        
        row.innerHTML = `
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-white">${raising.nome}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                R$ ${parseFloat(raising.valor_bruto).toFixed(2).replace('.', ',')}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-yellow-400">
                ${parseFloat(raising.taxa_juros).toFixed(2)}%
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-green-400">
                R$ ${parseFloat(raising.valor_total).toFixed(2).replace('.', ',')}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-purple-400" id="clients-count-${raising.id}">
                Carregando...
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formattedDate}</td>
            <td class="px-6 py-4 whitespace-nowrap">
                <span class="status-badge ${statusClass}">${statusText}</span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                <div class="flex space-x-2">
                    <button onclick="viewCapitalRaisingDetails(${raising.id})" class="text-blue-400 hover:text-blue-300" title="Visualizar detalhes">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                        </svg>
                    </button>
                    <button onclick="generateCapitalRaisingPDF(${raising.id})" class="text-green-400 hover:text-green-300" title="Gerar PDF">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                        </svg>
                    </button>
                    ${raising.ativo && !raising.data_baixa ? `
                    <button onclick="closeCapitalRaising(${raising.id})" class="text-orange-400 hover:text-orange-300" title="Dar baixa">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                    </button>
                    ` : ''}
                    <button onclick="toggleCapitalRaisingStatus(${raising.id})" class="text-yellow-400 hover:text-yellow-300" title="Alterar status">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                    </button>
                    <button onclick="deleteCapitalRaising(${raising.id})" class="text-red-400 hover:text-red-300" title="Excluir">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                        </svg>
                    </button>
                </div>
            </td>
        `;
        
        tbody.appendChild(row);
        
        // Carregar contagem de clientes para este levantamento
        loadCapitalRaisingClients(raising.id).then(clients => {
            const countElement = document.getElementById(`clients-count-${raising.id}`);
            if (countElement) {
                countElement.textContent = clients.length;
            }
        });
    });
}

// Atualizar resumo de levantamentos de capital
function updateCapitalRaisingSummary() {
    const activeRaisings = capitalRaisings.filter(r => r.ativo);
    
    const totalRaised = activeRaisings.reduce((sum, r) => sum + parseFloat(r.valor_bruto), 0);
    const totalInterest = activeRaisings.reduce((sum, r) => sum + (parseFloat(r.valor_bruto) * parseFloat(r.taxa_juros) / 100), 0);
    const activeCount = activeRaisings.length;
    
    const totalRaisedElement = document.getElementById('totalCapitalRaised');
    const totalInterestElement = document.getElementById('totalCapitalInterest');
    const activeRaisingsElement = document.getElementById('activeCapitalRaisings');
    
    if (totalRaisedElement) {
        totalRaisedElement.textContent = `R$ ${totalRaised.toFixed(2).replace('.', ',')}`;
    }
    
    if (totalInterestElement) {
        totalInterestElement.textContent = `R$ ${totalInterest.toFixed(2).replace('.', ',')}`;
    }
    
    if (activeRaisingsElement) {
        activeRaisingsElement.textContent = activeCount;
    }
    
    // Atualizar total de clientes
    updateCapitalClientsCount();
}

// Atualizar contagem total de clientes
async function updateCapitalClientsCount() {
    try {
        const { data, error } = await supabase
            .from('capital_raising_clients')
            .select('id')
            .eq('ativo', true);
            
        if (error) throw error;
        
        const totalClientsElement = document.getElementById('totalCapitalClients');
        if (totalClientsElement) {
            totalClientsElement.textContent = (data || []).length;
        }
        
    } catch (error) {
        console.error('Erro ao contar clientes de capital:', error);
    }
}

// Manipular novo levantamento de capital
async function handleNewCapitalRaising(e) {
    e.preventDefault();
    
    const nome = document.getElementById('capitalRaisingName').value;
    const valorBruto = parseFloat(document.getElementById('capitalRaisingAmount').value);
    const taxaJuros = parseFloat(document.getElementById('capitalRaisingInterest').value) || 0;
    const valorTotal = parseFloat(document.getElementById('capitalRaisingTotal').value);
    const observacoes = document.getElementById('capitalRaisingNotes').value;
    
    try {
        const { data, error } = await supabase
            .from('capital_raising')
            .insert([{
                nome,
                valor_bruto: valorBruto,
                taxa_juros: taxaJuros,
                valor_total: valorTotal,
                observacoes,
                user_id: currentUser.email
            }]);
            
        if (error) throw error;
        
        hideModal(newCapitalRaisingModal);
        document.getElementById('newCapitalRaisingForm').reset();
        
        await loadCapitalRaisings();
        
        alert('Levantamento de capital criado com sucesso!');
        
    } catch (error) {
        console.error('Erro ao criar levantamento de capital:', error);
        alert('Erro ao criar levantamento de capital. Tente novamente.');
    }
}

// Visualizar detalhes do levantamento de capital
async function viewCapitalRaisingDetails(capitalRaisingId) {
    const raising = capitalRaisings.find(r => r.id === capitalRaisingId);
    if (!raising) return;
    
    // Atualizar título e informações
    document.getElementById('capitalRaisingDetailsTitle').textContent = raising.nome;
    document.getElementById('detailsValueBruto').textContent = `R$ ${parseFloat(raising.valor_bruto).toFixed(2).replace('.', ',')}`;
    document.getElementById('detailsInterestRate').textContent = `${parseFloat(raising.taxa_juros).toFixed(2)}%`;
    document.getElementById('detailsValueTotal').textContent = `R$ ${parseFloat(raising.valor_total).toFixed(2).replace('.', ',')}`;
    
    // Configurar botão de adicionar cliente
    const addClientBtn = document.getElementById('addCapitalClientBtn');
    addClientBtn.onclick = () => showAddCapitalClientModal(capitalRaisingId);
    
    // Carregar e renderizar clientes
    const clients = await loadCapitalRaisingClients(capitalRaisingId);
    renderCapitalClientsTable(clients, capitalRaisingId);
    
    showModal(capitalRaisingDetailsModal);
}

// Renderizar tabela de clientes do levantamento
function renderCapitalClientsTable(clients, capitalRaisingId) {
    const tbody = document.getElementById('capitalClientsTableBody');
    if (!tbody) return;
    
    tbody.innerHTML = '';
    
    clients.forEach(client => {
        const row = document.createElement('tr');
        row.className = 'table-row';
        
        const formattedDate = formatDate(client.data_entrada);
        
        row.innerHTML = `
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-white">${client.nome}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${client.cpf || '-'}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${client.telefone || '-'}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${client.email || '-'}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-green-400">
                R$ ${parseFloat(client.valor_individual).toFixed(2).replace('.', ',')}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formattedDate}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                <div class="flex space-x-2">
                    <button onclick="editCapitalClient(${client.id})" class="text-blue-400 hover:text-blue-300">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                        </svg>
                    </button>
                    <button onclick="deleteCapitalClient(${client.id}, ${capitalRaisingId})" class="text-red-400 hover:text-red-300">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                        </svg>
                    </button>
                </div>
            </td>
        `;
        
        tbody.appendChild(row);
    });
}

// Mostrar modal para adicionar cliente ao levantamento
function showAddCapitalClientModal(capitalRaisingId) {
    // Armazenar o ID do levantamento para usar no submit
    document.getElementById('addCapitalClientForm').dataset.capitalRaisingId = capitalRaisingId;
    showModal(addCapitalClientModal);
}

// Manipular adição de cliente ao levantamento
async function handleAddCapitalClient(e) {
    e.preventDefault();
    
    const capitalRaisingId = e.target.dataset.capitalRaisingId;
    const nome = document.getElementById('capitalClientName').value;
    const cpf = document.getElementById('capitalClientCpf').value;
    const telefone = document.getElementById('capitalClientPhone').value;
    const email = document.getElementById('capitalClientEmail').value;
    const valorIndividual = parseFloat(document.getElementById('capitalClientValue').value);
    const observacoes = document.getElementById('capitalClientNotes').value;
    
    try {
        const { data, error } = await supabase
            .from('capital_raising_clients')
            .insert([{
                capital_raising_id: capitalRaisingId,
                nome,
                cpf,
                telefone,
                email,
                valor_individual: valorIndividual,
                observacoes
            }]);
            
        if (error) throw error;
        
        hideModal(addCapitalClientModal);
        document.getElementById('addCapitalClientForm').reset();
        
        // Recarregar detalhes do levantamento
        await viewCapitalRaisingDetails(capitalRaisingId);
        await updateCapitalClientsCount();
        
        alert('Participante adicionado com sucesso!');
        
    } catch (error) {
        console.error('Erro ao adicionar participante:', error);
        alert('Erro ao adicionar participante. Tente novamente.');
    }
}

// Alternar status do levantamento de capital
async function toggleCapitalRaisingStatus(capitalRaisingId) {
    const raising = capitalRaisings.find(r => r.id === capitalRaisingId);
    if (!raising) return;
    
    const newStatus = !raising.ativo;
    const statusText = newStatus ? 'ativar' : 'desativar';
    
    if (!confirm(`Tem certeza que deseja ${statusText} este levantamento?`)) return;
    
    try {
        const { error } = await supabase
            .from('capital_raising')
            .update({ ativo: newStatus })
            .eq('id', capitalRaisingId);
            
        if (error) throw error;
        
        await loadCapitalRaisings();
        
    } catch (error) {
        console.error('Erro ao alterar status do levantamento:', error);
        alert('Erro ao alterar status. Tente novamente.');
    }
}

// Dar baixa no levantamento de capital
async function closeCapitalRaising(capitalRaisingId) {
    const raising = capitalRaisings.find(r => r.id === capitalRaisingId);
    if (!raising) return;
    
    const motivo = prompt('Informe o motivo da baixa do levantamento:', '');
    if (motivo === null) return; // User cancelled
    
    if (!confirm(`Tem certeza que deseja dar baixa no levantamento "${raising.nome}"?\n\nUm PDF será gerado automaticamente com os dados finais do levantamento.`)) return;
    
    try {
        const { error } = await supabase
            .from('capital_raising')
            .update({ 
                data_baixa: new Date().toISOString(),
                motivo_baixa: motivo,
                ativo: false
            })
            .eq('id', capitalRaisingId);
            
        if (error) throw error;
        
        await loadCapitalRaisings();
        
        // Gerar PDF automaticamente após dar baixa
        alert('Baixa do levantamento realizada com sucesso!\n\nGenerando PDF automaticamente...');
        
        // Aguardar um pequeno delay para que os dados sejam atualizados
        setTimeout(async () => {
            await generateCapitalRaisingPDF(capitalRaisingId);
        }, 500);
        
    } catch (error) {
        console.error('Erro ao dar baixa no levantamento:', error);
        alert('Erro ao dar baixa no levantamento. Tente novamente.');
    }
}

// Excluir levantamento de capital
async function deleteCapitalRaising(capitalRaisingId) {
    if (!confirm('Tem certeza que deseja excluir este levantamento? Esta ação não pode ser desfeita.')) return;
    
    try {
        const { error } = await supabase
            .from('capital_raising')
            .delete()
            .eq('id', capitalRaisingId);
            
        if (error) throw error;
        
        await loadCapitalRaisings();
        
        alert('Levantamento excluído com sucesso!');
        
    } catch (error) {
        console.error('Erro ao excluir levantamento:', error);
        alert('Erro ao excluir levantamento. Tente novamente.');
    }
}

// Excluir cliente do levantamento
async function deleteCapitalClient(clientId, capitalRaisingId) {
    if (!confirm('Tem certeza que deseja remover este participante?')) return;
    
    try {
        const { error } = await supabase
            .from('capital_raising_clients')
            .delete()
            .eq('id', clientId);
            
        if (error) throw error;
        
        // Recarregar detalhes do levantamento
        await viewCapitalRaisingDetails(capitalRaisingId);
        await updateCapitalClientsCount();
        
        alert('Participante removido com sucesso!');
        
    } catch (error) {
        console.error('Erro ao remover participante:', error);
        alert('Erro ao remover participante. Tente novamente.');
    }
}

// Gerar PDF do levantamento de capital
async function generateCapitalRaisingPDF(capitalRaisingId) {
    const raising = capitalRaisings.find(r => r.id === capitalRaisingId);
    if (!raising) {
        alert('Levantamento não encontrado!');
        return;
    }
    
    try {
        // Carregar clientes do levantamento
        const clients = await loadCapitalRaisingClients(capitalRaisingId);
        
        // Criar novo documento PDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();
        
        // Configurações
        const margin = 20;
        const pageWidth = doc.internal.pageSize.width;
        const pageHeight = doc.internal.pageSize.height;
        let yPosition = margin;
        
        // Função para adicionar nova página se necessário
        function checkPageBreak(neededHeight) {
            if (yPosition + neededHeight > pageHeight - margin) {
                doc.addPage();
                yPosition = margin;
                return true;
            }
            return false;
        }
        
        // Título
        doc.setFontSize(20);
        doc.setFont(undefined, 'bold');
        const titulo = raising.data_baixa ? 'RELATÓRIO FINAL DE LEVANTAMENTO DE CAPITAL' : 'RELATÓRIO DE LEVANTAMENTO DE CAPITAL';
        doc.text(titulo, pageWidth / 2, yPosition, { align: 'center' });
        yPosition += 20;
        
        // Subtítulo se for baixa
        if (raising.data_baixa) {
            doc.setFontSize(14);
            doc.setTextColor(220, 38, 127); // Rosa/vermelho para destacar
            doc.text('(LEVANTAMENTO ENCERRADO)', pageWidth / 2, yPosition, { align: 'center' });
            doc.setTextColor(0, 0, 0); // Voltar para preto
            yPosition += 15;
        }
        
        // Linha separadora
        doc.setLineWidth(0.5);
        doc.line(margin, yPosition, pageWidth - margin, yPosition);
        yPosition += 15;
        
        // Informações do levantamento
        doc.setFontSize(16);
        doc.setFont(undefined, 'bold');
        doc.text('INFORMAÇÕES GERAIS', margin, yPosition);
        yPosition += 10;
        
        doc.setFontSize(12);
        doc.setFont(undefined, 'normal');
        
        const info = [
            ['Nome:', raising.nome],
            ['Valor Bruto:', `R$ ${parseFloat(raising.valor_bruto).toFixed(2).replace('.', ',')}`],
            ['Taxa de Juros:', `${parseFloat(raising.taxa_juros).toFixed(2)}%`],
            ['Valor Total:', `R$ ${parseFloat(raising.valor_total).toFixed(2).replace('.', ',')}`],
            ['Data de Criação:', formatDate(raising.data_criacao)],
            ['Status:', raising.ativo ? 'Ativo' : 'Inativo'],
        ];
        
        if (raising.data_baixa) {
            info.push(['Data da Baixa:', formatDate(raising.data_baixa)]);
            info.push(['Motivo da Baixa:', raising.motivo_baixa || 'Não informado']);
        }
        
        if (raising.observacoes) {
            info.push(['Observações:', raising.observacoes]);
        }
        
        info.forEach(([label, value]) => {
            checkPageBreak(8);
            doc.setFont(undefined, 'bold');
            doc.text(label, margin, yPosition);
            doc.setFont(undefined, 'normal');
            doc.text(value, margin + 50, yPosition);
            yPosition += 8;
        });
        
        yPosition += 10;
        
        // Seção de resumo final se for baixa
        if (raising.data_baixa) {
            checkPageBreak(25);
            
            doc.setFontSize(16);
            doc.setFont(undefined, 'bold');
            doc.setTextColor(220, 38, 127); // Rosa/vermelho para destacar
            doc.text('RESUMO DO ENCERRAMENTO', margin, yPosition);
            doc.setTextColor(0, 0, 0); // Voltar para preto
            yPosition += 15;
            
            // Calcular totais para o resumo (usando os clientes já carregados)
            const totalContribuido = clients.reduce((sum, client) => sum + parseFloat(client.valor_individual || 0), 0);
            const percentualArrecadado = ((totalContribuido / parseFloat(raising.valor_total)) * 100).toFixed(2);
            const diferenca = parseFloat(raising.valor_total) - totalContribuido;
            
            doc.setFontSize(12);
            doc.setFont(undefined, 'normal');
            
            const resumoInfo = [
                ['Valor Meta:', `R$ ${parseFloat(raising.valor_total).toFixed(2).replace('.', ',')}`],
                ['Valor Arrecadado:', `R$ ${totalContribuido.toFixed(2).replace('.', ',')}`],
                ['Percentual Atingido:', `${percentualArrecadado}%`],
                ['Diferença:', `R$ ${Math.abs(diferenca).toFixed(2).replace('.', ',')} ${diferenca >= 0 ? '(faltou)' : '(excedeu)'}`],
                ['Total de Participantes:', `${clients.length}`]
            ];
            
            resumoInfo.forEach(([label, value]) => {
                checkPageBreak(8);
                doc.setFont(undefined, 'bold');
                doc.text(label, margin, yPosition);
                doc.setFont(undefined, 'normal');
                doc.text(value, margin + 60, yPosition);
                yPosition += 8;
            });
            
            yPosition += 10;
        }
        
        // Participantes
        if (clients && clients.length > 0) {
            checkPageBreak(30);
            
            doc.setFontSize(16);
            doc.setFont(undefined, 'bold');
            doc.text('PARTICIPANTES', margin, yPosition);
            yPosition += 15;
            
            doc.setFontSize(10);
            doc.setFont(undefined, 'bold');
            
            // Cabeçalho da tabela
            const headers = ['Nome', 'CPF', 'Telefone', 'Email', 'Valor Individual', 'Data Entrada'];
            const columnWidths = [35, 25, 25, 40, 25, 25];
            let xPosition = margin;
            
            headers.forEach((header, index) => {
                doc.text(header, xPosition, yPosition);
                xPosition += columnWidths[index];
            });
            
            yPosition += 5;
            doc.line(margin, yPosition, pageWidth - margin, yPosition);
            yPosition += 5;
            
            // Dados dos participantes
            doc.setFont(undefined, 'normal');
            doc.setFontSize(9);
            
            let totalContribuido = 0;
            
            clients.forEach(client => {
                checkPageBreak(10);
                
                xPosition = margin;
                const data = [
                    client.nome || '',
                    client.cpf || '',
                    client.telefone || '',
                    client.email || '',
                    `R$ ${parseFloat(client.valor_individual || 0).toFixed(2).replace('.', ',')}`,
                    formatDate(client.data_entrada)
                ];
                
                data.forEach((item, index) => {
                    // Quebrar texto longo se necessário
                    const splitText = doc.splitTextToSize(item, columnWidths[index] - 2);
                    doc.text(splitText, xPosition, yPosition);
                    xPosition += columnWidths[index];
                });
                
                totalContribuido += parseFloat(client.valor_individual || 0);
                yPosition += 8;
            });
            
            // Linha separadora e total
            yPosition += 5;
            doc.line(margin, yPosition, pageWidth - margin, yPosition);
            yPosition += 10;
            
            doc.setFont(undefined, 'bold');
            doc.setFontSize(12);
            doc.text(`Total de Participantes: ${clients.length}`, margin, yPosition);
            yPosition += 8;
            doc.text(`Total Contribuído: R$ ${totalContribuido.toFixed(2).replace('.', ',')}`, margin, yPosition);
            yPosition += 8;
            
            const percentualArrecadado = ((totalContribuido / parseFloat(raising.valor_total)) * 100).toFixed(2);
            doc.text(`Percentual Arrecadado: ${percentualArrecadado}%`, margin, yPosition);
        } else {
            checkPageBreak(20);
            doc.setFontSize(12);
            doc.setFont(undefined, 'normal');
            doc.text('Nenhum participante cadastrado ainda.', margin, yPosition);
        }
        
        // Rodapé
        yPosition = pageHeight - 30;
        doc.setFontSize(8);
        doc.setFont(undefined, 'normal');
        doc.text(`Relatório gerado em ${new Date().toLocaleDateString('pt-BR')} às ${new Date().toLocaleTimeString('pt-BR')}`, pageWidth / 2, yPosition, { align: 'center' });
        
        // Salvar o PDF
        const prefix = raising.data_baixa ? 'FINAL_levantamento_capital' : 'levantamento_capital';
        const fileName = `${prefix}_${raising.nome.replace(/[^a-zA-Z0-9]/g, '_')}_${new Date().getTime()}.pdf`;
        doc.save(fileName);
        
    } catch (error) {
        console.error('Erro ao gerar PDF:', error);
        alert('Erro ao gerar PDF. Tente novamente.');
    }
}

// Event listeners para filtros
document.addEventListener('DOMContentLoaded', function() {
    const statusFilter = document.getElementById('capitalRaisingStatusFilter');
    if (statusFilter) {
        statusFilter.addEventListener('change', renderCapitalRaisingsTable);
    }
});

// ===================================================
// FIM DA GESTÃO DE LEVANTAMENTO DE CAPITAL
// ===================================================

// ===================================================
// FUNÇÕES DE GERAÇÃO DE PDF DOS RELATÓRIOS
// ===================================================

// Função para gerar PDF do resumo total de empréstimos
async function generateTotalReportPDF() {
    try {
        if (loans.length === 0) {
            showInfoMessage('Nenhum empréstimo foi encontrado.');
            return;
        }

        // Criar novo documento PDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // Configurações do documento
        doc.setFont('helvetica');
        
        // Título
        doc.setFontSize(18);
        doc.setFont('helvetica', 'bold');
        doc.text('RELATÓRIO TOTAL DE EMPRÉSTIMOS', 105, 20, { align: 'center' });
        
        // Data de geração
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Gerado em: ${new Date().toLocaleDateString('pt-BR')} às ${new Date().toLocaleTimeString('pt-BR')}`, 20, 35);
        
        // Linha divisória
        doc.line(20, 40, 190, 40);
        
        let yPosition = 50;
        
        // Resumo geral
        doc.setFontSize(14);
        doc.setFont('helvetica', 'bold');
        doc.text('RESUMO GERAL', 20, yPosition);
        yPosition += 10;
        
        const totalAmount = loans.reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
        const totalInterest = loans.reduce((sum, loan) => sum + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100), 0);
        const totalWithInterest = totalAmount + totalInterest;
        
        // Calcular estatísticas por período
        const now = new Date();
        const last7Days = new Date(now.getTime() - (7 * 24 * 60 * 60 * 1000));
        const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
        const last6Months = new Date(now.getFullYear(), now.getMonth() - 6, 1);
        const last12Months = new Date(now.getFullYear(), now.getMonth() - 12, 1);
        
        const loans7Days = loans.filter(loan => new Date(loan.created_at) >= last7Days);
        const loansMonth = loans.filter(loan => new Date(loan.created_at) >= lastMonth);
        const loans6Months = loans.filter(loan => new Date(loan.created_at) >= last6Months);
        const loans12Months = loans.filter(loan => new Date(loan.created_at) >= last12Months);
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Total de empréstimos: ${loans.length}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total emprestado: R$ ${totalAmount.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Total de juros: R$ ${totalInterest.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total com juros: R$ ${totalWithInterest.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 15;
        
        // Estatísticas por período
        doc.setFontSize(12);
        doc.setFont('helvetica', 'bold');
        doc.text('ESTATÍSTICAS POR PERÍODO', 20, yPosition);
        yPosition += 10;
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        
        const periods = [
            { label: 'Últimos 7 dias', loans: loans7Days },
            { label: 'Último mês', loans: loansMonth },
            { label: 'Últimos 6 meses', loans: loans6Months },
            { label: 'Últimos 12 meses', loans: loans12Months }
        ];
        
        periods.forEach(period => {
            const total = period.loans.reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
            doc.text(`${period.label}: ${period.loans.length} empréstimos - R$ ${total.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
            yPosition += 6;
        });
        
        yPosition += 10;
        
        // Distribuição por status
        doc.setFontSize(12);
        doc.setFont('helvetica', 'bold');
        doc.text('DISTRIBUIÇÃO POR STATUS', 20, yPosition);
        yPosition += 10;
        
        const activeLoans = loans.filter(loan => getLoanStatus(loan.due_date, loan.status) === 'active').length;
        const overdueLoans = loans.filter(loan => getLoanStatus(loan.due_date, loan.status) === 'overdue').length;
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Empréstimos ativos: ${activeLoans}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Empréstimos vencidos: ${overdueLoans}`, 20, yPosition);
        yPosition += 6;
        
        // Salvar o PDF
        const fileName = `relatorio_total_emprestimos_${new Date().getTime()}.pdf`;
        doc.save(fileName);
        
        showInfoMessage('Relatório total gerado com sucesso!');
        
    } catch (error) {
        console.error('Erro ao gerar PDF do relatório total:', error);
        showInfoMessage('Erro ao gerar PDF: ' + error.message);
    }
}

// Função para gerar PDF do relatório semanal
async function generateWeeklyReportPDF() {
    try {
        const now = new Date();
        const last7Days = new Date(now.getTime() - (7 * 24 * 60 * 60 * 1000));
        
        // Filtrar empréstimos dos últimos 7 dias
        const weeklyLoans = loans.filter(loan => {
            const loanDate = new Date(loan.created_at);
            return loanDate >= last7Days;
        });

        if (weeklyLoans.length === 0) {
            showInfoMessage('Nenhum empréstimo foi encontrado nos últimos 7 dias.');
            return;
        }

        // Criar novo documento PDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // Configurações do documento
        doc.setFont('helvetica');
        
        // Título
        doc.setFontSize(18);
        doc.setFont('helvetica', 'bold');
        doc.text('RELATÓRIO SEMANAL DE EMPRÉSTIMOS', 105, 20, { align: 'center' });
        
        // Período
        doc.setFontSize(12);
        doc.setFont('helvetica', 'normal');
        const periodText = `Período: ${last7Days.toLocaleDateString('pt-BR')} a ${now.toLocaleDateString('pt-BR')}`;
        doc.text(periodText, 105, 30, { align: 'center' });
        
        // Data de geração
        doc.setFontSize(10);
        doc.text(`Gerado em: ${new Date().toLocaleDateString('pt-BR')} às ${new Date().toLocaleTimeString('pt-BR')}`, 20, 40);
        
        // Linha divisória
        doc.line(20, 45, 190, 45);
        
        let yPosition = 55;
        
        // Resumo semanal
        doc.setFontSize(14);
        doc.setFont('helvetica', 'bold');
        doc.text('RESUMO DOS ÚLTIMOS 7 DIAS', 20, yPosition);
        yPosition += 10;
        
        const totalAmount = weeklyLoans.reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
        const totalInterest = weeklyLoans.reduce((sum, loan) => sum + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100), 0);
        const totalWithInterest = totalAmount + totalInterest;
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Total de empréstimos: ${weeklyLoans.length}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total emprestado: R$ ${totalAmount.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Total de juros: R$ ${totalInterest.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total com juros: R$ ${totalWithInterest.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 15;
        
        // Buscar informações sobre multas da semana
        const { data: weeklyPayments, error: paymentsError } = await supabase
            .from('payments')
            .select('fine_amount')
            .gte('payment_date', last7Days.toISOString().split('T')[0])
            .lte('payment_date', now.toISOString().split('T')[0]);
        
        if (!paymentsError && weeklyPayments) {
            const totalFines = weeklyPayments.reduce((sum, payment) => sum + (parseFloat(payment.fine_amount) || 0), 0);
            const fineCount = weeklyPayments.filter(payment => (parseFloat(payment.fine_amount) || 0) > 0).length;
            
            if (totalFines > 0) {
                doc.setFontSize(12);
                doc.setFont('helvetica', 'bold');
                doc.text('MULTAS DA SEMANA', 20, yPosition);
                yPosition += 10;
                
                doc.setFontSize(10);
                doc.setFont('helvetica', 'normal');
                doc.text(`Total de multas aplicadas: ${fineCount}`, 20, yPosition);
                yPosition += 6;
                doc.text(`Valor total em multas: R$ ${totalFines.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
                yPosition += 15;
            }
        }
        
        // Distribuição diária
        doc.setFontSize(12);
        doc.setFont('helvetica', 'bold');
        doc.text('DISTRIBUIÇÃO DIÁRIA', 20, yPosition);
        yPosition += 10;
        
        const dailyData = getLast7Days().map(day => {
            const dayLoans = weeklyLoans.filter(loan => {
                const loanDate = new Date(loan.created_at);
                return loanDate.toDateString() === day.toDateString();
            });
            return {
                date: day,
                count: dayLoans.length,
                total: dayLoans.reduce((sum, loan) => sum + parseFloat(loan.amount), 0)
            };
        });
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        
        dailyData.forEach(day => {
            doc.text(`${day.date.toLocaleDateString('pt-BR')}: ${day.count} empréstimos - R$ ${day.total.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
            yPosition += 6;
        });
        
        // Salvar o PDF
        const fileName = `relatorio_semanal_emprestimos_${new Date().getTime()}.pdf`;
        doc.save(fileName);
        
        showInfoMessage('Relatório semanal gerado com sucesso!');
        
    } catch (error) {
        console.error('Erro ao gerar PDF do relatório semanal:', error);
        showInfoMessage('Erro ao gerar PDF: ' + error.message);
    }
}

// Função para gerar PDF do relatório mensal
async function generateMonthlyReportPDF() {
    try {
        const now = new Date();
        const currentMonth = new Date(now.getFullYear(), now.getMonth(), 1);
        
        // Filtrar empréstimos do mês atual
        const monthlyLoans = loans.filter(loan => {
            const loanDate = new Date(loan.created_at);
            return loanDate >= currentMonth;
        });

        if (monthlyLoans.length === 0) {
            showInfoMessage('Nenhum empréstimo foi encontrado no mês atual.');
            return;
        }

        // Criar novo documento PDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // Configurações do documento
        doc.setFont('helvetica');
        
        // Título
        doc.setFontSize(18);
        doc.setFont('helvetica', 'bold');
        doc.text('RELATÓRIO MENSAL DE EMPRÉSTIMOS', 105, 20, { align: 'center' });
        
        // Período
        doc.setFontSize(12);
        doc.setFont('helvetica', 'normal');
        const monthName = currentMonth.toLocaleDateString('pt-BR', { month: 'long', year: 'numeric' });
        const periodText = `Período: ${monthName}`;
        doc.text(periodText, 105, 30, { align: 'center' });
        
        // Data de geração
        doc.setFontSize(10);
        doc.text(`Gerado em: ${new Date().toLocaleDateString('pt-BR')} às ${new Date().toLocaleTimeString('pt-BR')}`, 20, 40);
        
        // Linha divisória
        doc.line(20, 45, 190, 45);
        
        let yPosition = 55;
        
        // Resumo mensal
        doc.setFontSize(14);
        doc.setFont('helvetica', 'bold');
        doc.text('RESUMO DO MÊS ATUAL', 20, yPosition);
        yPosition += 10;
        
        const totalAmount = monthlyLoans.reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
        const totalInterest = monthlyLoans.reduce((sum, loan) => sum + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100), 0);
        const totalWithInterest = totalAmount + totalInterest;
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Total de empréstimos: ${monthlyLoans.length}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total emprestado: R$ ${totalAmount.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Total de juros: R$ ${totalInterest.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total com juros: R$ ${totalWithInterest.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 15;
        
        // Comparação com mês anterior
        const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
        const lastMonthEnd = new Date(now.getFullYear(), now.getMonth(), 0);
        const lastMonthLoans = loans.filter(loan => {
            const loanDate = new Date(loan.created_at);
            return loanDate >= lastMonth && loanDate <= lastMonthEnd;
        });
        
        const lastMonthTotal = lastMonthLoans.reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
        const growth = lastMonthTotal > 0 ? ((totalAmount - lastMonthTotal) / lastMonthTotal * 100) : 0;
        
        doc.setFontSize(12);
        doc.setFont('helvetica', 'bold');
        doc.text('COMPARAÇÃO COM MÊS ANTERIOR', 20, yPosition);
        yPosition += 10;
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Mês anterior: ${lastMonthLoans.length} empréstimos - R$ ${lastMonthTotal.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Crescimento: ${growth > 0 ? '+' : ''}${growth.toFixed(1)}%`, 20, yPosition);
        yPosition += 15;
        
        // Buscar informações sobre multas do mês
        const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
        const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0);
        
        const { data: monthlyPayments, error: paymentsError } = await supabase
            .from('payments')
            .select('fine_amount')
            .gte('payment_date', startOfMonth.toISOString().split('T')[0])
            .lte('payment_date', endOfMonth.toISOString().split('T')[0]);
        
        if (!paymentsError && monthlyPayments) {
            const totalFines = monthlyPayments.reduce((sum, payment) => sum + (parseFloat(payment.fine_amount) || 0), 0);
            const fineCount = monthlyPayments.filter(payment => (parseFloat(payment.fine_amount) || 0) > 0).length;
            
            if (totalFines > 0) {
                doc.setFontSize(12);
                doc.setFont('helvetica', 'bold');
                doc.text('MULTAS DO MÊS', 20, yPosition);
                yPosition += 10;
                
                doc.setFontSize(10);
                doc.setFont('helvetica', 'normal');
                doc.text(`Total de multas aplicadas: ${fineCount}`, 20, yPosition);
                yPosition += 6;
                doc.text(`Valor total em multas: R$ ${totalFines.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
                yPosition += 15;
            }
        }
        
        // Distribuição por status no mês
        doc.setFontSize(12);
        doc.setFont('helvetica', 'bold');
        doc.text('DISTRIBUIÇÃO POR STATUS (MÊS ATUAL)', 20, yPosition);
        yPosition += 10;
        
        const activeMonthly = monthlyLoans.filter(loan => getLoanStatus(loan.due_date, loan.status) === 'active').length;
        const overdueMonthly = monthlyLoans.filter(loan => getLoanStatus(loan.due_date, loan.status) === 'overdue').length;
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Empréstimos ativos: ${activeMonthly}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Empréstimos vencidos: ${overdueMonthly}`, 20, yPosition);
        
        // Salvar o PDF
        const fileName = `relatorio_mensal_emprestimos_${monthName.replace(/\s/g, '_')}_${new Date().getTime()}.pdf`;
        doc.save(fileName);
        
        showInfoMessage('Relatório mensal gerado com sucesso!');
        
    } catch (error) {
        console.error('Erro ao gerar PDF do relatório mensal:', error);
        showInfoMessage('Erro ao gerar PDF: ' + error.message);
    }
}

// =====================================================
// FUNÇÕES DE HISTÓRICO DE PAGAMENTOS SEMANAIS
// =====================================================

// Função para carregar histórico de pagamentos dos últimos 7 dias
async function loadWeeklyPaymentHistory() {
    try {
        const sevenDaysAgo = new Date();
        sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
        
        // Buscar pagamentos dos últimos 7 dias
        const { data: payments, error: paymentsError } = await supabase
            .from('payments')
            .select(`
                *,
                loans (
                    id,
                    amount,
                    client_id,
                    clients (
                        id,
                        name,
                        phone
                    )
                )
            `)
            .gte('payment_date', sevenDaysAgo.toISOString().split('T')[0])
            .order('payment_date', { ascending: false });

        if (paymentsError) throw paymentsError;

        // Renderizar dados na tabela
        renderWeeklyPaymentsTable(payments || []);
        updateWeeklyPaymentsSummary(payments || []);

    } catch (error) {
        console.error('Erro ao carregar histórico de pagamentos:', error);
        showErrorMessage('Erro ao carregar histórico de pagamentos: ' + error.message);
    }
}

// Função para renderizar tabela de pagamentos semanais
function renderWeeklyPaymentsTable(payments) {
    const tbody = document.getElementById('paymentsTableBody');
    const emptyState = document.getElementById('paymentsTableEmpty');
    
    if (!tbody) return;

    tbody.innerHTML = '';

    if (payments.length === 0) {
        tbody.style.display = 'none';
        if (emptyState) emptyState.classList.remove('hidden');
        return;
    }

    tbody.style.display = '';
    if (emptyState) emptyState.classList.add('hidden');

    payments.forEach(payment => {
        const client = payment.loans?.clients;
        const loan = payment.loans;
        
        const row = document.createElement('tr');
        row.className = 'hover:bg-gray-800 transition-colors';
        
        row.innerHTML = `
            <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-white">${formatDate(payment.payment_date)}</div>
                <div class="text-xs text-gray-400">${new Date(payment.payment_date).toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })}</div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium text-white">${client?.name || 'Cliente não encontrado'}</div>
                <div class="text-xs text-gray-400">${client?.phone || ''}</div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-white">Empréstimo #${loan?.id || payment.loan_id}</div>
                <div class="text-xs text-gray-400">Valor: R$ ${(loan?.amount || 0).toFixed(2)}</div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium text-green-400">R$ ${payment.amount.toFixed(2)}</div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium ${payment.fine_amount > 0 ? 'text-red-400' : 'text-gray-500'}">
                    ${payment.fine_amount > 0 ? `R$ ${payment.fine_amount.toFixed(2)}` : '-'}
                </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getPaymentMethodBadgeClass(payment.payment_method)}">
                    ${getPaymentMethodText(payment.payment_method)}
                </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                    Confirmado
                </span>
            </td>
        `;
        
        tbody.appendChild(row);
    });
}

// Função para atualizar resumo dos pagamentos semanais
function updateWeeklyPaymentsSummary(payments) {
    const totalAmount = payments.reduce((sum, payment) => sum + payment.amount, 0);
    const totalFines = payments.reduce((sum, payment) => sum + (payment.fine_amount || 0), 0);
    const totalCount = payments.length;
    const uniqueClients = new Set(payments.map(p => p.loans?.client_id).filter(Boolean)).size;

    // Atualizar elementos do DOM
    const totalAmountEl = document.getElementById('totalPaymentsAmount');
    const totalFinesEl = document.getElementById('totalFinesAmount');
    const totalCountEl = document.getElementById('totalPaymentsCount');
    const uniqueClientsEl = document.getElementById('uniqueClientsCount');

    if (totalAmountEl) totalAmountEl.textContent = `R$ ${totalAmount.toFixed(2)}`;
    if (totalFinesEl) totalFinesEl.textContent = `R$ ${totalFines.toFixed(2)}`;
    if (totalCountEl) totalCountEl.textContent = totalCount.toString();
    if (uniqueClientsEl) uniqueClientsEl.textContent = uniqueClients.toString();
}

// Função para obter classe CSS do método de pagamento
function getPaymentMethodBadgeClass(method) {
    const classes = {
        'pix': 'bg-purple-100 text-purple-800',
        'dinheiro': 'bg-green-100 text-green-800',
        'transferencia': 'bg-blue-100 text-blue-800',
        'cartao': 'bg-yellow-100 text-yellow-800',
        'cheque': 'bg-gray-100 text-gray-800'
    };
    return classes[method] || 'bg-gray-100 text-gray-800';
}

// Função para obter texto do método de pagamento
function getPaymentMethodText(method) {
    const methods = {
        'pix': 'PIX',
        'dinheiro': 'Dinheiro',
        'transferencia': 'Transferência',
        'cartao': 'Cartão',
        'cheque': 'Cheque'
    };
    return methods[method] || method;
}


// =====================================================
// SISTEMA DE GERAÇÃO AUTOMÁTICA DE PDFs SEMANAIS
// =====================================================

// Função para verificar se deve gerar PDF automático semanal
function checkAndGenerateWeeklyPDF() {
    const lastGeneratedKey = 'lastWeeklyPDFGenerated';
    const lastGenerated = localStorage.getItem(lastGeneratedKey);
    const now = new Date();
    const currentWeek = getWeekNumber(now);
    const currentYear = now.getFullYear();
    const currentWeekKey = `${currentYear}-W${currentWeek}`;
    
    // Se não foi gerado esta semana, gerar automaticamente
    if (lastGenerated !== currentWeekKey) {
        console.log('Gerando PDF semanal automático...');
        generateWeeklyPaymentsPDF();
        localStorage.setItem(lastGeneratedKey, currentWeekKey);
        addToWeeklyPDFHistory(currentWeekKey);
    }
}

// Função para obter número da semana do ano
function getWeekNumber(date) {
    const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
    const dayNum = d.getUTCDay() || 7;
    d.setUTCDate(d.getUTCDate() + 4 - dayNum);
    const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
    return Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
}

// Inicializar verificação automática de PDF semanal
function initializeWeeklyPDFCheck() {
    // Verificar imediatamente
    checkAndGenerateWeeklyPDF();
    
    // Verificar a cada hora (3600000 ms)
    setInterval(checkAndGenerateWeeklyPDF, 3600000);
}

// Função para mostrar histórico de PDFs gerados
function showWeeklyPDFHistory() {
    const history = getWeeklyPDFHistory();
    let historyText = 'Histórico de PDFs Semanais Gerados:\n\n';
    
    if (history.length === 0) {
        historyText += 'Nenhum PDF semanal foi gerado ainda.';
    } else {
        history.forEach((entry, index) => {
            historyText += `${index + 1}. Semana ${entry.week} - ${entry.date}\n`;
        });
    }
    
    alert(historyText);
}

// Função para obter histórico de PDFs gerados
function getWeeklyPDFHistory() {
    const historyKey = 'weeklyPDFHistory';
    const history = localStorage.getItem(historyKey);
    return history ? JSON.parse(history) : [];
}

// Função para adicionar entrada ao histórico
function addToWeeklyPDFHistory(weekKey) {
    const historyKey = 'weeklyPDFHistory';
    const history = getWeeklyPDFHistory();
    const now = new Date();
    
    history.push({
        week: weekKey,
        date: now.toLocaleDateString('pt-BR'),
        timestamp: now.getTime()
    });
    
    // Manter apenas os últimos 12 registros (3 meses)
    if (history.length > 12) {
        history.splice(0, history.length - 12);
    }
    
    localStorage.setItem(historyKey, JSON.stringify(history));
}

// =====================================================
// FUNÇÕES DE SELEÇÃO DE SEMANAS E MODAIS
// =====================================================

// Variável global para armazenar dados da semana selecionada
let selectedWeekData = null;

// Função para popular o seletor de semanas
async function populateWeekSelector() {
    try {
        const weekSelector = document.getElementById('weekSelector');
        if (!weekSelector) return;

        // Buscar todas as datas de pagamentos para determinar as semanas disponíveis
        const { data: payments, error } = await supabase
            .from('payments')
            .select('payment_date')
            .order('payment_date', { ascending: false });

        if (error) throw error;

        // Agrupar por semanas
        const weeks = new Map();
        const now = new Date();

        payments.forEach(payment => {
            const date = new Date(payment.payment_date);
            const weekInfo = getWeekInfo(date);
            const weekKey = `${weekInfo.year}-W${weekInfo.week}`;
            
            if (!weeks.has(weekKey)) {
                // Usar as datas originais do getWeekInfo para manter consistência
                weeks.set(weekKey, {
                    key: weekKey,
                    year: weekInfo.year,
                    week: weekInfo.week,
                    startDate: weekInfo.startDate,
                    endDate: weekInfo.endDate,
                    label: `Semana ${weekInfo.week}/${weekInfo.year} (${weekInfo.startDate.toLocaleDateString('pt-BR')} - ${weekInfo.endDate.toLocaleDateString('pt-BR')})`
                });
            }
        });

        // Adicionar semana atual se não existir
        const currentWeekInfo = getWeekInfo(now);
        const currentWeekKey = `${currentWeekInfo.year}-W${currentWeekInfo.week}`;
        if (!weeks.has(currentWeekKey)) {
            weeks.set(currentWeekKey, {
                key: currentWeekKey,
                year: currentWeekInfo.year,
                week: currentWeekInfo.week,
                startDate: currentWeekInfo.startDate,
                endDate: currentWeekInfo.endDate,
                label: `Semana ${currentWeekInfo.week}/${currentWeekInfo.year} (${currentWeekInfo.startDate.toLocaleDateString('pt-BR')} - ${currentWeekInfo.endDate.toLocaleDateString('pt-BR')}) - ATUAL`
            });
        }

        // Converter para array e ordenar por data
        const sortedWeeks = Array.from(weeks.values()).sort((a, b) => b.startDate - a.startDate);

        // Popular o select
        weekSelector.innerHTML = '<option value="">Selecione uma semana</option>';
        sortedWeeks.forEach(week => {
            const option = document.createElement('option');
            option.value = week.key;
            option.textContent = week.label;
            option.dataset.startDate = week.startDate.toISOString();
            option.dataset.endDate = week.endDate.toISOString();
            weekSelector.appendChild(option);
        });

        // Selecionar semana atual por padrão
        weekSelector.value = currentWeekKey;
        handleWeekChange();

    } catch (error) {
        console.error('Erro ao popular seletor de semanas:', error);
        showErrorMessage('Erro ao carregar semanas disponíveis');
    }
}

// Função para obter informações da semana - LÓGICA FIXA E SIMPLES
function getWeekInfo(date) {
    const d = new Date(date);
    const year = d.getFullYear();
    
    // Definir semanas fixas manualmente para 2025 (atualizado do 2024)
    const weekRanges = [
        { start: new Date(2025, 8, 29), end: new Date(2025, 9, 5), week: 40 },   // 29/09 - 05/10
        { start: new Date(2025, 9, 6), end: new Date(2025, 9, 12), week: 41 },   // 06/10 - 12/10
        { start: new Date(2025, 9, 13), end: new Date(2025, 9, 19), week: 42 },  // 13/10 - 19/10
        { start: new Date(2025, 9, 20), end: new Date(2025, 9, 26), week: 43 },  // 20/10 - 26/10
        { start: new Date(2025, 9, 27), end: new Date(2025, 10, 2), week: 44 },  // 27/10 - 02/11
        { start: new Date(2025, 10, 3), end: new Date(2025, 10, 9), week: 45 },  // 03/11 - 09/11
        { start: new Date(2025, 10, 10), end: new Date(2025, 10, 16), week: 46 }, // 10/11 - 16/11
    ];
    
    // Encontrar em qual semana a data se encaixa
    for (const range of weekRanges) {
        range.start.setHours(0, 0, 0, 0);
        range.end.setHours(23, 59, 59, 999);
        
        if (d >= range.start && d <= range.end) {
            return {
                year: year,
                week: range.week,
                startDate: new Date(range.start),
                endDate: new Date(range.end)
            };
        }
    }
    
    // Se não encontrou, calcular dinamicamente baseado na última semana definida
    const lastWeek = weekRanges[weekRanges.length - 1];
    const daysDiff = Math.floor((d - lastWeek.end) / (24 * 60 * 60 * 1000));
    const weeksAfter = Math.floor(daysDiff / 7) + 1;
    
    const startDate = new Date(lastWeek.end);
    startDate.setDate(lastWeek.end.getDate() + 1 + ((weeksAfter - 1) * 7));
    startDate.setHours(0, 0, 0, 0);
    
    const endDate = new Date(startDate);
    endDate.setDate(startDate.getDate() + 6);
    endDate.setHours(23, 59, 59, 999);
    
    return {
        year: year,
        week: lastWeek.week + weeksAfter,
        startDate: startDate,
        endDate: endDate
    };
}



// Função para lidar com mudança de semana
async function handleWeekChange() {
    const weekSelector = document.getElementById('weekSelector');
    const selectedOption = weekSelector.selectedOptions[0];
    
    if (!selectedOption || !selectedOption.value) {
        selectedWeekData = null;
        updatePaymentPeriodDisplay('Nenhuma semana selecionada');
        return;
    }

    const startDate = new Date(selectedOption.dataset.startDate);
    const endDate = new Date(selectedOption.dataset.endDate);
    
    selectedWeekData = {
        key: selectedOption.value,
        startDate,
        endDate,
        label: selectedOption.textContent
    };

    // Atualizar display do período
    updatePaymentPeriodDisplay(`${startDate.toLocaleDateString('pt-BR')} - ${endDate.toLocaleDateString('pt-BR')}`);

    // Carregar dados da semana selecionada
    await loadWeekData(startDate, endDate);
}

// Função para carregar dados de uma semana específica
async function loadWeekData(startDate, endDate) {
    try {
        const startDateStr = startDate.toISOString().split('T')[0];
        const endDateStr = endDate.toISOString().split('T')[0];
        
        // Buscar pagamentos da semana selecionada
        const { data: payments, error } = await supabase
            .from('payments')
            .select(`
                *,
                loans (
                    id,
                    amount,
                    client_id,
                    clients (
                        id,
                        name,
                        phone
                    )
                )
            `)
            .gte('payment_date', startDateStr)
            .lte('payment_date', endDateStr)
            .order('payment_date', { ascending: false });

        if (error) throw error;


        // Renderizar dados na tabela
        renderWeeklyPaymentsTable(payments || []);
        updateWeeklyPaymentsSummary(payments || []);

    } catch (error) {
        console.error('Erro ao carregar dados da semana:', error);
        showErrorMessage('Erro ao carregar dados da semana selecionada');
    }
}

// Função para atualizar display do período
function updatePaymentPeriodDisplay(text) {
    const display = document.getElementById('paymentPeriodDisplay');
    if (display) {
        display.textContent = text;
    }
}

// Função para mostrar modal de clientes da semana
async function showWeekClientsModal() {
    if (!selectedWeekData) {
        showErrorMessage('Selecione uma semana primeiro');
        return;
    }

    const modal = document.getElementById('weekClientsModal');
    const content = document.getElementById('weekClientsContent');
    
    showModal(modal);
    
    // Mostrar loading
    content.innerHTML = `
        <div class="text-center py-8">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto"></div>
            <p class="text-gray-400 mt-2">Carregando clientes...</p>
        </div>
    `;

    try {
        // Buscar pagamentos da semana com detalhes dos clientes
        const { data: payments, error } = await supabase
            .from('payments')
            .select(`
                *,
                loans (
                    id,
                    amount,
                    interest_rate,
                    clients (
                        id,
                        name,
                        phone,
                        email
                    )
                )
            `)
            .gte('payment_date', selectedWeekData.startDate.toISOString().split('T')[0])
            .lte('payment_date', selectedWeekData.endDate.toISOString().split('T')[0])
            .order('payment_date', { ascending: false });

        if (error) throw error;

        // Agrupar por cliente
        const clientsMap = new Map();
        payments.forEach(payment => {
            const client = payment.loans?.clients;
            if (!client) return;

            if (!clientsMap.has(client.id)) {
                clientsMap.set(client.id, {
                    ...client,
                    payments: [],
                    totalPaid: 0,
                    paymentCount: 0
                });
            }

            const clientData = clientsMap.get(client.id);
            clientData.payments.push(payment);
            clientData.totalPaid += payment.amount;
            clientData.paymentCount++;
        });

        const clients = Array.from(clientsMap.values());
        renderWeekClientsModal(clients, selectedWeekData);

    } catch (error) {
        console.error('Erro ao carregar clientes da semana:', error);
        content.innerHTML = `
            <div class="text-center py-8 text-red-400">
                <p>Erro ao carregar clientes</p>
                <p class="text-sm mt-2">${error.message}</p>
            </div>
        `;
    }
}

// Função para renderizar modal de clientes
function renderWeekClientsModal(clients, weekData) {
    const content = document.getElementById('weekClientsContent');
    
    if (clients.length === 0) {
        content.innerHTML = `
            <div class="text-center py-8 text-gray-400">
                <svg class="w-16 h-16 mx-auto mb-4 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                </svg>
                <p class="text-lg font-semibold">Nenhum cliente pagou nesta semana</p>
                <p class="text-sm mt-2">${weekData.label}</p>
            </div>
        `;
        return;
    }

    const totalAmount = clients.reduce((sum, client) => sum + client.totalPaid, 0);
    const totalPayments = clients.reduce((sum, client) => sum + client.paymentCount, 0);

    content.innerHTML = `
        <div class="mb-6">
            <h4 class="text-lg font-semibold text-white mb-2">${weekData.label}</h4>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div class="bg-gray-700 p-4 rounded-lg text-center">
                    <p class="text-sm text-gray-400">Clientes</p>
                    <p class="text-2xl font-bold text-white">${clients.length}</p>
                </div>
                <div class="bg-gray-700 p-4 rounded-lg text-center">
                    <p class="text-sm text-gray-400">Total Pagamentos</p>
                    <p class="text-2xl font-bold text-white">${totalPayments}</p>
                </div>
                <div class="bg-gray-700 p-4 rounded-lg text-center">
                    <p class="text-sm text-gray-400">Total Recebido</p>
                    <p class="text-2xl font-bold text-green-400">R$ ${totalAmount.toFixed(2)}</p>
                </div>
            </div>
        </div>

        <div class="space-y-4">
            ${clients.map(client => `
                <div class="bg-gray-700 rounded-lg p-4">
                    <div class="flex justify-between items-start mb-3">
                        <div>
                            <h5 class="text-lg font-semibold text-white">${client.name}</h5>
                            <p class="text-sm text-gray-400">${client.phone || 'Telefone não informado'}</p>
                            ${client.email ? `<p class="text-sm text-gray-400">${client.email}</p>` : ''}
                        </div>
                        <div class="text-right">
                            <p class="text-lg font-bold text-green-400">R$ ${client.totalPaid.toFixed(2)}</p>
                            <p class="text-sm text-gray-400">${client.paymentCount} pagamento${client.paymentCount > 1 ? 's' : ''}</p>
                        </div>
                    </div>
                    
                    <div class="space-y-2">
                        ${client.payments.map(payment => `
                            <div class="flex justify-between items-center bg-gray-800 p-2 rounded">
                                <div>
                                    <p class="text-sm text-white">${formatDate(payment.payment_date)}</p>
                                    <p class="text-xs text-gray-400">Empréstimo #${payment.loan_id}</p>
                                </div>
                                <div class="text-right">
                                    <p class="text-sm font-semibold text-green-400">R$ ${payment.amount.toFixed(2)}</p>
                                    <p class="text-xs text-gray-400">${getPaymentMethodText(payment.payment_method)}</p>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                </div>
            `).join('')}
        </div>
    `;
}

// Função para mostrar modal de histórico de PDFs
async function showPDFHistoryModal() {
    const modal = document.getElementById('pdfHistoryModal');
    const content = document.getElementById('pdfHistoryContent');
    
    showModal(modal);
    
    // Mostrar loading
    content.innerHTML = `
        <div class="text-center py-8">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto"></div>
            <p class="text-gray-400 mt-2">Carregando semanas disponíveis...</p>
        </div>
    `;

    try {
        // Buscar todas as semanas que têm pagamentos
        const availableWeeks = await getAvailableWeeksForPDF();
        
        if (availableWeeks.length === 0) {
            content.innerHTML = `
                <div class="text-center py-8 text-gray-400">
                    <svg class="w-16 h-16 mx-auto mb-4 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                    <p class="text-lg font-semibold">Nenhuma semana com pagamentos encontrada</p>
                    <p class="text-sm mt-2">Quando houver pagamentos registrados, as semanas aparecerão aqui</p>
                </div>
            `;
            return;
        }

        // Obter histórico local de PDFs gerados
        const localHistory = getWeeklyPDFHistory();
        const generatedWeeks = new Set(localHistory.map(entry => entry.week));

        content.innerHTML = `
            <div class="mb-6">
                <h4 class="text-lg font-semibold text-white mb-2">Semanas Disponíveis para PDF</h4>
                <p class="text-gray-400">Total de semanas com pagamentos: <span class="text-white font-semibold">${availableWeeks.length}</span></p>
                <p class="text-gray-400">PDFs já gerados: <span class="text-green-400 font-semibold">${generatedWeeks.size}</span></p>
            </div>
            
            <div class="space-y-3">
                ${availableWeeks.map(week => {
                    const wasGenerated = generatedWeeks.has(week.key);
                    const generatedInfo = wasGenerated ? localHistory.find(entry => entry.week === week.key) : null;
                    
                    return `
                        <div class="bg-gray-700 rounded-lg p-4">
                            <div class="flex justify-between items-start mb-3">
                                <div class="flex-1">
                                    <div class="flex items-center space-x-2 mb-1">
                                        <h5 class="text-white font-semibold">${week.key}</h5>
                                        ${wasGenerated ? `
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                                                </svg>
                                                PDF Gerado
                                            </span>
                                        ` : `
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                Disponível
                                            </span>
                                        `}
                                    </div>
                                    <p class="text-sm text-gray-400">${week.startDate.toLocaleDateString('pt-BR')} - ${week.endDate.toLocaleDateString('pt-BR')}</p>
                                    <div class="flex items-center space-x-4 mt-2 text-xs text-gray-400">
                                        <span>💰 ${week.totalAmount.toFixed(2)}</span>
                                        <span>📊 ${week.paymentCount} pagamentos</span>
                                        <span>👥 ${week.clientCount} clientes</span>
                                    </div>
                                    ${wasGenerated && generatedInfo ? `
                                        <p class="text-xs text-green-400 mt-1">Último PDF gerado em: ${generatedInfo.date}</p>
                                    ` : ''}
                                </div>
                                <div class="flex flex-col space-y-2 ml-4">
                                    <button onclick="generatePDFForSpecificWeek('${week.key}', '${week.startDate.toISOString()}', '${week.endDate.toISOString()}')" 
                                            class="bg-blue-600 hover:bg-blue-700 px-3 py-1 rounded text-sm text-white transition-colors whitespace-nowrap">
                                        ${wasGenerated ? 'Gerar Novamente' : 'Gerar PDF'}
                                    </button>
                                    <button onclick="showWeekDetailsInModal('${week.key}', '${week.startDate.toISOString()}', '${week.endDate.toISOString()}')" 
                                            class="bg-green-600 hover:bg-green-700 px-3 py-1 rounded text-sm text-white transition-colors whitespace-nowrap">
                                        Ver Detalhes
                                    </button>
                                </div>
                            </div>
                        </div>
                    `;
                }).join('')}
            </div>
        `;

    } catch (error) {
        console.error('Erro ao carregar histórico de PDFs:', error);
        content.innerHTML = `
            <div class="text-center py-8 text-red-400">
                <p class="text-lg font-semibold">Erro ao carregar dados</p>
                <p class="text-sm mt-2">${error.message}</p>
                <button onclick="showPDFHistoryModal()" class="mt-4 bg-blue-600 hover:bg-blue-700 px-4 py-2 rounded text-white transition-colors">
                    Tentar Novamente
                </button>
            </div>
        `;
    }
}

// Função para obter todas as semanas disponíveis para PDF
async function getAvailableWeeksForPDF() {
    try {
        // Buscar todos os pagamentos com informações dos clientes
        const { data: payments, error } = await supabase
            .from('payments')
            .select(`
                payment_date,
                amount,
                loans (
                    clients (
                        id
                    )
                )
            `)
            .order('payment_date', { ascending: false });

        if (error) throw error;

        // Agrupar por semanas
        const weeks = new Map();

        payments.forEach(payment => {
            const date = new Date(payment.payment_date);
            const weekInfo = getWeekInfo(date);
            const weekKey = `${weekInfo.year}-W${weekInfo.week}`;
            
            if (!weeks.has(weekKey)) {
                weeks.set(weekKey, {
                    key: weekKey,
                    year: weekInfo.year,
                    week: weekInfo.week,
                    startDate: weekInfo.startDate,
                    endDate: weekInfo.endDate,
                    payments: [],
                    totalAmount: 0,
                    paymentCount: 0,
                    clients: new Set()
                });
            }

            const weekData = weeks.get(weekKey);
            weekData.payments.push(payment);
            weekData.totalAmount += payment.amount;
            weekData.paymentCount++;
            
            // Adicionar cliente único
            if (payment.loans?.clients?.id) {
                weekData.clients.add(payment.loans.clients.id);
            }
        });

        // Converter para array e adicionar contagem de clientes
        const availableWeeks = Array.from(weeks.values()).map(week => ({
            ...week,
            clientCount: week.clients.size,
            clients: undefined // Remove o Set para não causar problemas na serialização
        }));

        // Ordenar por data (mais recentes primeiro)
        return availableWeeks.sort((a, b) => b.startDate - a.startDate);

    } catch (error) {
        console.error('Erro ao buscar semanas disponíveis:', error);
        throw error;
    }
}

// Função para gerar PDF de uma semana específica (chamada pelo modal)
async function generatePDFForSpecificWeek(weekKey, startDateISO, endDateISO) {
    try {
        // Usar as datas originais passadas pelo modal (já estão corretas)
        const startDate = new Date(startDateISO);
        const endDate = new Date(endDateISO);
        
        await generateWeeklyPaymentsPDFForDates(startDate, endDate);
        
        // Fechar modal e mostrar novamente para atualizar status
        hideModal(document.getElementById('pdfHistoryModal'));
        setTimeout(() => {
            showPDFHistoryModal();
        }, 500);
        
    } catch (error) {
        console.error('Erro ao gerar PDF:', error);
        showErrorMessage('Erro ao gerar PDF: ' + error.message);
    }
}

// Função para mostrar detalhes de uma semana no modal
async function showWeekDetailsInModal(weekKey, startDateISO, endDateISO) {
    try {
        // Usar as datas originais passadas pelo modal (já estão corretas)
        const startDate = new Date(startDateISO);
        const endDate = new Date(endDateISO);
        
        // Simular seleção da semana e mostrar modal de clientes
        selectedWeekData = {
            key: weekKey,
            startDate,
            endDate,
            label: `${weekKey} (${startDate.toLocaleDateString('pt-BR')} - ${endDate.toLocaleDateString('pt-BR')})`
        };
        
        // Fechar modal de histórico
        hideModal(document.getElementById('pdfHistoryModal'));
        
        // Mostrar modal de clientes após pequeno delay
        setTimeout(() => {
            showWeekClientsModal();
        }, 300);
        
    } catch (error) {
        console.error('Erro ao mostrar detalhes da semana:', error);
        showErrorMessage('Erro ao carregar detalhes da semana');
    }
}

// Função para regenerar PDF de uma semana específica
async function regeneratePDFForWeek(weekKey) {
    try {
        // Esta função não deveria ser chamada mais, mas mantendo para compatibilidade
        showErrorMessage('Use a função "Gerar Novamente" no modal de semanas passadas');
        
    } catch (error) {
        console.error('Erro ao regenerar PDF:', error);
        showErrorMessage('Erro ao regenerar PDF: ' + error.message);
    }
}

// Atualizar função de geração de PDF para usar semana selecionada
async function generateWeeklyPaymentsPDFForSelectedWeek() {
    if (!selectedWeekData) {
        showErrorMessage('Selecione uma semana primeiro');
        return;
    }
    
    await generateWeeklyPaymentsPDFForDates(selectedWeekData.startDate, selectedWeekData.endDate);
}

// Função para gerar PDF para datas específicas
async function generateWeeklyPaymentsPDFForDates(startDate, endDate) {
    try {
        // Garantir que as datas estão no formato correto e no início/fim do dia
        const startDateFormatted = new Date(startDate);
        startDateFormatted.setHours(0, 0, 0, 0);
        
        const endDateFormatted = new Date(endDate);
        endDateFormatted.setHours(23, 59, 59, 999);
        
        const startDateStr = startDateFormatted.toISOString().split('T')[0];
        const endDateStr = endDateFormatted.toISOString().split('T')[0];
        
        // Buscar todos os pagamentos da semana especificada
        const { data: weeklyPayments, error } = await supabase
            .from('payments')
            .select(`
                *,
                loans!inner (
                    id,
                    amount,
                    interest_rate,
                    clients!inner (
                        name,
                        phone
                    )
                )
            `)
            .gte('payment_date', startDateStr)
            .lte('payment_date', endDateStr)
            .order('payment_date', { ascending: false });

        if (error) throw error;

        const allWeeklyPayments = weeklyPayments || [];
        

        // Criar PDF (usando a mesma lógica da função original)
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();
        
        // Configurar fonte
        doc.setFont('helvetica');
        
        // Título
        doc.setFontSize(18);
        doc.setFont('helvetica', 'bold');
        doc.text('RELATÓRIO DE PAGAMENTOS SEMANAIS', 105, 20, { align: 'center' });
        
        // Período
        doc.setFontSize(12);
        doc.setFont('helvetica', 'normal');
        const periodText = `Período: ${startDate.toLocaleDateString('pt-BR')} a ${endDate.toLocaleDateString('pt-BR')}`;
        doc.text(periodText, 105, 30, { align: 'center' });
        
        // Data de geração
        doc.setFontSize(10);
        doc.text(`Gerado em: ${new Date().toLocaleDateString('pt-BR')} às ${new Date().toLocaleTimeString('pt-BR')}`, 20, 40);
        
        // Linha divisória
        doc.line(20, 45, 190, 45);
        
        let yPosition = 55;
        
        // Resumo
        doc.setFontSize(14);
        doc.setFont('helvetica', 'bold');
        doc.text('RESUMO SEMANAL', 20, yPosition);
        yPosition += 10;
        
        // Calcular totais
        const totalPayments = allWeeklyPayments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        const totalCapital = allWeeklyPayments.reduce((sum, payment) => {
            const loan = payment.loans;
            const loanAmount = parseFloat(loan.amount);
            const interestAmount = loanAmount * parseFloat(loan.interest_rate) / 100;
            const capitalPortion = parseFloat(payment.amount) > interestAmount ? 
                parseFloat(payment.amount) - interestAmount : 0;
            return sum + capitalPortion;
        }, 0);
        const totalInterest = totalPayments - totalCapital;
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Total de Pagamentos: ${allWeeklyPayments.length}`, 20, yPosition);
        yPosition += 8;
        doc.text(`Total Recebido: R$ ${totalPayments.toFixed(2)}`, 20, yPosition);
        yPosition += 8;
        doc.text(`Total em Juros: R$ ${totalInterest.toFixed(2)}`, 20, yPosition);
        yPosition += 8;
        doc.text(`Total em Capital: R$ ${totalCapital.toFixed(2)}`, 20, yPosition);
        yPosition += 8;
        
        // Calcular e exibir total de multas
        const totalFines = allWeeklyPayments.reduce((sum, payment) => sum + (parseFloat(payment.fine_amount) || 0), 0);
        doc.text(`Total em Multas: R$ ${totalFines.toFixed(2)}`, 20, yPosition);
        yPosition += 15;
        
        // Linha divisória
        doc.line(20, yPosition, 190, yPosition);
        yPosition += 10;
        
        // Cabeçalho da tabela
        doc.setFontSize(12);
        doc.setFont('helvetica', 'bold');
        doc.text('DETALHAMENTO DOS PAGAMENTOS', 20, yPosition);
        yPosition += 10;
        
        if (allWeeklyPayments.length > 0) {
            // Cabeçalhos das colunas
            doc.setFontSize(9);
            doc.setFont('helvetica', 'bold');
            doc.text('Data', 20, yPosition);
            doc.text('Cliente', 45, yPosition);
            doc.text('Valor Pago', 100, yPosition);
            doc.text('Multa', 130, yPosition);
            doc.text('Juros', 160, yPosition);
            doc.text('Capital', 180, yPosition);
            yPosition += 5;
            
            // Linha separadora
            doc.line(20, yPosition, 190, yPosition);
            yPosition += 8;
            
            // Dados dos pagamentos
            doc.setFont('helvetica', 'normal');
            
            for (const payment of allWeeklyPayments) {
                if (yPosition > 270) {
                    doc.addPage();
                    yPosition = 20;
                }
                
                const client = payment.loans.clients;
                const loan = payment.loans;
                const paymentAmount = parseFloat(payment.amount);
                const loanAmount = parseFloat(loan.amount);
                const interestRate = parseFloat(loan.interest_rate);
                const interestAmount = loanAmount * interestRate / 100;
                
                let interestPaid = 0;
                let capitalPaid = 0;
                let paymentTypeText = '';
                
                if (payment.is_settlement) {
                    // Quitação total
                    interestPaid = interestAmount;
                    capitalPaid = paymentAmount - interestAmount;
                    paymentTypeText = 'QUITAÇÃO';
                } else if (paymentAmount <= interestAmount) {
                    // Pagamento apenas de juros
                    interestPaid = paymentAmount;
                    capitalPaid = 0;
                    paymentTypeText = 'JUROS';
                } else {
                    // Pagamento de juros + capital
                    interestPaid = interestAmount;
                    capitalPaid = paymentAmount - interestAmount;
                    paymentTypeText = 'PGTO';
                }
                
                const fineAmount = parseFloat(payment.fine_amount) || 0;
                
                doc.text(formatDate(payment.payment_date), 20, yPosition);
                doc.text(client.name.substring(0, 18), 45, yPosition);
                doc.text(`R$ ${paymentAmount.toFixed(2)}`, 100, yPosition);
                doc.text(fineAmount > 0 ? `R$ ${fineAmount.toFixed(2)}` : '-', 130, yPosition);
                doc.text(`R$ ${interestPaid.toFixed(2)}`, 160, yPosition);
                doc.text(`R$ ${capitalPaid.toFixed(2)}`, 180, yPosition);
                
                yPosition += 8;
            }
            
            // Rodapé com totais
            yPosition += 10;
            doc.line(20, yPosition, 190, yPosition);
            yPosition += 8;
            
            doc.setFont('helvetica', 'bold');
            doc.text('TOTAIS DA SEMANA:', 20, yPosition);
            doc.text(`R$ ${totalPayments.toFixed(2)}`, 100, yPosition);
            doc.text(`R$ ${totalFines.toFixed(2)}`, 130, yPosition);
            doc.text(`R$ ${totalInterest.toFixed(2)}`, 160, yPosition);
            doc.text(`R$ ${totalCapital.toFixed(2)}`, 180, yPosition);
        } else {
            doc.text('Nenhum pagamento encontrado no período selecionado.', 20, yPosition);
        }
        
        // Informações da empresa no rodapé
        const pageCount = doc.internal.getNumberOfPages();
        for (let i = 1; i <= pageCount; i++) {
            doc.setPage(i);
            doc.setFontSize(8);
            doc.setFont('helvetica', 'normal');
            doc.text(`Página ${i} de ${pageCount}`, 190, 290, { align: 'right' });
            doc.text('Nexus Gestão Financeira', 20, 290);
        }
        
        // Salvar o PDF
        const fileName = `Pagamentos_Semana_${startDate.toLocaleDateString('pt-BR').replace(/\//g, '-')}_a_${endDate.toLocaleDateString('pt-BR').replace(/\//g, '-')}.pdf`;
        doc.save(fileName);

        // Adicionar ao histórico
        const weekNumber = getWeekNumber(startDate);
        const year = startDate.getFullYear();
        const weekKey = `${year}-W${weekNumber}`;
        addToWeeklyPDFHistory(weekKey);

        const regularPayments = allWeeklyPayments.filter(p => !p.is_settlement).length;
        const settlements = allWeeklyPayments.filter(p => p.is_settlement).length;
        let message = `PDF gerado com sucesso! ${allWeeklyPayments.length} registros encontrados na semana`;
        if (settlements > 0) {
            message += ` (${regularPayments} pagamentos + ${settlements} quitações)`;
        }
        showSuccessMessage(message);

    } catch (error) {
        console.error('Erro ao gerar PDF dos pagamentos semanais:', error);
        showErrorMessage('Erro ao gerar PDF: ' + error.message);
    }
}

// ============================================================================
// FUNÇÕES DE COMISSÕES
// ============================================================================

// Inicializar seção de comissões
function initializeCommissionsSection() {
    // Definir data padrão (último mês)
    const today = new Date();
    const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
    const lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
    
    document.getElementById('commissionStartDate').value = firstDay.toISOString().split('T')[0];
    document.getElementById('commissionEndDate').value = lastDay.toISOString().split('T')[0];
    
    // Configurar visibilidade dos cards baseado na empresa
    const isErechim = currentCompany === 'erechim';
    const isImperatriz = currentCompany === 'imperatriz';
    const brunoCard = document.getElementById('brunoCommissionCard');
    const alexCard = document.getElementById('alexCommissionCard');
    const douglasCard = document.querySelector('.glass-card p#douglasCommission')?.closest('.glass-card');
    const commissionsGrid = document.getElementById('commissionsCardsGrid');
    const brunoColumns = document.querySelectorAll('.bruno-column');
    const alexColumns = document.querySelectorAll('.alex-column');
    const douglasColumns = document.querySelectorAll('.douglas-column');
    const viniciusLabel = document.getElementById('viniciusCommissionLabel');
    const douglasLabel = document.getElementById('douglasCommissionLabel');
    const alexLabel = document.getElementById('alexCommissionLabel');
    
    if (isErechim) {
        // ERECHIM: Mostrar Bruno, Vinicius e Douglas (33,3% cada)
        if (brunoCard) brunoCard.style.display = 'block';
        if (alexCard) alexCard.style.display = 'none';
        if (douglasCard) douglasCard.style.display = 'block';
        if (commissionsGrid) {
            commissionsGrid.className = 'grid grid-cols-1 md:grid-cols-4 gap-4 mb-6';
        }
        if (viniciusLabel) viniciusLabel.textContent = 'Comissão Vinicius (33,3%)';
        if (douglasLabel) douglasLabel.textContent = 'Comissão Douglas (33,3%)';
        brunoColumns.forEach(col => col.style.display = '');
        alexColumns.forEach(col => col.style.display = 'none');
        douglasColumns.forEach(col => col.style.display = '');
    } else if (isImperatriz) {
        // IMPERATRIZ CRED: Mostrar Vinicius e Alex (50% cada), esconder Douglas e Bruno
        if (brunoCard) brunoCard.style.display = 'none';
        if (alexCard) alexCard.style.display = 'block';
        if (douglasCard) douglasCard.style.display = 'none';
        if (commissionsGrid) {
            commissionsGrid.className = 'grid grid-cols-1 md:grid-cols-3 gap-4 mb-6';
        }
        if (viniciusLabel) viniciusLabel.textContent = 'Comissão Vinicius (50%)';
        if (alexLabel) alexLabel.textContent = 'Comissão Alex (50%)';
        brunoColumns.forEach(col => col.style.display = 'none');
        alexColumns.forEach(col => col.style.display = '');
        douglasColumns.forEach(col => col.style.display = 'none');
    } else {
        // OUTRAS EMPRESAS: Mostrar Vinicius (66,6%) e Douglas (33,3%)
        if (brunoCard) brunoCard.style.display = 'none';
        if (alexCard) alexCard.style.display = 'none';
        if (douglasCard) douglasCard.style.display = 'block';
        if (commissionsGrid) {
            commissionsGrid.className = 'grid grid-cols-1 md:grid-cols-3 gap-4 mb-6';
        }
        if (viniciusLabel) viniciusLabel.textContent = 'Comissão Vinicius (66,6%)';
        if (douglasLabel) douglasLabel.textContent = 'Comissão Douglas (33,3%)';
        brunoColumns.forEach(col => col.style.display = 'none');
        alexColumns.forEach(col => col.style.display = 'none');
        douglasColumns.forEach(col => col.style.display = '');
    }
}

// Calcular comissões
async function calculateCommissions() {
    try {
        const startDate = document.getElementById('commissionStartDate').value;
        const endDate = document.getElementById('commissionEndDate').value;
        const loanStatus = document.getElementById('commissionLoanStatus').value;
        
        console.log('Calculando comissões para:', { startDate, endDate, loanStatus });
        
        // Buscar todos os empréstimos
        const allPayments = await fetchAllPaymentsForCommissions(startDate, endDate, loanStatus);

        // Calcular comissões baseado nos pagamentos
        const commissionsData = calculateCommissionsFromPayments(allPayments);
        
        // Atualizar interface
        updateCommissionsSummary(commissionsData.summary);
        renderCommissionsTable(commissionsData.details);
        
        showSuccessMessage(`Comissões calculadas! ${commissionsData.details.length} pagamentos processados.`);
        
    } catch (error) {
        console.error('Erro ao calcular comissões:', error);
        showErrorMessage('Erro ao calcular comissões: ' + error.message);
    }
}

// Extrair valor de juros pagos das notas do pagamento
function extractPaidInterestFromNotes(notes, paymentAmount, loanAmount, interestRate) {
    console.log(`\n=== ANALISANDO PAGAMENTO ===`);
    console.log(`Valor pago: R$ ${paymentAmount.toFixed(2)}`);
    console.log(`Notas: ${notes || 'SEM NOTAS'}`);
    
    if (!notes) {
        console.log(`⚠️ SEM NOTAS - Assumindo pagamento integral como juros`);
        return paymentAmount; // Se não há notas, assumir que todo pagamento é juros
    }
    
    // 1. Tentar extrair "Juros pagos: R$ X.XX" das notas
    const jurosRegex = /Juros pagos:\s*R\$\s*([\d.,]+)/i;
    const jurosMatch = notes.match(jurosRegex);
    
    if (jurosMatch) {
        const jurosStr = jurosMatch[1].replace(/\./g, '').replace(',', '.');
        const jurosValue = parseFloat(jurosStr);
        if (!isNaN(jurosValue)) {
            console.log(`✅ JUROS EXTRAÍDOS DAS NOTAS: R$ ${jurosValue.toFixed(2)}`);
            return jurosValue;
        }
    }
    
    // 2. Tentar extrair "Capital pago: R$ X.XX" das notas
    const capitalRegex = /Capital pago:\s*R\$\s*([\d.,]+)/i;
    const capitalMatch = notes.match(capitalRegex);
    
    if (capitalMatch) {
        const capitalStr = capitalMatch[1].replace(/\./g, '').replace(',', '.');
        const capitalValue = parseFloat(capitalStr);
        if (!isNaN(capitalValue)) {
            const jurosCalculado = paymentAmount - capitalValue;
            console.log(`✅ CAPITAL EXTRAÍDO DAS NOTAS: R$ ${capitalValue.toFixed(2)}`);
            console.log(`✅ JUROS CALCULADO: R$ ${paymentAmount.toFixed(2)} - R$ ${capitalValue.toFixed(2)} = R$ ${jurosCalculado.toFixed(2)}`);
            return Math.max(0, jurosCalculado);
        }
    }
    
    // 3. Analisar tipo de pagamento pelas palavras-chave
    if (notes.includes('PAGAMENTO APENAS DE JUROS') || notes.includes('RENOVAÇÃO')) {
        console.log(`✅ PAGAMENTO APENAS DE JUROS - Todo valor é comissão: R$ ${paymentAmount.toFixed(2)}`);
        return paymentAmount;
    }
    
    if (notes.includes('PAGAMENTO PARCIAL DE JUROS')) {
        console.log(`✅ PAGAMENTO PARCIAL DE JUROS - Todo valor é comissão: R$ ${paymentAmount.toFixed(2)}`);
        return paymentAmount;
    }
    
    // 4. Para pagamentos com capital, tentar extrair valores específicos das notas
    if (notes.includes('PAGAMENTO DE CAPITAL') || notes.includes('REDUÇÃO DE CAPITAL')) {
        // Tentar extrair valores mais específicos
        const novoCapitalRegex = /Novo capital:\s*R\$\s*([\d.,]+)/i;
        const capitalAnteriorRegex = /Capital anterior:\s*R\$\s*([\d.,]+)/i;
        
        const novoCapitalMatch = notes.match(novoCapitalRegex);
        const capitalAnteriorMatch = notes.match(capitalAnteriorRegex);
        
        if (novoCapitalMatch && capitalAnteriorMatch) {
            const novoCapital = parseFloat(novoCapitalMatch[1].replace(/\./g, '').replace(',', '.'));
            const capitalAnterior = parseFloat(capitalAnteriorMatch[1].replace(/\./g, '').replace(',', '.'));
            
            if (!isNaN(novoCapital) && !isNaN(capitalAnterior)) {
                const capitalPago = capitalAnterior - novoCapital;
                const jurosCalculado = paymentAmount - capitalPago;
                console.log(`✅ CAPITAL CALCULADO: R$ ${capitalAnterior.toFixed(2)} - R$ ${novoCapital.toFixed(2)} = R$ ${capitalPago.toFixed(2)}`);
                console.log(`✅ JUROS CALCULADO: R$ ${paymentAmount.toFixed(2)} - R$ ${capitalPago.toFixed(2)} = R$ ${jurosCalculado.toFixed(2)}`);
                return Math.max(0, jurosCalculado);
            }
        }
    }
    
    // 5. Caso padrão: assumir que todo o pagamento é juros (mais conservador para comissões)
    console.log(`⚠️ NÃO CONSEGUIU EXTRAIR - Assumindo todo pagamento como juros: R$ ${paymentAmount.toFixed(2)}`);
    return paymentAmount;
}

// Buscar todos os pagamentos para cálculo de comissões
async function fetchAllPaymentsForCommissions(startDate, endDate, loanStatus) {
    const allPayments = [];
    
    try {
        console.log('Buscando TODOS os pagamentos do sistema...');
        
        // 1. Buscar TODOS os pagamentos da tabela payments (pagamentos de empréstimos regulares)
        const paymentsQuery = supabase
            .from('payments')
            .select(`
                *,
                loans (
                    id,
                    amount,
                    interest_rate,
                    loan_date,
                    due_date,
                    status,
                    clients (
                        id,
                        name,
                        cpf
                    )
                )
            `)
            .limit(10000);
        
        // 2. NÃO buscar pagamentos de parcelamentos (conforme solicitado)
        
        // 3. Buscar empréstimos quitados (paid_loans) - SEM relacionamento
        const paidLoansQuery = supabase
            .from('paid_loans')
            .select('*')
            .limit(10000);
        
        // 4. Buscar clientes para join manual
        const clientsQuery = supabase
            .from('clients')
            .select('id, name, cpf')
            .limit(10000);
        
        // Executar as consultas em paralelo (SEM parcelamentos)
        const [paymentsResult, paidLoansResult, clientsResult] = await Promise.all([
            paymentsQuery,
            paidLoansQuery,
            clientsQuery
        ]);
        
        if (paymentsResult.error) {
            console.error('Erro na consulta de pagamentos:', paymentsResult.error);
            throw paymentsResult.error;
        }
        
        const payments = paymentsResult.data || [];
        const paidLoans = (paidLoansResult.error ? [] : paidLoansResult.data) || [];
        const clients = (clientsResult.error ? [] : clientsResult.data) || [];
        
        if (paidLoansResult.error) {
            console.error('ERRO na consulta paid_loans:', paidLoansResult.error);
        }
        if (clientsResult.error) {
            console.error('ERRO na consulta clients:', clientsResult.error);
        }
        
        // Criar mapa de clientes para join manual
        const clientsMap = {};
        clients.forEach(client => {
            clientsMap[client.id] = client;
        });
        
        console.log(`Dados encontrados por tabela:`);
        console.log(`- Pagamentos regulares (payments): ${payments.length}`);
        console.log(`- Empréstimos quitados (paid_loans): ${paidLoans.length}`);
        console.log(`- Clientes para join: ${clients.length}`);
        
        // Processar pagamentos regulares
        payments.forEach(payment => {
            if (payment.loans) {
                const loan = payment.loans;
                const loanAmount = parseFloat(loan.amount || 0);
                const interestRate = parseFloat(loan.interest_rate || 0);
                const paymentAmount = parseFloat(payment.amount || 0);
                
                // Extrair valor de juros pagos das notas do pagamento
                const paidInterest = extractPaidInterestFromNotes(payment.notes, paymentAmount, loanAmount, interestRate);
                const paidCapital = Math.max(0, paymentAmount - paidInterest);
                
                console.log(`RESULTADO FINAL - Pagamento ID ${payment.id}:`);
                console.log(`- Valor total pago: R$ ${paymentAmount.toFixed(2)}`);
                console.log(`- Juros pagos (COMISSÃO): R$ ${paidInterest.toFixed(2)}`);
                console.log(`- Capital pago: R$ ${paidCapital.toFixed(2)}`);
                console.log(`- Vinicius (66%): R$ ${(paidInterest * 0.66).toFixed(2)}`);
                console.log(`- Douglas (33%): R$ ${(paidInterest * 0.33).toFixed(2)}`);
                
                allPayments.push({
                    id: payment.id,
                    payment_date: payment.payment_date,
                    payment_amount: paymentAmount,
                    loan_amount: loanAmount,
                    interest_rate: interestRate,
                    interest_amount: loanAmount * (interestRate / 100), // Juros totais do empréstimo
                    commissionable_amount: paidInterest, // Comissão = JUROS PAGOS INTEGRALMENTE
                    paid_interest: paidInterest,
                    paid_capital: paidCapital,
                    client: loan.clients,
                    loan_id: loan.id,
                    loan_date: loan.loan_date,
                    loan_status: loan.status,
                    payment_type: 'regular',
                    notes: payment.notes
                });
            }
        });
        
        // NÃO processar pagamentos de parcelamentos (conforme solicitado)
        
        // Processar empréstimos quitados (paid_loans) - NOVA FUNCIONALIDADE
        console.log(`\n🔍 PROCESSANDO ${paidLoans.length} EMPRÉSTIMOS QUITADOS...`);
        
        paidLoans.forEach((paidLoan, index) => {
            const loanAmount = parseFloat(paidLoan.original_amount || 0);
            const interestRate = parseFloat(paidLoan.interest_rate || 0);
            const totalWithInterest = parseFloat(paidLoan.total_with_interest || 0);
            const totalPaid = parseFloat(paidLoan.total_paid || 0);
            
            // Buscar cliente usando join manual
            const client = clientsMap[paidLoan.client_id];
            
            // Calcular juros totais do empréstimo quitado
            const totalInterest = totalWithInterest - loanAmount;
            
            console.log(`\n=== EMPRÉSTIMO QUITADO ${index + 1}/${paidLoans.length} ===`);
            console.log(`ID: ${paidLoan.id}`);
            console.log(`Client ID: ${paidLoan.client_id}`);
            console.log(`Cliente: ${client?.name || 'CLIENTE NÃO ENCONTRADO'}`);
            console.log(`Valor original: R$ ${loanAmount.toFixed(2)}`);
            console.log(`Taxa de juros: ${interestRate}%`);
            console.log(`Total com juros: R$ ${totalWithInterest.toFixed(2)}`);
            console.log(`Total pago: R$ ${totalPaid.toFixed(2)}`);
            console.log(`Juros totais (COMISSÃO): R$ ${totalInterest.toFixed(2)}`);
            console.log(`Data de quitação: ${paidLoan.paid_date}`);
            
            if (totalInterest > 0) {
                allPayments.push({
                    id: `paid_loan_${paidLoan.id}`, // Prefixo para distinguir de pagamentos regulares
                    payment_date: paidLoan.paid_date,
                    payment_amount: totalPaid,
                    loan_amount: loanAmount,
                    interest_rate: interestRate,
                    interest_amount: totalInterest,
                    commissionable_amount: totalInterest, // Comissão sobre juros totais
                    paid_interest: totalInterest,
                    paid_capital: loanAmount,
                    client: client,
                    loan_id: paidLoan.loan_id,
                    loan_date: paidLoan.loan_date,
                    loan_status: 'paid',
                    payment_type: 'loan_payoff', // Novo tipo: quitação completa
                    notes: `QUITAÇÃO COMPLETA - Juros totais: R$ ${totalInterest.toFixed(2)}`
                });
                console.log(`✅ ADICIONADO À LISTA DE COMISSÕES`);
            } else {
                console.log(`⚠️ JUROS = 0, NÃO ADICIONADO`);
            }
        });
        
        console.log(`Total de pagamentos no sistema: ${allPayments.length}`);
        console.log('Amostra de pagamentos encontrados:', allPayments.slice(0, 3).map(payment => ({
            id: payment.id,
            client: payment.client?.name || 'Sem cliente',
            payment_amount: payment.payment_amount,
            paid_interest: payment.paid_interest,
            paid_capital: payment.paid_capital,
            commissionable_amount: payment.commissionable_amount,
            payment_date: payment.payment_date,
            type: payment.payment_type,
            notes: payment.notes?.substring(0, 100) + '...'
        })));
        
        // Mostrar distribuição por data de TODOS os pagamentos
        const allDatesDistribution = {};
        const monthlyDistribution = {};
        allPayments.forEach(payment => {
            const dateStr = payment.payment_date;
            if (dateStr) {
                const date = new Date(dateStr).toISOString().split('T')[0];
                const month = date.substring(0, 7); // YYYY-MM
                allDatesDistribution[date] = (allDatesDistribution[date] || 0) + 1;
                monthlyDistribution[month] = (monthlyDistribution[month] || 0) + 1;
            }
        });
        console.log('Distribuição por mês de TODOS os pagamentos:', monthlyDistribution);
        console.log('Distribuição por data de TODOS os pagamentos (primeiros 20):', 
            Object.entries(allDatesDistribution)
                .sort(([a], [b]) => b.localeCompare(a))
                .slice(0, 20)
                .reduce((obj, [key, value]) => ({ ...obj, [key]: value }), {})
        );
        
        // Aplicar filtros de data APÓS buscar todos os pagamentos
        let filteredByDate = allPayments;
        if (startDate || endDate) {
            console.log(`Aplicando filtro de data nos pagamentos e quitações: ${startDate} até ${endDate}`);
            console.log(`Total de pagamentos/quitações antes do filtro de data: ${allPayments.length}`);
            
            filteredByDate = allPayments.filter((payment, index) => {
                const paymentDateStr = payment.payment_date;
                
                if (!paymentDateStr) {
                    console.warn('Pagamento/quitação sem data encontrado:', payment);
                    return false;
                }
                
                const paymentDate = new Date(paymentDateStr);
                paymentDate.setHours(0, 0, 0, 0);
                
                let matchesDate = true;
                let startCheck = true;
                let endCheck = true;
                
                if (startDate) {
                    const start = new Date(startDate);
                    start.setHours(0, 0, 0, 0);
                    startCheck = paymentDate >= start;
                    matchesDate = matchesDate && startCheck;
                }
                
                if (endDate) {
                    const end = new Date(endDate);
                    end.setHours(23, 59, 59, 999);
                    endCheck = paymentDate <= end;
                    matchesDate = matchesDate && endCheck;
                }
                
                // Log detalhado para os primeiros 5 itens
                if (index < 5) {
                    console.log(`${payment.payment_type === 'loan_payoff' ? 'Quitação' : 'Pagamento'} ${index + 1}:`, {
                        id: payment.id,
                        type: payment.payment_type,
                        paymentDate: paymentDate.toISOString().split('T')[0],
                        startDate: startDate,
                        endDate: endDate,
                        startCheck: startCheck,
                        endCheck: endCheck,
                        matchesDate: matchesDate,
                        amount: payment.payment_amount,
                        commission: payment.commissionable_amount
                    });
                }
                
                return matchesDate;
            });
        }
        
        console.log(`Pagamentos após filtro de data: ${filteredByDate.length}`);
        
        // Mostrar distribuição por data dos pagamentos filtrados
        if (filteredByDate.length > 0) {
            const dateDistribution = {};
            filteredByDate.forEach(payment => {
                const dateStr = payment.payment_date;
                if (dateStr) {
                    const date = new Date(dateStr).toISOString().split('T')[0];
                    dateDistribution[date] = (dateDistribution[date] || 0) + 1;
                }
            });
            console.log('Distribuição por data dos pagamentos filtrados:', dateDistribution);
        }
        
        // Aplicar filtro de status do empréstimo (se especificado)
        let finalFiltered = filteredByDate;
        if (loanStatus && loanStatus !== 'all') {
            finalFiltered = filteredByDate.filter(payment => {
                switch (loanStatus) {
                    case 'active':
                        return payment.loan_status === 'active';
                    case 'overdue':
                        return payment.loan_status === 'overdue';
                    case 'due_today':
                        return payment.loan_status === 'due_today';
                    case 'paid':
                        return payment.loan_status === 'paid';
                    case 'partial_paid':
                        return payment.loan_status === 'partial_paid';
                    default:
                        return true;
                }
            });
        }
        
        console.log(`Pagamentos finais após todos os filtros: ${finalFiltered.length}`);
        console.log('Distribuição por status do empréstimo:', {
            active: finalFiltered.filter(p => p.loan_status === 'active').length,
            overdue: finalFiltered.filter(p => p.loan_status === 'overdue').length,
            paid: finalFiltered.filter(p => p.loan_status === 'paid').length,
            installment: finalFiltered.filter(p => p.payment_type === 'installment').length
        });
        
        return finalFiltered;
        
    } catch (error) {
        console.error('Erro ao buscar pagamentos:', error);
        throw error;
    }
}

// Calcular comissões baseado nos pagamentos realizados
function calculateCommissionsFromPayments(payments) {
    const details = [];
    let totalCommissionableAmount = 0;
    
    // Verificar o tipo de empresa para dividir comissões
    const isErechim = currentCompany === 'erechim';
    const isImperatriz = currentCompany === 'imperatriz';
    
    payments.forEach(payment => {
        const commissionableAmount = parseFloat(payment.commissionable_amount || 0);
        
        let viniciusCommission, douglasCommission, brunoCommission, alexCommission;
        
        if (isErechim) {
            // ERECHIM: Dividir igualmente entre Bruno, Vinicius e Douglas (33,33% cada)
            brunoCommission = commissionableAmount / 3;
            viniciusCommission = commissionableAmount / 3;
            douglasCommission = commissionableAmount / 3;
            alexCommission = 0;
        } else if (isImperatriz) {
            // IMPERATRIZ CRED: Dividir igualmente entre Vinicius e Alex (50% cada)
            viniciusCommission = commissionableAmount * 0.5;
            alexCommission = commissionableAmount * 0.5;
            douglasCommission = 0;
            brunoCommission = 0;
        } else {
            // Outras empresas: 66,6% Vinicius, 33,3% Douglas
            viniciusCommission = commissionableAmount * 0.666;
            douglasCommission = commissionableAmount * 0.333;
            brunoCommission = 0;
            alexCommission = 0;
        }
        
        totalCommissionableAmount += commissionableAmount;
        
        details.push({
            id: payment.id,
            client: payment.client,
            paymentAmount: payment.payment_amount,
            loanAmount: payment.loan_amount,
            interestRate: payment.interest_rate,
            commissionableAmount: commissionableAmount,
            viniciusCommission: viniciusCommission,
            douglasCommission: douglasCommission,
            brunoCommission: brunoCommission,
            alexCommission: alexCommission,
            paymentDate: payment.payment_date,
            loanDate: payment.loan_date,
            status: payment.loan_status || payment.payment_type,
            paymentType: payment.payment_type,
            notes: payment.notes
        });
    });
    
    let totalViniciusCommission, totalDouglasCommission, totalBrunoCommission, totalAlexCommission;
    
    if (isErechim) {
        // ERECHIM: Dividir igualmente entre Bruno, Vinicius e Douglas
        totalBrunoCommission = totalCommissionableAmount / 3;
        totalViniciusCommission = totalCommissionableAmount / 3;
        totalDouglasCommission = totalCommissionableAmount / 3;
        totalAlexCommission = 0;
    } else if (isImperatriz) {
        // IMPERATRIZ CRED: Dividir igualmente entre Vinicius e Alex (50% cada)
        totalViniciusCommission = totalCommissionableAmount * 0.5;
        totalAlexCommission = totalCommissionableAmount * 0.5;
        totalDouglasCommission = 0;
        totalBrunoCommission = 0;
    } else {
        // Outras empresas
        totalViniciusCommission = totalCommissionableAmount * 0.666;
        totalDouglasCommission = totalCommissionableAmount * 0.333;
        totalBrunoCommission = 0;
        totalAlexCommission = 0;
    }
    
    return {
        summary: {
            totalInterest: totalCommissionableAmount, // Mantendo nome para compatibilidade
            totalViniciusCommission,
            totalDouglasCommission,
            totalBrunoCommission,
            totalAlexCommission,
            totalPayments: payments.length
        },
        details
    };
}

// Atualizar resumo das comissões
function updateCommissionsSummary(summary) {
    const isErechim = currentCompany === 'erechim';
    const isImperatriz = currentCompany === 'imperatriz';
    
    // Atualizar valor total de juros
    document.getElementById('totalInterest').textContent = `R$ ${summary.totalInterest.toFixed(2)}`;
    
    // Atualizar comissão Vinicius (sempre visível)
    document.getElementById('viniciusCommission').textContent = `R$ ${summary.totalViniciusCommission.toFixed(2)}`;
    
    // Atualizar comissão Douglas
    document.getElementById('douglasCommission').textContent = `R$ ${summary.totalDouglasCommission.toFixed(2)}`;
    
    // Elementos dos cards
    const brunoCard = document.getElementById('brunoCommissionCard');
    const brunoCommissionElement = document.getElementById('brunoCommission');
    const alexCard = document.getElementById('alexCommissionCard');
    const alexCommissionElement = document.getElementById('alexCommission');
    const douglasCard = document.querySelector('.glass-card p#douglasCommission')?.closest('.glass-card');
    const commissionsGrid = document.getElementById('commissionsCardsGrid');
    const viniciusLabel = document.getElementById('viniciusCommissionLabel');
    const douglasLabel = document.getElementById('douglasCommissionLabel');
    
    if (isErechim) {
        // ERECHIM: Mostrar Bruno, Vinicius e Douglas (33,3% cada)
        if (brunoCard) brunoCard.style.display = 'block';
        if (brunoCommissionElement) {
            brunoCommissionElement.textContent = `R$ ${summary.totalBrunoCommission.toFixed(2)}`;
        }
        if (alexCard) alexCard.style.display = 'none';
        if (douglasCard) douglasCard.style.display = 'block';
        if (viniciusLabel) viniciusLabel.textContent = 'Comissão Vinicius (33,3%)';
        if (douglasLabel) douglasLabel.textContent = 'Comissão Douglas (33,3%)';
        if (commissionsGrid) {
            commissionsGrid.className = 'grid grid-cols-1 md:grid-cols-4 gap-4 mb-6';
        }
    } else if (isImperatriz) {
        // IMPERATRIZ CRED: Mostrar Vinicius e Alex (50% cada), esconder Douglas e Bruno
        if (brunoCard) brunoCard.style.display = 'none';
        if (alexCard) {
            alexCard.style.display = 'block';
            if (alexCommissionElement) {
                alexCommissionElement.textContent = `R$ ${summary.totalAlexCommission.toFixed(2)}`;
            }
        }
        if (douglasCard) douglasCard.style.display = 'none';
        if (viniciusLabel) viniciusLabel.textContent = 'Comissão Vinicius (50%)';
        if (commissionsGrid) {
            commissionsGrid.className = 'grid grid-cols-1 md:grid-cols-3 gap-4 mb-6';
        }
    } else {
        // OUTRAS EMPRESAS: Mostrar Vinicius (66,6%) e Douglas (33,3%)
        if (brunoCard) brunoCard.style.display = 'none';
        if (alexCard) alexCard.style.display = 'none';
        if (douglasCard) douglasCard.style.display = 'block';
        if (viniciusLabel) viniciusLabel.textContent = 'Comissão Vinicius (66,6%)';
        if (douglasLabel) douglasLabel.textContent = 'Comissão Douglas (33,3%)';
        if (commissionsGrid) {
            commissionsGrid.className = 'grid grid-cols-1 md:grid-cols-3 gap-4 mb-6';
        }
    }
}

// Renderizar tabela de comissões
function renderCommissionsTable(commissionsDetails) {
    const tableBody = document.getElementById('commissionsTableBody');
    const isErechim = currentCompany === 'erechim';
    const isImperatriz = currentCompany === 'imperatriz';
    
    // Mostrar/esconder colunas baseado na empresa
    const brunoColumns = document.querySelectorAll('.bruno-column');
    const alexColumns = document.querySelectorAll('.alex-column');
    const douglasColumns = document.querySelectorAll('.douglas-column');
    
    brunoColumns.forEach(col => {
        col.style.display = isErechim ? '' : 'none';
    });
    
    alexColumns.forEach(col => {
        col.style.display = isImperatriz ? '' : 'none';
    });
    
    douglasColumns.forEach(col => {
        col.style.display = isImperatriz ? 'none' : '';
    });
    
    if (commissionsDetails.length === 0) {
        let colspan = "9"; // Padrão: outras empresas
        if (isErechim) colspan = "10"; // Erechim tem Bruno
        if (isImperatriz) colspan = "10"; // Imperatriz tem Alex
        
        tableBody.innerHTML = `
            <tr>
                <td colspan="${colspan}" class="px-3 py-6 text-center text-gray-400 text-sm">
                    Nenhum pagamento encontrado para o período selecionado
                </td>
            </tr>
        `;
        return;
    }
    
    tableBody.innerHTML = commissionsDetails.map(item => {
        // Usar payment_type para badge se for quitação, senão usar status
        const badgeStatus = item.paymentType === 'loan_payoff' ? 'loan_payoff' : item.status;
        const statusBadge = getStatusBadge(badgeStatus);
        const clientName = item.client?.name || 'Cliente não encontrado';
        
        // Construir coluna do Bruno apenas se for Erechim
        const brunoColumn = isErechim ? `
                <td class="px-3 py-3 whitespace-nowrap text-xs text-orange-400 font-semibold bruno-column">
                    R$ ${item.brunoCommission.toFixed(2)}
                </td>` : '';
        
        // Construir coluna do Alex apenas se for Imperatriz
        const alexColumn = isImperatriz ? `
                <td class="px-3 py-3 whitespace-nowrap text-xs text-yellow-400 font-semibold alex-column">
                    R$ ${item.alexCommission.toFixed(2)}
                </td>` : '';
        
        // Construir coluna do Douglas (esconder se for Imperatriz)
        const douglasColumn = !isImperatriz ? `
                <td class="px-3 py-3 whitespace-nowrap text-xs text-purple-400 font-semibold douglas-column">
                    R$ ${item.douglasCommission.toFixed(2)}
                </td>` : '';
        
        return `
            <tr class="table-row">
                <td class="px-3 py-3 whitespace-nowrap">
                    <div class="text-xs font-medium text-white">${clientName}</div>
                    <div class="text-xs text-gray-300">${item.client?.cpf || ''}</div>
                </td>
                <td class="px-3 py-3 whitespace-nowrap text-xs text-gray-300">
                    <div>R$ ${item.paymentAmount.toFixed(2)}</div>
                    <div class="text-xs text-gray-400">J: ${item.paid_interest?.toFixed(2) || '0.00'} | C: ${item.paid_capital?.toFixed(2) || '0.00'}</div>
                </td>
                <td class="px-3 py-3 whitespace-nowrap text-xs text-gray-300">
                    R$ ${item.loanAmount.toFixed(2)}
                </td>
                <td class="px-3 py-3 whitespace-nowrap text-xs text-gray-300">
                    ${item.interestRate.toFixed(1)}%
                </td>
                <td class="px-3 py-3 whitespace-nowrap text-xs text-white font-semibold">
                    R$ ${item.commissionableAmount.toFixed(2)}
                </td>
                ${brunoColumn}
                ${alexColumn}
                <td class="px-3 py-3 whitespace-nowrap text-xs text-green-400 font-semibold">
                    R$ ${item.viniciusCommission.toFixed(2)}
                </td>
                ${douglasColumn}
                </td>
                <td class="px-3 py-3 whitespace-nowrap text-xs text-gray-300">
                    ${formatDate(item.paymentDate)}
                </td>
                <td class="px-3 py-3 whitespace-nowrap">
                    ${statusBadge}
                </td>
            </tr>
        `;
    }).join('');
}

// Obter badge de status
function getStatusBadge(status) {
    const badges = {
        'active': '<span class="px-1 py-0.5 inline-flex text-xs leading-4 font-medium rounded bg-green-100 text-green-800">Ativo</span>',
        'due_today': '<span class="px-1 py-0.5 inline-flex text-xs leading-4 font-medium rounded bg-orange-100 text-orange-800">Vence Hoje</span>',
        'overdue': '<span class="px-1 py-0.5 inline-flex text-xs leading-4 font-medium rounded bg-red-100 text-red-800">Vencido</span>',
        'paid': '<span class="px-1 py-0.5 inline-flex text-xs leading-4 font-medium rounded bg-blue-100 text-blue-800">Quitado</span>',
        'partial_paid': '<span class="px-1 py-0.5 inline-flex text-xs leading-4 font-medium rounded bg-yellow-100 text-yellow-800">Parcial</span>',
        'loan_payoff': '<span class="px-1 py-0.5 inline-flex text-xs leading-4 font-medium rounded bg-emerald-100 text-emerald-800">Quitação</span>',
        'installment': '<span class="px-1 py-0.5 inline-flex text-xs leading-4 font-medium rounded bg-purple-100 text-purple-800">Parcelamento</span>'
    };
    
    return badges[status] || '<span class="px-1 py-0.5 inline-flex text-xs leading-4 font-medium rounded bg-gray-100 text-gray-800">Desconhecido</span>';
}

// ==================== FUNÇÕES REUTILIZÁVEIS DE BUSCA DE CLIENTES ====================

/**
 * Função genérica para buscar clientes por nome, CPF, RG ou email (para dropdowns)
 * @param {string} searchTerm - Termo de busca
 * @returns {Array} - Array de clientes que correspondem ao termo de busca
 */
function findClientsForDropdown(searchTerm) {
    if (!clients || clients.length === 0) {
        return [];
    }
    
    if (!searchTerm || searchTerm.trim().length < 2) {
        return [];
    }
    
    const term = searchTerm.toLowerCase().trim();
    return clients.filter(client => 
        client.name.toLowerCase().includes(term) ||
        (client.cpf && client.cpf.includes(term)) ||
        (client.rg && client.rg.toLowerCase().includes(term)) ||
        (client.email && client.email.toLowerCase().includes(term))
    );
}

/**
 * Função genérica para renderizar resultados de busca de clientes
 * @param {Array} results - Array de clientes encontrados
 * @param {string} resultsListId - ID do elemento HTML onde os resultados serão exibidos
 * @param {string} resultsContainerId - ID do container dos resultados
 * @param {Function} onSelectCallback - Função callback a ser executada ao selecionar um cliente
 */
function renderClientSearchResults(results, resultsListId, resultsContainerId, onSelectCallback) {
    const resultsList = document.getElementById(resultsListId);
    const resultsContainer = document.getElementById(resultsContainerId);
    
    if (!results || results.length === 0) {
        resultsContainer.classList.add('hidden');
        return;
    }
    
    resultsList.innerHTML = '';
    
    results.forEach(client => {
        const resultItem = document.createElement('div');
        resultItem.className = 'p-3 hover:bg-gray-700 cursor-pointer transition-colors';
        resultItem.innerHTML = `
            <div class="text-white font-medium">${client.name}</div>
            <div class="text-gray-400 text-sm">CPF: ${client.cpf}</div>
            ${client.email ? `<div class="text-gray-400 text-sm">Email: ${client.email}</div>` : ''}
        `;
        
        resultItem.addEventListener('click', () => {
            onSelectCallback(client);
        });
        
        resultsList.appendChild(resultItem);
    });
    
    resultsContainer.classList.remove('hidden');
}

/**
 * Função genérica para selecionar um cliente da busca
 * @param {Object} client - Objeto do cliente selecionado
 * @param {string} searchInputId - ID do input de busca
 * @param {string} selectId - ID do select tradicional
 * @param {string} resultsContainerId - ID do container dos resultados
 */
function selectClientFromSearch(client, searchInputId, selectId, resultsContainerId) {
    // Atualizar o campo de busca
    document.getElementById(searchInputId).value = `${client.name} - ${client.cpf}`;
    
    // Atualizar o select
    document.getElementById(selectId).value = client.id;
    
    // Esconder resultados
    document.getElementById(resultsContainerId).classList.add('hidden');
    
    // Trigger change event no select para que outras funções possam reagir
    const selectElement = document.getElementById(selectId);
    const event = new Event('change', { bubbles: true });
    selectElement.dispatchEvent(event);
}

/**
 * Configurar busca de clientes para um modal específico
 * @param {string} searchInputId - ID do input de busca
 * @param {string} selectId - ID do select tradicional
 * @param {string} resultsListId - ID do elemento onde os resultados serão listados
 * @param {string} resultsContainerId - ID do container dos resultados
 */
function setupClientSearch(searchInputId, selectId, resultsListId, resultsContainerId) {
    const searchInput = document.getElementById(searchInputId);
    
    if (!searchInput) {
        console.warn(`Input de busca ${searchInputId} não encontrado`);
        return;
    }
    
    // Remover event listeners anteriores (se existirem)
    const newSearchInput = searchInput.cloneNode(true);
    searchInput.parentNode.replaceChild(newSearchInput, searchInput);
    
    // Adicionar event listener para busca
    newSearchInput.addEventListener('input', function(e) {
        const searchTerm = e.target.value;
        const results = findClientsForDropdown(searchTerm);
        
        renderClientSearchResults(
            results, 
            resultsListId, 
            resultsContainerId,
            (client) => selectClientFromSearch(client, searchInputId, selectId, resultsContainerId)
        );
    });
    
    // Limpar resultados ao focar novamente no input
    newSearchInput.addEventListener('focus', function() {
        if (this.value.trim().length >= 2) {
            const results = findClientsForDropdown(this.value);
            renderClientSearchResults(
                results, 
                resultsListId, 
                resultsContainerId,
                (client) => selectClientFromSearch(client, searchInputId, selectId, resultsContainerId)
            );
        }
    });
    
    // Esconder resultados ao clicar fora
    document.addEventListener('click', function(e) {
        const resultsContainer = document.getElementById(resultsContainerId);
        const searchInputElement = document.getElementById(searchInputId);
        
        if (searchInputElement && resultsContainer && 
            !searchInputElement.contains(e.target) && 
            !resultsContainer.contains(e.target)) {
            resultsContainer.classList.add('hidden');
        }
    });
}
