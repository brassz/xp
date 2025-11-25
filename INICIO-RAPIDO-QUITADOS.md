# ⚡ INÍCIO RÁPIDO - Corrigir Empréstimos Quitados

## 🎯 3 PASSOS SIMPLES

### 1️⃣ DIAGNÓSTICO (30 segundos)

```sql
-- Cole isso no SQL Editor do Supabase e execute:

SELECT 
    CASE WHEN EXISTS (SELECT FROM pg_tables WHERE tablename = 'paid_loans')
    THEN '✅ Tabela existe' 
    ELSE '❌ Tabela NÃO existe - Execute fix-litoral-paid-loans.sql' 
    END as resultado;
```

---

### 2️⃣ CORREÇÃO (1 minuto)

#### Se a tabela NÃO existe:
- Execute no SQL Editor: **`fix-litoral-paid-loans.sql`** (copie todo o arquivo)

#### Se a tabela existe mas não funciona:
- Execute no SQL Editor: **`fix-paid-loans-rls.sql`**

---

### 3️⃣ TESTAR (30 segundos)

1. Recarregue a página (F5)
2. Faça login na LITORAL CRED
3. Abra Console (F12)
4. Clique em "Marcar como Quitado"
5. Veja os logs - deve aparecer: `✅ Empréstimo inserido na tabela paid_loans com sucesso!`

---

## 🆘 SE NÃO FUNCIONAR

Execute no console (F12) após clicar em "Marcar como Quitado":

```javascript
// Copie TODOS os logs que aparecerem com ❌
```

E no SQL Editor:

```sql
-- Teste inserção manual
INSERT INTO paid_loans (
    loan_id, client_id, original_amount, interest_rate,
    total_with_interest, loan_date, due_date, paid_date,
    total_paid, payment_method, notes
) VALUES (
    gen_random_uuid(), gen_random_uuid(), 100, 5, 105,
    CURRENT_DATE, CURRENT_DATE, CURRENT_DATE, 105, 'Teste', 'TESTE'
) RETURNING *;

-- Funcionou? Deletar teste:
DELETE FROM paid_loans WHERE notes = 'TESTE';
```

Me envie:
- ✅ Resultado do teste SQL acima
- ✅ Todos os logs do console com ❌

---

## 📚 MAIS INFORMAÇÕES

Para guia completo passo a passo: **`GUIA-COMPLETO-QUITADOS.md`**

---

**Tempo Total**: ~2 minutos  
**Dificuldade**: ⭐ Fácil
