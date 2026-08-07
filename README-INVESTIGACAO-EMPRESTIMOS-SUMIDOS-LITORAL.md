# Investigação: Empréstimos Sumindo na Empresa Litoral

## 🚨 Problema Reportado

**Empresa:** LITORAL CRED  
**Problema:** Alguns empréstimos estão desaparecendo do sistema  
**Data:** 1 de Dezembro de 2025

## 📋 Diagnóstico

Para investigar o problema, foi criado um script de diagnóstico completo que verifica múltiplos aspectos do banco de dados.

### Como Executar o Diagnóstico

1. **Acesse o painel do Supabase da LITORAL CRED**
   - URL: `https://dtifsfzmnjnllzzlndxv.supabase.co`

2. **Vá para o SQL Editor**
   - No menu lateral, clique em "SQL Editor"

3. **Execute o script de diagnóstico**
   - Abra o arquivo `investigate-missing-loans-litoral.sql`
   - Copie todo o conteúdo
   - Cole no SQL Editor do Supabase
   - Clique em "Run" (ou pressione Ctrl + Enter)

4. **Analise os resultados**
   - O script retornará múltiplas seções com informações detalhadas

## 🔍 O Que o Script Verifica

### 1. Contagem Geral de Empréstimos
- Total de empréstimos na tabela principal `loans`
- Distribuição de empréstimos por status (active, paid, cancelled, etc.)

### 2. Empréstimos Cancelados
- Total de empréstimos na tabela `cancelled_loans`
- Empréstimos cancelados recentemente (últimos 30 dias)
- Detalhes dos 20 últimos cancelamentos
- **IMPORTANTE:** Verifica se o empréstimo ainda existe na tabela `loans` ou foi deletado

### 3. Verificação de Integridade
- Empréstimos "órfãos" (sem cliente vinculado)
- Problemas de relacionamento entre tabelas

### 4. Políticas RLS (Row Level Security)
- Verifica se o RLS está habilitado na tabela `loans`
- Lista todas as políticas ativas
- **Causa Comum:** RLS mal configurado pode esconder dados de usuários

### 5. Triggers do Banco de Dados
- Lista todos os triggers na tabela `loans`
- Identifica se há triggers que podem estar:
  - Movendo empréstimos para outras tabelas
  - Deletando empréstimos automaticamente
  - Alterando o status sem notificação

### 6. Histórico de Criação
- Empréstimos criados nos últimos 30 dias
- Tendência de criação por semana
- Ajuda a identificar se houve uma queda súbita

### 7. Duplicações
- Verifica se há empréstimos duplicados
- Pode indicar problema de sincronização

### 8. Últimos 50 Empréstimos
- Lista detalhada dos últimos empréstimos criados
- Status atual de cada um
- Se estão na tabela `cancelled_loans`

### 9. Foreign Keys CASCADE
- Identifica constraints que podem deletar empréstimos em cascata
- Se um cliente for deletado, pode arrastar empréstimos junto

### 10. Resumo Final
- Contagem em todas as tabelas relacionadas a empréstimos
- Visão geral do estado do banco

## 🎯 Possíveis Causas

Com base na análise do código e estrutura do banco, as causas mais prováveis são:

### 1. ⚠️ RLS (Row Level Security) Ativo
**Probabilidade:** ALTA 🔴

O sistema tem suporte para RLS, e se estiver mal configurado, pode esconder empréstimos de certos usuários.

**Como Verificar:**
```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' AND tablename = 'loans';
```

**Solução:**
- Se o RLS estiver causando problemas e você usa apenas uma empresa, execute o script `remove-all-rls.sql`
- **ATENÇÃO:** Só faça isso se compreender as implicações de segurança

### 2. 🔄 Triggers Automáticos de Status
**Probabilidade:** MÉDIA 🟡

Existem triggers que movem empréstimos para tabelas de status (`cancelled_loans`, `paid_loans`, etc.) quando o status muda.

**Comportamento:**
- Quando um empréstimo tem status alterado para 'cancelled', ele é **COPIADO** para `cancelled_loans`
- O empréstimo original pode ou não ser deletado, dependendo da implementação

**Verificar no diagnóstico:**
- Veja a seção "EMPRÉSTIMOS CANCELADOS"
- Compare com "ÚLTIMOS 50 EMPRÉSTIMOS"

### 3. 🗑️ Cascade Delete de Clientes
**Probabilidade:** MÉDIA 🟡

Se um cliente for deletado, todos os seus empréstimos também serão deletados devido ao `ON DELETE CASCADE`.

**Como Verificar:**
```sql
-- Verificar se há empréstimos órfãos (sem cliente)
SELECT COUNT(*) FROM loans l
WHERE NOT EXISTS (SELECT 1 FROM clients c WHERE c.id = l.client_id);
```

### 4. 📱 Problema na Interface (Filtros)
**Probabilidade:** BAIXA 🟢

Os filtros da interface podem estar escondendo empréstimos.

**Como Verificar:**
- Limpe todos os filtros na aba "Empréstimos"
- Verifique o localStorage: `localStorage.getItem('loanFilters')`
- Limpe os filtros: `localStorage.removeItem('loanFilters')`

### 5. 🔐 Múltiplos Bancos de Dados
**Probabilidade:** BAIXA 🟢

Como o sistema suporta múltiplas empresas, é possível que:
- Empréstimos foram criados em outra empresa por engano
- Usuário está logado na empresa errada

**Como Verificar:**
- Confirme que está conectado à empresa LITORAL CRED
- Verifique o badge no header do dashboard

## 🛠️ Soluções Propostas

### Solução 1: Desabilitar RLS (Temporário)

Se o diagnóstico mostrar que o RLS está causando problemas:

```sql
-- Executar no SQL Editor do Supabase da LITORAL
ALTER TABLE loans DISABLE ROW LEVEL SECURITY;
```

Ou use o script completo:
- Execute `remove-all-rls.sql` (ver `README-REMOVER-RLS.md`)

### Solução 2: Recuperar Empréstimos de cancelled_loans

Se os empréstimos foram movidos para `cancelled_loans` indevidamente:

```sql
-- Ver empréstimos em cancelled_loans que ainda deveriam estar ativos
SELECT 
    cl.*,
    CASE 
        WHEN EXISTS (SELECT 1 FROM loans WHERE id = cl.loan_id AND status = 'cancelled')
        THEN 'OK - Está cancelado corretamente'
        WHEN EXISTS (SELECT 1 FROM loans WHERE id = cl.loan_id)
        THEN 'PROBLEMA - Está em ambas as tabelas com status diferente'
        ELSE 'PROBLEMA GRAVE - Foi deletado da tabela loans'
    END as diagnostico
FROM cancelled_loans cl
ORDER BY cl.cancelled_at DESC
LIMIT 20;
```

### Solução 3: Criar Script de Backup Preventivo

```sql
-- Criar uma tabela de backup de todos os empréstimos
CREATE TABLE IF NOT EXISTS loans_backup AS 
SELECT *, NOW() as backup_date 
FROM loans;

-- Agendar backups diários (se possível via Supabase Functions)
```

### Solução 4: Adicionar Auditoria

```sql
-- Criar tabela de auditoria para rastrear mudanças
CREATE TABLE IF NOT EXISTS loans_audit (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    loan_id UUID NOT NULL,
    operation TEXT NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
    old_data JSONB,
    new_data JSONB,
    changed_by UUID REFERENCES users(id),
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar trigger para auditoria (exemplo simplificado)
CREATE OR REPLACE FUNCTION audit_loans()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO loans_audit (loan_id, operation, old_data)
        VALUES (OLD.id, 'DELETE', row_to_json(OLD));
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO loans_audit (loan_id, operation, old_data, new_data)
        VALUES (NEW.id, 'UPDATE', row_to_json(OLD), row_to_json(NEW));
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER loans_audit_trigger
AFTER UPDATE OR DELETE ON loans
FOR EACH ROW EXECUTE FUNCTION audit_loans();
```

## 📊 Próximos Passos

1. **Execute o script de diagnóstico** (`investigate-missing-loans-litoral.sql`)
2. **Analise os resultados** especialmente:
   - Seção de RLS
   - Empréstimos cancelados recentemente
   - Triggers ativos
3. **Documente os achados** em um arquivo ou mensagem
4. **Aplique a solução apropriada** baseada nos resultados
5. **Monitore por alguns dias** para ver se o problema se repete

## 🔒 Segurança

**IMPORTANTE:** Antes de fazer qualquer alteração no banco de dados:

1. ✅ Faça um backup completo
   - Supabase Dashboard > Settings > Database > Backup
2. ✅ Documente o estado atual
   - Salve os resultados do script de diagnóstico
3. ✅ Teste em ambiente de desenvolvimento primeiro (se possível)
4. ✅ Tenha um plano de rollback

## 📞 Suporte

Se após executar o diagnóstico você precisar de ajuda para interpretar os resultados:

1. Salve os resultados completos do script
2. Anote quais seções apresentaram resultados inesperados
3. Verifique se há padrões (ex: todos os empréstimos sumidos são de um cliente específico)
4. Documente quando o problema começou a acontecer

## 📝 Histórico de Mudanças

- **2025-12-01:** Criação do script de diagnóstico e documentação inicial

---

**Arquivos Relacionados:**
- `investigate-missing-loans-litoral.sql` - Script de diagnóstico
- `remove-all-rls.sql` - Script para remover RLS (use com cautela)
- `README-REMOVER-RLS.md` - Documentação sobre remoção de RLS
- `README-MULTI-EMPRESAS.md` - Documentação do sistema multi-empresas
