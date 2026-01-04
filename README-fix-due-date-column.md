# Correção: Erro ao atualizar empréstimo

## Problema

Ao tentar atualizar um empréstimo, o sistema retorna o erro:

```
Could not find the 'due_date_manually_changed' column of 'loans' in the schema cache
```

## Causa

O código JavaScript (`app.js`) está tentando atualizar a coluna `due_date_manually_changed` na tabela `loans`, mas essa coluna não existe no banco de dados.

Esta coluna é usada para:
- Rastrear quando a data de vencimento de um empréstimo foi alterada manualmente
- Exibir essas datas em amarelo na interface (com um ícone ⚠️)
- Diferenciar datas calculadas automaticamente de datas modificadas pelo usuário

## Solução

Execute o script SQL fornecido para adicionar a coluna ao banco de dados:

### Opção 1: Via Supabase Dashboard

1. Acesse o Supabase Dashboard
2. Vá para o SQL Editor
3. Cole o conteúdo do arquivo `fix-due-date-manually-changed-column.sql`
4. Execute o script

### Opção 2: Via linha de comando (psql)

```bash
psql -h seu-host -d seu-database -U seu-usuario -f fix-due-date-manually-changed-column.sql
```

### Opção 3: Via aplicação com acesso ao banco

```javascript
// Se você tiver acesso direto ao Supabase no seu código
const { data, error } = await supabase.rpc('sql', {
  query: `-- cole aqui o conteúdo do script`
});
```

## O que o script faz

1. **Verifica se a coluna existe** antes de tentar criá-la (evita erros)
2. **Adiciona a coluna** `due_date_manually_changed` como BOOLEAN com valor padrão FALSE
3. **Adiciona um comentário** explicando o propósito da coluna
4. **Cria um índice** para otimizar consultas que filtram por datas alteradas
5. **Garante que todos os registros existentes** tenham um valor (false por padrão)
6. **Verifica a instalação** e mostra estatísticas

## Verificação

Após executar o script, você deve ver mensagens como:

```
✓ Coluna criada com sucesso!
✓ Total de empréstimos: X
✓ Empréstimos com data alterada manualmente: 0
✓ Índice criado para otimização de consultas

O erro "Could not find the due_date_manually_changed column" foi corrigido!
```

## Funcionalidade

Após a correção, quando você:
1. Editar um empréstimo e alterar a data de vencimento manualmente
2. A data será exibida em **amarelo** na lista de empréstimos
3. Um ícone ⚠️ será mostrado ao lado da data
4. Ao passar o mouse sobre a data, verá: "Data de vencimento alterada manualmente"

## Código afetado

A coluna é usada em:
- `app.js` linha 3616: Define o valor ao atualizar empréstimo
- `app.js` linha 2317-2329: Exibe estilo amarelo para empréstimos ativos
- `app.js` linha 2557-2569: Exibe estilo amarelo para empréstimos pagos

## Prevenção

Este tipo de erro ocorre quando:
- O código é atualizado com novos campos
- O banco de dados não é atualizado correspondentemente
- Não há migrações automáticas configuradas

**Recomendação**: Sempre que adicionar novos campos no código, execute os scripts SQL correspondentes no banco de dados antes de fazer deploy.
