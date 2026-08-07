# 🔧 FIX: Erros de Database no Sistema Franca Private

## 📋 Resumo do Problema

O sistema Franca Private está apresentando múltiplos erros 404, 400 e 409 ao tentar acessar tabelas do banco de dados que não existem ou estão mal configuradas.

### Erros Identificados:

1. **Erro 404** - Tabelas não encontradas:
   - `cash_settings` - Configurações do caixa
   - `cash_transactions` - Transações de caixa
   - `capital_raising` - Levantamentos de capital
   - `paid_loans` - Empréstimos quitados
   - `guarantors` - Avalistas dos clientes

2. **Erro 400** - Requisições mal formadas:
   - Constraint inválida na coluna `payment_type` da tabela `payments`
   - Falta de permissões RLS

3. **Erro 409** - Conflitos (possivelmente por constraints ausentes ou RLS incorreto)

### Mensagens de Erro no Console:

```javascript
❌ Erro ao carregar configurações de caixa
❌ Erro ao carregar transações de caixa
❌ Erro ao carregar levantamentos de capital
❌ Erro ao buscar empréstimos quitados
❌ Database error
❌ Guarantor database error
❌ ERRO ao renovar empréstimo
```

## 🎯 Solução

Foi criado um script SQL completo que:

1. ✅ Cria todas as tabelas ausentes
2. ✅ Configura índices para performance
3. ✅ Adiciona triggers para atualização automática
4. ✅ Configura políticas RLS (Row Level Security)
5. ✅ Cria views úteis para relatórios
6. ✅ Concede permissões adequadas
7. ✅ **Corrige a constraint de `payment_type`** na tabela `payments`

## 📝 Instruções de Aplicação

### Passo 1: Acesse o Supabase

1. Abra o [Supabase Dashboard](https://supabase.com/dashboard)
2. Selecione o projeto **Franca Private**
3. No menu lateral, clique em **SQL Editor**

### Passo 2: Execute o Script de Correção

1. Abra o arquivo: `fix-franca-private-database-complete.sql`
2. Copie **TODO** o conteúdo do arquivo
3. Cole no SQL Editor do Supabase
4. Clique no botão **"Run"** (ou pressione Ctrl+Enter)

### Passo 3: Verifique a Execução

Após executar o script, você deve ver mensagens de sucesso como:

```
✓ Constraint de payment_type removida com sucesso
✓ Tabela guarantors criada com sucesso
✓ Tabela cash_transactions criada com sucesso
✓ Tabela cash_settings criada com sucesso
✓ Tabela capital_raising criada com sucesso
✓ Tabela capital_raising_clients criada com sucesso
✓ Tabela paid_loans criada com sucesso

INSTALAÇÃO CONCLUÍDA COM SUCESSO!
```

### Passo 4: Teste a Aplicação

1. Abra a aplicação Franca Private
2. Pressione **F5** para recarregar a página
3. Verifique o console do navegador (F12)
4. Os erros 404 devem ter desaparecido

## 🗂️ Tabelas Criadas

### 1. **guarantors** (Avalistas)
Armazena informações dos avalistas dos clientes.

**Campos principais:**
- `client_id` - Referência ao cliente
- `name`, `cpf`, `rg` - Dados pessoais
- `phone`, `email` - Contatos
- `relationship` - Relacionamento com o cliente

### 2. **cash_transactions** (Transações de Caixa)
Registra todas as entradas e saídas de dinheiro.

**Campos principais:**
- `transaction_type` - 'deposit' ou 'withdrawal'
- `amount` - Valor da transação
- `balance_after` - Saldo após a transação
- `reference_id` - Referência a empréstimo/despesa

### 3. **cash_settings** (Configurações do Caixa)
Armazena o saldo atual e configurações do caixa.

**Campos principais:**
- `current_balance` - Saldo atual
- `initial_balance` - Saldo inicial
- `last_updated` - Data da última atualização

### 4. **capital_raising** (Levantamento de Capital)
Gerencia levantamentos de capital independentes.

**Campos principais:**
- `nome` - Nome/descrição do levantamento
- `valor_bruto` - Valor bruto inicial
- `taxa_juros` - Taxa de juros aplicada
- `valor_total` - Valor total com juros

### 5. **capital_raising_clients** (Clientes de Levantamento)
Clientes vinculados a levantamentos de capital.

**Campos principais:**
- `capital_raising_id` - Referência ao levantamento
- `nome`, `cpf`, `telefone` - Dados do cliente
- `valor_individual` - Valor que o cliente deve contribuir

### 6. **paid_loans** (Empréstimos Quitados)
Armazena histórico de empréstimos completamente pagos.

**Campos principais:**
- `loan_id` - ID original do empréstimo
- `client_id` - Referência ao cliente
- `original_amount` - Valor original
- `paid_date` - Data da quitação
- `total_paid` - Total pago

## 🔒 Segurança (RLS)

Todas as tabelas foram configuradas com Row Level Security (RLS) ativado e políticas que permitem:

- ✅ Usuários autenticados podem **visualizar** todos os registros
- ✅ Usuários autenticados podem **inserir** novos registros
- ✅ Usuários autenticados podem **atualizar** registros
- ✅ Usuários autenticados podem **excluir** registros

## 🚀 Funcionalidades Habilitadas

Após aplicar o fix, as seguintes funcionalidades estarão disponíveis:

### Gestão de Caixa
- ✅ Visualizar saldo atual
- ✅ Registrar entradas/depósitos
- ✅ Registrar saídas/retiradas
- ✅ Histórico de transações
- ✅ Relatórios de fluxo de caixa

### Levantamento de Capital
- ✅ Criar levantamentos
- ✅ Adicionar clientes ao levantamento
- ✅ Calcular juros automaticamente
- ✅ Dar baixa em levantamentos

### Avalistas
- ✅ Cadastrar avalistas para clientes
- ✅ Visualizar avalistas por cliente
- ✅ Editar informações de avalistas
- ✅ Excluir avalistas

### Empréstimos Quitados
- ✅ Registrar quitação de empréstimos
- ✅ Histórico de empréstimos pagos
- ✅ Relatórios de quitações
- ✅ Movimentação para tabela de histórico

## 🔧 Correção de Constraint: payment_type

### Problema Original
A tabela `payments` tinha uma constraint `CHECK` que permitia apenas os valores `'partial'` e `'full'` na coluna `payment_type`.

### Por que isso causava erro?
O sistema foi atualizado para usar valores mais descritivos e específicos:
- `interest_renewal` - Renovação (pagamento apenas de juros)
- `capital_payment` - Pagamento de capital
- `early_payment_partial_interest` - Pagamento antecipado parcial de juros
- `early_payment_interest_renewal` - Pagamento antecipado com renovação
- `early_payment_capital_reduction` - Redução antecipada de capital
- `loan_renewal` - Renovação do empréstimo
- `loan_reactivation` - Reativação de empréstimo
- `partial_interest` - Pagamento parcial de juros

### Solução Aplicada
O script remove a constraint antiga, permitindo que a coluna aceite qualquer valor TEXT. Isso é seguro porque:
- ✅ A validação é feita no nível da aplicação
- ✅ Permite flexibilidade para novos tipos de pagamento
- ✅ Mantém histórico correto das operações
- ✅ Não afeta pagamentos existentes

## 🔄 Triggers Automáticos

### 1. Atualização de Timestamps
Todas as tabelas têm triggers que atualizam automaticamente o campo `updated_at` quando um registro é modificado.

### 2. Atualização de Saldo do Caixa
Quando uma transação é inserida em `cash_transactions`, o saldo em `cash_settings` é atualizado automaticamente.

### 3. Atualização de Timestamps do Capital
Quando um levantamento de capital é modificado, o campo `data_atualizacao` é atualizado automaticamente.

## 📊 Views Criadas

### 1. **cash_transactions_summary**
Resumo de transações por período e tipo.

### 2. **daily_cash_balance**
Balanço diário com fluxo e saldo acumulado.

### 3. **paid_loans_with_details**
Empréstimos quitados com informações completas do cliente.

## ⚠️ Observações Importantes

### Backup
- O script usa `CREATE TABLE IF NOT EXISTS`, então é seguro executar múltiplas vezes
- Não há risco de perder dados existentes

### Dependências
- As tabelas `users` e `clients` devem existir antes de executar o script
- O script cria foreign keys para essas tabelas

### RLS (Row Level Security)
- Todas as políticas RLS estão configuradas para usuários autenticados
- Se precisar de políticas mais restritivas, modifique as políticas após a criação

## 🐛 Troubleshooting

### Erro: "relation users does not exist"
**Solução:** A tabela `users` precisa existir primeiro. Execute o script completo do banco de dados base.

### Erro: "relation clients does not exist"
**Solução:** A tabela `clients` precisa existir primeiro. Execute o script completo do banco de dados base.

### Erro: "permission denied"
**Solução:** Verifique se você está executando o script como um usuário com permissões de administrador no Supabase.

### Ainda vejo erros 404
**Solução:** 
1. Limpe o cache do navegador (Ctrl+Shift+Delete)
2. Faça um hard refresh (Ctrl+F5)
3. Verifique se o script foi executado sem erros
4. Verifique se as tabelas existem no Table Editor do Supabase

### Erro ao renovar empréstimo
**Solução:** Verifique se a tabela `payments` tem a coluna `payment_type` e se aceita os valores esperados.

## 📞 Suporte

Se os erros persistirem após aplicar o fix:

1. Verifique o console do navegador (F12) para mensagens de erro específicas
2. Verifique os logs do SQL Editor no Supabase
3. Confirme que todas as tabelas foram criadas no Table Editor
4. Verifique se as políticas RLS estão ativas

## ✅ Checklist de Verificação

Após aplicar o fix, marque os itens verificados:

- [ ] Script executado sem erros no SQL Editor
- [ ] Tabela `guarantors` aparece no Table Editor
- [ ] Tabela `cash_transactions` aparece no Table Editor
- [ ] Tabela `cash_settings` aparece no Table Editor
- [ ] Tabela `capital_raising` aparece no Table Editor
- [ ] Tabela `capital_raising_clients` aparece no Table Editor
- [ ] Tabela `paid_loans` aparece no Table Editor
- [ ] Aplicação recarregada (F5)
- [ ] Erros 404 não aparecem mais no console
- [ ] Funcionalidades de caixa estão acessíveis
- [ ] Funcionalidades de levantamento de capital estão acessíveis
- [ ] Funcionalidades de avalistas estão acessíveis

## 📅 Histórico

- **Data:** 10 de Dezembro de 2024
- **Versão:** 1.0
- **Autor:** Cursor AI Assistant
- **Sistema:** Franca Private - Sistema de Gestão Financeira

---

**🎉 Após aplicar este fix, o sistema Franca Private deve funcionar corretamente sem os erros de database!**
