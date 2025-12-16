# Controle Financeiro - Franca Private

## 📋 Resumo

Nova funcionalidade exclusiva para a empresa **Franca Private** que permite gerenciar um caixa consolidado com base nas comissões do Vinicius de todas as empresas, com adição automática a cada 7 dias.

## 🎯 Funcionalidades

### 1. **Caixa Consolidado**
- Exibe o saldo atual do caixa
- Mostra as comissões do Vinicius de todas as empresas do último mês
- Indica quando será a próxima adição ao caixa (a cada 7 dias)
- Atualiza automaticamente o saldo com base nas transações

### 2. **Comissões Automáticas**
- Busca comissões do Vinicius de **todas as 6 empresas**:
  - FRANCA CRED (66,6%)
  - LITORAL CRED (66,6%)
  - MOGIANA CRED (66,6%)
  - ERECHIM (33,3%)
  - IMPERATRIZ CRED (50%)
  - FRANCA PRIVATE (100%)
- Adiciona automaticamente ao caixa a cada 7 dias
- Registra cada adição no histórico de transações

### 3. **Gestão de Despesas**
- Adicionar despesas com descrição, valor, data e observações
- Despesas são subtraídas automaticamente do caixa
- Registro completo no histórico

### 4. **Gestão de Reinvestimentos**
- Adicionar reinvestimentos com descrição, valor, data e observações
- Reinvestimentos são subtraídos automaticamente do caixa
- Registro completo no histórico

### 5. **Histórico de Transações**
- Visualização completa de todas as transações
- Tipos: Comissão (verde), Despesa (vermelho), Reinvestimento (azul)
- Mostra saldo após cada transação
- Ordenado por data (mais recentes primeiro)

## 🚀 Instalação

### Passo 1: Executar Script SQL

1. Acesse o **Supabase da Franca Private**:
   - URL: https://pebwoerzslfzhjptyjwh.supabase.co

2. Vá para **SQL Editor**

3. Abra o arquivo `setup-financial-control.sql`

4. Copie todo o conteúdo do arquivo

5. Cole no SQL Editor e clique em **Run**

6. Verifique se não há erros na execução

### Passo 2: Verificar Instalação

Execute esta query para verificar se as tabelas foram criadas:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('financial_control', 'financial_transactions', 'commission_cache');
```

Você deve ver 3 tabelas listadas.

## 📱 Como Usar

### Acessar o Controle Financeiro

1. Faça login no **Franca Private** (3 cliques em "Bruno Assoni")
2. Use as credenciais:
   - Email: `admin@francaprivate.com`
   - Senha: `1020`
3. No menu lateral, clique em **"Controle Financeiro"**

> **Nota**: Esta aba só aparece para a empresa Franca Private!

### Atualizar Dados

1. Clique no botão **"Atualizar Dados"**
2. O sistema irá:
   - Buscar comissões de todas as empresas do último mês
   - Verificar se já passaram 7 dias desde a última adição
   - Se sim, adicionar automaticamente as comissões ao caixa
   - Atualizar todos os cards e tabelas

### Adicionar Despesa

1. Clique em **"Adicionar Despesa"**
2. Preencha:
   - Descrição (ex: "Despesas operacionais")
   - Valor (ex: 500.00)
   - Data (padrão: hoje)
   - Observações (opcional)
3. Clique em **"Salvar Despesa"**
4. O valor será subtraído do caixa automaticamente

### Adicionar Reinvestimento

1. Clique em **"Adicionar Reinvestimento"**
2. Preencha:
   - Descrição (ex: "Reinvestimento em negócio")
   - Valor (ex: 1000.00)
   - Data (padrão: hoje)
   - Observações (opcional)
3. Clique em **"Salvar Reinvestimento"**
4. O valor será subtraído do caixa automaticamente

## 📊 Interface

### Cards de Resumo

**1. Caixa Atual**
- Mostra o saldo disponível no caixa
- Cor: Verde
- Indica última atualização

**2. Comissões do Mês**
- Total das comissões do Vinicius de todas as empresas
- Período: Último mês
- Cor: Azul

**3. Próxima Adição**
- Data da próxima adição automática ao caixa
- Quantos dias faltam
- Cor: Amarelo

### Tabela de Transações

Colunas:
- **Data**: Data da transação
- **Tipo**: Comissão / Despesa / Reinvestimento
- **Descrição**: Detalhes da transação
- **Valor**: Valor (positivo em verde, negativo em vermelho)
- **Saldo**: Saldo após a transação

## 🔄 Lógica de Atualização Automática

### A Cada 7 Dias

O sistema verifica automaticamente:

1. Se já passaram 7 dias desde a última adição
2. Se sim:
   - Busca comissões de todas as empresas do último mês
   - Soma total de comissões do Vinicius
   - Adiciona ao caixa
   - Registra transação do tipo "Comissão"
   - Define próxima data de adição (hoje + 7 dias)
   - Exibe notificação de sucesso

### Porcentagens de Comissão por Empresa

| Empresa | Vinicius |
|---------|----------|
| FRANCA CRED | 66,6% |
| LITORAL CRED | 66,6% |
| MOGIANA CRED | 66,6% |
| ERECHIM | 33,3% |
| IMPERATRIZ CRED | 50% |
| FRANCA PRIVATE | 100% |

## 🗄️ Estrutura do Banco de Dados

### Tabela: `financial_control`
- `id`: UUID (chave primária)
- `current_balance`: DECIMAL - Saldo atual
- `last_update`: TIMESTAMP - Última atualização
- `next_addition_date`: DATE - Data da próxima adição
- `created_at`: TIMESTAMP
- `updated_at`: TIMESTAMP

### Tabela: `financial_transactions`
- `id`: UUID (chave primária)
- `type`: VARCHAR - 'commission' | 'expense' | 'reinvestment'
- `description`: TEXT - Descrição
- `amount`: DECIMAL - Valor (+ para entrada, - para saída)
- `transaction_date`: DATE - Data da transação
- `notes`: TEXT - Observações
- `balance_after`: DECIMAL - Saldo após transação
- `created_at`: TIMESTAMP
- `updated_at`: TIMESTAMP

### Tabela: `commission_cache`
- `id`: UUID (chave primária)
- `company_name`: VARCHAR - Nome da empresa
- `commission_amount`: DECIMAL - Valor da comissão
- `period_start`: DATE - Início do período
- `period_end`: DATE - Fim do período
- `cached_at`: TIMESTAMP
- `created_at`: TIMESTAMP

## 🔒 Segurança

- **RLS (Row Level Security)** habilitado em todas as tabelas
- Apenas usuários autenticados podem acessar
- Políticas para SELECT, INSERT, UPDATE e DELETE
- Dados isolados por empresa

## 🎨 Características da Interface

- **Design Moderno**: Glass morphism e gradientes
- **Responsivo**: Funciona em desktop e mobile
- **Cores Intuitivas**:
  - Verde: Entradas/Comissões
  - Vermelho: Saídas/Despesas
  - Azul: Reinvestimentos
- **Feedback Visual**: Loading, sucesso e erro
- **Modais Elegantes**: Formulários limpos e intuitivos

## 📝 Notas Técnicas

### Limitações

1. A busca de comissões considera apenas o **último mês**
2. A adição automática ocorre apenas quando o usuário acessa o sistema (não é um cron job)
3. Requer conexão com os bancos de dados de todas as 6 empresas

### Otimizações

1. Cache de comissões para evitar buscas repetidas
2. Índices nas tabelas para performance
3. Triggers automáticos para updated_at
4. Batch queries para múltiplas empresas

## ✨ Exemplo de Uso

### Fluxo Típico

1. **Segunda-feira (Dia 1)**:
   - Acesso ao sistema
   - Caixa inicial: R$ 0,00
   - Sistema busca comissões: R$ 5.000,00
   - Adiciona ao caixa: R$ 5.000,00
   - Próxima adição: Segunda (Dia 8)

2. **Terça-feira (Dia 2)**:
   - Adiciona despesa: -R$ 500,00
   - Caixa: R$ 4.500,00

3. **Quarta-feira (Dia 3)**:
   - Adiciona reinvestimento: -R$ 1.000,00
   - Caixa: R$ 3.500,00

4. **Segunda-feira (Dia 8)**:
   - Acesso ao sistema
   - Sistema detecta 7 dias passados
   - Busca novas comissões: R$ 6.000,00
   - Adiciona automaticamente ao caixa
   - Caixa: R$ 9.500,00
   - Próxima adição: Segunda (Dia 15)

## 🔧 Troubleshooting

### A aba não aparece

**Solução**: Verifique se está logado na empresa Franca Private (brunoassoni)

### Erro ao buscar comissões

**Solução**: 
1. Verifique se todas as empresas têm a tabela `payments` criada
2. Verifique as credenciais de API de cada empresa no COMPANIES_CONFIG

### Caixa não atualiza automaticamente

**Solução**: Clique em "Atualizar Dados" manualmente

### Erro ao adicionar transação

**Solução**: 
1. Verifique se executou o script SQL corretamente
2. Verifique as políticas RLS no Supabase

## 📄 Arquivos Relacionados

- **SQL**: `setup-financial-control.sql` - Script de criação das tabelas
- **JavaScript**: `app.js` - Funções do controle financeiro (linhas ~17192+)
- **HTML**: `index.html` - Interface e modais
- **Documentação**: `README-controle-financeiro.md` - Este arquivo

## 🎯 Changelog

**Versão 1.0.0** (16 de Dezembro de 2025)
- ✅ Criação inicial do módulo de Controle Financeiro
- ✅ Integração com todas as 6 empresas
- ✅ Sistema de adição automática a cada 7 dias
- ✅ Gestão de despesas e reinvestimentos
- ✅ Histórico completo de transações
- ✅ Interface responsiva e moderna

---

**Sistema**: Franca Private (brunoassoni)  
**Módulo**: Controle Financeiro  
**Data**: 16 de Dezembro de 2025  
**Desenvolvedor**: Cursor AI Agent

Para suporte ou dúvidas, consulte a documentação completa ou entre em contato com o administrador do sistema.
