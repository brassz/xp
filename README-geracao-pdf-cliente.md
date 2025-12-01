# Geração de PDF Completo do Cliente

## Descrição

Esta funcionalidade permite gerar um relatório PDF completo com todas as informações de um cliente, incluindo dados pessoais, avalistas, contatos de emergência, empréstimos e pagamentos.

## Como Usar

1. **Acesse a aba "Histórico"** no menu lateral
2. **Selecione um cliente** usando o campo de busca ou o seletor dropdown
3. **Clique em "Carregar Histórico"** para visualizar os dados do cliente
4. **Clique no botão "Gerar PDF Completo"** localizado no topo do resumo do cliente

## Informações Incluídas no PDF

O PDF gerado contém as seguintes seções:

### 1. Dados do Cliente
- Nome completo
- CPF
- Email
- Telefone
- Endereço completo

### 2. Avalistas (se cadastrados)
Para cada avalista, são incluídos:
- Nome
- CPF
- Telefone
- Endereço
- Tipo de relacionamento

### 3. Contatos de Emergência (se cadastrados)
- Nome do contato
- Telefone

### 4. Resumo Financeiro
- Total de empréstimos (ativos e quitados)
- Valor total emprestado
- Total pago
- Valor restante a receber

### 5. Empréstimos Ativos
Para cada empréstimo ativo:
- Valor principal
- Taxa de juros
- Valor total com juros
- Data do empréstimo
- Data de vencimento
- Status atual
- Valor já pago
- Valor restante

### 6. Empréstimos Quitados
Para cada empréstimo quitado:
- Valor principal
- Taxa de juros
- Valor total com juros
- Data do empréstimo
- Data de quitação
- Total pago

### 7. Histórico de Pagamentos
Para cada pagamento:
- Data do pagamento
- Valor pago
- Multa (se houver)
- Tipo de pagamento
- Observações

## Características Técnicas

### Formato do Arquivo
- **Nome do arquivo**: `Cliente_[Nome_do_Cliente]_[Data].pdf`
- **Formato**: PDF (Portable Document Format)
- **Codificação**: UTF-8
- **Fonte**: Helvetica

### Funcionalidades Automáticas
- **Quebra de página automática**: O sistema adiciona novas páginas automaticamente quando necessário
- **Numeração de páginas**: Cada página é numerada (ex: "Página 1 de 5")
- **Rodapé**: Todas as páginas incluem o rodapé "Nexus Gestão Financeira"
- **Quebra de linha inteligente**: Textos longos (como endereços) são quebrados automaticamente

### Tratamento de Dados
- Campos vazios são exibidos como "N/A"
- Valores monetários são formatados em Reais (R$)
- Datas são formatadas no padrão brasileiro (DD/MM/YYYY)

## Requisitos

### Frontend
- Biblioteca jsPDF (já incluída no projeto)
- Navegador moderno com suporte a JavaScript ES6+

### Backend (Supabase)
- Acesso às seguintes tabelas:
  - `clients` (clientes)
  - `loans` (empréstimos ativos)
  - `paid_loans` (empréstimos quitados)
  - `payments` (pagamentos)
  - `guarantors` (avalistas)
  - `emergency_contacts` (contatos de emergência)

## Casos de Uso

### 1. Documentação para Auditoria
Gere um PDF completo para manter registros históricos de cada cliente.

### 2. Análise de Crédito
Use o relatório completo para avaliar o histórico de pagamento de um cliente antes de conceder um novo empréstimo.

### 3. Compartilhamento com Gestores
Exporte o relatório para compartilhar informações completas do cliente com outros membros da equipe.

### 4. Backup de Informações
Mantenha cópias em PDF das informações críticas dos clientes.

## Exemplos de Uso

### Cenário 1: Cliente com Múltiplos Empréstimos
Um cliente com 3 empréstimos ativos e 2 quitados terá um PDF com aproximadamente 4-5 páginas contendo:
- Página 1: Dados pessoais, avalistas e resumo financeiro
- Páginas 2-3: Detalhes de todos os empréstimos
- Páginas 4-5: Histórico completo de pagamentos

### Cenário 2: Cliente Novo
Um cliente com apenas 1 empréstimo e poucos pagamentos terá um PDF conciso de 1-2 páginas.

### Cenário 3: Cliente Sem Avalistas
Se o cliente não tiver avalistas cadastrados, a seção "Avalistas" não aparecerá no PDF.

## Tratamento de Erros

O sistema exibe mensagens de erro nas seguintes situações:
- **"Por favor, selecione um cliente primeiro"**: Quando nenhum cliente foi selecionado
- **"Cliente não encontrado"**: Quando o cliente selecionado não existe mais no banco de dados
- **"Erro ao gerar PDF: [mensagem]"**: Quando ocorre algum erro durante a geração do PDF

## Performance

- **Tempo de geração**: 2-5 segundos (dependendo da quantidade de dados)
- **Tamanho do arquivo**: Normalmente entre 50KB e 200KB
- **Limite de dados**: Sem limite (o sistema adiciona páginas conforme necessário)

## Manutenção

### Atualizações Futuras Sugeridas
1. Adicionar gráficos de histórico de pagamentos
2. Incluir foto do cliente no PDF
3. Permitir personalização do template
4. Adicionar opção de envio por email
5. Incluir assinatura digital

### Solução de Problemas

**PDF não está sendo gerado**:
- Verifique se o cliente tem dados carregados
- Verifique o console do navegador para mensagens de erro
- Confirme que a biblioteca jsPDF está carregada

**Dados faltando no PDF**:
- Verifique se os dados existem no banco de dados
- Confirme que o histórico foi carregado corretamente antes de gerar o PDF

**PDF com formatação incorreta**:
- Limpe o cache do navegador
- Recarregue a página e tente novamente

## Código Fonte

### Arquivos Modificados
1. **index.html** (linha ~1790):
   - Adicionado botão "Gerar PDF Completo" no resumo do cliente

2. **app.js** (linha ~562):
   - Adicionado event listener para o botão

3. **app.js** (linha ~8499):
   - Implementada função `generateClientLoansPDF()`

### Funções Principais

```javascript
// Função principal de geração do PDF
async function generateClientLoansPDF()

// Funções auxiliares utilizadas
- loadClientGuarantors(clientId)
- calculateBatchLoanRemainingAmounts(clientLoanIds)
- formatDate(dateString)
- getStatusText(status)
```

## Changelog

### Versão 1.0 (01/12/2025)
- Implementação inicial da funcionalidade
- Incluídas todas as seções básicas de informação
- Adicionada quebra automática de páginas
- Implementado rodapé com numeração

---

**Desenvolvido por**: Nexus Gestão Financeira  
**Data**: Dezembro 2025  
**Versão**: 1.0
