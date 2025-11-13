# 🚨 COMECE AQUI - IMPERATRIZ CRED

## ❌ Você está vendo estes erros?

1. `Could not find the 'original_amount' column of 'loans' in the schema cache`
2. `Could not find the 'fine_amount' column of 'payments' in the schema cache`
3. Valor restante zerado ao criar empréstimos

## ✅ Solução em 3 Passos (2 minutos)

### 📝 PASSO 1: Copie o Script

Abra o arquivo: **`COPIE-E-COLE-IMPERATRIZ.sql`**

Copie TODO o conteúdo (Ctrl+A, Ctrl+C)

### 🔧 PASSO 2: Execute no Supabase

1. Acesse: https://eppzphzwwpvpoocospxy.supabase.co
2. Vá em: **SQL Editor**
3. Cole o script (Ctrl+V)
4. Clique: **Run** (ou Ctrl+Enter)

### 🔄 PASSO 3: Recarregue o Cache

1. Vá em: **Settings** → **API**
2. Encontre: **Schema Cache**
3. Clique: **"Reload schema"**
4. Aguarde: **30-60 segundos**

---

## 🧪 Teste

1. Volte para a aplicação
2. Selecione: **IMPERATRIZ CRED**
3. Teste:
   - ✅ Criar um empréstimo
   - ✅ Renovar um empréstimo
   - ✅ Verificar valor restante

---

## 📚 Arquivos Disponíveis

### Se você quer algo mais rápido:
- 📄 `COPIE-E-COLE-IMPERATRIZ.sql` ← **MAIS RÁPIDO!**

### Se você quer entender melhor:
- 📄 `EXECUTAR-AGORA-IMPERATRIZ-V2.md` ← **RECOMENDADO!**
- 📄 `FIX-COMPLETO-IMPERATRIZ.sql` ← Script com verificações
- 📄 `README-FIX-IMPERATRIZ.md` ← Índice completo
- 📄 `CHANGELOG-FIX-IMPERATRIZ.md` ← Histórico de versões

### Scripts individuais (legado):
- 📄 `FIX-RAPIDO-IMPERATRIZ.sql` - Só original_amount
- 📄 `fix-imperatriz-original-amount.sql` - Só original_amount
- 📄 `add-fine-field-to-payments.sql` - Só fine_amount (genérico)

---

## 🆘 Problemas?

### Erro: "column already exists"
✅ Ótimo! A coluna já foi adicionada. Só recarregue o cache (Passo 3)

### Erro persiste após recarregar cache
1. Execute também:
   ```sql
   NOTIFY pgrst, 'reload schema';
   ```
2. Ou reinicie a API: **Settings → API → Restart API**
3. Aguarde 1-2 minutos
4. Teste novamente

### Valor ainda zerado
1. Limpe o cache do navegador (Ctrl+Shift+Del)
2. Ou abra em aba anônima
3. Faça login novamente
4. Teste

---

## ⏱️ Tempo Total

- ✅ Copiar script: 5 segundos
- ✅ Executar no Supabase: 10 segundos
- ✅ Recarregar cache: 30 segundos
- ✅ Testar: 30 segundos
- **TOTAL: ~2 minutos**

---

## 🎯 Resultado Final

Depois de seguir os passos:
- ✅ Criar empréstimos funciona
- ✅ Renovar empréstimos funciona
- ✅ Valor restante correto
- ✅ Multas registradas corretamente
- ✅ Dashboard completo funcionando
- ✅ Sistema 100% funcional! 🎉

---

**👉 PRÓXIMO PASSO:** Abra o arquivo **`COPIE-E-COLE-IMPERATRIZ.sql`**
