# Correção: Erro ao Criar Empréstimo - original_amount

## Problema
Ao tentar criar um novo empréstimo, o sistema apresentava o seguinte erro:
```
Erro ao criar empréstimo: null value in column "original_amount" of relation "loans" violates not-null constraint
```

## Causa
O erro ocorria porque:

1. **Campo original_amount ausente no código JavaScript**: A função `handleNewLoan` no arquivo `app.js` não estava incluindo o campo `original_amount` ao criar novos empréstimos.

2. **Restrição NOT NULL no banco**: O campo `original_amount` foi adicionado posteriormente ao banco de dados com uma restrição NOT NULL, mas o código JavaScript não foi atualizado para incluir este campo.

## Solução Implementada

### 1. Correção no Código JavaScript
**Arquivo alterado:** `app.js`

**Função:** `handleNewLoan` (linhas 2131-2177)

**Mudança:**
```javascript
// ANTES
const formData = {
    client_id: document.getElementById('loanClient').value,
    amount: parseFloat(document.getElementById('loanAmount').value),
    interest_rate: parseFloat(document.getElementById('loanInterest').value),
    // ... outros campos
};

// DEPOIS  
const loanAmount = parseFloat(document.getElementById('loanAmount').value);

const formData = {
    client_id: document.getElementById('loanClient').value,
    amount: loanAmount,
    original_amount: loanAmount, // ← CAMPO ADICIONADO
    interest_rate: parseFloat(document.getElementById('loanInterest').value),
    // ... outros campos
};
```

### 2. Script SQL de Correção
**Arquivo criado:** `fix-loan-creation-null-amount-error.sql`

Este script:
- Verifica se a coluna `original_amount` existe
- Adiciona a coluna se necessário
- Preenche valores NULL com o valor atual de `amount`
- Define a coluna como NOT NULL
- Adiciona comentários e índices

### 3. Como Aplicar a Correção

#### Para Bancos Existentes:
```sql
-- Execute o script SQL
\i fix-loan-creation-null-amount-error.sql
```

#### Para Novos Bancos:
O código JavaScript já está corrigido, então novos empréstimos serão criados corretamente.

## Validação

Após aplicar a correção:

1. **Teste de criação de empréstimo**: Crie um novo empréstimo através da interface
2. **Verificação no banco**: Confirme que o campo `original_amount` está sendo preenchido
3. **Logs do sistema**: Não devem mais aparecer erros relacionados ao `original_amount`

## Arquivos Modificados

- ✅ `app.js` - Função `handleNewLoan` atualizada
- ✅ `fix-loan-creation-null-amount-error.sql` - Script de correção criado
- ✅ `README-fix-loan-creation-error.md` - Documentação da correção

## Prevenção

Para evitar problemas similares no futuro:

1. **Sempre atualizar o código JavaScript** quando adicionar novos campos obrigatórios no banco
2. **Testar criação de registros** após mudanças no schema do banco
3. **Manter sincronização** entre o schema do banco e o código da aplicação

## Status
✅ **RESOLVIDO** - O erro foi corrigido e novos empréstimos podem ser criados normalmente.