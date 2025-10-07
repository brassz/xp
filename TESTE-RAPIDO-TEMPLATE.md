# 🚀 Teste Rápido do Template

## ✅ Template Confirmado: template_z3n0654

Agora vamos descobrir quais parâmetros ele aceita.

## 🧪 Opções de Teste

### Opção 1: Teste Automático (Recomendado)
1. **Abra o sistema principal** (`index.html`)
2. **Tente fazer login** e clique em "Enviar Código"
3. **Veja o console** (F12) - o sistema agora tenta 5 formatos diferentes automaticamente
4. **Me informe qual tentativa funcionou**

### Opção 2: Teste Manual Detalhado
1. **Abra** `teste-template-parametros.html`
2. **Execute os testes na ordem** (1, 2, 3, 4, 5, 6)
3. **Veja qual funciona** e me informe

### Opção 3: Teste no Console
Cole este código no console do navegador (F12):

```javascript
// Inicializar EmailJS
emailjs.init('UsJiG8it4NxqAcHkW');

// Teste simples
emailjs.send('service_0ap0m1k', 'template_z3n0654', {
    to_email: 'assonibrassz@gmail.com',
    verification_code: '123456'
}).then(result => {
    console.log('✅ FUNCIONOU!', result);
}).catch(error => {
    console.log('❌ Erro:', error.status, error.message);
});
```

## 🎯 O que Procurar

### Se Funcionar:
- ✅ Status 200
- ✅ Email chega em assonibrassz@gmail.com
- ✅ Console mostra "FUNCIONOU!"

### Se Não Funcionar:
- ❌ Erro 422 ainda
- ❌ Outros códigos de erro

## 📋 Formatos que o Sistema Tenta Automaticamente

1. **Formato Atual:**
   ```javascript
   {
       to_email: 'assonibrassz@gmail.com',
       verification_code: '123456',
       system_name: 'Nexus Gestão Financeira',
       expiry_time: '5 minutos'
   }
   ```

2. **Formato Simples:**
   ```javascript
   {
       email: 'assonibrassz@gmail.com',
       code: '123456'
   }
   ```

3. **Formato Padrão:**
   ```javascript
   {
       user_email: 'assonibrassz@gmail.com',
       message: 'Código de verificação: 123456'
   }
   ```

4. **Formato Mínimo:**
   ```javascript
   {
       to_email: 'assonibrassz@gmail.com',
       verification_code: '123456'
   }
   ```

5. **Formato Alternativo:**
   ```javascript
   {
       recipient_email: 'assonibrassz@gmail.com',
       auth_code: '123456',
       app_name: 'Nexus'
   }
   ```

## 🚀 Teste Agora!

**Recomendo a Opção 1** - simplesmente tente fazer login no sistema. O código agora testa automaticamente todos os formatos e me diz qual funcionou!

**Veja o console (F12) e me informe:**
- Qual tentativa funcionou (1, 2, 3, 4 ou 5)?
- Ou se todas falharam, qual foi o erro?

**Com essa informação, o sistema funcionará perfeitamente! 🎯**