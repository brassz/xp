# Guia de Instalação - Sistema de Multas de Clientes

## Passo a Passo para Ativar o Sistema

### 1. Criar a Tabela no Banco de Dados

Execute o script SQL no console do Supabase:

```bash
# No console SQL do Supabase, execute o conteúdo do arquivo:
setup-client-fines-table.sql
```

**Verificação:**
```sql
-- Confirme que a tabela foi criada
SELECT * FROM client_fines LIMIT 1;

-- Verifique os índices
SELECT indexname FROM pg_indexes WHERE tablename = 'client_fines';
```

### 2. Atualizar os Arquivos da Aplicação

Os seguintes arquivos já foram modificados:

✅ `index.html` - Modal e interface adicionados
✅ `app.js` - Funções JavaScript implementadas

### 3. Limpar Cache do Navegador

Para garantir que as mudanças sejam carregadas:

1. Abra o DevTools (F12)
2. Clique com botão direito no ícone de reload
3. Selecione "Hard Reload" ou "Empty Cache and Hard Reload"

Ou use: `Ctrl + Shift + R` (Windows/Linux) ou `Cmd + Shift + R` (Mac)

### 4. Testar a Funcionalidade

#### Teste 1: Adicionar Multa

1. Faça login no sistema
2. Vá para a aba **Empréstimos**
3. Localize qualquer empréstimo ativo
4. Clique no botão ⚠️ (último botão antes da lixeira)
5. Preencha:
   - Valor: 50.00
   - Descrição: "Teste de multa - documento pendente"
6. Clique em "Adicionar Multa"
7. Aguarde mensagem de sucesso

**Resultado Esperado:** 
- Modal fecha automaticamente
- Mensagem: "Multa de R$ 50.00 adicionada ao cliente [NOME] com sucesso!"

#### Teste 2: Visualizar no Histórico

1. Vá para a aba **Histórico**
2. Selecione o mesmo cliente do teste anterior
3. Clique em "Carregar Histórico"
4. Verifique:
   - Card "Total em Multas" mostra R$ 50,00
   - Tabela "Histórico de Multas" mostra a multa criada
   - Data, valor, descrição e usuário aparecem corretamente

**Resultado Esperado:**
- Total de multas atualizado
- Tabela mostra 1 registro com todos os dados

#### Teste 3: Múltiplas Multas

1. Adicione mais 2-3 multas para o mesmo cliente
2. Recarregue o histórico
3. Verifique:
   - Total de multas soma corretamente
   - Todas as multas aparecem na tabela
   - Ordenadas por data (mais recente primeiro)

### 5. Verificar Integridade dos Dados

Execute no console SQL do Supabase:

```sql
-- Verificar multas criadas
SELECT 
    cf.id,
    cf.fine_amount,
    cf.description,
    cf.fine_date,
    c.name as cliente,
    u.name as aplicado_por
FROM client_fines cf
JOIN clients c ON c.id = cf.client_id
LEFT JOIN users u ON u.id = cf.created_by
ORDER BY cf.fine_date DESC
LIMIT 10;

-- Verificar total por cliente
SELECT 
    c.name as cliente,
    COUNT(*) as qtd_multas,
    SUM(cf.fine_amount) as total_multas
FROM client_fines cf
JOIN clients c ON c.id = cf.client_id
GROUP BY c.id, c.name
ORDER BY total_multas DESC;
```

## Solução de Problemas Comuns

### Erro: "Tabela client_fines não existe"

**Solução:** Execute o script `setup-client-fines-table.sql` no Supabase

### Erro: "Permission denied for table client_fines"

**Solução:** Configure as políticas RLS (Row Level Security) no Supabase:

```sql
-- Habilitar RLS
ALTER TABLE client_fines ENABLE ROW LEVEL SECURITY;

-- Política de leitura
CREATE POLICY "Users can view fines from their company"
ON client_fines FOR SELECT
USING (company_id = auth.jwt()->>'company_id');

-- Política de inserção
CREATE POLICY "Users can insert fines for their company"
ON client_fines FOR INSERT
WITH CHECK (company_id = auth.jwt()->>'company_id');
```

### Botão ⚠️ não aparece

**Soluções:**
1. Limpe o cache do navegador (Ctrl + Shift + R)
2. Verifique se o arquivo `app.js` foi atualizado corretamente
3. Verifique o console do navegador por erros JavaScript

### Modal não abre

**Soluções:**
1. Verifique se o `index.html` foi atualizado
2. Abra o console (F12) e procure por erros
3. Verifique se a função `openAddClientFineModal` existe

### Multas não aparecem no histórico

**Soluções:**
1. Verifique se o `company_id` está correto
2. Confirme que o cliente tem multas no banco:
   ```sql
   SELECT * FROM client_fines WHERE client_id = 'CLIENT_ID';
   ```
3. Limpe o cache e recarregue a página

## Rollback (Desfazer Instalação)

Se precisar remover o sistema de multas:

```sql
-- 1. Fazer backup dos dados (opcional)
CREATE TABLE client_fines_backup AS SELECT * FROM client_fines;

-- 2. Remover a tabela
DROP TABLE IF EXISTS client_fines CASCADE;

-- 3. Remover a função de trigger
DROP FUNCTION IF EXISTS update_client_fines_updated_at() CASCADE;
```

Depois, reverter as mudanças em `index.html` e `app.js` usando git:

```bash
git checkout HEAD -- index.html app.js
```

## Suporte

Para problemas ou dúvidas:
1. Verifique este guia primeiro
2. Consulte `README-sistema-multas-clientes.md` para documentação completa
3. Verifique os logs do console do navegador
4. Verifique os logs do Supabase

## Checklist de Instalação

- [ ] Script SQL executado no Supabase
- [ ] Tabela `client_fines` criada com sucesso
- [ ] Índices criados corretamente
- [ ] Arquivos `index.html` e `app.js` atualizados
- [ ] Cache do navegador limpo
- [ ] Teste 1: Adicionar multa - OK
- [ ] Teste 2: Visualizar no histórico - OK
- [ ] Teste 3: Múltiplas multas - OK
- [ ] Verificação de integridade de dados - OK
- [ ] Políticas RLS configuradas (se necessário)

## Status: Instalação Completa ✅

Sistema pronto para uso em produção!
