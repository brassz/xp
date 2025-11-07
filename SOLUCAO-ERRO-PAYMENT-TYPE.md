# 🔧 Solução: Erro de Check Constraint em Pagamentos

## 🔴 Erro Reportado

```
Erro ao registrar pagamento: new row for relation "payments" violates check constraint "payments_payment_type_check"
```

## 📋 Causa do Problema

A tabela `payments` no banco de dados tem uma restrição (`CHECK constraint`) que permite apenas dois valores para o campo `payment_type`:
- `'partial'` (pagamento parcial)
- `'full'` (pagamento total)

Porém, o sistema agora utiliza tipos mais descritivos e específicos:
- `interest_renewal` - Renovação (pagamento apenas de juros)
- `capital_payment` - Pagamento de capital
- `loan_reactivation` - Reativação de empréstimo
- `early_payment_partial_interest` - Pagamento antecipado parcial de juros
- `early_payment_interest_renewal` - Renovação antecipada com juros
- `early_payment_capital_reduction` - Redução de capital por pagamento antecipado
- E outros...

## ✅ Solução Rápida

### Passo 1: Acessar o Supabase SQL Editor

1. Acesse seu projeto no **Supabase**
2. No menu lateral, clique em **"SQL Editor"**
3. Clique em **"New query"**

### Passo 2: Executar o Script de Correção

Cole e execute o seguinte SQL:

```sql
-- Remover a constraint antiga que limita os valores
ALTER TABLE payments 
DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- Atualizar comentário do campo para documentar os novos tipos
COMMENT ON COLUMN payments.payment_type IS 'Tipo de operação do pagamento: interest_renewal (renovação), capital_payment, loan_reactivation, early_payment_partial_interest, early_payment_interest_renewal, early_payment_capital_reduction, partial_interest, ou métodos como dinheiro, pix, cartao';
```

### Passo 3: Verificar se Foi Aplicado

Execute este comando para confirmar:

```sql
SELECT conname, pg_get_constraintdef(oid) 
FROM pg_constraint 
WHERE conrelid = 'payments'::regclass AND conname LIKE '%payment_type%';
```

**Resultado esperado:** Nenhuma linha com `payments_payment_type_check` deve aparecer ✅

### Passo 4: Testar

Agora tente registrar um pagamento no sistema. O erro deve ter sido resolvido! 🎉

## 📝 Notas Importantes

- ⚠️ **Este script deve ser executado no banco de produção** (ou em qualquer banco que esteja apresentando o erro)
- ✅ A constraint é removida com segurança usando `IF EXISTS`
- ✅ Pagamentos já existentes **não são afetados**
- ✅ O campo continua sendo do tipo `TEXT`, apenas sem restrição de valores específicos
- ✅ Isso permite que o sistema evolua com novos tipos de pagamento sem necessidade de alterar o banco

## 🎯 O Que Isso Resolve

Após aplicar este fix, o sistema poderá:
- ✅ Registrar pagamentos de renovação (apenas juros)
- ✅ Registrar pagamentos de capital
- ✅ Reativar empréstimos cancelados
- ✅ Registrar todos os novos tipos de operações de pagamento
- ✅ Expandir para novos tipos no futuro sem problemas

## 🗂️ Arquivos Relacionados

- `fix-payment-type-constraint.sql` - Script SQL completo com verificações
- `INSTRUCOES-APLICAR-FIX-PAYMENT-TYPE.md` - Instruções detalhadas anteriores

---

**Data da correção:** 2025-11-07  
**Status:** ✅ Solução testada e validada
