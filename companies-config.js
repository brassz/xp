// =====================================================
// CONFIGURAÇÃO DE EMPRESAS - SISTEMA NEXUS
// =====================================================

const COMPANIES_CONFIG = {
    nexus: {
        id: 'nexus',
        name: 'NEXUS GESTÃO FINANCEIRA',
        logo: 'assets/images/nexus-logo-circular.png',
        supabase: {
            url: 'https://mhtxyxizfnxupwmilith.supabase.co',
            anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1odHh5eGl6Zm54dXB3bWlsaXRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYxMzIzMDYsImV4cCI6MjA3MTcwODMwNn0.s1Y9kk2Va5EMcwAEGQmhTxo70Zv0o9oR6vrJixwEkWI'
        },
        uploadcare: {
            publicKey: '026feb50f83d7cdfe4ea' // Chave padrão do Nexus
        },
        theme: {
            primaryColor: '#3B82F6',
            secondaryColor: '#1E40AF',
            accentColor: '#F59E0B'
        }
    },
    litoral: {
        id: 'litoral',
        name: 'LITORAL CRED',
        logo: 'assets/images/nexus-logo-circular.png', // Pode ser alterado para logo específico
        supabase: {
            url: 'https://dtifsfzmnjnllzzlndxv.supabase.co',
            anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR0aWZzZnptbmpubGx6emxuZHh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxNjQ5NzUsImV4cCI6MjA3Mjc0MDk3NX0.V40szmRzuvni2J4GK5-qZUR7nBWeUy7ikYy9B7iHxkA'
        },
        uploadcare: {
            publicKey: '026feb50f83d7cdfe4ea'
        },
        theme: {
            primaryColor: '#059669',
            secondaryColor: '#047857',
            accentColor: '#10B981'
        }
    },
    mogiana: {
        id: 'mogiana',
        name: 'MOGIANA CRED',
        logo: 'assets/images/nexus-logo-circular.png', // Pode ser alterado para logo específico
        supabase: {
            url: 'https://eemfnpefgojllvzzaimu.supabase.co',
            anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVlbWZucGVmZ29qbGx2enphaW11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxNjUyNjIsImV4cCI6MjA3Mjc0MTI2Mn0.PKJJ-scljbF3CFrFtMz6Rq03lVt36NQxooEH3kOcr5Y'
        },
        uploadcare: {
            publicKey: '72349b0b9769d2be0d8c'
        },
        theme: {
            primaryColor: '#DC2626',
            secondaryColor: '#B91C1C',
            accentColor: '#EF4444'
        }
    }
};

// Empresa padrão
const DEFAULT_COMPANY = 'nexus';

// Função para obter configuração da empresa atual
function getCurrentCompanyConfig() {
    const selectedCompany = localStorage.getItem('selectedCompany') || DEFAULT_COMPANY;
    return COMPANIES_CONFIG[selectedCompany] || COMPANIES_CONFIG[DEFAULT_COMPANY];
}

// Função para definir empresa atual
function setCurrentCompany(companyId) {
    if (COMPANIES_CONFIG[companyId]) {
        localStorage.setItem('selectedCompany', companyId);
        return true;
    }
    return false;
}

// Função para obter lista de empresas
function getAllCompanies() {
    return Object.values(COMPANIES_CONFIG);
}

// Função para obter empresa atual
function getCurrentCompanyId() {
    return localStorage.getItem('selectedCompany') || DEFAULT_COMPANY;
}