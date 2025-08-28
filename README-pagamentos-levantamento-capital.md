# Sistema de Pagamentos para Levantamento de Capital

## Visão Geral

Foi implementado um sistema completo de gerenciamento de pagamentos para os clientes de levantamento de capital, permitindo:

- Criar pagamentos individuais para cada cliente
- Acompanhar o valor total pago por cliente
- Calcular automaticamente o saldo devedor
- Visualizar histórico completo de pagamentos
- Gerenciar status e métodos de pagamento

## Configuração do Banco de Dados

### 1. Execute o Script SQL

Execute o arquivo `capital-raising-payments-setup.sql` no seu banco Supabase para criar:

- Tabela `capital_raising_payments` para armazenar os pagamentos
- Campos adicionais na tabela `capital_raising_clients`:
  - `valor_total_pago`: Soma de todos pagamentos confirmados
  - `saldo_devedor`: Valor restante que o cliente deve pagar
- Triggers automáticos para atualizar os totais quando pagamentos são criados/editados/excluídos

### 2. Estrutura da Tabela de Pagamentos

A tabela `capital_raising_payments` possui os seguintes campos:

- `id`: Identificador único do pagamento
- `capital_raising_client_id`: ID do cliente (chave estrangeira)
- `valor_pagamento`: Valor do pagamento realizado
- `data_pagamento`: Data em que o pagamento foi realizado
- `data_vencimento`: Data de vencimento (opcional)
- `status_pagamento`: Status ('confirmado', 'pendente', 'cancelado')
- `metodo_pagamento`: Método utilizado (PIX, transferência, etc.)
- `observacoes`: Observações sobre o pagamento
- `comprovante_url`: URL do comprovante (para implementação futura)

## Funcionalidades Implementadas

### 1. Visualização na Tabela de Clientes

A tabela de participantes do levantamento agora exibe:

- **Valor Individual**: Valor que o cliente deve contribuir
- **Total Pago**: Soma de todos pagamentos confirmados
- **Saldo Devedor**: Valor restante (cores indicativas: verde = quitado, amarelo = parcial, vermelho = em aberto)

### 2. Gerenciamento de Pagamentos

Para cada cliente, você pode:

- **Adicionar Pagamento**: Botão com ícone de dinheiro (💰)
- **Ver Histórico**: Botão com ícone de documento (📄)

### 3. Modal de Adicionar Pagamento

Permite inserir:
- Valor do pagamento
- Data do pagamento
- Método de pagamento (PIX, transferência, etc.)
- Status (confirmado ou pendente)
- Data de vencimento (opcional)
- Observações

### 4. Modal de Histórico de Pagamentos

Exibe:
- Resumo do cliente (valor individual, total pago, saldo devedor)
- Tabela com todos os pagamentos realizados
- Opções para editar ou excluir pagamentos
- Botão para adicionar novo pagamento

## Atualizações Automáticas

O sistema utiliza triggers no banco de dados para:

1. **Calcular automaticamente** o valor total pago quando um pagamento é inserido
2. **Atualizar o saldo devedor** em tempo real
3. **Manter consistência** dos dados mesmo com múltiplas operações

## Métodos de Pagamento Suportados

- PIX
- Transferência Bancária
- TED
- DOC
- Boleto
- Cartão
- Dinheiro
- Outros

## Status de Pagamento

- **Confirmado**: Pagamento efetivado (conta para o total pago)
- **Pendente**: Pagamento em processamento (não conta para o total)
- **Cancelado**: Pagamento cancelado (não conta para o total)

## Interface de Usuário

### Cores dos Indicadores

- **Verde**: Saldo quitado (≤ 0)
- **Amarelo**: Pagamento parcial
- **Vermelho**: Sem pagamentos ou valor total em aberto
- **Azul**: Total pago
- **Verde claro**: Valor dos pagamentos individuais

### Ícones dos Botões

- 📄 **Histórico**: Ver todos os pagamentos do cliente
- 💰 **Pagamento**: Adicionar novo pagamento
- ✏️ **Editar**: Editar dados do cliente
- 🗑️ **Excluir**: Remover cliente do levantamento

## Benefícios da Implementação

1. **Controle Financeiro**: Acompanhamento preciso dos pagamentos
2. **Transparência**: Histórico completo de todas as transações
3. **Automatização**: Cálculos automáticos evitam erros manuais
4. **Flexibilidade**: Múltiplos métodos e status de pagamento
5. **Escalabilidade**: Sistema preparado para grandes volumes de dados

## Próximas Funcionalidades

- Edição de pagamentos existentes
- Upload de comprovantes
- Relatórios de pagamentos
- Notificações de vencimento
- Exportação de dados

---

## Como Usar

1. Acesse a aba "Levantamento de Capital"
2. Clique em "Ver Detalhes" de um levantamento
3. Na lista de participantes, use os botões:
   - 💰 para adicionar um pagamento
   - 📄 para ver o histórico completo
4. Os valores são atualizados automaticamente após cada operação

O sistema está totalmente integrado e pronto para uso!