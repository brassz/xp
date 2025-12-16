# Controle Financeiro - Franca Private

## 📋 Visão Geral

Foi implementada uma nova aba **"Controle Financeiro"** exclusiva para a empresa **Franca Private** que permite gerenciar o caixa da empresa com base nas comissões de Vinicius de todas as empresas do sistema.

## ✨ Funcionalidades

### 1. **Saldo em Caixa**
- Exibe o saldo atual disponível em caixa
- Atualizado automaticamente após cada transação
- Mostra a data da última atualização

### 2. **Comissões Consolidadas**
- Busca automaticamente as comissões de Vinicius de **todas as 6 empresas**:
  - FRANCA CRED (Nexus) - 66,6%
  - LITORAL CRED - 66,6%
  - MOGIANA CRED - 66,6%
  - ERECHIM - 33,3%
  - IMPERATRIZ CRED - 50%
  - FRANCA PRIVATE - 100%
- Exibe cards individuais com o valor de comissão de cada empresa
- Período: Último mês

### 3. **Adição Automática ao Caixa**
- Sistema de adição de comissões ao caixa **a cada 7 dias**
- Botão manual "Adicionar Agora" para antecipar a adição
- Exibe data da próxima adição programada
- Confirmação antes de adicionar ao caixa

### 4. **Registro de Despesas**
- Botão "Adicionar Despesa" para registrar gastos
- Campos:
  - Descrição
  - Valor
  - Data
  - Categoria (Operacional, Marketing, Pessoal, Infraestrutura, Outros)
  - Observações
- Deduz automaticamente do saldo em caixa
- Alerta se o valor exceder o saldo disponível

### 5. **Registro de Reinvestimentos**
- Botão "Reinvestimento" para registrar aplicações
- Campos:
  - Descrição
  - Valor
  - Data
  - Tipo (Empréstimo, Investimento, Expansão, Outros)
  - Observações
- Deduz automaticamente do saldo em caixa
- Alerta se o valor exceder o saldo disponível

### 6. **Histórico de Transações**
- Tabela completa com todas as movimentações
- Informações exibidas:
  - Data da transação
  - Tipo (Comissão, Despesa, Reinvestimento)
  - Descrição
  - Valor (+ para entrada, - para saída)
  - Saldo após a transação
- Ordenado por data (mais recentes primeiro)
- Limite de 50 transações exibidas

## 🗄️ Estrutura do Banco de Dados

### Tabela: `financial_control`
Armazena o controle geral do caixa.

```sql
- id (UUID, PK)
- cash_balance (DECIMAL) - Saldo atual
- last_commission_date (TIMESTAMP) - Última data de adição
- next_commission_date (TIMESTAMP) - Próxima data programada
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

### Tabela: `financial_transactions`
Registra todas as transações.

```sql
- id (UUID, PK)
- transaction_type (VARCHAR) - 'commission', 'expense', 'reinvestment'
- description (TEXT)
- amount (DECIMAL)
- balance_after (DECIMAL) - Saldo após a transação
- category (VARCHAR)
- notes (TEXT)
- transaction_date (TIMESTAMP)
- created_at (TIMESTAMP)
```

### Tabela: `collected_commissions`
Armazena comissões coletadas de cada empresa.

```sql
- id (UUID, PK)
- company_name (VARCHAR)
- commission_amount (DECIMAL)
- collection_date (TIMESTAMP)
- period_start (DATE)
- period_end (DATE)
- added_to_cash (BOOLEAN)
- added_to_cash_date (TIMESTAMP)
- created_at (TIMESTAMP)
```

## 📦 Instalação

### Passo 1: Executar Script SQL

1. Acesse o Supabase da **Franca Private**:
   - URL: https://pebwoerzslfzhjptyjwh.supabase.co

2. Navegue até: **SQL Editor**

3. Abra o arquivo `setup-financial-control.sql`

4. Copie todo o conteúdo e cole no SQL Editor

5. Clique em **Run** (ou pressione `Ctrl + Enter`)

6. Aguarde a confirmação de sucesso

### Passo 2: Acessar o Sistema

1. Faça login no sistema

2. Ative o Franca Private:
   - Na tela de login, clique **3 vezes** no botão "Bruno Assoni"
   - Aguarde aparecer: "✓ Franca Private Ativado"

3. Faça login com as credenciais:
   - **Email**: `admin@francaprivate.com`
   - **Senha**: `1020`

4. Na barra lateral, você verá a nova aba **"Controle Financeiro"**

5. Clique nela para acessar

## 🎯 Como Usar

### Visualizar Comissões

1. Acesse a aba "Controle Financeiro"
2. O sistema carregará automaticamente as comissões do último mês
3. Veja os cards individuais de cada empresa

### Adicionar Comissões ao Caixa

**Forma Automática:**
- O sistema sugere adicionar a cada 7 dias
- Veja a data da próxima adição no card "Próxima Adição"

**Forma Manual:**
1. Clique em "Adicionar Agora"
2. Confirme o valor total
3. As comissões serão adicionadas ao saldo

### Registrar Despesa

1. Clique em "Adicionar Despesa"
2. Preencha os campos:
   - Descrição
   - Valor
   - Data
   - Categoria
   - Observações (opcional)
3. Clique em "Adicionar Despesa"
4. O valor será deduzido do caixa

### Registrar Reinvestimento

1. Clique em "Reinvestimento"
2. Preencha os campos:
   - Descrição
   - Valor
   - Data
   - Tipo
   - Observações (opcional)
3. Clique em "Registrar Reinvestimento"
4. O valor será deduzido do caixa

### Ver Histórico

- Role até a seção "Histórico de Transações"
- Veja todas as movimentações
- Ordenadas da mais recente para a mais antiga

## 🔐 Segurança

- ✅ Aba visível **apenas** para Franca Private
- ✅ Dados isolados por empresa
- ✅ Confirmação antes de ações importantes
- ✅ Alertas quando saldo insuficiente
- ✅ Registro completo de todas as transações

## 🎨 Interface

### Cores por Tipo de Transação

| Tipo | Cor | Descrição |
|------|-----|-----------|
| **Comissão** | Verde | Entrada de dinheiro |
| **Despesa** | Vermelho | Saída de dinheiro |
| **Reinvestimento** | Roxo | Aplicação de recursos |

### Cards de Resumo

1. **Saldo em Caixa** (Verde)
   - Valor atual disponível
   - Data da última atualização

2. **Comissões por Empresa** (Azul/Verde)
   - 6 cards individuais
   - Valor de cada empresa

3. **Próxima Adição** (Azul)
   - Data programada
   - Botão de ação manual

## 📊 Lógica de Cálculo de Comissões

```javascript
// Percentuais de Vinicius por empresa
FRANCA CRED (nexus):     66,6%
LITORAL CRED (litoral):  66,6%
MOGIANA CRED (mogiana):  66,6%
ERECHIM (erechim):       33,3%
IMPERATRIZ (imperatriz): 50%
FRANCA PRIVATE (brunoassoni): 100%
```

### Fórmula

```
Juros Pagos = Valor Pago - Valor do Empréstimo
Comissão Vinicius = Juros Pagos × Percentual da Empresa
```

### Exemplo

**Empréstimo na FRANCA CRED:**
- Valor empréstimo: R$ 1.000,00
- Valor pago: R$ 1.100,00
- Juros: R$ 100,00
- Comissão Vinicius (66,6%): R$ 66,60

## 🔄 Fluxo de Trabalho

```
1. Sistema coleta comissões de todas as empresas (último mês)
   ↓
2. Armazena em 'collected_commissions' (added_to_cash = false)
   ↓
3. A cada 7 dias (ou manual):
   - Soma todas as comissões pendentes
   - Adiciona ao saldo em caixa
   - Marca comissões como adicionadas
   - Registra transação tipo 'commission'
   ↓
4. Usuário pode:
   - Adicionar despesas (deduz do caixa)
   - Adicionar reinvestimentos (deduz do caixa)
   ↓
5. Todas as movimentações ficam no histórico
```

## 🐛 Troubleshooting

### Aba não aparece
- ✅ Verifique se está logado no Franca Private (brunoassoni)
- ✅ Confirme que há "✓ Franca Private Ativado" no topo

### Comissões não aparecem
- ✅ Verifique se há empréstimos pagos no último mês
- ✅ Abra o console do navegador (F12) para ver erros
- ✅ Confirme que as 6 empresas estão acessíveis

### Erro ao adicionar ao caixa
- ✅ Verifique se há comissões pendentes
- ✅ Execute novamente o script SQL
- ✅ Verifique permissões no Supabase

### Saldo negativo
- ✅ Isso é permitido (alerta será exibido)
- ✅ Revise o histórico de transações
- ✅ Ajuste manualmente se necessário

## 📝 Arquivos Relacionados

| Arquivo | Descrição |
|---------|-----------|
| `setup-financial-control.sql` | Script de criação das tabelas |
| `README-CONTROLE-FINANCEIRO.md` | Esta documentação |
| `index.html` | Interface da aba (linhas 2088-2193) |
| `app.js` | Funções JavaScript (linhas 17192+) |

## 🎯 Melhorias Futuras

- [ ] Gráficos de evolução do saldo
- [ ] Exportar histórico para Excel/PDF
- [ ] Filtros avançados no histórico
- [ ] Categorias personalizáveis
- [ ] Notificações quando saldo baixo
- [ ] Relatórios mensais automáticos
- [ ] Comparação entre períodos
- [ ] Previsão de fluxo de caixa

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique esta documentação
2. Consulte o histórico de transações
3. Revise os logs do console (F12)
4. Entre em contato com o desenvolvedor

---

**Sistema**: Franca Private  
**Versão**: 1.0  
**Data**: 16/12/2025  
**Status**: ✅ Implementado  

🎉 **Controle Financeiro pronto para uso!**
