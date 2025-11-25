# 🔍 TROUBLESHOOTING - Erro Persiste

## ❌ Situação: Executou o fix mas o erro continua

---

## 🔎 PASSO 1: DIAGNÓSTICO

Execute este script no Supabase SQL Editor para descobrir o problema:

```sql
-- Verificar se a constraint ainda existe
SELECT 
    conname as constraint_name,
    pg_get_constraintdef(oid) as definition
FROM pg_constraint 
WHERE conrelid = 'payments'::regclass 
  AND conname LIKE '%payment_type%';
```

### Resultados Possíveis:

**A) Se retornar VAZIO (nenhuma linha):**
- ✅ Constraint foi removida
- ❓ O erro pode ser de cache ou outra causa
- → Vá para **PASSO 2**

**B) Se retornar 1 ou mais linhas:**
- ❌ Constraint ainda existe
- → Vá para **PASSO 3**

---

## 🔄 PASSO 2: LIMPAR CACHE

Se a constraint foi removida mas erro persiste:

### A) Limpar Cache do Navegador:
1. Pressione **Ctrl+Shift+Del** (ou Cmd+Shift+Del no Mac)
2. Marque "Cache" e "Cookies"
3. Clique em "Limpar dados"
4. **Feche e reabra o navegador**

### B) Fazer Logout/Login no Sistema:
1. Saia do sistema Nexus
2. Feche a aba
3. Abra uma nova aba
4. Entre novamente

### C) Verificar Empresa Correta:
- ⚠️ Você aplicou o fix na empresa CERTA?
- Verifique qual empresa está selecionada no sistema
- Aplique o fix nessa empresa específica

### D) Recarregar Conexão Supabase:
Execute este no console do navegador (F12):
```javascript
location.reload(true);
```

---

## 💪 PASSO 3: FIX FORÇADO

Se a constraint ainda existe, use o script mais agressivo:

### Arquivo: `FIX-FORCADO.sql`

Ou cole isto no Supabase:

```sql
-- Remove TODAS as constraints relacionadas
DO $$ 
DECLARE
    constraint_record RECORD;
BEGIN
    FOR constraint_record IN 
        SELECT conname 
        FROM pg_constraint 
        WHERE conrelid = 'payments'::regclass 
          AND conname LIKE '%payment_type%'
    LOOP
        EXECUTE format('ALTER TABLE payments DROP CONSTRAINT IF EXISTS %I CASCADE', constraint_record.conname);
    END LOOP;
END $$;

-- Garantia extra
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check CASCADE;

-- Verificar
SELECT 'Fix aplicado!' as resultado;
```

---

## 🧪 PASSO 4: TESTE DIRETO

Após aplicar o fix forçado, teste diretamente no SQL:

```sql
-- Teste 1: Inserir um pagamento de teste
BEGIN;

-- Buscar um loan_id válido
DO $$
DECLARE
    test_loan_id UUID;
BEGIN
    SELECT id INTO test_loan_id FROM loans WHERE status = 'active' LIMIT 1;
    
    IF test_loan_id IS NOT NULL THEN
        -- Tentar inserir com o tipo problemático
        INSERT INTO payments (
            loan_id,
            amount,
            payment_date,
            payment_type,
            notes
        ) VALUES (
            test_loan_id,
            1.00,
            CURRENT_DATE,
            'capital_interest_renewal',
            'TESTE - será removido'
        );
        
        RAISE NOTICE '✅ FUNCIONOU! Pode inserir pagamentos com novos tipos.';
        
        -- Remover o teste
        DELETE FROM payments WHERE notes = 'TESTE - será removido';
    END IF;
END $$;

ROLLBACK;
```

### Resultados:

**✅ Se aparecer "FUNCIONOU":**
- O banco está correto
- O problema é de cache/sessão
- Volte ao **PASSO 2**

**❌ Se der erro:**
- O banco ainda tem algum problema
- Contacte com a mensagem de erro exata

---

## 🚨 PASSO 5: VERIFICAÇÃO DE EMPRESA

**MUITO IMPORTANTE:** Você tem 5 empresas diferentes!

Execute este comando para ver qual banco você está:

```sql
SELECT current_database() as banco_atual;
```

Compare com:
- `mhtxyxizfnxupwmilith` = NEXUS
- `dtifsfzmnjnllzzlndxv` = LITORAL CRED
- `eemfnpefgojllvzzaimu` = MOGIANA CRED
- `adjrvtupfshdhwjvhmgj` = ERECHIM
- `eppzphzwwpvpoocospxy` = IMPERATRIZ CRED

### ⚠️ Você está aplicando o fix no banco CERTO?

1. No sistema Nexus, veja qual empresa está selecionada
2. Entre no Supabase DESSA empresa específica
3. Execute o fix lá

---

## 📋 CHECKLIST COMPLETO

Marque conforme vai fazendo:

- [ ] Apliquei o fix no Supabase
- [ ] Verifiquei que estou na empresa CORRETA
- [ ] Executei o script de diagnóstico
- [ ] Vi que a constraint foi removida
- [ ] Fiz logout/login no sistema
- [ ] Limpei o cache do navegador
- [ ] Fechei e reabri o navegador
- [ ] Testei renovar um empréstimo
- [ ] Ainda dá erro (preciso de ajuda!)

---

## 💬 SE AINDA DER ERRO

Me envie estas informações:

1. **Qual empresa está usando?** (NEXUS, LITORAL, etc)

2. **Resultado do diagnóstico:**
```sql
SELECT conname, pg_get_constraintdef(oid) 
FROM pg_constraint 
WHERE conrelid = 'payments'::regclass;
```

3. **Mensagem de erro EXATA** que aparece no sistema

4. **Confirme:** Você executou o script no Supabase da empresa correta?

---

**99% dos casos são resolvidos com:**
1. Executar o fix na empresa certa ✅
2. Limpar o cache do navegador ✅
3. Fazer logout/login ✅
