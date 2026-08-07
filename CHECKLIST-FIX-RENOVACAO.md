# ✅ Checklist: Corrigir Erro de Renovação

## 🎯 Objetivo
Corrigir o erro: `"payments_payment_type_check"` ao renovar empréstimos

---

## 📋 CHECKLIST DE APLICAÇÃO

Marque as empresas conforme aplicar o fix:

### Empresas para Aplicar

- [ ] **NEXUS** (Empresa Principal) - `mhtxyxizfnxupwmilith`
- [ ] **LITORAL CRED** - `dtifsfzmnjnllzzlndxv`
- [ ] **MOGIANA CRED** - `eemfnpefgojllvzzaimu`
- [ ] **ERECHIM** - `adjrvtupfshdhwjvhmgj`
- [ ] **IMPERATRIZ CRED** - `eppzphzwwpvpoocospxy`

---

## 🚀 Passos Rápidos (Para Cada Empresa)

### 1️⃣ Acessar Supabase
- [ ] Abrir [supabase.com](https://supabase.com)
- [ ] Entrar no projeto da empresa
- [ ] Clicar em **SQL Editor** (menu lateral)
- [ ] Clicar em **New query**

### 2️⃣ Executar Script
- [ ] Cole o script abaixo
- [ ] Clique em **Run** (ou pressione Ctrl+Enter)
- [ ] Aguarde mensagem de sucesso

```sql
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;
SELECT '✅ Fix aplicado com sucesso!' as resultado;
```

### 3️⃣ Verificar
- [ ] Mensagem "✅ Fix aplicado com sucesso!" apareceu
- [ ] Nenhum erro foi exibido

### 4️⃣ Testar no Sistema
- [ ] Voltar ao sistema Nexus
- [ ] Selecionar a empresa que foi corrigida
- [ ] Tentar renovar um empréstimo
- [ ] ✅ Renovação funcionou!

---

## ⚡ Script One-Liner (SUPER RÁPIDO)

Copie e cole este comando único no SQL Editor:

```sql
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_payment_type_check;
```

**Pronto!** Isso é tudo que você precisa executar. ✨

---

## 🔍 Verificação Final

Execute este script para confirmar que está tudo correto:

```sql
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM pg_constraint 
            WHERE conrelid = 'payments'::regclass 
              AND conname = 'payments_payment_type_check'
        ) 
        THEN '❌ Ainda existe - executar fix novamente'
        ELSE '✅ Tudo certo - renovações funcionarão!'
    END as status;
```

---

## 📊 Status da Aplicação

| Empresa | Status | Data | Testado |
|---------|--------|------|---------|
| NEXUS | ⏳ Pendente | - | - |
| LITORAL CRED | ⏳ Pendente | - | - |
| MOGIANA CRED | ⏳ Pendente | - | - |
| ERECHIM | ⏳ Pendente | - | - |
| IMPERATRIZ CRED | ⏳ Pendente | - | - |

**Instruções:** Preencha com ✅ (aplicado), ❌ (erro) ou ⏳ (pendente)

---

## ⚠️ Troubleshooting Rápido

**Se der erro:**
1. Confirme que está no banco correto
2. Execute novamente (comando é seguro para repetir)
3. Faça logout/login no sistema

**Se renovação ainda não funcionar:**
1. Limpe cache do navegador (Ctrl+Shift+Del)
2. Faça logout e login no Nexus
3. Tente selecionar a empresa novamente

---

## 💡 Dica Profissional

**Aplique em todas as 5 empresas de uma vez!**

Assim você não precisa se preocupar quando mudar de empresa. Leva apenas 5 minutos para aplicar em todas! ⚡

---

## 📞 Suporte

Se após aplicar o fix em todas as empresas ainda houver problemas:

1. Verifique a seção "Empresas para Aplicar" - todas marcadas? ✅
2. Verifique se selecionou a empresa correta no sistema
3. Tente renovar empréstimos em empresas diferentes

---

**Última atualização:** 2025-11-25  
**Tempo estimado:** 1-2 minutos por empresa  
**Dificuldade:** ⭐ Muito Fácil
