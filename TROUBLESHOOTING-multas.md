# 🔧 Troubleshooting: Multas Não Aparecem

## 📋 Passo a Passo para Diagnóstico

Siga estes passos **na ordem** para identificar e resolver o problema:

---

## PASSO 1: Verificar Estrutura do Banco de Dados

### Execute no Supabase SQL Editor:
```sql
-- Cole o conteúdo do arquivo: verify-fine-amount-column.sql
```

### O que verificar:
1. ✅ O campo `fine_amount` aparece na lista de colunas?
2. ✅ O tipo é `numeric` ou `decimal(10,2)`?
3. ✅ O valor padrão é `0.00`?

### ❌ Se o campo NÃO EXISTIR:
```sql
-- Execute este script: fix-multas-display-issue.sql
```

---

## PASSO 2: Limpar Cache do Navegador

1. Pressione `Ctrl+Shift+Delete` (Windows/Linux) ou `Cmd+Shift+Delete` (Mac)
2. Marque: ✅ Cache ✅ Cookies
3. Clique em "Limpar dados"
4. Feche completamente o navegador
5. Abra novamente

---

## PASSO 3: Testar com Logs de Debug

### 3.1 Abrir Console do Navegador
1. Pressione `F12`
2. Vá na aba "Console"
3. Deixe aberto durante o teste

### 3.2 Adicionar Pagamento com Multa
1. Vá em **Empréstimos**
2. Clique em 💰 **Ver histórico** de qualquer empréstimo
3. Clique em **Novo Pagamento**
4. Preencha:
   - Valor: `100`
   - ✅ Marque "Incluir Multa"
   - Multa: `50`
5. Clique em **Salvar**

### 3.3 Verificar Logs no Console
Procure por mensagens com 🔍 **[DEBUG]**:

```
🔍 [DEBUG] Multa: {
  includeFine: true,
  fineAmount: 50,
  fineInputValue: "50"
}

🔍 [DEBUG] Dados do pagamento sendo inserido: {
  loan_id: "...",
  amount: 100,
  fine_amount: 50,  ← DEVE APARECER AQUI
  ...
}

✅ Pagamento registrado com sucesso
```

### ❌ Problemas Possíveis:

#### Se `fineAmount: 0` quando deveria ser 50:
- O campo de input não está capturando o valor
- Verifique se o elemento `fineAmount` existe no HTML

#### Se aparecer erro ao salvar:
```
❌ Erro ao registrar pagamento: ...
```
- O campo `fine_amount` não existe no banco
- Execute o script: `fix-multas-display-issue.sql`

---

## PASSO 4: Verificar se Aparece no Histórico

### 4.1 Após salvar o pagamento:
1. O histórico deve recarregar automaticamente
2. Procure no console:
```
🔍 [DEBUG] Pagamentos carregados para histórico: 1
🔍 [DEBUG] Primeiro pagamento: {
  id: "...",
  amount: 100,
  fine_amount: 50,  ← DEVE TER O VALOR
  ...
}
```

### 4.2 Verificar na tabela:
```
+------------+-----------+----------+
| Valor      | Multa     | Tipo     |
+------------+-----------+----------+
| R$ 100,00  | R$ 50,00  | Dinheiro |  ← Multa em VERMELHO
+------------+-----------+----------+
```

### ❌ Se `fine_amount: null` ou `fine_amount: 0`:
- O valor não foi salvo no banco
- Execute: `verify-fine-amount-column.sql`
- Verifique se o campo existe

---

## PASSO 5: Verificar na Aba Relatórios

1. Vá na aba **Payments** (Relatórios)
2. Procure no console:
```
🔍 [DEBUG] Renderizando pagamentos: 5
🔍 [DEBUG] Exemplo de pagamento: {
  id: "...",
  amount: 100,
  fine_amount: 50,  ← DEVE APARECER
  payment_type: "dinheiro",  ← DEVE SER payment_type
  payment_method: undefined,  ← NÃO deve existir
  ...
}
```

### ❌ Se `payment_type: undefined`:
- Erro no banco de dados
- O campo `payment_type` não existe ou está NULL

### ❌ Se `fine_amount: null` ou não aparece:
- O campo não existe no banco
- Execute: `fix-multas-display-issue.sql`

---

## PASSO 6: Verificar Diretamente no Banco

### Execute no Supabase SQL Editor:
```sql
-- Ver último pagamento criado
SELECT 
    id,
    loan_id,
    amount,
    fine_amount,
    payment_type,
    payment_date,
    created_at
FROM payments
ORDER BY created_at DESC
LIMIT 1;
```

### O que verificar:
1. ✅ `fine_amount` tem o valor correto (50.00)?
2. ✅ `payment_type` tem um valor (ex: 'dinheiro')?

### ❌ Se fine_amount for NULL ou 0:
```sql
-- Atualizar manualmente para teste
UPDATE payments
SET fine_amount = 50.00
WHERE id = 'cole-o-id-aqui';
```

Depois recarregue a página e veja se aparece.

---

## 🎯 Cenários e Soluções

### Cenário 1: Campo não existe no banco
**Sintoma:** Erro ao salvar pagamento
**Solução:** Execute `fix-multas-display-issue.sql`

### Cenário 2: Campo existe mas valor não salva
**Sintoma:** Logs mostram `fine_amount: 0` ao inserir
**Solução:** Verifique se há erro de permissão (RLS) no Supabase

### Cenário 3: Valor salva mas não aparece na tela
**Sintoma:** Banco tem valor, mas tabela mostra "-"
**Solução:** Limpe cache e recarregue

### Cenário 4: Erro de JavaScript no console
**Sintoma:** `Cannot read property 'payment_type' of undefined`
**Solução:** O código já foi corrigido, limpe cache

---

## 📞 Informações para Suporte

Se o problema persistir, forneça estas informações:

### 1. Resultado do script de verificação:
```sql
-- Execute: verify-fine-amount-column.sql
-- Cole o resultado aqui
```

### 2. Logs do console:
```
-- Copie todas as mensagens com 🔍 [DEBUG]
```

### 3. Último pagamento do banco:
```sql
SELECT * FROM payments ORDER BY created_at DESC LIMIT 1;
-- Cole o resultado aqui
```

### 4. Versão do navegador:
- Chrome/Firefox/Safari: ?
- Versão: ?

---

## ✅ Checklist Final

Antes de reportar como "não funcionou", confirme:

- [ ] Executei o script `verify-fine-amount-column.sql`
- [ ] O campo `fine_amount` existe no banco (verificado no script)
- [ ] Executei o script `fix-multas-display-issue.sql` (se o campo não existia)
- [ ] Limpei o cache do navegador completamente
- [ ] Fechei e reabri o navegador
- [ ] Abri o console (F12) e verifiquei os logs 🔍 [DEBUG]
- [ ] Testei adicionar um novo pagamento com multa
- [ ] Verifiquei no banco se o valor foi salvo
- [ ] Copiei os logs de erro (se houver)

---

**Última atualização:** 2025-12-23  
**Branch:** cursor/loan-fine-display-issue-4468
