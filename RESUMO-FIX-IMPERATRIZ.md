# ⚡ RESUMO - Fix IMPERATRIZ CRED

## 🚨 Problemas
1. ❌ Erro: "Could not find the 'original_amount' column of 'loans' in the schema cache"
2. ❌ Valor restante zerado ao criar empréstimos

## ✅ Solução Rápida (2 minutos)

### 1. Execute no SQL Editor
Banco: **https://eppzphzwwpvpoocospxy.supabase.co**

```sql
ALTER TABLE loans ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);
UPDATE loans SET original_amount = amount WHERE original_amount IS NULL;
ALTER TABLE loans ALTER COLUMN original_amount SET NOT NULL;
CREATE INDEX IF NOT EXISTS idx_loans_original_amount ON loans(original_amount);
```

### 2. Recarregar Schema Cache
**Settings → API → Schema Cache → "Reload schema"**

### 3. Aguardar 30 segundos ⏱️

### 4. Testar ✅
- Selecione IMPERATRIZ CRED
- Crie um novo empréstimo
- Verifique o valor restante

## 📄 Arquivos

### Scripts SQL:
- **`FIX-RAPIDO-IMPERATRIZ.sql`** - Script minimalista (use este!)
- **`fix-imperatriz-original-amount.sql`** - Script completo com verificações

### Documentação:
- **`INSTRUCOES-FIX-IMPERATRIZ-URGENTE.md`** - Guia passo a passo detalhado
- **`README-IMPERATRIZ-CRED.md`** - Configuração da empresa

## 🆘 Problema Persistindo?

1. Reinicie a API: **Settings → API → Restart API**
2. Aguarde 1-2 minutos
3. Limpe cache do navegador
4. Teste novamente

---

✅ **Após fix:** Sistema 100% funcional na IMPERATRIZ CRED
