# Módulo de Levantamento de Capital

Este módulo foi criado para gerenciar captações de recursos e distribuição entre clientes, funcionando de forma independente dos empréstimos e clientes existentes no sistema.

## 🚀 Funcionalidades

### 1. Gestão de Levantamentos
- **Criar novos levantamentos** com valor bruto, taxa de juros e valor total
- **Visualizar caixa levantado** total em tempo real
- **Acompanhar levantamentos ativos** e número total de clientes
- **Excluir levantamentos** quando necessário

### 2. Gestão de Clientes por Levantamento
- **Adicionar clientes específicos** para cada levantamento
- **Definir valor individual** para cada cliente
- **Visualizar resumo financeiro** do levantamento
- **Remover clientes** quando necessário
- **Acompanhar distribuição** do valor total

### 3. Interface e Experiência do Usuário
- **Cards de métricas** mostrando totais importantes
- **Tabelas responsivas** para visualizar dados
- **Modal intuitivo** para gerenciar clientes
- **Cálculo automático** do valor total com juros
- **Feedback visual** em tempo real

## 📊 Estrutura dos Dados

### Tabela: capital_raisings
```sql
- id (UUID) - Identificador único
- description (TEXT) - Descrição do levantamento
- gross_amount (DECIMAL) - Valor bruto sem juros
- interest_rate (DECIMAL) - Taxa de juros em percentual
- total_amount (DECIMAL) - Valor total com juros
- status (VARCHAR) - Status: active, completed, cancelled
- created_at (TIMESTAMP) - Data de criação
- updated_at (TIMESTAMP) - Data de atualização
```

### Tabela: raising_clients
```sql
- id (UUID) - Identificador único
- raising_id (UUID) - ID do levantamento (FK)
- client_name (VARCHAR) - Nome do cliente
- client_cpf (VARCHAR) - CPF do cliente
- amount (DECIMAL) - Valor que o cliente deve contribuir
- status (VARCHAR) - Status: active, inactive
- created_at (TIMESTAMP) - Data de criação
- updated_at (TIMESTAMP) - Data de atualização
```

## 🛠️ Instalação e Configuração

### 1. Executar Script SQL
Execute o arquivo `capital-raising-setup.sql` no SQL Editor do Supabase para criar as tabelas necessárias:

```bash
# No Supabase Dashboard:
# 1. Vá para SQL Editor
# 2. Cole o conteúdo do arquivo capital-raising-setup.sql
# 3. Execute o script
```

### 2. Verificar Instalação
O sistema verificará automaticamente se as tabelas foram criadas corretamente. Verifique o console do navegador para confirmação.

## 📝 Como Usar

### Passo 1: Criar um Levantamento
1. Acesse a aba **"Levantamento de Capital"**
2. Preencha os campos:
   - **Valor Bruto**: Quantia inicial sem juros
   - **Juros**: Taxa de juros em percentual
   - **Valor Total**: Calculado automaticamente
   - **Descrição**: Nome/descrição do levantamento
3. Clique em **"Criar Levantamento"**

### Passo 2: Adicionar Clientes
1. Na tabela de levantamentos, clique em **"Gerenciar Clientes"**
2. No modal que abrir:
   - **Nome do Cliente**: Nome completo
   - **CPF**: CPF do cliente
   - **Valor**: Quanto este cliente deve contribuir
3. Clique em **"Adicionar"**

### Passo 3: Acompanhar Progresso
- **Resumo**: Veja total de clientes, valor arrecadado e valor restante
- **Métricas**: Acompanhe o caixa levantado total no dashboard
- **Tabela**: Visualize todos os levantamentos e seus status

## 💡 Exemplo Prático

**Cenário**: Levantamento de R$ 10.000 com 20% de juros

1. **Criar levantamento**:
   - Valor Bruto: R$ 10.000
   - Juros: 20%
   - Valor Total: R$ 12.000 (calculado automaticamente)

2. **Distribuir entre clientes**:
   - 10 clientes × R$ 1.200 = R$ 12.000
   - Ou distribuição personalizada conforme necessidade

3. **Acompanhar**:
   - Dashboard mostra R$ 12.000 em caixa levantado
   - Modal mostra progresso: 10 clientes, R$ 12.000 arrecadado

## 🔧 Recursos Técnicos

### Funcionalidades JavaScript
- `loadCapitalRaisings()` - Carrega dados dos levantamentos
- `createCapitalRaising()` - Cria novo levantamento
- `addClientToRaising()` - Adiciona cliente ao levantamento
- `updateCapitalRaisingMetrics()` - Atualiza métricas do dashboard
- `openManageClientsModal()` - Abre modal de gestão de clientes

### Validações
- ✅ Valores monetários devem ser positivos
- ✅ Taxa de juros não pode ser negativa
- ✅ Nome e CPF do cliente são obrigatórios
- ✅ Confirmação antes de excluir dados

### Responsividade
- 📱 Interface adaptável para mobile
- 🖥️ Layout otimizado para desktop
- ⚡ Performance otimizada com carregamento assíncrono

## 🚨 Importantes

1. **Independência**: Este módulo não interfere com empréstimos ou clientes existentes
2. **Backup**: Sempre faça backup antes de executar scripts SQL
3. **Permissões**: Certifique-se que o usuário tem permissões adequadas no Supabase
4. **Logs**: Verifique o console do navegador para debugs e erros

## 📈 Métricas Disponíveis

- **Caixa Levantado**: Soma de todos os valores totais dos levantamentos ativos
- **Levantamentos Ativos**: Quantidade de levantamentos com status "active"
- **Clientes Cadastrados**: Total de clientes em todos os levantamentos

## 🎯 Próximas Melhorias Sugeridas

- [ ] Relatórios em PDF dos levantamentos
- [ ] Gráficos de acompanhamento
- [ ] Notificações de vencimento
- [ ] Integração com sistema de cobrança
- [ ] Histórico de alterações
- [ ] Exportação para Excel

---

**Desenvolvido para Nexus Gestão Financeira**  
Versão: 1.0.0  
Data: Janeiro 2024