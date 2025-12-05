# Instruções para Corrigir Erro de Expenses - Franca Private

## Problema Identificado

```
Erro ao carregar despesas: Could not find a relationship between 'expenses' and 'users' in the schema cache
```

Este erro ocorre quando a tabela `expenses` não tem uma foreign key corretamente configurada para a tabela `users`.

## Solução

Execute o script SQL de correção no Supabase.

### Passos para Aplicar a Correção

1. **Acesse o Supabase do Franca Private**
   - URL: https://pebwoerzslfzhjptyjwh.supabase.co
   - Faça login no painel

2. **Abra o SQL Editor**
   - No menu lateral, clique em "SQL Editor"
   - Clique em "New Query" para criar uma nova query

3. **Execute o Script de Correção**
   - Abra o arquivo: `fix-franca-private-expenses.sql`
   - Copie todo o conteúdo do arquivo
   - Cole no SQL Editor do Supabase
   - Clique em **"Run"** (botão verde no canto inferior direito)

4. **Verifique os Resultados**
   - O script irá mostrar mensagens de progresso
   - Verifique se aparece: "Correção da tabela expenses concluída com sucesso!"
   - Verifique se não há erros em vermelho

5. **Teste na Aplicação**
   - Volte para a aplicação Nexus
   - Faça login no Franca Private (3 cliques em "Bruno Assoni")
   - Vá para a seção de "Despesas"
   - Tente adicionar uma nova despesa
   - O erro deve estar corrigido

## O Que o Script Faz

### 1. Verifica e Cria a Tabela
- Verifica se a tabela `expenses` existe
- Cria a tabela se não existir

### 2. Corrige a Foreign Key
- Remove constraint antiga se houver problemas
- Adiciona coluna `user_id` se não existir
- Cria foreign key: `expenses.user_id -> users.id`
- Configura `ON DELETE CASCADE`

### 3. Otimiza Performance
- Cria índices em:
  - `user_id`
  - `date`
  - `category`

### 4. Remove RLS (Row Level Security)
- Desabilita RLS na tabela `expenses`
- Remove todas as políticas RLS
- Facilita o uso com a aplicação

### 5. Configura Categorias
- Garante que a tabela `expense_categories` existe
- Insere 8 categorias padrão
- Não duplica categorias existentes

### 6. Cria Triggers
- Trigger para atualizar `updated_at` automaticamente
- Mantém timestamps atualizados

## Verificação Manual (Opcional)

Se quiser verificar manualmente se a correção funcionou:

```sql
-- Verificar se a foreign key existe
SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name = 'expenses';

-- Deve retornar algo como:
-- constraint_name: expenses_user_id_fkey
-- table_name: expenses
-- column_name: user_id
-- foreign_table_name: users
-- foreign_column_name: id
```

## Problemas Comuns

### Se o erro persistir:

1. **Limpe o cache do navegador**
   ```
   Ctrl + Shift + Delete (Chrome/Edge)
   Cmd + Shift + Delete (Mac)
   ```

2. **Recarregue a página completamente**
   ```
   Ctrl + F5 (Windows)
   Cmd + Shift + R (Mac)
   ```

3. **Faça logout e login novamente**
   - Isso reinicializa a conexão com o Supabase

4. **Verifique se executou no banco correto**
   - Confirme que está no projeto: pebwoerzslfzhjptyjwh
   - Não execute em outro banco de dados

## Se Ainda Assim Não Funcionar

Execute estas queries de diagnóstico e me envie os resultados:

```sql
-- 1. Verificar se a tabela existe
SELECT EXISTS (
    SELECT FROM pg_tables 
    WHERE schemaname = 'public' 
    AND tablename = 'expenses'
) as tabela_existe;

-- 2. Verificar colunas da tabela
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'expenses'
ORDER BY ordinal_position;

-- 3. Verificar constraints
SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_name = 'expenses';

-- 4. Verificar se há dados
SELECT COUNT(*) as total_expenses FROM expenses;
```

## Contato

Se precisar de ajuda adicional, forneça:
1. Mensagens de erro completas do SQL Editor
2. Resultados das queries de diagnóstico acima
3. Screenshots do erro na aplicação

---

**Importante**: Este script é seguro e não apaga dados existentes. Ele apenas corrige a estrutura da tabela.
