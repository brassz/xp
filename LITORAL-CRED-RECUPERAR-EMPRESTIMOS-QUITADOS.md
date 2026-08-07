# Recuperação de Empréstimos Quitados - Litoral Cred

## 🚨 Problema Identificado
Os empréstimos quitados sumiram do banco de dados da empresa **Litoral Cred**.

## 🔍 Possíveis Causas

1. **Tabela `paid_loans` não existe** no banco da Litoral Cred
2. **Triggers não foram criados** para mover empréstimos quitados
3. **Empréstimos foram deletados** da tabela `loans` sem backup
4. **Foreign keys com CASCADE** deletaram os registros
5. **Políticas RLS** estão bloqueando visualização

## 📋 Solução Passo a Passo

### Passo 1: Diagnóstico Inicial

Execute este script no SQL Editor do Supabase da **Litoral Cred** (`https://dtifsfzmnjnllzzlndxv.supabase.co`):

```sql
-- =====================================================
-- DIAGNÓSTICO COMPLETO - LITORAL CRED
-- =====================================================

-- 1. Verificar se a tabela paid_loans existe
SELECT 
    EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'paid_loans'
    ) AS paid_loans_existe;

-- 2. Verificar empréstimos com status 'paid' na tabela loans
SELECT COUNT(*) AS emprestimos_paid_na_loans
FROM loans 
WHERE status = 'paid';

-- 3. Verificar total de empréstimos por status
SELECT 
    status,
    COUNT(*) as quantidade,
    SUM(amount) as total_valor
FROM loans
GROUP BY status
ORDER BY status;

-- 4. Verificar se há registros na tabela paid_loans (se existir)
SELECT COUNT(*) AS registros_em_paid_loans
FROM paid_loans;

-- 5. Verificar empréstimos que foram completamente pagos mas não estão marcados como 'paid'
SELECT 
    l.id,
    l.client_id,
    l.amount,
    l.interest_rate,
    l.status,
    l.amount + (l.amount * l.interest_rate / 100) as total_com_juros,
    COALESCE(SUM(p.amount), 0) as total_pago
FROM loans l
LEFT JOIN payments p ON l.id = p.loan_id
GROUP BY l.id, l.client_id, l.amount, l.interest_rate, l.status
HAVING COALESCE(SUM(p.amount), 0) >= (l.amount + (l.amount * l.interest_rate / 100))
ORDER BY l.created_at DESC;

-- 6. Verificar histórico de pagamentos de empréstimos que podem ter sido deletados
SELECT 
    p.loan_id,
    COUNT(*) as num_pagamentos,
    SUM(p.amount) as total_pago,
    MIN(p.payment_date) as primeiro_pagamento,
    MAX(p.payment_date) as ultimo_pagamento,
    STRING_AGG(p.id::text, ', ') as ids_pagamentos
FROM payments p
LEFT JOIN loans l ON p.loan_id = l.id
WHERE l.id IS NULL  -- Empréstimos que foram deletados
GROUP BY p.loan_id
ORDER BY ultimo_pagamento DESC;

-- 7. Verificar triggers existentes na tabela loans
SELECT 
    trigger_name,
    event_manipulation,
    action_statement
FROM information_schema.triggers
WHERE event_object_table = 'loans'
ORDER BY trigger_name;
```

### Passo 2: Criar/Recriar Estrutura de Tabelas

Execute o script `litoral-cred-restore-paid-loans.sql` (criado abaixo) no SQL Editor.

### Passo 3: Recuperar Dados Históricos

Depois de criar a estrutura, execute o script de recuperação de dados.

---

## 📝 Instruções de Uso

### 1. Conecte-se ao Banco da Litoral Cred

- Acesse: `https://app.supabase.com/project/dtifsfzmnjnllzzlndxv`
- Vá em: **SQL Editor** > **New Query**

### 2. Execute o Diagnóstico

Cole e execute o script do **Passo 1** acima para identificar o problema exato.

### 3. Execute os Scripts de Recuperação

Execute os scripts fornecidos na ordem indicada.

---

## 🔧 Scripts de Recuperação

Veja os arquivos:
- `litoral-cred-restore-paid-loans.sql` - Cria/recria a estrutura completa
- `litoral-cred-recover-data.sql` - Recupera dados históricos baseado em pagamentos

---

## ⚠️ Importante

- **Faça backup** antes de executar qualquer script
- **Execute no banco correto**: Litoral Cred (dtifsfzmnjnllzzlndxv)
- **Teste primeiro** com `SELECT` antes de `INSERT/UPDATE`
- **Documente** as alterações realizadas

---

## 📞 Suporte

Se os empréstimos foram **deletados permanentemente** da tabela `loans` e não há backup, a recuperação será baseada nos registros da tabela `payments`. O sistema irá reconstruir os empréstimos quitados com base no histórico de pagamentos.
