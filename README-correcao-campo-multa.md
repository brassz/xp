# Correção do Campo de Multa nos Pagamentos

## Problema Identificado

O sistema estava com uma inconsistência entre o banco de dados e o código JavaScript:
- **Banco de dados**: Coluna chamada `fine` na tabela `payments`
- **Código JavaScript**: Esperava uma coluna chamada `fine_amount`

Isso fazia com que as multas cadastradas não aparecessem no histórico de pagamentos.

## Solução

Foi criado um script SQL que:
1. Cria a coluna `fine_amount` na tabela `payments`
2. Migra os dados existentes da coluna `fine` para `fine_amount`
3. Cria índices para otimizar consultas de relatórios de multas

## Como Aplicar a Correção

### Passo 1: Executar o Script SQL

Execute o script SQL no seu banco de dados Supabase:

```sql
-- Execute o conteúdo do arquivo: fix-fine-column-name.sql
```

Você pode fazer isso de duas formas:

#### Opção A: Via Interface do Supabase
1. Acesse o painel do Supabase: https://supabase.com/dashboard
2. Selecione seu projeto
3. Vá em "SQL Editor"
4. Copie e cole o conteúdo do arquivo `fix-fine-column-name.sql`
5. Clique em "Run" para executar

#### Opção B: Via psql (linha de comando)
```bash
psql -h seu-projeto.supabase.co -U postgres -d postgres -f fix-fine-column-name.sql
```

### Passo 2: Limpar Cache do Navegador

Após executar o script SQL, limpe o cache do navegador:

**Chrome/Edge:**
1. Pressione `Ctrl+Shift+Delete` (Windows) ou `Cmd+Shift+Delete` (Mac)
2. Selecione "Imagens e arquivos em cache"
3. Clique em "Limpar dados"

**Firefox:**
1. Pressione `Ctrl+Shift+Delete` (Windows) ou `Cmd+Shift+Delete` (Mac)
2. Selecione "Cache"
3. Clique em "Limpar agora"

Ou simplesmente faça um "Hard Refresh":
- **Chrome/Firefox/Edge**: `Ctrl+F5` (Windows) ou `Cmd+Shift+R` (Mac)

### Passo 3: Recarregar a Aplicação

1. Feche todas as abas do sistema
2. Abra novamente e faça login
3. Teste cadastrando um novo pagamento com multa

## Verificação

Após aplicar a correção, você deve:

1. **Ver a coluna "Multa" na tabela de histórico de pagamentos**
   - Aba "Histórico" do cliente
   - Modal "Histórico de Pagamentos" ao clicar no ícone 💰

2. **O valor da multa deve ser contabilizado no "Total Pago"**
   - No resumo financeiro do histórico
   - Ao quitar um empréstimo
   - Nos relatórios PDF

3. **Console de debug** (pressione F12 no navegador)
   - Ao cadastrar um pagamento, deve aparecer:
     ```
     === REGISTRANDO PAGAMENTO ===
     Include Fine: true
     Fine Amount: [valor da multa]
     ```
   - Ao visualizar o histórico, deve aparecer:
     ```
     Pagamento: {
       id: "...",
       amount: [valor],
       fine_amount: [valor da multa],
       fine_amount_raw: [valor da multa]
     }
     ```

## Alterações no Código JavaScript

O código JavaScript já foi corrigido para:

1. **Salvar a multa** ao cadastrar pagamento
   - Campo `fine_amount` é incluído no INSERT/UPDATE

2. **Exibir a multa** no histórico
   - Coluna "Multa" mostra o valor em vermelho quando > 0

3. **Contabilizar a multa** nos totais
   - Total Pago = Pagamentos + Multas
   - Cálculos de valor restante consideram multas pagas
   - Quitação de empréstimo inclui multas no total pago

## Funcionalidades que Agora Funcionam Corretamente

✅ Cadastro de multa ao registrar pagamento na aba de empréstimos
✅ Visualização da multa no histórico de pagamentos
✅ Contabilização da multa no "Total Pago"
✅ Multas aparecem no histórico completo do cliente
✅ Relatórios PDF incluem valores de multas
✅ Mensagens de cobrança via WhatsApp
✅ Quitação de empréstimos considera multas
✅ Cancelamento de empréstimos considera multas

## Suporte

Se após aplicar a correção o problema persistir:

1. Verifique se o script SQL foi executado com sucesso
2. Verifique no console do navegador (F12) se há erros
3. Confirme que o cache foi limpo
4. Tente em uma janela anônima/privada do navegador
