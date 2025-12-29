# Sistema de Multas de Clientes

## 📋 Visão Geral

Sistema completo para aplicar e gerenciar multas diretamente aos clientes, separado das multas aplicadas em pagamentos de empréstimos.

## 🎯 Funcionalidades Implementadas

### 1. **Aplicação de Multas**
- ⚠️ Botão com ícone de exclamação na aba de **Empréstimos**
- Modal intuitivo para registrar multas
- Campos disponíveis:
  - **Valor da multa** (obrigatório)
  - **Motivo** (obrigatório) - Dropdown com opções:
    - Atraso no pagamento
    - Inadimplência
    - Descumprimento de contrato
    - Cobrança judicial
    - Outros
  - **Observações** (opcional)

### 2. **Visualização no Histórico do Cliente**
- Novo card no resumo: **"⚠️ Total em Multas"**
- Mostra o total acumulado de multas do cliente
- Cor âmbar (laranja) para destaque visual
- Tabela dedicada: **"Histórico de Multas do Cliente"**
  - Data da multa
  - Valor
  - Motivo
  - Observações
  - Usuário que aplicou

### 3. **Visualização no Histórico de Pagamentos**
- Seção separada: **"⚠️ Multas Aplicadas aos Clientes"**
- Mostra multas dos últimos 7 dias
- Filtros por período (igual aos pagamentos)
- Inclui no total de multas do período

## 🗄️ Estrutura do Banco de Dados

### Tabela: `client_fines`

```sql
CREATE TABLE client_fines (
    id UUID PRIMARY KEY,
    client_id UUID REFERENCES clients(id),
    amount DECIMAL(10, 2) NOT NULL,
    reason TEXT,
    notes TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

**Campos:**
- `id`: Identificador único da multa
- `client_id`: Referência ao cliente
- `amount`: Valor da multa em reais
- `reason`: Motivo da aplicação da multa
- `notes`: Observações adicionais
- `created_by`: Usuário que aplicou a multa
- `created_at`: Data e hora de criação
- `updated_at`: Data e hora da última atualização

## 🚀 Como Usar

### Aplicar uma Multa ao Cliente

1. Acesse a aba **"Empréstimos"**
2. Localize o cliente na tabela
3. Clique no botão **⚠️** (ícone de exclamação amarelo) na coluna de Ações
4. No modal que abrir:
   - Confirme o nome do cliente
   - Digite o valor da multa (ex: 50.00)
   - Selecione o motivo no dropdown
   - Adicione observações se necessário
5. Clique em **"Aplicar Multa"**

### Visualizar Multas de um Cliente

#### Opção 1: Aba Histórico Completo
1. Acesse **"Relatórios" → "Histórico Completo"**
2. Busque e selecione o cliente
3. No resumo, veja **"⚠️ Total em Multas"**
4. Role até a seção **"Histórico de Multas do Cliente"**
5. Veja todas as multas aplicadas com detalhes

#### Opção 2: Histórico de Pagamentos
1. Acesse **"Relatórios" → "Histórico de Pagamentos"**
2. Veja a seção **"⚠️ Multas Aplicadas aos Clientes"**
3. Mostra multas dos últimos 7 dias de todos os clientes
4. Total de multas incluído no card de resumo

## 📊 Localização dos Elementos

### Na Aba de Empréstimos
```
┌─────────────────────────────────────────────────┐
│ Cliente │ Valor │ ... │ Ações                   │
├─────────────────────────────────────────────────┤
│ João    │ 1000  │ ... │ ✏️ 💰 📄 📑 ✅ 📞 👥 ⚠️ 🗑️│
│                             └─ Novo botão!      │
└─────────────────────────────────────────────────┘
```

### No Histórico do Cliente
```
┌────────────────────────────────────────────┐
│ RESUMO DO CLIENTE                          │
├────────────────────────────────────────────┤
│ Total de    │ Valor Total  │ Total  │ ⚠️ Total │ Valor   │
│ Empréstimos │ Emprestado   │ Pago   │ em Multas│ Restante│
│             │              │        │ R$ 150,00│         │
└────────────────────────────────────────────┘

┌────────────────────────────────────────────┐
│ ⚠️ HISTÓRICO DE MULTAS DO CLIENTE         │
├──────┬─────────┬──────────┬───────────────┤
│ Data │ Valor   │ Motivo   │ Observações   │
├──────┼─────────┼──────────┼───────────────┤
│12/10 │ R$ 50,00│ Atraso   │ Aviso prévio  │
└──────┴─────────┴──────────┴───────────────┘
```

### No Histórico de Pagamentos
```
┌────────────────────────────────────────────┐
│ RESUMO DO PERÍODO                          │
├────────────────────────────────────────────┤
│ Total     │ Número de  │ Total Multas     │
│ Recebido  │ Pagamentos │ R$ 200,00        │
│           │            │ (pagamentos +    │
│           │            │  multas clientes)│
└────────────────────────────────────────────┘

┌────────────────────────────────────────────┐
│ ⚠️ MULTAS APLICADAS AOS CLIENTES          │
├──────┬─────────┬─────────┬────────────────┤
│ Data │ Cliente │ Valor   │ Motivo         │
├──────┼─────────┼─────────┼────────────────┤
│12/10 │ Maria S.│ R$ 50,00│ Inadimplência  │
│11/10 │ João P. │ R$ 100,00│Cobrança judicial│
└──────┴─────────┴─────────┴────────────────┘
```

## 🔧 Arquivos Modificados

### Novos Arquivos
- `setup-client-fines-table.sql` - Script de criação da tabela
- `README-sistema-multas-clientes.md` - Esta documentação

### Arquivos Modificados
1. **`index.html`**
   - Novo modal: `addClientFineModal`
   - Nova coluna no resumo do cliente: `historyTotalFines`
   - Nova tabela: `historyClientFinesTableBody` (Histórico Completo)
   - Nova tabela: `clientFinesTableBody` (Histórico de Pagamentos)

2. **`app.js`**
   - Funções de gerenciamento de multas:
     - `openAddClientFineModal(clientId, clientName)`
     - `closeAddClientFineModal()`
     - `getClientFines(clientId)`
     - `getTotalClientFines(clientId)`
     - `renderHistoryClientFinesTable(clientFines)`
     - `renderWeeklyClientFinesTable(clientFines)`
   - Atualização em `renderLoansTable()` - Botão ⚠️ adicionado
   - Atualização em `loadClientHistory()` - Busca e exibe multas
   - Atualização em `loadWeeklyPaymentHistory()` - Inclui multas dos últimos 7 dias
   - Atualização em `updateWeeklyPaymentsSummary()` - Inclui total de multas de clientes

## 🎨 Cores e Ícones

- **Cor Principal**: Amber/Amarelo (`text-amber-400`, `bg-amber-600`)
- **Ícone**: ⚠️ (Ponto de exclamação em triângulo)
- **Destaque**: Fundo levemente amarelo nas linhas de multas

## ⚙️ Instalação

### 1. Executar Script SQL
```bash
# No seu cliente Supabase ou PostgreSQL
psql -U seu_usuario -d seu_banco -f setup-client-fines-table.sql
```

Ou execute manualmente pelo painel do Supabase:
1. Acesse o Supabase Dashboard
2. Vá em "SQL Editor"
3. Cole o conteúdo de `setup-client-fines-table.sql`
4. Execute o script

### 2. Verificar Políticas RLS
As políticas de Row Level Security já estão incluídas no script e permitem:
- ✅ Leitura para usuários autenticados
- ✅ Inserção para usuários autenticados
- ✅ Atualização para usuários autenticados
- ✅ Exclusão para usuários autenticados

## 🔐 Segurança

- Todas as operações requerem autenticação
- RLS (Row Level Security) habilitado
- Validação de dados no frontend e backend
- Registro do usuário que aplicou a multa
- Histórico completo de multas aplicadas

## 📈 Melhorias Futuras (Sugestões)

1. **Edição de Multas**
   - Permitir editar valor e observações de multas
   
2. **Exclusão de Multas**
   - Botão para remover multas incorretas
   - Confirmação obrigatória
   
3. **Relatórios de Multas**
   - PDF com histórico de multas por período
   - Gráficos de multas por motivo
   - Ranking de clientes com mais multas
   
4. **Notificações**
   - Email/SMS ao aplicar multa ao cliente
   - Alerta de multa acumulada
   
5. **Pagamento de Multas**
   - Permitir registrar pagamento de multas
   - Controle de multas pagas/pendentes
   
6. **Multas Automáticas**
   - Aplicar multa automaticamente por atraso
   - Regras configuráveis

## ❓ Perguntas Frequentes

**P: A multa de cliente é diferente da multa em pagamentos?**  
R: Sim! Existem dois tipos:
- **Multa em Pagamento** (`payments.fine_amount`): Aplicada em um pagamento específico de empréstimo
- **Multa de Cliente** (`client_fines.amount`): Aplicada diretamente ao cliente, independente de empréstimo específico

**P: As multas aparecem nos PDFs?**  
R: As multas de pagamentos já aparecem nos PDFs de empréstimos. As multas de clientes aparecem no histórico do cliente. PDFs dedicados para multas de clientes podem ser adicionados como melhoria futura.

**P: Posso deletar uma multa aplicada por engano?**  
R: Atualmente não há interface para isso, mas pode ser feito diretamente no banco de dados. Adicionar essa funcionalidade está nas melhorias sugeridas.

## 🐛 Resolução de Problemas

### Botão ⚠️ não aparece
- Verifique se a tabela foi renderizada corretamente
- Limpe o cache do navegador
- Verifique o console por erros JavaScript

### Modal não abre
- Verifique se o JavaScript carregou completamente
- Verifique se o `client_id` está sendo passado corretamente
- Abra o console do navegador (F12) e veja erros

### Multa não é salva
- Verifique a conexão com o Supabase
- Confirme que a tabela `client_fines` foi criada
- Verifique as políticas RLS
- Veja erros no console do navegador

### Multas não aparecem no histórico
- Confirme que o cliente possui multas registradas
- Verifique se a data das multas está no período correto
- Recarregue a página

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique esta documentação
2. Consulte o console do navegador (F12)
3. Verifique os logs do Supabase
4. Entre em contato com o suporte técnico

---

**Versão**: 1.0  
**Data**: Dezembro 2024  
**Sistema**: Nexus Gestão Financeira
