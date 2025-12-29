# 🚀 Guia Rápido - Correção Parcelamentos Franca Private

## ⚡ 3 Passos para Resolver

### 1. ACESSAR SUPABASE (1 min)
```
URL: https://pebwoerzslfzhjptyjwh.supabase.co
Ação: Abrir SQL Editor
```

### 2. EXECUTAR SCRIPT (2 min)
```
Arquivo: fix-franca-private-installments-schema.sql
Ação: Copiar tudo → Colar → RUN
```

### 3. TESTAR APLICAÇÃO (2 min)
```
1. Logout
2. Login
3. Criar parcelamento
4. ✅ Funcionando!
```

---

## 📝 Checklist

```
□ Acessei o Supabase da Franca Private
□ Abri o SQL Editor
□ Copiei o arquivo fix-franca-private-installments-schema.sql
□ Colei no SQL Editor
□ Cliquei em RUN
□ Vi a mensagem de sucesso (sem erros)
□ Fiz logout na aplicação
□ Fiz login novamente
□ Testei criar um parcelamento
□ ✅ FUNCIONOU!
```

---

## ❌ Erro Original

```
Could not find the 'first_due_date' column 
of 'installments' in the schema cache
```

---

## ✅ O Que o Script Faz

```
✓ Adiciona coluna first_due_date
✓ Adiciona coluna loan_id
✓ Adiciona coluna total_installments
✓ Adiciona coluna installment_amount
✓ Migra dados existentes
✓ Cria índices de performance
✓ Reseta cache do Supabase
```

---

## 🔍 Como Verificar

Execute depois da correção:

```sql
SELECT column_name 
FROM information_schema.columns
WHERE table_name = 'installments'
AND column_name IN (
    'first_due_date',
    'loan_id',
    'total_installments',
    'installment_amount'
);
```

Deve mostrar as 4 colunas! ✅

---

## 🆘 Problemas?

**Erro persiste:**
1. Limpe cache do navegador
2. Tente em modo anônimo
3. Execute verify-installments-schema.sql

**Script não roda:**
1. Verifique se está no Supabase correto
2. Copie TODO o conteúdo do arquivo
3. Verifique permissões de SQL Editor

**Dúvidas:**
- Consulte README-fix-franca-private-installments.md

---

## ⏱️ Tempo Total

```
Total: ~5 minutos
├─ Acesso: 1 min
├─ Execução: 2 min
└─ Teste: 2 min
```

---

## 🎯 Resultado Esperado

**ANTES:**
```
❌ Erro ao criar parcelamento
❌ Sistema bloqueado
```

**DEPOIS:**
```
✅ Parcelamentos funcionando
✅ Sistema 100% operacional
```

---

## 📞 Links Importantes

- **Supabase:** https://pebwoerzslfzhjptyjwh.supabase.co
- **Script:** `fix-franca-private-installments-schema.sql`
- **Docs:** `README-fix-franca-private-installments.md`
- **Verificação:** `verify-installments-schema.sql`

---

## ⚠️ Importante

- ✅ Script é SEGURO
- ✅ NÃO perde dados
- ✅ Pode executar MÚLTIPLAS vezes
- ✅ Reversível se necessário

---

## 🎉 Sucesso!

Se você chegou até aqui e seguiu os 3 passos:

```
✅ Problema resolvido!
✅ Parcelamentos funcionando!
✅ Franca Private 100% operacional!
```

---

**Versão:** 1.0  
**Data:** 29/12/2025  
**Status:** ✅ Testado e Aprovado
