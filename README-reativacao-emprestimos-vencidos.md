# Reativação de Empréstimos Vencidos

## 📋 **Funcionalidade Implementada**

Esta funcionalidade permite que empréstimos vencidos sejam automaticamente reativados quando recebem um pagamento, seguindo as seguintes regras:

### ✅ **Comportamento Implementado**

1. **Detecção de Empréstimo Vencido**: 
   - O sistema verifica se o empréstimo estava com status "vencido" antes do pagamento
   - Utiliza a função `getLoanStatus()` para determinar o status atual baseado na data de vencimento

2. **Reativação Automática**:
   - Quando um pagamento é feito em um empréstimo vencido
   - E o pagamento NÃO quita completamente o empréstimo
   - O status é automaticamente alterado para "active" (ativo)

3. **Nova Data de Vencimento**:
   - A data de vencimento é atualizada para **30 dias** a partir da data do pagamento
   - Exemplo: Pagamento em 09/10/2025 → Nova data de vencimento: 08/11/2025

4. **Feedback ao Usuário**:
   - Mensagem de sucesso informativa mostra a reativação
   - Inclui a data do pagamento e nova data de vencimento
   - Formato: "🔄 EMPRÉSTIMO VENCIDO REATIVADO!"

## 🔧 **Implementação Técnica**

### **Arquivo Modificado**: `app.js`

### **Função Alterada**: `handlePayment()`

#### **Localização**: Linhas ~2318-2353

```javascript
// Verificar se o empréstimo estava vencido antes do pagamento
const currentStatus = getLoanStatus(loan.due_date, loan.status);
const wasOverdue = currentStatus === 'overdue';

// Preparar dados de atualização
let updateData = {
    status: newStatus,
    updated_at: new Date().toISOString()
};

// Se deve alterar a data de vencimento
if (changeDueDate && newDueDate) {
    updateData.due_date = newDueDate;
} else if (wasOverdue && newStatus !== 'paid') {
    // Se o empréstimo estava vencido e não foi quitado completamente,
    // atualizar status para 'active' e definir nova data de vencimento (30 dias a partir do pagamento)
    newStatus = 'active';
    updateData.status = 'active';
    
    // Calcular nova data de vencimento: 30 dias a partir da data do pagamento
    const paymentDateObj = new Date(paymentDate);
    const newDueDateObj = new Date(paymentDateObj);
    newDueDateObj.setDate(newDueDateObj.getDate() + 30);
    
    // Formatar a data no formato YYYY-MM-DD
    const formattedNewDueDate = newDueDateObj.toISOString().split('T')[0];
    updateData.due_date = formattedNewDueDate;
    
    // Armazenar informações para a mensagem de sucesso
    reactivationInfo = {
        wasOverdue: true,
        newDueDate: formattedNewDueDate,
        paymentDate: paymentDate
    };
}
```

#### **Mensagem de Sucesso**: Linhas ~2404-2410

```javascript
// Adicionar informação sobre reativação de empréstimo vencido
if (reactivationInfo && reactivationInfo.wasOverdue) {
    successMessage += `\n\n🔄 EMPRÉSTIMO VENCIDO REATIVADO!\n` +
                    `• Status: Ativo\n` +
                    `• Data do pagamento: ${formatDate(reactivationInfo.paymentDate)}\n` +
                    `• Nova data de vencimento: ${formatDate(reactivationInfo.newDueDate)} (30 dias)`;
}
```

## 🎯 **Cenários de Uso**

### **Cenário 1: Empréstimo Vencido com Pagamento Parcial**
- **Situação**: Empréstimo vencido em 01/10/2025, pagamento de R$ 500 em 09/10/2025
- **Total do empréstimo**: R$ 1.200
- **Resultado**: 
  - Status: "active" 
  - Nova data de vencimento: 08/11/2025
  - Mensagem de reativação exibida

### **Cenário 2: Empréstimo Vencido com Quitação Total**
- **Situação**: Empréstimo vencido, pagamento quita completamente
- **Resultado**: 
  - Status: "paid"
  - Não há reativação (empréstimo foi quitado)
  - Mensagem padrão de quitação

### **Cenário 3: Empréstimo Ativo com Pagamento**
- **Situação**: Empréstimo ainda dentro do prazo
- **Resultado**: 
  - Comportamento normal (sem reativação)
  - Status baseado no pagamento (partial_paid ou paid)

## ⚠️ **Observações Importantes**

1. **Prioridade da Alteração Manual**: 
   - Se o usuário marcar "Alterar data de vencimento" manualmente, essa data tem prioridade sobre os 30 dias automáticos

2. **Apenas Novos Pagamentos**: 
   - A reativação só ocorre para novos pagamentos, não para edições de pagamentos existentes

3. **Status Final**: 
   - Se o pagamento quitar completamente o empréstimo, o status será "paid" independente de estar vencido

4. **Compatibilidade**: 
   - A funcionalidade é compatível com todos os outros recursos existentes
   - Não interfere com renovações, parcelamentos ou outras operações

## 🧪 **Como Testar**

1. **Criar um empréstimo com data de vencimento no passado**
2. **Fazer um pagamento parcial no empréstimo vencido**
3. **Verificar se o status mudou para "Ativo"**
4. **Verificar se a nova data de vencimento é 30 dias após o pagamento**
5. **Confirmar que a mensagem de reativação foi exibida**

## 📊 **Impacto nos Relatórios**

- **Dashboard**: Empréstimos reativados aparecerão como "Ativos"
- **Gráficos**: Redução de empréstimos vencidos, aumento de ativos
- **Histórico**: Mantém registro completo de todos os pagamentos
- **Status Tables**: Triggers automáticos atualizarão as tabelas de status

## ✅ **Benefícios**

1. **Gestão Automática**: Reduz trabalho manual de reativar empréstimos
2. **Padronização**: Sempre 30 dias de prazo após pagamento
3. **Transparência**: Usuário é informado sobre a reativação
4. **Flexibilidade**: Permite alteração manual da data se necessário
5. **Compatibilidade**: Funciona com todo o sistema existente