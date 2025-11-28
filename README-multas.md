# Sistema de Multas - Nexus Gestão Financeira

## 📋 Visão Geral

Este módulo implementa um sistema completo de gestão de multas que se integra perfeitamente ao histórico de pagamentos dos clientes. As multas aparecem automaticamente no histórico de pagamentos junto com pagamentos regulares e parcelas.

## 🚀 Instalação

Execute o script SQL no SQL Editor do Supabase:

```bash
setup-fines-table.sql
```

## 📊 Estrutura da Tabela de Multas

### Tabela: `fines`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador único da multa |
| `client_id` | UUID | Referência ao cliente (obrigatório) |
| `loan_id` | UUID | Referência ao empréstimo (opcional) |
| `installment_payment_id` | UUID | Referência à parcela (opcional) |
| `amount` | DECIMAL(10,2) | Valor da multa |
| `reason` | TEXT | Motivo da multa |
| `fine_type` | TEXT | Tipo de multa (late_payment, breach_of_contract, administrative, other) |
| `fine_date` | DATE | Data de aplicação da multa |
| `due_date` | DATE | Data de vencimento da multa |
| `paid_date` | DATE | Data de pagamento (quando paga) |
| `paid_amount` | DECIMAL(10,2) | Valor pago |
| `status` | TEXT | Status (pending, paid, partial_paid, cancelled) |
| `payment_method` | TEXT | Método de pagamento utilizado |
| `notes` | TEXT | Observações |
| `created_by` | UUID | Usuário que criou |
| `created_at` | TIMESTAMP | Data de criação |
| `updated_at` | TIMESTAMP | Data de atualização |

### Tipos de Multa

- **late_payment**: Multa por atraso no pagamento
- **breach_of_contract**: Multa por quebra de contrato
- **administrative**: Multa administrativa
- **other**: Outros tipos de multa

### Status da Multa

- **pending**: Pendente de pagamento
- **paid**: Paga integralmente
- **partial_paid**: Parcialmente paga
- **cancelled**: Cancelada

## 📈 Views Disponíveis

### 1. `client_payment_history`
Histórico unificado que combina:
- Pagamentos de empréstimos
- Pagamentos de parcelas
- Multas (pagas e pendentes)

**Colunas principais:**
- `transaction_type`: Tipo (payment, installment_payment, fine)
- `transaction_description`: Descrição da transação
- `amount`: Valor
- `transaction_date`: Data da transação
- `status`: Status atual

### 2. `pending_fines`
Lista todas as multas pendentes e parcialmente pagas, incluindo:
- Informações do cliente
- Valor pendente
- Dias de atraso
- Vínculo com empréstimo (se houver)

### 3. `client_fines_summary`
Resumo de multas por cliente:
- Total de multas
- Quantidade por status
- Valor total das multas
- Valor pago
- Saldo devedor

## 💡 Exemplos de Uso

### 1. Criar uma Nova Multa

```sql
-- Multa por atraso de pagamento
INSERT INTO fines (
    client_id, 
    loan_id, 
    amount, 
    reason, 
    fine_type, 
    fine_date, 
    due_date,
    created_by,
    notes
) VALUES (
    '123e4567-e89b-12d3-a456-426614174000', -- UUID do cliente
    '987fcdeb-51a2-43d7-9876-543210987654', -- UUID do empréstimo
    50.00,
    'Atraso no pagamento do empréstimo',
    'late_payment',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '7 days',
    (SELECT id FROM users WHERE email = 'admin@nexus.com'),
    'Multa aplicada por 5 dias de atraso'
);
```

### 2. Multa Administrativa (sem vínculo com empréstimo)

```sql
INSERT INTO fines (
    client_id, 
    amount, 
    reason, 
    fine_type, 
    fine_date, 
    due_date,
    created_by
) VALUES (
    '123e4567-e89b-12d3-a456-426614174000',
    100.00,
    'Taxa administrativa de reemissão de documentos',
    'administrative',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '15 days',
    (SELECT id FROM users WHERE email = 'admin@nexus.com')
);
```

### 3. Registrar Pagamento de Multa

```sql
-- Pagamento integral
UPDATE fines 
SET 
    paid_amount = amount,
    paid_date = CURRENT_DATE,
    payment_method = 'Dinheiro',
    notes = COALESCE(notes, '') || ' | Multa paga integralmente em ' || CURRENT_DATE
WHERE id = '456e7890-e89b-12d3-a456-426614174111';

-- Pagamento parcial
UPDATE fines 
SET 
    paid_amount = paid_amount + 25.00,
    payment_method = 'PIX',
    notes = COALESCE(notes, '') || ' | Pagamento parcial de R$ 25,00'
WHERE id = '456e7890-e89b-12d3-a456-426614174111';
```

### 4. Ver Histórico Completo de um Cliente

```sql
-- Ver todos os pagamentos, parcelas e multas de um cliente
SELECT 
    transaction_type,
    transaction_description,
    amount,
    transaction_date,
    status,
    created_by_name
FROM client_payment_history
WHERE client_id = '123e4567-e89b-12d3-a456-426614174000'
ORDER BY transaction_date DESC;
```

### 5. Ver Multas Pendentes

```sql
-- Todas as multas pendentes
SELECT 
    client_name,
    client_phone,
    amount,
    remaining_amount,
    reason,
    days_overdue,
    due_date
FROM pending_fines
ORDER BY days_overdue DESC;
```

### 6. Resumo de Multas por Cliente

```sql
-- Clientes com multas pendentes
SELECT 
    client_name,
    client_cpf,
    total_fines,
    pending_fines,
    total_outstanding_amount
FROM client_fines_summary
WHERE total_outstanding_amount > 0
ORDER BY total_outstanding_amount DESC;
```

### 7. Calcular Multa Automaticamente

```sql
-- Calcular multa por atraso (2% ao dia)
SELECT calculate_late_fine(
    '987fcdeb-51a2-43d7-9876-543210987654', -- UUID do empréstimo
    5,    -- dias de atraso
    0.02  -- taxa de 2% ao dia
) as valor_multa;
```

### 8. Cancelar uma Multa

```sql
UPDATE fines 
SET 
    status = 'cancelled',
    notes = COALESCE(notes, '') || ' | Multa cancelada em ' || CURRENT_DATE
WHERE id = '456e7890-e89b-12d3-a456-426614174111';
```

## 🔄 Funcionalidades Automáticas

### 1. Atualização Automática de Status
O sistema atualiza automaticamente o status da multa baseado no valor pago:
- `paid`: Quando paid_amount >= amount
- `partial_paid`: Quando paid_amount > 0 e < amount
- `pending`: Quando paid_amount = 0

### 2. Data de Pagamento Automática
Quando a multa é marcada como paga, a `paid_date` é automaticamente definida para a data atual.

### 3. Campo updated_at
Atualizado automaticamente sempre que há modificação no registro.

## 📱 Integração com o Sistema

### No Frontend (Exemplo React/Next.js)

```javascript
// Buscar histórico completo do cliente
async function getClientPaymentHistory(clientId) {
  const { data, error } = await supabase
    .from('client_payment_history')
    .select('*')
    .eq('client_id', clientId)
    .order('transaction_date', { ascending: false });
  
  return data;
}

// Criar nova multa
async function createFine(fineData) {
  const { data, error } = await supabase
    .from('fines')
    .insert([{
      client_id: fineData.clientId,
      loan_id: fineData.loanId, // opcional
      amount: fineData.amount,
      reason: fineData.reason,
      fine_type: fineData.fineType,
      fine_date: new Date().toISOString().split('T')[0],
      due_date: fineData.dueDate,
      created_by: fineData.userId,
      notes: fineData.notes
    }])
    .select();
  
  return data;
}

// Registrar pagamento de multa
async function payFine(fineId, paymentAmount, paymentMethod) {
  const { data, error } = await supabase
    .from('fines')
    .update({
      paid_amount: paymentAmount,
      payment_method: paymentMethod,
      notes: `Pagamento registrado em ${new Date().toLocaleDateString()}`
    })
    .eq('id', fineId)
    .select();
  
  return data;
}

// Buscar multas pendentes de um cliente
async function getClientPendingFines(clientId) {
  const { data, error } = await supabase
    .from('pending_fines')
    .select('*')
    .eq('client_id', clientId)
    .order('due_date', { ascending: true });
  
  return data;
}
```

## 🔐 Segurança (RLS)

O sistema implementa Row Level Security (RLS) para garantir segurança:

- **Visualização**: Todos os usuários autenticados podem ver multas
- **Criação**: Todos os usuários autenticados podem criar multas
- **Atualização**: Apenas o criador ou administradores
- **Exclusão**: Apenas o criador ou administradores

## 📊 Relatórios Úteis

### Multas por Período

```sql
SELECT 
    DATE_TRUNC('month', fine_date) as mes,
    fine_type,
    COUNT(*) as quantidade,
    SUM(amount) as valor_total,
    SUM(paid_amount) as valor_pago,
    SUM(amount - paid_amount) as valor_pendente
FROM fines
WHERE fine_date >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY DATE_TRUNC('month', fine_date), fine_type
ORDER BY mes DESC, fine_type;
```

### Top Clientes com Multas

```sql
SELECT 
    c.name,
    c.cpf,
    c.phone,
    COUNT(f.id) as total_multas,
    SUM(f.amount) as valor_total_multas,
    SUM(f.amount - f.paid_amount) as saldo_devedor
FROM clients c
JOIN fines f ON c.id = f.client_id
WHERE f.status IN ('pending', 'partial_paid')
GROUP BY c.id, c.name, c.cpf, c.phone
ORDER BY saldo_devedor DESC
LIMIT 10;
```

### Efetividade de Cobrança

```sql
SELECT 
    fine_type,
    COUNT(*) as total_multas,
    COUNT(CASE WHEN status = 'paid' THEN 1 END) as multas_pagas,
    ROUND(
        COUNT(CASE WHEN status = 'paid' THEN 1 END)::NUMERIC / 
        COUNT(*)::NUMERIC * 100, 
        2
    ) as taxa_pagamento_pct,
    SUM(amount) as valor_total,
    SUM(paid_amount) as valor_recebido,
    ROUND(
        SUM(paid_amount) / SUM(amount) * 100,
        2
    ) as taxa_recuperacao_pct
FROM fines
GROUP BY fine_type
ORDER BY total_multas DESC;
```

## ✅ Checklist de Implementação

- [x] Criar tabela `fines`
- [x] Adicionar índices para performance
- [x] Implementar triggers de atualização automática
- [x] Criar view `client_payment_history`
- [x] Criar view `pending_fines`
- [x] Criar view `client_fines_summary`
- [x] Configurar RLS policies
- [x] Função de cálculo de multa automática
- [x] Documentação completa

## 🎯 Benefícios

1. **Histórico Unificado**: Todas as transações (pagamentos, parcelas e multas) em um só lugar
2. **Gestão Completa**: Controle total sobre multas aplicadas, pagas e pendentes
3. **Automação**: Status e valores atualizados automaticamente
4. **Flexibilidade**: Multas podem ou não estar vinculadas a empréstimos
5. **Relatórios**: Views prontas para análise e tomada de decisão
6. **Segurança**: RLS implementado para proteção de dados

## 📞 Suporte

Para dúvidas ou problemas, consulte a documentação principal do sistema ou entre em contato com a equipe de desenvolvimento.

---

**Versão:** 1.0.0  
**Data:** 28/11/2024  
**Sistema:** Nexus Gestão Financeira
