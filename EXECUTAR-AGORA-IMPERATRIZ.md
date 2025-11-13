# 🚨 EXECUTAR AGORA - IMPERATRIZ CRED

## ⚡ Solução em 3 Passos (2 minutos)

### ✅ PASSO 1: Copie este código

```sql
ALTER TABLE loans ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);
UPDATE loans SET original_amount = amount WHERE original_amount IS NULL;
ALTER TABLE loans ALTER COLUMN original_amount SET NOT NULL;
CREATE INDEX IF NOT EXISTS idx_loans_original_amount ON loans(original_amount);
COMMENT ON COLUMN loans.original_amount IS 'Valor original do empréstimo';
```

### ✅ PASSO 2: Execute no Supabase

1. Acesse: https://eppzphzwwpvpoocospxy.supabase.co
2. Vá em: **SQL Editor**
3. Cole o código acima
4. Clique: **Run**

### ✅ PASSO 3: Recarregue o Cache

1. Vá em: **Settings → API**
2. Encontre: **Schema Cache**
3. Clique: **"Reload schema"**
4. Aguarde: **30 segundos**

---

## 🧪 Teste

1. Selecione empresa: **IMPERATRIZ CRED**
2. Crie um novo empréstimo
3. ✅ Deve funcionar sem erros!
4. ✅ Valor restante deve aparecer corretamente!

---

## 🆘 Ainda com erro?

Execute também:
```sql
NOTIFY pgrst, 'reload schema';
```

Ou reinicie a API:
**Settings → API → Restart API**

---

**Isso resolve:**
- ✅ Erro do schema cache
- ✅ Valor restante zerado
- ✅ Impossibilidade de criar empréstimos
