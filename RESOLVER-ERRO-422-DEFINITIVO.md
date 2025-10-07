# 🔧 Resolver Erro 422 - Guia Definitivo

## ❌ Problema Atual
- **Erro:** 422 Template não encontrado
- **Template confirmado:** template_z3n0654 existe ✅
- **Suspeita:** Service ID incorreto ou não associado

## 🎯 Solução em 3 Passos

### Passo 1: Verificar Service ID Real
1. **Acesse:** https://dashboard.emailjs.com/
2. **Vá em:** "Email Services"
3. **Anote:** Qual é o Service ID real (pode não ser service_0ap0m1k)
4. **Screenshot:** Tire uma foto da lista de services

### Passo 2: Verificar Associação Template
1. **No painel, vá em:** "Email Templates"
2. **Clique em:** template_z3n0654
3. **Verifique:** Se está associado ao service correto
4. **Se não estiver:** Associe ao service ativo

### Passo 3: Testar com ID Correto
1. **Abra:** `verificar-service-id.html`
2. **Cole:** O Service ID real no campo
3. **Teste:** Clique em "Testar com IDs Personalizados"

## 🔍 Possíveis Cenários

### Cenário A: Service ID Diferente
**Problema:** Estamos usando `service_0ap0m1k` mas o real é outro
**Solução:** Use o Service ID correto do painel

### Cenário B: Template Não Associado
**Problema:** Template existe mas não está vinculado ao service
**Solução:** No painel, associe o template ao service

### Cenário C: Service Inativo
**Problema:** Service existe mas está desabilitado
**Solução:** Ative o service no painel

### Cenário D: Conta Diferente
**Problema:** Template está em outra conta EmailJS
**Solução:** Use a conta correta ou crie novo template

## 🚀 Teste Rápido no Console

Cole este código no console (F12) com o Service ID correto:

```javascript
// Substitua SERVICE_ID_REAL pelo ID correto do painel
emailjs.init('UsJiG8it4NxqAcHkW');
emailjs.send('SERVICE_ID_REAL', 'template_z3n0654', {
    to_email: 'assonibrassz@gmail.com'
}).then(result => {
    console.log('✅ FUNCIONOU! Service ID correto:', 'SERVICE_ID_REAL');
}).catch(error => {
    console.log('❌ Ainda erro:', error.status, error.message);
});
```

## 📋 Informações Necessárias

**Me forneça:**
1. **Lista de Services** do seu painel (screenshot)
2. **Service ID real** (se diferente de service_0ap0m1k)
3. **Resultado do teste** com verificar-service-id.html

## 🔄 Alternativa Rápida

**Se quiser resolver imediatamente:**

1. **Crie um novo service** no EmailJS
2. **Conecte com Gmail/Outlook**
3. **Crie um template simples:**
   - Assunto: `Código: {{code}}`
   - Corpo: `Seu código: {{code}}`
4. **Me forneça os novos IDs**

## ⚡ Solução Mais Provável

**90% das vezes o problema é:**
- Service ID incorreto (não é service_0ap0m1k)
- Template não associado ao service

**Verifique o painel e me informe o Service ID real! 🎯**

## 🎊 Assim que Resolvermos

1. ✅ Atualizo o código com o Service ID correto
2. ✅ Sistema funcionará 100%
3. ✅ Emails com códigos reais chegando

**Estamos muito perto! Só preciso do Service ID correto! 🚀**