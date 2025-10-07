# 🚨 CORREÇÃO URGENTE - Erro de Constraint de Pagamento

## Problema Atual
```
Erro ao registrar pagamento: new row for relation "payments" violates check constraint "payments_payment_type_check"
```

## ⚡ SOLUÇÃO IMEDIATA

### Passo 1: Acesse o Supabase
1. Acesse o painel do Supabase da empresa Mogiana
2. Vá para **SQL Editor**

### Passo 2: Execute o comando de correção
Copie e cole o seguinte comando SQL no SQL Editor e execute:

```sql
-- CORREÇÃO URGENTE: Fix payment_type constraint
-- Remove a constraint antiga que está causando o erro
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- Adiciona nova constraint com todos os tipos de pagamento utilizados pela aplicação
ALTER TABLE payments ADD CONSTRAINT payments_payment_type_check 
CHECK (payment_type IN (
    'partial', 
    'full', 
    'interest_renewal', 
    'early_payment_partial_interest', 
    'early_payment_interest_renewal', 
    'early_payment_capital_reduction', 
    'capital_payment', 
    'partial_interest', 
    'adjustment',
    'renewal'
));

-- Atualiza o comentário da coluna
COMMENT ON COLUMN payments.payment_type IS 'Tipo do pagamento: partial (parcial), full (total), interest_renewal (renovação de juros), early_payment_partial_interest (pagamento antecipado parcial de juros), early_payment_interest_renewal (pagamento antecipado com renovação), early_payment_capital_reduction (pagamento antecipado com redução de capital), capital_payment (pagamento de capital), partial_interest (juros parcial), adjustment (ajuste), renewal (renovação)';
```

### Passo 3: Verificação
Após executar o comando, teste o registro de pagamento novamente. O erro deve ser resolvido.

## 📋 O que foi corrigido?
- A constraint antiga só permitia `'partial'` e `'full'`
- A aplicação usa outros tipos como `'interest_renewal'`, `'capital_payment'`, etc.
- Agora todos os tipos utilizados pela aplicação estão permitidos

## ✅ Resultado Esperado
Após aplicar esta correção, você poderá registrar pagamentos sem erro de constraint.

---
**IMPORTANTE**: Execute este comando o mais rápido possível para resolver o problema de registro de pagamentos.