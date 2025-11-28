# Correção - Mensagem de Cobrança WhatsApp

## Problema Identificado
Ao enviar mensagens de cobrança via WhatsApp, os valores de **Capital** e **Juros** estavam sendo exibidos incorretamente, mostrando os valores ORIGINAIS do empréstimo ao invés dos valores RESTANTES (após deduzir os pagamentos já realizados).

- ✅ **Valor Restante Total**: estava CORRETO
- ❌ **Capital**: estava mostrando o valor ORIGINAL (sem deduzir pagamentos)
- ❌ **Juros**: estava mostrando os juros ORIGINAIS (sem deduzir pagamentos)

## Exemplo do Problema

### Antes da Correção:
```
Cliente: João Silva
Valor: R$ 1.650,00 (Cap.: 1.500,00 • Juros: 150,00 • Multa: 0,00)
```
*Mesmo que o cliente já tenha pago R$ 500,00, ainda mostrava os valores originais.*

### Depois da Correção:
```
Cliente: João Silva  
Valor: R$ 1.150,00 (Cap.: 1.000,00 • Juros: 150,00 • Multa: 0,00)
```
*Agora mostra corretamente que restam R$ 1.000,00 de capital (após deduzir o pagamento).*

## Funções Corrigidas

As seguintes funções foram atualizadas para usar os valores RESTANTES ao invés dos valores originais:

### 1. `sendWhatsAppMessageWithPixKey` (linha ~5549)
**Função principal de cobrança via WhatsApp com chave PIX**
- ✅ Corrigido para usar `remainingCapital` e `remainingInterest`
- Esta é a função mais usada no sistema

### 2. `sendGuarantorOrEmergencyMessage` (linha ~5886)
**Função para enviar mensagens a avalistas e contatos de emergência**
- ✅ Corrigido para usar `remainingCapital` e `remainingInterest`
- Atualizado os labels para "Capital Restante" e "Juros Restantes"

### 3. `sendWhatsAppMessage` (linha ~6135)
**Função legada de envio de cobrança**
- ✅ Corrigido para usar `remainingCapital` e `remainingInterest`
- Adicionado campo "Valor Restante" para maior clareza

## Cálculo Correto dos Valores

O sistema já estava calculando corretamente os valores restantes usando a seguinte lógica:

```javascript
// 1. Calcular quanto foi pago de capital (deduzindo pagamentos que são apenas juros)
let capitalPaid = 0;
let currentCapital = originalCapital;

for (const payment of realPayments) {
    const paymentAmount = parseFloat(payment.amount);
    const paymentType = payment.payment_type;
    
    // Se for pagamento apenas de juros, não reduz capital
    if (interestOnlyTypes.includes(paymentType)) {
        continue;
    }
    
    // Calcular quanto foi de capital
    const currentInterest = currentCapital * (interestRate / 100);
    if (paymentAmount > currentInterest) {
        const capitalReduction = paymentAmount - currentInterest;
        capitalPaid += capitalReduction;
        currentCapital = Math.max(0, currentCapital - capitalReduction);
    }
}

// 2. Calcular valores restantes
const remainingCapital = Math.max(0, originalCapital - capitalPaid);
const remainingInterest = remainingCapital * (interestRate / 100);
const remainingAmount = remainingCapital + remainingInterest;
```

## O Que NÃO Foi Alterado

### `sendLoanSummaryWhatsApp` - Permanece com valores ORIGINAIS
Esta função é chamada quando um empréstimo NOVO é criado e envia o resumo inicial ao cliente.
- ✅ **CORRETO** usar valores originais neste caso
- Não há pagamentos ainda, então capital e juros originais são os valores corretos

### `sendInstallmentWhatsAppMessageWithPixKey` - Não precisa de alteração
Esta função envia cobranças de parcelamentos e já está correta.
- Mostra apenas o valor da parcela específica
- Não exibe capital e juros separados

## Tipos de Pagamento Considerados

O sistema identifica corretamente os pagamentos que **NÃO reduzem o capital** (apenas juros):
- `renewal` - Renovação
- `interest_renewal` - Renovação (Somente Juros)
- `early_payment_partial_interest` - Pagamento Antecipado (Juros Parcial)
- `early_payment_interest_renewal` - Renovação Antecipada (Somente Juros)
- `partial_interest` - Juros Parcial

Qualquer outro tipo de pagamento que exceda o valor dos juros reduz o capital proporcionalmente.

## Data da Correção
28 de Novembro de 2025

## Status
✅ **CORRIGIDO** - Todas as mensagens de cobrança agora mostram os valores restantes corretos.
