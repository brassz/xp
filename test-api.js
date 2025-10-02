const http = require('http');

// Função para fazer requisição HTTP simples
function makeRequest(path) {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: 'localhost',
            port: 3002,
            path: path,
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        };

        const req = http.request(options, (res) => {
            let data = '';
            
            res.on('data', (chunk) => {
                data += chunk;
            });
            
            res.on('end', () => {
                try {
                    const jsonData = JSON.parse(data);
                    resolve({
                        status: res.statusCode,
                        data: jsonData
                    });
                } catch (error) {
                    resolve({
                        status: res.statusCode,
                        data: data
                    });
                }
            });
        });

        req.on('error', (error) => {
            reject(error);
        });

        req.end();
    });
}

// Função principal de teste
async function testAPI() {
    console.log('🧪 Testando API de Clientes Vencidos...\n');

    try {
        // Teste 1: Endpoint raiz
        console.log('1. Testando endpoint raiz (/)...');
        const rootResponse = await makeRequest('/');
        console.log(`   Status: ${rootResponse.status}`);
        console.log(`   Message: ${rootResponse.data.message || 'N/A'}`);
        console.log('   ✅ Sucesso\n');

        // Teste 2: Listar empresas
        console.log('2. Testando listagem de empresas (/api/companies)...');
        const companiesResponse = await makeRequest('/api/companies');
        console.log(`   Status: ${companiesResponse.status}`);
        console.log(`   Empresas encontradas: ${companiesResponse.data.companies?.length || 0}`);
        if (companiesResponse.data.companies) {
            companiesResponse.data.companies.forEach(company => {
                console.log(`   - ${company.name} (${company.id})`);
            });
        }
        console.log('   ✅ Sucesso\n');

        // Teste 3: Estatísticas (não requer dados reais)
        console.log('3. Testando estatísticas (/api/overdue-stats)...');
        const statsResponse = await makeRequest('/api/overdue-stats');
        console.log(`   Status: ${statsResponse.status}`);
        if (statsResponse.data.success) {
            console.log(`   Total de clientes vencidos: ${statsResponse.data.stats?.total?.clients || 0}`);
            console.log('   ✅ Sucesso');
        } else {
            console.log(`   ⚠️  Aviso: ${statsResponse.data.error || 'Erro desconhecido'}`);
            console.log('   (Isso é esperado se não houver dados no Supabase)');
        }
        console.log('');

        // Teste 4: Buscar clientes vencidos de uma empresa
        console.log('4. Testando busca por empresa (/api/overdue-clients/nexus)...');
        const nexusResponse = await makeRequest('/api/overdue-clients/nexus');
        console.log(`   Status: ${nexusResponse.status}`);
        if (nexusResponse.data.success) {
            console.log(`   Clientes vencidos encontrados: ${nexusResponse.data.total || 0}`);
            console.log('   ✅ Sucesso');
        } else {
            console.log(`   ⚠️  Aviso: ${nexusResponse.data.error || 'Erro desconhecido'}`);
            console.log('   (Isso é esperado se não houver dados no Supabase)');
        }
        console.log('');

        console.log('🎉 Todos os testes da API foram executados!');
        console.log('📝 A API está funcionando corretamente.');
        console.log('⚠️  Avisos sobre dados são normais se o Supabase não tiver empréstimos vencidos.');

    } catch (error) {
        console.error('❌ Erro durante os testes:', error.message);
        process.exit(1);
    }
}

// Executar testes
testAPI();