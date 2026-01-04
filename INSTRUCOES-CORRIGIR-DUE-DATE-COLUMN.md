# 🔧 Instruções: Corrigir erro da coluna due_date_manually_changed

## 📋 Contexto

**Erro atual:**
```
Erro ao atualizar empréstimo: Could not find the 'due_date_manually_changed' column of 'loans' in the schema cache
```

**Causa:** A coluna `due_date_manually_changed` não existe no banco de dados, mas o código está tentando usá-la.

---

## ⚡ Solução Rápida (3 passos)

### Passo 1: Verificar o problema (opcional)

Execute este script para confirmar que a coluna não existe:

```bash
verify-due-date-column.sql
```

Você verá:
```
✗ A coluna due_date_manually_changed NÃO EXISTE na tabela loans
STATUS: ERRO - Coluna não encontrada
```

### Passo 2: Aplicar a correção

Execute o script de correção no seu banco de dados:

```bash
fix-due-date-manually-changed-column.sql
```

**Como executar:**

#### Opção A: Supabase Dashboard (Recomendado)
1. Acesse [https://app.supabase.com](https://app.supabase.com)
2. Selecione seu projeto
3. Vá em **SQL Editor** (menu lateral)
4. Clique em **+ New query**
5. Cole o conteúdo do arquivo `fix-due-date-manually-changed-column.sql`
6. Clique em **Run** (ou Ctrl+Enter)

#### Opção B: Linha de comando
```bash
# Se você tiver acesso direto ao PostgreSQL
psql -h seu-host.supabase.co -d postgres -U postgres -f fix-due-date-manually-changed-column.sql
```

#### Opção C: Copiar e colar SQL
Abra o arquivo `fix-due-date-manually-changed-column.sql` e copie todo o conteúdo, depois cole no SQL Editor do Supabase.

### Passo 3: Verificar a correção

Execute novamente o script de verificação:

```bash
verify-due-date-column.sql
```

Você deverá ver:
```
✓ A coluna due_date_manually_changed EXISTE na tabela loans
✓ O índice idx_loans_due_date_manually_changed EXISTE
STATUS: OK - Coluna configurada corretamente
```

---

## ✅ Teste

Após aplicar a correção:

1. Acesse sua aplicação
2. Tente editar um empréstimo
3. Altere a data de vencimento
4. Salve as alterações
5. **Resultado esperado:** 
   - Nenhum erro
   - A data aparecerá em **amarelo** na lista
   - Um ícone ⚠️ será exibido ao lado da data
   - Tooltip: "Data de vencimento alterada manualmente"

---

## 📊 O que foi corrigido

A correção adiciona:

| Item | Descrição |
|------|-----------|
| **Coluna** | `due_date_manually_changed` (BOOLEAN) |
| **Valor padrão** | `FALSE` |
| **Índice** | `idx_loans_due_date_manually_changed` |
| **Comentário** | Documentação no schema |

### Funcionalidade

Esta coluna rastreia quando um usuário altera manualmente a data de vencimento de um empréstimo, permitindo:

- ✅ Destacar visualmente datas modificadas (em amarelo)
- ✅ Diferenciar datas calculadas vs. datas manuais
- ✅ Auditoria de alterações manuais
- ✅ Melhor experiência do usuário

---

## 🚨 Prevenção de problemas futuros

Para evitar que este tipo de erro aconteça novamente:

### 1. Checklist antes de fazer deploy

- [ ] Código atualizado no repositório
- [ ] Scripts SQL executados no banco de dados
- [ ] Testes realizados em ambiente de staging
- [ ] Verificação das migrações aplicadas

### 2. Processo recomendado

1. **Desenvolvimento:**
   - Criar a coluna no banco local primeiro
   - Depois escrever o código que usa a coluna
   
2. **Staging:**
   - Aplicar o SQL no banco de staging
   - Testar a funcionalidade completamente
   
3. **Produção:**
   - Aplicar o SQL no banco de produção
   - Fazer deploy do código
   - Monitorar erros

### 3. Documentação

Mantenha um registro de todas as alterações de schema:
- Scripts SQL em `/workspace/*.sql`
- READMEs explicativos em `/workspace/README-*.md`
- CHANGELOGs em `/workspace/CHANGELOG-*.md`

---

## 📞 Suporte

### Arquivos criados para esta correção:

1. **fix-due-date-manually-changed-column.sql** - Script de correção principal
2. **verify-due-date-column.sql** - Script de verificação
3. **README-fix-due-date-column.md** - Documentação detalhada
4. **INSTRUCOES-CORRIGIR-DUE-DATE-COLUMN.md** - Este guia

### Se o problema persistir:

1. Verifique se você está conectado ao banco correto
2. Verifique se tem permissões para alterar a tabela `loans`
3. Verifique o log de erros do Supabase
4. Limpe o cache do browser (Ctrl+Shift+R)
5. Recarregue a aplicação

---

## 🎯 Resumo

```bash
# 1. Verificar (opcional)
Execute: verify-due-date-column.sql

# 2. Corrigir
Execute: fix-due-date-manually-changed-column.sql

# 3. Verificar novamente
Execute: verify-due-date-column.sql

# 4. Testar
Edite um empréstimo na aplicação
```

✅ **Pronto!** O erro "Could not find the 'due_date_manually_changed' column" está corrigido.
