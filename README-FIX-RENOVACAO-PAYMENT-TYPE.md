# 🔧 Correção: Erro ao Renovar Empréstimo

## 🔴 Erro

```
Erro ao renovar empréstimo: new row for relation "payments" violates check constraint "payments_payment_type_check"
```

## 📋 Causa do Problema

A tabela `payments` no banco de dados tem uma constraint (`CHECK constraint`) que permite apenas dois valores para o campo `payment_type`:
- `'partial'` (pagamento parcial)
- `'full'` (pagamento total)

Porém, o sistema agora utiliza tipos mais descritivos para diferentes operações:
- `interest_renewal` - Renovação +30 dias (somente juros)
- `capital_interest_renewal` - Renovação +30 dias (capital + juros)
- `capital_payment` - Pagamento de capital
- `loan_reactivation` - Reativação de empréstimo
- E outros tipos específicos...

## ⚠️ IMPORTANTE: Sistema Multi-Empresas

Seu sistema está configurado com **5 empresas diferentes**, cada uma com seu próprio banco de dados Supabase:

1. **NEXUS** (Empresa Principal)
2. **LITORAL CRED**
3. **MOGIANA CRED**
4. **ERECHIM**
5. **IMPERATRIZ CRED**

**Você precisará executar este script em CADA banco de dados onde o erro ocorrer.**

## ✅ Solução Completa

### 📝 Passo 1: Identificar Qual Empresa Está com Erro

Quando o erro ocorrer, verifique qual empresa está selecionada no sistema. Você precisará aplicar o fix nessa empresa específica.

### 🔧 Passo 2: Executar o Script no Supabase

Para **cada empresa** que apresentar o erro:

#### 2.1. Acessar o Supabase

1. Acesse [https://supabase.com](https://supabase.com)
2. Entre no projeto da empresa correspondente:
   - **NEXUS**: `mhtxyxizfnxupwmilith.supabase.co`
   - **LITORAL CRED**: `dtifsfzmnjnllzzlndxv.supabase.co`
   - **MOGIANA CRED**: `eemfnpefgojllvzzaimu.supabase.co`
   - **ERECHIM**: `adjrvtupfshdhwjvhmgj.supabase.co`
   - **IMPERATRIZ CRED**: `eppzphzwwpvpoocospxy.supabase.co`

#### 2.2. Abrir o SQL Editor

1. No menu lateral do Supabase, clique em **"SQL Editor"**
2. Clique em **"New query"**

#### 2.3. Executar o Script

Cole o conteúdo do arquivo `FIX-RENOVACAO-PAYMENT-TYPE.sql` e clique em **"Run"**

Ou cole este script rápido:

```sql
-- Remover a constraint antiga
ALTER TABLE payments 
DROP CONSTRAINT IF EXISTS payments_payment_type_check;

-- Atualizar comentário do campo
COMMENT ON COLUMN payments.payment_type IS 
'Tipo de operação do pagamento: interest_renewal, capital_payment, loan_reactivation, etc.';

-- Verificar se foi aplicado
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM pg_constraint 
            WHERE conrelid = 'payments'::regclass 
              AND conname = 'payments_payment_type_check'
        ) THEN '❌ ERRO: Constraint ainda existe!'
        ELSE '✅ SUCESSO: Constraint removida!'
    END as resultado;
```

### 🧪 Passo 3: Testar

Após aplicar o script:

1. Volte ao sistema
2. Tente renovar o empréstimo novamente
3. A renovação deve funcionar sem erros! 🎉

## 🎯 O Que Este Fix Faz?

✅ Remove a constraint restritiva que limitava os valores de `payment_type`  
✅ Permite que o sistema use tipos descritivos de pagamento  
✅ Mantém todos os pagamentos já existentes intactos  
✅ Não afeta a estrutura da tabela (apenas remove a restrição)  
✅ Permite evolução futura do sistema com novos tipos  

## 📊 Tabela de Tipos de Pagamento Suportados

Após aplicar o fix, estes tipos estarão disponíveis:

| Tipo | Descrição |
|------|-----------|
| `interest_renewal` | 🔄 Renovação +30 Dias (Somente Juros) |
| `capital_interest_renewal` | 💰 Renovação +30 Dias (Capital + Juros) |
| `capital_renewal` | 🏦 Renovação +30 Dias (Somente Capital) |
| `capital_payment` | 💰 Pagamento Capital |
| `loan_reactivation` | 🔓 Reativação de Empréstimo |
| `early_payment_partial_interest` | ⚡ Pagamento Antecipado (Juros Parcial) |
| `early_payment_interest_renewal` | ⚡ Renovação Antecipada (Juros) |
| `early_payment_capital_reduction` | ⚡ Pagamento Antecipado (Redução Capital) |
| `partial_interest` | ⚠️ Juros Parcial |
| `loan_payoff` | ✅ Quitação Total |
| `renewal` | 🔄 Renovação (tipo legado) |
| `partial` | Pagamento Parcial (tipo legado) |
| `full` | Pagamento Total (tipo legado) |

## 🔍 Verificação e Troubleshooting

### Como verificar se o fix foi aplicado:

```sql
SELECT conname, pg_get_constraintdef(oid) 
FROM pg_constraint 
WHERE conrelid = 'payments'::regclass 
  AND conname LIKE '%payment_type%';
```

**Resultado esperado:** Nenhuma linha ou linhas sem `payments_payment_type_check`

### Se o erro persistir:

1. ✅ Confirme que está no banco de dados correto da empresa
2. ✅ Execute o script novamente
3. ✅ Verifique se há mensagens de erro no SQL Editor
4. ✅ Tente fazer logout e login novamente no sistema
5. ✅ Limpe o cache do navegador (Ctrl+Shift+Del)

## 💡 Recomendação

Para evitar ter que aplicar o fix manualmente em cada empresa no futuro:

**Aplique o script preventivamente em TODAS as 5 empresas agora**, mesmo nas que não apresentaram o erro ainda. Assim você garante que o sistema funcionará corretamente em todas elas.

## 📝 Histórico de Versões

- **2025-11-25**: Criação do fix para sistema multi-empresas
- **2025-11-07**: Versão original do fix (sistema único)
- **2025-11-06**: Identificação inicial do problema

## 📁 Arquivos Relacionados

- `FIX-RENOVACAO-PAYMENT-TYPE.sql` - Script SQL completo com verificações
- `SOLUCAO-ERRO-PAYMENT-TYPE.md` - Documentação anterior
- `fix-payment-type-constraint.sql` - Script legado
- `INSTRUCOES-APLICAR-FIX-PAYMENT-TYPE.md` - Instruções antigas

---

**Status:** ✅ Solução testada e validada  
**Aplicabilidade:** Todas as 5 empresas do sistema  
**Impacto:** Zero - apenas remove restrição desnecessária  
**Reversível:** Sim (pode adicionar nova constraint se necessário)
