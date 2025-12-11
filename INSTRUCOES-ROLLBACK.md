# Instruções de Rollback - Reverter Controle Financeiro

## ⚠️ ATENÇÃO - LEIA ANTES DE EXECUTAR

Este processo vai **DELETAR PERMANENTEMENTE**:
- ✅ Todas as 4 tabelas criadas
- ✅ Todos os dados de entradas e despesas
- ✅ Todas as 4 views
- ✅ Todas as 2 funções SQL
- ✅ Todos os triggers
- ✅ Todos os índices

**NÃO HÁ COMO DESFAZER APÓS EXECUTAR!**

---

## 📋 Passo a Passo para Reverter

### Passo 1: (OPCIONAL) Fazer Backup

Se você quiser manter os dados antes de deletar:

1. Acesse o Supabase: https://pebwoerzslfzhjptyjwh.supabase.co
2. Vá para **SQL Editor**
3. Execute estas queries e salve os resultados:

```sql
-- Backup de entradas
SELECT * FROM financial_control_entries;

-- Backup de despesas
SELECT * FROM financial_control_expenses;

-- Backup de reinvestimentos
SELECT * FROM financial_control_reinvestments;

-- Backup de configurações
SELECT * FROM financial_control_settings;
```

### Passo 2: Executar Script de Rollback

1. Acesse o Supabase: https://pebwoerzslfzhjptyjwh.supabase.co
2. Faça login com suas credenciais
3. No menu lateral, clique em **SQL Editor**
4. Abra o arquivo `rollback-financial-control.sql`
5. **Copie TODO o conteúdo** do arquivo
6. **Cole no SQL Editor** do Supabase
7. Clique em **Run** (ou pressione Ctrl+Enter)
8. Aguarde a execução (deve levar alguns segundos)
9. Verifique se apareceu "Success" ou mensagem de sucesso

### Passo 3: Verificar Remoção

Execute estas queries no SQL Editor para confirmar:

```sql
-- Deve retornar 0 linhas
SELECT table_name 
FROM information_schema.tables 
WHERE table_name LIKE 'financial_control%';

-- Deve retornar 0 linhas
SELECT table_name 
FROM information_schema.views 
WHERE table_name LIKE 'financial_control%' 
   OR table_name LIKE 'expenses_by_category%';

-- Deve retornar 0 linhas
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_name LIKE '%financial%';
```

**Resultado Esperado**: Todas as queries devem retornar **0 linhas**

---

## 🗑️ O Que Será Removido

### Tabelas (4)
- ❌ `financial_control_entries`
- ❌ `financial_control_expenses`
- ❌ `financial_control_reinvestments`
- ❌ `financial_control_settings`

### Views (4)
- ❌ `financial_control_summary`
- ❌ `expenses_by_category`
- ❌ `entries_by_company`
- ❌ `monthly_financial_report`

### Funções SQL (2)
- ❌ `get_current_financial_balance()`
- ❌ `get_recommended_reinvestment()`

### Triggers (4)
- ❌ `update_fc_entries_timestamp`
- ❌ `update_fc_expenses_timestamp`
- ❌ `update_fc_reinvestments_timestamp`
- ❌ `update_fc_settings_timestamp`

### Função auxiliar (1)
- ❌ `update_financial_control_timestamp()`

### Índices (7)
- ❌ Todos os índices relacionados

---

## ✅ O Que NÃO Será Afetado

O script **NÃO** vai remover:
- ✅ Tabelas originais do sistema (clients, loans, payments, etc)
- ✅ Dados de clientes
- ✅ Dados de empréstimos
- ✅ Dados de pagamentos
- ✅ Dados de comissões
- ✅ Qualquer outra tabela do sistema

**Apenas o Controle Financeiro será removido!**

---

## 🔍 Solução de Problemas

### Erro: "cannot drop table ... because other objects depend on it"

**Solução**: O script usa `CASCADE` que remove automaticamente. Se ainda der erro:

```sql
-- Force drop com CASCADE explícito
DROP TABLE IF EXISTS financial_control_settings CASCADE;
DROP TABLE IF EXISTS financial_control_reinvestments CASCADE;
DROP TABLE IF EXISTS financial_control_expenses CASCADE;
DROP TABLE IF EXISTS financial_control_entries CASCADE;
```

### Erro: "permission denied"

**Solução**: Verifique se você está logado como admin no Supabase.

### Erro: "relation does not exist"

**Solução**: Normal, significa que a tabela já foi removida ou nunca existiu.

---

## 📊 Status Após Rollback

### Banco de Dados
- ✅ Voltou ao estado anterior
- ✅ Sem tabelas de controle financeiro
- ✅ Sem dados de entradas/despesas
- ✅ Espaço liberado

### Sistema (Frontend)
⚠️ A interface ainda terá a aba "Controle Financeiro", mas ela vai dar erro ao tentar carregar dados.

Para remover completamente do frontend também, veja o próximo arquivo: `ROLLBACK-FRONTEND.md`

---

## ⏱️ Tempo Estimado

- Backup (opcional): 2-5 minutos
- Executar rollback: 10-20 segundos
- Verificar: 1 minuto

**Total**: ~3-6 minutos

---

## 📝 Checklist de Verificação

Após executar o rollback:

- [ ] Script executou sem erros
- [ ] Query de verificação retorna 0 linhas (tabelas)
- [ ] Query de verificação retorna 0 linhas (views)
- [ ] Query de verificação retorna 0 linhas (funções)
- [ ] Nenhuma tabela `financial_control_*` aparece no Table Editor
- [ ] Backup foi feito (se necessário)

---

## 🆘 Em Caso de Erro

Se algo der errado durante o rollback:

1. **NÃO ENTRE EM PÂNICO** - As outras tabelas estão protegidas
2. Copie a mensagem de erro completa
3. Execute a query de verificação para ver o que ainda existe
4. Tente dropar manualmente as tabelas que restaram

---

## 🔄 Para Reinstalar Depois

Se quiser reinstalar o Controle Financeiro no futuro:

1. Execute novamente: `financial-control-setup.sql`
2. Todas as tabelas serão recriadas
3. Dados zerados (começará vazio)

---

## 📞 Confirmação Final

Antes de executar, confirme:

- [ ] Entendo que TODOS os dados serão deletados
- [ ] Fiz backup se necessário
- [ ] Estou no banco de dados correto (Franca Private)
- [ ] Tenho certeza que quero reverter

**Se todos os itens estão marcados, pode executar o rollback!**

---

**Data de Criação**: 11 de Dezembro de 2025  
**Arquivo**: rollback-financial-control.sql  
**Status**: Pronto para uso
