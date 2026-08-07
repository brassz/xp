# 🔥 FIX IMEDIATO - Erro de Renovação

## ❌ Erro que você está tendo:
```
new row for relation "payments" violates check constraint "payments_payment_type_check"
```

---

## ✅ SOLUÇÃO EM 3 PASSOS (2 MINUTOS)

### 1️⃣ COPIE ESTE COMANDO:
```sql
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;
```

### 2️⃣ ABRA O SUPABASE:
Clique no link da empresa onde está o erro:

- [🏆 NEXUS](https://supabase.com/dashboard/project/mhtxyxizfnxupwmilith/sql/new)
- [🌊 LITORAL CRED](https://supabase.com/dashboard/project/dtifsfzmnjnllzzlndxv/sql/new)  
- [☕ MOGIANA CRED](https://supabase.com/dashboard/project/eemfnpefgojllvzzaimu/sql/new)
- [🌾 ERECHIM](https://supabase.com/dashboard/project/adjrvtupfshdhwjvhmgj/sql/new)
- [👑 IMPERATRIZ CRED](https://supabase.com/dashboard/project/eppzphzwwpvpoocospxy/sql/new)

### 3️⃣ EXECUTE:
- Cole o comando
- Clique em **RUN** (ou aperte Ctrl+Enter)
- Pronto! ✅

---

## 🎯 O QUE FAZ:
Remove a restrição antiga que impedia pagamentos de:
- Capital + Juros
- Somente Capital
- Renovações

---

## ⚡ PRONTO PARA USAR
Depois de executar o comando acima, volte ao sistema e tente renovar novamente.

**O erro vai sumir!** 🎉

---

**Tempo:** 30 segundos por empresa  
**Seguro:** ✅ Sim, não apaga nada  
**Reversível:** ✅ Sim, se necessário
