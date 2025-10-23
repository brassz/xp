# Sistema de Comissões - NEXUS

## Visão Geral

O Sistema de Comissões foi implementado para calcular automaticamente as comissões baseadas nos valores de juros de empréstimos e parcelamentos. O sistema é totalmente integrado ao banco de dados existente e aos relatórios do NEXUS.

## Características Principais

### ✅ Cálculo Automático
- Comissões são calculadas automaticamente quando empréstimos ou parcelamentos são criados
- Base de cálculo: **valor dos juros** (não o valor principal)
- Taxas de comissão configuráveis por tipo de operação

### ✅ Flexibilidade
- Diferentes taxas de comissão para empréstimos e parcelamentos
- Configurações ativas/inativas
- Suporte a múltiplas configurações de comissão

### ✅ Relatórios Integrados
- Relatórios semanais e mensais incluem dados de comissões
- Relatório específico só de comissões
- Análise por usuário e tipo de operação

### ✅ Controle de Status
- Comissões pendentes e pagas
- Histórico de pagamentos
- Interface para gerenciamento

## Estrutura do Banco de Dados

### Tabelas Criadas

#### 1. `commission_settings`
Configurações de taxas de comissão:
```sql
- id: UUID (chave primária)
- name: TEXT (nome da configuração)
- description: TEXT (descrição)
- commission_rate: DECIMAL(5,2) (taxa de comissão em %)
- applies_to: TEXT[] (tipos: loans, installments, capital_raising)
- is_active: BOOLEAN (ativo/inativo)
```

#### 2. `commissions`
Comissões calculadas:
```sql
- id: UUID (chave primária)
- reference_id: UUID (ID do empréstimo/parcelamento)
- reference_type: TEXT (loan, installment, capital_raising)
- client_id: UUID (cliente)
- user_id: UUID (usuário responsável)
- principal_amount: DECIMAL(15,2) (valor principal)
- interest_rate: DECIMAL(5,2) (taxa de juros)
- interest_amount: DECIMAL(15,2) (valor dos juros)
- commission_rate: DECIMAL(5,2) (taxa de comissão aplicada)
- commission_amount: DECIMAL(15,2) (valor da comissão)
- status: TEXT (pending, paid, cancelled)
```

#### 3. `commission_payments`
Histórico de pagamentos de comissões:
```sql
- id: UUID (chave primária)
- commission_id: UUID (referência à comissão)
- amount: DECIMAL(15,2) (valor pago)
- payment_date: DATE (data do pagamento)
- payment_method: TEXT (forma de pagamento)
```

### Views Criadas

#### 1. `commissions_with_details`
Comissões com informações completas de clientes e usuários.

#### 2. `commission_summary_by_period`
Resumo de comissões agrupadas por período e tipo.

#### 3. `pending_commissions`
Comissões pendentes de pagamento.

## Como Funciona

### Cálculo Automático

1. **Empréstimos**: Quando um empréstimo é criado/atualizado:
   ```
   Valor dos Juros = Valor Principal × Taxa de Juros ÷ 100
   Comissão = Valor dos Juros × Taxa de Comissão ÷ 100
   ```

2. **Parcelamentos**: Quando um parcelamento é criado/atualizado:
   ```
   Valor dos Juros = Valor Total × Taxa de Juros ÷ 100
   Comissão = Valor dos Juros × Taxa de Comissão ÷ 100
   ```

### Exemplo Prático

**Empréstimo:**
- Valor Principal: R$ 10.000,00
- Taxa de Juros: 5%
- Taxa de Comissão: 10%

**Cálculo:**
- Valor dos Juros: R$ 10.000 × 5% = R$ 500,00
- Comissão: R$ 500 × 10% = R$ 50,00

## Configurações Padrão

O sistema vem com 3 configurações pré-definidas:

1. **Comissão Padrão Empréstimos**: 10% sobre os juros
2. **Comissão Padrão Parcelamentos**: 8% sobre os juros  
3. **Comissão Geral**: 5% sobre os juros (todos os tipos)

## Relatórios

### Relatório Semanal com Comissões
- Resumo de empréstimos da semana
- Total de comissões geradas
- Comissões por usuário
- Detalhes de cada comissão

### Relatório Mensal com Comissões
- Resumo completo do mês
- Ranking de usuários por comissão
- Análise de performance
- Percentual de comissão sobre juros

### Relatório Específico de Comissões
- Foco exclusivo em comissões
- Análise por tipo de operação
- Resumo por usuário
- Período personalizável

## Funções SQL Disponíveis

### `calculate_loan_commission(loan_id, commission_setting_id)`
Calcula comissão para um empréstimo específico.

### `calculate_installment_commission(installment_id, commission_setting_id)`
Calcula comissão para um parcelamento específico.

### `generate_commission_report(start_date, end_date, user_filter, reference_type_filter)`
Gera relatório de comissões por período com filtros opcionais.

## Triggers Automáticos

- **`trigger_auto_calculate_loan_commission`**: Calcula comissão automaticamente ao criar/atualizar empréstimos
- **`trigger_auto_calculate_installment_commission`**: Calcula comissão automaticamente ao criar/atualizar parcelamentos

## Interface JavaScript

### Funções Principais

- `generateWeeklyReportWithCommissions()`: Gera relatório semanal
- `generateMonthlyReportWithCommissions()`: Gera relatório mensal
- `generateCommissionOnlyReport(startDate, endDate)`: Gera relatório só de comissões
- `loadPendingCommissions()`: Carrega comissões pendentes
- `markCommissionAsPaid(commissionId)`: Marca comissão como paga

## Instalação

### 1. Executar Script SQL
```bash
# Execute o arquivo setup-commission-system.sql no Supabase
```

### 2. Integrar JavaScript
```javascript
// Inclua o arquivo commission-reports-integration.js no app.js
// ou carregue-o separadamente
```

### 3. Verificar Configurações
```sql
-- Verificar se as configurações foram criadas
SELECT * FROM commission_settings WHERE is_active = true;

-- Verificar se os triggers estão ativos
SELECT * FROM information_schema.triggers 
WHERE trigger_name LIKE '%commission%';
```

## Segurança

### Políticas RLS (Row Level Security)
- Usuários só veem suas próprias comissões
- Administradores e gerentes veem todas as comissões
- Configurações só podem ser alteradas por administradores

### Validações
- Taxas de comissão entre 0% e 100%
- Valores sempre positivos
- Referências válidas para empréstimos/parcelamentos

## Monitoramento

### Queries Úteis

```sql
-- Comissões pendentes
SELECT COUNT(*), SUM(commission_amount) 
FROM commissions 
WHERE status = 'pending';

-- Comissões por usuário (mês atual)
SELECT u.full_name, COUNT(*), SUM(c.commission_amount)
FROM commissions c
JOIN users u ON c.user_id = u.id
WHERE EXTRACT(MONTH FROM c.operation_date) = EXTRACT(MONTH FROM CURRENT_DATE)
GROUP BY u.full_name
ORDER BY SUM(c.commission_amount) DESC;

-- Performance por tipo de operação
SELECT reference_type, 
       COUNT(*), 
       SUM(commission_amount),
       AVG(commission_rate)
FROM commissions 
WHERE operation_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY reference_type;
```

## Manutenção

### Limpeza de Dados Antigos
```sql
-- Remover comissões canceladas antigas (opcional)
DELETE FROM commissions 
WHERE status = 'cancelled' 
AND created_at < CURRENT_DATE - INTERVAL '1 year';
```

### Recalcular Comissões
```sql
-- Recalcular todas as comissões de empréstimos ativos
SELECT calculate_loan_commission(id) FROM loans WHERE status IN ('active', 'overdue', 'partial_paid');

-- Recalcular todas as comissões de parcelamentos ativos
SELECT calculate_installment_commission(id) FROM installments WHERE status = 'active';
```

## Troubleshooting

### Problema: Comissões não estão sendo calculadas
**Solução:**
1. Verificar se os triggers estão ativos
2. Verificar se existe configuração ativa para o tipo de operação
3. Verificar logs de erro no Supabase

### Problema: Valores de comissão incorretos
**Solução:**
1. Verificar taxa de comissão na configuração
2. Verificar se o cálculo de juros está correto
3. Recalcular manualmente usando as funções SQL

### Problema: Relatórios não mostram comissões
**Solução:**
1. Verificar se o JavaScript foi carregado corretamente
2. Verificar permissões de acesso às views
3. Verificar se existem dados no período selecionado

## Próximas Melhorias

- [ ] Dashboard visual de comissões
- [ ] Notificações automáticas para comissões pendentes
- [ ] Integração com sistema de pagamentos
- [ ] Relatórios em Excel/CSV
- [ ] API REST para integração externa

---

**Desenvolvido para NEXUS Gestão Financeira**
*Sistema implementado em: Janeiro 2025*