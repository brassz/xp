# Multas nos PDFs da Aba de Empréstimos

## Problema Identificado

As multas não apareciam nos PDFs gerados na **aba de empréstimos**, especificamente:
- **PDF Pagamentos Semana** (botão azul "📊 PDF Pagamentos Semana")
- **PDF de períodos específicos** (seleção de semanas no histórico)

## Funções Corrigidas

### 1. **`generateWeeklyPaymentsPDF()`**
- **Localização:** Linha ~8739
- **Botão:** "📊 PDF Pagamentos Semana" (azul)
- **Função:** Gera PDF dos pagamentos da semana atual (segunda a domingo)

### 2. **`generateWeeklyPaymentsPDFForDates()`**
- **Localização:** Linha ~12884
- **Botão:** Usado pelo histórico de PDFs para períodos específicos
- **Função:** Gera PDF dos pagamentos para datas específicas selecionadas

## Correções Implementadas

### 📊 **1. Adição do Total de Multas no Resumo**

#### Antes:
```
RESUMO
Total de Pagamentos: 15
Total Recebido: R$ 2.500,00
Total em Juros: R$ 800,00
Total em Capital: R$ 1.700,00
```

#### Depois:
```
RESUMO
Total de Pagamentos: 15
Total Recebido: R$ 2.500,00
Total em Juros: R$ 800,00
Total em Capital: R$ 1.700,00
Total em Multas: R$ 150,00
```

### 📋 **2. Nova Coluna "Multa" na Tabela**

#### Cabeçalhos Atualizados:
```javascript
// Antes
doc.text('Data', 20, yPosition);
doc.text('Cliente', 45, yPosition);
doc.text('Valor Pago', 100, yPosition);
doc.text('Juros', 130, yPosition);
doc.text('Capital', 150, yPosition);
doc.text('Tipo', 170, yPosition);

// Depois
doc.text('Data', 20, yPosition);
doc.text('Cliente', 45, yPosition);
doc.text('Valor Pago', 95, yPosition);
doc.text('Multa', 120, yPosition);        // ✅ Nova coluna
doc.text('Juros', 140, yPosition);
doc.text('Capital', 160, yPosition);
doc.text('Tipo', 180, yPosition);
```

#### Dados da Tabela:
```javascript
// Cálculo da multa para cada pagamento
const fineAmount = parseFloat(payment.fine_amount) || 0;

// Exibição na tabela
doc.text(fineAmount > 0 ? `R$ ${fineAmount.toFixed(2)}` : '-', 120, yPosition);
```

### 📈 **3. Totais Atualizados no Rodapé**

#### Antes:
```
TOTAIS DA SEMANA:  R$ 2.500,00  R$ 800,00  R$ 1.700,00
                   [Pagamentos] [Juros]    [Capital]
```

#### Depois:
```
TOTAIS DA SEMANA:  R$ 2.500,00  R$ 150,00  R$ 800,00  R$ 1.700,00
                   [Pagamentos] [Multas]   [Juros]    [Capital]
```

## Estrutura do PDF Atualizada

```
┌─────────────────────────────────────────────────────────┐
│ RELATÓRIO DE PAGAMENTOS - SEMANA                       │
├─────────────────────────────────────────────────────────┤
│ RESUMO                                                  │
│ Total de Pagamentos: 15                                │
│ Total Recebido: R$ 2.500,00                           │
│ Total em Juros: R$ 800,00                             │
│ Total em Capital: R$ 1.700,00                         │
│ Total em Multas: R$ 150,00                            │ ✅
├─────────────────────────────────────────────────────────┤
│ DETALHAMENTO DOS PAGAMENTOS                            │
├─────┬─────────┬──────────┬───────┬───────┬─────────┬────┤
│Data │Cliente  │Valor Pago│ Multa │ Juros │ Capital │Tipo│
├─────┼─────────┼──────────┼───────┼───────┼─────────┼────┤
│12/10│João S.  │ R$ 500,00│R$ 50,00│R$ 300,00│R$ 200,00│PGTO│ ✅
│11/10│Maria O. │ R$ 300,00│   -   │R$ 300,00│R$   0,00│JUROS│
├─────┴─────────┴──────────┴───────┴───────┴─────────┴────┤
│ TOTAIS DA SEMANA: R$ 2.500,00 R$ 150,00 R$ 800,00 R$ 1.700,00 │ ✅
└─────────────────────────────────────────────────────────┘
```

## Código Implementado

### Cálculo do Total de Multas:
```javascript
// Calcular e exibir total de multas
const totalFines = allWeeklyPayments.reduce((sum, payment) => 
    sum + (parseFloat(payment.fine_amount) || 0), 0);
doc.text(`Total em Multas: R$ ${totalFines.toFixed(2)}`, 20, yPosition);
```

### Exibição na Tabela:
```javascript
// Para cada pagamento
const fineAmount = parseFloat(payment.fine_amount) || 0;

// Renderizar na tabela
doc.text(fineAmount > 0 ? `R$ ${fineAmount.toFixed(2)}` : '-', 120, yPosition);
```

### Totais no Rodapé:
```javascript
doc.text('TOTAIS DA SEMANA:', 20, yPosition);
doc.text(`R$ ${totalPayments.toFixed(2)}`, 95, yPosition);   // Pagamentos
doc.text(`R$ ${totalFines.toFixed(2)}`, 120, yPosition);     // Multas ✅
doc.text(`R$ ${totalInterest.toFixed(2)}`, 140, yPosition);  // Juros
doc.text(`R$ ${totalCapital.toFixed(2)}`, 160, yPosition);   // Capital
```

## Compatibilidade

### ✅ **Empréstimos Existentes**
- Pagamentos sem multa: Exibe "-" na coluna Multa
- Total de Multas: R$ 0,00 quando não há multas

### ✅ **Novos Pagamentos**
- Pagamentos com multa: Exibe valor em vermelho
- Total de Multas: Soma correta de todas as multas

### ✅ **Layouts Responsivos**
- **Páginas adicionais:** Cabeçalhos incluem coluna Multa
- **Espaçamento:** Colunas ajustadas para acomodar nova coluna
- **Alinhamento:** Valores monetários alinhados corretamente

## Funções Afetadas

1. **`generateWeeklyPaymentsPDF()`** - PDF da semana atual
2. **`generateWeeklyPaymentsPDFForDates()`** - PDF de períodos específicos

## Resultado Final

Agora **todos os PDFs de pagamentos** na aba de empréstimos incluem:
- ✅ **Coluna "Multa"** na tabela de detalhamento
- ✅ **"Total em Multas"** no resumo
- ✅ **Multas nos totais** do rodapé
- ✅ **Compatibilidade** com pagamentos existentes
- ✅ **Layout ajustado** para acomodar nova informação

As multas agora aparecem **consistentemente** em todos os relatórios do sistema:
- Histórico de pagamentos (interface)
- Relatórios semanais e mensais (aba principal)
- PDFs de pagamentos da semana (aba empréstimos) ✅
- PDFs de períodos específicos (aba empréstimos) ✅