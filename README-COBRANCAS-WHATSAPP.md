# Sistema de Cobranças via WhatsApp

## 📱 Visão Geral

Nova funcionalidade integrada ao sistema Nexus que permite o envio automatizado de mensagens de cobrança via WhatsApp para clientes com débitos em atraso ou que vencem no dia.

## ✨ Funcionalidades

### 1. Conexão WhatsApp via WPPConnect
- ✅ Conexão através de QR Code
- ✅ Verificação automática de status de conexão
- ✅ Indicador visual de conexão (conectado/desconectado)
- ✅ Botões para conectar e desconectar

### 2. Gestão de Devedores
- ✅ Listagem automática de clientes com débitos
- ✅ Suporte para **Empréstimos** e **Parcelamentos**
- ✅ Identificação de débitos **vencidos** e que **vencem hoje**
- ✅ Exibição de informações detalhadas:
  - Nome do cliente
  - Telefone
  - Tipo de débito (Empréstimo ou Parcela)
  - Valor em aberto
  - Data de vencimento
  - Status (Vencido/Vence Hoje)

### 3. Filtros Avançados
- ✅ Filtro por status: Todos / Vencidos / Vencem Hoje
- ✅ Filtro por tipo: Todos / Empréstimos / Parcelamentos
- ✅ Configuração de delay entre mensagens (padrão: 10 minutos)

### 4. Envio de Mensagens
- ✅ Seleção individual ou em massa de devedores
- ✅ Botão "Selecionar Todos" e "Desmarcar Todos"
- ✅ Envio automático com delay configurável (evita bloqueio do WhatsApp)
- ✅ Envio individual através do botão "Enviar Agora"
- ✅ Mensagens personalizadas por tipo de débito e status
- ✅ Possibilidade de pausar o envio a qualquer momento

### 5. Acompanhamento em Tempo Real
- ✅ Barra de progresso visual
- ✅ Log detalhado de envios (sucesso/falha)
- ✅ Contador de mensagens enviadas
- ✅ Estatísticas em cards:
  - Total de devedores
  - Quantidade de vencidos
  - Quantidade que vencem hoje
  - Total de mensagens enviadas

## 🚀 Como Usar

### Passo 1: Conectar WhatsApp
1. Acesse a aba **"Cobranças WhatsApp"** no menu lateral
2. Clique no botão **"Conectar WhatsApp"**
3. Aguarde o QR Code aparecer na tela
4. Escaneie o QR Code com seu WhatsApp
5. Aguarde a confirmação de conexão

### Passo 2: Carregar Devedores
1. Após conectar o WhatsApp, clique no botão de **atualizar** (ícone de seta circular)
2. O sistema carregará automaticamente todos os clientes com débitos:
   - Empréstimos ativos vencidos ou que vencem hoje
   - Parcelamentos pendentes vencidos ou que vencem hoje

### Passo 3: Filtrar e Selecionar
1. Use os filtros para refinar a lista:
   - **Status**: Vencidos, Vencem Hoje ou Todos
   - **Tipo**: Empréstimos, Parcelamentos ou Todos
2. Configure o delay entre mensagens (recomendado: 10 minutos)
3. Selecione os devedores desejados:
   - Use checkboxes individuais
   - Ou clique em **"Selecionar Todos"**

### Passo 4: Enviar Cobranças
1. Clique no botão **"Enviar Cobranças Selecionadas"**
2. Confirme a quantidade de mensagens a serem enviadas
3. Acompanhe o progresso em tempo real
4. Aguarde a conclusão do envio

> **Nota:** Você pode enviar uma mensagem individual clicando em "Enviar Agora" na coluna de ações.

## 📊 API WPPConnect

### Configuração
A API já está configurada e rodando em:
```
URL: http://212.85.19.210:21465
Session: nexus-collections
```

### Endpoints Utilizados
- `POST /{session}/start-session` - Inicia sessão e gera QR Code
- `GET /{session}/check-connection-session` - Verifica status da conexão
- `POST /{session}/send-message` - Envia mensagem para um número
- `POST /{session}/close-session` - Encerra a sessão

### Documentação Completa
Acesse: http://212.85.19.210:21465/api-docs

## 💬 Formato das Mensagens

### Para Débitos Vencidos

**Empréstimo:**
```
Olá, [Nome do Cliente]! 👋

⚠️ Identificamos que seu empréstimo está vencido.

💰 Valor em aberto: R$ X.XXX,XX
📅 Data de vencimento: DD/MM/AAAA

Por favor, regularize sua situação o quanto antes para evitar multas adicionais.

Para mais informações, entre em contato conosco.

Atenciosamente,
Equipe Nexus 💙
```

**Parcela:**
```
Olá, [Nome do Cliente]! 👋

⚠️ Identificamos que a parcela X do seu empréstimo está vencida.

💰 Valor em aberto: R$ XXX,XX
📅 Data de vencimento: DD/MM/AAAA

Por favor, regularize sua situação o quanto antes para evitar multas adicionais.

Para mais informações, entre em contato conosco.

Atenciosamente,
Equipe Nexus 💙
```

### Para Débitos que Vencem Hoje

Similar às mensagens acima, mas com o texto:
- `⏰ Seu empréstimo vence HOJE!`
- `⏰ A parcela X do seu empréstimo vence HOJE!`

E a orientação:
- `Por favor, realize o pagamento hoje para evitar juros e multas.`

## ⚙️ Configurações Técnicas

### Delay entre Mensagens
- **Padrão:** 10 minutos
- **Mínimo:** 1 minuto
- **Configurável:** Campo "Delay entre Mensagens (minutos)"

> **Importante:** O delay é essencial para evitar que o WhatsApp identifique como SPAM e bloqueie o número.

### Formato de Telefone
O sistema formata automaticamente os números para o padrão brasileiro:
- Remove caracteres não numéricos
- Adiciona código do país (55) se necessário
- Formato final: 55DDNNNNNNNNN

### Queries ao Banco de Dados
O sistema busca automaticamente:

**Empréstimos:**
- Status: `active`
- Data de vencimento: menor que hoje (vencidos) ou igual a hoje (vencem hoje)
- Empresa: da sessão atual do usuário

**Parcelamentos:**
- Status: `pending`
- Data de vencimento: menor que hoje (vencidos) ou igual a hoje (vencem hoje)
- Empresa: da sessão atual do usuário (através do loan)

## 🔒 Segurança

- ✅ Validação de conexão WhatsApp antes de enviar mensagens
- ✅ Confirmação obrigatória antes do envio em massa
- ✅ Possibilidade de cancelar envio a qualquer momento
- ✅ Isolamento por empresa (cada usuário vê apenas seus clientes)
- ✅ Log completo de todas as operações

## 📈 Estatísticas

O sistema exibe em tempo real:
- **Total de Devedores:** Quantidade total de clientes com débitos
- **Vencidos:** Quantidade de débitos já vencidos
- **Vencem Hoje:** Quantidade de débitos que vencem hoje
- **Mensagens Enviadas:** Contador total de mensagens enviadas na sessão

## 🐛 Solução de Problemas

### WhatsApp não conecta
1. Verifique se a API está online: http://212.85.19.210:21465/api-docs
2. Tente desconectar e conectar novamente
3. Certifique-se de que o QR Code está visível e válido

### Mensagens não são enviadas
1. Verifique se o WhatsApp está conectado (indicador verde)
2. Verifique se o número do cliente está no formato correto
3. Verifique o log de envio para identificar erros específicos

### Lista de devedores vazia
1. Clique no botão de atualizar (ícone de seta circular)
2. Verifique se existem empréstimos/parcelamentos vencidos ou que vencem hoje
3. Verifique se está na empresa correta

## 📝 Notas Importantes

1. **Uso Responsável:** Use esta funcionalidade de forma ética e respeitosa
2. **LGPD:** Certifique-se de ter consentimento dos clientes para envio de mensagens
3. **WhatsApp Business:** Recomenda-se usar uma conta WhatsApp Business
4. **Monitoramento:** Acompanhe o log de envios para identificar problemas
5. **Delay:** Respeite o delay configurado para evitar bloqueios

## 🎯 Próximos Passos (Sugestões)

- [ ] Adicionar templates de mensagens personalizáveis
- [ ] Implementar agendamento de envios
- [ ] Adicionar histórico de mensagens enviadas
- [ ] Integrar com outros canais (SMS, E-mail)
- [ ] Adicionar relatórios de efetividade das cobranças
- [ ] Implementar respostas automáticas

## 🆘 Suporte

Para dúvidas ou problemas:
1. Verifique este README
2. Consulte a documentação da API: http://212.85.19.210:21465/api-docs
3. Entre em contato com o suporte técnico

---

**Desenvolvido para:** Sistema Nexus Gestão Financeira  
**Data:** Janeiro 2026  
**Versão:** 1.0.0

