# Implementação de Campo de Multa nos Pagamentos

## Resumo das Alterações

Foi implementado um novo campo opcional de **multa** no sistema de registro de pagamentos de empréstimos. Esta funcionalidade permite aplicar valores de multa aos pagamentos e exibir essas informações nos relatórios.

## Alterações Implementadas

### 1. Banco de Dados
- **Arquivo**: `add-fine-field-to-payments.sql`
- **Alterações**:
  - Adicionado campo `fine_amount` na tabela `payments`
  - Adicionado campo `fine_amount` na tabela `installment_payments`
  - Campos com valor padrão 0.00 e constraint para valores >= 0

### 2. Interface do Usuário (HTML)
- **Arquivo**: `index.html`
- **Alterações**:
  - Adicionado checkbox "Aplicar multa (opcional)" no formulário de pagamento
  - Adicionado campo de input para valor da multa (aparece quando checkbox marcado)
  - Adicionada seção de "Total de Multas" nos relatórios semanais

### 3. Lógica JavaScript (Backend)
- **Arquivo**: `app.js`
- **Alterações**:
  - Adicionado controle do checkbox de multa (mostrar/ocultar campo)
  - Atualizada função `handlePayment()` para capturar valor da multa
  - Atualizada inserção/edição de pagamentos para incluir `fine_amount`
  - Atualizada função `editPayment()` para carregar valor da multa existente
  - Atualizada limpeza do formulário para incluir campos de multa
  - Atualizada renderização da tabela de pagamentos semanais para mostrar multas
  - Atualizada função `updateWeeklyPaymentsSummary()` para calcular total de multas
  - Atualizada função `generateWeeklyPaymentsPDFForDates()` para incluir multas no PDF

## Como Usar

### Registrar Pagamento com Multa
1. Acesse a aba de empréstimos
2. Clique em "Registrar Pagamento" em um empréstimo
3. Preencha o valor do pagamento normalmente
4. Marque a checkbox "Aplicar multa (opcional)"
5. Digite o valor da multa no campo que aparece
6. Complete o registro do pagamento

### Visualizar Multas nos Relatórios
- **Relatório Semanal**: As multas aparecem como uma linha adicional abaixo do valor do pagamento
- **Resumo Semanal**: Mostra o total de multas da semana (apenas se houver multas > 0)
- **PDF Semanal**: Inclui o total de multas no resumo do PDF

## Campos Adicionados

### Banco de Dados
```sql
-- Tabela payments
fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0)

-- Tabela installment_payments  
fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0)
```

### Interface
- Checkbox: `fineCheckbox`
- Container: `fineContainer` 
- Input: `fineAmount`
- Display total: `totalFinesAmount`

## Validações
- Valor da multa deve ser >= 0
- Campo é opcional (padrão 0.00)
- Multa é salva separadamente do valor do pagamento
- Relatórios só mostram seção de multas se houver valores > 0

## Compatibilidade
- Totalmente compatível com pagamentos existentes (campo padrão 0.00)
- Não afeta cálculos existentes de juros e capital
- Funciona tanto para empréstimos quanto para parcelamentos

## Arquivos Modificados
1. `add-fine-field-to-payments.sql` - Script de migração do banco
2. `index.html` - Interface do usuário
3. `app.js` - Lógica de negócio e relatórios

## Próximos Passos
1. Executar o script SQL no banco de dados
2. Testar a funcionalidade em ambiente de desenvolvimento
3. Validar os relatórios com dados de multa
4. Deploy em produção