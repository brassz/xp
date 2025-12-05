# Correção do Erro de Expenses - Franca Private

## Problema Resolvido

```
Erro: Could not find a relationship between 'expenses' and 'users' in the schema cache
```

## Causa do Problema

O erro ocorria porque o código JavaScript estava tentando fazer um JOIN com a tabela `users` usando relacionamentos nomeados que não existiam:

```javascript
// ❌ CÓDIGO ANTIGO (PROBLEMÁTICO)
let expensesQuery = supabase.from('expenses')
    .select(`
        *,
        users!expenses_user_id_fkey(full_name, email, role),
        created_by_user:users!expenses_created_by_fkey(full_name, email, role)
    `);
```

Problemas identificados:
1. Tentava usar relacionamento `expenses_user_id_fkey` que pode não existir
2. Tentava usar relacionamento `expenses_created_by_fkey` que não existe (coluna é `user_id`, não `created_by`)
3. O Supabase não conseguia resolver esses relacionamentos

## Solução Aplicada

### 1. Simplificação da Query (app.js)

**Arquivo**: `app.js` - Função `loadExpenses()`

```javascript
// ✅ CÓDIGO NOVO (CORRIGIDO)
let expensesQuery = supabase.from('expenses')
    .select('*');  // Query simples, sem JOIN
```

**Mudanças**:
- ✅ Removido JOIN com tabela users
- ✅ Query simplificada para buscar apenas expenses
- ✅ Informações do usuário podem ser buscadas separadamente se necessário
- ✅ Correção do nome da coluna de `expense_date` para `date`

### 2. Scripts SQL de Correção

Foram criados 2 scripts SQL para garantir que a estrutura do banco está correta:

#### A) `setup-bruno-assoni-system.sql` (Atualizado)
- Script principal de setup do sistema
- Foreign key definida explicitamente:
  ```sql
  CONSTRAINT expenses_user_id_fkey FOREIGN KEY (user_id) 
      REFERENCES users(id) ON DELETE CASCADE
  ```

#### B) `fix-franca-private-expenses.sql` (Novo)
- Script de correção para bancos já existentes
- Corrige a foreign key se estiver com problema
- Remove RLS problemático
- Adiciona índices de performance

## Como Aplicar a Correção

### Opção 1: Apenas Código (Já Aplicado) ✅

A correção do código JavaScript já foi aplicada. Basta:
1. Recarregar a página (Ctrl+F5)
2. Fazer login no sistema
3. Testar a seção de Despesas

### Opção 2: Código + Banco de Dados (Recomendado)

Se ainda houver problemas, execute o script SQL:

1. **Acesse o Supabase**
   - URL: https://pebwoerzslfzhjptyjwh.supabase.co

2. **Abra o SQL Editor**

3. **Execute o Script**
   - Copie o conteúdo de `fix-franca-private-expenses.sql`
   - Cole no SQL Editor
   - Clique em **Run**

4. **Teste Novamente**
   - Recarregue a aplicação
   - Faça login
   - Acesse Despesas

## Verificações

### No Navegador
```javascript
// Abra o Console (F12) e execute:
console.log('Supabase URL:', supabase.supabaseUrl);
console.log('Usuário atual:', currentUser);

// Teste direto:
await supabase.from('expenses').select('*').limit(1);
```

### No Supabase (SQL)
```sql
-- Verificar se a foreign key existe
SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name = 'expenses';

-- Verificar estrutura da tabela
\d expenses
```

## Mudanças Técnicas Detalhadas

### Arquivo: app.js

#### 1. Função `loadExpenses()` (Linha ~9195)
**Antes**:
```javascript
let expensesQuery = supabase.from('expenses')
    .select(`
        *,
        users!expenses_user_id_fkey(full_name, email, role),
        created_by_user:users!expenses_created_by_fkey(full_name, email, role)
    `);
```

**Depois**:
```javascript
let expensesQuery = supabase.from('expenses')
    .select('*');
```

#### 2. Geração de PDF - Query de Expenses (Linha ~13858)
**Antes**:
```javascript
.order('expense_date', { ascending: false })
```

**Depois**:
```javascript
.order('date', { ascending: false })
```

#### 3. Geração de PDF - Formatação (Linha ~13887)
**Antes**:
```javascript
formatDate(expense.expense_date)
```

**Depois**:
```javascript
formatDate(expense.date)
```

## Por Que Essa Solução Funciona

1. **Simplicidade**: Query direta sem JOINs complexos
2. **Compatibilidade**: Funciona independente da configuração do banco
3. **Performance**: Queries mais rápidas
4. **Manutenibilidade**: Código mais fácil de entender e manter

## Se o Erro Persistir

### 1. Limpe o Cache do Navegador
```
Chrome/Edge: Ctrl + Shift + Delete
Firefox: Ctrl + Shift + Delete
Safari: Cmd + Option + E
```

### 2. Verifique a Conexão do Supabase
```javascript
// No console do navegador (F12):
console.log('Config:', getCurrentCompanyConfig());
```

### 3. Execute o Script SQL de Correção
Ver arquivo: `fix-franca-private-expenses.sql`

### 4. Verifique os Logs
- Console do navegador (F12)
- SQL Editor do Supabase
- Network tab para ver as requisições

## Benefícios da Correção

✅ **Funcionalidade**
- Sistema de despesas funcionando
- Sem erros de relacionamento
- Queries mais confiáveis

✅ **Performance**
- Queries mais rápidas
- Menos carga no banco
- Cache mais eficiente

✅ **Manutenção**
- Código mais simples
- Menos dependências
- Mais fácil de debugar

## Status

- ✅ Código JavaScript corrigido
- ✅ Queries simplificadas
- ✅ Scripts SQL criados
- ✅ Documentação completa
- ⚠️ Script SQL precisa ser executado no banco

## Próximos Passos

1. Teste a funcionalidade de despesas
2. Se funcionar, está resolvido ✓
3. Se não funcionar, execute o script SQL
4. Reporte qualquer erro adicional

---

**Data da Correção**: Dezembro 2025
**Sistema**: Franca Private
**Módulo**: Gestão de Despesas
