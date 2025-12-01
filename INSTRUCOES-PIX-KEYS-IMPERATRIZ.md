# Instruções para Criar Tabela PIX_KEYS - Imperatriz Cred

## 🎯 Objetivo

Criar a tabela `public.pix_keys` no banco de dados da **IMPERATRIZ CRED** para permitir o gerenciamento de chaves PIX para cobrança.

## 📋 Pré-requisitos

- Acesso ao painel do Supabase da Imperatriz Cred
- URL do projeto: `https://eppzphzwwpvpoocospxy.supabase.co`

## 🚀 Passo a Passo

### 1️⃣ Acessar o Supabase

1. Acesse o painel do Supabase: https://supabase.com/dashboard
2. Faça login com suas credenciais
3. Selecione o projeto da **Imperatriz Cred**
   - URL: `https://eppzphzwwpvpoocospxy.supabase.co`

### 2️⃣ Abrir o SQL Editor

1. No menu lateral esquerdo, clique em **SQL Editor**
2. Clique em **New Query** para criar uma nova consulta

### 3️⃣ Executar o Script

1. Copie todo o conteúdo do arquivo `setup-pix-keys-imperatriz.sql`
2. Cole no SQL Editor do Supabase
3. Clique em **Run** (ou pressione `Ctrl/Cmd + Enter`)

### 4️⃣ Verificar a Criação

Após executar o script, você deverá ver:

```
✅ Tabela pix_keys criada com sucesso!
✅ Total de chaves: 1 (exemplo incluído)
✅ Estrutura da tabela (colunas)
✅ Políticas RLS aplicadas
```

### 5️⃣ Verificar no Painel

1. Acesse **Table Editor** no menu lateral
2. Procure pela tabela `pix_keys`
3. Verifique se a tabela foi criada com as colunas corretas:
   - `id` (UUID)
   - `bank_name` (VARCHAR)
   - `pix_key` (VARCHAR)
   - `pix_key_type` (VARCHAR)
   - `account_holder` (VARCHAR)
   - `is_active` (BOOLEAN)
   - `created_at` (TIMESTAMP)
   - `updated_at` (TIMESTAMP)

## 📊 Estrutura da Tabela

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id` | UUID | Identificador único da chave PIX |
| `bank_name` | VARCHAR(100) | Nome do banco |
| `pix_key` | VARCHAR(255) | Chave PIX (CPF, CNPJ, email, telefone ou aleatória) |
| `pix_key_type` | VARCHAR(20) | Tipo da chave: 'cpf', 'cnpj', 'email', 'phone', 'random' |
| `account_holder` | VARCHAR(100) | Nome do titular da conta |
| `is_active` | BOOLEAN | Se a chave está ativa (padrão: true) |
| `created_at` | TIMESTAMP | Data de criação |
| `updated_at` | TIMESTAMP | Data da última atualização |

## 🔒 Segurança (RLS)

O script configura automaticamente as seguintes políticas de segurança:

- ✅ **SELECT**: Usuários autenticados podem visualizar chaves PIX
- ✅ **INSERT**: Usuários autenticados podem adicionar chaves PIX
- ✅ **UPDATE**: Usuários autenticados podem atualizar chaves PIX
- ✅ **DELETE**: Usuários autenticados podem excluir chaves PIX

## 📝 Gerenciar Chaves PIX

### Adicionar Nova Chave PIX

```sql
INSERT INTO public.pix_keys (bank_name, pix_key, pix_key_type, account_holder, is_active)
VALUES ('Banco do Brasil', '12345678901234', 'cpf', 'Nome do Titular', true);
```

### Listar Todas as Chaves PIX

```sql
SELECT * FROM public.pix_keys WHERE is_active = true ORDER BY created_at DESC;
```

### Atualizar Chave PIX

```sql
UPDATE public.pix_keys 
SET pix_key = 'nova_chave@email.com', pix_key_type = 'email'
WHERE id = 'uuid-da-chave';
```

### Desativar Chave PIX

```sql
UPDATE public.pix_keys 
SET is_active = false
WHERE id = 'uuid-da-chave';
```

### Excluir Chave PIX

```sql
DELETE FROM public.pix_keys WHERE id = 'uuid-da-chave';
```

## ✅ Checklist de Verificação

Após executar o script, verifique:

- [ ] Tabela `pix_keys` aparece no Table Editor
- [ ] Estrutura da tabela está correta (8 colunas)
- [ ] Índices foram criados (`idx_pix_keys_active`, `idx_pix_keys_bank`, `idx_pix_keys_type`)
- [ ] RLS está habilitado
- [ ] 4 políticas de segurança estão ativas
- [ ] Trigger `trigger_update_pix_keys_updated_at` está criado
- [ ] Chave PIX de exemplo foi inserida (se desejar)

## 🆘 Solução de Problemas

### Erro: "relation pix_keys already exists"

Se você receber esse erro, significa que a tabela já foi criada. Você pode:

1. **Verificar se existe**: Execute `SELECT * FROM public.pix_keys;`
2. **Remover e recriar**: Execute `DROP TABLE IF EXISTS public.pix_keys CASCADE;` e rode o script novamente

### Erro: "permission denied"

Certifique-se de que você está logado com uma conta que tem permissões de admin no projeto.

### Erro: "function uuid_generate_v4() does not exist"

Execute antes do script:

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

## 📱 Usando no Sistema

Após criar a tabela, a funcionalidade de chaves PIX estará disponível no sistema da Imperatriz Cred:

1. Faça login no sistema
2. Selecione **IMPERATRIZ CRED** no dropdown de empresas
3. Acesse a seção de configurações de chaves PIX
4. Gerencie as chaves PIX conforme necessário

## 📚 Referências

- Script SQL: `setup-pix-keys-imperatriz.sql`
- Empresa: IMPERATRIZ CRED (Empresa 5)
- Supabase URL: https://eppzphzwwpvpoocospxy.supabase.co
- Data de criação: 1 de dezembro de 2025

---

**✨ Pronto! A tabela pix_keys está configurada e pronta para uso na Imperatriz Cred!**
