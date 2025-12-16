# Instruções de Debug Detalhado

## 🚨 PROBLEMA: Sistema não abre após login

## Passo 1: Limpar COMPLETAMENTE o Cache

### Opção A: Hard Refresh
1. Abra o site
2. Pressione `Ctrl + Shift + Delete` (Windows) ou `Cmd + Shift + Delete` (Mac)
3. Marque "Imagens e arquivos em cache"
4. Clique em "Limpar dados"
5. Feche e reabra o navegador

### Opção B: Modo Anônimo
1. Abra uma janela anônima/privada:
   - Chrome/Edge: `Ctrl + Shift + N`
   - Firefox: `Ctrl + Shift + P`
   - Safari: `Cmd + Shift + N`
2. Acesse o site na janela anônima

## Passo 2: Abrir o Console do Desenvolvedor

1. Pressione `F12` ou `Ctrl + Shift + I`
2. Vá para a aba **"Console"**
3. **MANTENHA O CONSOLE ABERTO** durante todo o processo

## Passo 3: Testar com a Página de Debug

1. Abra o arquivo: `TESTE-DEBUG-LOGIN.html`
2. Clique nos botões de teste:
   - "Verificar Elementos" - deve mostrar todos como `true`
   - "Testar showDashboard()" - deve esconder login e mostrar dashboard
   - "Testar showLogin()" - deve mostrar login e esconder dashboard

Se estes testes funcionarem, o problema está no arquivo principal.

## Passo 4: Testar o Sistema Principal

1. Abra o `index.html` principal
2. Aguarde carregar completamente
3. Observe o console - você DEVE ver:

```
DOM totalmente carregado
Elementos DOM inicializados: {...}
✓ Login form listener adicionado
✓ Logout button listener adicionado
✓ N navigation links configurados
Configurando event listeners...
setupEventListeners concluído com sucesso
Iniciando initializeApp...
Iniciando setupUploadcare...
showLogin called
loginPage element: [HTMLDivElement]
dashboard element: [HTMLDivElement]
Login page mostrada com sucesso
```

## Passo 5: Fazer Login

1. Selecione uma empresa
2. Digite email e senha
3. Clique em "Entrar"
4. Observe o console - você DEVE ver:

```
Iniciando processo de login...
Empresa inicializada: [nome]
Buscando usuário no banco de dados...
Usuário encontrado: [email]
✓ Login bem-sucedido! Usuário: [email]
✓ Usuário salvo no localStorage
>>> Chamando showDashboard()...
showDashboard called
loginPage element: [HTMLDivElement]
dashboard element: [HTMLDivElement]
Dashboard mostrado com sucesso
>>> showDashboard() retornou
>>> Iniciando loadData()...
```

## ❌ Se NÃO Aparecer "DOM totalmente carregado"

O script não está sendo carregado corretamente. Verifique:

1. O arquivo `app.js` existe na mesma pasta que o `index.html`?
2. O servidor está rodando corretamente?
3. Há erros de rede no console (aba Network)?

## ❌ Se Aparecer "Elementos essenciais do DOM não foram encontrados"

O HTML está com problema. Verifique:

1. Os elementos com IDs `loginPage`, `dashboard`, `loginForm`, `logoutBtn` existem no HTML?
2. Use a aba "Elements" do DevTools para procurar por estes IDs
3. Certifique-se de que não há duplicação de IDs

## ❌ Se o Login Der Erro Antes de "showDashboard"

Problema com banco de dados. Verifique:

1. A mensagem de erro exata
2. Se há conexão com internet
3. Se as credenciais do Supabase estão corretas
4. Se o usuário existe no banco de dados

## ❌ Se "showDashboard called" Aparecer Mas o Dashboard Não Abrir

Este é o problema atual. Verifique no console:

1. Depois de "showDashboard called", aparece algum erro?
2. Aparece "Dashboard mostrado com sucesso"?
3. Se não aparecer, qual é a última mensagem?

### Teste Manual no Console

Abra o console e digite:

```javascript
// Verificar elementos
console.log('loginPage:', document.getElementById('loginPage'));
console.log('dashboard:', document.getElementById('dashboard'));

// Verificar classes
console.log('loginPage classes:', document.getElementById('loginPage').className);
console.log('dashboard classes:', document.getElementById('dashboard').className);

// Testar manualmente
document.getElementById('loginPage').classList.add('hidden');
document.getElementById('dashboard').classList.remove('hidden');
```

Se depois do último comando o dashboard aparecer, então o problema está na função `showDashboard()`.

## 📋 Informações Necessárias para Reportar

Se o problema persistir, copie e envie:

1. **Todos os logs do console** desde o carregamento da página até o erro
2. **Mensagens de erro** (se houver) - em vermelho no console
3. **Resultado dos testes** manuais acima
4. **Navegador e versão** (Chrome 120, Firefox 121, etc.)
5. **Sistema Operacional** (Windows 11, macOS, Linux, etc.)

## 🔍 Verificações Adicionais

### Verificar se o CSS está bloqueando

No console, digite:

```javascript
const dashboard = document.getElementById('dashboard');
console.log('Display:', window.getComputedStyle(dashboard).display);
console.log('Visibility:', window.getComputedStyle(dashboard).visibility);
console.log('Opacity:', window.getComputedStyle(dashboard).opacity);
```

### Verificar se há JavaScript bloqueando

```javascript
console.log('currentUser:', currentUser);
console.log('supabase:', supabase);
console.log('window.appJsLoaded:', window.appJsLoaded);
```

### Forçar mostrar dashboard

```javascript
const loginPage = document.getElementById('loginPage');
const dashboard = document.getElementById('dashboard');
loginPage.style.display = 'none';
dashboard.style.display = 'block';
dashboard.classList.remove('hidden');
```

---

**Última atualização:** 16 de Dezembro de 2025
**Versão do script:** app.js?v=20251216-fix2
