# Funcionalidade: PDF de Empréstimo Individual

## Descrição

Nova funcionalidade que permite gerar um PDF detalhado de um empréstimo específico diretamente da aba de "Empréstimos". Cada empréstimo possui um botão individual para gerar seu comprovante em PDF.

## Como Usar

1. Acesse a aba **"Empréstimos"** no menu lateral
2. Na tabela de empréstimos, localize o empréstimo desejado
3. Na coluna de ações (última coluna), clique no botão **📑** (ícone de documento vermelho)
4. O PDF será gerado e baixado automaticamente

## Localização do Botão

O botão de PDF está localizado na coluna de ações de cada empréstimo, entre os botões:
- 📄 Gerar Contrato
- **📑 Gerar PDF do Empréstimo** ← NOVO
- ✅ Marcar como Pago

**Cor**: Vermelho (`text-red-500`)
**Tooltip**: "Gerar PDF do Empréstimo"

## Informações Incluídas no PDF

O PDF de empréstimo individual contém:

### 1. Cabeçalho
- Título: "COMPROVANTE DE EMPRÉSTIMO"
- ID do empréstimo (para referência)

### 2. Dados do Cliente
- Nome completo
- CPF
- RG (se disponível)
- Telefone
- Email (se disponível)
- **Endereço completo** (se disponível)
- Data de Nascimento (se disponível)

### 3. Avalista(s)
Se o cliente possuir avalistas cadastrados:
- Nome do avalista
- CPF
- Telefone
- Relacionamento com o cliente

### 4. Detalhes do Empréstimo
- Data do empréstimo
- Data de vencimento
- Valor principal
- Taxa de juros
- **Valor total com juros** (destacado em negrito)
- Status atual (Ativo, Vence Hoje, Vencido)

### 5. Resumo de Pagamentos
- Total já pago
- **Valor restante** (em vermelho se pendente, verde se quitado)

### 6. Histórico de Pagamentos
Lista detalhada de todos os pagamentos realizados neste empréstimo:
- Data do pagamento
- Valor pago
- Multa (se houver)
- Tipo de pagamento (PIX, Dinheiro, Cartão, etc.)
- Observações/notas

Se não houver pagamentos, exibe: "Nenhum pagamento registrado até o momento"

## Características Técnicas

### Formato do PDF
- Título centralizado e destacado
- Seções bem definidas com cabeçalhos em negrito
- Linha separadora entre dados do cliente e do empréstimo
- Cores diferenciadas:
  - Vermelho para valores pendentes
  - Verde para valores quitados
  - Cinza para texto secundário
- Páginas automáticas quando necessário
- Endereços longos são divididos em múltiplas linhas automaticamente

### Nome do Arquivo
```
Emprestimo_[Nome_do_Cliente]_[Data_do_Emprestimo].pdf
```

Exemplos:
- `Emprestimo_Maria_Silva_15-11-2025.pdf`
- `Emprestimo_Joao_Santos_01-12-2025.pdf`

### Tecnologia Utilizada
- **Biblioteca**: jsPDF 2.5.1
- **Formato**: PDF padrão
- **Codificação**: UTF-8 (suporta acentuação)

## Diferenças Entre os PDFs

O sistema agora oferece **dois tipos de PDF**:

### PDF Individual do Empréstimo (📑)
- **Localização**: Botão na aba "Empréstimos"
- **Escopo**: Apenas 1 empréstimo específico
- **Conteúdo**: Detalhes completos de um único empréstimo
- **Uso**: Comprovante individual, envio ao cliente

### PDF Completo do Cliente (Gerar PDF Completo)
- **Localização**: Botão na aba "Histórico Completo"
- **Escopo**: Todos os empréstimos do cliente
- **Conteúdo**: Histórico completo de empréstimos e pagamentos
- **Uso**: Análise de crédito, relatório financeiro completo

## Localização no Código

### Arquivo: `app.js`

**Botão adicionado** (linhas 1988-1997):
```javascript
<button class="text-red-500 hover:text-red-400 mr-3" 
        onclick="generateLoanPDF('${loan.id}')" 
        title="Gerar PDF do Empréstimo">📑</button>
```

**Função principal** (linhas 16226-16504):
```javascript
async function generateLoanPDF(loanId)
```

A função:
1. Busca os dados do empréstimo
2. Busca os dados completos do cliente (incluindo endereço)
3. Busca os pagamentos do empréstimo
4. Busca os avalistas do cliente
5. Calcula totais e valores restantes
6. Gera o PDF formatado
7. Faz o download automático

## Mensagens de Feedback

- **"Gerando PDF do empréstimo... Por favor, aguarde."** - Durante a geração
- **"PDF do empréstimo gerado com sucesso!"** - Quando concluído
- **"Empréstimo não encontrado"** - Se o empréstimo não existir
- **"Erro ao gerar PDF: [mensagem]"** - Em caso de erro

## Casos de Uso

1. **Comprovante para o Cliente**: Gerar e enviar por WhatsApp/Email
2. **Documentação**: Manter registro impresso do empréstimo
3. **Cobrança**: Enviar junto com mensagem de cobrança
4. **Auditoria**: Documentar transações individuais
5. **Arquivo**: Manter cópia em PDF de cada operação

## Benefícios

✅ **Rápido**: Geração instantânea com um clique
✅ **Completo**: Inclui endereço e todas as informações necessárias
✅ **Profissional**: Layout bem formatado e organizado
✅ **Individual**: Foco em um empréstimo específico
✅ **Portátil**: Arquivo PDF pode ser facilmente compartilhado
✅ **Histórico**: Mantém registro de pagamentos do empréstimo

## Observações Importantes

- O botão está disponível para **todos os empréstimos ativos**
- O endereço do cliente é automaticamente incluído (se cadastrado)
- Avalistas são incluídos automaticamente (se houver)
- O PDF mostra o status atual do empréstimo
- Valores são formatados em moeda brasileira (R$)
- Datas são formatadas no padrão brasileiro (DD/MM/AAAA)

## Data de Implementação

Implementado em: 01 de Dezembro de 2025

## Versão

v1.0.0
