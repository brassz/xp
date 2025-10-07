# 🚨 INSTRUÇÕES URGENTES - MOGIANA CRED

## ⚡ PARE TUDO E FAÇA ISSO AGORA:

### 1️⃣ ACESSE O SUPABASE DA MOGIANA
- URL: `https://eemfnpefgojllvzzaimu.supabase.co`
- Faça login no painel do Supabase

### 2️⃣ VÁ PARA O SQL EDITOR
- No menu lateral, clique em **"SQL Editor"**
- Clique em **"New Query"**

### 3️⃣ COLE E EXECUTE ESTE CÓDIGO:
```sql
-- CORREÇÃO URGENTE - MOGIANA CRED
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;

ALTER TABLE payments ADD CONSTRAINT payments_payment_type_check 
CHECK (payment_type IN (
    'partial', 
    'full', 
    'interest_renewal', 
    'early_payment_partial_interest', 
    'early_payment_interest_renewal', 
    'early_payment_capital_reduction', 
    'capital_payment', 
    'partial_interest', 
    'adjustment',
    'renewal'
));
```

### 4️⃣ CLIQUE EM "RUN"
- Aguarde a execução
- Deve aparecer "Success. No rows returned"

### 5️⃣ TESTE O PAGAMENTO
- Volte para sua aplicação
- Tente registrar o pagamento novamente
- O erro deve ter sido resolvido

---

## ❌ SE AINDA DER ERRO:

### Verifique se está no banco correto:
1. No Supabase, vá em **Settings** → **General**
2. Confirme se a URL é: `https://eemfnpefgojllvzzaimu.supabase.co`
3. Se não for, você está no banco errado!

### Ou execute este comando para verificar:
```sql
SELECT 
    conname as constraint_name,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE conrelid = 'payments'::regclass 
AND conname = 'payments_payment_type_check';
```

---

## 📞 PRECISA DE AJUDA?
Se ainda não funcionar, me informe:
1. Qual mensagem apareceu após executar o SQL?
2. O erro ainda persiste?
3. Conseguiu acessar o Supabase correto?