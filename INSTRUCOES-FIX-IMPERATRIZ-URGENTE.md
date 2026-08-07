# 🚨 FIX URGENTE - IMPERATRIZ CRED

## ❌ Problemas Identificados

### Problema 1: Erro ao Criar Empréstimo
```
Could not find the 'original_amount' column of 'loans' in the schema cache
```

### Problema 2: Valor Restante Zerado
- Ao criar um empréstimo, o valor restante aparece como R$ 0,00
- Impossível registrar pagamentos corretamente
- Dashboard mostra informações incorretas

## 🔍 Causa Raiz

O banco de dados da **IMPERATRIZ CRED** não possui a coluna `original_amount` na tabela `loans`. Esta coluna é essencial para:
1. Armazenar o valor original do empréstimo (nunca alterado)
2. Calcular corretamente o valor restante após pagamentos
3. Distinguir entre capital pago e capital restante

## ✅ Solução Completa (5 minutos)

### 📋 PASSO 1: Acessar o Banco da IMPERATRIZ

1. Acesse: **https://eppzphzwwpvpoocospxy.supabase.co**
2. Faça login no Supabase
3. Vá para **SQL Editor**
4. Crie uma nova query

### 🔧 PASSO 2: Executar o Script de Correção

1. Abra o arquivo: **`fix-imperatriz-original-amount.sql`**
2. Copie TODO o conteúdo do arquivo
3. Cole no SQL Editor do Supabase
4. Clique em **Run** (ou pressione Ctrl+Enter)

### ✅ Verificar Mensagens de Sucesso

Você deve ver as seguintes mensagens:
```
✅ Passo 1/5: Coluna original_amount adicionada
✅ Passo 2/5: Valores existentes preenchidos
✅ Passo 3/5: Coluna definida como obrigatória
✅ Passo 4/5: Documentação adicionada
✅ Passo 5/5: Índice criado
```

Além disso, o script mostra:
- 📊 Estrutura da tabela loans
- 📑 Índices criados
- 💰 Primeiros 10 empréstimos
- 📈 Estatísticas gerais

### 🔄 PASSO 3: Recarregar Schema Cache

**MUITO IMPORTANTE!** Sem este passo, o erro continuará!

#### Opção A: Via Dashboard (RECOMENDADO)
1. No Supabase, vá para: **Settings** → **API**
2. Encontre a seção **Schema Cache**
3. Clique no botão **"Reload schema"**
4. Aguarde a confirmação

#### Opção B: Via SQL
No SQL Editor, execute:
```sql
NOTIFY pgrst, 'reload schema';
```

### ⏱️ PASSO 4: Aguardar Propagação

- **Aguarde 30-60 segundos**
- O Supabase precisa deste tempo para atualizar o cache
- ☕ Aproveite para tomar um café!

### 🧪 PASSO 5: Testar na Aplicação

1. Acesse a aplicação Nexus
2. No dropdown, selecione: **IMPERATRIZ CRED**
3. Faça login
4. Vá para **Empréstimos**
5. Clique em **Novo Empréstimo**
6. Preencha os dados e salve

### ✅ Resultado Esperado

Após a correção:
- ✅ Empréstimo criado com sucesso (sem erros)
- ✅ Valor restante mostra corretamente (ex: R$ 5.125,00)
- ✅ Dashboard atualiza corretamente
- ✅ Possível registrar pagamentos

## 🔍 Verificação Manual

Se quiser verificar se a correção funcionou, execute no SQL Editor:

```sql
-- Verificar se a coluna existe
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'loans' 
AND column_name = 'original_amount';

-- Verificar empréstimos
SELECT 
    id,
    amount as "Valor Atual",
    original_amount as "Valor Original",
    (original_amount - amount) as "Diferença",
    status
FROM loans 
ORDER BY created_at DESC 
LIMIT 5;
```

**Resultado esperado:**
- Coluna `original_amount` existe
- Tipo: `numeric` (DECIMAL)
- Nullable: `NO` (obrigatório)
- Todos os empréstimos têm `original_amount` preenchido

## 🆘 Troubleshooting

### Erro: "column original_amount already exists"
**Solução:** A coluna já foi adicionada! Pule para o PASSO 3 (recarregar schema cache)

### Erro persiste após recarregar schema
**Solução:**
1. Reinicie a API do Supabase:
   - Settings → API → **Restart API**
2. Aguarde 1-2 minutos
3. Teste novamente

### Valor restante ainda aparece zerado
**Possível causa:** Cache do navegador

**Solução:**
1. Limpe o cache do navegador (Ctrl+Shift+Delete)
2. Ou abra em aba anônima/privada
3. Faça login novamente na IMPERATRIZ CRED
4. Teste criar um novo empréstimo

### Empréstimos antigos com valor errado
**Solução:** Execute no SQL Editor:
```sql
-- Corrigir empréstimos onde original_amount está diferente de amount
UPDATE loans 
SET original_amount = amount 
WHERE original_amount IS NULL 
OR original_amount = 0
OR original_amount != amount;
```

## 📊 Entendendo a Correção

### Antes da Correção

```sql
CREATE TABLE loans (
    id UUID,
    client_id UUID,
    amount DECIMAL(10,2),        -- ❌ Sem original_amount
    interest_rate DECIMAL(5,2),
    status TEXT
);
```

**Problema:**
- Ao criar empréstimo, app.js envia `original_amount`
- Supabase rejeita: "coluna não existe no schema"
- Cálculo de valor restante falha: retorna R$ 0,00

### Depois da Correção

```sql
CREATE TABLE loans (
    id UUID,
    client_id UUID,
    amount DECIMAL(10,2),
    original_amount DECIMAL(10,2),  -- ✅ Coluna adicionada
    interest_rate DECIMAL(5,2),
    status TEXT
);
```

**Solução:**
- Empréstimo criado com sucesso
- `original_amount` = valor inicial (nunca muda)
- `amount` = valor atual (reduzido por pagamentos)
- Cálculo correto: `valor_restante = original_amount - pagamentos + juros`

## 💡 Exemplo Prático

### Criação do Empréstimo
```
Cliente: João Silva
Valor: R$ 5.000,00
Juros: 2,5%
Total: R$ 5.125,00

Campos salvos:
- amount: 5000.00
- original_amount: 5000.00  ← Preservado para sempre
- total_amount: 5125.00
```

### Após Pagamento de R$ 1.000,00
```
Capital pago: R$ 1.000,00
Novo capital: R$ 4.000,00
Novos juros: R$ 100,00 (2,5% de 4.000)
Novo total: R$ 4.100,00

Campos atualizados:
- amount: 4000.00  ← Reduzido
- original_amount: 5000.00  ← Mantém valor original!
- total_amount: 4100.00
```

**Valor Restante Calculado:**
```javascript
// Código correto (app.js linha 6832):
const originalCapital = parseFloat(loan.original_amount || loan.amount);
// originalCapital = 5000.00 ✅

// Sem original_amount:
const originalCapital = parseFloat(loan.amount);
// originalCapital = 4000.00 ❌ (valor já reduzido!)
```

## 🎯 Por Que Isso Aconteceu?

A empresa IMPERATRIZ CRED foi configurada recentemente. Alguns scripts de migração não foram executados no banco dela:

1. ✅ `database-setup.sql` - Executado (tabelas básicas)
2. ✅ `setup-expenses-table.sql` - Executado
3. ❌ `fix-loan-original-amount-preservation.sql` - **NÃO EXECUTADO**

O último script adiciona a coluna `original_amount`, que é essencial para o funcionamento correto do sistema.

## 🚀 Prevenção Futura

Para evitar este problema em novas empresas:

### Checklist de Setup de Nova Empresa:
- [ ] Executar `database-setup.sql`
- [ ] Executar `setup-guarantors-table.sql`
- [ ] Executar `setup-emergency-contacts-table.sql`
- [ ] Executar `setup-client-documents-table.sql`
- [ ] Executar `setup-expenses-table.sql`
- [ ] Executar `setup-pix-keys-table.sql`
- [ ] Executar `add-fine-field-to-payments.sql`
- [ ] **Executar `fix-loan-original-amount-preservation.sql`** ← CRÍTICO!
- [ ] Recarregar schema cache
- [ ] Testar criar empréstimo
- [ ] Verificar valor restante

## 📚 Arquivos Relacionados

- **`fix-imperatriz-original-amount.sql`** - Script de correção (EXECUTE ESTE!)
- **`fix-loan-original-amount-preservation.sql`** - Script original genérico
- **`README-correcao-valores-originais.md`** - Documentação técnica
- **`README-IMPERATRIZ-CRED.md`** - Configuração da empresa
- **`app.js`** (linhas 2177, 6832, 6740) - Código que usa `original_amount`

## ✅ Checklist de Conclusão

Marque conforme completa:

- [ ] Acessou o Supabase da IMPERATRIZ CRED
- [ ] Executou o script `fix-imperatriz-original-amount.sql`
- [ ] Viu as 5 mensagens de sucesso
- [ ] Recarregou o schema cache
- [ ] Aguardou 30-60 segundos
- [ ] Testou criar um novo empréstimo
- [ ] Verificou que o valor restante aparece correto
- [ ] Confirmou que não há mais erros

## 📞 Suporte

Se após seguir todos os passos o problema persistir:

1. Verifique os logs do Supabase (Database → Logs)
2. Verifique o console do navegador (F12)
3. Tire prints das mensagens de erro
4. Documente os passos que seguiu

---

**Data de criação:** 2025-11-13  
**Empresa afetada:** IMPERATRIZ CRED  
**Prioridade:** 🚨 URGENTE  
**Tempo estimado:** 5 minutos  
**Status após correção:** ✅ Sistema 100% funcional
