# Campo de Multa em Pagamentos - Implementação

## Resumo das Alterações

Foi implementado um campo opcional de **MULTA** na aba de empréstimos para registrar multas em pagamentos. Esta funcionalidade permite:

- Adicionar um valor de multa separado do valor principal do pagamento
- Visualizar multas nos relatórios semanais e mensais
- Acompanhar o total de multas aplicadas

## Alterações Implementadas

### 1. Banco de Dados
**Arquivo:** `add-fine-field-to-payments.sql`
- Adicionado campo `fine_amount` na tabela `payments`
- Campo do tipo `DECIMAL(10,2)` com valor padrão 0.00
- Restrição para aceitar apenas valores >= 0
- Índice criado para otimizar consultas de relatórios

### 2. Interface do Usuário

#### Formulário de Pagamento
**Arquivo:** `index.html`
- Adicionado checkbox "Incluir multa (opcional)"
- Campo de valor da multa que aparece quando checkbox é marcado
- Texto explicativo sobre o campo de multa

#### Tabelas de Visualização
- **Tabela de Pagamentos Semanais:** Nova coluna "Multa"
- **Tabela de Histórico de Pagamentos:** Nova coluna "Multa"
- **Dashboard:** Novo card "Total Multas" no resumo semanal

### 3. Funcionalidades JavaScript

#### Formulário de Pagamento (`app.js`)
- Função `handlePayment()` atualizada para processar campo de multa
- Validação e salvamento do valor da multa no banco
- Checkbox com toggle para mostrar/ocultar campo de multa

#### Visualização de Dados
- `renderWeeklyPaymentsTable()`: Exibe valor da multa em vermelho quando > 0
- `renderHistoryPaymentsTable()`: Inclui coluna de multa no histórico
- `updateWeeklyPaymentsSummary()`: Calcula e exibe total de multas

#### Edição de Pagamentos
- `editPayment()`: Carrega valor da multa existente no formulário
- Preenche automaticamente checkbox e campo quando multa > 0

### 4. Relatórios

#### Relatório Semanal
- Nova seção "MULTAS DA SEMANA" no PDF
- Exibe quantidade de multas aplicadas
- Mostra valor total em multas da semana

#### Relatório Mensal  
- Nova seção "MULTAS DO MÊS" no PDF
- Exibe quantidade de multas aplicadas
- Mostra valor total em multas do mês

## Como Usar

### Para Aplicar uma Multa:

1. **Criar Novo Pagamento:**
   - Vá para a aba de empréstimos
   - Clique em "Adicionar Pagamento" em um empréstimo
   - Preencha o valor do pagamento normalmente
   - Marque o checkbox "Incluir multa (opcional)"
   - Digite o valor da multa
   - Clique em "Registrar Pagamento"

2. **Editar Pagamento Existente:**
   - Clique no botão de editar em um pagamento
   - Se já houver multa, o checkbox estará marcado
   - Modifique o valor da multa conforme necessário
   - Salve as alterações

### Visualização de Multas:

1. **Dashboard:**
   - Card "Total Multas" mostra valor total de multas da semana

2. **Tabelas:**
   - Coluna "Multa" nas tabelas de pagamentos
   - Valores em vermelho quando multa > 0
   - Traço (-) quando não há multa

3. **Relatórios:**
   - Seção específica sobre multas nos PDFs semanais e mensais
   - Quantidade e valor total das multas

## Características Técnicas

- **Separação de Valores:** A multa é um campo separado, não afeta o valor principal do pagamento
- **Opcional:** Campo só aparece quando checkbox é marcado
- **Validação:** Aceita apenas valores >= 0
- **Retrocompatibilidade:** Pagamentos existentes não são afetados
- **Performance:** Índice otimizado para consultas de relatórios

## Instalação

1. Execute o script SQL no Supabase:
   ```sql
   -- Executar o conteúdo do arquivo add-fine-field-to-payments.sql
   ```

2. As alterações no frontend já estão implementadas nos arquivos:
   - `index.html`
   - `app.js`

## Exemplos de Consultas SQL

```sql
-- Total de multas por semana
SELECT 
    DATE_TRUNC('week', payment_date) as semana,
    SUM(fine_amount) as total_multas_semana,
    COUNT(*) FILTER (WHERE fine_amount > 0) as quantidade_multas
FROM payments 
WHERE fine_amount > 0 
GROUP BY DATE_TRUNC('week', payment_date)
ORDER BY semana DESC;

-- Total de multas por mês
SELECT 
    DATE_TRUNC('month', payment_date) as mes,
    SUM(fine_amount) as total_multas_mes,
    COUNT(*) FILTER (WHERE fine_amount > 0) as quantidade_multas
FROM payments 
WHERE fine_amount > 0 
GROUP BY DATE_TRUNC('month', payment_date)
ORDER BY mes DESC;
```