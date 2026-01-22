# 🔐 Sistema de Acesso Limitado - Nexus Gestão Financeira

## 📋 Visão Geral

Este sistema permite criar usuários com acesso restrito que podem visualizar apenas as abas de **Empréstimos** e **Parcelamento**, escondendo todas as outras informações do sistema.

## ✨ Funcionalidades

### 👤 Usuários com Acesso Limitado

Usuários com role `limited` ou `viewer` terão acesso apenas a:
- ✅ **Aba de Empréstimos** (`#loans`)
- ✅ **Aba de Parcelamento** (`#installments`)

### 🚫 Abas Ocultas para Usuários Limitados

As seguintes abas serão automaticamente escondidas:
- ❌ Visão Geral
- ❌ Clientes
- ❌ Empréstimos Vencidos
- ❌ Empréstimos Quitados
- ❌ Relatórios
- ❌ Histórico de Pagamentos
- ❌ Despesas
- ❌ Gestão de Caixa
- ❌ Levantamento de Capital
- ❌ Histórico
- ❌ Comissões

## 🛠️ Configuração

### 1. Atualizar Banco de Dados

Execute o script SQL para atualizar a tabela de usuários:

```sql
-- Execute o arquivo: setup-limited-access-role.sql
```

Este script:
- Adiciona suporte aos roles `limited` e `viewer`
- Atualiza a constraint da coluna `role`
- Permite criar/atualizar usuários com acesso limitado

### 2. Criar Usuário com Acesso Limitado

#### Opção A: Criar Novo Usuário

```sql
INSERT INTO users (email, password_hash, full_name, role, is_active)
VALUES (
    'usuario.limitado@exemplo.com',
    'senha123', -- IMPORTANTE: Em produção, use hash de senha (bcrypt)
    'Usuário com Acesso Limitado',
    'limited',
    true
);
```

#### Opção B: Atualizar Usuário Existente

```sql
UPDATE users 
SET role = 'limited'
WHERE email = 'usuario.existente@exemplo.com';
```

### 3. Verificar Usuários com Acesso Limitado

```sql
SELECT 
    id,
    email,
    full_name,
    role,
    is_active,
    last_login,
    created_at
FROM users
WHERE role IN ('limited', 'viewer')
ORDER BY created_at DESC;
```

## 🔄 Como Funciona

### Fluxo de Autenticação

1. **Login**: O usuário faz login normalmente
2. **Verificação de Role**: O sistema verifica o `role` do usuário
3. **Aplicação de Permissões**: A função `setupUserPermissions()` é chamada automaticamente
4. **Ocultação de Elementos**: Links do menu e seções restritas são escondidos
5. **Redirecionamento**: Se o usuário tentar acessar uma seção restrita, é redirecionado para Empréstimos

### Função Principal

A função `setupUserPermissions()` em `app.js`:
- Verifica o role do usuário logado
- Esconde links do menu e seções restritas para usuários `limited` ou `viewer`
- Garante que apenas Empréstimos e Parcelamento estejam visíveis
- Redireciona automaticamente se necessário

## 📝 Roles Disponíveis

| Role | Descrição | Acesso |
|------|-----------|--------|
| `admin` | Administrador completo | ✅ Todas as funcionalidades |
| `manager` | Gerente | ✅ Todas as funcionalidades |
| `user` | Usuário padrão | ✅ Todas as funcionalidades |
| `limited` | Acesso limitado | ⚠️ Apenas Empréstimos e Parcelamento |
| `viewer` | Visualizador limitado | ⚠️ Apenas Empréstimos e Parcelamento |

## 🔒 Segurança

### Importante

- ⚠️ **Senhas**: Em produção, sempre use hash de senha (bcrypt) ao criar usuários
- ⚠️ **Validação**: O controle de acesso é feito no frontend. Para maior segurança, considere implementar também no backend
- ⚠️ **RLS**: Verifique se as políticas RLS (Row Level Security) do Supabase estão configuradas corretamente

## 🧪 Testando

1. **Criar usuário de teste**:
   ```sql
   INSERT INTO users (email, password_hash, full_name, role, is_active)
   VALUES ('teste.limitado@test.com', 'teste123', 'Usuário Teste', 'limited', true);
   ```

2. **Fazer login** com o usuário criado

3. **Verificar**:
   - ✅ Apenas abas "Empréstimos" e "Parcelamento" devem estar visíveis
   - ✅ Todas as outras abas devem estar escondidas
   - ✅ Ao acessar o sistema, deve abrir automaticamente na aba de Empréstimos

## 📚 Arquivos Modificados

- `app.js`: Adicionada função `setupUserPermissions()`
- `setup-limited-access-role.sql`: Script SQL para atualizar banco de dados

## 🔄 Atualizações Futuras

Possíveis melhorias:
- [ ] Implementar controle de acesso no backend (API)
- [ ] Adicionar mais níveis de permissão granulares
- [ ] Permitir configuração customizada de permissões por usuário
- [ ] Adicionar logs de acesso para auditoria

## ❓ Dúvidas Frequentes

**P: Posso criar um role customizado?**
R: Sim, basta adicionar o novo role na constraint da tabela `users` e atualizar a função `setupUserPermissions()`.

**P: Como reverter um usuário para acesso completo?**
R: Atualize o role do usuário:
```sql
UPDATE users SET role = 'user' WHERE email = 'usuario@exemplo.com';
```

**P: O controle funciona se o usuário tentar acessar diretamente via URL?**
R: O sistema redireciona automaticamente, mas para maior segurança, considere implementar validação também no backend.

