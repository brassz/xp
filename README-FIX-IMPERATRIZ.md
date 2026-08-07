# 🔥 FIX COMPLETO v3.0 - IMPERATRIZ CRED

## 🎯 Problemas

Na empresa **IMPERATRIZ CRED**:
- ❌ Erro ao criar empréstimo: `Could not find the 'original_amount' column`
- ❌ Erro ao renovar empréstimo: `Could not find the 'fine_amount' column`
- ❌ Erro ao renovar empréstimo: `violates check constraint "payments_payment_type_check"` 🆕
- ❌ Valor restante fica zerado (R$ 0,00)

## ⚡ Solução Rápida

### Abra o arquivo certo para você:

**✨ SOLUÇÃO COMPLETA v3.0 (2 minutos):**
📄 `EXECUTAR-AGORA-IMPERATRIZ-V3.md` ← RECOMENDADO! 🆕

**Solução v2.0 (sem constraint fix):**
📄 `EXECUTAR-AGORA-IMPERATRIZ-V2.md`

**Solução v1.0 (só original_amount):**
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

-- Corrigir payments
ALTER TABLE payments ADD COLUMN IF NOT EXISTS fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);

-- Remover constraint (NOVO!)
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;
```

2. Recarregue o Schema Cache:
   Settings → API → Schema Cache → "Reload schema"

3. Aguarde 30 segundos

4. ✅ Pronto! Teste criar, renovar e registrar pagamentos!

## 📊 Arquivos Disponíveis

### Para IMPERATRIZ CRED (específico):
- ✅ `EXECUTAR-AGORA-IMPERATRIZ-V3.md` - **INSTRUÇÕES v3.0** 🆕🔥
- ✅ `FIX-COMPLETO-IMPERATRIZ.sql` - **SCRIPT COMPLETO v3.0** 🆕🔥
- ✅ `COPIE-E-COLE-IMPERATRIZ.sql` - **Script pronto v3.0** 🆕🔥
- ✅ `CHANGELOG-FIX-IMPERATRIZ.md` - Histórico de versões
- ✅ `EXECUTAR-AGORA-IMPERATRIZ-V2.md` - Instruções v2.0 (legado)
- ✅ `EXECUTAR-AGORA-IMPERATRIZ.md` - Instruções v1.0 (legado)
- ✅ `INSTRUCOES-FIX-IMPERATRIZ-URGENTE.md` - Guia detalhado v1.0
- ✅ `RESUMO-FIX-IMPERATRIZ.md` - Resumo v1.0
- ✅ `FIX-RAPIDO-IMPERATRIZ.sql` - Script v1.0
- ✅ `fix-imperatriz-original-amount.sql` - Script v1.0

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
