# Correção: Salvamento de Avalistas e Contatos de Emergência - Franca Private

## Problema Identificado

No sistema Franca Private, os avalistas e contatos de emergência não estavam sendo salvos corretamente quando adicionados através do modal de edição de cliente.

## Causa Raiz

Na função `handleGuarantorForm` (arquivo `app.js`, linha ~5390), quando um novo avalista era criado, o campo `created_by` não estava sendo definido antes do insert no banco de dados. Este campo é obrigatório na tabela `guarantors` e sua ausência causava erro no salvamento.

### Código Original (COM PROBLEMA):

```javascript
} else {
    // Criar novo avalista
    formData.created_at = new Date().toISOString();
    
    const { data, error } = await supabase
        .from('guarantors')
        .insert([formData])
        .select();
    
    if (error) throw error;
    
    showSuccessMessage(`Avalista "${formData.name}" adicionado com sucesso!`);
}
```

### Código Corrigido:

```javascript
} else {
    // Criar novo avalista
    formData.created_by = currentUser.id;
    formData.created_at = new Date().toISOString();
    
    const { data, error } = await supabase
        .from('guarantors')
        .insert([formData])
        .select();
    
    if (error) throw error;
    
    showSuccessMessage(`Avalista "${formData.name}" adicionado com sucesso!`);
}
```

## Alteração Realizada

Foi adicionada a linha `formData.created_by = currentUser.id;` antes da inserção do avalista no banco de dados, garantindo que o campo obrigatório seja preenchido corretamente.

## Verificação de Outros Pontos

Durante a correção, foram verificados todos os locais do sistema onde avalistas e contatos de emergência são salvos:

1. ✅ **handleNewClient** - Criação de cliente com avalista: Já estava correto
2. ✅ **handleNewClient** - Criação de cliente com contato de emergência: Já estava correto
3. ✅ **handleGuarantorForm** - Criação de avalista via modal: **CORRIGIDO**
4. ✅ **handleEmergencyContactForm** - Criação de contato de emergência via modal: Já estava correto

## Impacto

Esta correção resolve o problema de salvamento de avalistas quando adicionados através do modal de gerenciamento de avalistas. Os contatos de emergência já estavam funcionando corretamente.

## Teste Recomendado

Para verificar se a correção está funcionando:

1. Acesse o sistema Franca Private
2. Edite um cliente existente
3. Clique em "Adicionar Avalista"
4. Preencha os dados do avalista (nome, CPF e telefone são obrigatórios)
5. Salve o formulário
6. Verifique se o avalista aparece na lista de avalistas do cliente
7. Verifique no banco de dados se o registro foi criado com o campo `created_by` preenchido

## Data da Correção

6 de dezembro de 2025

## Arquivos Modificados

- `app.js` - Função `handleGuarantorForm` (linha ~5390)
