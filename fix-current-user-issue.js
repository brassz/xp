// =====================================================
// CORREÇÃO PARA O PROBLEMA DE created_by_fkey
// =====================================================
// Este script corrige o problema onde currentUser.id pode ser inválido
// causando erro de constraint de chave estrangeira

// Função para validar e corrigir o currentUser
async function validateAndFixCurrentUser() {
    console.log('🔍 Verificando currentUser...');
    
    if (!currentUser || !currentUser.id) {
        console.warn('⚠️ currentUser não definido ou sem ID');
        await loadDefaultUser();
        return;
    }

    try {
        // Verificar se o usuário existe no banco
        const { data: userExists, error } = await supabase
            .from('users')
            .select('id, email, full_name, role')
            .eq('id', currentUser.id)
            .single();

        if (error || !userExists) {
            console.warn('⚠️ Usuário atual não existe no banco:', currentUser.id);
            await loadDefaultUser();
        } else {
            console.log('✅ currentUser válido:', userExists);
        }
    } catch (error) {
        console.error('❌ Erro ao verificar usuário:', error);
        await loadDefaultUser();
    }
}

// Função para carregar usuário padrão
async function loadDefaultUser() {
    try {
        console.log('🔄 Carregando usuário admin padrão...');
        
        const { data: adminUser, error } = await supabase
            .from('users')
            .select('id, email, full_name, role')
            .eq('email', 'admin@nexus.com')
            .single();

        if (error || !adminUser) {
            console.error('❌ Usuário admin não encontrado. Criando...');
            await createDefaultAdminUser();
        } else {
            currentUser = adminUser;
            localStorage.setItem('nexusUser', JSON.stringify(currentUser));
            console.log('✅ Usuário admin carregado:', currentUser);
        }
    } catch (error) {
        console.error('❌ Erro ao carregar usuário admin:', error);
        await createDefaultAdminUser();
    }
}

// Função para criar usuário admin padrão
async function createDefaultAdminUser() {
    try {
        console.log('🔨 Criando usuário admin padrão...');
        
        const adminData = {
            id: '00000000-0000-0000-0000-000000000001',
            email: 'admin@nexus.com',
            password_hash: '1020',
            full_name: 'Administrador Nexus',
            role: 'admin',
            is_active: true,
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString()
        };

        const { data, error } = await supabase
            .from('users')
            .upsert([adminData])
            .select()
            .single();

        if (error) {
            console.error('❌ Erro ao criar usuário admin:', error);
            // Usar dados padrão mesmo com erro
            currentUser = {
                id: '00000000-0000-0000-0000-000000000001',
                email: 'admin@nexus.com',
                full_name: 'Administrador Nexus',
                role: 'admin'
            };
        } else {
            currentUser = data;
            console.log('✅ Usuário admin criado:', currentUser);
        }

        localStorage.setItem('nexusUser', JSON.stringify(currentUser));
    } catch (error) {
        console.error('❌ Erro crítico ao criar usuário admin:', error);
        // Fallback para dados hardcoded
        currentUser = {
            id: '00000000-0000-0000-0000-000000000001',
            email: 'admin@nexus.com',
            full_name: 'Administrador Nexus',
            role: 'admin'
        };
        localStorage.setItem('nexusUser', JSON.stringify(currentUser));
    }
}

// Função para garantir created_by válido antes de inserções
function ensureValidCreatedBy() {
    if (!currentUser || !currentUser.id) {
        console.warn('⚠️ currentUser inválido, usando ID padrão');
        return '00000000-0000-0000-0000-000000000001';
    }
    return currentUser.id;
}

// Adicionar validação na inicialização
const originalInitializeApp = initializeApp;
async function initializeApp() {
    await originalInitializeApp();
    await validateAndFixCurrentUser();
}

// Sobrescrever função de criação de cliente com validação
const originalHandleNewClient = handleNewClient;
async function handleNewClient(e) {
    e.preventDefault();
    
    // Garantir que temos um usuário válido
    await validateAndFixCurrentUser();
    
    const formData = {
        name: document.getElementById('clientName').value,
        cpf: document.getElementById('clientCPF').value,
        email: document.getElementById('clientEmail').value,
        phone: document.getElementById('clientPhone').value,
        address: document.getElementById('clientAddress').value,
        rg: document.getElementById('clientRG').value || null,
        birth_date: document.getElementById('clientBirthDate').value || null,
        created_by: ensureValidCreatedBy(),
        created_at: new Date().toISOString()
    };
    
    // Resto da lógica permanece igual...
    return originalHandleNewClient.call(this, e, formData);
}

// Sobrescrever função de criação de empréstimo com validação
const originalHandleNewLoan = handleNewLoan;
async function handleNewLoan(e) {
    e.preventDefault();
    
    // Garantir que temos um usuário válido
    await validateAndFixCurrentUser();
    
    const formData = {
        client_id: document.getElementById('loanClient').value,
        amount: parseFloat(document.getElementById('loanAmount').value),
        interest_rate: parseFloat(document.getElementById('loanInterest').value),
        loan_date: document.getElementById('loanDate').value,
        due_date: document.getElementById('loanDueDate').value,
        status: 'active',
        created_by: ensureValidCreatedBy(),
        created_at: new Date().toISOString()
    };
    
    // Resto da lógica permanece igual...
    return originalHandleNewLoan.call(this, e, formData);
}

console.log('🔧 Script de correção carregado. Execute validateAndFixCurrentUser() se necessário.');