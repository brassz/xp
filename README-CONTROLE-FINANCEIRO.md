# Controle Financeiro - Franca Private

## 📋 Visão Geral

O **Controle Financeiro** é uma funcionalidade exclusiva da **Franca Private** que permite:

1. **Agregar comissões** de todas as empresas do sistema em um único caixa
2. **Gerenciar despesas** com categorização e controle
3. **Gerar relatórios financeiros** automáticos com cálculos de:
   - Total em caixa (comissões)
   - Total de despesas
   - Saldo restante
   - **15% do saldo para reinvestimento**

---

## 🎯 Funcionalidades Principais

### 1. Caixa Consolidado
- Busca automática de comissões de **TODAS as empresas** do sistema:
  - FRANCA CRED
  - LITORAL CRED
  - MOGIANA CRED
  - ERECHIM
  - IMPERATRIZ CRED
  - FRANCA PRIVATE
- Exibição individual do total de cada empresa
- Cálculo automático do total geral

### 2. Gestão de Despesas
- Registro de despesas com categorias predefinidas:
  - 💧 Água
  - ⚡ Luz/Energia
  - 🌐 Internet
  - 🏢 Aluguel
  - 💰 Salários
  - 📦 Materiais
  - 📢 Marketing
  - 🔧 Manutenção
  - 📊 Impostos
  - 📝 Outros
- Busca e filtro de despesas
- Exclusão de despesas

### 3. Relatório Financeiro Automático
O sistema calcula automaticamente:
- **Caixa Total**: Soma de todas as comissões
- **Total de Despesas**: Soma de todas as despesas registradas
- **Saldo Restante**: Caixa - Despesas
- **Reinvestimento (15%)**: 15% do saldo restante

---

## 🚀 Como Usar

### Passo 1: Acessar o Sistema Franca Private

1. Abra o sistema de gestão financeira
2. Na tela de login, clique **3 vezes** no texto "Bruno Assoni" (no rodapé)
3. Você verá a mensagem: **"🔒 Sistema Franca Private Ativado"**
4. Faça login com suas credenciais:
   - Email: `admin@francaprivate.com`
   - Senha: `1020`

### Passo 2: Configurar o Banco de Dados

**IMPORTANTE**: Execute este passo apenas uma vez, na primeira configuração.

1. Acesse o Supabase do Franca Private:
   - URL: https://pebwoerzslfzhjptyjwh.supabase.co
   
2. No Supabase, vá em **SQL Editor**

3. Abra o arquivo `setup-financial-control-franca-private.sql`

4. Copie TODO o conteúdo do arquivo

5. Cole no SQL Editor e clique em **Run**

6. Aguarde a confirmação: **"CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!"**

### Passo 3: Usar o Controle Financeiro

1. No menu lateral, clique em **"Controle Financeiro"**
   - ⚠️ Este menu só aparece para a empresa Franca Private

2. **Atualizar o Caixa**:
   - Clique no botão **"Atualizar Caixa"**
   - O sistema irá buscar todas as comissões dos últimos 12 meses
   - Aguarde o carregamento (pode levar alguns segundos)
   - Você verá:
     - Total geral em caixa
     - Detalhamento por empresa

3. **Adicionar Despesas**:
   - Clique no botão **"Nova Despesa"**
   - Preencha os campos:
     - Descrição (ex: "Água - Fevereiro")
     - Categoria (selecione da lista)
     - Valor (ex: 150.00)
     - Data
     - Observações (opcional)
   - Clique em **"Registrar Despesa"**

4. **Ver Relatório Financeiro**:
   - O relatório é atualizado automaticamente
   - Você verá 4 cards no topo:
     - 💰 **Caixa (Comissões)**: Total de todas as comissões
     - 📉 **Total Despesas**: Soma de todas as despesas
     - ✅ **Saldo Restante**: Caixa - Despesas
     - 📈 **Reinvestir (15%)**: 15% do saldo (para crescimento)

---

## 📊 Exemplo de Uso

### Cenário:

**Comissões agregadas (últimos 12 meses)**:
- FRANCA CRED: R$ 15.000,00
- LITORAL CRED: R$ 8.500,00
- MOGIANA CRED: R$ 12.300,00
- ERECHIM: R$ 6.700,00
- IMPERATRIZ CRED: R$ 9.200,00
- FRANCA PRIVATE: R$ 4.300,00

**Total em Caixa**: R$ 56.000,00

**Despesas registradas**:
- Água: R$ 150,00
- Luz: R$ 350,00
- Internet: R$ 120,00
- Aluguel: R$ 2.000,00
- Salários: R$ 15.000,00
- Marketing: R$ 1.500,00

**Total de Despesas**: R$ 19.120,00

**Cálculos automáticos**:
- **Saldo Restante**: R$ 56.000,00 - R$ 19.120,00 = **R$ 36.880,00**
- **Reinvestimento (15%)**: R$ 36.880,00 × 0,15 = **R$ 5.532,00**

---

## 🔧 Funcionalidades Técnicas

### Agregação Multi-Empresas
O sistema conecta automaticamente em TODAS as empresas configuradas e busca:
- Pagamentos realizados (tabela `payments`)
- Extrai os juros pagos (base para comissão)
- Soma os valores por empresa
- Apresenta o total consolidado

### Persistência de Dados
- Todas as despesas são salvas na tabela `financial_expenses`
- Os dados persistem mesmo após logout
- Histórico completo de todas as despesas

### Cálculos em Tempo Real
- Atualização automática ao adicionar/remover despesas
- Recálculo instantâneo do saldo e reinvestimento

---

## ⚠️ Notas Importantes

1. **Exclusivo para Franca Private**
   - O menu só aparece quando logado como Franca Private
   - Outras empresas não têm acesso a esta funcionalidade

2. **Período de Busca**
   - Por padrão, busca comissões dos últimos **12 meses**
   - Isso pode ser ajustado no código se necessário

3. **Performance**
   - A primeira busca pode demorar alguns segundos
   - O sistema precisa consultar 6 bancos de dados diferentes
   - Seja paciente ao clicar em "Atualizar Caixa"

4. **Segurança**
   - Apenas usuários autenticados podem acessar
   - Row Level Security (RLS) habilitado no banco
   - Dados isolados por empresa

---

## 📁 Arquivos Relacionados

### Scripts SQL
- `setup-financial-control-franca-private.sql` - Setup do banco de dados

### Código Fonte
- `index.html` (linhas ~2095-2260) - Interface HTML do Controle Financeiro
- `index.html` (linhas ~3580-3645) - Modal de nova despesa
- `app.js` (linhas ~17192-17527) - Funções JavaScript do Controle Financeiro

### Documentação
- `README-CONTROLE-FINANCEIRO.md` - Este arquivo

---

## 🆘 Troubleshooting

### Problema: Menu "Controle Financeiro" não aparece
**Solução**: Verifique se você está logado como Franca Private (3 cliques em "Bruno Assoni")

### Problema: Erro ao buscar comissões
**Solução**: 
1. Verifique a conexão com internet
2. Confirme que todas as empresas estão configuradas no `.env`
3. Verifique o console do navegador (F12) para erros

### Problema: Erro ao adicionar despesa
**Solução**:
1. Confirme que executou o script `setup-financial-control-franca-private.sql`
2. Verifique se a tabela `financial_expenses` existe no Supabase
3. Confira as permissões RLS no Supabase

### Problema: Valores não batem
**Solução**:
1. Clique em "Atualizar Caixa" novamente
2. Verifique se todas as despesas estão sendo mostradas
3. Limpe o cache do navegador e recarregue

---

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique a seção de Troubleshooting acima
2. Consulte os logs do console do navegador (F12)
3. Revise a documentação do Supabase

---

## 🎉 Conclusão

O **Controle Financeiro** é uma ferramenta poderosa para a gestão consolidada de todas as comissões e despesas do sistema. Com ele, você tem visão completa da saúde financeira e pode tomar decisões baseadas em dados reais.

**Desenvolvido com ❤️ para Franca Private**

---

**Última atualização**: Dezembro 2025  
**Versão**: 1.0.0  
**Sistema**: Franca Private (brunoassoni)
