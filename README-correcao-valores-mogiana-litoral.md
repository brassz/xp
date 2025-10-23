# Correção dos Valores Restantes - MOGIANA e LITORAL

## Problema Identificado

Os valores restantes dos empréstimos sumiram nas empresas **MOGIANA CRED** e **LITORAL CRED**. Este problema pode ter várias causas:

### Possíveis Causas

1. **Campo `original_amount` ausente**: O campo que preserva o valor original do empréstimo pode não existir
2. **Triggers desatualizados**: Os triggers automáticos podem estar usando lógica incorreta
3. **Valores zerados**: Os valores dos empréstimos podem ter sido zerados por algum processo
4. **Tabelas de status inconsistentes**: As tabelas `overdue_loans` e `partial_paid_loans` podem ter dados incorretos

## Solução Implementada

### 1. Scripts de Diagnóstico e Correção

#### `diagnose-mogiana-litoral-issues.sql`
- **Função**: Diagnosticar problemas específicos
- **Verifica**: Estrutura das tabelas, campos críticos, empréstimos problemáticos
- **Gera**: Relatório detalhado dos problemas encontrados

#### `fix-missing-loan-remaining-values.sql`
- **Função**: Corrigir os problemas identificados
- **Ações**: Adiciona campo `original_amount`, recalcula valores, atualiza triggers
- **Resultado**: Restaura valores restantes dos empréstimos

### 2. Processo de Correção

#### Passo 1: Diagnóstico
```sql
-- Execute primeiro o diagnóstico em cada empresa
-- MOGIANA: https://eemfnpefgojllvzzaimu.supabase.co
-- LITORAL: https://dtifsfzmnjnllzzlndxv.supabase.co
```

#### Passo 2: Aplicar Correção
```sql
-- Execute o script de correção em cada empresa
-- O script é seguro e pode ser executado múltiplas vezes
```

#### Passo 3: Verificação
```sql
-- Verifique os relatórios gerados
-- Teste a interface para confirmar que os valores aparecem
```

## Detalhes Técnicos

### Problema Principal: Campo `original_amount`

O sistema Nexus usa dois campos para valores de empréstimos:
- `amount`: Valor atual (pode ser reduzido por pagamentos)
- `original_amount`: Valor original (NUNCA deve ser alterado)

**Problema**: Se o campo `original_amount` não existe ou está vazio, o sistema perde a referência do valor original.

### Cálculo Correto dos Valores Restantes

```sql
-- Lógica correta para calcular valor restante
valor_original = original_amount (ou amount se original_amount for NULL)
juros_originais = valor_original * (interest_rate / 100)
total_com_juros = valor_original + juros_originais
total_pago = SUM(payments.amount)
valor_restante = MAX(0, total_com_juros - total_pago)
```

### Triggers Atualizados

Os triggers foram atualizados para:
1. Sempre usar `original_amount` como base
2. Calcular valores restantes corretamente
3. Atualizar tabelas de status com dados precisos

## Empresas Afetadas

### MOGIANA CRED
- **URL Supabase**: `https://eemfnpefgojllvzzaimu.supabase.co`
- **Status**: Requer correção
- **Ação**: Execute ambos os scripts

### LITORAL CRED
- **URL Supabase**: `https://dtifsfzmnjnllzzlndxv.supabase.co`
- **Status**: Requer correção
- **Ação**: Execute ambos os scripts

### NEXUS (Principal)
- **URL Supabase**: `https://mhtxyxizfnxupwmilith.supabase.co`
- **Status**: Funcionando corretamente
- **Ação**: Não requer correção (já tem as correções aplicadas)

## Instruções de Execução

### 1. Acesso ao Supabase

Para cada empresa, acesse:
1. Painel do Supabase da empresa
2. Vá em **SQL Editor**
3. Cole o conteúdo do script
4. Clique em **Run**

### 2. Ordem de Execução

```bash
# 1. Primeiro, execute o diagnóstico
diagnose-mogiana-litoral-issues.sql

# 2. Analise os resultados do diagnóstico

# 3. Execute a correção
fix-missing-loan-remaining-values.sql

# 4. Execute novamente o diagnóstico para confirmar
diagnose-mogiana-litoral-issues.sql
```

### 3. Verificação na Interface

Após executar os scripts:
1. Acesse a aplicação Nexus
2. Selecione a empresa corrigida
3. Vá na aba **Empréstimos**
4. Verifique se os valores restantes aparecem corretamente
5. Teste criar um novo empréstimo
6. Teste fazer um pagamento

## Resultados Esperados

### ✅ Após a Correção

- **Valores Restantes**: Aparecem corretamente na interface
- **Novos Empréstimos**: Funcionam normalmente
- **Pagamentos**: Calculam valores restantes corretamente
- **Relatórios**: Mostram dados precisos

### 📊 Métricas de Sucesso

- Empréstimos com `amount = 0`: **0**
- Empréstimos sem `original_amount`: **0**
- Tabelas de status com `remaining_amount = 0` (incorretamente): **0**
- Interface mostrando valores restantes: **✅**

## Monitoramento Pós-Correção

### 1. Verificações Regulares

Execute periodicamente:
```sql
-- Verificar se não há regressão
SELECT COUNT(*) FROM loans WHERE amount = 0 AND status IN ('active', 'overdue');
```

### 2. Logs de Aplicação

Monitore logs para:
- Erros de cálculo de valores restantes
- Problemas com triggers
- Inconsistências em pagamentos

### 3. Testes de Interface

Teste regularmente:
- Criação de novos empréstimos
- Registro de pagamentos
- Visualização de valores restantes
- Geração de relatórios

## Prevenção de Problemas Futuros

### 1. Backup Regular

- Configure backups automáticos no Supabase
- Mantenha backups antes de grandes alterações

### 2. Validação de Dados

- Implemente validações no frontend
- Adicione constraints no banco de dados
- Monitore integridade dos dados

### 3. Documentação

- Mantenha documentação atualizada
- Registre todas as alterações
- Treine equipe sobre o sistema

## Suporte

Em caso de problemas:

1. **Verifique os logs** do Supabase
2. **Execute novamente** o diagnóstico
3. **Documente** qualquer erro encontrado
4. **Mantenha backup** antes de correções

## Arquivos Relacionados

- `diagnose-mogiana-litoral-issues.sql` - Script de diagnóstico
- `fix-missing-loan-remaining-values.sql` - Script de correção
- `fix-loan-original-amount-preservation.sql` - Correção original do sistema
- `README-correcao-valores-originais.md` - Documentação da correção original

---

**Data da Correção**: 2024-10-23  
**Status**: Pronto para execução  
**Empresas Afetadas**: MOGIANA CRED, LITORAL CRED  
**Impacto**: Restauração completa dos valores restantes dos empréstimos