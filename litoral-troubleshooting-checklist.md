# Checklist de Troubleshooting - LITORAL

## Problema
A empresa MOGIANA está funcionando após a correção, mas a LITORAL ainda não está exibindo os valores restantes dos empréstimos.

## 🔍 Checklist de Verificação

### 1. Verificação de Banco de Dados
- [ ] **Confirmar URL correta da LITORAL**: `https://dtifsfzmnjnllzzlndxv.supabase.co`
- [ ] **Verificar se está acessando o banco correto** no Supabase
- [ ] **Confirmar credenciais** no painel do Supabase
- [ ] **Testar conexão** com o banco de dados

### 2. Verificação de Scripts Executados
- [ ] **Executar diagnóstico**: `compare-mogiana-litoral-config.sql`
- [ ] **Aplicar correção específica**: `fix-litoral-specific-issues.sql`
- [ ] **Verificar se os scripts executaram sem erro**
- [ ] **Confirmar que as tabelas foram atualizadas**

### 3. Verificação da Aplicação
- [ ] **Limpar cache do navegador** (Ctrl+Shift+Delete)
- [ ] **Testar em aba privada/incógnita**
- [ ] **Testar em navegador diferente**
- [ ] **Verificar console do navegador** (F12) por erros JavaScript

### 4. Verificação de Configuração no Código
- [ ] **Confirmar configuração da LITORAL** em `app.js`:
  ```javascript
  litoral: {
      name: 'LITORAL CRED',
      supabase: {
          url: 'https://dtifsfzmnjnllzzlndxv.supabase.co',
          key: 'sua_chave_aqui'
      }
  }
  ```
- [ ] **Verificar se a chave da API está correta**
- [ ] **Confirmar que não há cache de configuração antiga**

### 5. Verificação de Dados
- [ ] **Verificar se há empréstimos na LITORAL**:
  ```sql
  SELECT COUNT(*) FROM loans WHERE status IN ('active', 'overdue', 'partial_paid');
  ```
- [ ] **Verificar se o campo `original_amount` existe e tem dados**:
  ```sql
  SELECT COUNT(*) FROM loans WHERE original_amount IS NOT NULL AND original_amount > 0;
  ```
- [ ] **Verificar tabelas de status**:
  ```sql
  SELECT COUNT(*) FROM overdue_loans WHERE remaining_amount > 0;
  SELECT COUNT(*) FROM partial_paid_loans WHERE remaining_amount > 0;
  ```

## 🔧 Scripts de Correção

### Script 1: Diagnóstico Completo
```bash
# Execute na LITORAL para identificar problemas
compare-mogiana-litoral-config.sql
```

### Script 2: Correção Específica
```bash
# Execute na LITORAL para aplicar correções
fix-litoral-specific-issues.sql
```

### Script 3: Verificação Final
```bash
# Execute para confirmar que a correção funcionou
diagnose-mogiana-litoral-issues.sql
```

## 🚨 Problemas Comuns e Soluções

### Problema 1: Campo `original_amount` não existe
**Sintoma**: Erro ao executar queries ou valores sempre zero
**Solução**:
```sql
ALTER TABLE loans ADD COLUMN IF NOT EXISTS original_amount DECIMAL(10,2);
UPDATE loans SET original_amount = amount WHERE original_amount IS NULL;
ALTER TABLE loans ALTER COLUMN original_amount SET NOT NULL;
```

### Problema 2: Triggers desatualizados
**Sintoma**: Tabelas de status não são atualizadas
**Solução**: Execute a seção de triggers do script `fix-litoral-specific-issues.sql`

### Problema 3: Cache do navegador
**Sintoma**: Interface não mostra mudanças mesmo com banco correto
**Solução**: 
- Ctrl+Shift+Delete (limpar cache)
- Testar em aba privada
- Testar em navegador diferente

### Problema 4: Configuração incorreta no código
**Sintoma**: Aplicação conecta no banco errado
**Solução**: Verificar configuração em `app.js` e variáveis de ambiente

### Problema 5: Dados corrompidos
**Sintoma**: Empréstimos com valores zerados
**Solução**: Execute a função `recalculate_remaining_amounts()` do script de correção

## 📋 Passos Detalhados de Correção

### Passo 1: Diagnóstico
1. Acesse o Supabase da LITORAL: `https://dtifsfzmnjnllzzlndxv.supabase.co`
2. Vá em **SQL Editor**
3. Execute `compare-mogiana-litoral-config.sql`
4. Anote os problemas encontrados

### Passo 2: Correção
1. No mesmo SQL Editor
2. Execute `fix-litoral-specific-issues.sql`
3. Aguarde todas as mensagens de sucesso
4. Verifique se não há erros

### Passo 3: Verificação
1. Execute novamente `compare-mogiana-litoral-config.sql`
2. Confirme que os problemas foram resolvidos
3. Teste a interface da aplicação

### Passo 4: Teste na Interface
1. Limpe o cache do navegador
2. Acesse a aplicação Nexus
3. Selecione "LITORAL CRED"
4. Faça login
5. Vá na aba **Empréstimos**
6. Verifique se os valores restantes aparecem

## 🔄 Se Ainda Não Funcionar

### Verificação Avançada
1. **Compare estruturas**:
   - Execute o script de comparação na MOGIANA
   - Execute o mesmo script na LITORAL
   - Compare os resultados lado a lado

2. **Verifique logs de erro**:
   - Console do navegador (F12)
   - Logs do Supabase
   - Mensagens de erro na aplicação

3. **Teste com dados novos**:
   - Crie um novo empréstimo na LITORAL
   - Faça um pagamento parcial
   - Verifique se o valor restante aparece

### Escalação do Problema
Se após todos os passos o problema persistir:

1. **Documente exatamente**:
   - Quais scripts foram executados
   - Quais erros apareceram
   - Diferenças encontradas entre MOGIANA e LITORAL

2. **Colete evidências**:
   - Screenshots da interface
   - Resultados dos scripts SQL
   - Logs de erro completos

3. **Considere recriação**:
   - Como último recurso, pode ser necessário recriar a estrutura da LITORAL
   - Usando a MOGIANA como modelo

## ✅ Critérios de Sucesso

A correção será considerada bem-sucedida quando:

- [ ] Scripts SQL executam sem erro
- [ ] Campo `original_amount` existe e tem dados
- [ ] Tabelas de status têm registros com `remaining_amount > 0`
- [ ] Interface mostra valores restantes dos empréstimos
- [ ] Novos empréstimos funcionam corretamente
- [ ] Pagamentos calculam valores restantes corretamente
- [ ] Comportamento idêntico entre MOGIANA e LITORAL

## 📞 Próximos Passos

1. Execute o checklist na ordem
2. Documente os resultados de cada passo
3. Aplique as correções necessárias
4. Teste thoroughly na interface
5. Compare com MOGIANA para confirmar funcionamento idêntico