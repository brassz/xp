// Configuração do Supabase
const SUPABASE_URL = 'https://mhtxyxizfnxupwmilith.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1odHh5eGl6Zm54dXB3bWlsaXRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYxMzIzMDYsImV4cCI6MjA3MTcwODMwNn0.s1Y9kk2Va5EMcwAEGQmhTxo70Zv0o9oR6vrJixwEkWI';

// Configuração do Uploadcare
const UPLOADCARE_PUBLIC_KEY = '5bb6bf6b98f6d36060dc';

// Inicializar Supabase
const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Estado global da aplicação
let currentUser = null;
let clients = [];
let loans = [];
let expenses = [];
let expenseCategories = [];
let installments = [];
let installmentPayments = [];
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
const editClientModal = document.getElementById('editClientModal');
const editLoanModal = document.getElementById('editLoanModal');
const confirmationModal = document.getElementById('confirmationModal');
const paymentHistoryModal = document.getElementById('paymentHistoryModal');
const newExpenseModal = document.getElementById('newExpenseModal');
const newInstallmentModal = document.getElementById('newInstallmentModal');
const installmentDetailsModal = document.getElementById('installmentDetailsModal');
const installmentPaymentModal = document.getElementById('installmentPaymentModal');
const newCapitalRaisingModal = document.getElementById('newCapitalRaisingModal');
const capitalRaisingDetailsModal = document.getElementById('capitalRaisingDetailsModal');
const addCapitalClientModal = document.getElementById('addCapitalClientModal');


// Botões
const newClientBtn = document.getElementById('newClientBtn');
const newLoanBtn = document.getElementById('newLoanBtn');
const newExpenseBtn = document.getElementById('newExpenseBtn');
const newCapitalRaisingBtn = document.getElementById('newCapitalRaisingBtn');

const generatePdfBtn = document.getElementById('generatePdfBtn');
const generateExpensesPDFBtn = document.getElementById('generateExpensesPDFBtn');

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
    if (savedUser) {
        try {
            currentUser = JSON.parse(savedUser);
            showDashboard();
            // Verificar e criar tabelas se necessário
            await createTablesIfNotExist();
            
            // Aguardar um pouco para garantir que o DOM esteja pronto
            setTimeout(async () => {
                await loadData();
            }, 100);
        } catch (error) {
            localStorage.removeItem('nexusUser');
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
    
    // Adicionar event listener para o botão de PDF das despesas
    if (generateExpensesPDFBtn) {
        generateExpensesPDFBtn.addEventListener('click', generateMonthlyExpensesPDF);
    }
    
    // Fechar modais
    document.getElementById('closeClientModal').addEventListener('click', () => hideModal(newClientModal));
    document.getElementById('closeLoanModal').addEventListener('click', () => hideModal(newLoanModal));
    document.getElementById('closePaymentModal').addEventListener('click', () => hideModal(paymentModal));
    document.getElementById('closeEditClientModal').addEventListener('click', () => hideModal(editClientModal));
    document.getElementById('closeEditLoanModal').addEventListener('click', () => hideModal(editLoanModal));
    document.getElementById('closePaymentHistoryModal').addEventListener('click', () => hideModal(paymentHistoryModal));
    document.getElementById('closeExpenseModal').addEventListener('click', () => hideModal(newExpenseModal));
    
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
    document.getElementById('cancelExpense').addEventListener('click', () => hideModal(newExpenseModal));
    
    // Capital Raising cancel buttons
    if (document.getElementById('cancelCapitalRaising')) {
        document.getElementById('cancelCapitalRaising').addEventListener('click', () => hideModal(newCapitalRaisingModal));
    }
    if (document.getElementById('cancelCapitalClient')) {
        document.getElementById('cancelCapitalClient').addEventListener('click', () => hideModal(addCapitalClientModal));
    }

    
    // Botões do modal de histórico de pagamentos
    document.getElementById('newPaymentBtn').addEventListener('click', () => showNewPaymentFromHistory());
    
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
    paymentForm.addEventListener('submit', handlePayment);
    document.getElementById('editClientForm').addEventListener('submit', handleEditClient);
    document.getElementById('editLoanForm').addEventListener('submit', handleEditLoan);
    newExpenseForm.addEventListener('submit', handleNewExpense);
    
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
    
    // Validação do valor de pagamento
    document.getElementById('paymentAmount').addEventListener('input', validatePaymentAmount);
    

}

// Configurar Uploadcare
function setupUploadcare() {
    if (window.uploadcare) {
        // Configurar Uploadcare globalmente
        uploadcare.start({
            publicKey: UPLOADCARE_PUBLIC_KEY,
            locale: 'pt',
            tabs: 'file camera url facebook gdrive gphotos dropbox instagram',
            multiple: false,
            imageShrink: '1024x1024',
            crop: '1:1',
            effects: 'crop,rotate,enhance,grayscale',
            clearable: true
        });

        // Widget para novo cliente
        const widget = uploadcare.Widget('#clientPhotoUploader');
        widget.onChange(function(file) {
            if (file) {
                file.done(function(fileInfo) {
                    // Armazenar URL no campo hidden
                    document.getElementById('clientPhoto').value = fileInfo.cdnUrl;
                    
                    // Mostrar preview
                    const previewDiv = document.getElementById('photoUploadPreview');
                    const previewImg = document.getElementById('photoPreviewImg');
                    
                    previewImg.src = fileInfo.cdnUrl;
                    previewDiv.classList.remove('hidden');
                });
            } else {
                // Limpar quando arquivo for removido
                document.getElementById('clientPhoto').value = '';
                document.getElementById('photoUploadPreview').classList.add('hidden');
            }
        });
        
        // Widget para edição de cliente
        const editWidget = uploadcare.Widget('#editClientPhotoUploader');
        editWidget.onChange(function(file) {
            if (file) {
                file.done(function(fileInfo) {
                    // Armazenar URL no campo hidden
                    document.getElementById('editClientPhoto').value = fileInfo.cdnUrl;
                    
                    // Mostrar preview
                    const previewDiv = document.getElementById('editPhotoUploadPreview');
                    const previewImg = document.getElementById('editPhotoPreviewImg');
                    
                    previewImg.src = fileInfo.cdnUrl;
                    previewDiv.classList.remove('hidden');
                });
            } else {
                // Limpar quando arquivo for removido
                document.getElementById('editClientPhoto').value = '';
                document.getElementById('editPhotoUploadPreview').classList.add('hidden');
            }
        });
    } else {
        console.warn('Uploadcare library not loaded');
    }
}

// Handlers de autenticação
async function handleLogin(e) {
    e.preventDefault();
    
    const email = document.getElementById('loginEmail').value;
    const password = document.getElementById('loginPassword').value;
    
    try {
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
        
        // Para demonstração, aceitar senha simples
        // Em produção, implementar hash de senha
        if (password === '1020' || password === 'user123') {
            currentUser = userData;
            
            // Salvar usuário no localStorage
            localStorage.setItem('nexusUser', JSON.stringify(currentUser));
            
            showDashboard();
            await loadData();
            
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
    currentUser = null;
    localStorage.removeItem('nexusUser');
    showLogin();
}

// Navegação
function handleNavigation(e) {
    e.preventDefault();
    
    const target = e.currentTarget.getAttribute('href').substring(1);
    
    // Atualizar navegação ativa
    navLinks.forEach(link => link.classList.remove('active'));
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
                    updateGrowthChart();
                    updateDistributionChart();
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
                loadOverdueLoansForInstallmentTable();
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

// Carregar clientes
async function loadClients() {
    try {
        const { data, error } = await supabase
            .from('clients')
            .select('*')
            .order('created_at', { ascending: false });
        
        if (error) throw error;
        
        clients = data || [];
        renderClientsTable();
        populateHistoryClientSelect();
        
    } catch (error) {
        console.error('Erro ao carregar clientes:', error);
        clients = [];
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
        await renderLoansTable();
        
    } catch (error) {
        console.error('Erro ao carregar empréstimos:', error);
        loans = [];
    }
}

// Renderizar tabela de clientes
function renderClientsTable() {
    const tbody = document.getElementById('clientsTableBody');
    
    if (clients.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="6" class="px-6 py-8 text-center text-gray-400">
                    Nenhum cliente cadastrado ainda
                </td>
            </tr>
        `;
        return;
    }
    
    tbody.innerHTML = clients.map(client => `
        <tr class="table-row">
            <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center">
                    <div class="flex-shrink-0 h-10 w-10">
                        ${client.photo ? 
                            `<img class="h-10 w-10 rounded-full object-cover" src="${client.photo}" alt="${client.name}">` :
                            `<div class="h-10 w-10 rounded-full bg-gray-600 flex items-center justify-center">
                                <span class="text-white font-semibold">${client.name.charAt(0).toUpperCase()}</span>
                            </div>`
                        }
                    </div>
                    <div class="ml-4">
                        <div class="text-sm font-medium text-white">${client.name}</div>
                    </div>
                </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${client.cpf}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${client.phone}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${client.email}</td>
            <td class="px-6 py-4 text-sm text-gray-300 max-w-xs truncate">${client.address}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                <button class="text-blue-400 hover:text-blue-300 mr-3" onclick="editClient('${client.id}')">✏️</button>
                <button class="text-red-400 hover:text-red-300" onclick="deleteClient('${client.id}')">🗑️</button>
            </td>
        </tr>
    `).join('');
}

// Renderizar tabela de empréstimos
async function renderLoansTable() {
    const tbody = document.getElementById('loansTableBody');
    
    // Filtrar apenas empréstimos ativos (não quitados)
    const activeLoans = loans.filter(loan => loan.status !== 'paid');
    
    if (activeLoans.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="8" class="px-6 py-8 text-center text-gray-400">
                    Nenhum empréstimo ativo
                </td>
            </tr>
        `;
        return;
    }
    
    // Renderizar linhas com valores atualizados
    let tableHTML = '';
    for (const loan of activeLoans) {
        const originalTotal = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
        const remainingAmount = await calculateLoanRemainingAmount(loan.id);
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
                    <button class="text-yellow-400 hover:text-yellow-300 mr-3" onclick="sendWhatsAppMessage('${loan.id}')" title="Enviar cobrança via WhatsApp">📞</button>
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
        rg: document.getElementById('clientRG').value,
        birth_date: document.getElementById('clientBirthDate').value,
        photo: document.getElementById('clientPhoto').value,
        created_by: currentUser.id,
        created_at: new Date().toISOString()
    };
    
    try {
        const { data, error } = await supabase
            .from('clients')
            .insert([formData])
            .select();
        
        if (error) throw error;
        
        hideModal(newClientModal);
        newClientForm.reset();
        document.getElementById('photoUpload').innerHTML = `
            <svg class="w-12 h-12 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path>
            </svg>
            <p class="text-gray-400">Clique para fazer upload da foto</p>
        `;
        
        await loadClients();
        await updateDashboard();
        
    } catch (error) {
        alert('Erro ao criar cliente: ' + error.message);
    }
}

async function handleNewLoan(e) {
    e.preventDefault();
    
    const formData = {
        client_id: document.getElementById('loanClient').value,
        amount: parseFloat(document.getElementById('loanAmount').value),
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
        
        await loadLoans();
        await updateDashboard();
        
        // Perguntar se deseja gerar contrato
        const generateContractNow = confirm('Empréstimo criado com sucesso! Deseja gerar o contrato agora?');
        if (generateContractNow && data && data[0]) {
            await generateContract(data[0].id);
        }
        
    } catch (error) {
        alert('Erro ao criar empréstimo: ' + error.message);
    }
}

async function handlePayment(e) {
    e.preventDefault();
    
    const paymentAmount = parseFloat(document.getElementById('paymentAmount').value);
    const paymentDate = document.getElementById('paymentDate').value;
    const paymentType = document.getElementById('paymentType').value;
    const paymentNotes = document.getElementById('paymentNotes').value;
    const loanId = document.getElementById('paymentForm').dataset.loanId;
    
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
        
        // Verificar se é necessário recalcular o empréstimo antes de registrar o pagamento
        const recalcInfo = await checkAndRecalculateLoan(loanId, paymentAmount, paymentType);
        
        // Registrar o pagamento
        const { error: paymentError } = await supabase
            .from('payments')
            .insert([{
                loan_id: loanId,
                amount: paymentAmount,
                payment_date: paymentDate,
                payment_type: paymentType,
                notes: paymentNotes,
                created_by: currentUser.id,
                created_at: new Date().toISOString()
            }]);
        
        if (paymentError) throw paymentError;
        
        // Se precisa recalcular, atualizar os valores do empréstimo
        if (recalcInfo.shouldRecalculate) {
            // Preparar dados para atualização
            let updateData = {
                amount: recalcInfo.newAmount,
                updated_at: new Date().toISOString(),
                status: recalcInfo.isFullyPaid ? 'paid' : 'active'
            };
            
            // Se for renovação de juros, atualizar data de vencimento
            if (recalcInfo.isInterestOnlyRenewal) {
                updateData.due_date = recalcInfo.newDueDate;
            }
            
            const { error: loanUpdateError } = await supabase
                .from('loans')
                .update(updateData)
                .eq('id', loanId);
            
            if (loanUpdateError) throw loanUpdateError;
            
            // Registrar nota sobre o tipo de operação
            let actionNotes;
            let actionType;
            
            if (recalcInfo.isInterestOnlyRenewal) {
                actionType = 'interest_renewal';
                actionNotes = `RENOVAÇÃO - PAGAMENTO APENAS DE JUROS: ` +
                            `Capital mantido: R$ ${recalcInfo.newAmount.toFixed(2)} | ` +
                            `Juros pagos: R$ ${recalcInfo.paidAmount.toFixed(2)} | ` +
                            `Próximos juros: R$ ${recalcInfo.newInterestAmount.toFixed(2)} | ` +
                            `Nova data vencimento: ${recalcInfo.newDueDate}`;
            } else if (recalcInfo.isCapitalReduction) {
                actionType = 'capital_payment';
                actionNotes = `PAGAMENTO DE CAPITAL: ` +
                            `Capital anterior: R$ ${recalcInfo.originalAmount.toFixed(2)} | ` +
                            `Capital pago: R$ ${recalcInfo.paidCapital.toFixed(2)} | ` +
                            `Juros pagos: R$ ${recalcInfo.paidInterest.toFixed(2)} | ` +
                            `Novo capital: R$ ${recalcInfo.newAmount.toFixed(2)} | ` +
                            `Novos juros: R$ ${recalcInfo.newInterestAmount.toFixed(2)}`;
            } else if (recalcInfo.isPartialInterestPayment) {
                actionType = 'partial_interest';
                actionNotes = `PAGAMENTO PARCIAL DE JUROS: ` +
                            `Capital mantido: R$ ${recalcInfo.newAmount.toFixed(2)} | ` +
                            `Juros pagos: R$ ${recalcInfo.paidAmount.toFixed(2)} | ` +
                            `Novos juros acumulados: R$ ${recalcInfo.newInterestAmount.toFixed(2)}`;
            } else {
                actionType = 'adjustment';
                actionNotes = `AJUSTE AUTOMÁTICO: ` +
                            `Capital: R$ ${recalcInfo.newAmount.toFixed(2)} | ` +
                            `Juros: R$ ${recalcInfo.newInterestAmount.toFixed(2)}`;
            }
            
            const { error: actionNoteError } = await supabase
                .from('payments')
                .insert([{
                    loan_id: loanId,
                    amount: 0,
                    payment_date: paymentDate,
                    payment_type: actionType,
                    notes: actionNotes,
                    created_by: currentUser.id,
                    created_at: new Date().toISOString()
                }]);
            
            if (actionNoteError) console.warn('Erro ao registrar nota de ação:', actionNoteError);
        } else {
            // Atualizar status do empréstimo baseado no tipo de pagamento (lógica original)
            let newStatus = 'partial_paid';
            if (paymentType === 'full') {
                newStatus = 'paid';
            }
            
            const { error: loanError } = await supabase
                .from('loans')
                .update({ 
                    status: newStatus,
                    updated_at: new Date().toISOString()
                })
                .eq('id', loanId);
            
            if (loanError) throw loanError;
        }
        
        hideModal(paymentModal);
        paymentForm.reset();
        
        // Recarregar dados
        await loadLoans();
        await updateDashboard();
        
        // Se o modal de histórico estiver aberto, recarregar os dados
        if (!paymentHistoryModal.classList.contains('hidden')) {
            await loadPaymentHistory(loanId);
        }
        
        // Mostrar mensagem de sucesso com informações sobre a operação
        let successMessage = `Pagamento de R$ ${paymentAmount.toFixed(2)} registrado com sucesso!`;
        
        if (recalcInfo.shouldRecalculate) {
            if (recalcInfo.isInterestOnlyRenewal) {
                successMessage += `\n\n🔄 RENOVAÇÃO POR PAGAMENTO DE JUROS!\n` +
                                `• Capital mantido: R$ ${recalcInfo.newAmount.toFixed(2)}\n` +
                                `• Próximos juros: R$ ${recalcInfo.newInterestAmount.toFixed(2)}\n` +
                                `• Próximo total: R$ ${recalcInfo.newTotalAmount.toFixed(2)}\n` +
                                `• Nova data de vencimento: ${new Date(recalcInfo.newDueDate).toLocaleDateString('pt-BR')}`;
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
        
        showSuccessMessage(successMessage);
        
    } catch (error) {
        alert('Erro ao registrar pagamento: ' + error.message);
    }
}

async function handleEditClient(e) {
    e.preventDefault();
    
    const clientId = document.getElementById('editClientId').value;
    const formData = {
        name: document.getElementById('editClientName').value,
        cpf: document.getElementById('editClientCPF').value,
        email: document.getElementById('editClientEmail').value,
        phone: document.getElementById('editClientPhone').value,
        address: document.getElementById('editClientAddress').value,
        rg: document.getElementById('editClientRG').value,
        birth_date: document.getElementById('editClientBirthDate').value,
        photo: document.getElementById('editClientPhoto').value,
        updated_at: new Date().toISOString()
    };
    
    try {
        const { data, error } = await supabase
            .from('clients')
            .update(formData)
            .eq('id', clientId)
            .select();
        
        if (error) throw error;
        
        hideModal(editClientModal);
        
        // Recarregar dados
        await loadClients();
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
    }
}

function hideModal(modal) {
    modal.classList.add('hidden');
    modal.classList.remove('fade-in');
    
    // Limpar formulários específicos
    if (modal === editClientModal) {
        document.getElementById('editClientForm').reset();
        // Limpar preview da foto de edição
        document.getElementById('editPhotoUploadPreview').classList.add('hidden');
        document.getElementById('editClientPhoto').value = '';
        // Limpar widget do Uploadcare
        if (window.uploadcare) {
            const editWidget = uploadcare.Widget('#editClientPhotoUploader');
            editWidget.value(null);
        }
    } else if (modal === editLoanModal) {
        document.getElementById('editLoanForm').reset();
    } else if (modal === newClientModal) {
        document.getElementById('newClientForm').reset();
        // Limpar preview da foto
        document.getElementById('photoUploadPreview').classList.add('hidden');
        document.getElementById('clientPhoto').value = '';
        // Limpar widget do Uploadcare
        if (window.uploadcare) {
            const widget = uploadcare.Widget('#clientPhotoUploader');
            widget.value(null);
        }
    } else if (modal === newLoanModal) {
        document.getElementById('newLoanForm').reset();
    } else if (modal === paymentModal) {
        document.getElementById('paymentForm').reset();
        document.getElementById('paymentDate').value = new Date().toISOString().split('T')[0];
        document.getElementById('paymentType').value = 'partial';
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
    }
}

function showLogin() {
    loginPage.classList.remove('hidden');
    dashboard.classList.add('hidden');
}

function showDashboard() {
    loginPage.classList.add('hidden');
    dashboard.classList.remove('hidden');
}

function populateClientSelect() {
    const select = document.getElementById('loanClient');
    select.innerHTML = '<option value="">Selecione um cliente</option>';
    
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
    
    document.getElementById('loanDate').value = today.toISOString().split('T')[0];
    document.getElementById('loanDueDate').value = nextMonth.toISOString().split('T')[0];
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

function validatePaymentAmount() {
    const paymentAmount = parseFloat(document.getElementById('paymentAmount').value);
    const feedbackDiv = document.getElementById('paymentValidationFeedback');
    
    if (isNaN(paymentAmount) || paymentAmount <= 0) {
        feedbackDiv.className = 'mt-2 text-sm hidden';
        return;
    }
    
    // Obter valores do modal
    const remainingText = document.getElementById('paymentRemainingAmount').textContent;
    const minimumText = document.getElementById('paymentMinimumAmount').textContent;
    
    if (!remainingText || !minimumText) {
        feedbackDiv.className = 'mt-2 text-sm hidden';
        return;
    }
    
    // Função auxiliar para converter valor monetário brasileiro para número
    function parseMonetaryValue(text) {
        // Remove "R$" e espaços
        let cleanText = text.replace('R$', '').trim();
        
        // Se tem vírgula, assume formato brasileiro (1.234,56)
        if (cleanText.includes(',')) {
            // Remove pontos (separadores de milhares) e substitui vírgula por ponto
            cleanText = cleanText.replace(/\./g, '').replace(',', '.');
        }
        // Se não tem vírgula, assume que já está no formato correto (1234.56)
        
        return parseFloat(cleanText);
    }
    
    const remainingAmount = parseMonetaryValue(remainingText);
    const minimumAmount = parseMonetaryValue(minimumText);
    
    feedbackDiv.classList.remove('hidden');
    
    if (paymentAmount < minimumAmount) {
        feedbackDiv.textContent = `⚠️ Valor abaixo do mínimo (R$ ${minimumAmount.toFixed(2)}). Pagamento não permitido.`;
        feedbackDiv.className = 'mt-2 text-sm text-red-400';
        document.getElementById('paymentAmount').classList.add('border-red-500');
    } else if (Math.abs(paymentAmount - minimumAmount) <= (minimumAmount * 0.01)) {
        feedbackDiv.textContent = `🔄 PAGAMENTO DE JUROS: Capital permanece igual, empréstimo renovado por +30 dias.`;
        feedbackDiv.className = 'mt-2 text-sm text-yellow-400';
        document.getElementById('paymentAmount').classList.remove('border-red-500');
        document.getElementById('paymentAmount').classList.add('border-yellow-500');
    } else if (paymentAmount < remainingAmount) {
        const interestText = document.getElementById('paymentInterestAmount').textContent;
        const interestAmount = parseMonetaryValue(interestText);
        
        if (paymentAmount > interestAmount) {
            feedbackDiv.textContent = `💰 PAGAMENTO DE CAPITAL: Parte vai para juros, parte reduz o capital do empréstimo.`;
            feedbackDiv.className = 'mt-2 text-sm text-blue-400';
        } else {
            feedbackDiv.textContent = `⚠️ PAGAMENTO PARCIAL DE JUROS: Juros pendentes acumularão para o próximo período.`;
            feedbackDiv.className = 'mt-2 text-sm text-orange-400';
        }
        document.getElementById('paymentAmount').classList.remove('border-red-500', 'border-yellow-500');
        document.getElementById('paymentAmount').classList.add('border-blue-500');
    } else if (paymentAmount >= remainingAmount) {
        feedbackDiv.textContent = `✅ Pagamento quitará o empréstimo completamente.`;
        feedbackDiv.className = 'mt-2 text-sm text-green-400';
        document.getElementById('paymentAmount').classList.remove('border-red-500', 'border-yellow-500', 'border-blue-500');
        document.getElementById('paymentAmount').classList.add('border-green-500');
    } else {
        feedbackDiv.className = 'mt-2 text-sm hidden';
        document.getElementById('paymentAmount').classList.remove('border-red-500', 'border-yellow-500', 'border-blue-500', 'border-green-500');
    }
}

function showPaymentModal(loanId) {
    const loan = loans.find(l => l.id === loanId);
    if (!loan) return;
    
    // Preencher dados do empréstimo
    document.getElementById('paymentClientName').textContent = loan.clients?.name || 'Cliente não encontrado';
    
    // Calcular valor restante considerando pagamentos já feitos
    calculateAndShowRemainingAmount(loanId);
    
    // Definir data padrão como hoje
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('paymentDate').value = today;
    
    // Limpar outros campos
    document.getElementById('paymentAmount').value = '';
    document.getElementById('paymentType').value = 'partial';
    document.getElementById('paymentNotes').value = '';
    
    // Limpar validação anterior
    const feedbackDiv = document.getElementById('paymentValidationFeedback');
    feedbackDiv.className = 'mt-2 text-sm hidden';
    document.getElementById('paymentAmount').classList.remove('border-red-500', 'border-yellow-500', 'border-blue-500', 'border-green-500');
    
    // Armazenar ID do empréstimo
    document.getElementById('paymentForm').dataset.loanId = loanId;
    
    showModal(paymentModal);
}

async function calculateAndShowRemainingAmount(loanId) {
    try {
        const loan = loans.find(l => l.id === loanId);
        if (!loan) return;
        
        const currentCapital = parseFloat(loan.amount);
        const interestRate = parseFloat(loan.interest_rate);
        
        // Validação: se a taxa for muito alta, pode estar em formato incorreto
        let finalInterestRate = interestRate;
        if (interestRate > 100) {
            finalInterestRate = interestRate / 100;
        }
        
        const currentInterestAmount = currentCapital * (finalInterestRate / 100);
        const currentTotal = currentCapital + currentInterestAmount;
        
        // Buscar pagamentos já feitos
        const { data: payments, error } = await supabase
            .from('payments')
            .select('amount, payment_type, created_at')
            .eq('loan_id', loanId)
            .order('created_at', { ascending: true });
        
        if (error) throw error;
        
        // Separar pagamentos reais de ajustes/notificações
        const realPayments = payments.filter(p => parseFloat(p.amount) > 0);
        
        // Calcular estado atual baseado nos pagamentos
        let totalPaidThisCycle = 0;
        
        // Verificar se existe uma renovação recente que resetou o ciclo
        const lastRenewal = payments.filter(p => p.payment_type === 'interest_renewal').pop();
        
        if (lastRenewal) {
            // Se houve renovação, considerar apenas pagamentos após ela
            const renewalDate = new Date(lastRenewal.created_at);
            const paymentsAfterRenewal = realPayments.filter(p => new Date(p.created_at) > renewalDate);
            totalPaidThisCycle = paymentsAfterRenewal.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        } else {
            // Primeira vez ou sem renovações, considerar todos os pagamentos
            totalPaidThisCycle = realPayments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        }
        
        // Calcular quanto ainda deve baseado no tipo de pagamento feito
        let remainingAmount;
        
        if (totalPaidThisCycle === 0) {
            // Nenhum pagamento feito ainda neste ciclo
            remainingAmount = currentTotal;
        } else {
            // Houve pagamentos, vamos analisar o que foi pago
            const paidExactlyInterest = Math.abs(totalPaidThisCycle - currentInterestAmount) <= (currentInterestAmount * 0.01);
            const paidMoreThanInterest = totalPaidThisCycle > currentInterestAmount;
            const paidLessThanInterest = totalPaidThisCycle < currentInterestAmount;
            
            if (paidExactlyInterest) {
                // PAGOU APENAS JUROS: Capital permanece, próximo período terá mesmo valor total
                remainingAmount = currentCapital + currentInterestAmount;
            } else if (paidMoreThanInterest) {
                // PAGOU CAPITAL + JUROS: Capital foi reduzido
                const paidCapital = totalPaidThisCycle - currentInterestAmount;
                const newCapital = Math.max(0, currentCapital - paidCapital);
                const newInterest = newCapital * (finalInterestRate / 100);
                remainingAmount = newCapital + newInterest;
            } else if (paidLessThanInterest) {
                // PAGOU MENOS QUE OS JUROS: Juros pendentes + novos juros
                const unpaidInterest = currentInterestAmount - totalPaidThisCycle;
                const newInterest = currentCapital * (finalInterestRate / 100);
                remainingAmount = currentCapital + unpaidInterest + newInterest;
            } else {
                // Fallback: lógica original
                remainingAmount = currentTotal - totalPaidThisCycle;
            }
        }
        
        // O pagamento mínimo é sempre o valor dos juros atuais
        const minimumPayment = currentInterestAmount;
        
        console.log('Estado atual do empréstimo:', {
            currentCapital,
            currentInterestAmount,
            currentTotal,
            totalPaidThisCycle,
            remainingAmount,
            minimumPayment,
            hasRenewal: !!lastRenewal,
            paymentAnalysis: {
                paidExactlyInterest: totalPaidThisCycle > 0 ? Math.abs(totalPaidThisCycle - currentInterestAmount) <= (currentInterestAmount * 0.01) : false,
                paidMoreThanInterest: totalPaidThisCycle > currentInterestAmount,
                paidLessThanInterest: totalPaidThisCycle < currentInterestAmount && totalPaidThisCycle > 0
            }
        });
        
        // Mostrar informações detalhadas
        document.getElementById('paymentCapitalAmount').textContent = `R$ ${currentCapital.toFixed(2)}`;
        document.getElementById('paymentInterestRate').textContent = `${finalInterestRate.toFixed(2)}%`;
        document.getElementById('paymentInterestAmount').textContent = `R$ ${currentInterestAmount.toFixed(2)}`;
        document.getElementById('paymentTotalAmount').textContent = `R$ ${currentTotal.toFixed(2)}`;
        document.getElementById('paymentRemainingAmount').textContent = `R$ ${Math.max(0, remainingAmount).toFixed(2)}`;
        document.getElementById('paymentMinimumAmount').textContent = `R$ ${minimumPayment.toFixed(2)}`;
        
    } catch (error) {
        console.error('Erro ao calcular valor restante:', error);
        // Em caso de erro, mostrar valores básicos
        const loan = loans.find(l => l.id === loanId);
        if (loan) {
            const capitalAmount = parseFloat(loan.amount);
            let interestRate = parseFloat(loan.interest_rate);
            
            if (interestRate > 100) {
                interestRate = interestRate / 100;
            }
            
            const interestAmount = capitalAmount * (interestRate / 100);
            const totalWithInterest = capitalAmount + interestAmount;
            
            document.getElementById('paymentCapitalAmount').textContent = `R$ ${capitalAmount.toFixed(2)}`;
            document.getElementById('paymentInterestRate').textContent = `${interestRate.toFixed(2)}%`;
            document.getElementById('paymentInterestAmount').textContent = `R$ ${interestAmount.toFixed(2)}`;
            document.getElementById('paymentTotalAmount').textContent = `R$ ${totalWithInterest.toFixed(2)}`;
            document.getElementById('paymentRemainingAmount').textContent = `R$ ${totalWithInterest.toFixed(2)}`;
            document.getElementById('paymentMinimumAmount').textContent = `R$ ${interestAmount.toFixed(2)}`;
        }
    }
}

// Função para calcular o pagamento mínimo baseado no valor restante
function calculateMinimumPayment(capitalAmount, interestAmount, totalPaid, remainingAmount) {
    // O valor mínimo é sempre o valor dos juros originais do empréstimo
    // Isso garante que pelo menos os juros sejam pagos
    
    if (!interestAmount || interestAmount <= 0 || isNaN(interestAmount)) {
        return 0;
    }
    
    return interestAmount;
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
        
        // Buscar pagamentos anteriores para entender o estado atual
        const { data: payments, error } = await supabase
            .from('payments')
            .select('amount, payment_type, notes')
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
        
        console.log('DEBUG - Estado atual:', {
            currentCapital,
            currentInterestAmount,
            totalPaidSoFar,
            capitalPaidSoFar,
            remainingCapital,
            pendingInterest,
            paymentAmount
        });
        
        // Verificar se o pagamento é apenas os juros pendentes (renovação)
        const isInterestOnlyPayment = Math.abs(paymentAmount - currentInterestAmount) <= (currentInterestAmount * 0.01);
        
        if (isInterestOnlyPayment) {
            // PAGAMENTO APENAS DE JUROS: Capital permanece o mesmo
            // Próximo mês: mesmo capital + novos juros
            // Não há recálculo, apenas renovação da data
            const newDueDate = new Date(loan.due_date);
            newDueDate.setDate(newDueDate.getDate() + 30);
            
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
            
            if (newCapital > 0) {
                const newInterestAmount = newCapital * (interestRate / 100);
                const newTotal = newCapital + newInterestAmount;
                
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
    
    const due = new Date(dueDate);
    const today = new Date();
    
    if (due < today) return 'overdue';
    if (due.getTime() === today.getTime()) return 'due_today';
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

function formatDate(dateString) {
    return new Date(dateString).toLocaleDateString('pt-BR');
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
    
    // Calcular total restante considerando pagamentos
    let totalRemaining = 0;
    for (const loan of loans) {
        const remainingAmount = await calculateLoanRemainingAmount(loan.id);
        totalRemaining += remainingAmount;
    }
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
    
    // Calcular total de empréstimos vencidos
    const overdueLoans = loans.filter(loan => {
        const dueDate = new Date(loan.due_date);
        const today = new Date();
        return dueDate < today && loan.status !== 'paid';
    });
    
    let totalOverdue = 0;
    for (const loan of overdueLoans) {
        const remainingAmount = await calculateLoanRemainingAmount(loan.id);
        totalOverdue += remainingAmount;
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

function updateFinancialSummary() {
    const now = new Date();
    const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
    const last6Months = new Date(now.getFullYear(), now.getMonth() - 6, 1);
    const last12Months = new Date(now.getFullYear(), now.getMonth() - 12, 1);
    
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
    
    document.getElementById('lastMonthTotal').textContent = `R$ ${lastMonthTotal.toFixed(2)}`;
    document.getElementById('last6MonthsTotal').textContent = `R$ ${last6MonthsTotal.toFixed(2)}`;
    document.getElementById('last12MonthsTotal').textContent = `R$ ${last12MonthsTotal.toFixed(2)}`;
}

// Funções auxiliares para datas
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

// Funções de edição e exclusão
function editClient(clientId) {
    const client = clients.find(c => c.id === clientId);
    if (!client) return;
    
    // Preencher o formulário de edição
    document.getElementById('editClientId').value = client.id;
    document.getElementById('editClientName').value = client.name;
    document.getElementById('editClientCPF').value = client.cpf;
    document.getElementById('editClientEmail').value = client.email;
    document.getElementById('editClientPhone').value = client.phone;
    document.getElementById('editClientAddress').value = client.address;
    document.getElementById('editClientRG').value = client.rg || '';
    document.getElementById('editClientBirthDate').value = client.birth_date || '';
    document.getElementById('editClientPhoto').value = client.photo || '';
    
    // Atualizar preview da foto existente
    if (client.photo) {
        const previewDiv = document.getElementById('editPhotoUploadPreview');
        const previewImg = document.getElementById('editPhotoPreviewImg');
        
        previewImg.src = client.photo;
        previewDiv.classList.remove('hidden');
        
        // Configurar o widget com a foto atual se disponível
        if (window.uploadcare) {
            const editWidget = uploadcare.Widget('#editClientPhotoUploader');
            editWidget.value(client.photo);
        }
    } else {
        // Se não há foto, manter preview oculto
        document.getElementById('editPhotoUploadPreview').classList.add('hidden');
    }
    
    showModal(document.getElementById('editClientModal'));
    
    // Mostrar mensagem informativa
    showInfoMessage(`Editando cliente: ${client.name}`);
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

function showNewPaymentFromHistory() {
    const loanId = document.getElementById('paymentHistoryLoanId').value;
    if (!loanId) return;
    
    // Fechar modal de histórico
    hideModal(paymentHistoryModal);
    
    // Mostrar modal de pagamento
    showPaymentModal(loanId);
}

// Função para enviar mensagem de cobrança via WhatsApp
async function sendWhatsAppMessage(loanId) {
    const loan = loans.find(l => l.id === loanId);
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

    try {
        // Calcular valores atuais do empréstimo
        const principalAmount = parseFloat(loan.amount);
        const interestRate = parseFloat(loan.interest_rate);
        const interestAmount = principalAmount * (interestRate / 100);
        const remainingAmount = await calculateLoanRemainingAmount(loanId);
        
        // Calcular multa se estiver vencido
        const dueDate = new Date(loan.due_date);
        const today = new Date();
        const daysOverdue = Math.floor((today - dueDate) / (1000 * 60 * 60 * 24));
        const dailyFine = 50.00; // Multa diária de R$ 50,00
        const currentFine = daysOverdue > 0 ? daysOverdue * dailyFine : 0;

        // Formatar data de vencimento
        const formattedDueDate = formatDate(loan.due_date);

        // Montar mensagem do WhatsApp
        const message = `📅 VENCIMENTO: ${formattedDueDate}

💰 CLIENTE: ${client.name}
💵 Capital: R$ ${principalAmount.toFixed(2)}
📈 Juros: R$ ${interestAmount.toFixed(2)}
❌ Multa atual: R$ ${currentFine.toFixed(2)}

📌 PAGAMENTO VIA PIX (CNPJ):
Chave PIX: 54413674000147
Favorecido: Tuane Carla Mendes Tomaz
Instituição: Stone Pagamento S.A

⚠️🚨 ATENÇÃO!
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

    } catch (error) {
        console.error('Erro ao enviar mensagem do WhatsApp:', error);
        showErrorMessage('Erro ao preparar mensagem do WhatsApp: ' + error.message);
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
                    <td colspan="5" class="px-6 py-8 text-center text-gray-400">
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
            const paymentType = getPaymentTypeText(payment.payment_type);
            const paymentNotes = payment.notes || 'Sem notas';
            
            tbody.innerHTML += `
                <tr class="table-row">
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(payment.payment_date)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">R$ ${paymentAmount.toFixed(2)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${paymentType}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${paymentNotes}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <button class="text-blue-400 hover:text-blue-300 mr-3" onclick="editPayment('${payment.id}')">✏️</button>
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
    
    const totalWithInterest = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
    const totalPaid = payments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
    const remainingAmount = totalWithInterest - totalPaid;
    
    document.getElementById('paymentHistoryTotalPaid').textContent = `R$ ${totalPaid.toFixed(2)}`;
    document.getElementById('paymentHistoryRemainingAmount').textContent = `R$ ${remainingAmount.toFixed(2)}`;
    document.getElementById('paymentHistoryTotalWithInterest').textContent = `R$ ${totalWithInterest.toFixed(2)}`;
}

function getPaymentTypeText(type) {
    switch (type) {
        case 'partial': return 'Parcial';
        case 'full': return 'Total';
        case 'interest': return 'Apenas Juros';
        case 'principal': return 'Apenas Principal';
        case 'adjustment': return 'Ajuste/Recálculo';
        case 'renewal': return '🔄 Renovação';
        case 'interest_renewal': return '🔄 Renovação (Juros)';
        case 'capital_payment': return '💰 Pagamento Capital';
        case 'partial_interest': return '⚠️ Juros Parcial';
        default: return type;
    }
}

async function editPayment(paymentId) {
    const payment = payments.find(p => p.id === paymentId); // Assuming 'payments' is a global variable or passed as an argument
    if (!payment) return;

    const paymentForm = document.getElementById('paymentForm'); // Assuming this is the payment modal form
    if (!paymentForm) return;

    paymentForm.dataset.paymentId = paymentId; // Set the payment ID for the form

    document.getElementById('paymentAmount').value = payment.amount;
    document.getElementById('paymentDate').value = payment.payment_date;
    document.getElementById('paymentType').value = payment.payment_type;
    document.getElementById('paymentNotes').value = payment.notes;

    showModal(paymentModal);
}

async function deletePayment(paymentId) {
    const payment = payments.find(p => p.id === paymentId); // Assuming 'payments' is a global variable or passed as an argument
    if (!payment) return;

    showConfirmationModal(
        'Excluir Pagamento',
        `Tem certeza que deseja excluir o pagamento de R$ ${parseFloat(payment.amount).toFixed(2)} registrado em ${formatDate(payment.payment_date)}? Esta ação não pode ser desfeita.`,
        () => performDeletePayment(paymentId),
        'Excluir'
    );
}

async function performDeletePayment(paymentId) {
    try {
        const { error } = await supabase
            .from('payments')
            .delete()
            .eq('id', paymentId);
        
        if (error) throw error;
        
        hideModal(document.getElementById('confirmationModal'));
        
        // Recarregar histórico de pagamentos
        const loanId = document.getElementById('paymentHistoryLoanId').value;
        if (loanId) {
            await loadPaymentHistory(loanId);
        }
        
        // Mostrar mensagem de sucesso
        showSuccessMessage('Pagamento excluído com sucesso!');
        
    } catch (error) {
        console.error('Erro ao excluir pagamento:', error);
        alert('Erro ao excluir pagamento: ' + error.message);
    }
}

// Função para calcular valor restante de um empréstimo
async function calculateLoanRemainingAmount(loanId) {
    try {
        const loan = loans.find(l => l.id === loanId);
        if (!loan) return 0;
        
        const capitalAmount = parseFloat(loan.amount);
        let interestRate = parseFloat(loan.interest_rate);
        
        // Ajustar taxa se necessário
        if (interestRate > 100) {
            interestRate = interestRate / 100;
        }
        
        const interestAmount = capitalAmount * (interestRate / 100);
        const totalWithInterest = capitalAmount + interestAmount;
        
        // Buscar pagamentos já feitos
        const { data: payments, error } = await supabase
            .from('payments')
            .select('amount, payment_type')
            .eq('loan_id', loanId);
        
        if (error) throw error;
        
        // Verificar se houve renovações
        const realPayments = payments.filter(p => parseFloat(p.amount) > 0);
        const hasRenewals = payments.some(p => p.payment_type === 'renewal');
        
        let totalPaid;
        if (hasRenewals) {
            // Se houve renovação, considerar apenas pagamentos após a última renovação
            const lastRenewalIndex = payments.map(p => p.payment_type).lastIndexOf('renewal');
            const paymentsAfterRenewal = realPayments.filter((payment, index) => {
                const paymentIndex = payments.findIndex(p => p === payment);
                return paymentIndex > lastRenewalIndex;
            });
            totalPaid = paymentsAfterRenewal.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        } else {
            // Lógica original
            totalPaid = realPayments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        }
        
        // Calcular valor restante usando a mesma lógica da função principal
        let remainingAmount;
        
        if (totalPaid === 0) {
            remainingAmount = totalWithInterest;
        } else {
            const paidExactlyInterest = Math.abs(totalPaid - interestAmount) <= (interestAmount * 0.01);
            const paidMoreThanInterest = totalPaid > interestAmount;
            const paidLessThanInterest = totalPaid < interestAmount;
            
            if (paidExactlyInterest) {
                // PAGOU APENAS JUROS: próximo período terá mesmo valor total
                remainingAmount = capitalAmount + interestAmount;
            } else if (paidMoreThanInterest) {
                // PAGOU CAPITAL + JUROS: Capital foi reduzido
                const paidCapital = totalPaid - interestAmount;
                const newCapital = Math.max(0, capitalAmount - paidCapital);
                const newInterest = newCapital * (interestRate / 100);
                remainingAmount = newCapital + newInterest;
            } else if (paidLessThanInterest) {
                // PAGOU MENOS QUE OS JUROS: Juros pendentes + novos juros
                const unpaidInterest = interestAmount - totalPaid;
                const newInterest = capitalAmount * (interestRate / 100);
                remainingAmount = capitalAmount + unpaidInterest + newInterest;
            } else {
                remainingAmount = totalWithInterest - totalPaid;
            }
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
        await loadClients();
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
        await loadLoans();
        await updateDashboard();
        
        // Mostrar mensagem de sucesso
        showSuccessMessage('Empréstimo excluído com sucesso!');
        
    } catch (error) {
        console.error('Erro ao excluir empréstimo:', error);
        alert('Erro ao excluir empréstimo: ' + error.message);
    }
}

function populateEditLoanClientSelect(selectedClientId) {
    const select = document.getElementById('editLoanClient');
    select.innerHTML = '<option value="">Selecione um cliente</option>';
    
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
                
                // Mostrar mensagem de sucesso
                showSuccessMessage('Empréstimo quitado com sucesso e movido para histórico de quitados!');
                
                // Atualizar interface imediatamente sem recarregar do banco
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
        
        // Buscar todos os empréstimos do cliente
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
        
        // Buscar todos os pagamentos dos empréstimos do cliente
        const loanIds = clientLoans.map(loan => loan.id);
        let clientPayments = [];
        
        if (loanIds.length > 0) {
            const { data: payments, error: paymentsError } = await supabase
                .from('payments')
                .select('*')
                .in('loan_id', loanIds)
                .order('payment_date', { ascending: false });
            
            if (paymentsError) throw paymentsError;
            clientPayments = payments || [];
        }
        
        // Calcular resumo financeiro
        const totalLoans = clientLoans.length;
        const totalAmount = clientLoans.reduce((sum, loan) => sum + parseFloat(loan.amount), 0);
        const totalPaid = clientPayments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        
        let totalRemaining = 0;
        for (const loan of clientLoans) {
            const remainingAmount = await calculateLoanRemainingAmount(loan.id);
            totalRemaining += remainingAmount;
        }
        
        // Atualizar resumo do cliente
        document.getElementById('historyTotalLoans').textContent = totalLoans;
        document.getElementById('historyTotalAmount').textContent = `R$ ${totalAmount.toFixed(2)}`;
        document.getElementById('historyTotalPaid').textContent = `R$ ${totalPaid.toFixed(2)}`;
        document.getElementById('historyRemainingAmount').textContent = `R$ ${totalRemaining.toFixed(2)}`;
        
        // Mostrar resumo do cliente
        document.getElementById('clientSummary').classList.remove('hidden');
        
        // Renderizar tabela de empréstimos
        renderHistoryLoansTable(clientLoans);
        
        // Renderizar tabela de pagamentos
        renderHistoryPaymentsTable(clientPayments, clientLoans);
        
        showSuccessMessage(`Histórico carregado para ${client.name}`);
        
    } catch (error) {
        console.error('Erro ao carregar histórico:', error);
        showInfoMessage('Erro ao carregar histórico: ' + error.message);
    }
}

// Função para renderizar tabela de empréstimos do histórico
function renderHistoryLoansTable(clientLoans) {
    const tbody = document.getElementById('historyLoansTableBody');
    
    if (clientLoans.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="7" class="px-6 py-8 text-center text-gray-400">
                    Nenhum empréstimo encontrado para este cliente
                </td>
            </tr>
        `;
        return;
    }
    
    let tableHTML = '';
    for (const loan of clientLoans) {
        const originalTotal = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
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
                <td class="px-6 py-4 whitespace-nowrap">
                    <span class="status-badge ${getStatusClass(status)}">${getStatusText(status)}</span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                    <div class="text-blue-300">R$ ${originalTotal.toFixed(2)}</div>
                </td>
            </tr>
        `;
    }
    
    tbody.innerHTML = tableHTML;
}

// Função para renderizar tabela de pagamentos do histórico
function renderHistoryPaymentsTable(clientPayments, clientLoans) {
    const tbody = document.getElementById('historyPaymentsTableBody');
    
    if (clientPayments.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="5" class="px-6 py-8 text-center text-gray-400">
                    Nenhum pagamento encontrado para este cliente
                </td>
            </tr>
        `;
        return;
    }
    
    let tableHTML = '';
    for (const payment of clientPayments) {
        const loan = clientLoans.find(l => l.id === payment.loan_id);
        const loanAmount = loan ? parseFloat(loan.amount) : 0;
        const loanInterest = loan ? parseFloat(loan.interest_rate) : 0;
        const loanTotal = loanAmount + (loanAmount * loanInterest / 100);
        
        tableHTML += `
            <tr class="table-row">
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(payment.payment_date)}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">R$ ${parseFloat(payment.amount).toFixed(2)}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${getPaymentTypeText(payment.payment_type)}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                    <div>R$ ${loanAmount.toFixed(2)}</div>
                    <div class="text-xs text-gray-400">Total: R$ ${loanTotal.toFixed(2)}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${payment.notes || 'Sem notas'}</td>
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
        
        // Fechar modal de confirmação
        hideModal(document.getElementById('confirmationModal'));
        
        // Mostrar mensagem de sucesso
        showSuccessMessage('Empréstimo cancelado com sucesso e movido para histórico de cancelamentos!');
        
        // Atualizar interface imediatamente
        await renderLoansTable();
        await updateDashboard();
        await updateCharts();
        
    } catch (error) {
        console.error('Erro ao cancelar empréstimo:', error);
        showInfoMessage('Erro ao cancelar empréstimo: ' + error.message);
    }
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
        
        const message = `
Detalhes do Empréstimo Quitado:

Cliente: ${client?.name || 'Cliente não encontrado'}
CPF: ${client?.cpf || 'N/A'}
Valor Original: R$ ${parseFloat(paidLoan.original_amount).toFixed(2)}
Taxa de Juros: ${paidLoan.interest_rate}%
Total com Juros: R$ ${parseFloat(paidLoan.total_with_interest).toFixed(2)}
Data do Empréstimo: ${formatDate(paidLoan.loan_date)}
Data de Vencimento: ${formatDate(paidLoan.due_date)}
Data de Quitação: ${formatDate(paidLoan.paid_date)}
Total Pago: R$ ${parseFloat(paidLoan.total_paid).toFixed(2)}
Método de Pagamento: ${paidLoan.payment_method || 'N/A'}
Observações: ${paidLoan.notes || 'N/A'}
        `;
        
        alert(message);
        
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
        
        // Atualizar interface
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
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('expenseDate').value = today;
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
        // First, get the expenses
        const { data: expensesData, error: expensesError } = await supabase
            .from('expenses')
            .select('*')
            .eq('user_id', currentUser.id)
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
                <td colspan="5" class="px-6 py-8 text-center text-gray-400">
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
        const mutuanteText = "VALORUM, pessoa jurídica de direito privado, inscrita no CNPJ sob nº 52.496.899/0001-89, com sede à Rua Domingos Chicaroni, nº 5840, APT 2, Jardim Três Colinas, Franca/SP.";
        yPosition = addWrappedText(mutuanteText, margin, yPosition, maxWidth) + 3;

        // Mutuário
        doc.setFont('helvetica', 'bold');
        yPosition = addWrappedText("MUTUÁRIO:", margin, yPosition, maxWidth);
        doc.setFont('helvetica', 'normal');
        const mutuarioText = `${client.name}, brasileiro, portador do CPF nº ${client.cpf}, RG nº ${client.rg || 'N/A'}, residente e domiciliada à ${client.address || 'Endereço não informado'}.`;
        yPosition = addWrappedText(mutuarioText, margin, yPosition, maxWidth) + 5;

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
        const encerramentoText = "E por estarem assim justos e contratados, firmam o presente instrumento em duas vias de igual teor e forma, na presença de duas testemunhas, para que produza seus jurídicos e legais efeitos.";
        yPosition = addWrappedText(encerramentoText, margin, yPosition, maxWidth) + 6;

        // Data e local
        const dataEmprestimo = new Date(loan.loan_date).toLocaleDateString('pt-BR');
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

        // Testemunha
        yPosition += 8;
        doc.setFont('helvetica', 'normal');
        const testemunhaText = "Testemunha: Inove Porcelanataria e Marmoraria LTDA";
        yPosition = addWrappedText(testemunhaText, margin, yPosition, maxWidth);
        const cnpjText = "CNPJ: 50.485.843/0001-01";
        yPosition = addWrappedText(cnpjText, margin, yPosition, maxWidth);

        // Salvar o PDF
        const fileName = `Contrato_${client.name.replace(/\s+/g, '_')}_${new Date().toISOString().split('T')[0]}.pdf`;
        doc.save(fileName);

        showSuccessMessage('Contrato gerado com sucesso!');

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

        if (monthlyLoans.length === 0) {
            showInfoMessage('Nenhum empréstimo foi encontrado no último mês.');
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
        
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text(`Total de empréstimos: ${monthlyLoans.length}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total emprestado: R$ ${totalAmount.toFixed(2).replace('.', ',')}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Total de juros: R$ ${totalInterest.toFixed(2).replace('.', ',')}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total com juros: R$ ${totalWithInterest.toFixed(2).replace('.', ',')}`, 20, yPosition);
        yPosition += 15;
        
        // Cabeçalho da tabela
        doc.setFontSize(12);
        doc.setFont('helvetica', 'bold');
        doc.text('DETALHAMENTO DOS EMPRÉSTIMOS', 20, yPosition);
        yPosition += 10;
        
        // Cabeçalhos das colunas
        doc.setFontSize(8);
        doc.setFont('helvetica', 'bold');
        doc.text('Data', 20, yPosition);
        doc.text('Cliente', 40, yPosition);
        doc.text('Valor', 100, yPosition);
        doc.text('Juros%', 130, yPosition);
        doc.text('Total', 150, yPosition);
        doc.text('Status', 175, yPosition);
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
                doc.text('Valor', 100, yPosition);
                doc.text('Juros%', 130, yPosition);
                doc.text('Total', 150, yPosition);
                doc.text('Status', 175, yPosition);
                yPosition += 5;
                doc.line(20, yPosition, 190, yPosition);
                yPosition += 5;
                doc.setFont('helvetica', 'normal');
            }
            
            const loanDate = new Date(loan.created_at).toLocaleDateString('pt-BR');
            const clientName = loan.clients ? loan.clients.name : 'Cliente não encontrado';
            const amount = parseFloat(loan.amount);
            const interestRate = parseFloat(loan.interest_rate);
            const totalWithInterestLoan = amount + (amount * interestRate / 100);
            
            // Truncar nome do cliente se for muito longo
            const truncatedName = clientName.length > 25 ? clientName.substring(0, 22) + '...' : clientName;
            
            doc.text(loanDate, 20, yPosition);
            doc.text(truncatedName, 40, yPosition);
            doc.text(`R$ ${amount.toFixed(2).replace('.', ',')}`, 100, yPosition);
            doc.text(`${interestRate.toFixed(1)}%`, 130, yPosition);
            doc.text(`R$ ${totalWithInterestLoan.toFixed(2).replace('.', ',')}`, 150, yPosition);
            doc.text(loan.status === 'active' ? 'Ativo' : loan.status === 'paid' ? 'Pago' : 'Cancelado', 175, yPosition);
            
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
        const fileName = `Emprestimos_Ultimo_Mes_${new Date().toISOString().split('T')[0]}.pdf`;
        doc.save(fileName);

        showSuccessMessage(`PDF gerado com sucesso! ${monthlyLoans.length} empréstimos encontrados.`);

    } catch (error) {
        console.error('Erro ao gerar PDF dos empréstimos:', error);
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
            
            const expenseDate = new Date(expense.date).toLocaleDateString('pt-BR');
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
    
    // Carregar empréstimos vencidos
    loadOverdueLoansForInstallment();
    
    // Definir data padrão como próximo mês
    const nextMonth = new Date();
    nextMonth.setMonth(nextMonth.getMonth() + 1);
    document.getElementById('installmentFirstDueDate').value = nextMonth.toISOString().split('T')[0];
    
    newInstallmentModal.classList.remove('hidden');
}

// Carregar empréstimos vencidos para parcelamento
async function loadOverdueLoansForInstallment() {
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

        const loanSelect = document.getElementById('installmentLoanId');
        loanSelect.innerHTML = '<option value="">Selecione um empréstimo vencido</option>';

        overdueLoans.forEach(loan => {
            const daysOverdue = Math.floor((new Date() - new Date(loan.due_date)) / (1000 * 60 * 60 * 24));
            const option = document.createElement('option');
            option.value = loan.id;
            option.textContent = `${loan.clients.name} - R$ ${loan.total_amount.toFixed(2)} (${daysOverdue} dias vencido)`;
            option.dataset.clientName = loan.clients.name;
            option.dataset.totalAmount = loan.total_amount;
            option.dataset.clientId = loan.client_id;
            loanSelect.appendChild(option);
        });

    } catch (error) {
        console.error('Erro ao carregar empréstimos vencidos:', error);
        showNotification('Erro ao carregar empréstimos vencidos', 'error');
    }
}

// Atualizar informações quando um empréstimo é selecionado
document.getElementById('installmentLoanId').addEventListener('change', function() {
    const selectedOption = this.options[this.selectedIndex];
    if (selectedOption.value) {
        document.getElementById('installmentClientName').value = selectedOption.dataset.clientName;
        document.getElementById('installmentTotalAmount').value = selectedOption.dataset.totalAmount;
    } else {
        document.getElementById('installmentClientName').value = '';
        document.getElementById('installmentTotalAmount').value = '';
    }
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

// Criar parcelamento
document.getElementById('newInstallmentForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    const loanId = document.getElementById('installmentLoanId').value;
    const clientId = document.getElementById('installmentLoanId').options[document.getElementById('installmentLoanId').selectedIndex].dataset.clientId;
    const totalAmount = parseFloat(document.getElementById('installmentTotalAmount').value);
    const totalInstallments = parseInt(document.getElementById('installmentTotalInstallments').value);
    const interestRate = parseFloat(document.getElementById('installmentInterestRate').value) || 0;
    const firstDueDate = document.getElementById('installmentFirstDueDate').value;
    const notes = document.getElementById('installmentNotes').value;

    if (!loanId || !totalAmount || !totalInstallments || !firstDueDate) {
        showNotification('Preencha todos os campos obrigatórios', 'error');
        return;
    }

    try {
        // Calcular valor da parcela
        let installmentAmount;
        if (interestRate > 0) {
            const monthlyRate = interestRate / 100;
            const factor = Math.pow(1 + monthlyRate, totalInstallments);
            installmentAmount = totalAmount * (monthlyRate * factor) / (factor - 1);
        } else {
            installmentAmount = totalAmount / totalInstallments;
        }

        // Criar parcelamento
        const { data: installmentData, error: installmentError } = await supabase
            .from('installments')
            .insert([
                {
                    loan_id: loanId,
                    client_id: clientId,
                    total_amount: totalAmount,
                    total_installments: totalInstallments,
                    installment_amount: installmentAmount,
                    first_due_date: firstDueDate,
                    interest_rate: interestRate,
                    notes: notes,
                    created_by: currentUser.id
                }
            ])
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
                installment_id: installmentData.id,
                installment_number: i,
                amount: installmentAmount,
                due_date: dueDate.toISOString().split('T')[0]
            });
        }

        const { error: paymentsError } = await supabase
            .from('installment_payments')
            .insert(installmentPaymentsData);

        if (paymentsError) throw paymentsError;

        // Atualizar status do empréstimo para "partial_paid" (parcelamento ativo)
        const { error: loanUpdateError } = await supabase
            .from('loans')
            .update({ status: 'partial_paid' })
            .eq('id', loanId);

        if (loanUpdateError) {
            console.warn('Aviso: Não foi possível atualizar o status do empréstimo:', loanUpdateError);
        }

        closeInstallmentModal();
        showNotification('Parcelamento criado com sucesso!', 'success');
        loadInstallments();
        
    } catch (error) {
        console.error('Erro ao criar parcelamento:', error);
        showNotification('Erro ao criar parcelamento', 'error');
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

    if (installments.length === 0) {
        tableBody.innerHTML = `
            <tr>
                <td colspan="7" class="px-6 py-4 text-center text-gray-400">
                    Nenhum parcelamento ativo encontrado
                </td>
            </tr>
        `;
        return;
    }

    tableBody.innerHTML = installments.map(installment => {
        // Calcular próximo vencimento
        const unpaidPayments = installment.installment_payments.filter(p => p.status === 'pending');
        const nextDueDate = unpaidPayments.length > 0 
            ? new Date(unpaidPayments[0].due_date).toLocaleDateString('pt-BR') 
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
                <td class="px-6 py-4 text-white">${new Date(payment.due_date).toLocaleDateString('pt-BR')}</td>
                <td class="px-6 py-4">
                    <span class="px-2 py-1 text-xs font-medium rounded-full ${statusColors[currentStatus]}">
                        ${statusLabels[currentStatus]}
                    </span>
                </td>
                <td class="px-6 py-4 text-white">${payment.paid_date ? new Date(payment.paid_date).toLocaleDateString('pt-BR') : '-'}</td>
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
                    <p class="text-white">${new Date(data.due_date).toLocaleDateString('pt-BR')}</p>
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
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('installmentPaidDate').value = today;

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
        showNotification('Pagamento registrado com sucesso!', 'success');
        
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
                        <button onclick="createInstallmentFromLoan('${loan.id}')" 
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

// Criar parcelamento a partir de um empréstimo específico
function createInstallmentFromLoan(loanId) {
    openInstallmentModal();
    
    // Aguardar um pouco para o modal carregar
    setTimeout(() => {
        const loanSelect = document.getElementById('installmentLoanId');
        loanSelect.value = loanId;
        
        // Trigger change event para preencher dados automaticamente
        const changeEvent = new Event('change');
        loanSelect.dispatchEvent(changeEvent);
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
        
        const formattedDate = new Date(raising.data_criacao).toLocaleDateString('pt-BR');
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
        
        const formattedDate = new Date(client.data_entrada).toLocaleDateString('pt-BR');
        
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
            ['Data de Criação:', new Date(raising.data_criacao).toLocaleDateString('pt-BR')],
            ['Status:', raising.ativo ? 'Ativo' : 'Inativo'],
        ];
        
        if (raising.data_baixa) {
            info.push(['Data da Baixa:', new Date(raising.data_baixa).toLocaleDateString('pt-BR')]);
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
                    new Date(client.data_entrada).toLocaleDateString('pt-BR')
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
