# Funcionalidade de Levantamento de Capital

## Visão Geral

A funcionalidade de Levantamento de Capital permite gerenciar captações de recursos financeiros e a distribuição desses valores entre múltiplos clientes. Esta é uma funcionalidade independente que não possui conexão com as outras abas do sistema (empréstimos, clientes, etc.).

## Funcionalidades Principais

### 1. Dashboard de Levantamentos
- **Total Levantado**: Soma de todos os valores totais (com juros) dos levantamentos
- **Total Distribuído**: Soma de todos os valores distribuídos para clientes
- **Saldo Disponível**: Diferença entre o total levantado e o total distribuído

### 2. Criar Novo Levantamento
- **Valor Bruto**: Valor inicial levantado
- **Taxa de Juros (%)**: Percentual aplicado sobre o valor bruto
- **Valor Total**: Calculado automaticamente (Valor Bruto + Juros)
- **Data do Levantamento**: Data da operação
- **Observações**: Campo opcional para anotações

### 3. Gestão de Clientes no Levantamento
Para cada levantamento, é possível adicionar múltiplos clientes com:
- **Nome do Cliente**: Nome completo
- **Valor Individual**: Quantia específica para este cliente
- **Documento**: CPF ou RG (opcional)
- **Telefone**: Contato (opcional)
- **Observações**: Notas específicas do cliente

### 4. Controles e Validações
- Cálculo automático do valor total com juros
- Validação para não permitir levantamentos sem clientes
- Controle do saldo disponível em tempo real
- Resumo da distribuição durante a criação

## Estrutura do Banco de Dados

### Tabela: `capital_raising`
```sql
- id (SERIAL PRIMARY KEY)
- gross_amount (DECIMAL 15,2) - Valor bruto
- interest_rate (DECIMAL 5,2) - Taxa de juros (%)
- total_amount (DECIMAL 15,2) - Valor total com juros
- raised_date (DATE) - Data do levantamento
- status (VARCHAR 20) - Status: active, completed, cancelled
- notes (TEXT) - Observações
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

### Tabela: `capital_clients`
```sql
- id (SERIAL PRIMARY KEY)
- capital_raising_id (INTEGER FOREIGN KEY)
- client_name (VARCHAR 255) - Nome do cliente
- amount (DECIMAL 15,2) - Valor individual
- document (VARCHAR 50) - CPF/RG
- phone (VARCHAR 20) - Telefone
- notes (TEXT) - Observações
- status (VARCHAR 20) - Status: active, paid, cancelled
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

## Exemplo de Uso

### Cenário: Levantamento de R$ 10.000 com 20% de juros

1. **Criação do Levantamento:**
   - Valor Bruto: R$ 10.000,00
   - Juros: 20%
   - Valor Total: R$ 12.000,00

2. **Distribuição entre 10 clientes de R$ 1.200 cada:**
   - Cliente 1: João Silva - R$ 1.200,00
   - Cliente 2: Maria Santos - R$ 1.200,00
   - Cliente 3: Pedro Oliveira - R$ 1.200,00
   - ... (total 10 clientes)
   - **Total Distribuído:** R$ 12.000,00
   - **Saldo Disponível:** R$ 0,00

## Funcionalidades Futuras (Planejadas)

- Edição de levantamentos existentes
- Controle de pagamentos dos clientes
- Relatórios detalhados de rendimento
- Histórico de status dos clientes
- Exportação para PDF/Excel
- Dashboard com gráficos de performance

## Instalação

Para instalar as tabelas necessárias no banco de dados, execute:

```sql
-- Execute o arquivo capital-raising-setup.sql
\i capital-raising-setup.sql
```

Ou através do Supabase Dashboard na seção SQL Editor.

## Considerações Técnicas

- **Independência**: Esta funcionalidade é completamente independente das outras seções
- **Validações**: O sistema valida que o total distribuído não exceda o valor total
- **Segurança**: Usa as mesmas credenciais e permissões do Supabase
- **Performance**: Índices criados para otimizar consultas por data e relacionamentos
- **Responsividade**: Interface adaptativa para diferentes tamanhos de tela

## Navegação

A funcionalidade está acessível através da nova aba "Levantamento de Capital" no menu lateral, identificada pelo ícone de gráfico crescente.

## Suporte

Esta implementação segue os mesmos padrões de código e design do sistema existente, mantendo consistência visual e funcional com as outras seções da aplicação.