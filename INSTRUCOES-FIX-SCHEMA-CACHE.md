# 🔧 Solução: Erro "Could not find the 'original_amount' column of 'loans' in the schema cache"

## 📋 Descrição do Problema

Ao tentar criar um empréstimo, o sistema retorna o erro:
```
Could not find the 'original_amount' column of 'loans' in the schema cache
```

Este erro ocorre porque:
1. A coluna `original_amount` foi adicionada à tabela `loans` via ALTER TABLE
2. O cache do schema do Supabase (PostgREST) não foi atualizado
3. A API não reconhece a nova coluna

## ✅ Solução (Passo a Passo)

### PASSO 1: Executar o Script SQL

1. Acesse o **Supabase Dashboard**
2. Vá para **SQL Editor**
3. Crie uma nova query
4. Cole o conteúdo do arquivo `fix-schema-cache-original-amount.sql`
5. Clique em **Run** para executar
6. Verifique se aparece a mensagem: ✅ "Coluna original_amount adicionada com sucesso!"

### PASSO 2: Recarregar o Schema Cache

#### Opção A: Via Dashboard (RECOMENDADO)
1. No Supabase Dashboard, vá para:
   - **Settings** → **API** → **Schema Cache**
2. Clique no botão **"Reload schema"**
3. Aguarde a confirmação de sucesso

#### Opção B: Via SQL
No SQL Editor, execute:
```sql
NOTIFY pgrst, 'reload schema';
```

#### Opção C: Reiniciar a API (se as opções acima não funcionarem)
1. Vá para **Settings** → **API**
2. Clique em **"Restart API"**
3. Aguarde 1-2 minutos para a API reiniciar

### PASSO 3: Aguardar Propagação
- Aguarde **10-30 segundos** para o cache ser completamente atualizado
- O Supabase precisa deste tempo para sincronizar o schema

### PASSO 4: Testar
1. Volte para a aplicação
2. Tente criar um novo empréstimo
3. O erro deve ter desaparecido! ✅

## 🔍 Verificação

Para confirmar que a coluna foi adicionada corretamente, execute no SQL Editor:

```sql
-- Verificar estrutura da tabela
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'loans' 
AND column_name = 'original_amount';

-- Verificar dados
SELECT 
    id,
    original_amount,
    amount,
    status
FROM loans 
LIMIT 5;
```

## 🎯 O que Foi Corrigido

### Antes
```sql
CREATE TABLE loans (
    id UUID,
    client_id UUID,
    amount DECIMAL(10,2),  -- ❌ Sem original_amount
    interest_rate DECIMAL(5,2),
    ...
);
```

### Depois
```sql
CREATE TABLE loans (
    id UUID,
    client_id UUID,
    amount DECIMAL(10,2),
    original_amount DECIMAL(10,2),  -- ✅ Coluna adicionada
    interest_rate DECIMAL(5,2),
    ...
);
```

## 📝 Detalhes Técnicos

### Campo `original_amount`
- **Propósito**: Preservar o valor original do empréstimo
- **Tipo**: `DECIMAL(10,2)`
- **Obrigatório**: Sim (`NOT NULL`)
- **Comportamento**: Definido na criação e **NUNCA** alterado

### Campo `amount`
- **Propósito**: Valor atual do empréstimo (reduzido por pagamentos)
- **Tipo**: `DECIMAL(10,2)`
- **Comportamento**: Atualizado quando há pagamentos de capital

### Exemplo de Uso
```javascript
// Ao criar empréstimo
const loanData = {
    client_id: clientId,
    amount: 5000.00,
    original_amount: 5000.00,  // ✅ Mesmo valor inicial
    interest_rate: 2.5,
    ...
};

// Após pagamento de R$ 1000 (capital)
// amount = 4000.00        (valor restante)
// original_amount = 5000.00  (preservado)
```

## ⚠️ Problemas Comuns

### Erro persiste após recarregar schema
**Solução**: Reinicie a API do Supabase (Opção C do Passo 2)

### Coluna aparece como NULL
**Solução**: O script preenche automaticamente com valores existentes. Se ainda aparecer NULL, execute:
```sql
UPDATE loans 
SET original_amount = amount 
WHERE original_amount IS NULL;
```

### Erro "column original_amount already exists"
**Solução**: A coluna já foi adicionada! Só precisa recarregar o schema cache (Passo 2)

## 🚀 Prevenção Futura

Para evitar este problema ao adicionar novas colunas:

1. **Sempre recarregue o schema cache** após ALTER TABLE
2. Use migrations organizadas por data
3. Documente todas as alterações de schema
4. Teste em ambiente de desenvolvimento primeiro

## 📚 Arquivos Relacionados

- `fix-schema-cache-original-amount.sql` - Script de correção
- `fix-loan-original-amount-preservation.sql` - Script original que adicionou a coluna
- `app.js` (linha ~2177) - Código que usa `original_amount`
- `README-correcao-valores-originais.md` - Documentação do recurso

## ✅ Checklist de Conclusão

- [ ] Executou o script SQL de correção
- [ ] Recarregou o schema cache do Supabase
- [ ] Aguardou 10-30 segundos
- [ ] Testou criar um novo empréstimo
- [ ] Verificou que o erro desapareceu
- [ ] Empréstimo foi criado com sucesso

---

**Data de criação**: 2025-11-13  
**Versão**: 1.0  
**Autor**: Sistema Nexus Gestão Financeira
