# Correção do Erro de Relacionamento entre Tabelas

## Problema

**Erro:** `Could not find a relationship between 'cancelled_loans' and 'clients' in the schema cache`

Este erro ocorre quando o Supabase não consegue reconhecer o relacionamento entre as tabelas `cancelled_loans` e `clients` porque as foreign keys não estão definidas no banco de dados.

## Causa Raiz

O problema estava no arquivo `loan-status-tables.sql`, onde as constraints de foreign key estavam comentadas:

```sql
-- AS CONSTRAINTS ESTAVAM COMENTADAS:
-- ALTER TABLE cancelled_loans ADD CONSTRAINT fk_cancelled_loans_client_id FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;
```

Mas o código em `app.js` faz consultas relacionais que dependem dessas foreign keys:

```javascript
const { data: cancelledLoans, error } = await supabase
    .from('cancelled_loans')
    .select(`
        *,
        clients (
            name,
            cpf,
            email,
            phone
        )
    `)
```

## Solução Implementada

### 1. Correção nos Scripts Principais

**Arquivo:** `loan-status-tables.sql`
- ✅ Descomentadas todas as foreign keys
- ✅ Adicionado aviso sobre dependências das tabelas

### 2. Script de Correção Específico

**Arquivo:** `fix-cancelled-loans-relationship.sql`
- ✅ Corrige especificamente o relacionamento entre `cancelled_loans` e `clients`
- ✅ Remove constraints existentes para evitar conflitos
- ✅ Adiciona as foreign keys necessárias
- ✅ Verifica se as tabelas existem antes de executar

### 3. Script de Correção Completo

**Arquivo:** `fix-all-table-relationships.sql`
- ✅ Corrige relacionamentos de todas as tabelas de status
- ✅ Inclui `paid_loans`, `overdue_loans`, `partial_paid_loans` e `cancelled_loans`
- ✅ Tratamento de erros robusto
- ✅ Verificação final dos relacionamentos criados

## Como Aplicar a Correção

### Opção 1: Correção Rápida (Apenas cancelled_loans)
```sql
-- Execute no SQL Editor do Supabase:
\i fix-cancelled-loans-relationship.sql
```

### Opção 2: Correção Completa (Todas as tabelas)
```sql
-- Execute no SQL Editor do Supabase:
\i fix-all-table-relationships.sql
```

### Opção 3: Para Novas Instalações
- O arquivo `loan-status-tables.sql` já foi corrigido
- Execute normalmente após ter criado as tabelas `clients`, `loans` e `users`

## Verificação da Correção

Após executar a correção, você pode verificar se funcionou:

```sql
-- 1. Verificar se as foreign keys foram criadas
SELECT 
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name = 'cancelled_loans';

-- 2. Testar consulta relacional
SELECT cl.*, c.name as client_name 
FROM cancelled_loans cl
JOIN clients c ON cl.client_id = c.id
LIMIT 1;
```

## Estrutura Correta das Foreign Keys

Após a correção, as tabelas terão os seguintes relacionamentos:

### cancelled_loans
- `client_id` → `clients(id)`
- `loan_id` → `loans(id)`
- `cancelled_by` → `users(id)` (se tabela users existir)
- `created_by` → `users(id)` (se tabela users existir)

### paid_loans, overdue_loans, partial_paid_loans
- `client_id` → `clients(id)`
- `loan_id` → `loans(id)`
- `created_by` → `users(id)` (se tabela users existir)

## Prevenção

Para evitar este tipo de problema no futuro:

1. **Sempre definir foreign keys** quando houver relacionamentos entre tabelas
2. **Testar consultas relacionais** após criação das tabelas
3. **Verificar o schema cache** no Supabase dashboard
4. **Executar scripts na ordem correta** (primeiro tabelas principais, depois tabelas de status)

## Scripts de Execução Recomendada

1. `database-setup.sql` (cria users, clients, loans)
2. `loan-status-tables.sql` (cria tabelas de status COM foreign keys)
3. `setup-cancelled-loans.sql` (configurações específicas de cancelled_loans)

Ou, se já existem as tabelas:
- Execute `fix-all-table-relationships.sql` para corrigir todos os relacionamentos