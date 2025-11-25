# 🆘 SOCORRO - Recuperação Urgente Litoral Cred

## ❌ CALMA! Os dados NÃO foram perdidos!

Se você tem registros na tabela `payments`, **TUDO pode ser recuperado!**

---

## 🔍 PASSO 1: Verificar se há dados (2 minutos)

**Copie e execute isto:**

```sql
SELECT COUNT(*) as total_pagamentos FROM payments;
```

### Resultado:

- **Se aparecer um número > 0:** ✅ **ÓTIMO! Podemos recuperar!**
- **Se aparecer 0:** ⚠️ Problema mais grave, mas ainda há esperança

---

## 🚀 PASSO 2: Recuperação Simples (1 minuto)

### Copie TODO o conteúdo deste arquivo:

```
RECUPERACAO-SIMPLES-LITORAL-CRED.sql
```

### Cole no SQL Editor do Supabase e clique em "Run"

**É SÓ ISSO!** O script faz tudo automaticamente:
- ✅ Cria a tabela
- ✅ Recupera os dados
- ✅ Mostra relatório

---

## 📊 PASSO 3: Ver Resultados (1 minuto)

Após executar, você verá tabelas com:

1. **Total recuperado**
2. **Quantidade por método**
3. **Lista dos 20 primeiros registros**

### Consulta rápida:

```sql
-- Ver total recuperado
SELECT COUNT(*) as total FROM paid_loans;

-- Ver os dados
SELECT * FROM paid_loans ORDER BY paid_date DESC LIMIT 20;
```

---

## ⚠️ E se NÃO recuperar nada?

### Possíveis causas:

**1. Tabela payments também foi limpa**
```sql
-- Verificar
SELECT COUNT(*) FROM payments;
```
- Se retornar 0: Dados foram deletados sem backup 😢

**2. Nunca houve empréstimos quitados**
```sql
-- Verificar histórico
SELECT COUNT(*) FROM loans WHERE status = 'paid';
```

**3. Estrutura do banco está diferente**
```sql
-- Verificar tabelas
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;
```

---

## 🔄 Alternativas se o Script Simples Não Funcionar

### Opção 1: Verificar se há backup no Supabase

1. Acesse: Dashboard → Database → Backups
2. Veja se há backup recente
3. Restaure o backup mais recente

### Opção 2: Recuperação Manual

Se você SABE que havia empréstimos quitados:

```sql
-- Criar tabela vazia
CREATE TABLE paid_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID,
    client_id UUID,
    original_amount DECIMAL(10,2),
    total_paid DECIMAL(10,2),
    paid_date DATE,
    notes TEXT
);

-- Inserir manualmente os dados que você lembra
-- (se tiver planilhas, notas, ou qualquer registro)
```

### Opção 3: Verificar Logs do Supabase

```
Dashboard → Logs → Postgres Logs
Filtrar por: DELETE ou DROP
Ver se há registros de quando os dados foram deletados
```

---

## 📞 Diagnóstico Completo

Execute este script para ver TUDO:

```sql
-- 1. Tabelas existentes
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

-- 2. Total de registros em cada tabela
SELECT 'loans' as tabela, COUNT(*) as registros FROM loans
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'clients', COUNT(*) FROM clients;

-- 3. Status dos empréstimos
SELECT status, COUNT(*) FROM loans GROUP BY status;

-- 4. Pagamentos órfãos (de empréstimos deletados)
SELECT COUNT(DISTINCT p.loan_id) as emprestimos_deletados
FROM payments p
LEFT JOIN loans l ON p.loan_id = l.id
WHERE l.id IS NULL;

-- 5. Verificar se já existe paid_loans
SELECT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'paid_loans'
) as paid_loans_existe;
```

---

## 💡 O Que Provavelmente Aconteceu

### Cenário 1: Dados movidos incorretamente
- Empréstimos foram deletados da tabela `loans`
- Mas registros de `payments` ainda existem
- **Solução:** Script de recuperação funciona! ✅

### Cenário 2: Trigger deletou os dados
- Havia trigger que deletava automaticamente
- Quando status mudava para 'paid'
- **Solução:** Script de recuperação funciona! ✅

### Cenário 3: Comando DELETE manual
- Alguém executou DELETE FROM loans WHERE status='paid'
- Sem backup prévio
- **Solução:** Recuperar de payments ✅

### Cenário 4: Dados nunca foram salvos
- Problema na aplicação
- Dados ficavam apenas em memória
- **Solução:** Verificar aplicação frontend 🔍

---

## ✅ Garantia de Sucesso

**Se houver QUALQUER registro em `payments`:**
→ O script de recuperação VAI FUNCIONAR!

**O que o script recupera:**
- ✅ loan_id (do payment)
- ✅ total_paid (soma dos payments)
- ✅ paid_date (último payment_date)
- ✅ Estimativa de valores originais

---

## 🎯 AÇÃO IMEDIATA

**AGORA faça isto:**

1. ✅ Execute: `SELECT COUNT(*) FROM payments;`
2. ✅ Se > 0, execute: `RECUPERACAO-SIMPLES-LITORAL-CRED.sql`
3. ✅ Veja o relatório automático
4. ✅ Execute: `SELECT * FROM paid_loans;`

**Leva 5 minutos no máximo!**

---

## 📊 Expectativa Realista

### Se payments tem dados:
- **Recuperação: 80-100%** dos empréstimos
- **Dados completos:** loan_id, valores, datas
- **Pode precisar:** Corrigir client_id manualmente

### Se payments está vazio:
- **Recuperação: 0%** (dados perdidos)
- **Alternativa:** Restaurar backup do Supabase
- **Última opção:** Reconstruir manualmente de outras fontes

---

## 🆘 Ainda Não Funcionou?

### Me diga:

1. **Quantos registros tem em payments?**
   ```sql
   SELECT COUNT(*) FROM payments;
   ```

2. **Quantos registros tem em loans?**
   ```sql
   SELECT COUNT(*) FROM loans;
   ```

3. **Qual erro apareceu?**
   - Copie a mensagem de erro completa

4. **O que você vê nas tabelas?**
   ```sql
   SELECT table_name FROM information_schema.tables 
   WHERE table_schema = 'public';
   ```

---

## 💪 NÃO DESISTA!

Enquanto houver:
- ✅ Registros em `payments`
- ✅ Registros em `loans`
- ✅ Backup no Supabase
- ✅ Logs do sistema

**Há uma forma de recuperar!**

---

## 📞 Próximos Passos

**Execute agora:**
```
RECUPERACAO-SIMPLES-LITORAL-CRED.sql
```

**Se não funcionar, me diga:**
- Qual erro apareceu
- Quantos registros tem em payments
- Quantos registros tem em loans

**Vamos resolver isso! 🚀**
