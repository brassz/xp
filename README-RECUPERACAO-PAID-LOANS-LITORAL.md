# 🔧 Recuperação de Empréstimos Quitados - LITORAL CRED

## 📋 Problema Identificado

Os empréstimos quitados da empresa **LITORAL CRED** desapareceram do sistema.

## 🎯 Possíveis Causas

1. **Tabela não existe**: A tabela `paid_loans` pode não ter sido criada no banco de dados da Litoral Cred
2. **RLS bloqueando acesso**: As políticas de Row Level Security podem estar impedindo a visualização
3. **Dados deletados**: Os registros podem ter sido deletados acidentalmente
4. **Migração incompleta**: Empréstimos marcados como "paid" não foram movidos para `paid_loans`
5. **Problema de permissões**: Usuário sem permissão adequada para visualizar os dados

## 🔍 Passo 1: Diagnóstico

Execute o script de diagnóstico no SQL Editor do Supabase da **LITORAL CRED**:

**URL do Supabase:** `https://dtifsfzmnjnllzzlndxv.supabase.co`

```sql
-- Execute o arquivo: diagnostico-paid-loans-litoral.sql
```

O diagnóstico irá verificar:
- ✅ Se a tabela `paid_loans` existe
- ✅ Quantos registros existem
- ✅ Se há políticas RLS ativas
- ✅ Se há empréstimos com status 'paid' na tabela loans
- ✅ Se há pagamentos que indicam quitação

## 🛠️ Passo 2: Recuperação

Após identificar o problema no diagnóstico, execute o script de recuperação:

```sql
-- Execute o arquivo: recuperar-paid-loans-litoral.sql
```

Este script irá:

### 1. Criar a tabela `paid_loans` (se não existir)
- Cria a estrutura completa da tabela
- Configura índices para performance
- Habilita RLS com políticas corretas
- Define permissões apropriadas

### 2. Recuperar dados de empréstimos quitados

**Opção A: Da tabela loans**
- Busca empréstimos com status = 'paid'
- Move para a tabela `paid_loans`

**Opção B: Dos pagamentos**
- Busca pagamentos marcados como `is_final_payment = true`
- Reconstrói os registros de empréstimos quitados
- Insere na tabela `paid_loans`

## 📊 Verificação Pós-Recuperação

Após executar os scripts, verifique no sistema:

1. Acesse a aba **"Empréstimos Quitados"** no sistema
2. Verifique se os empréstimos aparecem
3. Confira se os valores estão corretos
4. Teste as funcionalidades:
   - Visualizar detalhes
   - Ver histórico de pagamentos
   - Restaurar empréstimo (se necessário)

## 🚨 Solução Emergencial

Se os scripts não funcionarem, tente desabilitar temporariamente o RLS:

```sql
-- ATENÇÃO: Use apenas para diagnóstico!
ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;

-- Teste se consegue ver os dados agora
SELECT COUNT(*) FROM paid_loans;

-- NÃO ESQUEÇA de reabilitar depois!
ALTER TABLE paid_loans ENABLE ROW LEVEL SECURITY;
```

## 🔒 Prevenção Futura

Para evitar que isso aconteça novamente:

### 1. Backup Regular
```sql
-- Criar backup semanal
CREATE TABLE paid_loans_backup_YYYYMMDD AS 
SELECT * FROM paid_loans;
```

### 2. Verificar Políticas RLS
As políticas corretas devem ser:
- ✅ SELECT: Permitir para usuários autenticados
- ✅ INSERT: Permitir para usuários autenticados
- ✅ UPDATE: Permitir para criador ou admin
- ✅ DELETE: Permitir para criador ou admin

### 3. Monitoramento
```sql
-- Query para monitorar empréstimos quitados
SELECT 
    DATE_TRUNC('month', paid_date) as mes,
    COUNT(*) as total_quitados,
    SUM(total_paid) as valor_total
FROM paid_loans
GROUP BY DATE_TRUNC('month', paid_date)
ORDER BY mes DESC;
```

## 📞 Suporte

Se após executar todos os passos o problema persistir:

1. Verifique os logs de erro no console do navegador (F12)
2. Verifique os logs do Supabase
3. Confirme que está conectado na empresa correta (LITORAL CRED)
4. Verifique se o usuário tem permissões adequadas

## 📝 Checklist de Recuperação

- [ ] Executei o script de diagnóstico
- [ ] Identifiquei a causa do problema
- [ ] Executei o script de recuperação
- [ ] Verifiquei os dados no sistema
- [ ] Testei as funcionalidades
- [ ] Criei backup dos dados recuperados
- [ ] Documentei o que aconteceu

## 🎯 Resultado Esperado

Após a recuperação bem-sucedida:
- ✅ Tabela `paid_loans` existe e está configurada corretamente
- ✅ Todos os empréstimos quitados aparecem na aba correspondente
- ✅ Valores e datas estão corretos
- ✅ Funcionalidades de visualização funcionam
- ✅ Backup foi criado para segurança

---

**Data de criação:** 25/11/2025  
**Empresa afetada:** LITORAL CRED  
**Banco de dados:** https://dtifsfzmnjnllzzlndxv.supabase.co
