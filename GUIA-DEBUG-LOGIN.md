# Guia de Debug - Problema de Login

## ATUALIZAÇÃO: Melhorias Aplicadas

O sistema agora possui:
- ✅ Logs extremamente detalhados em cada etapa do login
- ✅ Prevenção de reload de página com `onsubmit="return false;"`
- ✅ Wrapper no event listener com preventDefault e stopPropagation
- ✅ Tratamento de erros melhorado com alertas informativos
- ✅ Verificação da biblioteca Supabase na inicialização

## Passo a Passo para Identificar o Problema

### 1. Abrir o Console do Navegador
- **Chrome/Edge**: Pressione F12 ou Ctrl+Shift+I
- **Firefox**: Pressione F12 ou Ctrl+Shift+K
- Clique na aba "Console"

### 2. Recarregar a Página
Pressione Ctrl+R ou F5 para recarregar completamente a página.

### 3. Verificar Logs de Inicialização
Você deve ver os seguintes logs no console:

```
=== DOM CONTENT LOADED ===
Timestamp: [data/hora]
loginPage existe? true
dashboard existe? true
loginForm existe? true
window.supabase existe? true
```

**❌ Se algum desses valores for `false`, há um problema crítico:**
- `loginPage false`: O elemento HTML com id="loginPage" não foi encontrado
- `dashboard false`: O elemento HTML com id="dashboard" não foi encontrado
- `loginForm false`: O formulário de login não foi encontrado
- `window.supabase false`: A biblioteca Supabase não foi carregada

### 4. Verificar Erros Globais
Procure por mensagens começando com:
```
=== ERRO GLOBAL CAPTURADO ===
```
ou
```
=== PROMISE REJEITADA NÃO TRATADA ===
```

Se encontrar, copie toda a mensagem de erro.

### 5. Testar Login Manual
No console do navegador, digite:
```javascript
testLogin()
```

Isso deve fazer a transição da tela de login para o dashboard. Se funcionar, o problema é na autenticação. Se não funcionar, o problema é com os elementos HTML.

### 6. Tentar Fazer Login Normal
Preencha o formulário de login e clique em "Entrar". Você deve ver:

```
=== FORMULÁRIO SUBMETIDO (teste inline) ===
handleLogin chamado
Company ID: [empresa selecionada]
Email: [seu email]
=== initializeCompany chamado ===
Company ID: [empresa]
window.supabase existe? true
```

### 7. Identificar Onde o Processo Para

#### Se você vê "handleLogin chamado" mas nada mais:
→ Problema na validação dos campos do formulário

#### Se você vê "initializeCompany chamado" mas nada mais:
→ Problema ao inicializar o Supabase ou configuração da empresa

#### Se você vê "Verificando usuário no banco de dados..." mas nada mais:
→ Problema de conexão com o banco de dados ou credenciais inválidas

#### Se você vê "Usuário encontrado" mas nada mais:
→ Problema na senha ou ao processar o login

#### Se você vê "Login concluído com sucesso!" mas a tela não muda:
→ Problema na função showDashboard()

### 8. Verificar Conectividade com Supabase
No console, digite:
```javascript
console.log('Supabase URL:', window.supabase ? 'Carregado' : 'NÃO carregado');
```

### 9. Teste de Elementos DOM
No console, digite:
```javascript
console.log('loginPage:', document.getElementById('loginPage'));
console.log('dashboard:', document.getElementById('dashboard'));
console.log('loginForm:', document.getElementById('loginForm'));
```

Todos devem retornar elementos HTML, não `null`.

## Problemas Comuns e Soluções

### Problema: "window.supabase existe? false"
**Solução**: A biblioteca Supabase não foi carregada. Verifique:
- Se o arquivo index.html tem: `<script src="https://unpkg.com/@supabase/supabase-js@2"></script>`
- Se há conexão com internet
- Se há bloqueio de scripts no navegador

### Problema: "loginForm existe? false"
**Solução**: O formulário não foi encontrado. Verifique:
- Se o arquivo index.html não foi corrompido
- Se há algum erro de sintaxe HTML impedindo o carregamento

### Problema: "Usuário não encontrado ou inativo"
**Solução**: 
- Verifique se o email está correto
- Verifique se a empresa selecionada está correta
- Verifique se o usuário existe no banco de dados da empresa

### Problema: "Senha incorreta"
**Solução**:
- Verifique se a senha está correta
- Lembre-se que as senhas são case-sensitive

### Problema: Login bem-sucedido mas tela não muda
**Solução**: Execute no console:
```javascript
testLogin()
```
Se isso funcionar, o problema é na autenticação, não na interface.

## Informações para Reportar

Se o problema persistir, por favor forneça:

1. **Navegador e Versão**: (ex: Chrome 120, Firefox 121)
2. **Logs do Console**: Copie todos os logs desde "=== DOM CONTENT LOADED ===" até o erro
3. **Empresa Selecionada**: Qual empresa você está tentando acessar?
4. **Resultado do testLogin()**: O que acontece quando executa `testLogin()` no console?
5. **Mensagens de Erro**: Qualquer mensagem de erro em vermelho no console

## Comandos Úteis de Debug

```javascript
// Ver se elementos existem
console.log('Elements:', {
    loginPage: !!document.getElementById('loginPage'),
    dashboard: !!document.getElementById('dashboard'),
    loginForm: !!document.getElementById('loginForm')
});

// Ver configuração atual
console.log('Current Company:', currentCompany);
console.log('Current User:', currentUser);

// Testar transição de tela
testLogin();

// Ver localStorage
console.log('LocalStorage:', {
    user: localStorage.getItem('nexusUser'),
    company: localStorage.getItem('selectedCompany')
});

// Limpar localStorage e recarregar
localStorage.clear();
location.reload();
```

## Última Atualização
16 de Dezembro de 2025
