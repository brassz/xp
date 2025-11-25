# ✅ Checklist de Recuperação - Litoral Cred

**Empresa:** Litoral Cred  
**Data:** _______________  
**Responsável:** _______________  
**URL do Banco:** https://dtifsfzmnjnllzzlndxv.supabase.co

---

## 📋 PREPARAÇÃO

- [ ] Acesso ao Supabase da Litoral Cred confirmado
- [ ] SQL Editor aberto e funcionando
- [ ] Permissões de administrador verificadas
- [ ] Arquivos SQL baixados e acessíveis
- [ ] Tempo estimado reservado: 30-45 minutos

---

## 🔒 PASSO 1: BACKUP PREVENTIVO (5 min)

**Arquivo:** `litoral-cred-backup-preventivo.sql`

- [ ] Arquivo aberto no editor de texto
- [ ] Conteúdo copiado para o SQL Editor
- [ ] Script executado (clique em "Run")
- [ ] Aguardou até aparecer "✅ BACKUP CONCLUÍDO COM SUCESSO!"
- [ ] Anotou as tabelas de backup criadas:
  - [ ] loans_backup_20241125
  - [ ] payments_backup_20241125
  - [ ] clients_backup_20241125
  - [ ] paid_loans_backup_20241125 (se existir)

**Resultado esperado:**
```
✅ BACKUP CONCLUÍDO COM SUCESSO!
📊 Resumo do Backup:
✅ Empréstimos (loans): ___ registros
✅ Pagamentos (payments): ___ registros
✅ Clientes (clients): ___ registros
```

**Anotar números:**
- Empréstimos: _______________
- Pagamentos: _______________
- Clientes: _______________

---

## 🔍 PASSO 2: DIAGNÓSTICO (5 min)

**Arquivo:** `litoral-cred-diagnostico-rapido.sql`

- [ ] Arquivo aberto no editor de texto
- [ ] Conteúdo copiado para o SQL Editor
- [ ] Script executado (clique em "Run")
- [ ] Analisou todos os resultados

**Anotar diagnóstico:**

- [ ] Tabela paid_loans existe? 
  - [ ] ✅ SIM
  - [ ] ❌ NÃO

- [ ] Empréstimos com status 'paid' na loans: _______________

- [ ] Empréstimos totalmente pagos (status errado): _______________

- [ ] Pagamentos órfãos (empréstimos deletados): _______________

- [ ] Total de empréstimos ativos: _______________

**Situação identificada:**
- [ ] Tabela não existe (precisa criar)
- [ ] Tabela existe mas vazia (precisa popular)
- [ ] Há empréstimos deletados (reconstrução necessária)
- [ ] Há empréstimos com status errado (correção necessária)

---

## 🏗️ PASSO 3: RESTAURAR ESTRUTURA (10 min)

**Arquivo:** `litoral-cred-restore-paid-loans.sql`

- [ ] Arquivo aberto no editor de texto
- [ ] Conteúdo copiado para o SQL Editor
- [ ] Script executado (clique em "Run")
- [ ] Aguardou conclusão (1-2 minutos)

**Verificações:**
- [ ] Mensagem "✅ Tabela paid_loans criada/restaurada com sucesso!"
- [ ] Índices criados
- [ ] Políticas RLS configuradas
- [ ] Triggers automáticos criados
- [ ] Sistema de auditoria configurado

**Executar verificação manual:**
```sql
SELECT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'paid_loans'
) AS tabela_existe;
```

- [ ] Resultado: ✅ TRUE (tabela existe)

---

## 💾 PASSO 4: RECUPERAR DADOS (15 min)

**Arquivo:** `litoral-cred-recover-data.sql`

- [ ] Arquivo aberto no editor de texto
- [ ] Conteúdo copiado para o SQL Editor
- [ ] Script executado (clique em "Run")
- [ ] Aguardou conclusão (2-5 minutos)

**Anotar resultados de cada método:**

### Método 1: Status 'paid'
- [ ] Executado
- [ ] Registros movidos: _______________

### Método 2: Totalmente pagos
- [ ] Executado
- [ ] Registros recuperados: _______________

### Método 3: Reconstrução (órfãos)
- [ ] Executado
- [ ] Registros reconstruídos: _______________
- [ ] ⚠️ Se > 0, precisam revisão manual

### Método 4: Correção de dados
- [ ] Executado
- [ ] Registros corrigidos: _______________

**Totais:**
- [ ] Total de empréstimos quitados recuperados: _______________
- [ ] Total de empréstimos ativos restantes: _______________
- [ ] Total de pagamentos no sistema: _______________
- [ ] Pagamentos órfãos finais: _______________

---

## ✅ PASSO 5: VERIFICAÇÃO (10 min)

### 5.1 Consulta Geral

```sql
SELECT COUNT(*) FROM paid_loans;
```

- [ ] Executado
- [ ] Total de registros: _______________

### 5.2 Ver Primeiros Registros

```sql
SELECT 
    pl.id,
    c.name as cliente,
    pl.original_amount,
    pl.total_paid,
    pl.paid_date
FROM paid_loans pl
LEFT JOIN clients c ON pl.client_id = c.id
ORDER BY pl.paid_date DESC
LIMIT 10;
```

- [ ] Executado
- [ ] Dados parecem corretos? 
  - [ ] ✅ SIM
  - [ ] ❌ NÃO (anotar problemas abaixo)

**Problemas identificados:**
________________________________________________________________
________________________________________________________________
________________________________________________________________

### 5.3 Verificar Problemas

```sql
-- Empréstimos sem cliente
SELECT COUNT(*) FROM paid_loans 
WHERE client_id = '00000000-0000-0000-0000-000000000000'::uuid;

-- Empréstimos reconstruídos
SELECT COUNT(*) FROM paid_loans 
WHERE notes LIKE '%RECONSTRUÍDO%';
```

- [ ] Executado
- [ ] Sem cliente: _______________
- [ ] Reconstruídos: _______________

### 5.4 Estatísticas Financeiras

```sql
SELECT 
    COUNT(*) as total,
    SUM(original_amount) as emprestado,
    SUM(total_paid) as recebido
FROM paid_loans;
```

- [ ] Executado
- [ ] Total de empréstimos: _______________
- [ ] Total emprestado: R$ _______________
- [ ] Total recebido: R$ _______________

---

## 🔧 PASSO 6: CORREÇÕES MANUAIS (se necessário)

**Executar apenas se houver problemas identificados no Passo 5**

### 6.1 Corrigir Empréstimos Sem Cliente

- [ ] Listar empréstimos sem cliente
- [ ] Identificar clientes corretos
- [ ] Executar UPDATEs

**Quantidade corrigida:** _______________

### 6.2 Revisar Empréstimos Reconstruídos

- [ ] Listar todos os reconstruídos
- [ ] Validar valores para cada um
- [ ] Corrigir valores incorretos
- [ ] Atualizar client_id correto

**Quantidade revisada:** _______________

### 6.3 Validar Datas

- [ ] Verificar datas suspeitas
- [ ] Corrigir se necessário

**Quantidade corrigida:** _______________

---

## 📊 PASSO 7: RELATÓRIOS FINAIS (5 min)

### 7.1 Relatório Geral

```sql
SELECT 
    'Empréstimos Quitados' as tipo,
    COUNT(*) as quantidade,
    SUM(total_paid) as total
FROM paid_loans

UNION ALL

SELECT 
    'Empréstimos Ativos' as tipo,
    COUNT(*) as quantidade,
    SUM(amount) as total
FROM loans
WHERE status = 'active';
```

- [ ] Executado
- [ ] Números fazem sentido? 
  - [ ] ✅ SIM
  - [ ] ❌ NÃO

### 7.2 Top 10 Clientes

```sql
SELECT 
    c.name,
    COUNT(pl.id) as emprestimos,
    SUM(pl.total_paid) as total
FROM paid_loans pl
JOIN clients c ON pl.client_id = c.id
GROUP BY c.name
ORDER BY total DESC
LIMIT 10;
```

- [ ] Executado
- [ ] Resultados parecem corretos? 
  - [ ] ✅ SIM
  - [ ] ❌ NÃO

---

## 🎯 CHECKLIST FINAL

Antes de considerar a recuperação completa, verificar:

- [ ] ✅ Backup preventivo foi criado e verificado
- [ ] ✅ Diagnóstico identificou todos os problemas
- [ ] ✅ Tabela `paid_loans` existe e está configurada
- [ ] ✅ Todos os 4 métodos de recuperação foram executados
- [ ] ✅ Total de registros recuperados: _______________
- [ ] ✅ Não há empréstimos com `client_id` inválido (ou foram corrigidos)
- [ ] ✅ Empréstimos reconstruídos foram revisados e corrigidos
- [ ] ✅ Valores financeiros estão consistentes
- [ ] ✅ Datas estão corretas
- [ ] ✅ Triggers automáticos estão ativos
- [ ] ✅ Sistema de auditoria está funcionando
- [ ] ✅ Relatórios financeiros conferem
- [ ] ✅ Interface da aplicação foi testada (se aplicável)

---

## 📝 DOCUMENTAÇÃO

### Resumo da Recuperação

**Data de execução:** _______________  
**Horário início:** _______________  
**Horário término:** _______________  
**Tempo total:** _______________

**Resultados:**
- Backup criado: ✅ SIM / ❌ NÃO
- Estrutura restaurada: ✅ SIM / ❌ NÃO
- Dados recuperados: _______________
- Correções manuais: _______________
- Problemas encontrados: _______________
- Status final: ✅ SUCESSO / ⚠️ PARCIAL / ❌ FALHOU

**Observações:**
________________________________________________________________
________________________________________________________________
________________________________________________________________
________________________________________________________________

**Próximos passos:**
- [ ] Monitorar sistema por 24-48h
- [ ] Validar relatórios com equipe financeira
- [ ] Documentar lições aprendidas
- [ ] Implementar backup automático (se não existir)

---

## 🆘 EM CASO DE PROBLEMAS

**Se algo der errado, PARE e execute:**

```sql
-- Ver comandos de restauração
SELECT * FROM restore_commands;
```

**Contatos:**
- Suporte Técnico: _______________
- Administrador: _______________
- Responsável Financeiro: _______________

---

## ✍️ ASSINATURAS

**Executado por:**  
Nome: _______________  
Data: _______________  
Assinatura: _______________

**Revisado por:**  
Nome: _______________  
Data: _______________  
Assinatura: _______________

**Aprovado por:**  
Nome: _______________  
Data: _______________  
Assinatura: _______________

---

**FIM DO CHECKLIST**

---

## 📚 Arquivos de Referência

- `README-RECUPERACAO-LITORAL-CRED.md` - Guia completo
- `LITORAL-CRED-GUIA-VISUAL.md` - Guia visual passo a passo
- `litoral-cred-backup-preventivo.sql` - Script de backup
- `litoral-cred-diagnostico-rapido.sql` - Script de diagnóstico
- `litoral-cred-restore-paid-loans.sql` - Script de estrutura
- `litoral-cred-recover-data.sql` - Script de recuperação
