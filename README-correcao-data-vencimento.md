# Correção: Data de Vencimento do Empréstimo

## Problema Identificado

A data de vencimento dos empréstimos estava sendo alterada **automaticamente** em situações onde não deveria, especificamente:

1. ❌ **Pagamento normal em empréstimo ativo**: Ao registrar um pagamento parcial ou total em um empréstimo que ainda estava dentro do prazo (não vencido), o sistema automaticamente mudava a data de vencimento para +30 dias a partir da data do pagamento.

2. ❌ **Reativação de empréstimo vencido**: Quando um empréstimo vencido recebia um pagamento parcial, o sistema reativava o empréstimo mas também alterava automaticamente a data de vencimento para +30 dias.

## Regra de Negócio Correta

**A data de vencimento de um empréstimo NUNCA deve ser alterada automaticamente. Ela só deve ser mudada quando o usuário explicitamente solicitar essa alteração.**

### Situações onde a data de vencimento PODE ser alterada:

✅ **Renovação Explícita (Botão "RENOVAR 30+")**
   - Quando o usuário clica no botão de renovação e escolhe uma das opções (juros completos, juros parciais, ou capital)
   - Neste caso, o sistema adiciona +30 dias à data de vencimento atual

✅ **Alteração Manual pelo Usuário**
   - No modal de pagamento, há um checkbox "Alterar data de vencimento"
   - Quando marcado, o usuário pode definir manualmente uma nova data de vencimento
   - Esta é a ÚNICA forma de alterar a data durante um pagamento normal

✅ **Edição do Empréstimo**
   - Na tela de edição do empréstimo, o usuário pode alterar a data de vencimento manualmente

### Situações onde a data de vencimento NÃO deve ser alterada:

❌ **Pagamento parcial ou total em empréstimo ativo**
   - A data de vencimento permanece a mesma
   - O usuário deve marcar explicitamente o checkbox se quiser alterá-la

❌ **Reativação de empréstimo vencido**
   - Quando um empréstimo vencido recebe pagamento, seu status volta para 'active'
   - MAS a data de vencimento original é mantida
   - O usuário deve marcar explicitamente o checkbox se quiser alterá-la

## Mudanças Implementadas

### 1. Função `handlePayment` (app.js, linhas ~2732-2774)

**ANTES:**
```javascript
// Empréstimo vencido que recebe pagamento
if (changeDueDate && newDueDate) {
    updateData.due_date = newDueDate;
} else {
    // PROBLEMA: Alterava automaticamente para +30 dias
    const newDueDateObj = new Date(paymentDateObj);
    newDueDateObj.setDate(newDueDateObj.getDate() + 30);
    updateData.due_date = newDueDateFormatted;
}

// Empréstimo não vencido que recebe pagamento
if (changeDueDate && newDueDate) {
    updateData.due_date = newDueDate;
} else {
    // PROBLEMA: Alterava automaticamente para +30 dias
    const newDueDateObj = new Date(paymentDateObj);
    newDueDateObj.setDate(newDueDateObj.getDate() + 30);
    updateData.due_date = newDueDateFormatted;
}
```

**DEPOIS:**
```javascript
// Empréstimo vencido que recebe pagamento
if (changeDueDate && newDueDate) {
    // Usuário escolheu alterar a data manualmente
    updateData.due_date = newDueDate;
    
    // Registrar nota sobre a reativação com nova data
    const reactivationNote = `EMPRÉSTIMO REATIVADO: Status alterado de 'vencido' para 'ativo'. Nova data de vencimento: ${updateData.due_date} (definida manualmente pelo usuário). Valor restante: R$ ${remainingAmountAfterPayment.toFixed(2)}`;
}
// SOLUÇÃO: NÃO alterar automaticamente a data de vencimento - manter a data original

// Empréstimo não vencido que recebe pagamento
if (changeDueDate && newDueDate) {
    // Usuário escolheu alterar a data manualmente
    updateData.due_date = newDueDate;
}
// SOLUÇÃO: NÃO alterar automaticamente a data de vencimento em pagamentos normais
```

### 2. Mensagem de Sucesso (app.js, linhas ~2806-2809)

**ANTES:**
```javascript
if (changeDueDate && newDueDate) {
    successMessage += `\n\n📅 DATA DE VENCIMENTO ALTERADA!\n• Nova data: ${formatDate(newDueDate)}`;
} else if (updateData && updateData.due_date && !recalcInfo.shouldRecalculate) {
    // PROBLEMA: Mostrava mensagem mesmo quando não foi alterado pelo usuário
    successMessage += `\n\n📅 DATA DE VENCIMENTO ATUALIZADA!\n• Nova data: ${formatDate(updateData.due_date)}\n• (+30 dias a partir do pagamento)`;
}
```

**DEPOIS:**
```javascript
// Adicionar informação sobre alteração de data de vencimento (APENAS se o usuário alterou manualmente)
if (changeDueDate && newDueDate) {
    successMessage += `\n\n📅 DATA DE VENCIMENTO ALTERADA!\n• Nova data: ${formatDate(newDueDate)}`;
}
// SOLUÇÃO: Não mostrar mensagem de alteração se não foi feita pelo usuário
```

## Funções que Continuam Alterando a Data de Vencimento

As seguintes funções continuam alterando a data de vencimento porque são **ações explícitas** do usuário:

1. ✅ `handleOldLoanRenewal` (linha ~2305): Renovação com pagamento de juros completos
2. ✅ `handleNewRenewalPayment` (linha ~2475): Renovação com opções (juros/capital)
3. ✅ `handleEditLoan` (linha ~2940): Edição manual do empréstimo

## Como Testar

### Teste 1: Pagamento Parcial em Empréstimo Ativo
1. Criar um empréstimo com vencimento em 30 dias
2. Fazer um pagamento parcial hoje (sem marcar o checkbox de alterar data)
3. ✅ **Resultado esperado**: Data de vencimento permanece a mesma (30 dias no futuro)

### Teste 2: Reativação de Empréstimo Vencido
1. Ter um empréstimo com vencimento no passado (status: vencido)
2. Fazer um pagamento parcial (sem marcar o checkbox de alterar data)
3. ✅ **Resultado esperado**: 
   - Status muda para 'active'
   - Data de vencimento permanece a mesma (data original)

### Teste 3: Alteração Manual da Data
1. Abrir modal de pagamento
2. Marcar checkbox "Alterar data de vencimento"
3. Definir nova data manualmente
4. Registrar pagamento
5. ✅ **Resultado esperado**: Data de vencimento é alterada para a data escolhida

### Teste 4: Renovação Explícita
1. Clicar no botão "RENOVAR 30+" de um empréstimo
2. Escolher uma opção (juros completos, parciais ou capital)
3. Confirmar renovação
4. ✅ **Resultado esperado**: Data de vencimento é alterada para +30 dias

## Impacto

✅ **Positivo:**
- A data de vencimento original do empréstimo é preservada
- Maior controle e previsibilidade nas datas de vencimento
- Comportamento mais intuitivo e esperado pelos usuários
- Reduz erros e confusão sobre datas de vencimento

⚠️ **Atenção:**
- Empréstimos vencidos que recebem pagamento voltam para 'active' mas mantêm a data de vencimento original
- Se o usuário quiser estender a data de vencimento ao fazer um pagamento, deve marcar explicitamente o checkbox "Alterar data de vencimento"
- Para renovar formalmente um empréstimo com +30 dias, deve usar o botão "RENOVAR 30+"

## Data da Correção
27 de Novembro de 2025
