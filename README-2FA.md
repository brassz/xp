# Autenticação de Dois Fatores (2FA) - Nexus

## Visão Geral

O sistema Nexus agora suporta autenticação de dois fatores (2FA) usando TOTP (Time-based One-Time Password), compatível com aplicativos como Google Authenticator, Authy, Microsoft Authenticator, entre outros.

## Configuração Inicial

### 1. Executar Script SQL

Antes de usar o 2FA, execute o script SQL no seu banco Supabase:

```sql
-- Execute o arquivo setup-2fa-fields.sql
```

Este script adiciona as colunas necessárias na tabela `users`:
- `two_factor_secret`: Secret key para geração de códigos TOTP
- `two_factor_enabled`: Indica se o 2FA está ativo
- `two_factor_backup_codes`: Códigos de backup para recuperação
- `two_factor_setup_at`: Data de configuração do 2FA

### 2. Instalar Dependências (Opcional)

Se você quiser executar localmente com Node.js:

```bash
npm install
```

## Como Usar

### Para Usuários

#### 1. Configurar 2FA

1. Faça login normalmente no sistema
2. No dashboard, clique no botão **"Configurar 2FA"** no menu lateral
3. Escaneie o QR Code com seu aplicativo autenticador ou digite o código manual
4. Digite o código de 6 dígitos do seu aplicativo para verificar
5. Salve os códigos de backup em local seguro
6. Clique em "Finalizar"

#### 2. Login com 2FA

1. Digite email, senha e selecione a empresa normalmente
2. Se o 2FA estiver ativo, você será redirecionado para a tela de verificação
3. Digite o código de 6 dígitos do seu aplicativo autenticador
4. Alternativamente, use um código de backup se necessário

#### 3. Desabilitar 2FA

1. No dashboard, clique no botão **"Desabilitar 2FA"**
2. Confirme a ação

### Para Administradores

#### Desabilitar 2FA de um Usuário

```javascript
// No console do navegador ou em código administrativo
await disable2FA(userId);
```

## Aplicativos Autenticadores Recomendados

- **Google Authenticator** (iOS/Android)
- **Authy** (iOS/Android/Desktop)
- **Microsoft Authenticator** (iOS/Android)
- **1Password** (iOS/Android/Desktop)
- **Bitwarden** (iOS/Android/Desktop)

## Códigos de Backup

- São gerados automaticamente durante a configuração
- Use-os se perder acesso ao seu aplicativo autenticador
- Cada código pode ser usado apenas uma vez
- Guarde-os em local seguro (cofre de senhas, papel em local seguro)

## Segurança

### Características de Segurança

- **TOTP padrão**: Compatível com RFC 6238
- **Códigos de 6 dígitos**: Renovados a cada 30 segundos
- **Janela de tolerância**: ±30 segundos para compensar diferenças de relógio
- **Códigos de backup**: Para recuperação de acesso
- **Criptografia**: Secrets armazenados de forma segura

### Boas Práticas

1. **Configuração**:
   - Configure o 2FA imediatamente após o primeiro login
   - Use um aplicativo autenticador confiável
   - Salve os códigos de backup em local seguro

2. **Uso Diário**:
   - Mantenha seu aplicativo autenticador atualizado
   - Sincronize o relógio do seu dispositivo
   - Não compartilhe códigos com outras pessoas

3. **Backup e Recuperação**:
   - Guarde códigos de backup em múltiplos locais seguros
   - Configure o 2FA em múltiplos dispositivos se possível
   - Mantenha uma lista de códigos de backup atualizada

## Solução de Problemas

### Código Inválido

1. Verifique se o relógio do dispositivo está sincronizado
2. Certifique-se de estar usando o código mais recente
3. Tente aguardar a próxima renovação do código (30 segundos)

### Perda de Acesso ao Aplicativo

1. Use um dos códigos de backup
2. Entre em contato com o administrador do sistema
3. Reconfigure o 2FA após recuperar o acesso

### Problemas de QR Code

1. Tente digitar o código manual em vez de escanear
2. Verifique se a câmera tem permissão para acessar
3. Use boa iluminação ao escanear

## Estrutura Técnica

### Arquivos Principais

- `2fa-module.js`: Módulo principal com funções TOTP
- `setup-2fa-fields.sql`: Script de configuração do banco
- Seções no `index.html`: Interfaces de configuração e verificação
- Funções no `app.js`: Integração com o fluxo de login

### Fluxo de Funcionamento

1. **Configuração**:
   ```
   Usuário clica "Configurar 2FA" → 
   Gera secret e QR Code → 
   Usuário escaneia → 
   Verifica código → 
   Salva no banco → 
   Mostra códigos de backup
   ```

2. **Login**:
   ```
   Login normal → 
   Verifica se tem 2FA → 
   Solicita código → 
   Valida TOTP → 
   Completa login
   ```

## Suporte

Para problemas técnicos ou dúvidas:
1. Verifique este documento primeiro
2. Consulte os logs do navegador (F12 → Console)
3. Entre em contato com o suporte técnico

---

**Nota**: O 2FA adiciona uma camada extra de segurança ao seu sistema. É altamente recomendado para todos os usuários, especialmente aqueles com acesso a dados sensíveis.