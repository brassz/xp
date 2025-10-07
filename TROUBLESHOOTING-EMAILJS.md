# 🔧 Troubleshooting - Sistema de Verificação EmailJS

## Problema Reportado: "Não está funcionando"

### 📋 Checklist de Diagnóstico

#### 1. **Teste Básico - Abra o Console do Navegador**
1. Abra o sistema principal (`index.html`)
2. Pressione F12 para abrir as ferramentas de desenvolvedor
3. Vá na aba "Console"
4. Tente clicar em "Enviar Código"
5. **Anote todas as mensagens que aparecem no console**

#### 2. **Teste com Página de Debug**
1. Abra `debug-verification.html` no navegador
2. Execute cada passo e anote os resultados:
   - Passo 1: Verificar EmailJS
   - Passo 2: Inicializar EmailJS
   - Passo 3: Gerar Código
   - Passo 4: Enviar Email (Método 1)
   - Passo 5: Enviar Email (Método 2)

#### 3. **Teste Simples**
1. Abra `simple-verification-test.html`
2. Clique em "Enviar Email de Teste"
3. Observe as mensagens no resultado

### 🚨 Possíveis Problemas e Soluções

#### **Problema 1: EmailJS não carrega**
**Sintomas:** Console mostra "EmailJS não está disponível"
**Soluções:**
- Verificar conexão com internet
- Verificar se o script está sendo bloqueado por ad-blocker
- Tentar recarregar a página

#### **Problema 2: Erro 400 (Bad Request)**
**Sintomas:** "Erro no envio por EmailJS: 400"
**Causas possíveis:**
- Template não existe ou está inativo
- Parâmetros do template incorretos
- Service ID incorreto

**Verificações:**
1. Acesse https://dashboard.emailjs.com/
2. Verifique se o serviço `service_0ap0m1k` existe
3. Verifique se o template `template_z3n0654` existe e está ativo
4. Confirme se o template tem as variáveis: `to_email`, `verification_code`, `system_name`, `expiry_time`

#### **Problema 3: Erro 401 (Unauthorized)**
**Sintomas:** "Erro no envio por EmailJS: 401"
**Causa:** Public Key incorreta
**Solução:** Verificar se a Public Key `UsJiG8it4NxqAcHkW` está correta

#### **Problema 4: Erro 404 (Not Found)**
**Sintomas:** "Erro no envio por EmailJS: 404"
**Causa:** Service ID ou Template ID não encontrados
**Solução:** Verificar IDs no painel do EmailJS

#### **Problema 5: Template não configurado**
**Sintomas:** Email não chega mesmo com status 200
**Verificações:**
1. Template deve ter o assunto configurado
2. Template deve ter o corpo do email
3. Serviço de email deve estar conectado (Gmail, Outlook, etc.)

### 📧 Configuração Esperada do Template

**Assunto sugerido:**
```
Código de Verificação - {{system_name}}
```

**Corpo do email sugerido:**
```
Olá,

Seu código de verificação para acessar o {{system_name}} é:

**{{verification_code}}**

Este código expira em {{expiry_time}}.

Se você não solicitou este código, ignore este email.

Atenciosamente,
Equipe {{system_name}}
```

### 🔍 Como Coletar Informações para Debug

Execute este código no console do navegador:

```javascript
// Verificar status do EmailJS
console.log('EmailJS disponível:', typeof emailjs !== 'undefined');
console.log('Configurações:', {
    serviceId: 'service_0ap0m1k',
    templateId: 'template_z3n0654',
    publicKey: 'UsJiG8it4NxqAcHkW'
});

// Testar envio simples
if (typeof emailjs !== 'undefined') {
    emailjs.init('UsJiG8it4NxqAcHkW');
    emailjs.send('service_0ap0m1k', 'template_z3n0654', {
        to_email: 'brasszgc@gmail.com',
        verification_code: '123456',
        system_name: 'Teste Debug',
        expiry_time: '5 minutos'
    }).then(result => {
        console.log('✅ Sucesso:', result);
    }).catch(error => {
        console.error('❌ Erro:', error);
    });
}
```

### 📞 Próximos Passos

1. **Execute os testes de debug**
2. **Colete as mensagens de erro**
3. **Verifique a configuração no painel EmailJS**
4. **Teste com o código de debug acima**

### 🆘 Se Nada Funcionar

Como fallback, o sistema sempre mostra o código no console e em uma notificação na tela. Mesmo que o email não seja enviado, o sistema de verificação ainda funciona para testes.

**Para usar em modo demonstração:**
1. Clique em "Enviar Código"
2. Veja o código no console ou na notificação
3. Digite o código mostrado
4. Complete o login

### 📋 Informações Necessárias para Suporte

Se precisar de ajuda, forneça:
1. Mensagens do console (screenshots)
2. Resultado dos testes de debug
3. Status no painel do EmailJS
4. Navegador e versão utilizados