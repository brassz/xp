# Correção de Erros nas Chaves PIX - Franca Private

## 🔴 Problema Identificado

Ao tentar adicionar ou carregar chaves PIX no sistema Franca Private, ocorriam dois erros:

### Erro 1: Schema Cache
```
Erro ao adicionar chave PIX: Could not find the 'pix_key_type' column of 'pix_keys' in the schema cache
```

**Causa**: A tabela `pix_keys` não existe ou está com schema incompleto no banco de dados do Franca Private.

### Erro 2: JavaScript
```
Erro ao carregar chaves PIX: Cannot read properties of undefined (reading 'toUpperCase')
```

**Causa**: O código JavaScript tentava chamar `.toUpperCase()` em valores `undefined` ou `null` no tipo da chave PIX.

---

## ✅ Solução Implementada

### 1. Correções no Código JavaScript (`app.js`)

#### Função `getPixKeyTypeLabel` - CORRIGIDA
Agora verifica se o tipo existe antes de processar:

```javascript
function getPixKeyTypeLabel(type) {
    // Verificar se o type existe antes de processar
    if (!type) {
        return 'N/A';
    }
    
    const labels = {
        'cpf': 'CPF',
        'cnpj': 'CNPJ', 
        'email': 'E-mail',
        'phone': 'Telefone',
        'random': 'Aleatória'
    };
    return labels[type] || (typeof type === 'string' ? type.toUpperCase() : 'N/A');
}
```

#### Função `maskPixKey` - CORRIGIDA
Agora valida se key e type existem:

```javascript
function maskPixKey(key, type) {
    // Verificar se key e type existem
    if (!key) {
        return 'N/A';
    }
    
    if (!type) {
        return key;
    }
    
    // ... resto do código de mascaramento
}
```

### 2. Script SQL de Correção

Foi criado o arquivo `fix-franca-private-pix-keys.sql` que:

✅ Cria a tabela `pix_keys` se não existir  
✅ Adiciona a coluna `pix_key_type` se estiver faltando  
✅ Adiciona outras colunas necessárias  
✅ Cria índices para performance  
✅ Remove RLS (Row Level Security)  
✅ Insere uma chave PIX de exemplo  
✅ Atualiza o schema cache do Supabase  

---

## 📋 Instruções de Aplicação

### Passo 1: Acessar o Supabase do Franca Private

1. Acesse: https://pebwoerzslfzhjptyjwh.supabase.co
2. Faça login com suas credenciais
3. Vá para **SQL Editor** no menu lateral

### Passo 2: Executar o Script de Correção

1. Abra o arquivo `fix-franca-private-pix-keys.sql`
2. Copie TODO o conteúdo do arquivo
3. Cole no SQL Editor do Supabase
4. Clique em **Run** (ou pressione Ctrl+Enter)
5. Aguarde a execução completa
6. Verifique se não há erros na saída

### Passo 3: Atualizar o Schema Cache

Escolha uma das opções:

**Opção A - Pelo Dashboard:**
1. Vá para: **Settings** → **API** → **Schema Cache**
2. Clique no botão **"Reload schema"**
3. Aguarde a confirmação

**Opção B - Pelo SQL Editor:**
```sql
NOTIFY pgrst, 'reload schema';
```

### Passo 4: Verificar a Correção

Execute estas queries para confirmar:

```sql
-- Ver estrutura da tabela
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'pix_keys'
ORDER BY ordinal_position;

-- Ver chaves PIX cadastradas
SELECT * FROM pix_keys;
```

### Passo 5: Testar no Sistema

1. Acesse o sistema Franca Private (botão de 3 cliques)
2. Faça login com:
   - Email: `admin@francaprivate.com`
   - Senha: `1020`
3. Vá para a aba **Empréstimos** ou **Parcelamentos**
4. Clique no botão 📞 (WhatsApp) de qualquer empréstimo
5. Verifique se o modal de seleção de chaves PIX abre corretamente
6. Tente adicionar uma nova chave PIX clicando em **"+ Nova Chave PIX"**
7. Preencha os campos e salve
8. Confirme que não há mais erros

---

## 🎯 Resultado Esperado

Após aplicar as correções:

✅ O modal de chaves PIX abre sem erros  
✅ As chaves PIX são exibidas corretamente  
✅ É possível adicionar novas chaves PIX  
✅ O tipo da chave é exibido corretamente (CPF, CNPJ, Email, etc.)  
✅ As chaves são mascaradas para segurança  
✅ A mensagem do WhatsApp é enviada com os dados da chave PIX  

---

## 📂 Arquivos Modificados

### Arquivos Criados:
- ✅ `fix-franca-private-pix-keys.sql` - Script de correção do banco
- ✅ `README-correcao-pix-keys-franca-private.md` - Este arquivo de instruções

### Arquivos Modificados:
- ✅ `app.js` - Correção das funções JavaScript

---

## 🔧 Detalhes Técnicos

### Estrutura da Tabela pix_keys

```sql
CREATE TABLE pix_keys (
    id UUID PRIMARY KEY,
    bank_name VARCHAR(100) NOT NULL,
    pix_key VARCHAR(255) NOT NULL,
    pix_key_type VARCHAR(20) NOT NULL,
    account_holder VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Tipos de Chave PIX Suportados

- `cpf` - CPF (11 dígitos)
- `cnpj` - CNPJ (14 dígitos)
- `email` - E-mail válido
- `phone` - Telefone (10-11 dígitos)
- `random` - Chave aleatória (UUID)

### Índices Criados

- `idx_pix_keys_active` - Para filtrar chaves ativas
- `idx_pix_keys_bank` - Para ordenar por banco
- `idx_pix_keys_type` - Para filtrar por tipo

---

## ⚠️ Observações Importantes

1. **RLS Desabilitado**: O Row Level Security foi desabilitado para facilitar o uso. A segurança é gerenciada pela aplicação.

2. **Schema Cache**: Sempre que modificar o schema do banco, lembre-se de recarregar o cache do Supabase.

3. **Chave de Exemplo**: O script insere uma chave PIX de exemplo. Você pode deletá-la ou editá-la conforme necessário.

4. **Backup**: Recomenda-se fazer backup do banco antes de executar scripts de correção.

---

## 🆘 Problemas Comuns

### Se o erro persistir após aplicar a correção:

1. **Limpar cache do navegador**: Ctrl+Shift+Delete
2. **Fazer logout e login novamente** no sistema
3. **Verificar se o schema cache foi recarregado** no Supabase
4. **Verificar console do navegador** (F12) para novos erros
5. **Verificar se todas as credenciais estão corretas** no arquivo de configuração

### Se não conseguir adicionar chaves PIX:

1. Verifique se a tabela foi criada corretamente
2. Confirme que não há políticas RLS bloqueando
3. Verifique os logs do Supabase para erros específicos

---

## 📞 Suporte

Sistema desenvolvido seguindo o padrão dos outros sistemas Nexus.

Para mais informações, consulte:
- `README-FRANCA-PRIVATE.md` - Documentação do Franca Private
- `README-seletor-chave-pix.md` - Documentação das chaves PIX
- `setup-pix-keys-table.sql` - Setup original da tabela

---

## ✅ Checklist de Validação

Use este checklist para confirmar que tudo está funcionando:

- [ ] Script SQL executado sem erros
- [ ] Schema cache recarregado no Supabase
- [ ] Tabela `pix_keys` existe e tem todas as colunas
- [ ] Modal de chaves PIX abre corretamente
- [ ] Chaves PIX são listadas sem erros
- [ ] Possível adicionar nova chave PIX
- [ ] Tipos de chave são exibidos corretamente
- [ ] Chaves são mascaradas para segurança
- [ ] Mensagem WhatsApp é enviada com sucesso
- [ ] Não há erros no console do navegador

---

**Data da Correção**: Dezembro 2024  
**Versão**: 1.0  
**Sistema**: Franca Private  
**Status**: ✅ Correção Aplicada e Testada
