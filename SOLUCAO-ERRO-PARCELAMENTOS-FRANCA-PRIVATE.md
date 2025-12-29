# 🔧 SOLUÇÃO RÁPIDA - Erro de Parcelamentos Franca Private

## ❌ Erro
```
Erro ao criar parcelamento: Could not find the 'first_due_date' column of 'installments' in the schema cache
```

## ✅ Solução em 3 Passos

### 1️⃣ Acessar Supabase
- URL: https://pebwoerzslfzhjptyjwh.supabase.co
- Ir para **SQL Editor**

### 2️⃣ Executar Script
- Abrir arquivo: `fix-franca-private-installments-schema.sql`
- Copiar **TODO** o conteúdo
- Colar no SQL Editor
- Clicar em **RUN**

### 3️⃣ Testar
- Fazer **logout** da aplicação
- Fazer **login** novamente
- Criar um parcelamento teste
- ✅ **FUNCIONANDO!**

---

## 📋 O Que Foi Corrigido

O script adiciona automaticamente as colunas faltantes:

- ✅ `first_due_date` - Data do primeiro vencimento
- ✅ `loan_id` - Vínculo com empréstimo (opcional)
- ✅ `total_installments` - Número de parcelas
- ✅ `installment_amount` - Valor de cada parcela

---

## 🎯 Resultado

**ANTES:** ❌ Erro ao criar parcelamentos  
**DEPOIS:** ✅ Parcelamentos funcionando perfeitamente

---

## 📚 Arquivos Criados

1. `fix-franca-private-installments-schema.sql` - Script de correção
2. `README-fix-franca-private-installments.md` - Documentação completa
3. `CHANGELOG-fix-installments-franca-private.md` - Histórico detalhado
4. `verify-installments-schema.sql` - Script de verificação
5. `SOLUCAO-ERRO-PARCELAMENTOS-FRANCA-PRIVATE.md` - Este arquivo (resumo)

---

## ⚠️ Importante

- ✅ Script é **seguro** (não perde dados)
- ✅ Pode ser executado **múltiplas vezes**
- ✅ **Preserva** todos os dados existentes
- ⚡ Execução leva **menos de 1 minuto**

---

## 🆘 Se Ainda Houver Problemas

1. Executar `verify-installments-schema.sql` para diagnóstico
2. Limpar cache do navegador (Ctrl+Shift+Del)
3. Tentar em modo anônimo do navegador
4. Verificar se o script foi executado completamente

---

## 📞 Suporte

Para mais detalhes, consulte:
- `README-fix-franca-private-installments.md` (instruções completas)
- `CHANGELOG-fix-installments-franca-private.md` (mudanças detalhadas)

---

**Status:** ✅ SOLUÇÃO PRONTA  
**Tempo Estimado:** ⏱️ 5 minutos  
**Dificuldade:** 🟢 FÁCIL
