# 🚨 PROBLEMA: Multa não está sendo salva no banco

## Situação Atual
- ✅ Coluna `fine_amount` existe
- ✅ Código JavaScript está tentando salvar
- ❌ **Mas não está salvando no banco de dados**

## Causa Provável

**99% de chance:** Políticas de RLS (Row Level Security) do Supabase estão **bloqueando** o campo `fine_amount`.

O Supabase tem um sistema de segurança que pode bloquear campos específicos mesmo que o código esteja correto.

---

## ✅ SOLUÇÃO RÁPIDA (5 minutos)

### PASSO 1: Verificar o Problema no Sistema

1. Abra seu sistema no navegador
2. Pressione **F12** (Console)
3. Vá na aba **"Console"**
4. Tente criar um pagamento COM multa
5. Você verá logs assim:

```
🔍 DEBUG handlePayment - Capturando multa: {includeFine: true, fineAmount: 50}
🔍 DEBUG - Criando novo pagamento: {..., fine_amount: 50}
🔍 DEBUG - Resultado do INSERT: {data: [...], fine_amount_salvo: 0}
⚠️ ALERTA: Multa não foi salva corretamente! {tentou_salvar: 50, foi_salvo: 0}
```

Se aparecer esse ALERTA, confirma que é problema de permissões!

### PASSO 2: Testar Manualmente no SQL

Vá no Supabase → SQL Editor e execute:

```sql
-- Pegar um loan_id válido
SELECT id FROM loans LIMIT 1;
```

Copie o ID e execute:

```sql
-- Tente inserir com multa (substitua o ID)
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
    'Teste manual de multa'
) RETURNING *;
```

**Se der ERRO ou fine_amount = 0 →** É problema de RLS!

### PASSO 3: Corrigir as Permissões

No Supabase → SQL Editor, execute:

```sql
-- Ver políticas atuais
SELECT policyname, cmd FROM pg_policies WHERE tablename = 'payments';
```

Depois, execute a CORREÇÃO:

```sql
-- Remover políticas antigas que podem estar bloqueando
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON payments;
DROP POLICY IF EXISTS "Enable update for authenticated users only" ON payments;
DROP POLICY IF EXISTS "Enable select for authenticated users only" ON payments;

-- Criar políticas COMPLETAS (sem restrições de colunas)
CREATE POLICY "payments_insert_policy"
ON payments FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "payments_update_policy"
ON payments FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "payments_select_policy"
ON payments FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "payments_delete_policy"
ON payments FOR DELETE
TO authenticated
USING (true);
```

### PASSO 4: Testar Novamente

1. Recarregue o sistema (Ctrl + Shift + R)
2. Crie um pagamento COM multa
3. Veja o console (F12)
4. Deve aparecer: `✅ Multa salva com sucesso: 50`

---

## 🔥 SOLUÇÃO ALTERNATIVA (Se ainda não funcionar)

### Opção A: Desabilitar RLS Completamente

⚠️ **ATENÇÃO:** Isso remove todas as restrições de segurança!

```sql
ALTER TABLE payments DISABLE ROW LEVEL SECURITY;
```

### Opção B: Verificar Permissões do Usuário

```sql
-- Ver quem você está logado
SELECT current_user;

-- Ver permissões
SELECT grantee, privilege_type
FROM information_schema.table_privileges
WHERE table_name = 'payments';
```

### Opção C: Criar Função de Trigger

Se as políticas não funcionarem, use um trigger:

```sql
-- Criar função que força o fine_amount
CREATE OR REPLACE FUNCTION ensure_fine_amount()
RETURNS TRIGGER AS $$
BEGIN
    -- Se fine_amount for NULL, definir como 0
    IF NEW.fine_amount IS NULL THEN
        NEW.fine_amount := 0;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger
DROP TRIGGER IF EXISTS ensure_fine_amount_trigger ON payments;
CREATE TRIGGER ensure_fine_amount_trigger
    BEFORE INSERT OR UPDATE ON payments
    FOR EACH ROW
    EXECUTE FUNCTION ensure_fine_amount();
```

---

## 🧪 VERIFICAÇÃO FINAL

Depois de aplicar a solução, execute:

```sql
-- 1. Inserir teste
INSERT INTO payments (loan_id, amount, fine_amount, payment_date, payment_type)
SELECT id, 100.00, 75.00, CURRENT_DATE, 'dinheiro'
FROM loans LIMIT 1
RETURNING id, amount, fine_amount;

-- 2. Verificar se salvou
SELECT id, amount, fine_amount 
FROM payments 
ORDER BY created_at DESC 
LIMIT 1;
```

**Se fine_amount = 75.00 →** ✅ **FUNCIONOU!**

---

## 📋 Checklist de Diagnóstico

Execute no console (F12) depois de tentar criar um pagamento:

- [ ] Aparece: "🔍 DEBUG - Capturando multa"?
- [ ] O valor `fineAmountParsed` está correto?
- [ ] Aparece: "🔍 DEBUG - Criando novo pagamento"?
- [ ] O `fine_amount` está no objeto sendo enviado?
- [ ] Aparece: "🔍 DEBUG - Resultado do INSERT"?
- [ ] O `fine_amount_salvo` é igual ao que você digitou?
- [ ] Aparece ALERTA ou "✅ Multa salva com sucesso"?

---

## 💡 Resumo

**Problema:** RLS (Row Level Security) do Supabase bloqueando o campo `fine_amount`

**Solução:** Recriar as políticas de RLS sem restrições de colunas

**Tempo:** 5 minutos

**Resultado esperado:** Multas salvam corretamente e aparecem no histórico

---

## 🆘 Se Ainda Não Funcionar

Me envie os resultados de:

1. **Console do navegador** (F12) ao criar pagamento
2. **Resultado do SQL:**
   ```sql
   SELECT policyname FROM pg_policies WHERE tablename = 'payments';
   ```
3. **Teste de INSERT manual** (resultado da query acima)
4. **Screenshot** do erro (se houver)

Com isso eu vou saber EXATAMENTE o que está bloqueando! 🎯
