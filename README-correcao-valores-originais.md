# Correção dos Valores Originais dos Empréstimos

## Problema Identificado

O sistema estava **alterando incorretamente o valor original** dos empréstimos na tabela `loans` quando pagamentos eram realizados. Isso causava:

- ❌ Valor original do empréstimo sendo modificado
- ❌ Cálculos incorretos de valores restantes
- ❌ Perda da referência do valor inicial do empréstimo

## Exemplo do Problema

**Cenário:** Empréstimo de R$ 1.300 (R$ 1.000 capital + R$ 300 juros)
- Cliente pagou R$ 1.000 (R$ 300 juros + R$ 700 capital)
- **Problema:** Sistema alterava valor original de R$ 1.000 para R$ 300
- **Resultado Esperado:** Valor original permanece R$ 1.000, valor restante R$ 390 (R$ 300 capital + R$ 90 juros)

## Soluções Implementadas

### 1. Preservação do Valor Original

**Arquivo:** `fix-loan-original-amount-preservation.sql`
- Adicionado campo `original_amount` na tabela `loans`
- Campo `amount` agora representa valor atual (pode ser reduzido)
- Campo `original_amount` **NUNCA** é alterado após criação

### 2. Correção da Lógica de Cálculo

**Função:** `calculateAndShowRemainingAmount()`
- ✅ Sempre usa `original_amount` como base
- ✅ Calcula pagamentos de capital e juros separadamente
- ✅ Valor restante baseado no capital restante + novos juros

### 3. Desabilitação do Recálculo Automático

**Função:** `handlePayment()`
- ❌ Desabilitada função `checkAndRecalculateLoan()`
- ✅ Valores originais **NUNCA** são alterados no banco
- ✅ Apenas status e datas de vencimento são atualizados

### 4. Interface Melhorada

**Modal de Pagamento:**
- ✅ Seção "Pagamentos Já Realizados"
- ✅ Separação clara: Capital Pago, Juros Pagos, Total Pago
- ✅ Valores sempre baseados no empréstimo original

## Como Funciona Agora

### Exemplo Prático

**Empréstimo Original:**
- Capital: R$ 1.000,00
- Juros: R$ 300,00 (30%)
- Total: R$ 1.300,00

**Após Pagamento de R$ 1.000:**
- Capital Pago: R$ 700,00 (R$ 1.000 - R$ 300 juros)
- Juros Pagos: R$ 300,00
- Capital Restante: R$ 300,00 (R$ 1.000 - R$ 700)
- Juros Restantes: R$ 90,00 (R$ 300 × 30%)
- **Valor Restante: R$ 390,00**

### Lógica de Cálculo

```javascript
// SEMPRE usar valor original
const originalCapital = parseFloat(loan.original_amount || loan.amount);
const originalInterest = originalCapital * (interestRate / 100);

// Calcular pagamentos
if (totalPaid > originalInterest) {
    capitalPaid = totalPaid - originalInterest;
    interestPaid = originalInterest;
} else {
    capitalPaid = 0;
    interestPaid = totalPaid;
}

// Calcular restante
const remainingCapital = Math.max(0, originalCapital - capitalPaid);
const remainingInterest = remainingCapital * (interestRate / 100);
const remainingAmount = remainingCapital + remainingInterest;
```

## Arquivos Modificados

### 1. Banco de Dados
- `fix-loan-original-amount-preservation.sql` - Script de correção

### 2. JavaScript (`app.js`)
- `calculateAndShowRemainingAmount()` - Lógica corrigida
- `calculateLoanRemainingAmount()` - Usa valor original
- `calculateBatchLoanRemainingAmounts()` - Cálculo em lote corrigido
- `handlePayment()` - Recálculo automático desabilitado

### 3. Interface (`index.html`)
- Modal de pagamento com seção "Pagamentos Já Realizados"
- Separação visual de capital e juros pagos

## Instalação

1. **Execute o script SQL no Supabase:**
   ```sql
   -- Executar o conteúdo do arquivo fix-loan-original-amount-preservation.sql
   ```

2. **As alterações no frontend já estão implementadas nos arquivos:**
   - `index.html`
   - `app.js`

## Características da Correção

### ✅ Benefícios
- **Preservação Total:** Valores originais nunca mudam
- **Cálculos Corretos:** Baseados sempre no valor original
- **Transparência:** Interface mostra separação clara
- **Retrocompatibilidade:** Funciona com empréstimos existentes
- **Performance:** Cálculos otimizados

### 🔒 Garantias
- Campo `original_amount` é **somente leitura** após criação
- Função de recálculo automático **desabilitada**
- Todos os cálculos baseados em **valores originais**
- Interface sempre mostra **valores corretos**

## Validação

Para validar se a correção está funcionando:

1. **Criar novo empréstimo** de R$ 1.000 com 30% juros
2. **Fazer pagamento** de R$ 1.000
3. **Verificar:**
   - Valor original permanece R$ 1.000
   - Capital pago: R$ 700
   - Juros pagos: R$ 300
   - Valor restante: R$ 390 (R$ 300 capital + R$ 90 juros)

## Consultas SQL de Verificação

```sql
-- Verificar se valores originais estão preservados
SELECT 
    id,
    original_amount as "Valor Original",
    amount as "Valor Atual",
    (original_amount - amount) as "Diferença",
    created_at
FROM loans 
WHERE original_amount IS NOT NULL
ORDER BY created_at DESC;

-- Verificar cálculos de pagamentos
SELECT 
    l.id,
    l.original_amount,
    SUM(p.amount) as total_pago,
    (l.original_amount * l.interest_rate / 100) as juros_originais
FROM loans l
LEFT JOIN payments p ON p.loan_id = l.id
GROUP BY l.id, l.original_amount, l.interest_rate
ORDER BY l.created_at DESC;
```