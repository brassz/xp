# 🚨 INSTRUÇÕES URGENTES - Recuperar Empréstimos Quitados da LITORAL CRED

## 📢 Situação Atual

Os empréstimos quitados da empresa **LITORAL CRED** não estão aparecendo no sistema.

## ✅ Solução Passo-a-Passo

### PASSO 1: Acessar o Supabase da Litoral Cred

1. Acesse: https://supabase.com/
2. Faça login na conta
3. Selecione o projeto da **LITORAL CRED**
   - URL: `https://dtifsfzmnjnllzzlndxv.supabase.co`

### PASSO 2: Abrir o SQL Editor

1. No menu lateral esquerdo, clique em **"SQL Editor"**
2. Clique em **"New query"** para abrir um novo editor

### PASSO 3: Executar Diagnóstico

1. Abra o arquivo: `diagnostico-paid-loans-litoral.sql`
2. Copie TODO o conteúdo do arquivo
3. Cole no SQL Editor do Supabase
4. Clique em **"Run"** ou pressione `Ctrl + Enter`
5. **Analise os resultados:**
   - Se retornar **"0 registros"** → A tabela existe mas está vazia
   - Se retornar **"relation does not exist"** → A tabela não foi criada
   - Se retornar registros → Os dados existem mas há problema de RLS

### PASSO 4: Executar Recuperação

1. Abra o arquivo: `recuperar-paid-loans-litoral.sql`
2. Copie TODO o conteúdo do arquivo
3. Cole no SQL Editor do Supabase
4. Clique em **"Run"** ou pressione `Ctrl + Enter`
5. **Aguarde a execução** (pode levar alguns segundos)
6. **Verifique as mensagens de retorno:**
   - "Tabela paid_loans criada com sucesso!" → ✅
   - "X empréstimos recuperados" → ✅
   - Erros → Anote e veja seção de Problemas abaixo

### PASSO 5: Verificar no Sistema

1. **Abra o sistema** no navegador
2. **Faça login** na conta
3. **Selecione a empresa LITORAL CRED**
4. Vá para a aba **"Empréstimos Quitados"**
5. **Abra o Console do navegador** (F12)
6. Procure por mensagens de log que mostram:
   ```
   ✅ Empréstimos quitados encontrados: X
   📊 Resumo dos dados
   ```

### PASSO 6: Confirmar Recuperação

Verifique se:
- [ ] Os empréstimos quitados aparecem na lista
- [ ] Os valores estão corretos
- [ ] Os nomes dos clientes aparecem
- [ ] As datas estão corretas
- [ ] É possível visualizar detalhes de cada empréstimo

---

## 🔧 Problemas Comuns e Soluções

### Problema 1: "relation paid_loans does not exist"
**Causa:** Tabela não foi criada  
**Solução:** Execute o script `recuperar-paid-loans-litoral.sql` - ele cria a tabela automaticamente

### Problema 2: "permission denied for table paid_loans"
**Causa:** Políticas RLS muito restritivas  
**Solução Temporária:**
```sql
-- Execute no SQL Editor:
ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;
```
**⚠️ IMPORTANTE:** Reabilite depois de testar!
```sql
ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;
```

### Problema 3: Tabela existe mas retorna 0 registros
**Causa:** Dados foram deletados ou nunca foram migrados  
**Solução:** O script de recuperação busca dados de:
- Empréstimos com status 'paid' na tabela loans
- Pagamentos marcados como finais (is_final_payment = true)

### Problema 4: "duplicate key value violates unique constraint"
**Causa:** Alguns registros já existem  
**Solução:** O script usa `ON CONFLICT DO NOTHING` - isso é esperado

### Problema 5: Empréstimos aparecem sem nome do cliente
**Causa:** Cliente foi deletado ou ID está incorreto  
**Solução:** Verificar integridade dos dados:
```sql
-- Listar empréstimos quitados sem cliente válido
SELECT pl.* 
FROM paid_loans pl
LEFT JOIN clients c ON c.id = pl.client_id
WHERE c.id IS NULL;
```

---

## 🔍 Verificações de Segurança

Antes de considerar concluído, execute estas queries de verificação:

### 1. Contar Total de Registros
```sql
SELECT COUNT(*) as total FROM paid_loans;
```

### 2. Ver Resumo Mensal
```sql
SELECT 
    DATE_TRUNC('month', paid_date) as mes,
    COUNT(*) as total,
    SUM(original_amount) as valor_original,
    SUM(total_paid) as valor_pago
FROM paid_loans
GROUP BY mes
ORDER BY mes DESC;
```

### 3. Verificar Últimos 10 Quitados
```sql
SELECT 
    pl.paid_date,
    c.name as cliente,
    pl.original_amount,
    pl.total_paid
FROM paid_loans pl
LEFT JOIN clients c ON c.id = pl.client_id
ORDER BY pl.paid_date DESC
LIMIT 10;
```

---

## 📋 Checklist Final

Execute este checklist para garantir que tudo está funcionando:

- [ ] Executei o diagnóstico e identifiquei o problema
- [ ] Executei o script de recuperação
- [ ] A tabela paid_loans existe
- [ ] Há registros na tabela paid_loans
- [ ] Os empréstimos aparecem no sistema
- [ ] Os valores estão corretos
- [ ] Consigo ver detalhes de cada empréstimo
- [ ] Consigo ver o histórico de pagamentos
- [ ] Criei um backup da tabela:
  ```sql
  CREATE TABLE paid_loans_backup_20251125 AS 
  SELECT * FROM paid_loans;
  ```

---

## 📞 Se Nada Funcionar

Se após seguir todos os passos o problema persistir:

### 1. Capture Informações
- Screenshot do erro no SQL Editor
- Console do navegador (F12) com erros
- Resultado das queries de diagnóstico

### 2. Verifique Conexão
```javascript
// No console do navegador (F12), execute:
console.log('Empresa atual:', currentCompany);
console.log('Config:', getCurrentCompanyConfig());
```

### 3. Tente Recuperação Manual
Se você tem os dados em outro lugar (planilha, backup, etc.):
```sql
-- Inserir manualmente
INSERT INTO paid_loans (
    loan_id, client_id, original_amount, 
    interest_rate, total_with_interest,
    loan_date, due_date, paid_date,
    total_paid, payment_method, notes
) VALUES (
    gen_random_uuid(), -- loan_id
    'ID_DO_CLIENTE',   -- client_id
    1000.00,           -- original_amount
    10.00,             -- interest_rate
    1100.00,           -- total_with_interest
    '2024-01-01',      -- loan_date
    '2024-02-01',      -- due_date
    '2024-01-25',      -- paid_date
    1100.00,           -- total_paid
    'Dinheiro',        -- payment_method
    'Recuperado manualmente' -- notes
);
```

---

## 🎯 Resultado Esperado

Após completar todos os passos:

✅ Tabela `paid_loans` criada e configurada  
✅ Empréstimos quitados recuperados e visíveis  
✅ Sistema funcionando normalmente  
✅ Backup criado para segurança  
✅ Logs detalhados no console para debug futuro

---

## 📅 Manutenção Preventiva

Para evitar problemas futuros:

### Backup Semanal Automático
Configure no Supabase > Database > Extensions > pg_cron:
```sql
-- Criar backup automático todo domingo às 2h
SELECT cron.schedule(
    'backup-paid-loans',
    '0 2 * * 0',
    $$CREATE TABLE IF NOT EXISTS paid_loans_backup_auto AS 
      SELECT * FROM paid_loans$$
);
```

### Monitoramento
Adicione esta query aos favoritos do SQL Editor:
```sql
-- Verificação rápida de saúde
SELECT 
    'paid_loans' as tabela,
    COUNT(*) as registros,
    MAX(paid_date) as ultimo_quitado,
    SUM(total_paid) as valor_total_quitado
FROM paid_loans;
```

---

**Data:** 25/11/2025  
**Empresa:** LITORAL CRED  
**Prioridade:** URGENTE  
**Status:** Aguardando execução
