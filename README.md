# Nexus Gestão Financeira

Sistema completo de gestão financeira para controle de clientes, empréstimos e parcelamentos.

## Funcionalidades Implementadas

### 🔐 Autenticação
- Sistema de login seguro
- Controle de acesso por usuário
- Sessões persistentes

### 👥 Gestão de Clientes
- **Cadastro completo** com foto, CPF, contato e endereço
- **Edição completa** de todos os dados do cliente
- **Exclusão inteligente** com validação de empréstimos ativos
- Upload de fotos via Uploadcare
- Histórico de empréstimos por cliente

### 💰 Gestão de Empréstimos
- **Criação** de empréstimos com cálculo automático de juros
- **Edição completa** de todos os dados do empréstimo
- **Exclusão** com confirmação detalhada
- Controle de status (Ativo, Pago, Vencido, Cancelado)
- Cálculo automático de valores totais
- Seleção de clientes existentes

### 📊 Parcelamento
- **Gestão de empréstimos vencidos**
- **Edição** de empréstimos vencidos
- **Exclusão** de empréstimos vencidos
- **Registro de pagamentos parciais**
- Cálculo de dias de vencimento

### 📈 Dashboard e Relatórios
- Métricas em tempo real
- Gráficos interativos
- Resumo financeiro por períodos
- Estatísticas de crescimento

## Funcionalidades de Edição e Exclusão

### ✏️ Edição de Clientes
- Modal dedicado para edição
- Preservação da foto atual
- Validação de dados obrigatórios
- Atualização em tempo real
- Notificações de sucesso

### ✏️ Edição de Empréstimos
- Modal dedicado para edição
- Seleção de cliente
- Cálculo automático de resumo
- Controle de status
- Validação de datas

### 🗑️ Exclusão Inteligente
- **Validação de integridade**: Não permite exclusão de clientes com empréstimos ativos
- **Confirmação detalhada**: Mostra informações completas antes da exclusão
- **Histórico preservado**: Mantém registro de operações
- **Modal de confirmação**: Interface amigável para confirmação

### 🔒 Validações de Segurança
- Verificação de empréstimos ativos antes de excluir clientes
- Confirmação obrigatória para exclusões
- Mensagens informativas detalhadas
- Prevenção de exclusões acidentais

## Tecnologias Utilizadas

- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Estilização**: Tailwind CSS
- **Backend**: Supabase (PostgreSQL)
- **Uploads**: Uploadcare
- **Gráficos**: Chart.js
- **Design**: Interface moderna com tema escuro

## Estrutura do Sistema

### Tabelas do Banco
- `clients`: Dados dos clientes
- `loans`: Registro de empréstimos
- `payments`: Histórico de pagamentos
- `users`: Usuários do sistema

### Funcionalidades Principais
1. **Autenticação e Controle de Acesso**
2. **CRUD Completo de Clientes**
3. **CRUD Completo de Empréstimos**
4. **Gestão de Parcelamentos**
5. **Dashboard com Métricas**
6. **Relatórios e Gráficos**

## Como Usar

### Login
- Email: admin@nexus.com
- Senha: 1020

### Editar Cliente
1. Acesse a aba "Clientes"
2. Clique no botão "Editar" na linha do cliente
3. Modifique os dados desejados
4. Clique em "Atualizar Cliente"

### Editar Empréstimo
1. Acesse a aba "Empréstimos"
2. Clique no botão "Editar" na linha do empréstimo
3. Modifique os dados desejados
4. Clique em "Atualizar Empréstimo"

### Excluir Item
1. Clique no botão "Excluir" do item desejado
2. Confirme a ação no modal de confirmação
3. O sistema validará se a exclusão é segura
4. Confirme novamente se necessário

## Recursos de UX

- **Modais responsivos** para todas as operações
- **Notificações em tempo real** para feedback do usuário
- **Validações visuais** com mensagens claras
- **Confirmações detalhadas** para ações críticas
- **Interface intuitiva** com navegação clara
- **Animações suaves** para melhor experiência

## Segurança

- Validação de dados em frontend e backend
- Verificação de integridade referencial
- Confirmações obrigatórias para exclusões
- Controle de acesso por usuário
- Logs de operações críticas

## Próximas Funcionalidades

- [ ] Histórico de alterações
- [ ] Backup automático de dados
- [ ] Exportação de relatórios
- [ ] Notificações por email
- [ ] API REST para integrações
- [ ] Sistema de auditoria completo 