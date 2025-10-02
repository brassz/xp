const express = require('express');
const cors = require('cors');
const { createClient } = require('@supabase/supabase-js');

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Configurações do Supabase para cada empresa
const COMPANIES_CONFIG = {
    nexus: {
        name: 'NEXUS (Principal)',
        supabase: {
            url: process.env.NEXT_PUBLIC_SUPABASE_URL_EMPRESA1 || 'https://mhtxyxizfnxupwmilith.supabase.co',
            key: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA1 || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1odHh5eGl6Zm54dXB3bWlsaXRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYxMzIzMDYsImV4cCI6MjA3MTcwODMwNn0.s1Y9kk2Va5EMcwAEGQmhTxo70Zv0o9oR6vrJixwEkWI'
        }
    },
    litoral: {
        name: 'LITORAL CRED',
        supabase: {
            url: process.env.NEXT_PUBLIC_SUPABASE_URL_EMPRESA2 || 'https://dtifsfzmnjnllzzlndxv.supabase.co',
            key: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA2 || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR0aWZzZnptbmpubGx6emxuZHh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxNjQ5NzUsImV4cCI6MjA3Mjc0MDk3NX0.V40szmRzuvni2J4GK5-qZUR7nBWeUy7ikYy9B7iHxkA'
        }
    },
    mogiana: {
        name: 'MOGIANA CRED',
        supabase: {
            url: process.env.NEXT_PUBLIC_SUPABASE_URL_EMPRESA3 || 'https://eemfnpefgojllvzzaimu.supabase.co',
            key: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA3 || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVlbWZucGVmZ29qbGx2enphaW11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxNjUyNjIsImV4cCI6MjA3Mjc0MTI2Mn0.PKJJ-scljbF3CFrFtMz6Rq03lVt36NQxooEH3kOcr5Y'
        }
    }
};

// Função para criar cliente Supabase
function createSupabaseClient(companyId) {
    const config = COMPANIES_CONFIG[companyId];
    if (!config) {
        throw new Error(`Empresa ${companyId} não encontrada`);
    }
    return createClient(config.supabase.url, config.supabase.key);
}

// Rota de teste
app.get('/', (req, res) => {
    res.json({
        message: 'API de Clientes Vencidos - Nexus Gestão Financeira',
        version: '1.0.0',
        endpoints: {
            '/api/overdue-clients': 'GET - Lista todos os clientes com empréstimos vencidos',
            '/api/overdue-clients/:company': 'GET - Lista clientes vencidos de uma empresa específica',
            '/api/companies': 'GET - Lista empresas disponíveis'
        }
    });
});

// Rota para listar empresas disponíveis
app.get('/api/companies', (req, res) => {
    const companies = Object.keys(COMPANIES_CONFIG).map(key => ({
        id: key,
        name: COMPANIES_CONFIG[key].name
    }));
    
    res.json({
        success: true,
        companies
    });
});

// Rota para buscar clientes vencidos de todas as empresas
app.get('/api/overdue-clients', async (req, res) => {
    try {
        const allOverdueClients = [];
        
        // Buscar de todas as empresas
        for (const [companyId, config] of Object.entries(COMPANIES_CONFIG)) {
            try {
                const supabase = createSupabaseClient(companyId);
                
                // Query para buscar clientes com empréstimos vencidos
                const { data: overdueLoans, error } = await supabase
                    .from('overdue_loans')
                    .select(`
                        *,
                        clients (
                            id,
                            name,
                            cpf,
                            email,
                            phone,
                            address
                        )
                    `)
                    .order('days_overdue', { ascending: false });

                if (error) {
                    console.error(`Erro ao buscar dados da empresa ${companyId}:`, error);
                    continue;
                }

                // Processar dados e adicionar informação da empresa
                const processedData = overdueLoans?.map(loan => ({
                    company: {
                        id: companyId,
                        name: config.name
                    },
                    loan: {
                        id: loan.id,
                        loan_id: loan.loan_id,
                        amount: loan.amount,
                        total_with_interest: loan.total_with_interest,
                        loan_date: loan.loan_date,
                        due_date: loan.due_date,
                        days_overdue: loan.days_overdue,
                        collection_status: loan.collection_status,
                        notes: loan.notes,
                        created_at: loan.created_at
                    },
                    client: loan.clients
                })) || [];

                allOverdueClients.push(...processedData);
            } catch (companyError) {
                console.error(`Erro ao processar empresa ${companyId}:`, companyError);
            }
        }

        // Ordenar por dias de atraso (maior primeiro)
        allOverdueClients.sort((a, b) => b.loan.days_overdue - a.loan.days_overdue);

        res.json({
            success: true,
            total: allOverdueClients.length,
            data: allOverdueClients,
            generated_at: new Date().toISOString()
        });

    } catch (error) {
        console.error('Erro ao buscar clientes vencidos:', error);
        res.status(500).json({
            success: false,
            error: 'Erro interno do servidor',
            message: error.message
        });
    }
});

// Rota para buscar clientes vencidos de uma empresa específica
app.get('/api/overdue-clients/:company', async (req, res) => {
    try {
        const { company } = req.params;
        
        if (!COMPANIES_CONFIG[company]) {
            return res.status(404).json({
                success: false,
                error: 'Empresa não encontrada',
                available_companies: Object.keys(COMPANIES_CONFIG)
            });
        }

        const supabase = createSupabaseClient(company);
        const config = COMPANIES_CONFIG[company];

        // Query para buscar clientes com empréstimos vencidos
        const { data: overdueLoans, error } = await supabase
            .from('overdue_loans')
            .select(`
                *,
                clients (
                    id,
                    name,
                    cpf,
                    email,
                    phone,
                    address
                )
            `)
            .order('days_overdue', { ascending: false });

        if (error) {
            throw error;
        }

        // Processar dados
        const processedData = overdueLoans?.map(loan => ({
            company: {
                id: company,
                name: config.name
            },
            loan: {
                id: loan.id,
                loan_id: loan.loan_id,
                amount: loan.amount,
                total_with_interest: loan.total_with_interest,
                loan_date: loan.loan_date,
                due_date: loan.due_date,
                days_overdue: loan.days_overdue,
                collection_status: loan.collection_status,
                notes: loan.notes,
                created_at: loan.created_at
            },
            client: loan.clients
        })) || [];

        res.json({
            success: true,
            company: {
                id: company,
                name: config.name
            },
            total: processedData.length,
            data: processedData,
            generated_at: new Date().toISOString()
        });

    } catch (error) {
        console.error('Erro ao buscar clientes vencidos:', error);
        res.status(500).json({
            success: false,
            error: 'Erro interno do servidor',
            message: error.message
        });
    }
});

// Rota para buscar estatísticas de clientes vencidos
app.get('/api/overdue-stats', async (req, res) => {
    try {
        const stats = {
            companies: {},
            total: {
                clients: 0,
                amount: 0,
                total_with_interest: 0,
                average_days_overdue: 0
            }
        };

        let totalDaysOverdue = 0;
        let totalLoans = 0;

        // Buscar estatísticas de todas as empresas
        for (const [companyId, config] of Object.entries(COMPANIES_CONFIG)) {
            try {
                const supabase = createSupabaseClient(companyId);
                
                const { data: overdueLoans, error } = await supabase
                    .from('overdue_loans')
                    .select('amount, total_with_interest, days_overdue');

                if (error) {
                    console.error(`Erro ao buscar estatísticas da empresa ${companyId}:`, error);
                    continue;
                }

                const companyStats = {
                    name: config.name,
                    total_loans: overdueLoans?.length || 0,
                    total_amount: overdueLoans?.reduce((sum, loan) => sum + parseFloat(loan.amount || 0), 0) || 0,
                    total_with_interest: overdueLoans?.reduce((sum, loan) => sum + parseFloat(loan.total_with_interest || 0), 0) || 0,
                    average_days_overdue: overdueLoans?.length > 0 
                        ? Math.round(overdueLoans.reduce((sum, loan) => sum + (loan.days_overdue || 0), 0) / overdueLoans.length)
                        : 0
                };

                stats.companies[companyId] = companyStats;

                // Somar para totais gerais
                stats.total.clients += companyStats.total_loans;
                stats.total.amount += companyStats.total_amount;
                stats.total.total_with_interest += companyStats.total_with_interest;
                totalDaysOverdue += overdueLoans?.reduce((sum, loan) => sum + (loan.days_overdue || 0), 0) || 0;
                totalLoans += overdueLoans?.length || 0;

            } catch (companyError) {
                console.error(`Erro ao processar estatísticas da empresa ${companyId}:`, companyError);
            }
        }

        // Calcular média geral de dias em atraso
        stats.total.average_days_overdue = totalLoans > 0 ? Math.round(totalDaysOverdue / totalLoans) : 0;

        res.json({
            success: true,
            stats,
            generated_at: new Date().toISOString()
        });

    } catch (error) {
        console.error('Erro ao buscar estatísticas:', error);
        res.status(500).json({
            success: false,
            error: 'Erro interno do servidor',
            message: error.message
        });
    }
});

// Middleware de tratamento de erros
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        success: false,
        error: 'Erro interno do servidor'
    });
});

// Iniciar servidor
app.listen(PORT, () => {
    console.log(`🚀 API de Clientes Vencidos rodando na porta ${PORT}`);
    console.log(`📊 Acesse http://localhost:${PORT} para ver os endpoints disponíveis`);
    console.log(`🏢 Empresas configuradas: ${Object.keys(COMPANIES_CONFIG).join(', ')}`);
});

module.exports = app;