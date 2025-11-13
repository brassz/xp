# 🔥 FIX COMPLETO - IMPERATRIZ CRED

## 🎯 Problemas

Na empresa **IMPERATRIZ CRED**:
- ❌ Erro ao criar empréstimo: `Could not find the 'original_amount' column`
- ❌ Erro ao renovar empréstimo: `Could not find the 'fine_amount' column`
- ❌ Valor restante fica zerado (R$ 0,00)

## ⚡ Solução Rápida

### Abra o arquivo certo para você:

**✨ SOLUÇÃO COMPLETA (2 minutos):**
📄 `EXECUTAR-AGORA-IMPERATRIZ-V2.md` ← RECOMENDADO! 🆕

**Solução antiga (só original_amount):**
📄 `EXECUTAR-AGORA-IMPERATRIZ.md`

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
-- Corrigir loans
ALTER TABLE loans ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);
UPDATE loans SET original_amount = amount WHERE original_amount IS NULL;
ALTER TABLE loans ALTER COLUMN original_amount SET NOT NULL;

-- Corrigir payments (NOVO!)
ALTER TABLE payments ADD COLUMN IF NOT EXISTS fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);
```

2. Recarregue o Schema Cache:
   Settings → API → Schema Cache → "Reload schema"

3. Aguarde 30 segundos

4. ✅ Pronto! Teste criar E renovar empréstimos

## 📊 Arquivos Disponíveis

### Para IMPERATRIZ CRED (específico):
- ✅ `EXECUTAR-AGORA-IMPERATRIZ-V2.md` - **INSTRUÇÕES COMPLETAS** 🆕
- ✅ `FIX-COMPLETO-IMPERATRIZ.sql` - **SCRIPT COMPLETO** 🆕
- ✅ `EXECUTAR-AGORA-IMPERATRIZ.md` - Fix original_amount apenas
- ✅ `INSTRUCOES-FIX-IMPERATRIZ-URGENTE.md` - Guia detalhado
- ✅ `RESUMO-FIX-IMPERATRIZ.md` - Resumo executivo
- ✅ `FIX-RAPIDO-IMPERATRIZ.sql` - Script minimalista
- ✅ `fix-imperatriz-original-amount.sql` - Script original_amount

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

**P: Por que só a IMPERATRIZ tem esses problemas?**
R: O banco da IMPERATRIZ foi criado antes das migrações que adicionam `original_amount` e `fine_amount`. Outras empresas já têm essas colunas.

**P: Vai afetar empréstimos e pagamentos existentes?**
R: Não! O script preserva todos os dados. Empréstimos existentes terão `original_amount = amount` e pagamentos terão `fine_amount = 0.00`.

**P: Preciso fazer backup antes?**
R: Não é necessário, mas nunca faz mal. O script usa `IF NOT EXISTS` para evitar erros.

**P: Quanto tempo demora?**
R: 2-5 minutos no total (30s para executar + 30s para cache + 1min de teste)

**P: E se der erro?**
R: Provavelmente a coluna já existe. Só recarregue o schema cache e teste.

---

**🎉 Após executar:** Sistema 100% funcional na IMPERATRIZ CRED!
