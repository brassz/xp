# API de Clientes Vencidos - Nexus Gestão Financeira

Esta API permite buscar informações sobre clientes com empréstimos vencidos do sistema Nexus Gestão Financeira.

## 🚀 Instalação e Execução

### Pré-requisitos
- Node.js 16+ instalado
- Acesso às bases de dados Supabase das empresas

### Instalação
```bash
# Instalar dependências
npm install

# Executar em modo de desenvolvimento
npm run dev

# Executar em produção
npm start
```

A API estará disponível em `http://localhost:3001`

## 📋 Endpoints Disponíveis

### 1. Informações da API
```
GET /
```
Retorna informações básicas sobre a API e endpoints disponíveis.

### 2. Listar Empresas
```
GET /api/companies
```
Retorna lista de empresas configuradas no sistema.

**Resposta:**
```json
{
  "success": true,
  "companies": [
    {
      "id": "nexus",
      "name": "NEXUS (Principal)"
    },
    {
      "id": "litoral",
      "name": "LITORAL CRED"
    },
    {
      "id": "mogiana",
      "name": "MOGIANA CRED"
    }
  ]
}
```

### 3. Buscar Todos os Clientes Vencidos
```
GET /api/overdue-clients
```
Retorna todos os clientes com empréstimos vencidos de todas as empresas.

**Resposta:**
```json
{
  "success": true,
  "total": 15,
  "data": [
    {
      "company": {
        "id": "nexus",
        "name": "NEXUS (Principal)"
      },
      "loan": {
        "id": "uuid",
        "loan_id": "uuid",
        "amount": 1000.00,
        "total_with_interest": 1150.00,
        "loan_date": "2024-01-15",
        "due_date": "2024-02-15",
        "days_overdue": 45,
        "collection_status": "pending",
        "notes": "Cliente contatado em 01/03",
        "created_at": "2024-01-15T10:00:00Z"
      },
      "client": {
        "id": "uuid",
        "name": "João da Silva",
        "cpf": "123.456.789-00",
        "email": "joao@email.com",
        "phone": "(11) 99999-9999",
        "address": "Rua das Flores, 123"
      }
    }
  ],
  "generated_at": "2024-03-01T15:30:00Z"
}
```

### 4. Buscar Clientes Vencidos por Empresa
```
GET /api/overdue-clients/:company
```
Retorna clientes vencidos de uma empresa específica.

**Parâmetros:**
- `company`: ID da empresa (`nexus`, `litoral`, ou `mogiana`)

**Exemplo:**
```
GET /api/overdue-clients/nexus
```

### 5. Estatísticas de Clientes Vencidos
```
GET /api/overdue-stats
```
Retorna estatísticas consolidadas sobre empréstimos vencidos.

**Resposta:**
```json
{
  "success": true,
  "stats": {
    "companies": {
      "nexus": {
        "name": "NEXUS (Principal)",
        "total_loans": 8,
        "total_amount": 15000.00,
        "total_with_interest": 17250.00,
        "average_days_overdue": 32
      }
    },
    "total": {
      "clients": 15,
      "amount": 45000.00,
      "total_with_interest": 51750.00,
      "average_days_overdue": 28
    }
  },
  "generated_at": "2024-03-01T15:30:00Z"
}
```

## 🔧 Configuração

### Variáveis de Ambiente
Você pode configurar as URLs e chaves do Supabase através de variáveis de ambiente:

```bash
# Empresa 1 - NEXUS
NEXT_PUBLIC_SUPABASE_URL_EMPRESA1=sua_url_supabase
NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA1=sua_chave_supabase

# Empresa 2 - LITORAL CRED
NEXT_PUBLIC_SUPABASE_URL_EMPRESA2=sua_url_supabase
NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA2=sua_chave_supabase

# Empresa 3 - MOGIANA CRED
NEXT_PUBLIC_SUPABASE_URL_EMPRESA3=sua_url_supabase
NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA3=sua_chave_supabase

# Porta do servidor (opcional, padrão: 3001)
PORT=3001
```

## 📊 Estrutura dos Dados

### Cliente Vencido
Cada cliente vencido retornado pela API contém:

- **company**: Informações da empresa
- **loan**: Detalhes do empréstimo vencido
- **client**: Informações do cliente

### Status de Cobrança
Os possíveis valores para `collection_status` são:
- `pending`: Cobrança pendente
- `contacted`: Cliente contatado
- `negotiating`: Em negociação
- `legal`: Processo jurídico

## 🔒 Segurança

- A API utiliza as chaves públicas (anon) do Supabase
- Implementa CORS para permitir requisições de diferentes origens
- Trata erros de forma segura sem expor informações sensíveis

## 🚀 Deploy

### Deploy Local
```bash
npm start
```

### Deploy em Servidor
1. Configure as variáveis de ambiente
2. Execute `npm install --production`
3. Execute `npm start`
4. Configure um proxy reverso (nginx) se necessário

## 📝 Exemplos de Uso

### JavaScript/Fetch
```javascript
// Buscar todos os clientes vencidos
const response = await fetch('http://localhost:3001/api/overdue-clients');
const data = await response.json();

console.log(`Total de clientes vencidos: ${data.total}`);
data.data.forEach(item => {
  console.log(`${item.client.name} - ${item.loan.days_overdue} dias em atraso`);
});
```

### Python/Requests
```python
import requests

# Buscar clientes vencidos de uma empresa específica
response = requests.get('http://localhost:3001/api/overdue-clients/nexus')
data = response.json()

for item in data['data']:
    print(f"{item['client']['name']} - R$ {item['loan']['total_with_interest']}")
```

### cURL
```bash
# Buscar estatísticas
curl -X GET http://localhost:3001/api/overdue-stats
```

## 🐛 Tratamento de Erros

A API retorna erros no formato:
```json
{
  "success": false,
  "error": "Descrição do erro",
  "message": "Detalhes técnicos (quando disponível)"
}
```

Códigos de status HTTP:
- `200`: Sucesso
- `404`: Recurso não encontrado
- `500`: Erro interno do servidor

## 📞 Suporte

Para dúvidas ou problemas com a API, consulte os logs do servidor ou entre em contato com a equipe de desenvolvimento.