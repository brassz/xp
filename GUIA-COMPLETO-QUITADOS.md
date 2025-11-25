# 🔧 GUIA COMPLETO - Resolver Problema de Empréstimos Quitados

## 🚨 PROBLEMA ATUAL

**Sintoma**: Ao clicar em "Marcar como Quitado", o empréstimo **NÃO é salvo** no banco de dados.

---

## 📋 SOLUÇÃO PASSO A PASSO

### ETAPA 1: Diagnóstico (2 minutos)

Execute este script para identificar o problema:

1. **Abra o SQL Editor** no Supabase da LITORAL CRED
2. **Copie e execute** o arquivo: `diagnostico-paid-loans.sql`
3. **Leia o resultado** - ele vai te dizer exatamente qual é o problema

**Possíveis resultados**:

#### ❌ "Tabela não existe"
→ Vá para **ETAPA 2A**

#### ⚠️ "Políticas RLS incompletas" ou "Permissões insuficientes"
→ Vá para **ETAPA 2B**

#### ⚠️ "INSERT falhou" mas tabela existe
→ Vá para **ETAPA 2C**

---

### ETAPA 2A: Criar Tabela (se não existir)

Se o diagnóstico mostrou que a tabela não existe:

1. **Abra o SQL Editor** no Supabase
2. **Copie TODO o conteúdo** do arquivo: `fix-litoral-paid-loans.sql`
3. **Cole no editor** e clique em **"Run"**
4. **Aguarde** a execução (pode levar 10-20 segundos)
5. **Verifique** se apareceu: `✅ CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!`

**Depois**: Vá para **ETAPA 3**

---

### ETAPA 2B: Corrigir Políticas RLS

Se o diagnóstico mostrou problema nas políticas ou permissões:

1. **Abra o SQL Editor** no Supabase
2. **Copie e execute** o arquivo: `fix-paid-loans-rls.sql`
3. **Aguarde** a execução
4. **Verifique** se apareceu: `✅ SUCESSO! INSERT funcionou!`

**Se ainda mostrar erro**, execute também:
```sql
GRANT ALL ON paid_loans TO authenticated;
GRANT ALL ON paid_loans_with_details TO authenticated;
```

**Depois**: Vá para **ETAPA 3**

---

### ETAPA 2C: Desabilitar RLS Temporariamente (última opção)

**⚠️ USE APENAS SE AS OUTRAS OPÇÕES FALHARAM**

Se nada funcionou, desabilite o RLS temporariamente:

```sql
-- ATENÇÃO: Isso remove a segurança RLS
ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;
```

**Depois**: Vá para **ETAPA 3**

---

### ETAPA 3: Testar na Aplicação

1. **Recarregue** a página da aplicação (F5 ou Ctrl+R)
2. **Faça logout** e **login** novamente
3. **Selecione** LITORAL CRED
4. **Abra o Console** (F12 → aba Console)
5. Vá para aba **"Empréstimos"**
6. Clique no botão **✅ "Marcar como Quitado"** de qualquer empréstimo
7. **Confirme** a ação

**Observe os logs no console**:

---

### ✅ LOGS DE SUCESSO

Se funcionar, você verá:

```
🔵 Iniciando processo de quitação do empréstimo: xxx
✅ Empréstimo encontrado: {...}
🔵 Usuário confirmou quitação. Processando...
💰 Total com juros calculado: xxx
🔵 Buscando pagamentos do empréstimo...
✅ Total pago: xxx
🔵 Inserindo empréstimo na tabela paid_loans: {...}
👤 Usuário atual: {...}
🏢 Empresa atual: litoral
🔵 Verificando se tabela paid_loans existe...
✅ Tabela paid_loans existe
🔵 Executando INSERT...
✅ Empréstimo inserido na tabela paid_loans com sucesso!
📊 Dados inseridos: {...}
🔵 Removendo empréstimo da tabela loans...
✅ Empréstimo removido da tabela loans com sucesso
...
🎉 Processo de quitação concluído com sucesso!
```

**E o empréstimo deve**:
- ✅ Sumir da aba "Empréstimos"
- ✅ Aparecer na aba "Empréstimos Quitados"
- ✅ Aba mudar automaticamente

---

### ❌ LOGS DE ERRO

Se NÃO funcionar, você verá um dos erros abaixo:

#### Erro 1: "Tabela paid_loans não existe"
```
❌ ERRO CRÍTICO: Tabela paid_loans não existe!
```
**Solução**: Volte para **ETAPA 2A**

#### Erro 2: "Permissão negada"
```
❌ Código do erro: 42501
❌ Permissão negada!
```
**Solução**: Execute `fix-paid-loans-rls.sql` ou volte para **ETAPA 2B**

#### Erro 3: "Política RLS bloqueou"
```
❌ Política RLS bloqueou a inserção!
```
**Solução**: Execute `fix-paid-loans-rls.sql` ou volte para **ETAPA 2B**

#### Erro 4: "new row violates row-level security policy"
```
❌ new row violates row-level security policy
```
**Solução**: As políticas RLS estão muito restritivas. Execute:

```sql
-- Opção 1: Políticas mais permissivas
-- Execute: fix-paid-loans-rls.sql

-- Opção 2: Desabilitar RLS (menos seguro)
ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;
```

---

### ETAPA 4: Verificar no Banco de Dados

Para confirmar que salvou no banco:

1. **Abra o SQL Editor** no Supabase
2. **Execute**:
```sql
-- Ver todos os quitados
SELECT * FROM paid_loans ORDER BY created_at DESC LIMIT 10;

-- Contar quantos tem
SELECT COUNT(*) as total FROM paid_loans;
```

3. **Verifique** se o empréstimo aparece na lista

---

## 🔍 DIAGNÓSTICO COMPLETO

Se ainda não funcionar, execute este diagnóstico e me envie o resultado:

### No SQL Editor:
```sql
-- 1. Verificar tabela
SELECT 
    CASE WHEN EXISTS (SELECT FROM pg_tables WHERE tablename = 'paid_loans')
    THEN '✅ Tabela existe' 
    ELSE '❌ Tabela NÃO existe' 
    END as status;

-- 2. Verificar RLS
SELECT 
    tablename,
    CASE WHEN rowsecurity THEN '✅ RLS Habilitado' ELSE '❌ RLS Desabilitado' END
FROM pg_tables WHERE tablename = 'paid_loans';

-- 3. Contar políticas
SELECT 
    '📋 Políticas RLS:' as info,
    COUNT(*) as total
FROM pg_policies WHERE tablename = 'paid_loans';

-- 4. Listar políticas
SELECT policyname, cmd FROM pg_policies WHERE tablename = 'paid_loans';

-- 5. Teste de INSERT manual
INSERT INTO paid_loans (
    loan_id, client_id, original_amount, interest_rate,
    total_with_interest, loan_date, due_date, paid_date,
    total_paid, payment_method, notes
) VALUES (
    gen_random_uuid(), gen_random_uuid(),
    100, 5, 105,
    CURRENT_DATE, CURRENT_DATE, CURRENT_DATE,
    105, 'Teste', 'TESTE MANUAL'
) RETURNING id;

-- Se funcionou, deletar o teste:
DELETE FROM paid_loans WHERE notes = 'TESTE MANUAL';
```

### No Console do Navegador (F12):

Quando clicar em "Marcar como Quitado", **copie TODOS os logs** que aparecerem (especialmente os que têm ❌).

---

## 📊 RESUMO DOS ARQUIVOS

| Arquivo | Uso | Quando Executar |
|---------|-----|-----------------|
| `diagnostico-paid-loans.sql` | Identificar problema | **SEMPRE PRIMEIRO** |
| `fix-litoral-paid-loans.sql` | Criar tabela completa | Se tabela não existir |
| `fix-paid-loans-rls.sql` | Corrigir políticas RLS | Se INSERT falhar |
| `fix-sequence-error.sql` | Corrigir erro de sequence | Se tiver erro de sequence |
| `verify-paid-loans-table.sql` | Verificar configuração | Após executar scripts |

---

## 🎯 CHECKLIST FINAL

Marque conforme for fazendo:

- [ ] Executei `diagnostico-paid-loans.sql`
- [ ] Li o resultado do diagnóstico
- [ ] Executei o script de correção apropriado
- [ ] Vi mensagem de sucesso no SQL Editor
- [ ] Recarreguei a página (F5)
- [ ] Fiz logout e login novamente
- [ ] Abri o Console (F12)
- [ ] Testei "Marcar como Quitado"
- [ ] Li TODOS os logs no console
- [ ] Empréstimo foi salvo no banco (verificado via SQL)
- [ ] Empréstimo apareceu na aba "Quitados"

---

## 🆘 SE NADA FUNCIONAR

Me envie:

1. ✅ Print/cópia do resultado de `diagnostico-paid-loans.sql`
2. ✅ Print/cópia de **TODOS os logs** do console (F12) quando clicar em "Marcar como Quitado"
3. ✅ Resultado desta query:
```sql
SELECT * FROM pg_policies WHERE tablename = 'paid_loans';
```
4. ✅ Confirmação de qual empresa está usando (LITORAL CRED?)
5. ✅ Se consegue inserir manualmente via SQL:
```sql
INSERT INTO paid_loans (loan_id, client_id, original_amount, 
    interest_rate, total_with_interest, loan_date, due_date, 
    paid_date, total_paid, payment_method, notes)
VALUES (gen_random_uuid(), gen_random_uuid(), 100, 5, 105,
    CURRENT_DATE, CURRENT_DATE, CURRENT_DATE, 105, 'Teste', 'Teste manual');
```

---

## 💡 DICAS

1. **Sempre recarregue a página** após executar scripts SQL
2. **Faça logout/login** para garantir que as permissões sejam atualizadas
3. **Use o console (F12)** - os logs mostram EXATAMENTE onde está falhando
4. **Teste inserção manual** no SQL Editor para confirmar que é problema de código ou permissão
5. **Confirme que está no projeto correto** do Supabase (LITORAL CRED)

---

**Última Atualização**: 25/11/2025  
**Versão**: 2.0 - Com diagnóstico automático e logs detalhados  
**Status**: ✅ Pronto para usar
