# 🚀 Guia Visual de Recuperação - Litoral Cred

## 📍 Acesso ao Banco de Dados

### 1. Acessar o Supabase da Litoral Cred

```
URL: https://app.supabase.com/project/dtifsfzmnjnllzzlndxv
Empresa: LITORAL CRED
```

### 2. Abrir SQL Editor

```
Dashboard → SQL Editor → New Query
```

---

## 🔍 Passo 1: Diagnóstico (5 minutos)

### Copie e execute o arquivo: `litoral-cred-diagnostico-rapido.sql`

Este script irá mostrar:

```
✅ Se a tabela paid_loans existe
📊 Quantos empréstimos existem por status
⚠️  Empréstimos que foram totalmente pagos mas não marcados
🚨 Empréstimos que foram DELETADOS mas tinham pagamentos
```

### Interpretando os Resultados:

#### Cenário A: Tabela não existe
```
❌ Tabela paid_loans: NÃO EXISTE
```
**Ação:** Vá para o Passo 2 (Criar Estrutura)

#### Cenário B: Tabela existe mas está vazia
```
⚠️ Tabela paid_loans: VAZIA (0 registros)
```
**Ação:** Vá para o Passo 3 (Recuperar Dados)

#### Cenário C: Há empréstimos deletados
```
🚨 Empréstimos DELETADOS com pagamentos: 15
```
**Ação:** Vá para o Passo 3 (Recuperar Dados) - método de reconstrução

---

## 🏗️ Passo 2: Criar/Restaurar Estrutura (10 minutos)

### Execute o arquivo: `litoral-cred-restore-paid-loans.sql`

Este script irá:

```
✅ Criar a tabela paid_loans (se não existir)
✅ Criar índices para performance
✅ Configurar políticas de segurança (RLS)
✅ Criar triggers automáticos
✅ Criar sistema de auditoria
```

### Resultado Esperado:

```sql
✅ Tabela paid_loans criada/restaurada com sucesso!
✅ Índices criados
✅ Políticas RLS configuradas
✅ Triggers automáticos criados
✅ Sistema de auditoria configurado
```

---

## 💾 Passo 3: Recuperar Dados (15 minutos)

### Execute o arquivo: `litoral-cred-recover-data.sql`

Este script usa **4 métodos** de recuperação:

### Método 1: Empréstimos com status 'paid'
```
Move empréstimos que estão marcados como 'paid' na tabela loans
para a tabela paid_loans
```

### Método 2: Empréstimos completamente pagos
```
Identifica empréstimos que foram totalmente pagos mas têm status incorreto
e move para paid_loans
```

### Método 3: 🚨 Reconstrução de órfãos
```
RECONSTRÓI empréstimos que foram DELETADOS mas tinham pagamentos
⚠️ ATENÇÃO: Usa valores ESTIMADOS
```

### Método 4: Correção de dados
```
Corrige client_id e outros dados inconsistentes
```

### Resultado Esperado:

```
========================================
   RELATÓRIO DE RECUPERAÇÃO - LITORAL CRED
========================================

📊 Total de empréstimos quitados recuperados: 47
📋 Total de empréstimos ativos restantes: 123
💰 Total de registros de pagamentos: 256
⚠️  Pagamentos órfãos (empréstimos deletados): 5

========================================
```

---

## 🔍 Passo 4: Verificar Dados Recuperados

### Consulta: Ver empréstimos recuperados

```sql
SELECT 
    pl.id,
    c.name as cliente,
    c.cpf,
    pl.original_amount as valor_original,
    pl.total_paid as total_pago,
    pl.paid_date as data_quitacao,
    pl.notes as observacoes
FROM paid_loans pl
LEFT JOIN clients c ON pl.client_id = c.id
ORDER BY pl.paid_date DESC;
```

### Consulta: Identificar problemas

```sql
-- Empréstimos sem cliente válido
SELECT * FROM paid_loans 
WHERE client_id = '00000000-0000-0000-0000-000000000000'::uuid;

-- Empréstimos com valores suspeitos
SELECT * FROM paid_loans 
WHERE original_amount < 10 OR total_paid < 10;
```

---

## ✅ Passo 5: Correções Manuais (se necessário)

### Se houver empréstimos com client_id incorreto:

```sql
-- Ver empréstimos sem cliente
SELECT 
    pl.loan_id,
    pl.original_amount,
    pl.paid_date,
    pl.notes
FROM paid_loans pl
WHERE pl.client_id = '00000000-0000-0000-0000-000000000000'::uuid;

-- Corrigir manualmente (exemplo)
UPDATE paid_loans
SET client_id = 'ID_DO_CLIENTE_CORRETO'
WHERE loan_id = 'ID_DO_EMPRESTIMO';
```

### Se houver valores estimados incorretos:

```sql
-- Atualizar valores manualmente
UPDATE paid_loans
SET 
    original_amount = VALOR_CORRETO,
    interest_rate = TAXA_CORRETA,
    total_with_interest = TOTAL_CORRETO
WHERE loan_id = 'ID_DO_EMPRESTIMO';
```

---

## 📊 Relatórios Úteis

### Total financeiro recuperado

```sql
SELECT 
    COUNT(*) as total_emprestimos,
    CONCAT('R$ ', TO_CHAR(SUM(original_amount), '999,999,990.00')) as total_emprestado,
    CONCAT('R$ ', TO_CHAR(SUM(total_paid), '999,999,990.00')) as total_recebido
FROM paid_loans;
```

### Empréstimos por mês

```sql
SELECT 
    TO_CHAR(paid_date, 'YYYY-MM') as mes,
    COUNT(*) as quantidade,
    CONCAT('R$ ', TO_CHAR(SUM(total_paid), '999,999,990.00')) as total
FROM paid_loans
GROUP BY TO_CHAR(paid_date, 'YYYY-MM')
ORDER BY mes DESC;
```

### Top 10 clientes

```sql
SELECT 
    c.name as cliente,
    COUNT(pl.id) as num_emprestimos,
    CONCAT('R$ ', TO_CHAR(SUM(pl.total_paid), '999,999,990.00')) as total_pago
FROM paid_loans pl
JOIN clients c ON pl.client_id = c.id
GROUP BY c.name
ORDER BY SUM(pl.total_paid) DESC
LIMIT 10;
```

---

## 🎯 Checklist Final

Antes de considerar a recuperação completa, verifique:

- [ ] ✅ Tabela `paid_loans` existe e está populada
- [ ] ✅ Triggers automáticos estão funcionando
- [ ] ✅ Políticas RLS estão ativas
- [ ] ✅ Não há empréstimos com `client_id` nulo ou inválido
- [ ] ✅ Valores financeiros estão corretos
- [ ] ✅ Datas estão consistentes
- [ ] ✅ Sistema de auditoria está registrando mudanças
- [ ] ✅ Interface da aplicação mostra os empréstimos quitados

---

## ⚠️ Empréstimos Reconstruídos (Método 3)

Se o script recuperou empréstimos usando o **Método 3** (reconstrução), estes terão a observação:

```
RECONSTRUÍDO: Empréstimo foi deletado mas havia pagamentos. Valores são estimados.
```

### Ações Necessárias:

1. **Identificar o cliente real**
   - Verificar histórico de pagamentos
   - Consultar documentos físicos/digitais
   - Contatar o cliente se necessário

2. **Corrigir valores**
   - Atualizar `original_amount` real
   - Ajustar `interest_rate` correta
   - Recalcular `total_with_interest`

3. **Validar datas**
   - Confirmar `loan_date`
   - Confirmar `due_date`
   - Verificar `paid_date`

---

## 🆘 Solução de Problemas

### Erro: "relation paid_loans does not exist"

**Causa:** Tabela não foi criada

**Solução:** Execute o script `litoral-cred-restore-paid-loans.sql`

### Erro: "duplicate key value violates unique constraint"

**Causa:** Tentando inserir empréstimo que já existe

**Solução:** Normal, o script usa `ON CONFLICT DO NOTHING`

### Erro: "foreign key violation"

**Causa:** Referência a cliente ou usuário inexistente

**Solução:** 
```sql
-- Verificar clientes
SELECT id, name FROM clients;

-- Corrigir referência
UPDATE paid_loans 
SET client_id = 'ID_CLIENTE_VALIDO'
WHERE client_id NOT IN (SELECT id FROM clients);
```

### Nenhum dado foi recuperado

**Causa:** Dados podem ter sido permanentemente deletados sem registros de pagamento

**Solução:** Verificar backups do Supabase ou logs de auditoria

---

## 📞 Suporte Adicional

Se após executar todos os passos ainda houver problemas:

1. **Verificar logs do Supabase**
   - Dashboard → Logs → Error logs

2. **Consultar auditoria**
   ```sql
   SELECT * FROM paid_loans_audit 
   ORDER BY changed_at DESC;
   ```

3. **Exportar dados para análise**
   ```sql
   COPY (SELECT * FROM paid_loans) 
   TO '/tmp/paid_loans_backup.csv' 
   WITH CSV HEADER;
   ```

---

## 🎉 Conclusão

Após seguir este guia:

- ✅ Estrutura da tabela `paid_loans` estará criada
- ✅ Empréstimos quitados estarão recuperados
- ✅ Sistema funcionará automaticamente para futuros empréstimos
- ✅ Dados estarão organizados e auditados

**Próximo passo:** Atualizar a aplicação frontend se necessário para exibir os empréstimos quitados corretamente.
