# 🚨 Recuperação de Empréstimos Quitados - Litoral Cred

## 📋 Resumo Executivo

Os empréstimos quitados da empresa **Litoral Cred** sumiram do banco de dados. Este guia fornece scripts completos para diagnóstico, recuperação e prevenção de perda de dados.

---

## 🎯 Objetivo

Recuperar todos os empréstimos quitados que desapareceram do sistema, reconstruindo-os a partir de:
1. Empréstimos com status "paid" na tabela `loans`
2. Empréstimos totalmente pagos mas com status incorreto
3. Registros de pagamentos de empréstimos deletados (reconstrução)

---

## 📂 Arquivos do Sistema

| Arquivo | Propósito | Ordem |
|---------|-----------|-------|
| `litoral-cred-backup-preventivo.sql` | Criar backup antes de qualquer alteração | 1º |
| `litoral-cred-diagnostico-rapido.sql` | Diagnosticar o problema | 2º |
| `litoral-cred-restore-paid-loans.sql` | Criar/restaurar estrutura da tabela | 3º |
| `litoral-cred-recover-data.sql` | Recuperar dados históricos | 4º |
| `LITORAL-CRED-GUIA-VISUAL.md` | Guia passo a passo com exemplos | Referência |
| `LITORAL-CRED-RECUPERAR-EMPRESTIMOS-QUITADOS.md` | Documentação técnica completa | Referência |

---

## 🚀 Guia Rápido (30 minutos)

### Pré-requisitos

- ✅ Acesso ao Supabase da Litoral Cred
- ✅ Permissões de administrador
- ✅ SQL Editor aberto

### URL do Banco

```
https://app.supabase.com/project/dtifsfzmnjnllzzlndxv
```

---

## 📝 Passo a Passo Completo

### Passo 0: Backup Preventivo ⚠️

**SEMPRE execute o backup primeiro!**

```bash
# No SQL Editor do Supabase
1. Abrir: litoral-cred-backup-preventivo.sql
2. Copiar todo o conteúdo
3. Colar no SQL Editor
4. Clicar em "Run"
5. Aguardar mensagem: "✅ BACKUP CONCLUÍDO COM SUCESSO!"
```

**Resultado:** Tabelas de backup criadas:
- `loans_backup_20241125`
- `payments_backup_20241125`
- `clients_backup_20241125`
- `paid_loans_backup_20241125` (se existir)

---

### Passo 1: Diagnóstico 🔍

```bash
# No SQL Editor do Supabase
1. Abrir: litoral-cred-diagnostico-rapido.sql
2. Copiar todo o conteúdo
3. Colar no SQL Editor
4. Clicar em "Run"
5. Analisar os resultados
```

**O que o diagnóstico mostra:**

```
✅ Status da tabela paid_loans
📊 Quantidade de empréstimos por status
⚠️  Empréstimos totalmente pagos mas não marcados
🚨 Empréstimos deletados que tinham pagamentos
📋 Triggers e estruturas existentes
```

**Exemplo de resultado:**

```
❌ Tabela paid_loans: NÃO EXISTE
⚠️ Empréstimos com status "paid" na tabela loans: 23
🚨 Empréstimos DELETADOS com pagamentos: 15
```

---

### Passo 2: Restaurar Estrutura 🏗️

```bash
# No SQL Editor do Supabase
1. Abrir: litoral-cred-restore-paid-loans.sql
2. Copiar todo o conteúdo
3. Colar no SQL Editor
4. Clicar em "Run"
5. Aguardar conclusão (pode levar 1-2 minutos)
```

**O que este script faz:**

```
✅ Cria tabela paid_loans (se não existir)
✅ Cria índices para performance
✅ Configura políticas de segurança (RLS)
✅ Cria triggers automáticos
✅ Cria sistema de auditoria
✅ Cria views para consultas
```

**Resultado esperado:**

```
✅ Tabela paid_loans criada/restaurada com sucesso!
✅ Índices criados
✅ Políticas RLS configuradas
✅ Triggers automáticos criados
✅ Sistema de auditoria configurado

📋 Próximo passo: Execute o script litoral-cred-recover-data.sql para recuperar dados
```

---

### Passo 3: Recuperar Dados 💾

```bash
# No SQL Editor do Supabase
1. Abrir: litoral-cred-recover-data.sql
2. Copiar todo o conteúdo
3. Colar no SQL Editor
4. Clicar em "Run"
5. Aguardar conclusão (pode levar 2-5 minutos)
```

**Métodos de recuperação utilizados:**

#### Método 1: Status 'paid'
```
Move empréstimos com status='paid' da tabela loans para paid_loans
```

#### Método 2: Totalmente pagos
```
Identifica empréstimos onde: total_pago >= valor_total
Move para paid_loans e corrige status
```

#### Método 3: Reconstrução 🚨
```
Reconstrói empréstimos que foram DELETADOS
Usa histórico de pagamentos para estimar valores
⚠️ ATENÇÃO: Valores são ESTIMADOS
```

#### Método 4: Correção
```
Corrige client_id e dados inconsistentes
```

**Resultado esperado:**

```
========================================
   RELATÓRIO DE RECUPERAÇÃO - LITORAL CRED
========================================

📊 Método 1: 23 empréstimos recuperados da tabela loans com status paid
📊 Método 2: 8 empréstimos recuperados (completamente pagos)
📊 Método 3: 15 empréstimos reconstruídos de pagamentos órfãos
📊 Método 4: 12 registros tiveram client_id corrigido

📊 Total de empréstimos quitados recuperados: 46
📋 Total de empréstimos ativos restantes: 127
💰 Total de registros de pagamentos: 342
⚠️  Pagamentos órfãos (empréstimos deletados): 0

========================================
```

---

### Passo 4: Verificação ✅

#### Consulta 1: Ver empréstimos recuperados

```sql
SELECT 
    pl.id,
    c.name as cliente,
    c.cpf,
    pl.original_amount as valor_original,
    pl.total_paid as total_pago,
    TO_CHAR(pl.paid_date, 'DD/MM/YYYY') as data_quitacao,
    pl.payment_method as metodo,
    pl.notes as observacoes
FROM paid_loans pl
LEFT JOIN clients c ON pl.client_id = c.id
ORDER BY pl.paid_date DESC
LIMIT 20;
```

#### Consulta 2: Estatísticas financeiras

```sql
SELECT 
    COUNT(*) as total_emprestimos,
    CONCAT('R$ ', TO_CHAR(SUM(original_amount), '999,999,990.00')) as total_emprestado,
    CONCAT('R$ ', TO_CHAR(SUM(total_paid), '999,999,990.00')) as total_recebido,
    CONCAT('R$ ', TO_CHAR(AVG(original_amount), '999,999,990.00')) as ticket_medio
FROM paid_loans;
```

#### Consulta 3: Identificar problemas

```sql
-- Empréstimos sem cliente válido
SELECT 
    COUNT(*) as quantidade,
    'Sem cliente válido' as problema
FROM paid_loans 
WHERE client_id = '00000000-0000-0000-0000-000000000000'::uuid
    OR client_id NOT IN (SELECT id FROM clients);

-- Empréstimos reconstruídos (precisam revisão)
SELECT 
    COUNT(*) as quantidade,
    'Reconstruídos - Revisar valores' as problema
FROM paid_loans 
WHERE notes LIKE '%RECONSTRUÍDO%';
```

---

### Passo 5: Correções Manuais (se necessário) 🔧

#### Se houver empréstimos sem cliente:

```sql
-- 1. Listar empréstimos sem cliente
SELECT 
    pl.id,
    pl.loan_id,
    pl.original_amount,
    TO_CHAR(pl.paid_date, 'DD/MM/YYYY') as data_quitacao,
    pl.notes
FROM paid_loans pl
WHERE pl.client_id = '00000000-0000-0000-0000-000000000000'::uuid;

-- 2. Corrigir manualmente (exemplo)
UPDATE paid_loans
SET client_id = 'UUID_DO_CLIENTE_CORRETO'
WHERE loan_id = 'UUID_DO_EMPRESTIMO';
```

#### Se houver valores estimados incorretos:

```sql
-- 1. Listar empréstimos reconstruídos
SELECT * FROM paid_loans 
WHERE notes LIKE '%RECONSTRUÍDO%';

-- 2. Corrigir valores (exemplo)
UPDATE paid_loans
SET 
    original_amount = 5000.00,
    interest_rate = 2.5,
    total_with_interest = 5125.00,
    client_id = 'UUID_DO_CLIENTE_CORRETO',
    notes = 'Valores corrigidos manualmente'
WHERE loan_id = 'UUID_DO_EMPRESTIMO';
```

---

## 📊 Relatórios Importantes

### Empréstimos por mês

```sql
SELECT 
    TO_CHAR(paid_date, 'YYYY-MM') as mes,
    COUNT(*) as quantidade,
    CONCAT('R$ ', TO_CHAR(SUM(original_amount), '999,999,990.00')) as emprestado,
    CONCAT('R$ ', TO_CHAR(SUM(total_paid), '999,999,990.00')) as recebido
FROM paid_loans
GROUP BY TO_CHAR(paid_date, 'YYYY-MM')
ORDER BY mes DESC;
```

### Top 10 clientes

```sql
SELECT 
    c.name as cliente,
    c.cpf,
    COUNT(pl.id) as num_emprestimos,
    CONCAT('R$ ', TO_CHAR(SUM(pl.total_paid), '999,999,990.00')) as total_pago
FROM paid_loans pl
JOIN clients c ON pl.client_id = c.id
GROUP BY c.name, c.cpf
ORDER BY SUM(pl.total_paid) DESC
LIMIT 10;
```

### Resumo geral do sistema

```sql
SELECT 
    'Empréstimos Quitados' as categoria,
    COUNT(*) as quantidade,
    CONCAT('R$ ', TO_CHAR(SUM(total_paid), '999,999,990.00')) as valor_total
FROM paid_loans

UNION ALL

SELECT 
    'Empréstimos Ativos' as categoria,
    COUNT(*) as quantidade,
    CONCAT('R$ ', TO_CHAR(SUM(amount), '999,999,990.00')) as valor_total
FROM loans
WHERE status = 'active'

UNION ALL

SELECT 
    'Empréstimos Vencidos' as categoria,
    COUNT(*) as quantidade,
    CONCAT('R$ ', TO_CHAR(SUM(amount), '999,999,990.00')) as valor_total
FROM loans
WHERE status = 'overdue';
```

---

## 🔄 Restauração (Rollback)

Se algo der errado, você pode restaurar o estado anterior:

```sql
-- Ver comandos de restauração disponíveis
SELECT * FROM restore_commands;

-- Executar restauração completa
DROP TABLE IF EXISTS loans CASCADE;
CREATE TABLE loans AS SELECT * FROM loans_backup_20241125;

DROP TABLE IF EXISTS payments CASCADE;
CREATE TABLE payments AS SELECT * FROM payments_backup_20241125;

DROP TABLE IF EXISTS clients CASCADE;
CREATE TABLE clients AS SELECT * FROM clients_backup_20241125;

-- Recriar índices e constraints
-- (Execute o script database-setup.sql após a restauração)
```

---

## ⚠️ Atenção Especial

### Empréstimos Reconstruídos (Método 3)

Empréstimos com esta observação foram **DELETADOS** e tiveram que ser reconstruídos:

```
RECONSTRUÍDO: Empréstimo foi deletado mas havia pagamentos. 
Valores são estimados.
```

**Ações necessárias:**

1. ✅ **Identificar o cliente real**
   - Verificar documentos
   - Consultar registros físicos
   - Contatar cliente se necessário

2. ✅ **Corrigir valores**
   - Valor original real
   - Taxa de juros real
   - Recalcular total com juros

3. ✅ **Validar datas**
   - Data de empréstimo
   - Data de vencimento
   - Data de quitação

---

## 🎯 Checklist de Conclusão

Antes de considerar a recuperação completa:

- [ ] ✅ Backup preventivo foi criado
- [ ] ✅ Diagnóstico foi executado e analisado
- [ ] ✅ Tabela `paid_loans` foi criada/restaurada
- [ ] ✅ Todos os 4 métodos de recuperação foram executados
- [ ] ✅ Dados recuperados foram verificados
- [ ] ✅ Não há empréstimos com `client_id` inválido
- [ ] ✅ Empréstimos reconstruídos foram revisados
- [ ] ✅ Valores e datas estão consistentes
- [ ] ✅ Triggers automáticos estão funcionando
- [ ] ✅ Sistema de auditoria está ativo
- [ ] ✅ Relatórios financeiros estão corretos
- [ ] ✅ Interface da aplicação mostra os dados corretamente

---

## 🆘 Solução de Problemas

### Problema: "relation paid_loans does not exist"

**Causa:** Tabela não foi criada

**Solução:** Execute `litoral-cred-restore-paid-loans.sql`

---

### Problema: Nenhum dado foi recuperado

**Causas possíveis:**
1. Dados foram permanentemente deletados sem histórico
2. Tabela de pagamentos também foi limpa
3. Problema com foreign keys

**Solução:**
```sql
-- Verificar se há pagamentos
SELECT COUNT(*) FROM payments;

-- Verificar se há empréstimos órfãos
SELECT COUNT(DISTINCT p.loan_id)
FROM payments p
LEFT JOIN loans l ON p.loan_id = l.id
WHERE l.id IS NULL;
```

---

### Problema: Valores estão incorretos

**Causa:** Reconstrução automática estimou valores

**Solução:** Correção manual (ver Passo 5)

---

### Problema: Cliente não encontrado

**Causa:** Empréstimo foi deletado antes de associar ao cliente

**Solução:**
```sql
-- Buscar cliente por CPF ou nome nos pagamentos
SELECT DISTINCT created_by 
FROM payments 
WHERE loan_id = 'UUID_DO_EMPRESTIMO';

-- Atualizar manualmente
UPDATE paid_loans 
SET client_id = 'UUID_CORRETO'
WHERE loan_id = 'UUID_DO_EMPRESTIMO';
```

---

## 📞 Suporte Adicional

### Logs do Supabase

```
Dashboard → Logs → Postgres Logs
Dashboard → Logs → Error Logs
```

### Auditoria de Mudanças

```sql
-- Ver todas as mudanças em paid_loans
SELECT 
    pa.action,
    pa.changed_at,
    pa.changed_data->>'loan_id' as loan_id,
    u.full_name as usuario
FROM paid_loans_audit pa
LEFT JOIN users u ON pa.changed_by = u.id
ORDER BY pa.changed_at DESC
LIMIT 50;
```

### Exportar Dados

```sql
-- Exportar empréstimos quitados para análise
COPY (
    SELECT 
        pl.*,
        c.name as cliente_nome,
        c.cpf as cliente_cpf
    FROM paid_loans pl
    LEFT JOIN clients c ON pl.client_id = c.id
    ORDER BY pl.paid_date DESC
) TO '/tmp/paid_loans_litoral_cred.csv' 
WITH CSV HEADER;
```

---

## 📚 Documentação Adicional

- **Guia Visual:** `LITORAL-CRED-GUIA-VISUAL.md`
- **Documentação Técnica:** `LITORAL-CRED-RECUPERAR-EMPRESTIMOS-QUITADOS.md`
- **Multi-Empresas:** `README-MULTI-EMPRESAS.md`
- **Tabelas de Status:** `README-loan-status-tables.md`

---

## 🎉 Conclusão

Após executar todos os passos deste guia:

- ✅ **Estrutura recriada:** Tabela `paid_loans` com todos os índices e triggers
- ✅ **Dados recuperados:** Empréstimos quitados restaurados de múltiplas fontes
- ✅ **Sistema automatizado:** Futuros empréstimos quitados serão movidos automaticamente
- ✅ **Auditoria ativa:** Todas as mudanças serão registradas
- ✅ **Backup disponível:** Possibilidade de rollback se necessário

**Data de criação:** 25 de Novembro de 2024  
**Empresa:** Litoral Cred  
**Sistema:** Nexus Gestão Financeira
