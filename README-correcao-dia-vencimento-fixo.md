# Correção: Data de Vencimento com Dia Fixo do Mês

## 📋 Problema Identificado

Quando um cliente fazia um pagamento em atraso, a próxima data de vencimento era calculada adicionando 30 dias à data de vencimento anterior. Isso causava uma mudança no dia de referência do mês.

### Exemplo do Problema

**Situação:**
- Empréstimo feito em: **25/11/2024**
- Primeira data de vencimento: **25/12/2024**
- Cliente pagou atrasado em: **28/12/2024**

**Comportamento Anterior (INCORRETO):**
- Sistema calculava: 25/12 + 30 dias = **24/01/2025**
- Próximo vencimento: 24/01 (dia mudou de 25 para 24)
- Se pagasse dia 28/01, próximo seria 27/02
- **Resultado:** O dia de vencimento ia mudando a cada pagamento

**Comportamento Esperado (CORRETO):**
- Próximo vencimento: **25/01/2025** (mantém o dia 25)
- Mesmo que pague dia 28/01, próximo será **25/02/2025**
- **Resultado:** O dia de vencimento sempre será 25, independente de quando o pagamento for feito

## ✅ Solução Implementada

### 1. Nova Função: `calculateNextDueDateKeepingOriginalDay`

Foi criada uma função que calcula a próxima data de vencimento mantendo o dia original do empréstimo.

**Localização:** `app.js`, linhas ~3796-3841

**Lógica:**
1. Identifica o dia do mês em que o empréstimo foi criado (`loan_date`)
2. Pega a data de vencimento atual (`due_date`)
3. Adiciona 1 mês à data de vencimento
4. **Define o dia como o dia original do empréstimo**
5. Trata casos especiais (ex: empréstimo dia 31 em mês com 30 dias)

**Código:**
```javascript
function calculateNextDueDateKeepingOriginalDay(loanDate, currentDueDate) {
    // Pegar o dia do mês da data original do empréstimo (dia de referência)
    const loanDateObj = new Date(loanDate + 'T00:00:00');
    const originalDay = loanDateObj.getDate();
    
    // Pegar a data de vencimento atual
    const currentDueDateObj = new Date(currentDueDate + 'T00:00:00');
    
    // Adicionar 1 mês à data de vencimento atual
    let nextMonth = currentDueDateObj.getMonth() + 1;
    let nextYear = currentDueDateObj.getFullYear();
    
    if (nextMonth > 11) {
        nextMonth = 0;
        nextYear++;
    }
    
    // Criar nova data com o dia original
    let nextDueDate = new Date(nextYear, nextMonth, originalDay);
    
    // Verificar se o dia é válido para o mês
    if (nextDueDate.getDate() !== originalDay) {
        // Usar o último dia do mês se o dia não existir
        nextDueDate = new Date(nextYear, nextMonth + 1, 0);
    }
    
    return formatDateForInput(nextDueDate);
}
```

### 2. Atualizações Realizadas

#### a) Função de Renovação de Empréstimo
**Arquivo:** `app.js`, linha ~2502

**Antes:**
```javascript
const currentDueDate = new Date(loan.due_date);
const newDueDate = new Date(currentDueDate);
newDueDate.setDate(newDueDate.getDate() + 30);
const newDueDateStr = newDueDate.toISOString().split('T')[0];
```

**Depois:**
```javascript
const newDueDateStr = calculateNextDueDateKeepingOriginalDay(loan.loan_date, loan.due_date);
```

#### b) Geração de Comprovante de Pagamento
**Arquivo:** `app.js`, linha ~6784

**Antes:**
```javascript
const today = new Date();
const nextDueDate = new Date(today);
nextDueDate.setDate(today.getDate() + 30);
const nextDueDateString = formatDateForInput(nextDueDate);
```

**Depois:**
```javascript
const nextDueDateStr = calculateNextDueDateKeepingOriginalDay(loan.loan_date, loan.due_date);
const nextDueDateString = nextDueDateStr;
```

#### c) Modal de Mensagem de Pagamento
**Arquivo:** `app.js`, linhas ~7611-7631

**Antes:**
```javascript
const today = new Date();
const nextDate = new Date(today);
nextDate.setDate(nextDate.getDate() + 30);
nextPaymentDate = formatDate(nextDate.toISOString().split('T')[0]);
```

**Depois:**
```javascript
if (loan.loan_date && loan.due_date) {
    const nextDueDate = calculateNextDueDateKeepingOriginalDay(loan.loan_date, loan.due_date);
    nextPaymentDate = formatDate(nextDueDate);
}
```

#### d) Modal de Opções de Renovação
**Arquivo:** `app.js`, linha ~2427

**Antes:**
```javascript
const currentDueDate = new Date(loan.due_date);
const newDueDate = new Date(currentDueDate);
newDueDate.setDate(newDueDate.getDate() + 30);
document.getElementById('renewalNewDueDate').textContent = formatDate(newDueDate.toISOString().split('T')[0]);
```

**Depois:**
```javascript
const newDueDateStr = calculateNextDueDateKeepingOriginalDay(loan.loan_date, loan.due_date);
document.getElementById('renewalNewDueDate').textContent = formatDate(newDueDateStr);
```

#### e) Função Auxiliar de Formatação
**Arquivo:** `app.js`, linhas ~2386-2401

Foi atualizada a função `formatDateToAdd30Days` para aceitar um parâmetro opcional `loanDate` e usar a nova lógica quando disponível:

```javascript
function formatDateToAdd30Days(dateStr, loanDate = null) {
    if (loanDate) {
        return formatNextDueDate(loanDate, dateStr);
    }
    // Fallback antigo: adicionar 30 dias
    const date = new Date(dateStr);
    date.setDate(date.getDate() + 30);
    return formatDate(date.toISOString().split('T')[0]);
}
```

## 🔍 Casos Especiais Tratados

### Caso 1: Meses com Menos Dias
**Situação:** Empréstimo feito dia 31/01, próximo mês é fevereiro (28 ou 29 dias)

**Solução:** 
- A função detecta que fevereiro não tem dia 31
- Define automaticamente para o último dia do mês (28 ou 29/02)
- No mês seguinte, volta para dia 31/03

### Caso 2: Múltiplos Pagamentos Atrasados
**Situação:** Cliente faz vários pagamentos atrasados em dias diferentes

**Solução:**
- Independente do dia do pagamento (28, 29, 30, etc.)
- A próxima data de vencimento sempre será o dia original (ex: 25)
- O sistema mantém consistência ao longo do tempo

### Caso 3: Renovação de Empréstimo
**Situação:** Cliente renova o empréstimo (+30 dias)

**Solução:**
- A renovação agora usa a mesma lógica
- Mantém o dia original do empréstimo
- Exemplo: empréstimo dia 25, renovações sempre serão dia 25

## 🧪 Como Testar

### Teste 1: Pagamento no Dia Correto
1. Criar empréstimo em 25/11/2024
2. Data de vencimento será 25/12/2024
3. Renovar o empréstimo exatamente dia 25/12
4. ✅ **Resultado esperado:** Próximo vencimento = 25/01/2025

### Teste 2: Pagamento com Atraso
1. Criar empréstimo em 25/11/2024
2. Data de vencimento será 25/12/2024
3. Renovar o empréstimo apenas dia 28/12 (3 dias atrasado)
4. ✅ **Resultado esperado:** Próximo vencimento = 25/01/2025 (não 28/01)

### Teste 3: Múltiplos Pagamentos Atrasados
1. Criar empréstimo em 25/11/2024
2. Renovar dia 28/12 → Próximo vencimento: 25/01
3. Renovar dia 27/01 → Próximo vencimento: 25/02
4. Renovar dia 26/02 → Próximo vencimento: 25/03
5. ✅ **Resultado esperado:** Sempre mantém dia 25

### Teste 4: Empréstimo no Dia 31
1. Criar empréstimo em 31/01/2025
2. Renovar em fevereiro (28 dias)
3. ✅ **Resultado esperado:** 
   - Vencimento em fevereiro: 28/02/2025 (último dia do mês)
   - Próximo vencimento: 31/03/2025 (volta para dia 31)

## 📊 Impacto

### ✅ Benefícios

1. **Previsibilidade:** Clientes sabem exatamente qual dia do mês devem pagar
2. **Consistência:** Datas de vencimento não mudam com pagamentos atrasados
3. **Facilita Gestão:** Mais fácil controlar quando os pagamentos vencem
4. **Reduz Confusão:** Elimina dúvidas sobre qual será a próxima data

### ⚠️ Mudança de Comportamento

**Importante:** Esta correção muda o comportamento do sistema em relação às correções anteriores:

- **27/11/2025** - `README-correcao-data-vencimento.md`: Dizia que a data NUNCA deveria ser alterada automaticamente
- **08/11/2025** - `README-correcao-data-vencimento-pagamento.md`: Dizia que a data deveria ser atualizada para +30 dias sempre
- **28/11/2025** - **ESTA CORREÇÃO**: A data é atualizada mas MANTÉM o dia do mês original

A nova abordagem é um meio-termo que:
- ✅ Atualiza a data automaticamente nas renovações (como solicitado antes)
- ✅ MAS mantém o dia de referência original (nova regra)
- ✅ Oferece previsibilidade para o cliente

## 🔄 Compatibilidade

### Empréstimos Existentes
- A função funciona corretamente com empréstimos já cadastrados
- Usa o campo `loan_date` (data de criação) como referência
- Se `loan_date` não estiver disponível, usa fallback de +30 dias

### Parcelas (Installments)
- O sistema de parcelas **NÃO foi alterado**
- Parcelas já mantinham o dia do mês corretamente usando `setMonth()`
- Esta correção se aplica apenas aos empréstimos regulares

## 📝 Notas Técnicas

### Função `setMonth()` vs `setDate()`
- `setDate(date.getDate() + 30)` → Adiciona 30 dias, pode mudar o dia do mês
- `setMonth(date.getMonth() + 1)` → Adiciona 1 mês, mantém o mesmo dia

### Tratamento de Timezone
- Usa a função `parseLocalDate()` existente no código para parsing seguro de datas
- `parseLocalDate()` previne problemas de timezone ao parsear strings no formato `YYYY-MM-DD`
- Cria datas locais sem conversão de fuso horário: `new Date(year, month - 1, day)`
- Formato usado: `YYYY-MM-DD`

### Correção de Bug (28/11/2025)
- **Problema identificado:** Datas estavam sendo parseadas incorretamente, resultando em dia errado (ex: 27 ao invés de 28)
- **Causa:** Uso de `new Date(dateString + 'T00:00:00')` ao invés da função `parseLocalDate()` existente
- **Solução:** Substituído parsing manual por `parseLocalDate()` que já existe no código e trata corretamente timezone

### Fallbacks
- Se `loan_date` não estiver disponível, usa lógica antiga (+30 dias)
- Se houver erro, usa fallback seguro
- Sistema continua funcionando mesmo em casos de dados incompletos

## 📅 Histórico de Correções Relacionadas

1. **08/11/2025** - Implementado atualização automática de data (+30 dias)
2. **27/11/2025** - Removida atualização automática (apenas manual)
3. **28/11/2025** - **ESTA CORREÇÃO:** Atualização automática mantendo dia original

---

**Data da Correção:** 28 de Novembro de 2025  
**Arquivos Modificados:** `app.js`  
**Linhas Afetadas:** ~2330, ~2427, ~2502, ~2386-2401, ~6784-6786, ~7611-7631
