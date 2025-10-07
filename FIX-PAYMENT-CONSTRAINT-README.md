# Fix para Erro de Constraint de Pagamento

## Problema
Erro ao registrar pagamento: `new row for relation "payments" violates check constraint "payments_payment_type_check"`

## Causa
A constraint `payments_payment_type_check` na tabela `payments` estava limitada apenas aos valores `'partial'` e `'full'`, mas o código da aplicação utiliza outros tipos de pagamento como:

- `interest_renewal` - Renovação de juros
- `early_payment_partial_interest` - Pagamento antecipado parcial de juros  
- `early_payment_interest_renewal` - Pagamento antecipado com renovação
- `early_payment_capital_reduction` - Pagamento antecipado com redução de capital
- `capital_payment` - Pagamento de capital
- `partial_interest` - Juros parcial
- `adjustment` - Ajuste
- `renewal` - Renovação

## Solução
1. **Arquivo de migração criado**: `fix-payment-type-constraint.sql`
   - Remove a constraint antiga
   - Adiciona nova constraint com todos os tipos de pagamento utilizados
   - Atualiza o comentário da coluna

2. **Arquivos de schema atualizados**:
   - `database-setup.sql` 
   - `NEXUS-DATABASE-COMPLETE.sql`

## Como aplicar a correção

### Opção 1: Executar o arquivo de migração
```sql
\i fix-payment-type-constraint.sql
```

### Opção 2: Executar comandos manualmente
```sql
-- Remover constraint antiga
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- Adicionar nova constraint
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
```

## Verificação
Após aplicar a correção, o sistema deve permitir o registro de pagamentos com todos os tipos utilizados pela aplicação sem erro de constraint.