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

// Botões
const newClientBtn = document.getElementById('newClientBtn');
const newLoanBtn = document.getElementById('newLoanBtn');

// Formulários
const newClientForm = document.getElementById('newClientForm');
const newLoanForm = document.getElementById('newLoanForm');
const paymentForm = document.getElementById('paymentForm');

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
    
    // Fechar modais
    document.getElementById('closeClientModal').addEventListener('click', () => hideModal(newClientModal));
    document.getElementById('closeLoanModal').addEventListener('click', () => hideModal(newLoanModal));
    document.getElementById('closePaymentModal').addEventListener('click', () => hideModal(paymentModal));
    document.getElementById('closeEditClientModal').addEventListener('click', () => hideModal(editClientModal));
    document.getElementById('closeEditLoanModal').addEventListener('click', () => hideModal(editLoanModal));
    document.getElementById('closePaymentHistoryModal').addEventListener('click', () => hideModal(paymentHistoryModal));
    
    // Cancelar modais
    document.getElementById('cancelClientBtn').addEventListener('click', () => hideModal(newClientModal));
    document.getElementById('cancelLoanBtn').addEventListener('click', () => hideModal(newLoanModal));
    document.getElementById('cancelPaymentBtn').addEventListener('click', () => hideModal(paymentModal));
    document.getElementById('cancelEditClientBtn').addEventListener('click', () => hideModal(editClientModal));
    document.getElementById('cancelEditLoanBtn').addEventListener('click', () => hideModal(editLoanModal));
    document.getElementById('cancelConfirmationBtn').addEventListener('click', () => hideModal(confirmationModal));
    document.getElementById('closePaymentHistoryBtn').addEventListener('click', () => hideModal(paymentHistoryModal));
    
    // Botões do modal de histórico de pagamentos
    document.getElementById('newPaymentBtn').addEventListener('click', () => showNewPaymentFromHistory());
    
    // Botão de carregar histórico
    document.getElementById('loadHistoryBtn').addEventListener('click', () => loadClientHistory());
    
    // Formulários
    newClientForm.addEventListener('submit', handleNewClient);
    newLoanForm.addEventListener('submit', handleNewLoan);
    paymentForm.addEventListener('submit', handlePayment);
    document.getElementById('editClientForm').addEventListener('submit', handleEditClient);
    document.getElementById('editLoanForm').addEventListener('submit', handleEditLoan);
    
    // Cálculos em tempo real
    document.getElementById('loanAmount').addEventListener('input', updateLoanSummary);
    document.getElementById('loanInterest').addEventListener('input', updateLoanSummary);
    document.getElementById('editLoanAmount').addEventListener('input', updateEditLoanSummary);
    document.getElementById('editLoanInterest').addEventListener('input', updateEditLoanSummary);
}

// Configurar Uploadcare
function setupUploadcare() {
    if (window.uploadcare) {
        // Widget para novo cliente
        const widget = window.uploadcare.Widget('#photoUpload');
        widget.onChange(function(file) {
            if (file) {
                file.done(function(fileInfo) {
                    document.getElementById('clientPhoto').value = fileInfo.cdnUrl;
                    document.getElementById('photoUpload').innerHTML = `
                        <div class="text-center">
                            <img src="${fileInfo.cdnUrl}" alt="Foto do cliente" class="w-20 h-20 rounded-lg mx-auto mb-2 object-cover">
                            <p class="text-green-400 text-sm">Foto carregada com sucesso!</p>
                        </div>
                    `;
                });
            }
        });
        
        // Widget para edição de cliente
        const editWidget = window.uploadcare.Widget('#editPhotoUpload');
        editWidget.onChange(function(file) {
            if (file) {
                file.done(function(fileInfo) {
                    document.getElementById('editClientPhoto').value = fileInfo.cdnUrl;
                    document.getElementById('editPhotoUpload').innerHTML = `
                        <div class="text-center">
                            <img src="${fileInfo.cdnUrl}" alt="Foto do cliente" class="w-20 h-20 rounded-lg mx-auto mb-2 object-cover">
                            <p class="text-green-400 text-sm">Foto atualizada com sucesso!</p>
                        </div>
                    `;
                });
            }
        });
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
        await Promise.all([
            loadClients(),
            loadLoans()
        ]);
        
        // Carregar empréstimos quitados e cancelados separadamente
        await renderPaidLoansTable();
        await renderCancelledLoansTable();
        
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
        await renderOverdueTable();
        
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
                <button class="text-blue-400 hover:text-blue-300 mr-3" onclick="editClient('${client.id}')">Editar</button>
                <button class="text-red-400 hover:text-red-300" onclick="deleteClient('${client.id}')">Excluir</button>
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
                    <button class="text-blue-400 hover:text-blue-300 mr-3" onclick="editLoan('${loan.id}')">Editar</button>
                    <button class="text-purple-400 hover:text-purple-300 mr-3" onclick="showPaymentHistory('${loan.id}')">Gerenciar Pagamentos</button>
                    <button class="text-green-400 hover:text-green-300 mr-3" onclick="markLoanAsPaid('${loan.id}')" ${loan.status === 'paid' ? 'disabled' : ''}>${loan.status === 'paid' ? 'Quitado' : 'Marcar como Quitado'}</button>
                    <button class="text-red-400 hover:text-red-300" onclick="deleteLoan('${loan.id}')">Excluir</button>
                </td>
            </tr>
        `;
    }
    
    tbody.innerHTML = tableHTML;
}

// Renderizar tabela de empréstimos vencidos
async function renderOverdueTable() {
    const overdueLoans = loans.filter(loan => {
        const dueDate = new Date(loan.due_date);
        const today = new Date();
        return dueDate < today && loan.status !== 'paid';
    });
    
    const tbody = document.getElementById('overdueTableBody');
    
    if (overdueLoans.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="5" class="px-6 py-8 text-center text-gray-400">
                    Nenhum empréstimo vencido
                </td>
            </tr>
        `;
        return;
    }
    
    // Renderizar linhas com valores atualizados
    let tableHTML = '';
    for (const loan of overdueLoans) {
        const dueDate = new Date(loan.due_date);
        const today = new Date();
        const daysOverdue = Math.floor((today - dueDate) / (1000 * 60 * 60 * 24));
        const originalTotal = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
        const remainingAmount = await calculateLoanRemainingAmount(loan.id);
        
        tableHTML += `
            <tr class="table-row">
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm font-medium text-white">${loan.clients?.name || 'Cliente não encontrado'}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">R$ ${originalTotal.toFixed(2)}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">R$ ${remainingAmount.toFixed(2)}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${daysOverdue} dias</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    <button class="text-green-400 hover:text-green-300 mr-3" onclick="showPaymentModal('${loan.id}')">Registrar Pagamento</button>
                    <button class="text-blue-400 hover:text-blue-300 mr-3" onclick="editLoan('${loan.id}')">Editar</button>
                    <button class="text-purple-400 hover:text-purple-300 mr-3" onclick="showPaymentHistory('${loan.id}')">Gerenciar Pagamentos</button>
                    <button class="text-green-400 hover:text-green-300 mr-3" onclick="markLoanAsPaid('${loan.id}')" ${loan.status === 'paid' ? 'disabled' : ''}>${loan.status === 'paid' ? 'Quitado' : 'Marcar como Quitado'}</button>
                    <button class="text-red-400 hover:text-red-300" onclick="deleteLoan('${loan.id}')">Excluir</button>
                </td>
            </tr>
        `;
    }
    
    tbody.innerHTML = tableHTML;
}

// Renderizar tabela de empréstimos quitados
async function renderPaidLoansTable() {
    try {
        // Buscar empréstimos quitados da tabela paid_loans
        const { data: paidLoans, error } = await supabase
            .from('paid_loans')
            .select(`
                *,
                clients (
                    name,
                    cpf,
                    email,
                    phone
                )
            `)
            .order('paid_date', { ascending: false });
        
        if (error) throw error;
        
        const tbody = document.getElementById('paidLoansTableBody');
        
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
            tableHTML += `
                <tr class="table-row">
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-white">${paidLoan.clients?.name || 'Cliente não encontrado'}</div>
                        <div class="text-sm text-gray-300">${paidLoan.clients?.cpf || ''}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">R$ ${parseFloat(paidLoan.original_amount).toFixed(2)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${paidLoan.interest_rate}%</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(paidLoan.loan_date)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(paidLoan.due_date)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-green-300">
                        R$ ${parseFloat(paidLoan.total_paid).toFixed(2)}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                        ${formatDate(paidLoan.paid_date)}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <button class="text-blue-400 hover:text-blue-300 mr-3" onclick="showPaidLoanDetails('${paidLoan.id}')">Detalhes</button>
                        <button class="text-green-400 hover:text-green-300 mr-3" onclick="restorePaidLoan('${paidLoan.id}')">Restaurar</button>
                        <button class="text-red-400 hover:text-red-300" onclick="deletePaidLoan('${paidLoan.id}')">Excluir</button>
                    </td>
                </tr>
            `;
        }
        
        tbody.innerHTML = tableHTML;
        
    } catch (error) {
        console.error('Erro ao carregar empréstimos quitados:', error);
        const tbody = document.getElementById('paidLoansTableBody');
        tbody.innerHTML = `
            <tr>
                <td colspan="8" class="px-6 py-8 text-center text-gray-400">
                    Erro ao carregar empréstimos quitados
                </td>
            </tr>
        `;
    }
}

// Renderizar tabela de empréstimos cancelados
async function renderCancelledLoansTable() {
    try {
        // Buscar empréstimos cancelados da tabela cancelled_loans
        const { data: cancelledLoans, error } = await supabase
            .from('cancelled_loans')
            .select(`
                *,
                clients (
                    name,
                    cpf,
                    email,
                    phone
                )
            `)
            .order('cancellation_date', { ascending: false });
        
        if (error) throw error;
        
        const tbody = document.getElementById('cancelledLoansTableBody');
        
        if (!cancelledLoans || cancelledLoans.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="8" class="px-6 py-8 text-center text-gray-400">
                        Nenhum empréstimo cancelado
                    </td>
                </tr>
            `;
            return;
        }
        
        // Renderizar linhas com valores atualizados
        let tableHTML = '';
        for (const cancelledLoan of cancelledLoans) {
            tableHTML += `
                <tr class="table-row">
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-white">${cancelledLoan.clients?.name || 'Cliente não encontrado'}</div>
                        <div class="text-sm text-gray-300">${cancelledLoan.clients?.cpf || ''}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">R$ ${parseFloat(cancelledLoan.original_amount).toFixed(2)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${cancelledLoan.interest_rate}%</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(cancelledLoan.loan_date)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">${formatDate(cancelledLoan.due_date)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                        ${formatDate(cancelledLoan.cancellation_date)}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-300">
                        <div class="text-red-300">Cancelado</div>
                        <div class="text-xs text-gray-400">Motivo: ${cancelledLoan.cancellation_reason}</div>
                        <div class="text-xs text-gray-400">Pago antes: R$ ${parseFloat(cancelledLoan.total_paid_before_cancellation).toFixed(2)}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <button class="text-blue-400 hover:text-blue-300 mr-3" onclick="showCancelledLoanDetails('${cancelledLoan.id}')">Detalhes</button>
                        <button class="text-green-400 hover:text-green-300 mr-3" onclick="restoreCancelledLoan('${cancelledLoan.id}')">Restaurar</button>
                        <button class="text-red-400 hover:text-red-300" onclick="deleteCancelledLoan('${cancelledLoan.id}')">Excluir</button>
                    </td>
                </tr>
            `;
        }
        
        tbody.innerHTML = tableHTML;
        
    } catch (error) {
        console.error('Erro ao carregar empréstimos cancelados:', error);
        const tbody = document.getElementById('cancelledLoansTableBody');
        tbody.innerHTML = `
            <tr>
                <td colspan="8" class="px-6 py-8 text-center text-gray-400">
                    Erro ao carregar empréstimos cancelados
                </td>
            </tr>
        `;
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
        
        // Atualizar status do empréstimo baseado no tipo de pagamento
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
        
        hideModal(paymentModal);
        paymentForm.reset();
        
        // Recarregar dados
        await loadLoans();
        await updateDashboard();
        
        // Se o modal de histórico estiver aberto, recarregar os dados
        if (!paymentHistoryModal.classList.contains('hidden')) {
            await loadPaymentHistory(loanId);
        }
        
        // Mostrar mensagem de sucesso
        showSuccessMessage(`Pagamento de R$ ${paymentAmount.toFixed(2)} registrado com sucesso!`);
        
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
        document.getElementById('editPhotoUpload').innerHTML = `
            <svg class="w-12 h-12 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path>
            </svg>
            <p class="text-gray-400">Clique para fazer upload da foto</p>
        `;
    } else if (modal === editLoanModal) {
        document.getElementById('editLoanForm').reset();
    } else if (modal === newClientModal) {
        document.getElementById('newClientForm').reset();
        document.getElementById('photoUpload').innerHTML = `
            <svg class="w-12 h-12 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path>
            </svg>
            <p class="text-gray-400">Clique para fazer upload da foto</p>
        `;
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
    
    // Armazenar ID do empréstimo
    document.getElementById('paymentForm').dataset.loanId = loanId;
    
    showModal(paymentModal);
}

async function calculateAndShowRemainingAmount(loanId) {
    try {
        const loan = loans.find(l => l.id === loanId);
        if (!loan) return;
        
        // Calcular total com juros
        const totalWithInterest = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
        
        // Buscar pagamentos já feitos
        const { data: payments, error } = await supabase
            .from('payments')
            .select('amount')
            .eq('loan_id', loanId);
        
        if (error) throw error;
        
        // Calcular total já pago
        const totalPaid = payments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        
        // Calcular valor restante
        const remainingAmount = totalWithInterest - totalPaid;
        
        // Mostrar valor restante
        document.getElementById('paymentRemainingAmount').textContent = `R$ ${remainingAmount.toFixed(2)}`;
        
    } catch (error) {
        console.error('Erro ao calcular valor restante:', error);
        // Em caso de erro, mostrar valor total com juros
        const loan = loans.find(l => l.id === loanId);
        if (loan) {
            const totalWithInterest = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
            document.getElementById('paymentRemainingAmount').textContent = `R$ ${totalWithInterest.toFixed(2)}`;
        }
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
    
    // Contar empréstimos cancelados da tabela cancelled_loans
    let cancelledLoansCount = 0;
    try {
        const { count, error } = await supabase
            .from('cancelled_loans')
            .select('*', { count: 'exact', head: true });
        
        if (!error) {
            cancelledLoansCount = count || 0;
        }
    } catch (error) {
        console.error('Erro ao contar empréstimos cancelados:', error);
    }
    document.getElementById('cancelledLoans').textContent = cancelledLoansCount;
    
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
    document.getElementById('editClientPhoto').value = client.photo || '';
    
    // Atualizar a área de upload de foto
    if (client.photo) {
        document.getElementById('editPhotoUpload').innerHTML = `
            <div class="text-center">
                <img src="${client.photo}" alt="Foto do cliente" class="w-20 h-20 rounded-lg mx-auto mb-2 object-cover">
                <p class="text-green-400 text-sm">Foto atual</p>
            </div>
        `;
    } else {
        document.getElementById('editPhotoUpload').innerHTML = `
            <svg class="w-12 h-12 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path>
            </svg>
            <p class="text-gray-400">Clique para fazer upload da foto</p>
        `;
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
        'Cancelar'
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
                        <button class="text-blue-400 hover:text-blue-300 mr-3" onclick="editPayment('${payment.id}')">Editar</button>
                        <button class="text-red-400 hover:text-red-300" onclick="deletePayment('${payment.id}')">Excluir</button>
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
        
        // Calcular total com juros
        const totalWithInterest = parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
        
        // Buscar pagamentos já feitos
        const { data: payments, error } = await supabase
            .from('payments')
            .select('amount')
            .eq('loan_id', loanId);
        
        if (error) throw error;
        
        // Calcular total já pago
        const totalPaid = payments.reduce((sum, payment) => sum + parseFloat(payment.amount), 0);
        
        // Calcular valor restante
        const remainingAmount = totalWithInterest - totalPaid;
        
        return Math.max(0, remainingAmount); // Não pode ser negativo
        
    } catch (error) {
        console.error('Erro ao calcular valor restante:', error);
        // Em caso de erro, retornar valor total com juros
        const loan = loans.find(l => l.id === loanId);
        if (loan) {
            return parseFloat(loan.amount) + (parseFloat(loan.amount) * parseFloat(loan.interest_rate) / 100);
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

function showConfirmationModal(title, message, onConfirm, confirmButtonText = 'Confirmar') {
    document.getElementById('confirmationTitle').textContent = title;
    document.getElementById('confirmationMessage').textContent = message;
    
    // Configurar o botão de confirmação
    const confirmBtn = document.getElementById('confirmDeleteBtn');
    confirmBtn.onclick = onConfirm;
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
        
        console.log('Verificação de tabelas concluída!');
        console.log('Se alguma tabela não foi encontrada, execute o script database-setup.sql no SQL Editor do Supabase.');
        
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
                await renderOverdueTable();
                await renderPaidLoansTable();
                await renderCancelledLoansTable();
                await updateDashboard();
                await updateCharts();
            },
            'Marcar como Quitado'
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
    select.innerHTML = '<option value="">Selecione um cliente para ver o histórico</option>';
    
    clients.forEach(client => {
        const option = document.createElement('option');
        option.value = client.id;
        option.textContent = `${client.name} - ${client.cpf}`;
        select.appendChild(option);
    });
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
        
        // Mostrar mensagem de sucesso
        showSuccessMessage('Empréstimo cancelado com sucesso e movido para histórico de cancelamentos!');
        
        // Atualizar interface imediatamente
        await renderLoansTable();
        await renderOverdueTable();
        await renderCancelledLoansTable();
        await updateDashboard();
        await updateCharts();
        
    } catch (error) {
        console.error('Erro ao cancelar empréstimo:', error);
        showInfoMessage('Erro ao cancelar empréstimo: ' + error.message);
    }
}

// Função para mostrar detalhes de um empréstimo cancelado
async function showCancelledLoanDetails(cancelledLoanId) {
    try {
        const { data: cancelledLoan, error } = await supabase
            .from('cancelled_loans')
            .select(`
                *,
                clients (
                    name,
                    cpf,
                    email,
                    phone
                )
            `)
            .eq('id', cancelledLoanId)
            .single();
        
        if (error) throw error;
        
        const message = `
Detalhes do Empréstimo Cancelado:

Cliente: ${cancelledLoan.clients?.name || 'Cliente não encontrado'}
CPF: ${cancelledLoan.clients?.cpf || 'N/A'}
Valor Original: R$ ${parseFloat(cancelledLoan.original_amount).toFixed(2)}
Taxa de Juros: ${cancelledLoan.interest_rate}%
Total com Juros: R$ ${parseFloat(cancelledLoan.total_with_interest).toFixed(2)}
Data do Empréstimo: ${formatDate(cancelledLoan.loan_date)}
Data de Vencimento: ${formatDate(cancelledLoan.due_date)}
Data de Cancelamento: ${formatDate(cancelledLoan.cancellation_date)}
Motivo do Cancelamento: ${cancelledLoan.cancellation_reason}
Valor Pago Antes do Cancelamento: R$ ${parseFloat(cancelledLoan.total_paid_before_cancellation).toFixed(2)}
Valor de Reembolso: R$ ${parseFloat(cancelledLoan.refund_amount).toFixed(2)}
Taxa de Cancelamento: R$ ${parseFloat(cancelledLoan.cancellation_fee).toFixed(2)}
        `;
        
        alert(message);
        
    } catch (error) {
        console.error('Erro ao buscar detalhes do empréstimo cancelado:', error);
        showInfoMessage('Erro ao buscar detalhes: ' + error.message);
    }
}

// Função para restaurar um empréstimo cancelado
async function restoreCancelledLoan(cancelledLoanId) {
    try {
        // Buscar dados do empréstimo cancelado
        const { data: cancelledLoan, error: fetchError } = await supabase
            .from('cancelled_loans')
            .select(`
                *,
                clients (
                    name,
                    cpf,
                    email,
                    phone
                )
            `)
            .eq('id', cancelledLoanId)
            .single();
        
        if (fetchError) throw fetchError;
        
        // Mostrar confirmação
        const confirmMessage = `Deseja restaurar o empréstimo cancelado?\n\nCliente: ${cancelledLoan.clients?.name || 'Cliente não encontrado'}\nValor: R$ ${parseFloat(cancelledLoan.original_amount).toFixed(2)}\nJuros: ${cancelledLoan.interest_rate}%\n\nEsta ação irá recriar o empréstimo na tabela principal.`;
        
        if (!confirm(confirmMessage)) return;
        
        // Recriar o empréstimo na tabela loans
        const { error: insertError } = await supabase
            .from('loans')
            .insert([{
                id: cancelledLoan.loan_id, // Manter o ID original
                client_id: cancelledLoan.client_id,
                amount: cancelledLoan.original_amount,
                interest_rate: cancelledLoan.interest_rate,
                loan_date: cancelledLoan.loan_date,
                due_date: cancelledLoan.due_date,
                status: 'active', // Status ativo
                created_by: cancelledLoan.created_by,
                created_at: cancelledLoan.created_at
            }]);
        
        if (insertError) throw insertError;
        
        // Remover da tabela cancelled_loans
        const { error: deleteError } = await supabase
            .from('cancelled_loans')
            .delete()
            .eq('id', cancelledLoanId);
        
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

// Função para excluir um empréstimo cancelado permanentemente
async function deleteCancelledLoan(cancelledLoanId) {
    try {
        // Buscar dados do empréstimo cancelado
        const { data: cancelledLoan, error: fetchError } = await supabase
            .from('cancelled_loans')
            .select(`
                *,
                clients (
                    name,
                    cpf,
                    email,
                    phone
                )
            `)
            .eq('id', cancelledLoanId)
            .single();
        
        if (fetchError) throw fetchError;
        
        // Mostrar confirmação
        const confirmMessage = `ATENÇÃO: Esta ação é irreversível!\n\nDeseja excluir permanentemente o empréstimo cancelado?\n\nCliente: ${cancelledLoan.clients?.name || 'Cliente não encontrado'}\nValor: R$ ${parseFloat(cancelledLoan.original_amount).toFixed(2)}\nJuros: ${cancelledLoan.interest_rate}%\n\nTodos os dados serão perdidos para sempre.`;
        
        if (!confirm(confirmMessage)) return;
        
        // Excluir da tabela cancelled_loans
        const { error: deleteError } = await supabase
            .from('cancelled_loans')
            .delete()
            .eq('id', cancelledLoanId);
        
        if (deleteError) throw deleteError;
        
        // Atualizar interface
        await renderCancelledLoansTable();
        await updateDashboard();
        await updateCharts();
        
        showSuccessMessage('Empréstimo cancelado excluído permanentemente!');
        
    } catch (error) {
        console.error('Erro ao excluir empréstimo cancelado:', error);
        showInfoMessage('Erro ao excluir empréstimo: ' + error.message);
    }
}

// Função para mostrar detalhes de um empréstimo quitado
async function showPaidLoanDetails(paidLoanId) {
    try {
        const { data: paidLoan, error } = await supabase
            .from('paid_loans')
            .select(`
                *,
                clients (
                    name,
                    cpf,
                    email,
                    phone
                )
            `)
            .eq('id', paidLoanId)
            .single();
        
        if (error) throw error;
        
        const message = `
Detalhes do Empréstimo Quitado:

Cliente: ${paidLoan.clients?.name || 'Cliente não encontrado'}
CPF: ${paidLoan.clients?.cpf || 'N/A'}
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
            .select(`
                *,
                clients (
                    name,
                    cpf,
                    email,
                    phone
                )
            `)
            .eq('id', paidLoanId)
            .single();
        
        if (fetchError) throw fetchError;
        
        // Mostrar confirmação
        const confirmMessage = `Deseja restaurar o empréstimo quitado?\n\nCliente: ${paidLoan.clients?.name || 'Cliente não encontrado'}\nValor: R$ ${parseFloat(paidLoan.original_amount).toFixed(2)}\nJuros: ${paidLoan.interest_rate}%\n\nEsta ação irá recriar o empréstimo na tabela principal.`;
        
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
            .select(`
                *,
                clients (
                    name,
                    cpf,
                    email,
                    phone
                )
            `)
            .eq('id', paidLoanId)
            .single();
        
        if (fetchError) throw fetchError;
        
        // Mostrar confirmação
        const confirmMessage = `ATENÇÃO: Esta ação é irreversível!\n\nDeseja excluir permanentemente o empréstimo quitado?\n\nCliente: ${paidLoan.clients?.name || 'Cliente não encontrado'}\nValor: R$ ${parseFloat(paidLoan.original_amount).toFixed(2)}\nJuros: ${paidLoan.interest_rate}%\n\nTodos os dados serão perdidos para sempre.`;
        
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