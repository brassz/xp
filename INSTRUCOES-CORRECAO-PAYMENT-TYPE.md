# Correção do Erro de Constraint payment_type

## Problema Identificado

O erro "new row for relation 'payments' violates check constraint 'payments_payment_type_check'" ocorre porque há uma incompatibilidade entre:

1. **Valores do formulário**: `dinheiro`, `pix`, `cartao`
2. **Constraint do banco**: só aceita `partial` e `full`

## Solução

Execute o script SQL `fix-payment-type-constraint.sql` no seu banco de dados para corrigir a constraint.

### Se estiver usando Supabase:
1. Acesse o painel do Supabase
2. Vá para SQL Editor
3. Execute o conteúdo do arquivo `fix-payment-type-constraint.sql`

### Se estiver usando PostgreSQL local:
```bash
psql -h localhost -U seu_usuario -d loan_system -f fix-payment-type-constraint.sql
```

### Se estiver usando outro banco:
Adapte o script SQL conforme necessário para seu sistema de banco de dados.

## Alterações Feitas

1. **Arquivo `database-setup.sql`**: Atualizada a constraint para aceitar todos os valores válidos
2. **Arquivo `fix-payment-type-constraint.sql`**: Script de migração para corrigir bancos existentes

## Valores Válidos Após a Correção

- `dinheiro`, `pix`, `cartao` (métodos de pagamento do formulário)
- `partial`, `full` (tipos de pagamento)
- `interest`, `principal`, `adjustment`, `renewal`, `interest_renewal`, `capital_payment`, `partial_interest` (tipos especiais)

Após executar a correção, o sistema deve funcionar normalmente para registrar pagamentos.