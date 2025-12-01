# Funcionalidade: Relatório PDF Completo do Cliente

## Descrição

Nova funcionalidade adicionada na aba de "Histórico Completo" que permite gerar um relatório PDF completo com todas as informações de um cliente específico.

## Como Usar

1. Acesse a aba **"Histórico Completo"** no menu lateral
2. Selecione um cliente através do campo de busca ou da lista dropdown
3. Clique no botão **"Carregar Histórico"**
4. Após carregar os dados do cliente, clique no botão vermelho **"Gerar PDF Completo"** localizado no cabeçalho da seção "Resumo do Cliente"
5. O PDF será gerado e baixado automaticamente

## Informações Incluídas no PDF

O relatório PDF completo contém as seguintes seções:

### 1. Dados do Cliente
- Nome completo
- CPF
- RG
- Telefone
- Email
- Endereço (se disponível)
- Data de Nascimento (se disponível)

### 2. Avalistas
Para cada avalista cadastrado:
- Nome
- CPF
- Telefone
- Email (se disponível)
- Relacionamento com o cliente
- Endereço (se disponível)

### 3. Contatos de Emergência
Para cada contato de emergência:
- Nome
- Telefone
- Relacionamento com o cliente

### 4. Resumo Financeiro
- Total de empréstimos (ativos + quitados)
- Valor total emprestado (com juros)
- Total pago até o momento
- Valor restante a pagar

### 5. Empréstimos Ativos
Para cada empréstimo ativo, o PDF inclui:
- ID do empréstimo
- Data do empréstimo
- Data de vencimento
- Valor original
- Taxa de juros
- Valor total com juros
- Valor já pago
- Valor restante
- Status atual (Ativo, Vence Hoje, Vencido)

### 6. Empréstimos Quitados
Para cada empréstimo quitado:
- ID do empréstimo
- Data de quitação
- Valor original
- Taxa de juros
- Valor total com juros
- Valor total pago

### 7. Histórico de Pagamentos
Lista completa de todos os pagamentos realizados, incluindo:
- Data do pagamento
- Valor pago
- Multa (se houver)
- Tipo de pagamento (PIX, Dinheiro, etc.)
- Notas/observações

## Características Técnicas

### Formato do PDF
- Páginas automáticas: o PDF cria automaticamente novas páginas quando necessário
- Layout responsivo com margens adequadas
- Títulos em negrito e tamanhos de fonte diferenciados
- Data e hora de geração no rodapé

### Nome do Arquivo
O arquivo PDF é salvo automaticamente com o seguinte formato:
```
Relatorio_[Nome_do_Cliente]_[Data].pdf
```

Exemplo: `Relatorio_Joao_Silva_01-12-2025.pdf`

### Tecnologia Utilizada
- **Biblioteca**: jsPDF 2.5.1
- **Formato**: PDF/A padrão
- **Codificação**: UTF-8 (suporta acentuação)

## Localização no Código

### Arquivo: `index.html`
- **Linhas 1786-1799**: Botão "Gerar PDF Completo" adicionado na seção de resumo do cliente
- Botão com ícone de documento e cor vermelha para destaque

### Arquivo: `app.js`
- **Linhas 15829-16223**: Função `generateClientCompletePDF()`
- Função assíncrona que:
  1. Busca dados do cliente selecionado
  2. Busca empréstimos ativos e quitados
  3. Busca todos os pagamentos
  4. Busca avalistas
  5. Busca contatos de emergência
  6. Calcula totais financeiros
  7. Gera o PDF formatado com todas as informações

## Mensagens de Feedback

O sistema exibe mensagens ao usuário durante o processo:
- **"Gerando PDF completo do cliente... Por favor, aguarde."** - Enquanto coleta dados e gera o PDF
- **"PDF gerado com sucesso!"** - Quando o PDF é gerado e baixado
- **"Por favor, selecione um cliente primeiro"** - Se tentar gerar PDF sem selecionar cliente
- **"Erro ao gerar PDF: [mensagem de erro]"** - Em caso de erro

## Benefícios

1. **Documentação Completa**: Todas as informações do cliente em um único documento
2. **Fácil Compartilhamento**: PDF pode ser enviado por email ou impresso
3. **Histórico Permanente**: Registro completo para arquivo ou auditoria
4. **Profissionalismo**: Relatório bem formatado e organizado
5. **Automação**: Geração rápida sem necessidade de copiar/colar dados

## Observações

- É necessário selecionar um cliente e carregar seu histórico antes de gerar o PDF
- O PDF inclui automaticamente apenas as seções com dados disponíveis (ex: se não houver avalista, essa seção não aparece)
- Acentos e caracteres especiais são suportados corretamente
- O PDF é gerado no navegador e não requer servidor ou processamento backend

## Data de Implementação

Implementado em: 01 de Dezembro de 2025

## Versão

v1.0.0
