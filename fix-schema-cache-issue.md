# Solução para o Erro: "Could not find the 'birth_date' column of 'clients' in the schema cache"

## Análise do Problema

O erro indica que a aplicação está tentando acessar uma coluna `birth_date` na tabela `clients` que não existe no esquema atual do banco de dados. Isso é um problema de cache de esquema do Supabase.

Após análise do código:
- A tabela `clients` no arquivo `database-setup.sql` NÃO contém uma coluna `birth_date`
- O código JavaScript não faz referência a `birth_date` em nenhum lugar
- O formulário HTML também não possui campo `birth_date`

## Possíveis Causas

1. **Cache do Supabase desatualizado**: O cliente Supabase pode ter um cache de esquema antigo
2. **Cache do navegador**: Pode haver JavaScript em cache que referencia a coluna
3. **Versão anterior**: A aplicação pode ter tido essa coluna anteriormente

## Soluções

### Solução 1: Limpar Cache do Navegador
1. Pressione `Ctrl+Shift+R` (ou `Cmd+Shift+R` no Mac) para fazer um hard refresh
2. Ou abra o DevTools (F12), clique com botão direito no botão de refresh e selecione "Empty Cache and Hard Reload"

### Solução 2: Recriar Cliente Supabase
Adicione esta função temporária no `app.js` para recriar o cliente Supabase:

```javascript
// Função temporária para limpar cache do Supabase
function clearSupabaseCache() {
    // Recriar cliente Supabase
    window.supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    console.log('Cliente Supabase recriado');
}

// Chamar antes de tentar criar um cliente
// clearSupabaseCache();
```

### Solução 3: Verificar Schema no Supabase Dashboard
1. Acesse o Supabase Dashboard
2. Vá para "Table Editor"
3. Verifique se a tabela `clients` tem as colunas corretas
4. Se houver uma coluna `birth_date`, remova-a ou atualize o código para usá-la

### Solução 4: Executar Query SQL para Verificar Schema
Execute esta query no SQL Editor do Supabase:

```sql
-- Verificar colunas da tabela clients
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'clients' 
ORDER BY ordinal_position;
```

### Solução 5: Recriar Tabela (Se Necessário)
Se a tabela estiver corrompida, execute:

```sql
-- Backup dos dados (se houver)
CREATE TABLE clients_backup AS SELECT * FROM clients;

-- Dropar e recriar tabela
DROP TABLE IF EXISTS clients CASCADE;

-- Executar novamente o script de criação da tabela
-- (código do database-setup.sql)
```

## Código de Teste
Para testar se o problema foi resolvido, adicione este código temporário:

```javascript
// Função de teste
async function testClientCreation() {
    try {
        const testData = {
            name: 'Teste',
            cpf: '123.456.789-00',
            email: 'teste@teste.com',
            phone: '(11) 99999-9999',
            address: 'Endereço teste',
            photo: null,
            created_by: currentUser?.id || '00000000-0000-0000-0000-000000000000'
        };
        
        const { data, error } = await supabase
            .from('clients')
            .insert([testData])
            .select();
            
        if (error) {
            console.error('Erro no teste:', error);
        } else {
            console.log('Teste bem-sucedido:', data);
            // Remover o registro de teste
            await supabase.from('clients').delete().eq('id', data[0].id);
        }
    } catch (error) {
        console.error('Erro no teste:', error);
    }
}
```

## Recomendação
Comece com a **Solução 1** (limpar cache do navegador) e teste. Se não funcionar, tente a **Solução 2** (recriar cliente Supabase).