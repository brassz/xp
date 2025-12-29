# Sistema de Multas para Clientes

## Descrição

Implementação de um sistema completo para aplicar e gerenciar multas diretamente aos clientes, com rastreamento no histórico e visualização em múltiplas áreas do sistema.

## Funcionalidades Implementadas

### 1. Estrutura de Banco de Dados

#### Nova Tabela: `client_fines`

Criada para gerenciar multas aplicadas aos clientes de forma independente dos pagamentos de empréstimos.

**Campos:**
- `id` (UUID) - Identificador único
- `client_id` (UUID) - Referência ao cliente
- `company_id` (UUID) - Referência à empresa
- `fine_amount` (DECIMAL) - Valor da multa
- `description` (TEXT) - Motivo/descrição da multa
- `fine_date` (TIMESTAMP) - Data de aplicação da multa
- `created_by` (UUID) - Usuário que criou a multa
- `created_at` (TIMESTAMP) - Data de criação do registro
- `updated_at` (TIMESTAMP) - Data da última atualização

**Índices criados:**
- `idx_client_fines_client_id` - Para buscar multas por cliente
- `idx_client_fines_company_id` - Para buscar multas por empresa
- `idx_client_fines_fine_date` - Para filtros por período
- `idx_client_fines_created_at` - Para ordenação por criação

**Script SQL:** `setup-client-fines-table.sql`

### 2. Interface de Usuário

#### Botão de Adicionar Multa

**Localização:** Aba de Empréstimos, na coluna de Ações de cada empréstimo

**Características:**
- Ícone: ⚠️ (ponto de exclamação)
- Cor: Âmbar (amber-400)
- Tooltip: "Adicionar Multa ao Cliente"
- Funcionalidade: Abre modal para adicionar multa ao cliente do empréstimo

#### Modal de Adicionar Multa

**Campos:**
- **Cliente**: Exibido automaticamente (somente leitura)
- **Valor da Multa**: Campo numérico obrigatório (R$)
- **Motivo/Descrição**: Campo de texto opcional para justificar a multa

**Validações:**
- Valor deve ser maior que zero
- Cliente deve estar selecionado

**Feedback:**
- Mensagem de sucesso ao adicionar multa
- Atualização automática do histórico se estiver aberto

### 3. Exibição no Histórico do Cliente

#### Card de Total de Multas

Na seção de "Histórico" do cliente, foi adicionado um quinto card no resumo:

**Métricas exibidas:**
1. Total de Empréstimos
2. Valor Total Emprestado
3. Total Pago
4. Valor Restante
5. **Total em Multas** (NOVO) - Exibe o somatório de todas as multas aplicadas ao cliente

**Estilo:** Texto vermelho (red-300/red-400) para destacar as multas

#### Tabela de Histórico de Multas

Nova seção entre a tabela de empréstimos e pagamentos:

**Colunas:**
- **Data**: Data em que a multa foi aplicada
- **Valor**: Valor da multa em R$
- **Descrição**: Motivo ou descrição da multa
- **Aplicado Por**: Nome do usuário que aplicou a multa

**Características:**
- Ordenação por data (mais recente primeiro)
- Mensagem quando não há multas
- Visual consistente com as outras tabelas do sistema

### 4. Funções JavaScript Implementadas

#### Gerenciamento de Multas

```javascript
// Abrir modal de multa
openAddClientFineModal(clientId, clientName)

// Fechar modal de multa
closeAddClientFineModal()

// Salvar multa no banco de dados
saveClientFine(event)

// Buscar total de multas de um cliente
getClientTotalFines(clientId)

// Buscar histórico de multas de um cliente
getClientFinesHistory(clientId)
```

#### Renderização

```javascript
// Renderizar tabela de multas no histórico
renderHistoryFinesTable(clientFines)
```

#### Integração

A função `loadClientHistory()` foi atualizada para:
1. Buscar multas do cliente
2. Calcular total de multas
3. Atualizar card de total de multas
4. Renderizar tabela de histórico de multas

## Como Usar

### Adicionar Multa a um Cliente

1. Navegue até a aba **Empréstimos**
2. Localize o empréstimo do cliente na lista
3. Clique no botão ⚠️ (ponto de exclamação) na coluna de Ações
4. No modal que abrir:
   - Verifique o nome do cliente
   - Digite o valor da multa
   - Opcionalmente, adicione uma descrição
5. Clique em **Adicionar Multa**
6. Confirme a mensagem de sucesso

### Visualizar Multas de um Cliente

1. Navegue até a aba **Histórico**
2. Selecione o cliente no seletor
3. Clique em **Carregar Histórico**
4. Visualize:
   - **Card "Total em Multas"**: Valor total acumulado
   - **Tabela "Histórico de Multas"**: Lista detalhada de todas as multas

### Relatórios e Consultas

O arquivo SQL inclui exemplos de consultas úteis:

```sql
-- Total de multas por cliente
SELECT 
    c.name as cliente,
    COUNT(*) as quantidade_multas,
    SUM(cf.fine_amount) as total_multas
FROM client_fines cf
JOIN clients c ON c.id = cf.client_id
WHERE cf.company_id = 'YOUR_COMPANY_ID'
GROUP BY c.id, c.name
ORDER BY total_multas DESC;

-- Multas por período
SELECT 
    DATE_TRUNC('month', fine_date) as mes,
    COUNT(*) as quantidade_multas,
    SUM(fine_amount) as total_multas
FROM client_fines
WHERE company_id = 'YOUR_COMPANY_ID'
GROUP BY DATE_TRUNC('month', fine_date)
ORDER BY mes DESC;
```

## Arquivos Modificados

### Novos Arquivos
- `setup-client-fines-table.sql` - Script de criação da tabela

### Arquivos Modificados
- `index.html`:
  - Adicionado modal `addClientFineModal`
  - Adicionado card de total de multas no histórico
  - Adicionada tabela de histórico de multas
  
- `app.js`:
  - Adicionado botão de multa na renderização de empréstimos
  - Implementadas funções de gerenciamento de multas
  - Atualizada função `loadClientHistory()`
  - Adicionada função `renderHistoryFinesTable()`

## Observações Importantes

### Diferença entre Multas de Cliente e Multas de Pagamento

**Multas de Cliente** (nova funcionalidade):
- Aplicadas diretamente ao cliente
- Independentes de empréstimos específicos
- Gerenciadas na tabela `client_fines`
- Visíveis no histórico do cliente

**Multas de Pagamento** (já existente):
- Aplicadas a pagamentos específicos
- Parte do registro de pagamento
- Campo `fine_amount` na tabela `payments`
- Visíveis no histórico de pagamentos

### Segurança e Permissões

- A multa registra qual usuário a aplicou (`created_by`)
- Data de aplicação é registrada automaticamente
- Multas não podem ser negativas (constraint do banco)
- Multas estão vinculadas à empresa (`company_id`)

### Performance

- Índices otimizados para consultas comuns
- Cálculos em lote quando possível
- Cache de resultados quando apropriado

## Próximas Melhorias Sugeridas

1. **Funcionalidade de Edição**: Permitir editar multas existentes
2. **Funcionalidade de Exclusão**: Permitir remover multas com justificativa
3. **Histórico de Alterações**: Registrar modificações nas multas
4. **Relatórios Específicos**: PDF de relatório de multas
5. **Notificações**: Alertar cliente sobre multas aplicadas
6. **Pagamento de Multas**: Sistema para quitar multas separadamente
7. **Dashboard de Multas**: Visão geral de multas por período/cliente
8. **Integração com WhatsApp**: Enviar notificação de multa via WhatsApp

## Suporte e Manutenção

Para dúvidas ou problemas:
1. Verifique os logs do navegador (console)
2. Verifique os logs do Supabase
3. Confirme que a tabela `client_fines` foi criada corretamente
4. Verifique as permissões de usuário no Supabase

## Changelog

### Versão 1.0.0 (Dezembro 2025)
- ✅ Criação da tabela `client_fines`
- ✅ Modal para adicionar multas
- ✅ Botão de multa na aba de empréstimos
- ✅ Exibição de total de multas no histórico
- ✅ Tabela de histórico de multas
- ✅ Funções JavaScript completas
- ✅ Documentação inicial
