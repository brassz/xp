# 🚨 FIX COMPLETO - IMPERATRIZ CRED

## ❌ Problemas Atuais

1. **Erro ao criar empréstimo:**
   ```
   Could not find the 'original_amount' column of 'loans' in the schema cache
   ```

2. **Erro ao renovar empréstimo:**
   ```
   Could not find the 'fine_amount' column of 'payments' in the schema cache
   ```

3. **Valor restante zerado** ao criar empréstimos

## ⚡ Solução Completa (3 minutos)

### ✅ PASSO 1: Copie este código

```sql
-- Corrigir tabela LOANS
ALTER TABLE loans ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);
UPDATE loans SET original_amount = amount WHERE original_amount IS NULL;
ALTER TABLE loans ALTER COLUMN original_amount SET NOT NULL;
CREATE INDEX IF NOT EXISTS idx_loans_original_amount ON loans(original_amount);

-- Corrigir tabela PAYMENTS
ALTER TABLE payments ADD COLUMN IF NOT EXISTS fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);
CREATE INDEX IF NOT EXISTS idx_payments_fine_amount ON payments(fine_amount) WHERE fine_amount > 0;

-- Adicionar comentários
COMMENT ON COLUMN loans.original_amount IS 'Valor original do empréstimo (NUNCA alterado)';
COMMENT ON COLUMN payments.fine_amount IS 'Valor da multa (opcional, separado do valor principal)';
```

### ✅ PASSO 2: Execute no Supabase

1. Acesse: **https://eppzphzwwpvpoocospxy.supabase.co**
2. Vá em: **SQL Editor**
3. Cole o código acima
4. Clique: **Run**

### ✅ PASSO 3: Recarregue o Schema Cache

**MUITO IMPORTANTE!** Sem este passo, os erros continuarão!

1. Vá em: **Settings → API**
2. Encontre: **Schema Cache**
3. Clique: **"Reload schema"**
4. Aguarde: **30-60 segundos**

### ✅ PASSO 4: Teste

1. Selecione: **IMPERATRIZ CRED**
2. Teste criar um empréstimo ✅
3. Teste renovar um empréstimo ✅
4. Verifique o valor restante ✅

---

## 🎯 Resultado Esperado

### ✅ Depois do Fix:

- ✅ Criar empréstimos funciona perfeitamente
- ✅ Renovar empréstimos funciona sem erros
- ✅ Valor restante calculado corretamente
- ✅ Multas registradas sem problemas
- ✅ Dashboard atualiza corretamente

---

## 📄 Scripts Disponíveis

### Opção 1: Script Rápido (recomendado)
- Use o código acima (copiar e colar)

### Opção 2: Script Completo com Verificações
- Arquivo: **`FIX-COMPLETO-IMPERATRIZ.sql`**
- Inclui: Verificações, estatísticas e relatórios

---

## 🆘 Se Ainda Houver Erro

### Método 1: Recarregar Schema via SQL
```sql
NOTIFY pgrst, 'reload schema';
```

### Método 2: Reiniciar API
1. **Settings → API**
2. Clique: **"Restart API"**
3. Aguarde: **1-2 minutos**
4. Teste novamente

### Método 3: Limpar Cache do Navegador
1. Pressione: **Ctrl + Shift + Delete**
2. Marque: "Cache" e "Cookies"
3. Clique: "Limpar dados"
4. Recarregue a página

---

## 💡 O Que Foi Corrigido

### Tabela LOANS

**Antes:**
```sql
CREATE TABLE loans (
    amount DECIMAL(10,2),        -- ❌ Sem original_amount
    interest_rate DECIMAL(5,2)
);
```

**Depois:**
```sql
CREATE TABLE loans (
    amount DECIMAL(10,2),
    original_amount DECIMAL(10,2),  -- ✅ Adicionado!
    interest_rate DECIMAL(5,2)
);
```

### Tabela PAYMENTS

**Antes:**
```sql
CREATE TABLE payments (
    amount DECIMAL(10,2),         -- ❌ Sem fine_amount
    payment_date DATE
);
```

**Depois:**
```sql
CREATE TABLE payments (
    amount DECIMAL(10,2),
    fine_amount DECIMAL(10,2),    -- ✅ Adicionado!
    payment_date DATE
);
```

---

## 📊 Exemplo Prático

### Criar Empréstimo
```
Cliente: Maria Silva
Valor: R$ 3.000,00
Juros: 3%
Total: R$ 3.090,00

✅ ANTES DO FIX: Erro!
✅ DEPOIS DO FIX: Sucesso!
✅ Valor restante: R$ 3.090,00 (correto!)
```

### Renovar Empréstimo
```
Empréstimo anterior: R$ 5.000,00
Multa: R$ 50,00
Juros renovação: R$ 150,00

✅ ANTES DO FIX: Erro fine_amount!
✅ DEPOIS DO FIX: Sucesso!
✅ Multa registrada: R$ 50,00
```

---

## ⏱️ Tempo Estimado

- **Executar script:** 10 segundos
- **Recarregar cache:** 30 segundos
- **Testar:** 1 minuto
- **Total:** ~2-3 minutos

---

## ✅ Checklist

- [ ] Acessei o Supabase da IMPERATRIZ
- [ ] Executei o script SQL
- [ ] Recarreguei o schema cache
- [ ] Aguardei 30-60 segundos
- [ ] Testei criar empréstimo ✅
- [ ] Testei renovar empréstimo ✅
- [ ] Valor restante aparece correto ✅
- [ ] Sem mais erros! 🎉

---

**🎉 Sistema 100% funcional na IMPERATRIZ CRED!**
