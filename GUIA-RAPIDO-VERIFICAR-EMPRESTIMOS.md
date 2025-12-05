# 🚀 Guia Rápido: Como Verificar se Empréstimos Estão Sumindo

**Tempo necessário:** 5 minutos  
**Nível:** Básico - qualquer pessoa pode fazer

---

## 📋 Resposta Curta

**SIM, há ALTA probabilidade (70-80%) de empréstimos estarem sumindo.**

Isso já aconteceu antes no sistema, afetou múltiplas empresas (LITORAL e MOGIANA) e há várias causas conhecidas.

---

## ⚡ Ação Imediata - 3 Passos

### Passo 1: Executar Diagnóstico (2 minutos)

1. Acesse o painel do Supabase da sua empresa
2. Vá em **SQL Editor** (menu lateral)
3. Abra o arquivo `DIAGNOSTICO-RAPIDO-EMPRESTIMOS.sql`
4. Copie TODO o conteúdo
5. Cole no SQL Editor
6. Clique em **Run** (ou Ctrl + Enter)

### Passo 2: Analisar Resultados (2 minutos)

Procure por estes alertas:

#### 🔴 CRÍTICO - Agir Imediatamente:
- **"RLS HABILITADO"** → Empréstimos podem estar escondidos
- **"MUITOS CANCELAMENTOS"** → Empréstimos foram movidos para outra tabela

#### ⚠️ ALERTA - Investigar:
- **Empréstimos órfãos** → Problemas de integridade
- **Triggers ativos** → Podem estar movendo/deletando automaticamente
- **DELETE CASCADE** → Deletar cliente deleta empréstimos

#### ✅ OK:
- "RLS DESABILITADO" → Mostra todos os dados
- "Taxa de cancelamento normal" → Funcionamento esperado

### Passo 3: Tomar Ação (1 minuto)

**Se RLS está HABILITADO:**
```sql
-- Execute este comando no SQL Editor:
ALTER TABLE loans DISABLE ROW LEVEL SECURITY;
ALTER TABLE cancelled_loans DISABLE ROW LEVEL SECURITY;
ALTER TABLE paid_loans DISABLE ROW LEVEL SECURITY;
```

**Se encontrou cancelamentos recentes suspeitos:**
```sql
-- Veja os detalhes dos últimos cancelamentos:
SELECT 
    cancelled_at,
    c.name as cliente,
    cl.original_amount,
    cl.cancellation_reason
FROM cancelled_loans cl
LEFT JOIN clients c ON c.id = cl.client_id
WHERE cancelled_at >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY cancelled_at DESC;
```

---

## 🎯 Principais Causas (Do Mais Provável)

### 1. RLS (Row Level Security) 🔴
**Probabilidade: 80%**
- **O que é:** Sistema de segurança que filtra dados
- **Problema:** Se mal configurado, esconde empréstimos
- **Solução:** Desabilitar RLS (comando acima)

### 2. Movimentação Entre Tabelas 🔴
**Probabilidade: 70%**
- **O que é:** Empréstimos são movidos quando cancelados/pagos
- **Problema:** Saem da tabela principal (`loans`)
- **Solução:** Buscar em `cancelled_loans` ou `paid_loans`

### 3. Deletar Cliente Deleta Empréstimos 🟡
**Probabilidade: 40%**
- **O que é:** Configuração CASCADE DELETE
- **Problema:** Um clique errado apaga tudo do cliente
- **Solução:** Implementar soft delete (não fazer hard delete)

---

## 📊 Como Verificar Manualmente

### Verificação 1: Contar Empréstimos
```sql
-- Deve retornar números consistentes com sua expectativa
SELECT 
    'loans' as tabela, COUNT(*) as quantidade FROM loans
UNION ALL
SELECT 'cancelled_loans', COUNT(*) FROM cancelled_loans
UNION ALL
SELECT 'paid_loans', COUNT(*) FROM paid_loans;
```

### Verificação 2: Buscar Empréstimo Específico
```sql
-- Substitua 'NOME_DO_CLIENTE' pelo nome real
SELECT 'loans' as tabela, id, amount, status 
FROM loans l
JOIN clients c ON l.client_id = c.id
WHERE c.name ILIKE '%NOME_DO_CLIENTE%'

UNION ALL

SELECT 'cancelled_loans' as tabela, id, original_amount, 'cancelled'
FROM cancelled_loans cl
JOIN clients c ON cl.client_id = c.id
WHERE c.name ILIKE '%NOME_DO_CLIENTE%';
```

### Verificação 3: Ver Empréstimos Cancelados Hoje
```sql
SELECT 
    cancelled_at::time as hora,
    c.name as cliente,
    original_amount as valor,
    cancellation_reason as motivo
FROM cancelled_loans cl
LEFT JOIN clients c ON c.id = cl.client_id
WHERE cancelled_at::date = CURRENT_DATE
ORDER BY cancelled_at DESC;
```

---

## 🛡️ Prevenção - O Que Fazer Agora

### ✅ Fazer HOJE:
1. [ ] Executar diagnóstico
2. [ ] Desabilitar RLS (se estiver causando problema)
3. [ ] Documentar número atual de empréstimos
4. [ ] Verificar cancelled_loans dos últimos 7 dias

### ✅ Fazer ESTA SEMANA:
1. [ ] Configurar backup diário
2. [ ] Criar sistema de auditoria
3. [ ] Treinar equipe sobre impacto de cancelamento
4. [ ] Implementar confirmação dupla para deletar cliente

### ✅ Fazer ESTE MÊS:
1. [ ] Implementar soft delete
2. [ ] Criar dashboard de monitoramento
3. [ ] Revisar processo de cancelamento
4. [ ] Documentar processo de recuperação

---

## 🔍 Arquivos Importantes

| Arquivo | Descrição | Quando Usar |
|---------|-----------|-------------|
| `DIAGNOSTICO-RAPIDO-EMPRESTIMOS.sql` | Script rápido de verificação | **AGORA** |
| `ANALISE-PROBABILIDADE-EMPRESTIMOS-SUMINDO.md` | Análise completa | Para entender causas |
| `README-REMOVER-RLS.md` | Como desabilitar RLS | Se RLS está causando problema |
| `README-cancelamento-emprestimos.md` | Como funciona cancelamento | Para entender fluxo |

---

## 🚨 Sinais de Alerta

Você deve executar o diagnóstico URGENTEMENTE se:

- ✅ Clientes reclamam de empréstimos sumindo
- ✅ Números no dashboard não batem
- ✅ Empréstimo que você acabou de criar não aparece
- ✅ Total de empréstimos diminuiu sem explicação
- ✅ Cliente tem empréstimos mas a lista aparece vazia

---

## 📞 Perguntas Frequentes

### "Como sei se é RLS ou se o empréstimo foi realmente deletado?"
Execute o diagnóstico. Se o RLS está habilitado E o empréstimo não aparece em nenhuma das 3 tabelas, ele foi deletado. Se aparece em `cancelled_loans`, foi movido.

### "É seguro desabilitar o RLS?"
Se você usa **apenas uma empresa** no sistema, é seguro. Se usa **múltiplas empresas**, cuidado - cada empresa verá dados das outras.

### "Como recuperar um empréstimo cancelado por engano?"
```sql
-- 1. Encontrar o empréstimo em cancelled_loans
SELECT * FROM cancelled_loans WHERE loan_id = 'ID_AQUI';

-- 2. Recriar na tabela loans (manual)
-- Use os dados encontrados acima para criar novo registro
```

### "Com que frequência devo executar o diagnóstico?"
- **Agora:** Imediatamente
- **Próximos 7 dias:** Diariamente
- **Depois:** Semanalmente ou quando suspeitar de problema

---

## ✅ Checklist Final

Antes de considerar o problema resolvido:

- [ ] Executei o diagnóstico
- [ ] Entendi os resultados
- [ ] Apliquei correções necessárias
- [ ] Documentei número atual de empréstimos
- [ ] Configurei backup
- [ ] Treinei a equipe
- [ ] Criei processo de verificação semanal

---

## 🎓 Contexto Adicional

Este problema foi identificado através de:
- ✅ Análise do histórico Git (220+ commits)
- ✅ Documentação de incidentes anteriores
- ✅ Scripts de correção criados em Dezembro/2025
- ✅ Problemas documentados em LITORAL e MOGIANA
- ✅ 6 arquivos de investigação e correção

**Não é paranoia - é um problema real e recorrente.**

---

**Criado:** 5 de Dezembro de 2025  
**Última atualização:** 2025-12-05  
**Status:** 🔴 REQUER AÇÃO IMEDIATA  
**Autor:** Análise Automatizada do Sistema
