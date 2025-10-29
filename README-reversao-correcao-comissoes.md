# Scripts de Reversão - Correção de Comissões

Este documento explica como reverter as correções aplicadas no campo `total_paid` da tabela `paid_loans`.

## Scripts Disponíveis

### 1. `revert-paid-loans-total-paid.sql`
Script automático que reverte as correções aplicadas pelo `fix-paid-loans-total-paid.sql`.

### 2. `revert-paid-loans-safe.sql` ⭐ **RECOMENDADO**
Script seguro com análise detalhada e múltiplas opções de reversão.

## Quando Usar a Reversão

Use os scripts de reversão se:

- ✅ As correções causaram problemas inesperados
- ✅ Você precisa de uma lógica diferente para o campo `total_paid`
- ✅ Houve erro na aplicação das correções
- ✅ Você quer testar diferentes abordagens

## Como Usar o Script Seguro (Recomendado)

### Passo 1: Análise
Execute as consultas de análise para entender o estado atual:

```sql
-- Verificar quantos registros foram corrigidos
SELECT COUNT(*) FROM paid_loans 
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%';
```

### Passo 2: Escolher Opção de Reversão

O script oferece 4 opções:

#### **Opção A: Reverter para Soma de Pagamentos Parciais**
```sql
UPDATE paid_loans 
SET total_paid = (
    SELECT COALESCE(SUM(p.amount), original_amount)
    FROM payments p 
    WHERE p.loan_id = paid_loans.loan_id
),
notes = REPLACE(notes, ' | CORRIGIDO: total_paid atualizado para valor correto da quitação', '')
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%';
```

**Use quando**: Os empréstimos tiveram pagamentos parciais registrados na tabela `payments`.

#### **Opção B: Reverter para Valor Original (Capital)**
```sql
UPDATE paid_loans 
SET total_paid = original_amount,
notes = REPLACE(notes, ' | CORRIGIDO: total_paid atualizado para valor correto da quitação', '')
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%';
```

**Use quando**: Você quer que `total_paid` represente apenas o capital, sem juros.

#### **Opção C: Reverter para Valor Calculado**
```sql
UPDATE paid_loans 
SET total_paid = original_amount + ((total_with_interest - original_amount) * 0.5),
notes = REPLACE(notes, ' | CORRIGIDO: total_paid atualizado para valor correto da quitação', '')
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%';
```

**Use quando**: Você quer uma fórmula específica (exemplo: capital + 50% dos juros).

#### **Opção D: Reverter Registros Específicos**
```sql
UPDATE paid_loans 
SET total_paid = original_amount,
notes = REPLACE(notes, ' | CORRIGIDO: total_paid atualizado para valor correto da quitação', '')
WHERE id IN (1, 2, 3) -- IDs específicos
AND notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%';
```

**Use quando**: Você quer reverter apenas alguns registros específicos.

### Passo 3: Verificação
Após executar a reversão, verifique os resultados:

```sql
-- Verificar se ainda existem registros com correção
SELECT COUNT(*) FROM paid_loans 
WHERE notes LIKE '%CORRIGIDO: total_paid atualizado para valor correto da quitação%';

-- Deve retornar 0 se a reversão foi completa
```

## Impacto da Reversão

### Na Aba de Comissões

Após a reversão, os valores na aba de comissões voltarão a mostrar:

- **Se Opção A**: Soma dos pagamentos parciais
- **Se Opção B**: Valor do capital (sem juros)
- **Se Opção C**: Valor calculado conforme fórmula
- **Se Opção D**: Valores específicos por registro

### Exemplo Prático

**Empréstimo**: R$ 1.000 + 20% juros = R$ 1.200 total

| Opção | total_paid | Valor na Comissão | Observação |
|-------|------------|-------------------|------------|
| Original (corrigido) | R$ 1.200 | R$ 200 (juros) | ✅ Correto |
| Opção A | R$ 500* | R$ 500 | *Se houve R$ 500 em pagamentos parciais |
| Opção B | R$ 1.000 | R$ 1.000 | ❌ Mostra capital como comissão |
| Opção C | R$ 1.100 | R$ 1.100 | ❌ Mostra valor calculado como comissão |

## Recomendação

⚠️ **CUIDADO**: A reversão pode causar cálculos incorretos nas comissões.

A correção original foi aplicada porque:
- Empréstimos quitados devem ter `total_paid = total_with_interest`
- As comissões devem ser calculadas sobre os juros, não sobre o total pago
- A lógica original estava causando valores incorretos

**Recomendação**: Mantenha a correção original, a menos que haja uma razão específica para reverter.

## Backup

Antes de executar qualquer reversão, faça backup da tabela:

```sql
-- Criar backup
CREATE TABLE paid_loans_backup AS SELECT * FROM paid_loans;

-- Para restaurar (se necessário)
-- DELETE FROM paid_loans;
-- INSERT INTO paid_loans SELECT * FROM paid_loans_backup;
```

## Suporte

Se precisar de ajuda com a reversão, consulte:
1. Este README
2. Os comentários nos scripts SQL
3. O `README-correcao-comissoes-emprestimos-quitados.md` original