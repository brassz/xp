# Sistema Multi-Empresas - Nexus

## Implementação Concluída

Foi implementado um sistema de seleção de empresas no Nexus que permite gerenciar múltiplas empresas com bancos de dados separados.

### Empresas Configuradas

1. **NEXUS (Principal)**
   - Supabase URL: `https://mhtxyxizfnxupwmilith.supabase.co`
   - Uploadcare Key: `5bb6bf6b98f6d36060dc`

2. **LITORAL CRED**
   - Supabase URL: `https://dtifsfzmnjnllzzlndxv.supabase.co`
   - Uploadcare Key: `026feb50f83d7cdfe4ea`

3. **MOGIANA CRED**
   - Supabase URL: `https://eemfnpefgojllvzzaimu.supabase.co`
   - Uploadcare Key: `72349b0b9769d2be0d8c`

4. **ERECHIM**
   - Supabase URL: `https://adjrvtupfshdhwjvhmgj.supabase.co`
   - Uploadcare Key: `CONFIGURE_UPLOADCARE_KEY_HERE` (pendente configuração)

5. **IMPERATRIZ CRED**
   - Supabase URL: `https://eppzphzwwpvpoocospxy.supabase.co`
   - Uploadcare Key: `CONFIGURE_UPLOADCARE_KEY_HERE` (pendente configuração)

### Funcionalidades Implementadas

#### 1. Interface de Seleção de Empresa
- Adicionado dropdown de seleção de empresa na tela de login
- Campo obrigatório antes de fazer login
- Interface integrada ao design existente

#### 2. Configuração Multi-Database
- Configuração centralizada das empresas em `COMPANIES_CONFIG`
- Cada empresa tem suas próprias credenciais do Supabase e Uploadcare
- Troca dinâmica de banco de dados baseada na empresa selecionada

#### 3. Gerenciamento de Estado
- Variável global `currentCompany` para rastrear empresa ativa
- Função `initializeCompany()` para configurar empresa selecionada
- Função `getCurrentCompanyConfig()` para obter configuração atual

#### 4. Persistência de Sessão
- Empresa selecionada salva no localStorage
- Restauração automática da empresa ao recarregar a página
- Limpeza adequada ao fazer logout

#### 5. Indicador Visual
- Badge no header do dashboard mostrando empresa ativa
- Feedback visual claro da empresa selecionada

### Fluxo de Funcionamento

1. **Login**: Usuário seleciona empresa e faz login
2. **Inicialização**: Sistema inicializa conexão com banco da empresa
3. **Operação**: Todas as operações são realizadas no banco da empresa selecionada
4. **Persistência**: Empresa fica salva para próximas sessões
5. **Logout**: Limpeza completa do estado e redirecionamento para login

### Alterações Realizadas

#### `index.html`
- Adicionado dropdown de seleção de empresa no formulário de login
- Adicionado indicador visual da empresa no header do dashboard

#### `app.js`
- Substituída configuração única do Supabase por configuração multi-empresa
- Implementadas funções para gerenciamento de empresas
- Atualizado fluxo de login para incluir seleção de empresa
- Modificado `initializeApp()` para restaurar empresa salva
- Atualizado `showDashboard()` para exibir empresa ativa
- Modificado `handleLogout()` para limpeza completa

### Segurança e Isolamento

- **Isolamento Completo**: Cada empresa opera em seu próprio banco de dados Supabase
- **Credenciais Separadas**: Cada empresa tem suas próprias chaves de API
- **Uploadcare Isolado**: Arquivos de cada empresa ficam em contas separadas
- **Sessão Segura**: Estado da empresa é validado a cada inicialização

### Como Usar

1. Acesse a aplicação
2. Selecione a empresa desejada no dropdown
3. Faça login normalmente
4. Todas as operações serão realizadas no contexto da empresa selecionada
5. A empresa ficará selecionada até o logout

### Configuração de Variáveis de Ambiente

O sistema agora utiliza variáveis de ambiente para maior segurança e flexibilidade:

#### Variáveis Necessárias no Vercel:

```bash
# Empresa 1 - NEXUS (Principal)
NEXT_PUBLIC_SUPABASE_URL_EMPRESA1=https://mhtxyxizfnxupwmilith.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA1=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA1=5bb6bf6b98f6d36060dc

# Empresa 2 - LITORAL CRED
NEXT_PUBLIC_SUPABASE_URL_EMPRESA2=https://dtifsfzmnjnllzzlndxv.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA2=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA2=026feb50f83d7cdfe4ea

# Empresa 3 - MOGIANA CRED
NEXT_PUBLIC_SUPABASE_URL_EMPRESA3=https://eemfnpefgojllvzzaimu.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA3=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ5...
NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA3=72349b0b9769d2be0d8c

# Empresa 4 - ERECHIM
NEXT_PUBLIC_SUPABASE_URL_EMPRESA4=https://adjrvtupfshdhwjvhmgj.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA4=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA4=CONFIGURE_UPLOADCARE_KEY_HERE

# Empresa 5 - IMPERATRIZ CRED
NEXT_PUBLIC_SUPABASE_URL_EMPRESA5=https://eppzphzwwpvpoocospxy.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA5=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVwcHpwaHp3d3B2cG9vY29zcHh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0NTc1MDEsImV4cCI6MjA3NTAzMzUwMX0.QwiFlP-h3sk0-pDBmrOMkQmhWZtewD2wDMPYbXAATXI
NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA5=CONFIGURE_UPLOADCARE_KEY_HERE
```

#### Configuração no Vercel:

1. Acesse o painel do Vercel
2. Vá em **Settings > Environment Variables**
3. Adicione cada variável acima
4. Marque para todos os ambientes (Production, Preview, Development)
5. Faça redeploy da aplicação

#### Desenvolvimento Local:

1. Copie `.env.example` para `.env.local`
2. Preencha com os valores corretos
3. O arquivo `.env.local` já está no `.gitignore` por segurança

### Observações Técnicas

- Configurações das empresas agora usam variáveis de ambiente
- Fallback para valores hardcoded em desenvolvimento local
- Cada empresa mantém seus próprios dados isolados
- A troca de empresa requer novo login
- Sistema compatível com todas as funcionalidades existentes do Nexus

### Próximos Passos (Opcionais)

- Implementar permissões por empresa
- Adicionar logs de auditoria por empresa
- Criar painel administrativo para gerenciar empresas
- Implementar backup automático por empresa