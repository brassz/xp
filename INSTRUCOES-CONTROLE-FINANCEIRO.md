# Instruções de Instalação - Controle Financeiro

## 📋 Passo a Passo para Configuração

### Passo 1: Executar Script SQL no Supabase

1. Acesse o Supabase da Franca Private:
   ```
   https://pebwoerzslfzhjptyjwh.supabase.co
   ```

2. Faça login com suas credenciais

3. No menu lateral, clique em **SQL Editor**

4. Abra o arquivo `financial-control-setup.sql` da pasta do projeto

5. Copie todo o conteúdo do arquivo

6. Cole no SQL Editor do Supabase

7. Clique em **Run** (ou pressione Ctrl+Enter)

8. Aguarde a execução (deve levar alguns segundos)

9. Verifique se apareceu a mensagem de sucesso

### Passo 2: Verificar Criação das Tabelas

1. No menu lateral do Supabase, clique em **Table Editor**

2. Confirme que as seguintes tabelas foram criadas:
   - ✅ `financial_control_entries`
   - ✅ `financial_control_expenses`
   - ✅ `financial_control_reinvestments`
   - ✅ `financial_control_settings`

3. Se alguma tabela não aparecer, execute o script novamente

### Passo 3: Testar a Funcionalidade

1. Abra o sistema Nexus Gestão Financeira

2. Na tela de login, clique **3 vezes** no nome "Bruno Assoni"

3. Faça login com as credenciais:
   - **Email**: `admin@francaprivate.com`
   - **Senha**: `1020`

4. Após o login, verifique se a aba **"Controle Financeiro"** aparece no menu lateral

5. Clique na aba "Controle Financeiro"

6. O dashboard deve aparecer com os cards:
   - Total em Caixa: R$ 0,00
   - Total de Entradas: R$ 0,00
   - Total de Despesas: R$ 0,00
   - Reinvestir (15%): R$ 0,00

### Passo 4: Adicionar Primeira Entrada (Teste)

1. Clique no botão **"Adicionar Comissões ao Caixa"**

2. Preencha o formulário:
   - **Empresa**: ERECHIM (ou outra)
   - **Valor**: 5000.00
   - **Período Inicial**: Data de 30 dias atrás
   - **Período Final**: Data de hoje
   - **Descrição**: Comissões de teste

3. Clique em **"Adicionar ao Caixa"**

4. Deve aparecer mensagem de sucesso

5. O dashboard deve atualizar mostrando:
   - Total em Caixa: R$ 5.000,00
   - Total de Entradas: R$ 5.000,00
   - Reinvestir (15%): R$ 750,00

### Passo 5: Adicionar Primeira Despesa (Teste)

1. Clique no botão **"Adicionar Despesa"**

2. Preencha o formulário:
   - **Descrição**: Água
   - **Categoria**: Serviços Públicos
   - **Valor**: 150.00
   - **Data**: Data de hoje
   - **Observações**: Conta de água do mês

3. Clique em **"Registrar Despesa"**

4. Deve aparecer mensagem de sucesso

5. O dashboard deve atualizar mostrando:
   - Total em Caixa: R$ 4.850,00
   - Total de Despesas: R$ 150,00
   - Reinvestir (15%): R$ 727,50

### Passo 6: Gerar Relatório PDF (Teste)

1. Clique no botão **"Gerar Relatório PDF"**

2. O sistema deve gerar e baixar automaticamente um PDF

3. Abra o PDF e verifique se contém:
   - ✅ Título: "RELATÓRIO DE CONTROLE FINANCEIRO"
   - ✅ Resumo com todos os valores
   - ✅ Gastos por categoria
   - ✅ Detalhamento das despesas
   - ✅ Valor de reinvestimento em destaque

### Passo 7: Verificar Relatório por Categoria

1. Na seção **"Relatório de Gastos por Categoria"**

2. Deve aparecer um card com:
   - Nome da categoria: Serviços Públicos
   - Quantidade: 1 despesa
   - Valor: R$ 150,00

## ✅ Checklist de Verificação

Marque cada item após verificar:

- [ ] Script SQL executado sem erros
- [ ] Todas as 4 tabelas criadas
- [ ] Aba "Controle Financeiro" visível no menu
- [ ] Dashboard carrega corretamente
- [ ] Consegue adicionar entrada de comissão
- [ ] Consegue adicionar despesa
- [ ] Dashboard atualiza após cada operação
- [ ] Relatório por categoria aparece
- [ ] PDF é gerado corretamente
- [ ] Valores de reinvestimento (15%) calculados

## 🔧 Solução de Problemas

### Problema: Aba não aparece no menu

**Solução:**
1. Confirme que está logado na Franca Private (3 cliques)
2. Verifique se o indicador no topo mostra "FRANCA PRIVATE"
3. Faça logout e login novamente
4. Limpe o cache do navegador (Ctrl+Shift+Delete)

### Problema: Erro ao executar script SQL

**Solução:**
1. Verifique se está no banco correto (Franca Private)
2. Tente executar linha por linha para identificar o erro
3. Confirme se as extensões estão habilitadas
4. Verifique se não há tabelas com mesmo nome já criadas

### Problema: Erro ao adicionar entrada/despesa

**Solução:**
1. Abra o console do navegador (F12)
2. Vá para a aba "Console"
3. Procure por erros em vermelho
4. Verifique se todos os campos obrigatórios estão preenchidos
5. Confirme se os valores numéricos são válidos

### Problema: PDF não é gerado

**Solução:**
1. Verifique se há dados cadastrados (entradas ou despesas)
2. Abra o console do navegador para ver erros
3. Confirme se a biblioteca jsPDF está carregada
4. Tente em outro navegador (Chrome recomendado)

## 📞 Suporte Adicional

Se os problemas persistirem:

1. **Verifique os Logs**:
   - Abra F12 no navegador
   - Vá para aba "Console"
   - Copie os erros em vermelho

2. **Verifique o Supabase**:
   - Acesse o SQL Editor
   - Execute: `SELECT * FROM financial_control_entries LIMIT 1;`
   - Se retornar erro, a tabela não foi criada

3. **Teste Conexão**:
   - No console do navegador, digite:
   ```javascript
   console.log(supabase)
   ```
   - Deve mostrar o objeto Supabase

## 🎯 Próximos Passos Após Instalação

1. **Remover dados de teste**:
   - Delete as entradas/despesas de teste via SQL
   - Ou mantenha para referência

2. **Adicionar dados reais**:
   - Comece adicionando comissões reais recebidas
   - Registre despesas reais conforme ocorrem

3. **Estabelecer rotina**:
   - Defina quando adicionar comissões (semanal/mensal)
   - Registre despesas diariamente ou semanalmente
   - Gere relatório PDF mensalmente

4. **Treinar usuários**:
   - Mostre como adicionar entradas
   - Ensine a registrar despesas
   - Explique o cálculo de reinvestimento

## 📚 Documentação Completa

Para mais detalhes sobre o sistema, consulte:
- `README-CONTROLE-FINANCEIRO.md` - Documentação completa
- `financial-control-setup.sql` - Script SQL com comentários

---

**Data de Criação**: Dezembro de 2025  
**Sistema**: Franca Private - Controle Financeiro  
**Versão**: 1.0.0
