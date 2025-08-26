# Funcionalidade de Cancelamento e Quitação de Empréstimos

## Visão Geral

Esta funcionalidade permite cancelar e quitar empréstimos, movendo-os automaticamente da tabela `loans` para as tabelas `cancelled_loans` e `paid_loans` respectivamente, mantendo um histórico completo de todas as operações.

## Como Funciona

### 1. Processo de Cancelamento

Quando um empréstimo é cancelado:

1. **Cálculo de Valores**: O sistema calcula o total pago antes do cancelamento
2. **Inserção na Tabela de Cancelados**: Os dados são movidos para `cancelled_loans`
3. **Remoção da Tabela Principal**: O empréstimo é removido da tabela `loans`
4. **Atualização da Interface**: Todas as tabelas e gráficos são atualizados

### 2. Processo de Quitação

Quando um empréstimo é marcado como quitado:

1. **Cálculo de Valores**: O sistema calcula o total com juros e total pago
2. **Inserção na Tabela de Quitados**: Os dados são movidos para `paid_loans`
3. **Remoção da Tabela Principal**: O empréstimo é removido da tabela `loans`
4. **Atualização da Interface**: Todas as tabelas e gráficos são atualizados

### 3. Dados Armazenados

#### Tabela `cancelled_loans` (Cancelados)
- **Informações do Empréstimo**: Valor, juros, datas, etc.
- **Dados do Cancelamento**: Data, motivo, usuário que cancelou
- **Informações Financeiras**: Total pago, valor de reembolso, taxa de cancelamento
- **Rastreabilidade**: Quem criou e quem cancelou o empréstimo

#### Tabela `paid_loans` (Quitados)
- **Informações do Empréstimo**: Valor, juros, datas, etc.
- **Dados da Quitação**: Data de quitação, método de pagamento
- **Informações Financeiras**: Total com juros, total pago
- **Rastreabilidade**: Quem criou o empréstimo original

## Configuração do Banco de Dados

### 1. Executar Scripts SQL

Execute os seguintes arquivos no SQL Editor do Supabase:

1. **`setup-cancelled-loans.sql`** - Para tabela de empréstimos cancelados
2. **`setup-paid-loans.sql`** - Para tabela de empréstimos quitados

```sql
-- Acesse o SQL Editor no Supabase
-- Cole o conteúdo do arquivo setup-cancelled-loans.sql
-- Clique em "Run"
```

### 2. Verificar Criação

Após a execução, verifique se:

- ✅ Tabela `cancelled_loans` foi criada
- ✅ Tabela `paid_loans` foi criada
- ✅ Índices foram criados
- ✅ Políticas RLS estão ativas
- ✅ Permissões foram concedidas

## Uso da Funcionalidade

### 1. Cancelar um Empréstimo

1. Na tabela de empréstimos ativos, clique em **"Excluir"**
2. Confirme o cancelamento na janela de confirmação
3. O empréstimo será movido para a tabela de cancelados

### 2. Quitar um Empréstimo

1. Na tabela de empréstimos ativos, clique em **"Marcar como Quitado"**
2. Confirme a quitação na janela de confirmação
3. O empréstimo será movido para a tabela de quitados

### 3. Visualizar Empréstimos Cancelados

1. Acesse a aba **"Empréstimos Cancelados"**
2. Veja todos os empréstimos cancelados com detalhes
3. Use os botões de ação para cada registro

### 4. Visualizar Empréstimos Quitados

1. Acesse a aba **"Empréstimos Quitados"**
2. Veja todos os empréstimos quitados com detalhes
3. Use os botões de ação para cada registro

### 5. Ações Disponíveis

#### Para Empréstimos Cancelados:
- **📋 Detalhes**: Ver informações completas
- **🔄 Restaurar**: Recriar o empréstimo na tabela principal
- **🗑️ Excluir**: Remover permanentemente do histórico

#### Para Empréstimos Quitados:
- **📋 Detalhes**: Ver informações completas
- **🔄 Restaurar**: Recriar o empréstimo na tabela principal
- **🗑️ Excluir**: Remover permanentemente do histórico

## Estrutura das Tabelas

### Tabela `loans` (Principal)
```sql
-- Empréstimos ativos e vencidos
-- NÃO contém mais empréstimos quitados ou cancelados
```

### Tabela `paid_loans` (Quitados)
```sql
-- Histórico completo de empréstimos quitados
-- Mantém todos os dados originais + informações de quitação
```

### Tabela `cancelled_loans` (Cancelados)
```sql
-- Histórico completo de empréstimos cancelados
-- Mantém todos os dados originais + informações de cancelamento
```

## Benefícios da Implementação

### 1. **Integridade dos Dados**
- Empréstimos cancelados não aparecem mais nas listas ativas
- Histórico completo preservado
- Separação clara entre status

### 2. **Rastreabilidade**
- Quem cancelou cada empréstimo
- Quando foi cancelado
- Motivo do cancelamento
- Valor pago antes do cancelamento

### 3. **Flexibilidade**
- Possibilidade de restaurar empréstimos cancelados
- Histórico para auditoria
- Relatórios separados por status

### 4. **Performance**
- Tabela `loans` mais limpa
- Consultas mais rápidas
- Índices otimizados

## Casos de Uso

### 1. **Cancelamento por Solicitação do Cliente**
- Cliente solicita cancelamento
- Sistema registra motivo e dados
- Empréstimo movido para histórico

### 2. **Cancelamento por Problemas Técnicos**
- Erro na criação do empréstimo
- Sistema detecta inconsistências
- Cancelamento automático com registro

### 3. **Cancelamento por Política da Empresa**
- Mudança nas condições
- Aplicação de novas regras
- Cancelamento com justificativa

## Monitoramento e Relatórios

### 1. **Dashboard Atualizado**
- Contador de empréstimos cancelados
- Gráficos sem interferência de cancelados
- Métricas mais precisas

### 2. **Relatórios de Cancelamento**
- Total de cancelamentos por período
- Motivos mais comuns
- Usuários que mais cancelam

### 3. **Auditoria**
- Histórico completo de ações
- Rastreamento de mudanças
- Conformidade com regulamentações

## Manutenção

### 1. **Limpeza Periódica**
- Empréstimos cancelados muito antigos
- Arquivos de backup
- Otimização de performance

### 2. **Atualizações**
- Novos campos conforme necessário
- Melhorias na interface
- Novas funcionalidades

## Troubleshooting

### Problema: Tabela não encontrada
**Solução**: Execute o script `setup-cancelled-loans.sql`

### Problema: Erro de permissão
**Solução**: Verifique as políticas RLS e permissões

### Problema: Dados não aparecem
**Solução**: Verifique se a função `renderCancelledLoansTable()` está sendo chamada

### Problema: Erro ao cancelar
**Solução**: Verifique logs do console e permissões do usuário

## Próximos Passos

### 1. **Melhorias Futuras**
- Interface mais intuitiva para cancelamento
- Relatórios avançados
- Integração com sistema de notificações

### 2. **Funcionalidades Adicionais**
- Cancelamento em lote
- Templates de motivos
- Workflow de aprovação

### 3. **Integrações**
- Sistema de auditoria externo
- Relatórios automáticos
- APIs para terceiros

## Suporte

Para dúvidas ou problemas:

1. Verifique os logs do console do navegador
2. Confirme a estrutura do banco de dados
3. Teste as permissões do usuário
4. Consulte a documentação do Supabase

---

**Nota**: Esta funcionalidade foi implementada seguindo as melhores práticas de desenvolvimento e segurança, garantindo a integridade dos dados e a rastreabilidade das operações. 