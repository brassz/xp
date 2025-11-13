# 🔥 FIX IMPERATRIZ CRED - Valor Restante Zerado

## 🎯 Problema

Na empresa **IMPERATRIZ CRED**:
- ❌ Erro ao criar empréstimo: `Could not find the 'original_amount' column`
- ❌ Valor restante fica zerado (R$ 0,00)

## ⚡ Solução Rápida

### Abra o arquivo certo para você:

**Tenho pressa (2 minutos):**
📄 `EXECUTAR-AGORA-IMPERATRIZ.md` ← RECOMENDADO!

**Quero entender tudo (5 minutos):**
📄 `INSTRUCOES-FIX-IMPERATRIZ-URGENTE.md`

**Só preciso do script SQL:**
📄 `FIX-RAPIDO-IMPERATRIZ.sql`

**Quero a versão com todas verificações:**
📄 `fix-imperatriz-original-amount.sql`

**Só um resumo:**
📄 `RESUMO-FIX-IMPERATRIZ.md`

## 🚀 TL;DR

1. Execute no SQL Editor da IMPERATRIZ:
```sql
ALTER TABLE loans ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);
UPDATE loans SET original_amount = amount WHERE original_amount IS NULL;
ALTER TABLE loans ALTER COLUMN original_amount SET NOT NULL;
```

2. Recarregue o Schema Cache:
   Settings → API → Schema Cache → "Reload schema"

3. Aguarde 30 segundos

4. ✅ Pronto! Teste criar um empréstimo

## 📊 Arquivos Disponíveis

### Para IMPERATRIZ CRED (específico):
- ✅ `EXECUTAR-AGORA-IMPERATRIZ.md` - Instruções diretas
- ✅ `INSTRUCOES-FIX-IMPERATRIZ-URGENTE.md` - Guia completo
- ✅ `RESUMO-FIX-IMPERATRIZ.md` - Resumo executivo
- ✅ `FIX-RAPIDO-IMPERATRIZ.sql` - Script minimalista
- ✅ `fix-imperatriz-original-amount.sql` - Script completo

### Para outras empresas (genérico):
- ✅ `fix-schema-cache-original-amount.sql` - Script universal
- ✅ `INSTRUCOES-FIX-SCHEMA-CACHE.md` - Guia detalhado
- ✅ `SOLUCAO-RAPIDA-SCHEMA-CACHE.md` - Solução rápida

## 🔗 Links Úteis

**Supabase IMPERATRIZ:**
https://eppzphzwwpvpoocospxy.supabase.co

**Caminho no Dashboard:**
SQL Editor → Cole o script → Run → Settings → API → Reload Schema

## ❓ FAQ

**P: Por que só a IMPERATRIZ tem esse problema?**
R: O banco da IMPERATRIZ foi criado antes da migração que adiciona o `original_amount`. Outras empresas já têm essa coluna.

**P: Vai afetar empréstimos existentes?**
R: Não! O script preserva todos os dados. Empréstimos existentes terão `original_amount = amount`.

**P: Preciso fazer backup antes?**
R: Não é necessário, mas nunca faz mal. O script usa `IF NOT EXISTS` para evitar erros.

**P: Quanto tempo demora?**
R: 2-5 minutos no total (30s para executar + 30s para cache + 1min de teste)

**P: E se der erro?**
R: Provavelmente a coluna já existe. Só recarregue o schema cache e teste.

---

**🎉 Após executar:** Sistema 100% funcional na IMPERATRIZ CRED!
