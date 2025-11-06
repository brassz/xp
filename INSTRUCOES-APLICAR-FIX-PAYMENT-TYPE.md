# Instruções: Aplicar Fix de Payment Type

## Problema

Erro ao registrar pagamento:
```
new row for relation "payments" violates check constraint "payments_payment_type_check"
```

## Causa

O banco de dados tem uma constraint `CHECK` na coluna `payment_type` da tabela `payments` que permite apenas os valores `'partial'` e `'full'`. 

A correção do sistema agora usa valores mais descritivos como:
- `interest_renewal` (renovação - pagamento apenas de juros)
- `capital_payment` (pagamento de capital)
- `early_payment_partial_interest`
- `early_payment_interest_renewal`
- `early_payment_capital_reduction`
- `partial_interest`

## Solução

Execute o script SQL no Supabase para remover a constraint:

### Passo 1: Acessar o Supabase SQL Editor

1. Acesse seu projeto no Supabase
2. Vá em "SQL Editor" no menu lateral
3. Clique em "New query"

### Passo 2: Executar o Script

Cole e execute o seguinte SQL:

```sql
-- Remover a constraint antiga
ALTER TABLE payments 
DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- Atualizar comentário do campo
COMMENT ON COLUMN payments.payment_type IS 'Tipo de operação do pagamento: interest_renewal (renovação), capital_payment, early_payment_partial_interest, early_payment_interest_renewal, early_payment_capital_reduction, partial_interest, ou métodos como dinheiro, pix, cartao';
```

### Passo 3: Verificar

Execute para confirmar que a constraint foi removida:

```sql
SELECT conname, pg_get_constraintdef(oid) 
FROM pg_constraint 
WHERE conrelid = 'payments'::regclass AND conname LIKE '%payment_type%';
```

Se não retornar nenhuma linha com `payments_payment_type_check`, está correto!

### Passo 4: Testar

Agora tente registrar um novo pagamento no sistema. Deve funcionar sem erros.

## Alternativa: Script Completo

Se preferir, use o arquivo `fix-payment-type-constraint.sql` que contém o script completo com verificações.

## Notas Importantes

- ⚠️ **IMPORTANTE**: Este script deve ser executado no banco de produção
- ✅ A constraint é removida de forma segura com `IF EXISTS`
- ✅ Pagamentos já existentes não são afetados
- ✅ O campo continua aceitando TEXT, apenas sem restrição de valores

## Próximos Passos Após Aplicar

Depois de executar o script:

1. Teste registrar um pagamento de renovação (apenas juros)
2. Verifique se a tabela de valores mostra corretamente
3. Confirme que pagamentos de capital também funcionam

## Data

2025-11-06
