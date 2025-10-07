# 🔍 Verificação Edge Function - Problemas Comuns

## 🎯 Problema Reportado
- ✅ Edge Function configurada
- ❌ Sistema ainda diz "não configurada"

## 🔍 Possíveis Causas

### 1. **Nome da Função Incorreto**
**Problema:** Função criada com nome diferente
**Verificação:** Nome deve ser exatamente `send-verification`
**Solução:** Renomear ou criar nova função

### 2. **Função Não Deployada**
**Problema:** Função criada mas não foi deployada
**Verificação:** Status deve ser "Deployed" no painel
**Solução:** Clicar em "Deploy" na função

### 3. **Erro no Código da Função**
**Problema:** Código da função tem erro de sintaxe
**Verificação:** Ver logs da função no Supabase
**Solução:** Corrigir código e redeploy

### 4. **Projeto Supabase Diferente**
**Problema:** Função criada em projeto diferente
**Verificação:** URL deve ser mhtxyxizfnxupwmilith.supabase.co
**Solução:** Criar função no projeto correto

### 5. **Permissões da Função**
**Problema:** Função sem permissões adequadas
**Verificação:** RLS ou políticas bloqueando
**Solução:** Configurar permissões

## 🧪 Diagnóstico Rápido

### **Teste 1: Verificar se Função Existe**
1. **Abra `diagnostico-edge-function.html`**
2. **Clique em "2. Testar Edge Function"**
3. **Veja o erro específico**

### **Teste 2: Console do Sistema Principal**
1. **Abra `index.html`**
2. **Abra console (F12)**
3. **Clique "Enviar Código"**
4. **Veja logs detalhados**

### **Teste 3: Painel Supabase**
1. **Acesse dashboard Supabase**
2. **Vá em "Edge Functions"**
3. **Verifique:**
   - ✅ Função `send-verification` existe?
   - ✅ Status é "Deployed"?
   - ✅ Não há erros nos logs?

## 🔧 Soluções por Tipo de Erro

### **"Function not found"**
```
💡 Função não existe ou nome incorreto
✅ Criar função com nome: send-verification
✅ Fazer deploy da função
```

### **"CORS error"**
```
💡 Função existe mas CORS não configurado
✅ Verificar código da função
✅ Incluir headers CORS corretos
```

### **"Timeout"**
```
💡 Função existe mas tem erro interno
✅ Verificar logs da função
✅ Verificar código Resend
```

### **"Permission denied"**
```
💡 Função existe mas sem permissões
✅ Verificar RLS da tabela
✅ Verificar políticas de segurança
```

## 📋 Checklist de Verificação

**No painel Supabase, verifique:**

- [ ] **Edge Functions** → Função `send-verification` existe?
- [ ] **Status** → Mostra "Deployed" (não "Draft")?
- [ ] **Logs** → Não há erros na última execução?
- [ ] **Nome** → Exatamente `send-verification` (sem espaços)?
- [ ] **Código** → Contém o código completo fornecido?

## 🚀 Solução Mais Provável

**90% das vezes o problema é:**
1. **Nome incorreto** da função
2. **Função não deployada**
3. **Código incompleto** na função

## 💡 Teste Rápido

**No console do navegador (F12), teste:**

```javascript
// Verificar se Supabase está funcionando
console.log('Supabase:', !!supabase);

// Testar Edge Function diretamente
supabase.functions.invoke('send-verification', {
  body: { email: 'brasszgc@gmail.com', code: '123456' }
}).then(result => {
  console.log('✅ Funcionou:', result);
}).catch(error => {
  console.log('❌ Erro específico:', error);
});
```

## 🎯 Próximos Passos

1. **Execute diagnóstico** com `diagnostico-edge-function.html`
2. **Verifique painel Supabase** - função existe e está deployada?
3. **Me informe o erro específico** do diagnóstico

**Com essas informações, posso resolver o problema rapidamente! 🔍**