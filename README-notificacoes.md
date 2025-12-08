# Sistema de Notificações - Botão de Notificações

## 📋 Resumo

Foi implementado um sistema completo de notificações no header da aplicação que exibe:
- ⚠️ **Parcelamentos vencidos** - Todas as parcelas de parcelamentos que já passaram da data de vencimento
- 📅 **Empréstimos que vencem hoje** - Empréstimos ativos com vencimento na data atual

## ✨ Funcionalidades Implementadas

### 1. Botão de Notificações no Header
- Ícone de sino no canto superior direito
- Badge com contador de notificações (pulsa quando há notificações)
- Clique no botão abre/fecha o dropdown de notificações

### 2. Dropdown de Notificações
- Lista todas as notificações ordenadas por data de vencimento (mais antigas primeiro)
- Cada notificação mostra:
  - Ícone indicativo (⚠️ para vencidos, 📅 para vencimentos hoje)
  - Título da notificação
  - Nome do cliente
  - Data/dias de atraso
  - Valor envolvido
  - Número da parcela (para parcelamentos)
- Scroll customizado para melhor UX
- Fecha automaticamente ao clicar fora

### 3. Navegação Inteligente
- Ao clicar em uma notificação de parcelamento vencido:
  - Navega para a aba "Parcelamentos"
  - Abre automaticamente os detalhes do parcelamento
- Ao clicar em uma notificação de empréstimo:
  - Navega para a aba "Empréstimos"
  - Abre o histórico de pagamentos do empréstimo

### 4. Atualização Automática
- As notificações são carregadas ao iniciar a aplicação
- Atualização automática a cada 5 minutos
- Badge é atualizado automaticamente com o número total de notificações

## 🎨 Design

### Cores e Estilos
- **Parcelamentos Vencidos**: Fundo vermelho escuro (red-900/30) com borda vermelha
- **Empréstimos Hoje**: Fundo amarelo escuro (yellow-900/30) com borda amarela
- **Badge**: Vermelho vibrante com animação de pulso
- **Dropdown**: Dark theme consistente com o resto da aplicação

### Animações
- Badge pulsa suavemente
- Dropdown com scroll personalizado
- Hover effects nos cards de notificação

## 🔧 Arquivos Modificados

### index.html
- Adicionado botão de notificações no header (linha ~567)
- Adicionado dropdown de notificações
- Estilos CSS para notificações (linha ~212)

### app.js
- `loadNotifications()` - Carrega todas as notificações
- `getOverdueInstallments()` - Busca parcelamentos vencidos do Supabase
- `getLoansDueToday()` - Busca empréstimos que vencem hoje
- `renderNotifications()` - Renderiza a lista de notificações no DOM
- `updateNotificationsBadge()` - Atualiza o contador visual
- `handleNotificationClick()` - Gerencia cliques nas notificações
- `navigateToSection()` - Navegação programática entre seções
- `initNotifications()` - Inicializa o sistema ao carregar a app
- `toggleNotifications()` - Abre/fecha o dropdown

## 📊 Lógica de Negócio

### Parcelamentos Vencidos
- Busca todos os parcelamentos com status "active"
- Filtra os `installment_payments` com status "pending"
- Identifica quais têm `due_date` anterior à data atual
- Cada pagamento vencido gera uma notificação individual

### Empréstimos que Vencem Hoje
- Busca empréstimos com `due_date` igual à data atual
- Exclui empréstimos já quitados (status ≠ 'paid')
- Calcula o valor restante usando `calculateBatchLoanRemainingAmounts()`
- Cada empréstimo gera uma notificação

## 🚀 Como Usar

1. **Visualizar Notificações**: Clique no ícone de sino no header
2. **Ver Detalhes**: Clique em qualquer notificação para ser direcionado aos detalhes
3. **Fechar Dropdown**: Clique fora do dropdown ou no botão novamente

## 💡 Melhorias Futuras (Sugestões)

- [ ] Som de notificação quando novas notificações aparecem
- [ ] Notificações push no navegador
- [ ] Filtros por tipo de notificação
- [ ] Marcar notificações como lidas
- [ ] Configurar lembretes antecipados (ex: avisar 3 dias antes do vencimento)
- [ ] Export de lista de notificações para PDF
- [ ] Envio automático de WhatsApp para clientes com notificações

## 🐛 Tratamento de Erros

- Erros na busca de dados são logados no console
- Mensagens amigáveis são exibidas ao usuário
- Fallback para arrays vazios em caso de erro
- Verificações de null/undefined em todos os pontos críticos

## ✅ Status

✅ Todos os componentes implementados e testados
✅ Sintaxe JavaScript validada
✅ Sem erros de linter
✅ Integração completa com sistema existente
