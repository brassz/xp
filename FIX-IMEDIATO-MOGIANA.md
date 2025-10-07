# 🆘 CORREÇÃO IMEDIATA - MOGIANA CRED

## 🚨 O PROBLEMA:
Sua aplicação está tentando inserir tipos de pagamento que o banco não permite.

## ✅ A SOLUÇÃO (3 MINUTOS):

### OPÇÃO 1: Supabase Web (RECOMENDADO)
1. **Abra uma nova aba** e acesse: https://supabase.com/dashboard
2. **Faça login** na sua conta
3. **Selecione o projeto** da MOGIANA CRED (URL termina com `eemfnpefgojllvzzaimu`)
4. **Clique em "SQL Editor"** no menu lateral esquerdo
5. **Clique em "New Query"**
6. **Cole este código** na caixa de texto:

```sql
ALTER TABLE payments DROP CONSTRAINT payments_payment_type_check;
ALTER TABLE payments ADD CONSTRAINT payments_payment_type_check CHECK (payment_type IN ('partial', 'full', 'interest_renewal', 'early_payment_partial_interest', 'early_payment_interest_renewal', 'early_payment_capital_reduction', 'capital_payment', 'partial_interest', 'adjustment', 'renewal'));
```

7. **Clique no botão "RUN"** (ou pressione Ctrl+Enter)
8. **Aguarde** aparecer "Success"
9. **Volte para sua aplicação** e teste o pagamento

### OPÇÃO 2: Se não conseguir acessar o Supabase
Me informe e eu vou te ajudar com uma solução alternativa.

---

## 🔍 VERIFICAÇÃO:
Após executar, teste registrar um pagamento. Se ainda der erro, me avise qual mensagem apareceu.

## 📞 PRECISA DE AJUDA?
- ❌ Não consegue acessar o Supabase?
- ❌ Não encontra o projeto da MOGIANA?
- ❌ Deu algum erro ao executar?
- ❌ Ainda não funcionou?

**Me conte qual é o problema específico que está enfrentando!**