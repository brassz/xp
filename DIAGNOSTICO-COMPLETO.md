# 🔥 DIAGNÓSTICO COMPLETO - Multa Não Salva

## TESTE 1: Ver o que o Console mostra

1. Abra seu sistema no navegador
2. Pressione **F12**
3. Vá na aba **Console**
4. Limpe o console (ícone 🚫 ou Ctrl+L)
5. Tente criar um pagamento COM multa

**Me envie TUDO que aparecer no console, principalmente:**
- "🔍 DEBUG handlePayment - Capturando multa"
- "🔍 DEBUG - Criando novo pagamento"
- "🔍 DEBUG - Resultado do INSERT"
- Qualquer erro em vermelho

---

## TESTE 2: Verificar no Banco (CRITICAL)

No Supabase → SQL Editor, execute LINHA POR LINHA:

### A) Ver estrutura da coluna
```sql
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    is_updatable
FROM information_schema.columns 
WHERE table_name = 'payments' 
AND column_name = 'fine_amount';
```

**Me envie o resultado!**

### B) Ver se RLS está habilitado
```sql
SELECT 
    tablename,
    rowsecurity
FROM pg_tables
WHERE tablename = 'payments';
```

**rowsecurity = true ou false?**

### C) Ver todas as políticas
```sql
SELECT 
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'payments';
```

**Me envie TODAS as políticas!**

### D) Tentar INSERT manual DIRETO
```sql
-- Pegar loan_id
SELECT id FROM loans LIMIT 1;
```

Copie o ID e execute:

```sql
-- SUBSTITUA o ID abaixo
INSERT INTO payments (
    loan_id,
    amount,
    fine_amount,
    payment_date,
    payment_type,
    notes
) VALUES (
    'COLE_O_LOAN_ID_AQUI',
    100.00,
    50.00,
    CURRENT_DATE,
    'dinheiro',
    'TESTE MANUAL'
) RETURNING *;
```

**CRITICAL: Funcionou? Qual o valor de fine_amount no resultado?**

### E) Buscar o pagamento criado
```sql
SELECT 
    id,
    amount,
    fine_amount,
    notes
FROM payments
WHERE notes LIKE '%TESTE MANUAL%'
ORDER BY created_at DESC
LIMIT 1;
```

**fine_amount = 50.00 ou 0.00?**

---

## TESTE 3: Verificar Constraints

```sql
SELECT
    conname as constraint_name,
    contype as constraint_type,
    pg_get_constraintdef(oid) as definition
FROM pg_constraint
WHERE conrelid = 'payments'::regclass;
```

**Me envie TODOS os constraints!**

---

## TESTE 4: Ver permissões do seu usuário

```sql
-- Ver seu usuário atual
SELECT current_user, session_user;

-- Ver permissões na tabela
SELECT 
    grantee,
    privilege_type
FROM information_schema.table_privileges
WHERE table_name = 'payments';
```

**Quem é o current_user?**

---

## TESTE 5: Verificar se a coluna REALMENTE existe

```sql
-- Ver TODAS as colunas da tabela payments
SELECT 
    column_name,
    ordinal_position,
    data_type
FROM information_schema.columns 
WHERE table_name = 'payments'
ORDER BY ordinal_position;
```

**fine_amount aparece na lista?**

---

## TESTE DEFINITIVO: Bypass Total

Se NADA funcionar, tente isto no SQL:

```sql
-- Desabilitar TUDO que pode bloquear
ALTER TABLE payments DISABLE ROW LEVEL SECURITY;
ALTER TABLE payments DISABLE TRIGGER ALL;

-- Tentar inserir novamente
INSERT INTO payments (
    loan_id,
    amount,
    fine_amount,
    payment_date,
    payment_type
) 
SELECT 
    id,
    100.00,
    75.00,
    CURRENT_DATE,
    'dinheiro'
FROM loans 
LIMIT 1
RETURNING id, amount, fine_amount;
```

**FUNCIONOU AGORA?**

---

## 📊 RESULTADO ESPERADO

Depois de executar todos os testes acima, me diga:

1. **Console do navegador:** Cole TODO o texto que apareceu
2. **TESTE 2-A:** Coluna existe? Qual o `is_updatable`?
3. **TESTE 2-B:** RLS está true ou false?
4. **TESTE 2-C:** Quais políticas existem?
5. **TESTE 2-D:** INSERT manual funcionou? fine_amount = 50?
6. **TESTE 2-E:** O pagamento foi salvo com multa?
7. **TESTE 3:** Algum constraint bloqueando?
8. **TESTE 4:** Qual seu usuário?
9. **TESTE 5:** fine_amount aparece?
10. **TESTE DEFINITIVO:** Funcionou com RLS desabilitado?

**COM ESSAS INFORMAÇÕES EU VOU SABER EXATAMENTE O QUE ESTÁ ERRADO!**

---

## 🚨 ATENÇÃO

**NÃO pule nenhum teste!** Cada um revela uma informação importante.

Copie e cole os resultados de TODOS os testes.
