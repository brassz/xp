# Controle Financeiro - Franca Private

## 📋 Visão Geral

Foi implementado um sistema completo de **Controle Financeiro** exclusivo para a empresa **FRANCA PRIVATE**. Este sistema permite gerenciar um caixa centralizado com comissões de todas as empresas, registrar despesas e gerar relatórios detalhados com cálculo automático de reinvestimento.

## 🎯 Funcionalidades Implementadas

### 1. **Caixa Unificado**
- Centraliza comissões de todas as empresas (ERECHIM, IMPERATRIZ CRED, FRANCA PRIVATE, etc.)
- Rastreamento completo de entradas por empresa e período
- Cálculo automático do saldo atual

### 2. **Gestão de Despesas**
- Registro detalhado de despesas por categoria
- Categorias predefinidas:
  - Serviços Públicos (Água, Luz, Internet)
  - Aluguel
  - Salários
  - Materiais de Escritório
  - Marketing
  - Manutenção
  - Impostos e Taxas
  - Outros
- Data e observações para cada despesa

### 3. **Relatórios Financeiros**
- **Dashboard em tempo real** com 4 indicadores principais:
  - Total em Caixa
  - Total de Entradas
  - Total de Despesas
  - Reinvestimento Recomendado (15% do saldo)
- **Relatório por Categoria**: Visualização agrupada dos gastos
- **Geração de PDF**: Relatório completo para impressão/arquivamento

### 4. **Cálculo Automático de Reinvestimento**
- Sistema calcula automaticamente 15% do saldo restante
- Sugestão clara de quanto deve ser reinvestido
- Exibido em todos os relatórios e no dashboard

## 🗄️ Estrutura do Banco de Dados

### Tabelas Criadas

#### 1. `financial_control_entries`
```sql
- id: UUID (PK)
- company_name: TEXT (Nome da empresa de origem)
- company_code: TEXT (Código da empresa)
- commission_amount: DECIMAL (Valor das comissões)
- period_start: DATE (Início do período)
- period_end: DATE (Fim do período)
- description: TEXT (Descrição opcional)
- entry_date: DATE (Data de entrada no caixa)
- created_by: UUID (Usuário que criou)
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

#### 2. `financial_control_expenses`
```sql
- id: UUID (PK)
- description: TEXT (Descrição da despesa)
- amount: DECIMAL (Valor da despesa)
- category: TEXT (Categoria)
- expense_date: DATE (Data da despesa)
- notes: TEXT (Observações)
- created_by: UUID (Usuário que criou)
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

#### 3. `financial_control_reinvestments`
```sql
- id: UUID (PK)
- amount: DECIMAL (Valor a reinvestir)
- percentage: DECIMAL (Percentual - padrão 15%)
- base_amount: DECIMAL (Saldo base)
- description: TEXT
- reinvestment_date: DATE
- status: TEXT (pending, applied, cancelled)
- created_by: UUID
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

#### 4. `financial_control_settings`
```sql
- id: UUID (PK)
- current_balance: DECIMAL
- total_entries: DECIMAL
- total_expenses: DECIMAL
- reinvestment_percentage: DECIMAL (padrão 15.00)
- last_updated: TIMESTAMP
- updated_by: UUID
```

### Views Criadas

#### `financial_control_summary`
Resumo geral com totais e saldo atual

#### `expenses_by_category`
Despesas agrupadas por categoria com estatísticas

#### `entries_by_company`
Entradas agrupadas por empresa com totais

#### `monthly_financial_report`
Relatório mensal com entradas, despesas e saldo líquido

### Funções SQL

#### `get_current_financial_balance()`
Retorna o saldo atual do caixa

#### `get_recommended_reinvestment()`
Retorna o valor recomendado para reinvestimento (15% do saldo)

## 🚀 Como Usar

### 1. **Acessar o Sistema**
1. Faça login no sistema Franca Private (3 cliques em "Bruno Assoni")
2. A aba "Controle Financeiro" aparecerá no menu lateral
3. Clique na aba para acessar

### 2. **Adicionar Comissões ao Caixa**
1. Clique em "Adicionar Comissões ao Caixa"
2. Selecione a empresa de origem:
   - ERECHIM
   - IMPERATRIZ CRED
   - FRANCA PRIVATE
   - Outra Empresa (permite digitar o nome)
3. Digite o valor das comissões
4. Selecione o período (datas inicial e final)
5. Adicione uma descrição (opcional)
6. Clique em "Adicionar ao Caixa"

### 3. **Registrar Despesas**
1. Clique em "Adicionar Despesa"
2. Digite a descrição da despesa (ex: Água, Luz, Aluguel)
3. Selecione a categoria
4. Digite o valor
5. Selecione a data
6. Adicione observações (opcional)
7. Clique em "Registrar Despesa"

### 4. **Visualizar Dashboard**
O dashboard é atualizado automaticamente e exibe:
- **Total em Caixa**: Saldo atual (entradas - despesas)
- **Total de Entradas**: Soma de todas as comissões recebidas
- **Total de Despesas**: Soma de todas as despesas registradas
- **Reinvestir (15%)**: Valor recomendado para reinvestimento

### 5. **Gerar Relatório PDF**
1. Clique em "Gerar Relatório PDF"
2. O sistema gera automaticamente um PDF com:
   - Resumo financeiro completo
   - Gastos por categoria
   - Detalhamento de todas as despesas
   - Cálculo do reinvestimento recomendado
3. O PDF é baixado automaticamente

## 📊 Estrutura do Relatório PDF

### Seção 1: Resumo Financeiro
- Total de Entradas (Comissões)
- Total de Despesas
- Saldo Atual
- Reinvestimento Recomendado (15%)

### Seção 2: Gastos por Categoria
Lista ordenada das categorias com maiores gastos

### Seção 3: Detalhamento das Despesas
Lista completa de todas as despesas com:
- Data
- Descrição
- Valor
- Categoria

## 🎨 Interface

### Cards de Resumo
Quatro cards coloridos no topo da página:
- **Azul**: Total em Caixa
- **Verde**: Total de Entradas
- **Vermelho**: Total de Despesas
- **Amarelo**: Reinvestimento (15%)

### Tabelas
Duas tabelas lado a lado:
- **Esquerda**: Entradas de Comissões (empresa, valor, data)
- **Direita**: Despesas (descrição, valor, data)

### Relatório de Gastos
Grid responsivo mostrando gastos por categoria com:
- Nome da categoria
- Quantidade de despesas
- Valor total

## 🔒 Segurança e Acesso

- **Exclusivo para Franca Private**: A aba só aparece quando logado na empresa Franca Private
- **Outras empresas**: Não têm acesso a esta funcionalidade
- **Proteção de dados**: Cada empresa mantém seus dados isolados
- **Auditoria**: Todas as operações registram quem criou e quando

## 📈 Cálculo do Reinvestimento

O sistema calcula automaticamente **15% do saldo restante**:

```
Saldo Atual = Total de Entradas - Total de Despesas
Reinvestimento = Saldo Atual × 0,15 (15%)
```

**Exemplo:**
- Entradas: R$ 50.000,00
- Despesas: R$ 30.000,00
- Saldo: R$ 20.000,00
- **Reinvestimento**: R$ 3.000,00 (15% de R$ 20.000,00)

## 🛠️ Configuração do Banco de Dados

### Passo 1: Executar Script SQL
Execute o arquivo `financial-control-setup.sql` no SQL Editor do Supabase:
```
https://pebwoerzslfzhjptyjwh.supabase.co
```

### Passo 2: Verificar Criação
Confirme que todas as tabelas foram criadas:
- ✅ `financial_control_entries`
- ✅ `financial_control_expenses`
- ✅ `financial_control_reinvestments`
- ✅ `financial_control_settings`

### Passo 3: Verificar Views
Confirme que as views foram criadas:
- ✅ `financial_control_summary`
- ✅ `expenses_by_category`
- ✅ `entries_by_company`
- ✅ `monthly_financial_report`

## 💡 Casos de Uso

### Uso Diário
1. Registrar despesas conforme ocorrem
2. Visualizar saldo em tempo real
3. Acompanhar gastos por categoria

### Uso Semanal
1. Adicionar comissões recebidas de outras empresas
2. Revisar relatório de gastos por categoria
3. Ajustar despesas conforme necessário

### Uso Mensal
1. Gerar relatório PDF completo
2. Calcular e aplicar reinvestimento de 15%
3. Analisar tendências de gastos
4. Planejar orçamento do próximo mês

## 📝 Notas Técnicas

### Performance
- Índices otimizados em todas as tabelas
- Queries eficientes com views materializadas
- Carregamento assíncrono dos dados

### Escalabilidade
- Preparado para grandes volumes de dados
- Paginação automática em tabelas longas
- Filtros e ordenação otimizados

### Manutenção
- Triggers automáticos para timestamps
- Funções SQL para cálculos complexos
- Logs completos de auditoria

## 🔄 Próximas Melhorias (Futuro)

- [ ] Gráficos de tendência de gastos
- [ ] Comparativo mensal/anual
- [ ] Alertas de limite de gastos
- [ ] Categorias customizadas
- [ ] Exportação para Excel
- [ ] Dashboard mobile otimizado
- [ ] Histórico de reinvestimentos aplicados
- [ ] Previsão de saldo futuro

## 📞 Suporte

### Problemas Comuns

**A aba não aparece:**
- Confirme que está logado na Franca Private
- Faça logout e login novamente

**Dados não carregam:**
- Verifique se o script SQL foi executado
- Confirme conexão com o Supabase
- Verifique o console do navegador

**Erro ao adicionar despesa:**
- Confirme que todos os campos obrigatórios estão preenchidos
- Verifique se o valor é maior que zero
- Confirme que a data é válida

### Logs e Debug
Para debug, abra o console do navegador (F12) e procure por:
- `Erro ao carregar dados do controle financeiro`
- `Erro ao adicionar entrada`
- `Erro ao adicionar despesa`

## ✅ Checklist de Implementação

- [x] Criar tabelas no banco de dados
- [x] Criar views e funções SQL
- [x] Adicionar aba no menu lateral
- [x] Criar interface do dashboard
- [x] Implementar modal de adicionar comissões
- [x] Implementar modal de adicionar despesas
- [x] Criar sistema de cálculo automático
- [x] Implementar geração de PDF
- [x] Adicionar relatório por categoria
- [x] Testar funcionalidades
- [x] Documentar sistema completo

---

## 🎉 Status

✅ **Sistema Implementado e Pronto para Uso!**

O Controle Financeiro está totalmente funcional e integrado ao sistema Franca Private. Todas as funcionalidades descritas estão operacionais e testadas.

**Data de Implementação**: Dezembro de 2025  
**Desenvolvido para**: FRANCA PRIVATE  
**Versão**: 1.0.0
