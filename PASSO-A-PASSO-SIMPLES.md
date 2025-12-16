# 🚀 Passo a Passo SIMPLES para Testar

## ⚠️ IMPORTANTE: Faça EXATAMENTE nesta ordem

### 1️⃣ FECHAR TUDO
- Feche TODAS as abas do site
- Feche o navegador completamente

### 2️⃣ ABRIR NOVAMENTE
- Abra o navegador
- Abra o site

### 3️⃣ ABRIR CONSOLE (ESSENCIAL!)
- Pressione **F12** 
- Clique na aba **"Console"**
- **DEIXE ABERTO**

### 4️⃣ LIMPAR CACHE
- Pressione **Ctrl + Shift + Delete** (Windows) ou **Cmd + Shift + Delete** (Mac)
- Marque **"Imagens e arquivos em cache"**
- Clique em **"Limpar dados"**

### 5️⃣ RECARREGAR
- Pressione **Ctrl + F5** (Windows) ou **Cmd + Shift + R** (Mac)
- Aguarde carregar COMPLETAMENTE

### 6️⃣ COLAR SCRIPT DE DIAGNÓSTICO
1. Abra o arquivo: **teste-console.js**
2. **Copie TODO o conteúdo**
3. **Cole no console** (na parte de baixo onde você pode digitar)
4. Pressione **Enter**
5. **Copie e envie TODO o resultado**

### 7️⃣ FAZER LOGIN
1. Selecione a empresa
2. Digite email e senha
3. Clique em "Entrar"
4. **OBSERVE O CONSOLE**

---

## ✅ O que você DEVE ver no console após o login:

```
Iniciando processo de login...
Empresa inicializada: [nome]
Buscando usuário no banco de dados...
Usuário encontrado: [email]
✓ Login bem-sucedido!
✓ Usuário salvo no localStorage
>>> Chamando showDashboard()...
showDashboard called
Dashboard mostrado com sucesso
>>> showDashboard() retornou
```

---

## ❌ SE NÃO APARECER NADA NO CONSOLE

Significa que o script não está carregando. Faça:

1. Vá na aba **"Network"** do DevTools (F12)
2. Recarregue a página
3. Procure por **"app.js"**
4. Veja se aparece erro (vermelho)
5. **Envie print** do que aparecer

---

## ❌ SE APARECER ERRO NO CONSOLE

1. **COPIE O ERRO COMPLETO** (clique com botão direito → Copy)
2. **ENVIE** a mensagem de erro

---

## 🧪 TESTE ALTERNATIVO

Se nada funcionar, teste a página simplificada:

1. Abra: **TESTE-DEBUG-LOGIN.html**
2. Clique em **"Verificar Elementos"**
3. Clique em **"Testar showDashboard()"**
4. O dashboard deve aparecer?
   - **SIM**: O problema está no arquivo principal
   - **NÃO**: Problema no navegador/configuração

---

## 📞 O QUE ENVIAR SE NÃO FUNCIONAR

**ENVIE EXATAMENTE ISSO:**

1. ✅ Resultado do script de diagnóstico (todo o texto que aparecer)
2. ✅ Logs do console após tentar fazer login
3. ✅ Mensagens de erro (se houver)
4. ✅ Resposta: O TESTE-DEBUG-LOGIN.html funcionou? (SIM/NÃO)
5. ✅ Navegador que está usando (Chrome, Firefox, etc.)

---

## 💡 ATALHOS ÚTEIS

| Ação | Windows/Linux | Mac |
|------|--------------|-----|
| Abrir Console | F12 | F12 ou Cmd+Opt+I |
| Limpar Cache | Ctrl+Shift+Del | Cmd+Shift+Del |
| Hard Refresh | Ctrl+F5 | Cmd+Shift+R |
| Modo Anônimo | Ctrl+Shift+N | Cmd+Shift+N |

---

**Última atualização:** 16/12/2025
