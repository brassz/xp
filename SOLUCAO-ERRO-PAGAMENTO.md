# Solução para Erro de Registro de Pagamento

## Erro
```
Erro ao registrar pagamento: there is no unique or exclusion constraint matching the ON CONFLICT specification
```

## Diagnóstico

Este erro ocorre quando o código tenta usar uma cláusula `ON CONFLICT` em PostgreSQL, mas a constraint (restrição) especificada não existe ou não está corretamente definida.

## Possíveis Causas

1. **Constraint UNIQUE ausente**: A tabela `installment_payments` não possui a constraint única necessária
2. **Dados duplicados**: Existem registros duplicados que impedem a criação da constraint
3. **Código usando upsert**: Algum código pode estar usando funcionalidade de upsert do Supabase
4. **Trigger ou função**: Alguma função PL/pgSQL pode estar usando ON CONFLICT incorretamente

## Soluções

### Solução 1: Executar Script de Correção
Execute o arquivo `fix-payment-registration-error.sql` no SQL Editor do Supabase:

```sql
-- Este script irá:
-- 1. Verificar se a constraint UNIQUE existe
-- 2. Criar a constraint se necessário
-- 3. Remover dados duplicados
-- 4. Testar ON CONFLICT
```

### Solução 2: Verificação Manual da Constraint

1. Acesse o SQL Editor do Supabase
2. Execute o comando para verificar constraints:

```sql
SELECT 
    conname as constraint_name,
    pg_get_constraintdef(oid) as definition
FROM pg_constraint 
WHERE conrelid = 'installment_payments'::regclass
AND contype = 'u';
```

3. Se não houver constraint UNIQUE, execute:

```sql
ALTER TABLE installment_payments 
ADD CONSTRAINT installment_payments_unique_combo 
UNIQUE (installment_id, installment_number);
```

### Solução 3: Verificar Dados Duplicados

Execute para verificar duplicatas:

```sql
SELECT 
    installment_id, 
    installment_number, 
    COUNT(*) as count
FROM installment_payments 
GROUP BY installment_id, installment_number 
HAVING COUNT(*) > 1;
```

Se houver duplicatas, remova-as:

```sql
DELETE FROM installment_payments 
WHERE id NOT IN (
    SELECT DISTINCT ON (installment_id, installment_number) id
    FROM installment_payments 
    ORDER BY installment_id, installment_number, created_at DESC
);
```

### Solução 4: Diagnóstico Completo

Execute o arquivo `diagnose-on-conflict-error.sql` para um diagnóstico completo.

## Verificação da Correção

Após aplicar as soluções, teste o registro de pagamento:

1. Acesse a aplicação
2. Tente registrar um pagamento de parcela
3. Verifique se o erro não ocorre mais

## Prevenção

Para evitar este erro no futuro:

1. **Sempre verifique constraints**: Antes de usar ON CONFLICT, certifique-se de que a constraint existe
2. **Validação de dados**: Implemente validação para evitar duplicatas
3. **Testes regulares**: Execute testes regulares das funcionalidades de pagamento
4. **Backup**: Mantenha backups regulares do banco de dados

## Código de Exemplo Correto

Se você precisar usar ON CONFLICT no código, use assim:

```sql
INSERT INTO installment_payments (installment_id, installment_number, amount, due_date, status)
VALUES ($1, $2, $3, $4, $5)
ON CONFLICT (installment_id, installment_number) 
DO UPDATE SET 
    amount = EXCLUDED.amount,
    due_date = EXCLUDED.due_date,
    status = EXCLUDED.status,
    updated_at = NOW();
```

## Suporte

Se o problema persistir após aplicar todas as soluções:

1. Execute o diagnóstico completo
2. Verifique os logs do Supabase
3. Verifique se há código JavaScript usando upsert
4. Contate o suporte técnico com os resultados do diagnóstico