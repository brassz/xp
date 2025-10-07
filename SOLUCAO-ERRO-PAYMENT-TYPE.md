# Solução para Erro de Constraint payment_type

## Problema Identificado

**Erro:** `new row for relation "payments" violates check constraint "payments_payment_type_check"`

**Causa:** A constraint da tabela `payments` só permite os valores `'partial'` e `'full'` para o campo `payment_type`, mas a aplicação está tentando usar outros valores como:

- `'renewal'` (Renovação)
- `'interest_renewal'` (Renovação de Juros)
- `'quitacao'` (Quitação)
- `'dinheiro'` (Dinheiro)
- `'pix'` (Pix)
- `'cartao'` (Cartão)
- `'interest'` (Apenas Juros)
- `'principal'` (Apenas Principal)
- `'adjustment'` (Ajuste/Recálculo)
- `'capital_payment'` (Pagamento Capital)
- `'partial_interest'` (Juros Parcial)
- E outros tipos de pagamento

## Solução

### 1. Executar no Supabase SQL Editor

Para a **Empresa 3 MOGIANA** (https://eemfnpefgojllvzzaimu.supabase.co):

1. Acesse o painel do Supabase
2. Vá em **SQL Editor**
3. Execute o seguinte comando:

```sql
-- Remover a constraint existente
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- Adicionar nova constraint com todos os tipos válidos
ALTER TABLE payments ADD CONSTRAINT payments_payment_type_check 
CHECK (payment_type IN (
    'partial',                          -- Pagamento parcial
    'full',                            -- Pagamento total
    'dinheiro',                        -- Método: Dinheiro
    'pix',                             -- Método: Pix
    'cartao',                          -- Método: Cartão
    'interest',                        -- Apenas Juros
    'principal',                       -- Apenas Principal
    'adjustment',                      -- Ajuste/Recálculo
    'renewal',                         -- Renovação
    'interest_renewal',                -- Renovação (Juros)
    'early_payment_interest_renewal',  -- Pagamento Antecipado - Renovação
    'early_payment_partial_interest',  -- Pagamento Antecipado Parcial de Juros
    'early_payment_capital_reduction', -- Pagamento Antecipado com Redução de Capital
    'capital_payment',                 -- Pagamento Capital
    'partial_interest',                -- Juros Parcial
    'quitacao'                         -- Quitação
));

-- Atualizar comentário da coluna
COMMENT ON COLUMN payments.payment_type IS 'Tipo do pagamento: partial, full, dinheiro, pix, cartao, interest, principal, adjustment, renewal, interest_renewal, early_payment_interest_renewal, early_payment_partial_interest, early_payment_capital_reduction, capital_payment, partial_interest, quitacao';
```

### 2. Aplicar para Todas as Empresas

**IMPORTANTE:** Este mesmo problema pode ocorrer nas outras empresas. Recomenda-se aplicar a mesma correção para:

- **Empresa 1:** https://mhtxyxizfnxupwmilith.supabase.co
- **Empresa 2:** https://dtifsfzmnjnllzzlndxv.supabase.co

### 3. Verificação

Após executar o SQL, você pode verificar se a constraint foi aplicada corretamente:

```sql
SELECT conname, consrc 
FROM pg_constraint 
WHERE conname = 'payments_payment_type_check';
```

## Tipos de Pagamento Suportados

A aplicação utiliza os seguintes tipos de pagamento:

| Código | Descrição |
|--------|-----------|
| `partial` | Pagamento parcial |
| `full` | Pagamento total |
| `dinheiro` | Método: Dinheiro |
| `pix` | Método: Pix |
| `cartao` | Método: Cartão |
| `interest` | Apenas Juros |
| `principal` | Apenas Principal |
| `adjustment` | Ajuste/Recálculo |
| `renewal` | 🔄 Renovação |
| `interest_renewal` | 🔄 Renovação (Juros) |
| `capital_payment` | 💰 Pagamento Capital |
| `partial_interest` | ⚠️ Juros Parcial |
| `quitacao` | Quitação |

## Resultado Esperado

Após aplicar esta correção, o sistema poderá registrar pagamentos com todos os tipos necessários sem violar a constraint do banco de dados.

## Arquivo SQL Gerado

O arquivo `fix-payment-types-constraint.sql` foi criado com o comando completo para facilitar a execução.