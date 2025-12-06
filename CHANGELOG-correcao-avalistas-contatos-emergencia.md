# CHANGELOG - Correção Salvamento Avalistas e Contatos de Emergência

## [6 de Dezembro de 2025] - Correção de Bug Crítico

### 🐛 Bug Corrigido

**Problema:** Avalistas e contatos de emergência não estavam sendo salvos no sistema Franca Private quando adicionados através do modal de edição de cliente.

**Sintoma:** Ao tentar adicionar um avalista através do botão "Adicionar Avalista" no modal de edição do cliente, o sistema não salvava os dados no banco de dados.

### 🔧 Correção Aplicada

**Arquivo:** `app.js`  
**Função:** `handleGuarantorForm` (linha ~5390)  
**Alteração:** Adicionada linha `formData.created_by = currentUser.id;` antes do insert

```diff
} else {
    // Criar novo avalista
+   formData.created_by = currentUser.id;
    formData.created_at = new Date().toISOString();
    
    const { data, error } = await supabase
        .from('guarantors')
        .insert([formData])
        .select();
```

### ✅ Verificações Realizadas

- ✅ Validação de todos os pontos de inserção de avalistas no sistema
- ✅ Validação de todos os pontos de inserção de contatos de emergência
- ✅ Verificação de erros de lint (nenhum erro encontrado)
- ✅ Criação de documentação detalhada

### 📝 Notas Importantes

1. **Contatos de Emergência**: Já estavam funcionando corretamente, sem necessidade de correção
2. **Criação de Cliente com Avalista**: Já estava funcionando corretamente
3. **Único ponto corrigido**: Modal de adicionar avalista em cliente existente

### 🧪 Como Testar

1. Faça login no sistema Franca Private
2. Vá para a seção de Clientes
3. Clique no ícone de editar (✏️) de qualquer cliente
4. Role até a seção "Avalistas"
5. Clique em "+ Adicionar Avalista"
6. Preencha os dados obrigatórios:
   - Nome completo
   - CPF
   - Telefone
7. Clique em "Salvar"
8. Verifique se o avalista aparece na lista
9. (Opcional) Verifique no banco de dados Supabase se o registro foi criado com `created_by` preenchido

### 📚 Documentação

Criado arquivo: `README-correcao-salvamento-avalistas-contatos-emergencia.md` com documentação completa da correção.

### 🎯 Impacto

- **Severidade:** Alta (funcionalidade crítica não estava funcionando)
- **Sistemas Afetados:** Franca Private (e potencialmente outros sistemas multi-empresa)
- **Usuários Impactados:** Todos os usuários que tentavam adicionar avalistas via modal
- **Compatibilidade:** 100% compatível com código existente, sem breaking changes

### 🔐 Segurança

A correção não introduz nenhum risco de segurança. Pelo contrário, garante que o campo `created_by` seja sempre preenchido, melhorando a auditoria do sistema.
