# 🚨 Guia Rápido: Empréstimos Sumindo na Litoral

## Passo 1: Execute o Diagnóstico

1. Acesse: https://dtifsfzmnjnllzzlndxv.supabase.co
2. Vá em **SQL Editor**
3. Execute o arquivo: `investigate-missing-loans-litoral.sql`

## Passo 2: Identifique o Problema

Baseado nos resultados do diagnóstico, veja qual é a causa:

### 🔴 Causa A: RLS Está Habilitado
**Sintoma:** A seção "POLÍTICAS DE SEGURANÇA (RLS)" mostra "HABILITADO"

**Solução:**
```sql
-- Execute este comando:
ALTER TABLE loans DISABLE ROW LEVEL SECURITY;
```

Ou execute o arquivo completo: `fix-litoral-missing-loans-rls.sql`

---

### 🟡 Causa B: Empréstimos em cancelled_loans mas não em loans
**Sintoma:** A seção "EMPRÉSTIMOS CANCELADOS" mostra muitos registros recentes

**Solução:**
1. Execute: `fix-litoral-restore-from-cancelled.sql`
2. Analise quais empréstimos foram perdidos
3. Descomente o bloco de restauração apropriado no script
4. Execute novamente

---

### 🟡 Causa C: Empréstimos Órfãos (sem cliente)
**Sintoma:** A seção "VERIFICAÇÃO DE INTEGRIDADE" mostra empréstimos sem cliente

**Isso NÃO causa o problema de sumiço, mas indica problemas de dados**

---

### 🟢 Causa D: Filtros na Interface
**Sintoma:** Diagnóstico mostra muitos empréstimos no banco, mas poucos aparecem na tela

**Solução:**
1. Abra o sistema LITORAL
2. Vá na aba "Empréstimos"
3. Clique em "Limpar Filtros"
4. Ou abra o Console do navegador (F12) e execute:
```javascript
localStorage.removeItem('loanFilters');
location.reload();
```

---

## Passo 3: Previna Futuros Problemas

Após resolver o problema imediato, execute:

```sql
-- Arquivo: fix-litoral-prevent-future-loss.sql
```

Este script irá:
- ✅ Criar tabela de auditoria para rastrear mudanças
- ✅ Criar sistema de backup automático
- ✅ Permitir restaurar empréstimos deletados
- ✅ Registrar quem/quando fez cada alteração

---

## 🔍 Comandos Úteis para Debug

### Ver últimos 20 empréstimos
```sql
SELECT * FROM loans ORDER BY created_at DESC LIMIT 20;
```

### Ver empréstimos cancelados hoje
```sql
SELECT * FROM cancelled_loans WHERE cancelled_at::date = CURRENT_DATE;
```

### Contar todos os empréstimos
```sql
SELECT status, COUNT(*) FROM loans GROUP BY status;
```

### Ver se empréstimo específico existe
```sql
-- Substitua 'ID_DO_EMPRESTIMO' pelo ID real
SELECT 'loans' as tabela, COUNT(*) FROM loans WHERE id = 'ID_DO_EMPRESTIMO'
UNION ALL
SELECT 'cancelled_loans' as tabela, COUNT(*) FROM cancelled_loans WHERE loan_id = 'ID_DO_EMPRESTIMO';
```

---

## 📞 Checklist de Resolução

- [ ] Executei o diagnóstico completo
- [ ] Identifiquei a causa raiz
- [ ] Executei o script de correção apropriado
- [ ] Verifiquei que os empréstimos voltaram a aparecer
- [ ] Instalei o sistema de auditoria/backup
- [ ] Criei um backup manual
- [ ] Documentei o problema para referência futura

---

## ⚠️ Avisos Importantes

1. **SEMPRE faça backup antes de executar scripts de correção**
2. **Leia cada script antes de executar** (especialmente os que têm código comentado)
3. **Teste primeiro em uma cópia do banco** se possível
4. **Documente o que você fez** para referência futura

---

## 📁 Arquivos de Referência

1. **Diagnóstico:**
   - `investigate-missing-loans-litoral.sql` - Script principal de diagnóstico
   - `README-INVESTIGACAO-EMPRESTIMOS-SUMIDOS-LITORAL.md` - Documentação completa

2. **Correções:**
   - `fix-litoral-missing-loans-rls.sql` - Desabilitar RLS
   - `fix-litoral-restore-from-cancelled.sql` - Restaurar empréstimos
   - `fix-litoral-prevent-future-loss.sql` - Sistema de auditoria/backup

3. **Referências:**
   - `README-REMOVER-RLS.md` - Info sobre RLS
   - `README-MULTI-EMPRESAS.md` - Info sobre empresas

---

## 🆘 Se Nada Funcionar

Se após executar todos os scripts o problema persistir:

1. **Documente tudo:**
   - Salve os resultados do diagnóstico
   - Anote quantos empréstimos sumiram
   - Quando começou a acontecer
   - Se há padrão (sempre mesmo cliente, mesma data, etc.)

2. **Verifique a aplicação:**
   - Console do navegador (F12) - veja se há erros JavaScript
   - Network tab - veja se as requisições ao Supabase estão falhando
   - Confirme que está logado na empresa correta (badge no header)

3. **Verifique permissões:**
   - No Supabase, vá em Authentication > Policies
   - Verifique se o usuário tem permissões corretas

---

**Última atualização:** 1 de Dezembro de 2025
