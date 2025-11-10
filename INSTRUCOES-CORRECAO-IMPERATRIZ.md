# Correção do Erro de Despesas - Imperatriz Cred

## 🐛 Problema Identificado

**Erro:** `column expenses.date does not exist`

### Causa do Problema

O banco de dados da Imperatriz Cred foi criado com a coluna chamada `expense_date`, mas o código da aplicação espera uma coluna chamada `date`.

## ✅ Solução

Execute o script SQL de correção no banco de dados do Supabase da Imperatriz Cred.

### Passo a Passo

#### 1. Acesse o Supabase da Imperatriz Cred

Acesse: https://eppzphzwwpvpoocospxy.supabase.co

#### 2. Abra o SQL Editor

1. No menu lateral, clique em **SQL Editor**
2. Clique em **New query** ou use uma query existente

#### 3. Execute o Script de Correção

Copie e cole o conteúdo do arquivo `fix-imperatriz-expenses.sql` no SQL Editor e clique em **Run**.

Ou copie o script abaixo:

```sql
-- =====================================================
-- CORREÇÃO DA TABELA EXPENSES - IMPERATRIZ CRED
-- =====================================================

-- PASSO 1: Verificar estrutura atual
SELECT 
    'Estrutura atual:' as info,
    column_name,
    data_type
FROM information_schema.columns 
WHERE table_name = 'expenses' 
AND column_name IN ('date', 'expense_date');

-- PASSO 2: Renomear coluna
DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'expenses' 
        AND column_name = 'expense_date'
    ) THEN
        ALTER TABLE expenses RENAME COLUMN expense_date TO date;
        RAISE NOTICE '✓ Coluna renomeada com sucesso';
    END IF;
END $$;

-- PASSO 3: Atualizar índices
DROP INDEX IF EXISTS idx_expenses_expense_date;
DROP INDEX IF EXISTS idx_expenses_user_expense_date;
DROP INDEX IF EXISTS idx_expenses_category_expense_date;

CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date);
CREATE INDEX IF NOT EXISTS idx_expenses_user_date ON expenses(user_id, date DESC);
CREATE INDEX IF NOT EXISTS idx_expenses_category_date ON expenses(category_id, date DESC);

-- PASSO 4: Verificar resultado
SELECT 
    '=== VERIFICAÇÃO FINAL ===' as info,
    column_name,
    data_type
FROM information_schema.columns 
WHERE table_name = 'expenses' 
AND column_name = 'date';
```

#### 4. Verifique o Resultado

Após executar o script, você deve ver a mensagem:

```
✓ Coluna expense_date renomeada para date com sucesso
```

E na verificação final, deve aparecer:

```
column_name | data_type
------------|----------
date        | date
```

#### 5. Teste a Aplicação

1. Recarregue a página da aplicação Nexus
2. Faça login selecionando **IMPERATRIZ CRED**
3. Acesse a aba **Despesas**
4. Verifique se carrega sem erros

## 📋 Checklist de Verificação

- [ ] Script executado no Supabase
- [ ] Mensagem de sucesso apareceu
- [ ] Coluna `date` existe na tabela `expenses`
- [ ] Índices foram criados
- [ ] Aplicação carrega despesas sem erro
- [ ] Possível criar nova despesa
- [ ] Despesas aparecem na tabela

## 🔍 Verificação Manual (Opcional)

Se quiser verificar manualmente a estrutura da tabela, execute:

```sql
-- Ver todas as colunas da tabela expenses
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'expenses' 
ORDER BY ordinal_position;

-- Ver todos os índices da tabela expenses
SELECT 
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'expenses'
ORDER BY indexname;
```

## ⚠️ Problemas Comuns

### Problema 1: "Permissão negada"
**Solução:** Certifique-se de estar conectado com uma conta que tenha permissões de administrador no Supabase.

### Problema 2: "Tabela expenses não existe"
**Solução:** A tabela expenses precisa ser criada primeiro. Execute o script `setup-expenses-table.sql` antes.

### Problema 3: Script não executa
**Solução:** Execute cada bloco DO $$ separadamente se houver erro.

## 📊 O Que Foi Alterado

### Antes
```
Tabela: expenses
Coluna: expense_date (DATE)
```

### Depois
```
Tabela: expenses
Coluna: date (DATE)
```

### Índices Atualizados

- ❌ `idx_expenses_expense_date` (removido)
- ❌ `idx_expenses_user_expense_date` (removido)
- ❌ `idx_expenses_category_expense_date` (removido)
- ✅ `idx_expenses_date` (criado)
- ✅ `idx_expenses_user_date` (criado)
- ✅ `idx_expenses_category_date` (criado)

## 📝 Observações

- **Dados preservados:** Todos os dados existentes na tabela são mantidos
- **Sem downtime:** A alteração é instantânea
- **Reversível:** Se necessário, pode renomear de volta (não recomendado)
- **Compatibilidade:** Agora totalmente compatível com o código da aplicação

## 🎯 Próximos Passos

Após a correção, a empresa Imperatriz Cred estará totalmente funcional com:

- ✅ Gestão de Despesas
- ✅ Categorias de Despesas
- ✅ Relatórios
- ✅ PDFs com despesas
- ✅ Filtros por data

## 🆘 Suporte

Se o erro persistir após executar o script:

1. Verifique se o script foi executado com sucesso
2. Verifique se há erros no console do navegador (F12)
3. Limpe o cache do navegador
4. Faça logout e login novamente
5. Verifique se a empresa selecionada é "IMPERATRIZ CRED"

---

**Data:** 10/11/2025  
**Empresa:** Imperatriz Cred  
**Arquivo:** fix-imperatriz-expenses.sql  
**Status:** ✅ Solução pronta para aplicação
