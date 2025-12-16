# 🚀 Instruções Rápidas - Controle Financeiro

## ⚡ Início Rápido (5 minutos)

### Passo 1: Configurar Banco de Dados ⚙️

1. **Acesse o Supabase do Franca Private:**
   - URL: https://pebwoerzslfzhjptyjwh.supabase.co
   - Faça login com suas credenciais

2. **Execute o SQL:**
   - Clique em **"SQL Editor"** no menu lateral
   - Clique em **"New Query"**
   - Abra o arquivo `setup-financial-control.sql` deste projeto
   - Copie TODO o conteúdo
   - Cole no editor SQL
   - Clique em **"Run"** ou pressione `Ctrl + Enter`

3. **Aguarde a confirmação:**
   ```
   ✅ CONTROLE FINANCEIRO CONFIGURADO COM SUCESSO!
   ```

### Passo 2: Acessar o Sistema 🔐

1. **Abra o sistema no navegador**

2. **Ative o Franca Private:**
   - Na tela de login, localize o botão "Bruno Assoni"
   - Clique **3 VEZES** rapidamente no botão
   - Aguarde aparecer: **"✓ Franca Private Ativado"**

3. **Faça Login:**
   - **Email:** `admin@francaprivate.com`
   - **Senha:** `1020`
   - Clique em "Entrar"

### Passo 3: Usar o Controle Financeiro 💰

1. **Veja a nova aba:**
   - Na barra lateral, procure **"Controle Financeiro"**
   - Clique nela

2. **Aguarde o carregamento:**
   - Sistema buscará comissões de todas as empresas
   - Isso pode levar alguns segundos

3. **Pronto!** Você verá:
   - ✅ Saldo em Caixa (R$ 0,00 inicialmente)
   - ✅ 6 cards com comissões de cada empresa
   - ✅ Botões para Despesa e Reinvestimento
   - ✅ Data da próxima adição ao caixa
   - ✅ Histórico de transações

---

## 📖 Como Usar

### ➕ Adicionar Comissões ao Caixa

**Quando fazer:** A cada 7 dias (ou quando preferir)

1. Na aba "Controle Financeiro"
2. Veja a seção "Próxima Adição de Comissões ao Caixa"
3. Clique no botão **"Adicionar Agora"**
4. Confirme o valor total na janela de confirmação
5. ✅ Saldo atualizado!

### 💸 Registrar uma Despesa

1. Clique no botão **"Adicionar Despesa"**
2. Preencha:
   - **Descrição:** Ex: "Aluguel escritório"
   - **Valor:** Ex: 1500.00
   - **Data:** Selecione a data
   - **Categoria:** Escolha (Operacional, Marketing, etc.)
   - **Observações:** (opcional)
3. Clique **"Adicionar Despesa"**
4. ✅ Valor deduzido do caixa!

### 📈 Registrar um Reinvestimento

1. Clique no botão **"Reinvestimento"**
2. Preencha:
   - **Descrição:** Ex: "Novo empréstimo para cliente X"
   - **Valor:** Ex: 5000.00
   - **Data:** Selecione a data
   - **Tipo:** Escolha (Empréstimo, Investimento, etc.)
   - **Observações:** (opcional)
3. Clique **"Registrar Reinvestimento"**
4. ✅ Valor deduzido do caixa!

### 📊 Ver Histórico

- Role a página até "Histórico de Transações"
- Veja todas as movimentações
- Cores:
  - 🟢 Verde = Entrada (Comissão)
  - 🔴 Vermelho = Saída (Despesa/Reinvestimento)

---

## 💡 Dicas

### ✅ Boas Práticas

1. **Adicione comissões regularmente**
   - Sugestão: Todo domingo ou a cada 7 dias
   - Mantenha o caixa atualizado

2. **Registre TODAS as despesas**
   - Mesmo as pequenas
   - Use categorias corretas

3. **Anote observações importantes**
   - Ajuda no controle futuro
   - Facilita auditorias

4. **Verifique o saldo antes de grandes saídas**
   - Evite surpresas
   - Planeje melhor

### ⚠️ Alertas

- ⚠️ Se despesa > saldo → Sistema alertará, mas permite continuar
- ⚠️ Saldo pode ficar negativo (fique atento!)
- ⚠️ Transações não podem ser excluídas (apenas adicionar novas)

---

## 📊 Entendendo as Comissões

### De onde vêm os valores?

O sistema busca TODOS os pagamentos do **último mês** em TODAS as 6 empresas:

| Empresa | Percentual Vinicius |
|---------|---------------------|
| **FRANCA CRED** | 66,6% |
| **LITORAL CRED** | 66,6% |
| **MOGIANA CRED** | 66,6% |
| **ERECHIM** | 33,3% |
| **IMPERATRIZ CRED** | 50% |
| **FRANCA PRIVATE** | 100% |

### Exemplo de Cálculo

**Empréstimo em FRANCA CRED:**
- Cliente pagou: R$ 1.200,00
- Valor do empréstimo: R$ 1.000,00
- **Juros:** R$ 200,00
- **Comissão Vinicius (66,6%):** R$ 133,20

---

## 🔍 Troubleshooting

### ❌ Aba não aparece

**Solução:**
- Confirme que está no Franca Private
- Veja se há "✓ Franca Private Ativado" no topo
- Faça logout e login novamente

### ❌ Comissões aparecem zeradas

**Possíveis causas:**
1. Não há pagamentos no último mês
2. Problemas de conexão com outras empresas
3. Aguarde alguns segundos para carregar

**Solução:**
- Abra o Console do navegador (F12)
- Veja se há erros em vermelho
- Recarregue a página (F5)

### ❌ Erro ao adicionar ao caixa

**Solução:**
1. Verifique se executou o SQL corretamente
2. Confirme que as tabelas existem no Supabase
3. Verifique permissões no Supabase

### ❌ Modal não abre

**Solução:**
- Recarregue a página (F5)
- Limpe o cache do navegador
- Verifique console (F12) por erros

---

## 📞 Precisa de Ajuda?

### Documentação Completa
📄 Leia: `README-CONTROLE-FINANCEIRO.md`

### Changelog Técnico
📋 Veja: `CHANGELOG-CONTROLE-FINANCEIRO.md`

### Verificar Banco de Dados

1. Acesse Supabase do Franca Private
2. Vá em "Table Editor"
3. Verifique se existem:
   - ✅ `financial_control`
   - ✅ `financial_transactions`
   - ✅ `collected_commissions`

### Console do Navegador

1. Pressione `F12`
2. Vá na aba "Console"
3. Veja se há erros (em vermelho)
4. Copie e envie para suporte

---

## ✅ Checklist de Verificação

Antes de usar, confirme:

- [ ] SQL executado com sucesso no Supabase
- [ ] Logado no Franca Private (3 cliques)
- [ ] Aba "Controle Financeiro" visível no menu
- [ ] Consegue acessar a aba
- [ ] Cards de comissões carregam
- [ ] Saldo em caixa aparece (mesmo que R$ 0,00)

Tudo OK? **Você está pronto!** 🎉

---

## 🎯 Próximos Passos

1. ✅ Configure o banco (Passo 1)
2. ✅ Acesse o sistema (Passo 2)
3. ✅ Explore a interface
4. ✅ Adicione as primeiras comissões ao caixa
5. ✅ Registre despesas/reinvestimentos conforme necessário
6. ✅ Monitore o histórico regularmente

---

## 📅 Rotina Sugerida

### Semanalmente (Todo Domingo)
- [ ] Acessar Controle Financeiro
- [ ] Adicionar comissões pendentes ao caixa
- [ ] Revisar saldo

### Diariamente
- [ ] Registrar despesas do dia
- [ ] Registrar reinvestimentos realizados

### Mensalmente
- [ ] Revisar histórico completo
- [ ] Analisar categorias de gastos
- [ ] Planejar próximo mês

---

**Pronto para começar!** 🚀

Se tiver dúvidas, consulte a documentação completa em `README-CONTROLE-FINANCEIRO.md`

---

**Sistema:** Franca Private  
**Feature:** Controle Financeiro  
**Status:** ✅ Pronto para Uso  
**Data:** 16/12/2025
