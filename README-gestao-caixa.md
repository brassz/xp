# Gestão de Caixa - Sistema Nexus

Este documento descreve a implementação do módulo de **Gestão de Caixa** adicionado ao sistema Nexus Gestão Financeira.

## 📋 Funcionalidades Implementadas

### 1. **Nova Aba de Gestão de Caixa**
- Interface moderna e intuitiva
- Navegação integrada ao sistema existente
- Design responsivo com tema dark

### 2. **Operações de Caixa**
- ✅ **Adicionar Dinheiro**: Formulário para registrar entradas
- ✅ **Retirar Dinheiro**: Formulário para registrar saídas
- ✅ **Validação de Saldo**: Impede saques superiores ao saldo disponível
- ✅ **Descrições Personalizadas**: Campo opcional para descrever transações

### 3. **Dashboard de Caixa**
- **Saldo Atual**: Exibição em tempo real do saldo do caixa
- **Entradas do Mês**: Total de depósitos do mês atual
- **Saídas do Mês**: Total de retiradas do mês atual
- **Indicadores Visuais**: Cards coloridos com ícones

### 4. **Histórico de Transações**
- Tabela completa com todas as transações
- Filtros por tipo (Entradas/Saídas) e data
- Exibição de data/hora, tipo, valor, descrição e saldo após transação
- Indicadores visuais (cores e ícones) para tipos de transação

### 5. **Gráfico de Fluxo de Caixa**
- Gráfico de barras dos últimos 7 dias
- Visualização separada de entradas e saídas
- Cores distintas (verde para entradas, vermelho para saídas)
- Atualização automática com novas transações

### 6. **Geração de Extrato Mensal**
- ✅ **PDF Automático**: Gera extrato em PDF do mês atual
- ✅ **Resumo Completo**: Totais de entradas, saídas e saldo líquido
- ✅ **Detalhamento**: Lista todas as transações do mês
- ✅ **Formatação Profissional**: Layout limpo com cabeçalho e rodapé
- ✅ **Download Automático**: Arquivo nomeado automaticamente

## 🗄️ Estrutura do Banco de Dados

### Tabelas Criadas

#### 1. `cash_transactions`
```sql
- id (UUID, PK): Identificador único da transação
- transaction_type (TEXT): 'deposit' ou 'withdrawal' 
- amount (DECIMAL): Valor da transação (sempre positivo)
- description (TEXT): Descrição opcional
- reference_id (UUID): ID de referência (empréstimos, despesas, etc.)
- reference_type (TEXT): Tipo da referência ('loan', 'expense', 'manual', 'installment')
- balance_after (DECIMAL): Saldo após a transação
- created_by (UUID): Usuário que criou a transação
- created_at (TIMESTAMP): Data de criação
- updated_at (TIMESTAMP): Data de atualização
```

#### 2. `cash_settings`
```sql
- id (UUID, PK): Identificador único
- current_balance (DECIMAL): Saldo atual do caixa
- initial_balance (DECIMAL): Saldo inicial configurado
- last_updated (TIMESTAMP): Data da última atualização
- updated_by (UUID): Usuário que fez a última atualização
```

### Recursos Avançados
- **Triggers**: Atualização automática do saldo na tabela `cash_settings`
- **Views**: `cash_transactions_summary` e `daily_cash_balance`
- **Índices**: Otimização para consultas por tipo, data e usuário
- **RLS (Row Level Security)**: Políticas de segurança configuradas

## 🚀 Instalação

### 1. Configurar Banco de Dados
Execute o arquivo SQL no Supabase:
```bash
# No SQL Editor do Supabase, execute:
cash-management-setup.sql
```

### 2. Arquivos Modificados
- `index.html`: Nova aba e seção de gestão de caixa
- `app.js`: Funções JavaScript para operações de caixa

### 3. Dependências
O sistema usa as bibliotecas já existentes:
- **Chart.js**: Para gráficos
- **jsPDF**: Para geração de PDFs
- **Supabase**: Para banco de dados

## 💡 Como Usar

### 1. **Acessar a Gestão de Caixa**
- Faça login no sistema
- Clique na aba "Gestão de Caixa" no menu lateral

### 2. **Adicionar Dinheiro**
- Preencha o valor no formulário "Adicionar Dinheiro"
- Adicione uma descrição (opcional)
- Clique em "Adicionar"

### 3. **Retirar Dinheiro**
- Preencha o valor no formulário "Retirar Dinheiro"
- Adicione uma descrição (opcional)
- Clique em "Retirar"
- O sistema valida se há saldo suficiente

### 4. **Visualizar Histórico**
- A tabela mostra todas as transações
- Use os filtros para buscar por tipo ou data específica

### 5. **Gerar Extrato**
- Clique no botão "Gerar Extrato Mensal"
- O PDF será baixado automaticamente
- O extrato inclui resumo e detalhamento completo

## 🔧 Recursos Técnicos

### Segurança
- Validação de saldo antes de retiradas
- Controle de acesso por usuário autenticado
- Histórico completo de todas as operações

### Performance
- Índices otimizados para consultas
- Carregamento assíncrono dos dados
- Atualização em tempo real da interface

### Integração
- Preparado para integração com empréstimos e despesas
- Campo `reference_id` permite rastreamento de operações relacionadas
- Compatível com o sistema de usuários existente

## 📊 Relatórios Disponíveis

### Dashboard
- Saldo atual em tempo real
- Totais mensais de entradas e saídas
- Gráfico de fluxo dos últimos 7 dias

### Extrato Mensal (PDF)
- Resumo do mês com totais
- Lista detalhada de todas as transações
- Saldo atual e movimentação líquida
- Formatação profissional para impressão

## 🛠️ Manutenção

### Backup
As transações são armazenadas no Supabase com backup automático.

### Auditoria
Todos os registros incluem:
- Usuário responsável
- Data e hora exata
- Saldo antes e depois da operação

### Monitoramento
- Views SQL para análises avançadas
- Consultas otimizadas para relatórios
- Histórico completo preservado

---

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique se o banco de dados foi configurado corretamente
2. Confirme se o usuário tem permissões adequadas
3. Verifique o console do navegador para erros JavaScript

A Gestão de Caixa está totalmente integrada ao sistema Nexus e pronta para uso!