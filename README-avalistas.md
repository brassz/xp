# Gestão de Avalistas - Nexus Gestão Financeira

## Visão Geral

A funcionalidade de avalistas foi implementada para permitir que cada cliente possa ter um ou mais avalistas associados. Um avalista é uma pessoa que garante o pagamento de um empréstimo caso o cliente principal não consiga cumprir suas obrigações.

## Funcionalidades Implementadas

### 1. Estrutura do Banco de Dados

Foi criada a tabela `guarantors` com os seguintes campos:
- `id`: Identificador único do avalista (UUID)
- `client_id`: Referência ao cliente (FK para table clients)
- `name`: Nome completo do avalista
- `cpf`: CPF do avalista
- `rg`: RG do avalista (opcional)
- `email`: Email do avalista (opcional)
- `phone`: Telefone do avalista (obrigatório)
- `address`: Endereço completo (opcional)
- `birth_date`: Data de nascimento (opcional)
- `relationship`: Relacionamento com o cliente (opcional)
- `photo`: URL da foto do avalista (opcional)
- `created_by`: Usuário que criou o registro
- `created_at`: Data de criação
- `updated_at`: Data da última atualização

### 2. Interface do Usuário

#### Modal de Edição de Cliente
- Na aba de edição de clientes, foi adicionada uma nova seção "Avalistas"
- Contém um botão "Adicionar Avalista" para incluir novos avalistas
- Lista todos os avalistas existentes com opções para editar e remover

#### Modal de Avalista
- Modal dedicado para adicionar/editar avalistas
- Campos para todas as informações do avalista
- Upload de foto usando Uploadcare
- Select com opções de relacionamento pré-definidas:
  - Cônjuge
  - Pai/Mãe
  - Filho(a)
  - Irmão/Irmã
  - Parente
  - Amigo(a)
  - Conhecido(a)
  - Outro

### 3. Funcionalidades JavaScript

#### Funções Principais:
- `loadGuarantors()`: Carrega todos os avalistas do banco
- `loadClientGuarantors(clientId)`: Carrega avalistas de um cliente específico
- `loadAndDisplayClientGuarantors(clientId)`: Carrega e exibe avalistas na interface
- `renderGuarantorsList(clientGuarantors, clientId)`: Renderiza a lista de avalistas
- `openGuarantorModal(guarantorId)`: Abre modal para adicionar/editar avalista
- `handleGuarantorForm(e)`: Processa o formulário de avalista
- `editGuarantor(guarantorId)`: Edita um avalista existente
- `deleteGuarantor(guarantorId, guarantorName)`: Exclui um avalista
- `performDeleteGuarantor(guarantorId)`: Executa a exclusão do avalista
- `getRelationshipText(relationship)`: Converte código do relacionamento para texto

## Como Usar

### 1. Instalação da Tabela
Execute o script `setup-guarantors-table.sql` no SQL Editor do Supabase para criar a tabela de avalistas.

### 2. Adicionando um Avalista
1. Vá até a seção "Clientes"
2. Clique no ícone de edição (✏️) de um cliente
3. No modal de edição, encontre a seção "Avalistas"
4. Clique em "Adicionar Avalista"
5. Preencha as informações do avalista
6. Salve o formulário

### 3. Editando um Avalista
1. No modal de edição do cliente, na seção "Avalistas"
2. Clique no ícone de edição (✏️) do avalista desejado
3. Modifique as informações necessárias
4. Salve o formulário

### 4. Removendo um Avalista
1. No modal de edição do cliente, na seção "Avalistas"
2. Clique no ícone de lixeira (🗑️) do avalista desejado
3. Confirme a exclusão

## Segurança e Validações

- A tabela `guarantors` possui constraint de foreign key para garantir integridade referencial
- Campos obrigatórios: `name`, `cpf`, `phone`, `client_id`
- CPF e telefone são validados no frontend
- Relacionamento cascata: se um cliente for excluído, seus avalistas também serão removidos

## Observações Técnicas

### Dependências
- Supabase JavaScript Client
- Uploadcare Widget (para upload de fotos)
- Tailwind CSS (para estilização)

### Permissões no Supabase
Certifique-se de que as políticas RLS (Row Level Security) estejam configuradas adequadamente para a tabela `guarantors` se necessário.

### Upload de Fotos
- As fotos dos avalistas são armazenadas no Uploadcare
- Formato recomendado: imagens quadradas (1:1)
- Redimensionamento automático para 1024x1024px
- Efeitos disponíveis: crop, rotate, enhance, grayscale

## Melhorias Futuras

1. **Relatórios de Avalistas**: Criar relatórios específicos mostrando avalistas por cliente
2. **Busca de Avalistas**: Implementar funcionalidade de busca global de avalistas
3. **Histórico de Avalistas**: Manter histórico quando um avalista for removido
4. **Validação de CPF**: Implementar validação mais robusta de CPF
5. **Integração com Empréstimos**: Exibir informações de avalistas nos detalhes dos empréstimos

## Arquivos Modificados/Criados

### Criados:
- `setup-guarantors-table.sql`: Script de criação da tabela
- `README-avalistas.md`: Documentação da funcionalidade

### Modificados:
- `index.html`: Adicionado modal de avalista e seção no modal de edição de cliente
- `app.js`: Adicionadas variáveis globais, event listeners e todas as funções de gerenciamento de avalistas

## Suporte

Em caso de problemas ou dúvidas sobre a funcionalidade de avalistas, verifique:
1. Se a tabela `guarantors` foi criada corretamente no Supabase
2. Se as permissões estão configuradas adequadamente
3. Se o console do navegador apresenta algum erro JavaScript
4. Se a biblioteca Uploadcare está carregada corretamente