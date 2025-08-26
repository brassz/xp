# Tabelas de Status de Empréstimos

Este arquivo contém a estrutura para criar tabelas separadas para cada status de empréstimo, permitindo melhor organização e controle dos dados.

## ⚠️ **IMPORTANTE: Resolução de Problemas**

### Problema: "cannot create index on relation - This operation is not supported for views"
### Problema: "overdue_loans is not a table - Use DROP VIEW to remove a view"

Se você encontrar estes erros, significa que as tabelas já existem como views ou há conflitos. A solução está nos arquivos corrigidos:

1. **`cleanup-existing-objects.sql`** - Limpa completamente todos os objetos existentes
2. **`loan-status-tables.sql`** - Cria as tabelas limpas
3. **`setup-foreign-keys.sql`** - Configura foreign keys e permissões

## 📁 **Arquivos do Sistema**

| Arquivo | Propósito | Ordem de Execução |
|---------|-----------|-------------------|
| `cleanup-existing-objects.sql` | Limpa objetos existentes | 1º (se necessário) |
| `loan-status-tables.sql` | Cria as tabelas principais | 2º |
| `setup-foreign-keys.sql` | Configura relacionamentos | 3º |

## 🚀 **Como Usar (Passo a Passo)**

### **Cenário 1: Primeira Instalação (Recomendado)**
```sql
-- Passo 1: Criar tabelas
\i loan-status-tables.sql

-- Passo 2: Configurar foreign keys
\i setup-foreign-keys.sql
```

### **Cenário 2: Se Houver Conflitos (Views/Tabelas Existentes)**
```sql
-- Passo 1: Limpar tudo
\i cleanup-existing-objects.sql

-- Passo 2: Criar tabelas
\i loan-status-tables.sql

-- Passo 3: Configurar foreign keys
\i setup-foreign-keys.sql
```

## 🔧 **O que Cada Arquivo Faz**

### **`cleanup-existing-objects.sql`**
- **Verifica** o que existe atualmente (tabelas, views, triggers)
- **Remove** todos os triggers relacionados a loans
- **Remove** todas as funções relacionadas
- **Remove** todas as views existentes
- **Remove** todas as tabelas existentes
- **Valida** se as tabelas principais existem

### **`loan-status-tables.sql`**
- **Remove** views e tabelas existentes que possam causar conflitos
- **Cria** as 4 tabelas de status limpas
- **Remove** funções e triggers antigos para evitar conflitos
- **Cria** novos triggers otimizados
- **Cria** índices para performance

### **`setup-foreign-keys.sql`**
- **Verifica** se as tabelas principais existem
- **Adiciona** todas as foreign keys necessárias
- **Configura** permissões de usuário
- **Valida** a configuração completa

## 🏗️ **Estrutura das Tabelas**

### 1. `paid_loans` - Empréstimos Quitados
- **Propósito**: Armazena empréstimos completamente pagos
- **Campos principais**:
  - `loan_id`: Referência ao empréstimo original
  - `paid_date`: Data em que foi quitado
  - `total_paid`: Valor total pago
  - `payment_method`: Método de pagamento utilizado

### 2. `overdue_loans` - Empréstimos Vencidos
- **Propósito**: Controla empréstimos em atraso para cobrança
- **Campos principais**:
  - `days_overdue`: Quantidade de dias em atraso
  - `remaining_amount`: Valor restante a pagar
  - `collection_status`: Status do processo de cobrança
  - `collection_notes`: Notas sobre a cobrança

### 3. `partial_paid_loans` - Empréstimos Parcelados
- **Propósito**: Gerencia empréstimos com pagamentos parciais
- **Campos principais**:
  - `payment_count`: Número de pagamentos realizados
  - `next_payment_date`: Próxima data de pagamento
  - `installment_amount`: Valor de cada parcela
  - `payment_schedule`: Cronograma de pagamentos

### 4. `cancelled_loans` - Empréstimos Cancelados
- **Propósito**: Registra empréstimos cancelados
- **Campos principais**:
  - `cancellation_reason`: Motivo do cancelamento
  - `refund_amount`: Valor a ser reembolsado
  - `cancellation_fee`: Taxa de cancelamento
  - `cancelled_by`: Usuário que cancelou

## ⚡ **Triggers Automáticos**

O sistema inclui triggers que mantêm as tabelas sincronizadas automaticamente:

- **`insert_paid_loan`**: Insere empréstimos na tabela de quitados quando o status muda para 'paid'
- **`insert_overdue_loan`**: Insere/atualiza empréstimos na tabela de vencidos
- **`insert_partial_paid_loan`**: Gerencia empréstimos com pagamentos parciais
- **`insert_cancelled_loan`**: Registra empréstimos cancelados
- **`cleanup_loan_status_tables`**: Remove registros das tabelas quando o status muda

## 🔧 **Solução de Problemas**

### Erro: "overdue_loans is not a table - Use DROP VIEW to remove a view"
```sql
-- Execute o script de limpeza
\i cleanup-existing-objects.sql

-- Depois execute os scripts principais
\i loan-status-tables.sql
\i setup-foreign-keys.sql
```

### Erro: "cannot create index on relation - This operation is not supported for views"
```sql
-- Execute o script de limpeza
\i cleanup-existing-objects.sql

-- Depois execute os scripts principais
\i loan-status-tables.sql
\i setup-foreign-keys.sql
```

### Erro: "relation already exists"
```sql
-- Execute o script de limpeza
\i cleanup-existing-objects.sql

-- Depois execute os scripts principais
\i loan-status-tables.sql
\i setup-foreign-keys.sql
```

### Erro: "function already exists"
```sql
-- O script de limpeza já remove funções antigas
-- Se persistir, execute manualmente:
\i cleanup-existing-objects.sql
```

### Erro: "table does not exist"
```sql
-- Verifique se executou na ordem correta:
-- 1. cleanup-existing-objects.sql (se necessário)
-- 2. loan-status-tables.sql (tabelas de status)
-- 3. setup-foreign-keys.sql (relacionamentos)
```

## 📊 **Consultas Úteis**

#### Empréstimos Quitados no Último Mês
```sql
SELECT 
    pl.loan_id,
    c.name as client_name,
    pl.total_paid,
    pl.paid_date
FROM paid_loans pl
JOIN clients c ON pl.client_id = c.id
WHERE pl.paid_date >= CURRENT_DATE - INTERVAL '1 month'
ORDER BY pl.paid_date DESC;
```

#### Empréstimos Vencidos por Dias de Atraso
```sql
SELECT 
    ol.loan_id,
    c.name as client_name,
    ol.days_overdue,
    ol.remaining_amount,
    ol.collection_status
FROM overdue_loans ol
JOIN clients c ON ol.client_id = c.id
ORDER BY ol.days_overdue DESC;
```

#### Resumo de Pagamentos Parciais
```sql
SELECT 
    ppl.loan_id,
    c.name as client_name,
    ppl.total_paid,
    ppl.remaining_amount,
    ppl.payment_count,
    ppl.next_payment_date
FROM partial_paid_loans ppl
JOIN clients c ON ppl.client_id = c.id
WHERE ppl.next_payment_date <= CURRENT_DATE + INTERVAL '7 days'
ORDER BY ppl.next_payment_date;
```

#### Histórico de Cancelamentos
```sql
SELECT 
    cl.loan_id,
    c.name as client_name,
    cl.cancellation_reason,
    cl.cancellation_date,
    cl.refund_amount
FROM cancelled_loans cl
JOIN clients c ON cl.client_id = c.id
ORDER BY cl.cancellation_date DESC;
```

## 📈 **Relatórios**

#### Dashboard de Status
```sql
SELECT 
    'Quitados' as status,
    COUNT(*) as count,
    SUM(total_paid) as total_amount
FROM paid_loans
WHERE paid_date >= CURRENT_DATE - INTERVAL '30 days'

UNION ALL

SELECT 
    'Vencidos' as status,
    COUNT(*) as count,
    SUM(remaining_amount) as total_amount
FROM overdue_loans

UNION ALL

SELECT 
    'Parcelados' as status,
    COUNT(*) as count,
    SUM(remaining_amount) as total_amount
FROM partial_paid_loans

UNION ALL

SELECT 
    'Cancelados' as status,
    COUNT(*) as count,
    SUM(total_paid_before_cancellation) as total_amount
FROM cancelled_loans
WHERE cancellation_date >= CURRENT_DATE - INTERVAL '30 days';
```

## ✅ **Verificação de Instalação**

Após executar todos os arquivos, verifique se tudo foi criado corretamente:

```sql
-- Verificar tabelas
SELECT table_name FROM information_schema.tables 
WHERE table_name IN ('paid_loans', 'overdue_loans', 'partial_paid_loans', 'cancelled_loans')
ORDER BY table_name;

-- Verificar triggers
SELECT trigger_name, event_object_table 
FROM information_schema.triggers 
WHERE event_object_table = 'loans';

-- Verificar foreign keys
SELECT tc.table_name, kcu.column_name, ccu.table_name AS foreign_table_name
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name IN ('paid_loans', 'overdue_loans', 'partial_paid_loans', 'cancelled_loans');
```

## 🎯 **Vantagens desta Abordagem**

1. **Performance Superior** - Consultas mais rápidas por status específico
2. **Organização Lógica** - Dados organizados logicamente por situação
3. **Relatórios Fáceis** - Consultas específicas por categoria
4. **Manutenção Simples** - Triggers automáticos
5. **Escalabilidade** - Melhor performance com volume alto
6. **Resistente a Erros** - Scripts separados evitam conflitos
7. **Limpeza Completa** - Remove views, tabelas e triggers antigos

## 🚨 **Notas Importantes**

- **Execute os arquivos na ordem correta** para evitar erros
- **Use o script de limpeza** se houver conflitos com views/tabelas existentes
- **Os triggers funcionam automaticamente** quando o status muda
- **As tabelas mantêm referências** para integridade referencial
- **Índices foram criados** para otimizar consultas frequentes
- **O sistema suporta rollback** automático em caso de erros
- **Todas as operações são registradas** com timestamps para auditoria
- **Foreign keys são configuradas separadamente** para evitar dependências circulares
- **O script de limpeza é seguro** e verifica antes de remover 