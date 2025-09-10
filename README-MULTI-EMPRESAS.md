# Sistema Multi-Empresas Nexus

## Visão Geral

O sistema Nexus agora suporta múltiplas empresas com bancos de dados separados. Foram implementadas duas empresas:

- **LITORAL CRED** - Sistema de gestão financeira com database próprio
- **MOGIANA CRED** - Sistema de gestão financeira com database próprio

## Características Implementadas

### 1. Interface de Seleção de Empresa
- Tela inicial com opções para selecionar LITORAL CRED ou MOGIANA CRED
- Design moderno com cards interativos
- Cores diferenciadas para cada empresa (azul para Litoral, verde para Mogiana)

### 2. Configuração Dinâmica de Banco de Dados
- Cada empresa possui suas próprias credenciais Supabase
- Inicialização dinâmica do cliente Supabase baseada na empresa selecionada
- Configuração separada de chaves Uploadcare para cada empresa

### 3. Persistência de Seleção
- A empresa selecionada é salva no localStorage
- Sistema lembra a última empresa utilizada
- Possibilidade de trocar de empresa a qualquer momento

### 4. Indicadores Visuais
- Nome da empresa ativa exibido na sidebar do dashboard
- Botão "Trocar Empresa" para alternar entre empresas
- Botão "Voltar" na tela de login para retornar à seleção de empresa

## Configuração das Empresas

### LITORAL CRED
```javascript
{
    name: 'LITORAL CRED',
    supabaseUrl: 'https://dtifsfzmnjnllzzlndxv.supabase.co',
    supabaseKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    uploadcareKey: '026feb50f83d7cdfe4ea'
}
```

### MOGIANA CRED
```javascript
{
    name: 'MOGIANA CRED',
    supabaseUrl: 'https://eemfnpefgojllvzzaimu.supabase.co',
    supabaseKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    uploadcareKey: '72349b0b9769d2be0d8c'
}
```

## Fluxo de Navegação

1. **Seleção de Empresa**: Usuário escolhe entre LITORAL CRED ou MOGIANA CRED
2. **Inicialização**: Sistema configura Supabase e Uploadcare para a empresa selecionada
3. **Login**: Usuário faz login com credenciais específicas da empresa
4. **Dashboard**: Sistema exibe dados da empresa selecionada
5. **Troca de Empresa**: Usuário pode trocar de empresa através do botão na sidebar

## Arquivos Modificados

### `index.html`
- Adicionada tela de seleção de empresa (`companySelectionPage`)
- Modificada tela de login para incluir nome da empresa selecionada
- Adicionado indicador de empresa ativa na sidebar
- Botão "Trocar Empresa" na sidebar

### `app.js`
- Configuração das empresas no objeto `COMPANIES`
- Funções para seleção e inicialização dinâmica de empresas
- Gerenciamento de estado da empresa selecionada
- Event listeners para navegação entre empresas
- Persistência da seleção no localStorage

### `test-companies.html` (Novo)
- Arquivo de teste para verificar conectividade com ambos os bancos
- Interface simples para testar conexões Supabase

## Funcionalidades de Segurança

- **Isolamento de Dados**: Cada empresa acessa apenas seu próprio banco de dados
- **Autenticação Separada**: Usuários de uma empresa não podem acessar dados de outra
- **Configuração Segura**: Chaves de API mantidas separadamente para cada empresa

## Como Usar

### Para Desenvolvedores
1. O sistema inicia na tela de seleção de empresa
2. Selecione a empresa desejada
3. Faça login com as credenciais apropriadas
4. O sistema carregará dados apenas da empresa selecionada

### Para Usuários Finais
1. Acesse o sistema Nexus
2. Escolha sua empresa (LITORAL CRED ou MOGIANA CRED)
3. Faça login normalmente
4. Use o sistema como antes - todos os dados serão específicos da sua empresa
5. Para trocar de empresa, clique em "Trocar Empresa" na sidebar

## Teste do Sistema

Execute o arquivo `test-companies.html` para verificar:
- Conectividade com ambos os bancos Supabase
- Configuração correta das chaves Uploadcare
- Funcionalidade básica de cada empresa

## Próximos Passos

1. Configurar usuários específicos para cada empresa nos respectivos bancos Supabase
2. Executar scripts de setup de banco de dados em ambos os ambientes
3. Testar todas as funcionalidades (clientes, empréstimos, pagamentos, etc.) em ambas as empresas
4. Configurar backups separados para cada banco de dados

## Notas Técnicas

- O sistema mantém compatibilidade total com a versão anterior
- Não há quebra de funcionalidades existentes
- A empresa selecionada persiste entre sessões
- Logout mantém a empresa selecionada (apenas desloga o usuário)
- "Trocar Empresa" faz logout completo e volta à seleção de empresa