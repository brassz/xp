# 📋 INSTRUÇÕES - Aplicar Funcionalidade de Coloração de Datas de Vencimento

## ⚡ Aplicação Rápida

### Passo 1: Executar Script SQL no Supabase

1. Acesse o Supabase Dashboard: https://supabase.com/dashboard
2. Selecione seu projeto
3. Vá para **SQL Editor** (menu lateral)
4. Cole o conteúdo do arquivo `add-due-date-color-tracking.sql`
5. Clique em **RUN** ou pressione `Ctrl+Enter`

### Passo 2: Verificar a Aplicação

1. Abra o sistema Nexus Gestão Financeira
2. Acesse a aba "Empréstimos"
3. Edite um empréstimo qualquer
4. Altere a data de vencimento
5. Salve as alterações
6. Verifique que a data aparece em **AMARELO** com o símbolo ⚠️

## 📝 Script SQL a Executar

```sql
-- =====================================================
-- ADICIONAR CAMPO PARA RASTREAR ALTERAÇÃO MANUAL DE DATA DE VENCIMENTO
-- =====================================================

-- Adicionar o campo due_date_manually_changed
ALTER TABLE loans 
ADD COLUMN IF NOT EXISTS due_date_manually_changed BOOLEAN DEFAULT FALSE;

-- Adicionar comentário explicando o campo
COMMENT ON COLUMN loans.due_date_manually_changed IS 'Indica se a data de vencimento foi alterada manualmente (exibida em amarelo na interface)';

-- Criar índice para melhorar consultas que filtram por este campo
CREATE INDEX IF NOT EXISTS idx_loans_due_date_manually_changed 
ON loans(due_date_manually_changed);
```

## ✅ Checklist de Verificação

Após aplicar as mudanças, verifique:

- [ ] Script SQL executado sem erros
- [ ] Campo `due_date_manually_changed` existe na tabela `loans`
- [ ] Índice criado com sucesso
- [ ] Página do sistema carrega normalmente
- [ ] Ao editar empréstimo, alteração de data é detectada
- [ ] Data alterada aparece em amarelo na listagem
- [ ] Símbolo ⚠️ aparece ao lado da data alterada
- [ ] Tooltip funciona ao passar o mouse
- [ ] Mensagem de confirmação aparece ao salvar

## 🔍 Verificação do Campo no Banco

Execute no SQL Editor para confirmar:

```sql
-- Verificar se a coluna foi criada
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'loans' 
AND column_name = 'due_date_manually_changed';

-- Verificar se o índice foi criado
SELECT indexname, indexdef 
FROM pg_indexes 
WHERE tablename = 'loans' 
AND indexname = 'idx_loans_due_date_manually_changed';
```

## 🎯 Resultado Esperado

### Antes
```
Data de Vencimento
15/01/2024     (cinza, texto normal)
```

### Depois (após alteração manual)
```
Data de Vencimento
15/01/2024 ⚠️  (amarelo, negrito)
```

## 📊 Monitoramento

Para ver quantos empréstimos têm datas alteradas manualmente:

```sql
-- Total de empréstimos com data alterada
SELECT COUNT(*) as total_alterados
FROM loans
WHERE due_date_manually_changed = true;

-- Percentual de empréstimos com data alterada
SELECT 
    COUNT(CASE WHEN due_date_manually_changed = true THEN 1 END) * 100.0 / COUNT(*) as percentual
FROM loans
WHERE status != 'cancelled';
```

## ⚠️ Notas Importantes

1. **Empréstimos Existentes**: Todos os empréstimos existentes terão `due_date_manually_changed = false` por padrão
2. **Sem Impacto**: A alteração não afeta empréstimos já cadastrados
3. **Retroativo**: Apenas futuras edições de data serão marcadas como alteradas manualmente
4. **Reversível**: Se necessário, pode-se remover o campo sem impacto nos dados principais

## 🔧 Rollback (Se Necessário)

Para reverter as alterações (se houver algum problema):

```sql
-- Remover o índice
DROP INDEX IF EXISTS idx_loans_due_date_manually_changed;

-- Remover a coluna
ALTER TABLE loans DROP COLUMN IF EXISTS due_date_manually_changed;
```

## 🐛 Troubleshooting

### Erro: "column already exists"
**Causa:** Campo já foi adicionado anteriormente  
**Solução:** Não é um problema, o campo já existe. Continue com os testes.

### Erro: "permission denied"
**Causa:** Usuário sem permissões suficientes  
**Solução:** Execute como usuário com permissões de ALTER TABLE ou como superusuário do Supabase

### Data não aparece em amarelo
**Causa:** Cache do navegador ou JavaScript não atualizado  
**Solução:** 
1. Limpe o cache (Ctrl+Shift+R ou Cmd+Shift+R)
2. Feche e abra o navegador
3. Verifique o console para erros JavaScript

## 📞 Suporte

Se encontrar problemas:
1. Verifique o console do navegador (F12)
2. Verifique logs do Supabase
3. Consulte o arquivo `README-coloracao-datas-vencimento.md` para detalhes técnicos

---

**Última Atualização:** 02/12/2025  
**Versão:** 1.0  
**Status:** ✅ Pronto para Produção
