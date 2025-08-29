# Sistema de Documentos dos Clientes

Este documento explica como usar a nova funcionalidade de gerenciamento de documentos dos clientes.

## 🚀 Funcionalidades Implementadas

### ✅ Ícone de Documentos na Tabela de Clientes
- Adicionado ícone 📄 na coluna "Ações" da tabela de clientes
- Cor verde para identificação fácil
- Tooltip "Documentos" ao passar o mouse

### ✅ Modal de Gerenciamento de Documentos
- Modal completo com seções de upload e visualização
- Interface responsiva e moderna
- Organização por categorias de documentos

### ✅ Upload de Documentos
- Formulário para upload com campos:
  - Nome do documento
  - Categoria (Identificação, Comprovante de Renda, etc.)
  - Arquivo (PDF, JPG, PNG, DOC, DOCX)
  - Observações (opcional)
- Validação de tamanho (máximo 10MB)
- Feedback visual durante o upload

### ✅ Visualização de Documentos
- Lista organizada de todos os documentos do cliente
- Filtro por categoria
- Ícones diferentes para tipos de arquivo (📄 PDF, 🖼️ imagens, 📎 outros)
- Data e hora de upload
- Observações quando disponíveis

### ✅ Ações nos Documentos
- **Ver**: Abre o documento em nova aba
- **Baixar**: Download direto do arquivo
- **Excluir**: Remove o documento (com confirmação)

## 📋 Categorias de Documentos

1. **Identificação**: RG, CPF, CNH, etc.
2. **Comprovante de Renda**: Holerites, declarações, etc.
3. **Comprovante de Residência**: Contas de luz, água, etc.
4. **Referências**: Cartas de recomendação, referências comerciais
5. **Outros**: Documentos diversos

## 🛠️ Configuração Necessária

### 1. Banco de Dados
Execute o script `setup-client-documents-table.sql` no seu banco Supabase:

```sql
-- O script criará:
-- ✓ Tabela client_documents
-- ✓ Índices para performance
-- ✓ Triggers para updated_at
-- ✓ Políticas RLS básicas
```

### 2. Storage no Supabase
No painel do Supabase, crie o bucket de storage:

1. Vá para **Storage** → **Buckets**
2. Clique em **New Bucket**
3. Nome: `client-documents`
4. Público: **Não** (Private)
5. Confirme a criação

### 3. Políticas de Storage
Execute no SQL Editor do Supabase:

```sql
-- Política para upload
CREATE POLICY "Enable upload for client documents" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'client-documents');

-- Política para download
CREATE POLICY "Enable download for client documents" ON storage.objects
    FOR SELECT USING (bucket_id = 'client-documents');

-- Política para exclusão
CREATE POLICY "Enable delete for client documents" ON storage.objects
    FOR DELETE USING (bucket_id = 'client-documents');
```

## 📱 Como Usar

### Para Adicionar Documentos:
1. Na aba **Clientes**, clique no ícone 📄 do cliente desejado
2. No modal que abrir, preencha o formulário de upload:
   - Digite o nome do documento
   - Selecione a categoria
   - Escolha o arquivo
   - Adicione observações (opcional)
3. Clique em **Fazer Upload**

### Para Visualizar Documentos:
1. No mesmo modal, role para baixo até "Documentos Salvos"
2. Use o filtro por categoria se necessário
3. Clique em **👁️ Ver** para abrir o documento
4. Clique em **⬇️ Baixar** para fazer download
5. Clique em **🗑️** para excluir (com confirmação)

## 🔒 Segurança

- Todos os arquivos são armazenados de forma privada no Supabase Storage
- Cada cliente só tem acesso aos próprios documentos
- Validação de tipos de arquivo aceitos
- Limite de tamanho por arquivo (10MB)
- URLs de acesso são temporárias e seguras

## 🎨 Interface

- Design consistente com o tema do sistema
- Cores e ícones intuitivos
- Responsivo para desktop e mobile
- Feedback visual para todas as ações
- Loading states durante uploads

## 📊 Estrutura da Tabela

```sql
client_documents (
    id              UUID PRIMARY KEY,
    client_id       UUID (FK → clients.id),
    name            VARCHAR(255),
    category        VARCHAR(50),
    file_path       TEXT,
    file_type       VARCHAR(100),
    file_size       INTEGER,
    notes           TEXT,
    created_at      TIMESTAMP,
    updated_at      TIMESTAMP
)
```

## 🔧 Arquivos Modificados

- `index.html`: Adicionado modal de documentos
- `app.js`: Implementadas todas as funções de gerenciamento
- `setup-client-documents-table.sql`: Script de criação da tabela

## ⚡ Performance

- Índices otimizados para consultas por cliente e categoria
- Paginação automática para grandes volumes de documentos
- Cache de documentos carregados
- Uploads assíncronos com feedback

---

**Nota**: Certifique-se de executar o script SQL e configurar o Storage antes de usar a funcionalidade.