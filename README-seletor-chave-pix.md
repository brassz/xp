# Seletor de Chave PIX para Cobrança via WhatsApp

## Resumo das Alterações

Foi implementada uma nova funcionalidade que permite selecionar a chave PIX antes de enviar cobranças via WhatsApp. Agora, quando o usuário clica no botão de cobrança (📞), um modal é aberto para escolher qual chave PIX usar para a cobrança.

## Funcionalidades Implementadas

### 1. Modal de Seleção de Chave PIX
- **Interface moderna**: Modal com design glass-card consistente com o sistema
- **Lista de chaves**: Exibe todas as chaves PIX ativas cadastradas
- **Informações detalhadas**: Mostra banco, titular, tipo de chave e chave mascarada
- **Seleção intuitiva**: Click para selecionar a chave desejada

### 2. Gerenciamento de Chaves PIX
- **Cadastro de novas chaves**: Modal para adicionar novas chaves PIX
- **Tipos suportados**: CPF, CNPJ, E-mail, Telefone, Chave Aleatória
- **Mascaramento de segurança**: Chaves são exibidas parcialmente mascaradas
- **Validação**: Todos os campos são obrigatórios

### 3. Integração com Cobrança
- **Empréstimos**: Funciona na aba de empréstimos
- **Parcelamentos**: Funciona na aba de parcelamentos
- **Mensagem personalizada**: Inclui dados da chave PIX na mensagem do WhatsApp
- **Identificação do banco**: Nome do banco aparece na mensagem

## Arquivos Modificados

### 1. `index.html`
- Adicionado modal de seleção de chave PIX
- Adicionado modal para cadastrar nova chave PIX
- Interface responsiva e moderna

### 2. `app.js`
- **Novos botões**: Alterado `onclick` dos botões de cobrança
- **Novas funções**:
  - `showPixKeySelector()` - Abre modal para empréstimos
  - `showPixKeySelectorForInstallment()` - Abre modal para parcelamentos
  - `loadPixKeys()` - Carrega chaves PIX do banco
  - `selectPixKey()` - Processa seleção da chave
  - `sendWhatsAppMessageWithPixKey()` - Envia cobrança de empréstimo com PIX
  - `sendInstallmentWhatsAppMessageWithPixKey()` - Envia cobrança de parcelamento com PIX
  - Funções auxiliares para mascaramento e gerenciamento

### 3. `setup-pix-keys-table.sql`
- **Nova tabela**: `pix_keys` para armazenar as chaves PIX
- **Campos**: id, bank_name, pix_key, pix_key_type, account_holder, is_active
- **Políticas RLS**: Segurança para usuários autenticados
- **Dados de exemplo**: 5 chaves PIX de exemplo para teste

## Como Usar

### 1. Configuração Inicial
1. Execute o arquivo `setup-pix-keys-table.sql` no SQL Editor do Supabase
2. As chaves PIX de exemplo serão criadas automaticamente

### 2. Enviando Cobrança
1. Na aba **Empréstimos** ou **Parcelamentos**, clique no botão 📞 (WhatsApp)
2. Um modal será aberto com as chaves PIX disponíveis
3. Selecione a chave PIX desejada (ex: Banco X, Banco Y, Banco Z)
4. A mensagem do WhatsApp será aberta com os dados da chave PIX selecionada

### 3. Cadastrando Nova Chave PIX
1. No modal de seleção, clique em **"+ Nova Chave PIX"**
2. Preencha os dados:
   - Nome do Banco
   - Tipo da Chave (CPF, CNPJ, E-mail, etc.)
   - Chave PIX
   - Titular da Conta
3. Clique em **"Salvar Chave PIX"**

## Exemplo de Uso

**Cenário**: Cliente Ana Clara tem um empréstimo vencido

**Antes**: 
- Click no 📞 → Abre WhatsApp diretamente

**Agora**:
1. Click no 📞 → Abre modal de seleção
2. Opções disponíveis:
   - 🏦 **Banco do Brasil** - João Silva (CPF: 123.***.**01)
   - 🏦 **Itaú** - João Silva (E-mail: jo***@email.com)
   - 🏦 **Nubank** - João Silva (Telefone: (11) 98765-****)
3. Seleciona "Banco do Brasil"
4. WhatsApp abre com mensagem incluindo:
   ```
   💸 DADOS PARA PAGAMENTO PIX:
   🏦 Banco: Banco do Brasil
   🔑 Chave PIX: 12345678901
   ```

## Benefícios

1. **Flexibilidade**: Permite escolher qual conta receber o pagamento
2. **Organização**: Diferentes bancos para diferentes clientes
3. **Transparência**: Cliente sabe exatamente onde depositar
4. **Eficiência**: Reduz erros de pagamento em conta errada
5. **Profissionalismo**: Mensagem mais completa e informativa

## Estrutura da Tabela PIX Keys

```sql
CREATE TABLE pix_keys (
    id UUID PRIMARY KEY,
    bank_name VARCHAR(100) NOT NULL,
    pix_key VARCHAR(255) NOT NULL,
    pix_key_type VARCHAR(20) CHECK (pix_key_type IN ('cpf', 'cnpj', 'email', 'phone', 'random')),
    account_holder VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

## Segurança

- **RLS habilitado**: Apenas usuários autenticados podem acessar
- **Mascaramento**: Chaves PIX são exibidas parcialmente mascaradas
- **Validação**: Campos obrigatórios e tipos de chave validados
- **Soft delete**: Campo `is_active` para desativar sem excluir

## Próximos Passos Sugeridos

1. **Edição de chaves**: Permitir editar chaves PIX existentes
2. **Ordenação personalizada**: Permitir definir ordem de exibição
3. **Chaves por cliente**: Associar chaves PIX específicas a clientes
4. **Relatórios**: Relatório de uso das chaves PIX
5. **Backup**: Sistema de backup das chaves PIX