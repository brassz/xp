# Melhorias de Segurança - Sistema de Login

## Status Atual
O sistema atualmente armazena senhas em texto plano no campo `password_hash` da tabela `users`, o que representa um risco de segurança.

## Recomendações de Segurança

### 1. Implementar Hash de Senhas
```javascript
// Instalar bcrypt: npm install bcryptjs
const bcrypt = require('bcryptjs');

// Para criar hash da senha (no backend)
const saltRounds = 10;
const hashedPassword = await bcrypt.hash('Nexus2025!', saltRounds);

// Para verificar senha no login
const isValid = await bcrypt.compare(password, userData.password_hash);
```

### 2. Atualizar Função de Login
```javascript
async function handleLogin(e) {
    e.preventDefault();
    
    const email = document.getElementById('loginEmail').value;
    const password = document.getElementById('loginPassword').value;
    
    try {
        const { data: userData, error: userError } = await supabase
            .from('users')
            .select('*')
            .eq('email', email)
            .eq('is_active', true)
            .single();
        
        if (userError || !userData) {
            throw new Error('Usuário não encontrado ou inativo');
        }
        
        // Verificar senha com hash
        const isValidPassword = await bcrypt.compare(password, userData.password_hash);
        
        if (isValidPassword) {
            currentUser = userData;
            localStorage.setItem('nexusUser', JSON.stringify(currentUser));
            showDashboard();
            await loadData();
            
            // Atualizar último login
            await supabase
                .from('users')
                .update({ last_login: new Date().toISOString() })
                .eq('id', currentUser.id);
        } else {
            throw new Error('Senha incorreta');
        }
        
    } catch (error) {
        alert('Erro no login: ' + error.message);
    }
}
```

### 3. Script para Atualizar Senhas Existentes
```sql
-- Atualizar senhas com hash (exemplo usando extensão pgcrypto)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Atualizar senha do admin existente
UPDATE users 
SET password_hash = crypt('1020', gen_salt('bf')) 
WHERE email = 'admin@nexus.com';

-- Atualizar senhas dos novos usuários
UPDATE users 
SET password_hash = crypt('Nexus2025!', gen_salt('bf')) 
WHERE email IN ('douglas@nexus.com', 'vinicius@nexus.com');
```

### 4. Outras Melhorias de Segurança
- Implementar limite de tentativas de login
- Adicionar autenticação de dois fatores (2FA)
- Implementar expiração de sessões
- Adicionar logs de auditoria para logins
- Validar força da senha no cadastro
- Implementar recuperação de senha por email

## Implementação Gradual
1. **Fase 1**: Manter sistema atual funcionando
2. **Fase 2**: Implementar hash de senhas no backend
3. **Fase 3**: Migrar senhas existentes
4. **Fase 4**: Adicionar recursos de segurança extras