# ⚡ SOLUÇÃO RÁPIDA - Erro Schema Cache

## ❌ Erro
```
Could not find the 'original_amount' column of 'loans' in the schema cache
```

## ✅ Solução Rápida (2 minutos)

### 1️⃣ Execute no SQL Editor do Supabase:

```sql
-- Adicionar coluna original_amount
ALTER TABLE loans ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);

-- Preencher valores existentes
UPDATE loans SET original_amount = amount WHERE original_amount IS NULL;

-- Tornar obrigatório
ALTER TABLE loans ALTER COLUMN original_amount SET NOT NULL;

-- Criar índice
CREATE INDEX IF NOT EXISTS idx_loans_original_amount ON loans(original_amount);
```

### 2️⃣ Recarregar Schema Cache:

**Opção A** (Recomendado):
- Vá em: **Settings → API → Schema Cache**
- Clique: **"Reload schema"**

**Opção B** (Alternativa):
```sql
NOTIFY pgrst, 'reload schema';
```

### 3️⃣ Aguarde 30 segundos

### 4️⃣ Teste criar um empréstimo ✅

---

## 📄 Documentação Completa
- `INSTRUCOES-FIX-SCHEMA-CACHE.md` - Instruções detalhadas
- `fix-schema-cache-original-amount.sql` - Script completo

## 🆘 Ainda com erro?
1. Reinicie a API do Supabase: **Settings → API → Restart API**
2. Aguarde 1-2 minutos
3. Tente novamente
