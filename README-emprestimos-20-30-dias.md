# Sistema de Empréstimos com Vencimento em 20 ou 30 Dias

## Resumo das Alterações

Foi implementado um sistema que permite criar empréstimos com vencimento em 20 ou 30 dias, além de opções de renovação para ambos os períodos.

## Mudanças Implementadas

### 1. Banco de Dados

- **Arquivo**: `add-term-days-field.sql`
- **Campo adicionado**: `term_days` na tabela `loans`
- **Valores permitidos**: 20 ou 30 (padrão: 30)
- **Descrição**: Armazena o período de vencimento do empréstimo

**Para aplicar a mudança no banco de dados:**
```sql
-- Execute o arquivo add-term-days-field.sql no Supabase SQL Editor
```

### 2. Formulário de Criação de Empréstimo

**Mudanças no HTML (`index.html`):**
- Adicionado seletor "Período de Vencimento" com opções de 20 ou 30 dias
- Campo "Data de Vencimento" agora é calculado automaticamente e somente leitura
- A data de vencimento é calculada automaticamente baseada na data do empréstimo + período escolhido

**Funcionalidades:**
- Ao selecionar o período (20 ou 30 dias), a data de vencimento é calculada automaticamente
- Ao alterar a data do empréstimo, a data de vencimento é recalculada automaticamente

### 3. Modal de Pagamento

**Novo botão adicionado:**
- **"RENOVAR 20+"**: Botão laranja/vermelho para renovação de 20 dias
- **"RENOVAR 30+"**: Botão roxo/rosa para renovação de 30 dias (já existia)

**Localização**: Ambos os botões aparecem no modal de pagamento, permitindo escolher o período de renovação desejado.

### 4. Modal de Renovação 20 Dias

**Novo modal criado:**
- Modal similar ao de renovação de 30 dias, mas para 20 dias
- Opções disponíveis:
  - Capital + Juros
  - Somente Juros
  - Somente Capital

### 5. Funções JavaScript

**Novas funções adicionadas:**
- `calculateLoanDueDate()`: Calcula automaticamente a data de vencimento baseado no período escolhido
- `calculateNextDueDateByTermDays()`: Calcula próxima data de vencimento baseado no term_days
- `openRenewalOptionsModal20()`: Abre o modal de renovação de 20 dias
- `handleNewRenewalPayment()`: Modificada para aceitar o parâmetro `renewalDays` (20 ou 30)

**Funções modificadas:**
- `setDefaultDates()`: Agora chama `calculateLoanDueDate()` para calcular a data de vencimento
- `handleNewLoan()`: Agora salva o campo `term_days` no banco de dados

## Como Usar

### Criar um Novo Empréstimo

1. Clique em "Novo Empréstimo"
2. Preencha os dados do empréstimo
3. **Selecione o período de vencimento:**
   - **30 dias**: Vencimento padrão (30 dias após a data do empréstimo)
   - **20 dias**: Vencimento em 20 dias após a data do empréstimo
4. A data de vencimento será calculada automaticamente
5. Clique em "Criar Empréstimo"

### Renovar um Empréstimo

1. Abra o modal de pagamento do empréstimo
2. Preencha o valor do pagamento
3. Escolha o tipo de renovação:
   - **RENOVAR 20+**: Renova o empréstimo por mais 20 dias
   - **RENOVAR 30+**: Renova o empréstimo por mais 30 dias
4. Selecione o tipo de pagamento (Capital + Juros, Somente Juros, ou Somente Capital)
5. Confirme a renovação

## Observações Importantes

1. **Empréstimos existentes**: Empréstimos criados antes desta atualização terão `term_days = 30` por padrão
2. **Renovação flexível**: Você pode renovar um empréstimo de 30 dias por 20 dias, ou vice-versa
3. **Cálculo automático**: A data de vencimento é sempre calculada automaticamente baseada no período escolhido
4. **Compatibilidade**: O sistema mantém compatibilidade com empréstimos antigos que não possuem o campo `term_days`

## Arquivos Modificados

- `index.html`: Adicionado seletor de período e botão de renovação 20+
- `app.js`: Adicionadas funções para cálculo de datas e renovação de 20 dias
- `add-term-days-field.sql`: Script SQL para adicionar campo no banco de dados

## Próximos Passos

1. Execute o script SQL `add-term-days-field.sql` no Supabase
2. Teste a criação de empréstimos com ambos os períodos (20 e 30 dias)
3. Teste as renovações de 20 e 30 dias
4. Verifique se os empréstimos existentes continuam funcionando corretamente

