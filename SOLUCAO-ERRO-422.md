# 🔧 Solução para Erro 422 EmailJS

## ❌ Problema Identificado
**Erro:** `422 Unprocessable Entity`

**Significado:** O template não existe, não está ativo, ou os parâmetros estão incorretos.

## 🔍 Possíveis Causas

### 1. **Template não existe**
- O template `template_z3n0654` pode não existir na sua conta
- Pode ter sido deletado ou nunca foi criado

### 2. **Template não está ativo**
- Template existe mas está desabilitado
- Precisa ser ativado no painel

### 3. **Parâmetros incorretos**
- Template espera variáveis diferentes
- Nomes das variáveis não coincidem

### 4. **Service não existe**
- O service `service_0ap0m1k` pode não existir
- Pode estar em outra conta

## ✅ Soluções

### Solução 1: Verificar no Painel EmailJS

1. **Acesse:** https://dashboard.emailjs.com/
2. **Vá em "Email Services"**
   - Verifique se `service_0ap0m1k` existe
   - Se não existir, anote o ID correto
3. **Vá em "Email Templates"**
   - Verifique se `template_z3n0654` existe
   - Se não existir, crie um novo ou anote o ID correto

### Solução 2: Criar Novo Template

Se o template não existir, crie um novo:

1. **No painel EmailJS, clique em "Create New Template"**
2. **Configure assim:**

**Assunto:**
```
Código de Verificação - {{system_name}}
```

**Corpo do Email:**
```
Olá,

Seu código de verificação para acessar o {{system_name}} é:

**{{verification_code}}**

Este código expira em {{expiry_time}}.

Se você não solicitou este código, ignore este email.

Atenciosamente,
Equipe {{system_name}}
```

3. **Salve e anote o novo Template ID**

### Solução 3: Template Mínimo (Teste)

Para testar rapidamente, crie um template simples:

**Assunto:**
```
Código: {{verification_code}}
```

**Corpo:**
```
Seu código: {{verification_code}}
Para: {{to_email}}
```

### Solução 4: Usar Template Existente

Se você já tem outros templates funcionando:
1. Vá em "Email Templates"
2. Escolha um template que funciona
3. Anote o Template ID
4. Me informe para atualizar o código

## 🧪 Como Testar

### Teste Rápido no Console:
```javascript
// Cole este código no console do navegador
emailjs.init('UsJiG8it4NxqAcHkW');

// Teste com template mínimo
emailjs.send('service_0ap0m1k', 'SEU_TEMPLATE_ID_AQUI', {
    to_email: 'assonibrassz@gmail.com',
    verification_code: '123456'
}).then(result => {
    console.log('✅ SUCESSO:', result);
}).catch(error => {
    console.error('❌ ERRO:', error);
});
```

### Teste com Página de Debug:
1. Abra `debug-erro-422.html`
2. Execute os testes na ordem
3. Veja qual funciona

## 🔄 Alternativas Rápidas

### Opção A: Usar Outro Serviço
Se você tem outros serviços EmailJS funcionando, me informe os IDs corretos.

### Opção B: Criar Nova Conta
1. Crie uma nova conta EmailJS
2. Configure Gmail/Outlook
3. Crie template simples
4. Me forneça os novos IDs

### Opção C: Template Genérico
Use um template que aceite qualquer parâmetro:

**Corpo:**
```
{{message}}
```

E envie assim:
```javascript
{
    message: `Código: 123456 para assonibrassz@gmail.com`
}
```

## 📋 Informações Necessárias

Para resolver rapidamente, me forneça:

1. **Screenshot do painel EmailJS** mostrando:
   - Lista de Services
   - Lista de Templates

2. **IDs corretos:**
   - Service ID real
   - Template ID real (se diferente)

3. **Resultado do teste** com `debug-erro-422.html`

## 🚀 Solução Imediata

**Se quiser resolver agora mesmo:**

1. Acesse https://dashboard.emailjs.com/
2. Crie um template novo e simples
3. Me informe o novo Template ID
4. Atualizo o código em 2 minutos

**Ou me informe os IDs corretos dos seus services/templates existentes!**

## 💡 Dica

O erro 422 é sempre relacionado ao template. Uma vez que criarmos/encontrarmos o template correto, o sistema funcionará perfeitamente.