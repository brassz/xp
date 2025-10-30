# Script para Remover Row Level Security (RLS)

## ⚠️ ATENÇÃO - LEIA ANTES DE EXECUTAR

Este script **REMOVE TODAS AS POLÍTICAS DE SEGURANÇA** do banco de dados. 

**CONSEQUÊNCIAS:**
- ❌ Qualquer usuário autenticado terá acesso a TODOS os dados
- ❌ Não haverá mais isolamento entre usuários
- ❌ Administradores e usuários comuns terão os mesmos privilégios
- ❌ Dados sensíveis ficarão expostos

## 🎯 Quando Usar Este Script

Este script deve ser usado APENAS em situações específicas:

1. **Ambiente de Desenvolvimento/Teste**
   - Para facilitar testes sem restrições de acesso
   - Para debugging de problemas de dados

2. **Migração de Dados**
   - Durante processos de importação/exportação massiva
   - Quando ferramentas externas precisam de acesso total

3. **Problemas com Políticas**
   - Quando políticas RLS estão causando erros
   - Para reconfigurar políticas do zero

4. **Single-User Environment**
   - Quando apenas um usuário/empresa usa o banco
   - Em ambientes controlados sem necessidade de segurança

## ❌ Quando NÃO Usar

**NUNCA USE EM PRODUÇÃO** se:
- Múltiplos usuários acessam o sistema
- Dados sensíveis precisam de proteção
- Compliance/Auditoria é necessário
- Sistema está em produção com clientes reais

## 📋 Como Usar

### Passo 1: Fazer Backup

**SEMPRE** faça backup antes de executar:

```bash
# No Supabase Dashboard:
# Settings > Database > Backup > Create backup
```

### Passo 2: Executar o Script

1. Acesse o painel do Supabase
2. Vá em **SQL Editor**
3. Cole o conteúdo do arquivo `remove-all-rls.sql`
4. Clique em **Run** ou pressione `Ctrl + Enter`
5. Aguarde a conclusão

### Passo 3: Verificar Execução

O script exibirá:

1. **Lista de tabelas** com status de RLS (todas devem mostrar `rls_enabled: false`)
2. **Lista de políticas** (deve estar vazia)
3. **Mensagem de confirmação**

## 🔄 Como Reverter

Se precisar reativar o RLS, você tem duas opções:

### Opção 1: Re-executar Script Completo

Execute novamente o script de setup do banco:
- `NEXUS-DATABASE-COMPLETE.sql` (para NEXUS)
- `setup-erechim-database.sql` (para ERECHIM)

### Opção 2: Script Manual de Reativação

Crie um script com:

```sql
-- Habilitar RLS
ALTER TABLE nome_da_tabela ENABLE ROW LEVEL SECURITY;

-- Recriar políticas
CREATE POLICY "nome_da_politica" ON nome_da_tabela
    FOR SELECT USING (sua_condicao);
```

## 📊 O Que o Script Faz

### 1. Remove Todas as Políticas

Remove políticas de:
- ✅ users (4 políticas)
- ✅ clients (4 políticas)
- ✅ loans (4 políticas)
- ✅ payments (4 políticas)
- ✅ guarantors (4 políticas)
- ✅ emergency_contacts (4 políticas)
- ✅ client_documents (1 política)
- ✅ expense_categories (2 políticas)
- ✅ expenses (4 políticas)
- ✅ installments (3 políticas)
- ✅ installment_payments (3 políticas)
- ✅ cash_transactions (3 políticas)
- ✅ cash_settings (2 políticas)
- ✅ paid_loans (2 políticas)
- ✅ overdue_loans (2 políticas)
- ✅ partial_paid_loans (2 políticas)
- ✅ cancelled_loans (2 políticas)
- ✅ client_pix_keys (4 políticas)

**Total: ~54 políticas removidas**

### 2. Desabilita RLS em Todas as Tabelas

Executa `ALTER TABLE ... DISABLE ROW LEVEL SECURITY` em:
- Todas as tabelas principais
- Todas as tabelas auxiliares
- Todas as tabelas de status

### 3. Verificações Finais

Exibe relatórios mostrando:
- Status de RLS de cada tabela
- Políticas restantes (se houver)
- Mensagem de confirmação

## 🔍 Verificação Manual

Após executar, você pode verificar manualmente:

```sql
-- Ver status de RLS
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';

-- Ver políticas ativas
SELECT * FROM pg_policies 
WHERE schemaname = 'public';
```

## 🛡️ Alternativas ao Remover RLS

Antes de remover completamente o RLS, considere:

### 1. Criar Política Permissiva

```sql
-- Permitir tudo para admins
CREATE POLICY "admin_all_access" ON nome_tabela
    FOR ALL 
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() 
            AND role = 'admin'
        )
    );
```

### 2. Usar Service Role Key

Use a **service_role key** do Supabase (não a anon key) para bypass automático do RLS.

### 3. Função de Bypass

```sql
-- Criar função que bypassa RLS
CREATE OR REPLACE FUNCTION bypass_rls()
RETURNS void AS $$
BEGIN
    SET LOCAL row_security = off;
END;
$$ LANGUAGE plpgsql;
```

## 📝 Logs e Auditoria

Após remover RLS:

- ❌ Logs de acesso não diferenciarão usuários
- ❌ Auditoria de "quem viu o quê" não será possível
- ❌ Compliance com LGPD/GDPR pode ser comprometido

## ⚡ Performance

**Impacto de Remover RLS:**

✅ **Positivo:**
- Queries mais rápidas (sem verificação de políticas)
- Joins simplificados
- Menor overhead do PostgreSQL

❌ **Negativo:**
- Perda total de segurança
- Possível acesso indevido a dados
- Violação de privacidade

## 🎓 Entendendo RLS

### O que é RLS?

Row Level Security é uma feature do PostgreSQL que:
- Filtra linhas automaticamente baseado em regras
- Isola dados entre usuários/empresas
- Funciona no nível do banco de dados

### Como Funciona?

```sql
-- Com RLS habilitado:
SELECT * FROM clients;
-- Retorna apenas clientes que o usuário tem permissão

-- Sem RLS:
SELECT * FROM clients;
-- Retorna TODOS os clientes do banco
```

## 📞 Suporte

Se tiver dúvidas sobre:
- ✅ Por que suas queries não retornam dados → Verifique políticas RLS
- ✅ Como criar políticas customizadas → Consulte documentação PostgreSQL
- ✅ Problemas após remover RLS → Re-execute script de setup

## ⚠️ Checklist Final

Antes de executar, confirme:

- [ ] Fiz backup completo do banco
- [ ] Entendo que todos os dados ficarão expostos
- [ ] Estou em ambiente de desenvolvimento/teste
- [ ] Tenho como reverter a operação
- [ ] Notifiquei a equipe (se aplicável)
- [ ] Li toda esta documentação

## 🚀 Após Remover RLS

O que muda na aplicação:

✅ **Funciona normalmente:**
- Login e autenticação
- Criação de registros
- Leitura de dados
- Atualização de registros
- Exclusão de registros

❌ **Não funciona mais:**
- Isolamento entre usuários
- Restrições baseadas em role
- Proteção de dados sensíveis
- Auditoria de acesso

---

**Criado em**: 30/10/2025  
**Arquivo**: `remove-all-rls.sql`  
**Versão**: 1.0  
**Empresa**: Todas (NEXUS, LITORAL, MOGIANA, ERECHIM)

**⚠️ USE COM RESPONSABILIDADE ⚠️**
