# 🚨 INSTRUÇÕES URGENTES: Diagnóstico de Quitação

## ⚡ Problema

Empréstimos **ainda não estão sendo salvos** na tabela `paid_loans` ao marcar como quitado na Imperatriz Cred.

## 🔍 Vamos Diagnosticar AGORA

### PASSO 1: Execute o Script de Diagnóstico

1. **Abra o sistema no navegador**
2. **Faça login na IMPERATRIZ CRED**
3. **Abra o Console** (F12)
4. **Cole o conteúdo do arquivo `diagnostico-quitacao.js` no Console**
5. **Pressione ENTER**

### PASSO 2: Analise o Resultado

O script vai verificar 10 pontos críticos. **ANOTE** onde aparece ❌:

```
✅ = OK
❌ = PROBLEMA (ANOTE ESTE!)
⚠️ = AVISO (pode ser normal)
```

### PASSO 3: Teste Real de Quitação

1. **Mantenha o Console aberto**
2. **Vá para aba Empréstimos**
3. **Clique no botão ✅ de um empréstimo**
4. **Clique em "Marcar como Quitado"**
5. **OBSERVE ATENTAMENTE O CONSOLE**

### O que procurar no Console:

#### ✅ SE ESTÁ FUNCIONANDO, você verá:
```
🔄 Iniciando marcação de empréstimo como quitado...
📊 Dados calculados: {...}
✅ Empréstimo inserido na tabela paid_loans com sucesso
✅ Empréstimo removido da tabela loans com sucesso
🔄 Atualizando interface...
✅ Interface atualizada com sucesso
```

#### ❌ SE NÃO ESTÁ FUNCIONANDO, você verá:
```
🔄 Iniciando marcação...
❌ Erro ao inserir empréstimo na tabela paid_loans: [ERRO AQUI]
❌ ERRO ao marcar empréstimo como quitado: [ERRO AQUI]
```

## 📋 Checklist Urgente

Execute TODAS estas verificações:

### No Navegador:

- [ ] Está logado na **IMPERATRIZ CRED** (não outra empresa)?
- [ ] Página foi recarregada com Ctrl + Shift + R?
- [ ] Console está aberto (F12)?
- [ ] Script de diagnóstico foi executado?
- [ ] Tentou marcar empréstimo como quitado?
- [ ] Capturou TODO o erro do Console?

### No Supabase:

- [ ] Acessou o Supabase Dashboard?
- [ ] Foi em **Table Editor**?
- [ ] Tabela `paid_loans` existe?
- [ ] Foi em **SQL Editor**?
- [ ] Executou query abaixo?

```sql
-- Verificar se tabela existe e tem políticas
SELECT 
    tablename,
    rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
AND tablename = 'paid_loans';

-- Verificar políticas RLS
SELECT 
    policyname,
    cmd
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'paid_loans';
```

**Resultado esperado:**
- Tabela existe: rowsecurity = 't'
- 4 políticas: SELECT, INSERT, UPDATE, DELETE

### Se Tabela NÃO Existir:

**Execute no SQL Editor:**

```sql
-- Criar tabela paid_loans
CREATE TABLE IF NOT EXISTS paid_loans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    loan_id UUID NOT NULL,
    client_id UUID NOT NULL,
    original_amount DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    total_with_interest DECIMAL(10,2) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    paid_date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_paid DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    notes TEXT,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS
ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;

-- Políticas
CREATE POLICY "Users can view all paid loans" ON paid_loans
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert paid loans" ON paid_loans
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can update their paid loans" ON paid_loans
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Users can delete their paid loans" ON paid_loans
    FOR DELETE USING (auth.role() = 'authenticated');

-- Permissões
GRANT SELECT, INSERT, UPDATE, DELETE ON paid_loans TO authenticated;
```

## 🎯 Cenários Possíveis

### Cenário 1: Tabela não existe
**Sintoma:** Erro "relation paid_loans does not exist"  
**Solução:** Execute o SQL acima

### Cenário 2: Sem permissão de INSERT
**Sintoma:** Erro "permission denied" ou "new row violates row-level security"  
**Solução:** Execute:
```sql
GRANT INSERT ON paid_loans TO authenticated;

-- E verifique política:
CREATE POLICY "Users can insert paid loans" ON paid_loans
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');
```

### Cenário 3: Erro de chave estrangeira
**Sintoma:** Erro "violates foreign key constraint"  
**Solução:** Verifique se `client_id` existe na tabela `clients`

### Cenário 4: Usuário não autenticado
**Sintoma:** Erro "JWT expired" ou "not authenticated"  
**Solução:** Faça logout e login novamente

### Cenário 5: Código não atualizado
**Sintoma:** Não vê logs 🔄 no Console  
**Solução:** Ctrl + Shift + R (força reload)

## 📸 CAPTURE TUDO

Para eu poder ajudar, preciso ver:

1. **Screenshot do resultado do script de diagnóstico**
2. **Screenshot de TODO o Console após tentar quitar**
3. **Screenshot da tabela paid_loans no Supabase** (Table Editor)
4. **Screenshot das políticas RLS** (resultado da query SQL)
5. **Qual empresa está selecionada** (screenshot do nome no canto)

## 🔬 Teste Manual no Supabase

Se nada funcionar, teste inserção manual:

1. Vá em **Table Editor** → **paid_loans**
2. Clique em **Insert** → **Insert row**
3. Preencha campos manualmente
4. Clique em **Save**

**Se inserção manual funcionar:** Problema é no código JavaScript  
**Se inserção manual falhar:** Problema é nas permissões do Supabase

## ⚡ Ação Imediata

**FAÇA AGORA:**

1. Cole o script `diagnostico-quitacao.js` no Console
2. Execute
3. Copie TODO o resultado
4. Tente marcar empréstimo como quitado
5. Copie TODO o erro do Console
6. Me envie TUDO

**SEM ESSAS INFORMAÇÕES, NÃO CONSIGO AJUDAR!**

---

**IMPORTANTE:** O código está correto. O problema é:
- Tabela não existe, OU
- Permissões RLS bloqueando, OU
- Código antigo em cache

Execute o diagnóstico e me envie o resultado!
