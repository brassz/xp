# Assistente IA - Informações de Clientes

## 📋 Descrição

Nova funcionalidade que adiciona um Assistente de IA ao sistema Nexus para consultar informações detalhadas dos clientes usando linguagem natural. O assistente permite que você faça perguntas em português sobre qualquer cliente e receba respostas completas e formatadas.

## ✨ Funcionalidades

### 🤖 Consulta por Linguagem Natural
- Digite perguntas em linguagem natural como "Me dê as informações do cliente João Silva"
- O assistente extrai automaticamente o nome do cliente e busca as informações
- Interface de chat intuitiva com respostas formatadas

### 📊 Informações Disponíveis

O assistente fornece:

1. **Dados Cadastrais**
   - Nome completo
   - CPF
   - Telefone
   - Endereço

2. **Resumo Financeiro**
   - Total de empréstimos realizados
   - Valor total emprestado
   - Total com juros
   - Total pago
   - Valor restante
   - Número de empréstimos ativos

3. **Status dos Empréstimos**
   - Empréstimos quitados
   - Empréstimos ativos
   - Empréstimos vencidos
   - Empréstimos cancelados

4. **Histórico de Atrasos**
   - Número total de pagamentos atrasados
   - Detalhes de cada atraso (data de vencimento, data de pagamento, dias de atraso)
   - Alertas visuais destacando problemas de pagamento

5. **Empréstimos Ativos/Vencidos**
   - Detalhes completos de cada empréstimo em aberto
   - Valores originais, juros aplicados, valores restantes
   - Datas de vencimento
   - Status atualizado

6. **Anotações e Observações**
   - Notas cadastradas sobre o cliente
   - Observações importantes sobre histórico de pagamentos

## 🎯 Como Usar

### Acessar o Assistente

1. Faça login no sistema Nexus
2. No menu lateral, clique em **"Assistente IA"**
3. A interface do chat será exibida

### Fazer Perguntas

Digite perguntas como:

- "Me dê as informações do cliente João Silva"
- "Qual o histórico do cliente Maria Santos?"
- "Quais empréstimos o cliente Pedro tem?"
- "Cliente Ana Paula"
- "Informações do cliente Carlos Eduardo"

### Exemplos de Uso

**Exemplo 1: Cliente com bom histórico**
```
Usuário: Me dê as informações do cliente João Silva

Assistente: Retorna informações completas incluindo:
- 3 empréstimos realizados
- R$ 5.000,00 total emprestado
- 2 empréstimos quitados
- 1 empréstimo ativo
- Sem histórico de atrasos
```

**Exemplo 2: Cliente com atrasos**
```
Usuário: Informações do cliente Maria Santos

Assistente: Retorna informações completas incluindo:
- 4 empréstimos realizados
- R$ 8.000,00 total emprestado
- 1 empréstimo ativo em atraso
- Alerta destacando 3 pagamentos realizados com atraso
- Detalhes das datas e dias de atraso
```

## 🎨 Interface

### Área de Chat
- **Cabeçalho**: Identificação do Assistente Nexus
- **Mensagens**: Histórico da conversa com scroll automático
- **Input**: Campo de texto para digitar perguntas
- **Botão Enviar**: Envia a pergunta (também funciona com Enter)

### Painel Lateral
- **Como usar**: Instruções rápidas
- **Informações disponíveis**: Lista do que pode ser consultado
- **Dicas**: Orientações para melhores resultados

### Feedback Visual
- Indicador de loading (três pontos animados) enquanto processa
- Mensagens do usuário em azul (lado direito)
- Respostas do assistente em cinza (lado esquerdo)
- Ícones e emojis para facilitar leitura
- Cores diferenciadas para alertas e informações importantes

## 🔍 Processamento de Linguagem Natural

O sistema utiliza algoritmos para:

1. **Extração de Nome**: Remove palavras comuns e extrai o nome do cliente
2. **Busca Inteligente**: Procura por nomes similares no banco de dados
3. **Múltiplos Resultados**: Se encontrar mais de um cliente, lista todos com CPF
4. **Tratamento de Erros**: Mensagens amigáveis quando cliente não é encontrado

## 💡 Dicas de Uso

1. **Seja específico**: Quanto mais completo o nome, mais preciso o resultado
2. **Use variações**: Se não encontrar, tente com nome completo ou apelido
3. **Múltiplos clientes**: Se houver clientes com nomes similares, o sistema listará todos
4. **Scroll automático**: As mensagens mais recentes sempre ficam visíveis

## 🔧 Tecnologias Utilizadas

- **Frontend**: HTML5, Tailwind CSS, JavaScript ES6+
- **Backend**: Supabase (PostgreSQL)
- **Integração**: Conexão direta com tabelas existentes
- **UX**: Interface de chat moderna com animações

## 📊 Estrutura de Dados

O assistente consulta as seguintes tabelas:

- `clients`: Dados dos clientes
- `loans`: Empréstimos realizados
- `payments`: Histórico de pagamentos

## 🚀 Benefícios

1. **Rapidez**: Consulta instantânea de informações complexas
2. **Praticidade**: Não precisa navegar por várias telas
3. **Completude**: Todas as informações em uma única resposta
4. **Intuitividade**: Interface de chat familiar e fácil de usar
5. **Insights**: Destaque automático de problemas como atrasos
6. **Histórico**: Mantém conversa completa na sessão

## 📝 Notas Técnicas

### Campos Suportados

O assistente busca informações dos seguintes campos:

**Clientes:**
- name, cpf, phone, address, notes, observations

**Empréstimos:**
- amount, original_amount, total_amount, paid_amount, remaining_amount
- interest_rate, loan_date, due_date, status

**Pagamentos:**
- payment_date, due_date, amount

### Cálculos Automáticos

- Total emprestado (soma de original_amount)
- Total com juros (soma de total_amount)
- Total pago (soma de paid_amount)
- Valor restante (soma de remaining_amount)
- Dias de atraso (diferença entre payment_date e due_date)
- Estatísticas por status de empréstimo

## 🎯 Casos de Uso

### 1. Análise de Crédito
Consulte rapidamente o histórico de um cliente antes de aprovar novo empréstimo

### 2. Cobrança
Verifique status de pagamentos e histórico de atrasos para ações de cobrança

### 3. Atendimento
Responda perguntas do cliente sobre seu histórico instantaneamente

### 4. Relatórios
Obtenha resumo completo de qualquer cliente para reuniões e decisões

## 🔐 Segurança

- Requer autenticação no sistema
- Consulta apenas dados do banco de dados autenticado
- Não armazena histórico de conversas entre sessões
- Respeita todas as permissões do Supabase

## 🆕 Melhorias Futuras

Possíveis expansões:

- [ ] Consultas mais complexas (ex: "Clientes com atraso")
- [ ] Exportar informações em PDF
- [ ] Gráficos e estatísticas visuais
- [ ] Comparação entre clientes
- [ ] Previsões e recomendações
- [ ] Integração com WhatsApp para notificações

## 📞 Suporte

Em caso de dúvidas ou problemas:
1. Verifique se o cliente está cadastrado no sistema
2. Tente variações do nome
3. Verifique a conexão com internet
4. Recarregue a página se necessário

---

**Desenvolvido para**: Nexus Gestão Financeira  
**Data de Implementação**: Novembro 2025  
**Versão**: 1.0.0
