# Funcionalidade: Contato com Avalistas e Contatos de Emergência

## 📋 Descrição

Esta funcionalidade permite entrar em contato com **avalistas** ou **contatos de emergência** de clientes diretamente da aba de empréstimos, enviando mensagens automáticas via WhatsApp.

## ✨ Características

### 1. **Botão de Contato na Tabela de Empréstimos**
- Novo botão 👥 (ícone cyan/azul claro) adicionado nas ações de cada empréstimo
- Localizado ao lado dos outros botões de ação
- Tooltip: "Contatar Avalista ou Emergência"

### 2. **Detecção Automática de Contatos**
O sistema busca automaticamente:
- **Avalistas** cadastrados para o cliente
- **Contatos de emergência** cadastrados para o cliente

### 3. **Modal de Seleção de Contatos**
Quando há múltiplos contatos disponíveis, um modal é exibido com:
- Lista de avalistas (com foto, nome, telefone e relacionamento)
- Lista de contatos de emergência (com nome, telefone e relacionamento)
- Visual diferenciado:
  - 👥 Avalistas em azul
  - 🚨 Contatos de emergência em amarelo

### 4. **Envio Automático para Contato Único**
Se houver apenas um contato disponível (avalista ou emergência), a mensagem é enviada automaticamente sem necessidade de seleção.

### 5. **Mensagem Automática Personalizada**

#### Para Avalistas (👥):
```
👥 ATENÇÃO - CONTATO SOBRE EMPRÉSTIMO

Olá, [Nome do Avalista]!

Estamos entrando em contato com você como avalista do(a) cliente [Nome do Cliente].

📋 INFORMAÇÕES DO EMPRÉSTIMO:
👤 Cliente: [Nome]
📅 Data de Vencimento: [Data]
💰 Valor do Capital: R$ [Valor]
📈 Juros: R$ [Valor]
💳 Valor Total: R$ [Valor]
💸 Valor Restante: R$ [Valor]
⚠️ Multa acumulada: R$ [Valor] (X dias em atraso)

[Status do empréstimo - vencido ou próximo do vencimento]

⚠️ IMPORTANTE:
Como avalista deste empréstimo, você é corresponsável pelo pagamento caso o cliente não honre o compromisso.

Após o vencimento, incide uma multa diária de R$ 50,00.

📱 Por favor, entre em contato com [Nome do Cliente] pelo telefone [Telefone] com urgência.

Agradecemos sua colaboração!
```

#### Para Contatos de Emergência (🚨):
```
🚨 ATENÇÃO - CONTATO SOBRE EMPRÉSTIMO

Olá, [Nome do Contato]!

Estamos entrando em contato com você como contato de emergência do(a) cliente [Nome do Cliente].

[... mesmas informações do empréstimo ...]

⚠️ IMPORTANTE:
Como contato de emergência, pedimos sua ajuda para localizar ou alertar o(a) cliente sobre a necessidade de regularização.

[... resto da mensagem ...]
```

### 6. **Cálculo Inteligente de Valores**
A mensagem inclui cálculos automáticos de:
- Valor do capital
- Juros
- Valor total com juros
- Valor restante (considerando pagamentos já realizados)
- Multa acumulada (R$ 50,00/dia após vencimento)
- Dias de atraso (se aplicável)

## 🎯 Como Usar

### Passo 1: Acessar a Aba de Empréstimos
1. Faça login no sistema
2. Navegue até a aba "Empréstimos"

### Passo 2: Localizar o Empréstimo
1. Encontre o empréstimo desejado na tabela
2. Identifique o botão 👥 (cyan) nas ações

### Passo 3: Clicar no Botão de Contato
- Se não houver contatos cadastrados: mensagem de erro
- Se houver um único contato: WhatsApp abre automaticamente
- Se houver múltiplos contatos: modal de seleção aparece

### Passo 4: Selecionar o Contato (se necessário)
1. No modal, escolha entre avalistas ou contatos de emergência
2. Clique no contato desejado
3. O WhatsApp Web abrirá automaticamente com a mensagem pronta

### Passo 5: Enviar a Mensagem
1. Revise a mensagem automática no WhatsApp
2. Faça ajustes se necessário
3. Envie a mensagem

## ⚠️ Validações

O sistema verifica:
- ✅ Se o empréstimo existe
- ✅ Se o cliente tem dados cadastrados
- ✅ Se há pelo menos um contato (avalista ou emergência) cadastrado
- ✅ Se o contato possui telefone cadastrado
- ✅ Se há erros ao buscar dados do banco

## 📱 Formato do Telefone

O sistema formata automaticamente o telefone:
- Remove caracteres especiais (parênteses, hífens, espaços)
- Adiciona o código do país +55 se não estiver presente
- Formato final: `55XXXXXXXXXXX`

## 🎨 Interface

### Botão na Tabela
- **Cor**: Cyan (azul claro)
- **Ícone**: 👥
- **Posição**: Entre o botão de WhatsApp (📞) e o de deletar (🗑️)
- **Hover**: Efeito de mudança de cor

### Modal de Seleção
- **Layout**: Responsivo e centralizado
- **Tamanho**: Max 2xl width, 90% altura da viewport
- **Scroll**: Automático para muitos contatos
- **Fechamento**: Clique no X ou ao selecionar um contato

## 🔍 Diferenças entre Avalista e Contato de Emergência

| Característica | Avalista | Contato de Emergência |
|----------------|----------|------------------------|
| **Ícone** | 👥 | 🚨 |
| **Cor** | Azul | Amarelo |
| **Responsabilidade** | Corresponsável pelo pagamento | Apenas auxílio para localizar cliente |
| **Mensagem** | Enfatiza responsabilidade legal | Solicita ajuda para contatar cliente |
| **Obrigação** | Legal e financeira | Moral e de auxílio |

## 🚀 Benefícios

1. **Agilidade**: Contato rápido com responsáveis
2. **Automação**: Mensagens padronizadas e completas
3. **Transparência**: Todas as informações do empréstimo incluídas
4. **Flexibilidade**: Escolha entre múltiplos contatos
5. **Rastreabilidade**: Histórico de mensagens no WhatsApp
6. **Profissionalismo**: Mensagens formatadas e claras

## 📝 Observações

- A mensagem é enviada via WhatsApp Web (wa.me)
- Requer que o WhatsApp esteja configurado no dispositivo
- O envio é feito em nova aba do navegador
- A mensagem pode ser editada antes do envio no WhatsApp
- Não há limite de envios
- Funciona em desktop e mobile

## 🔧 Requisitos Técnicos

- Tabela `guarantors` deve existir no banco de dados
- Tabela `emergency_contacts` deve existir no banco de dados
- Contatos devem ter telefone cadastrado
- Internet ativa para acessar WhatsApp Web

## 💡 Casos de Uso

### Caso 1: Empréstimo Próximo do Vencimento
Usar para alertar avalista ou contato de emergência antes do vencimento.

### Caso 2: Empréstimo Vencido
Informar sobre atraso e solicitar ação imediata.

### Caso 3: Cliente Inadimplente
Acionar avalista sobre responsabilidade ou contato de emergência para localizar cliente.

### Caso 4: Renovação de Empréstimo
Comunicar sobre necessidade de renovação ou pagamento.

## 🎯 Boas Práticas

1. **Use com Moderação**: Evite spam de mensagens
2. **Seja Profissional**: Mantenha tom educado e claro
3. **Documente**: Guarde registro de quando enviou mensagens
4. **Respeite Horários**: Envie em horários comerciais
5. **Seja Transparente**: Todas as informações devem estar corretas

## 📊 Informações Incluídas na Mensagem

- ✅ Nome do contato
- ✅ Nome do cliente
- ✅ Tipo de contato (avalista ou emergência)
- ✅ Data de vencimento
- ✅ Valor do capital
- ✅ Juros
- ✅ Valor total
- ✅ Valor restante
- ✅ Multa acumulada (se houver)
- ✅ Dias de atraso (se houver)
- ✅ Telefone do cliente
- ✅ Orientações específicas por tipo de contato

## 🐛 Tratamento de Erros

O sistema exibe mensagens claras em caso de:
- ❌ Empréstimo não encontrado
- ❌ Cliente sem dados
- ❌ Sem contatos cadastrados
- ❌ Contato sem telefone
- ❌ Erro ao buscar dados do banco
- ❌ Erro ao enviar mensagem

## 🔄 Fluxo Completo

```
Usuário clica no botão 👥
    ↓
Sistema busca avalistas e contatos de emergência
    ↓
[Nenhum contato?] → Mensagem de erro
    ↓
[Um contato apenas?] → Envia direto
    ↓
[Múltiplos contatos?] → Abre modal de seleção
    ↓
Usuário seleciona contato
    ↓
Sistema calcula valores do empréstimo
    ↓
Sistema gera mensagem personalizada
    ↓
WhatsApp abre com mensagem pronta
    ↓
Usuário revisa e envia
```

---

## 🔄 Changelog

### Versão 1.1 - 2025-11-10
**Correção de Bug - UUID Inválido**
- ✅ Corrigido erro "invalid input syntax for type uuid: 'undefined'"
- ✅ Função `contactGuarantorOrEmergency` agora usa `loan.client_id` diretamente
- ✅ Adicionada busca explícita de dados do cliente via Supabase
- ✅ Criada função auxiliar `sendContactMessageById` para melhor separação de responsabilidades
- ✅ Simplificado modal para passar apenas IDs em vez de objetos JSON complexos
- ✅ Melhorada robustez e tratamento de erros

**Mudanças Técnicas:**
- Modal agora chama `sendContactMessageById(loanId, contactId, contactType)`
- Dados de cliente e contato são buscados frescos do banco antes de enviar mensagem
- Reduzida complexidade de passar objetos via `onclick` em HTML dinâmico

### Versão 1.0 - 2025-11-10
**Lançamento Inicial**
- ✅ Botão de contato na tabela de empréstimos
- ✅ Modal de seleção de contatos
- ✅ Mensagens automáticas para avalistas e contatos de emergência
- ✅ Integração com WhatsApp

---

**Versão Atual**: 1.1  
**Data**: 2025-11-10  
**Desenvolvido para**: Sistema de Gestão de Empréstimos
