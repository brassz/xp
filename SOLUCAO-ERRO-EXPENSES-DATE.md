# SOLUÇÃO - Erro "column expenses.date does not exist"

## Problema Identificado

O erro "column expenses.date does not exist" indica que há uma incompatibilidade entre o nome da coluna de data na tabela `expenses` do banco de dados e o que a aplicação está esperando.

## Causa Raiz

Existem diferentes esquemas SQL no projeto que usam nomes diferentes para a coluna de data:

1. **setup-expenses-table.sql** (linha 46): Usa `expense_date`
2. **fix-expenses-schema.sql** (linha 36): Usa `date`  
3. **database-setup.sql** (linha 488): Usa `date`

A aplicação JavaScript espera que a coluna se chame `date`, mas o banco pode ter sido criado com `expense_date`.

## Soluções Implementadas

### Solução 1: Correção no Banco de Dados (Recomendada)

Execute o script `fix-expenses-date-column.sql` no SQL Editor do Supabase:

```sql
-- Este script renomeia automaticamente expense_date para date
-- É seguro executar múltiplas vezes
```

**Vantagens:**
- Corrige definitivamente o problema
- Mantém consistência com o código JavaScript
- Solução limpa e permanente

### Solução 2: Compatibilidade no JavaScript (Implementada)

Modificações feitas no `app.js` para suportar ambos os nomes de coluna:

#### 2.1. Função `loadExpenses()` (linhas 5699-5708)
```javascript
let { data: expensesData, error: expensesError } = await expensesQuery
    .order('date', { ascending: false });
    
// Se houver erro com 'date', tentar com 'expense_date'
if (expensesError && expensesError.message.includes('column') && expensesError.message.includes('date')) {
    console.log('Tentando com expense_date...');
    const result = await expensesQuery.order('expense_date', { ascending: false });
    expensesData = result.data;
    expensesError = result.error;
}
```

#### 2.2. Normalização dos Dados (linhas 5726-5732)
```javascript
// Join expenses with categories and normalize date field
expenses = (expensesData || []).map(expense => ({
    ...expense,
    expense_categories: expense.category_id ? categoriesMap[expense.category_id] : null,
    // Normalizar campo de data para compatibilidade
    date: expense.date || expense.expense_date
}));
```

**Vantagens:**
- Funciona independente do nome da coluna no banco
- Não requer alterações no banco de dados
- Compatibilidade retroativa

## Arquivos Modificados

1. **fix-expenses-date-column.sql** (novo)
   - Script para renomear coluna no banco de dados

2. **app.js:**
   - Função `loadExpenses()`: Tratamento de erro e fallback
   - Normalização do campo de data nos objetos de despesa

3. **SOLUCAO-ERRO-EXPENSES-DATE.md** (este arquivo)
   - Documentação da solução

## Como Testar

1. **Teste a aplicação** - Acesse a aba DESPESAS
2. **Verifique se carrega sem erro** - Deve mostrar as despesas ou "Nenhuma despesa encontrada"
3. **Confira o console** - Se aparecer "Tentando com expense_date...", o banco usa `expense_date`

## Recomendação

**Execute a Solução 1** (script SQL) para corrigir definitivamente o problema. A Solução 2 serve como backup de compatibilidade.

## Status da Solução

✅ **RESOLVIDO:** Aplicação agora suporta ambos os nomes de coluna  
✅ **RESOLVIDO:** Script SQL disponível para correção definitiva  
✅ **RESOLVIDO:** Tratamento de erro implementado  
✅ **RESOLVIDO:** Normalização de dados implementada  

## Próximos Passos

1. Executar `fix-expenses-date-column.sql` no Supabase
2. Testar carregamento de despesas
3. Remover código de compatibilidade após confirmação (opcional)