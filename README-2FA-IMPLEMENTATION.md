# Sistema de Autenticação 2FA - Nexus Gestão Financeira

## 📋 Passo a Passo Completo

### 1. Configuração do Banco de Dados (Supabase)

#### 1.1 Executar Script SQL
Execute o arquivo `setup-2fa-tables.sql` no SQL Editor do Supabase:

```sql
-- Este script cria todas as tabelas necessárias para 2FA
-- Inclui: user_2fa_settings, temp_2fa_codes, user_2fa_attempts
-- E todas as funções, triggers e políticas de segurança
```

#### 1.2 Verificar Tabelas Criadas
Confirme que as seguintes tabelas foram criadas:
- `user_2fa_settings` - Configurações de 2FA por usuário
- `temp_2fa_codes` - Códigos temporários (email/SMS)
- `user_2fa_attempts` - Log de tentativas de autenticação

### 2. Configuração do Resend

#### 2.1 Criar Conta no Resend
1. Acesse [resend.com](https://resend.com)
2. Crie uma conta gratuita
3. Verifique seu domínio ou use o domínio de teste

#### 2.2 Obter API Key
1. No painel do Resend, vá em "API Keys"
2. Crie uma nova API Key
3. Copie a chave (formato: `re_xxxxxxxxxx`)

#### 2.3 Configurar Variáveis de Ambiente
Crie um arquivo `.env` baseado no `.env.example`:

```env
# Resend Configuration
RESEND_API_KEY=re_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
FROM_EMAIL=noreply@seudominio.com
FROM_NAME=Nexus Gestão Financeira

# 2FA Settings
TWO_FA_ISSUER=Nexus Gestão
TWO_FA_CODE_EXPIRY_MINUTES=5
TWO_FA_MAX_ATTEMPTS=3
```

### 3. Instalação de Dependências

#### 3.1 Instalar Pacotes NPM
```bash
npm install
```

Isso instalará:
- `resend` - SDK para envio de emails
- `speakeasy` - Geração e validação de códigos TOTP
- `qrcode` - Geração de QR codes
- `express` - Servidor web (se necessário)

### 4. Configuração no Frontend

#### 4.1 Arquivos Adicionados
Os seguintes arquivos foram criados/modificados:

**Novos Arquivos:**
- `2fa-service.js` - Serviço principal de 2FA
- `2fa-ui.js` - Interface de usuário para 2FA
- `setup-2fa-tables.sql` - Script de banco de dados
- `.env.example` - Exemplo de configuração

**Arquivos Modificados:**
- `index.html` - Adicionados modais e menu de 2FA
- `app.js` - Integração com fluxo de login
- `package.json` - Dependências adicionadas

#### 4.2 Configurar API Key do Resend
No arquivo `app.js`, linha 767, substitua:
```javascript
resendApiKey: 'YOUR_RESEND_API_KEY'
```

Por sua chave real do Resend.

### 5. Funcionalidades Implementadas

#### 5.1 Métodos de 2FA Suportados

**1. TOTP (Time-based One-Time Password)**
- Compatível com Google Authenticator, Authy, Microsoft Authenticator
- QR Code para configuração fácil
- Códigos de 6 dígitos válidos por 30 segundos
- Códigos de backup para recuperação

**2. Email 2FA**
- Códigos de 6 dígitos enviados por email
- Válidos por 5 minutos
- Template HTML personalizado
- Integração com Resend

#### 5.2 Interface de Usuário

**Menu do Usuário:**
- Dropdown no avatar do usuário
- Status do 2FA (Ativado/Desativado)
- Acesso às configurações

**Modal de Configuração:**
- Escolha entre TOTP e Email
- QR Code para apps autenticadores
- Códigos de backup
- Verificação antes da ativação

**Modal de Verificação:**
- Solicitação de código durante login
- Opção de enviar código por email
- Suporte a códigos de backup

### 6. Fluxo de Uso

#### 6.1 Ativação do 2FA

1. **Login Normal:** Usuário faz login com email/senha
2. **Acessar Configurações:** Clica no avatar → "Autenticação 2FA"
3. **Escolher Método:** TOTP (app) ou Email
4. **Configurar TOTP:**
   - Escanear QR Code com app autenticador
   - Ou inserir chave manual
   - Salvar códigos de backup
5. **Verificar:** Inserir código do app para confirmar
6. **Ativado:** 2FA está ativo para próximos logins

#### 6.2 Login com 2FA

1. **Credenciais:** Inserir email/senha normalmente
2. **Verificação 2FA:** Modal solicita código
3. **Inserir Código:** 
   - Código do app autenticador (6 dígitos)
   - Código recebido por email
   - Código de backup (8 caracteres)
4. **Acesso:** Dashboard liberado após verificação

#### 6.3 Desativação do 2FA

1. **Acessar Configurações:** Avatar → "Autenticação 2FA"
2. **Verificar Identidade:** Inserir código atual
3. **Confirmar:** 2FA é desativado

### 7. Segurança Implementada

#### 7.1 Medidas de Proteção

- **Row Level Security (RLS)** no Supabase
- **Códigos com expiração** (5 minutos para email)
- **Códigos de uso único** (não podem ser reutilizados)
- **Log de tentativas** para auditoria
- **Limpeza automática** de códigos expirados
- **Validação de entrada** nos formulários

#### 7.2 Políticas de Segurança

- Usuários só acessam seus próprios dados 2FA
- Códigos temporários gerenciados apenas pelo sistema
- Tentativas de autenticação registradas
- Backup codes removidos após uso

### 8. Testes e Validação

#### 8.1 Cenários de Teste

**Teste 1: Configuração TOTP**
1. Login com usuário sem 2FA
2. Ativar 2FA via TOTP
3. Escanear QR Code
4. Verificar código gerado
5. Salvar códigos de backup

**Teste 2: Login com TOTP**
1. Logout do sistema
2. Login com credenciais
3. Inserir código do app autenticador
4. Verificar acesso ao dashboard

**Teste 3: Código de Backup**
1. Tentar login com código de backup
2. Verificar que código é removido após uso
3. Confirmar que não pode ser reutilizado

**Teste 4: Email 2FA**
1. Configurar 2FA por email
2. Fazer login e solicitar código por email
3. Verificar recebimento do email
4. Inserir código e acessar sistema

**Teste 5: Desativação**
1. Acessar configurações 2FA
2. Inserir código para desativar
3. Verificar que próximo login não solicita 2FA

### 9. Troubleshooting

#### 9.1 Problemas Comuns

**Erro: "Supabase não inicializado"**
- Verificar se as tabelas foram criadas
- Confirmar configuração do Supabase

**Erro: "Falha ao enviar email"**
- Verificar API Key do Resend
- Confirmar configuração de domínio
- Checar logs do Resend

**QR Code não aparece**
- Verificar se biblioteca QRCode foi carregada
- Checar console do navegador por erros
- Confirmar que canvas está sendo criado

**Códigos TOTP inválidos**
- Verificar sincronização de horário
- Confirmar que app está configurado corretamente
- Tentar com janela de tempo maior

#### 9.2 Logs e Debugging

**Verificar logs no console:**
```javascript
// Ativar logs detalhados
localStorage.setItem('debug2FA', 'true');
```

**Verificar dados no Supabase:**
```sql
-- Ver configurações de usuário
SELECT * FROM user_2fa_settings WHERE user_id = 'USER_UUID';

-- Ver tentativas de login
SELECT * FROM user_2fa_attempts WHERE user_id = 'USER_UUID' ORDER BY created_at DESC;

-- Ver códigos temporários
SELECT * FROM temp_2fa_codes WHERE user_id = 'USER_UUID' AND expires_at > NOW();
```

### 10. Próximos Passos

#### 10.1 Melhorias Futuras

- **SMS 2FA:** Integração com Twilio ou similar
- **Push Notifications:** Notificações via app móvel
- **Biometria:** Autenticação por impressão digital
- **Backup automático:** Sincronização de códigos
- **Relatórios:** Dashboard de segurança

#### 10.2 Monitoramento

- **Métricas de uso:** Quantos usuários usam 2FA
- **Tentativas falhadas:** Alertas de segurança
- **Performance:** Tempo de resposta dos códigos
- **Disponibilidade:** Status do serviço de email

### 11. Suporte

Para dúvidas ou problemas:

1. **Verificar logs** do console do navegador
2. **Consultar documentação** do Supabase e Resend
3. **Testar configurações** em ambiente de desenvolvimento
4. **Verificar permissões** e políticas RLS

---

## ✅ Sistema 2FA Implementado com Sucesso!

O sistema está pronto para uso em produção com todas as funcionalidades de segurança implementadas. Lembre-se de configurar as variáveis de ambiente antes de fazer deploy.