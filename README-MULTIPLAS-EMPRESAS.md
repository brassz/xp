# Sistema de Múltiplas Empresas - Nexus

## Visão Geral

O sistema Nexus foi expandido para suportar múltiplas empresas com bancos de dados separados. Agora você pode gerenciar três empresas diferentes:

- **LITORAL CRED** - Gestão Financeira Litoral
- **MOGIANA CRED** - Gestão Financeira Mogiana  
- **NEXUS** - Sistema Original

## Características

### 🏢 Seleção de Empresa
- Tela inicial com seleção visual de empresa
- Cada empresa tem sua própria cor e identidade visual
- Seleção salva automaticamente no navegador

### 🗄️ Bancos de Dados Separados
- Cada empresa possui seu próprio banco de dados Supabase
- Dados completamente isolados entre empresas
- Configurações independentes de Uploadcare

### 🔐 Autenticação por Empresa
- Login independente para cada empresa
- Sessões separadas por empresa
- Possibilidade de trocar de empresa sem fazer logout completo

## Configurações das Empresas

### LITORAL CRED
- **Supabase URL**: `https://dtifsfzmnjnllzzlndxv.supabase.co`
- **Uploadcare Key**: `026feb50f83d7cdfe4ea`
- **Cor**: Azul (`#3b82f6`)

### MOGIANA CRED
- **Supabase URL**: `https://eemfnpefgojllvzzaimu.supabase.co`
- **Uploadcare Key**: `72349b0b9769d2be0d8c`
- **Cor**: Verde (`#10b981`)

### NEXUS (Original)
- **Supabase URL**: `https://mhtxyxizfnxupwmilith.supabase.co`
- **Uploadcare Key**: `5bb6bf6b98f6d36060dc`
- **Cor**: Roxo (`#8b5cf6`)

## Como Usar

### 1. Primeira Utilização
1. Acesse o sistema
2. Selecione a empresa desejada na tela inicial
3. Faça login com suas credenciais da empresa selecionada

### 2. Trocar de Empresa
1. No dashboard, clique em "Trocar Empresa" no menu lateral
2. Selecione a nova empresa
3. Faça login com as credenciais da nova empresa

### 3. Indicador Visual
- No header do dashboard, você verá o nome da empresa atual
- A cor do indicador corresponde à cor da empresa selecionada

## Estrutura Técnica

### Arquivos Modificados
- `app.js` - Lógica de gerenciamento de empresas
- `index.html` - Interface do seletor de empresas

### Principais Funções Adicionadas
- `initializeCompany(companyId)` - Inicializa uma empresa específica
- `showCompanySelector()` - Exibe o seletor de empresas
- `handleCompanySelection(companyId)` - Processa seleção de empresa
- `resetToCompanySelector()` - Volta para seleção de empresa
- `updateCompanyIndicator(company)` - Atualiza indicador visual

### Armazenamento Local
- `selectedCompany` - Empresa atualmente selecionada
- `nexusUser` - Usuário logado (específico por empresa)

## Segurança

- Cada empresa possui chaves de API separadas
- Dados não são compartilhados entre empresas
- Autenticação independente por empresa
- Sessões isoladas

## Manutenção

Para adicionar uma nova empresa:
1. Adicione a configuração no objeto `COMPANIES` em `app.js`
2. Inclua o cartão da empresa no HTML do seletor
3. Configure o banco Supabase e Uploadcare para a nova empresa

## Troubleshooting

### Problema: "Sistema não inicializado"
- **Solução**: Selecione uma empresa na tela inicial

### Problema: Dados não carregam
- **Solução**: Verifique se as credenciais da empresa estão corretas

### Problema: Upload de arquivos não funciona
- **Solução**: Verifique a configuração do Uploadcare para a empresa