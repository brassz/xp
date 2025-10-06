# Sistema de Timeout Automático para Administradores

## Descrição

Implementação de um sistema de logout automático para usuários com role "admin" após 5 minutos de inatividade no sistema.

## Funcionalidades

### 1. Monitoramento de Atividade
- Monitora eventos de atividade do usuário: cliques, movimentos do mouse, teclas, scroll e touch
- Reseta o timer automaticamente quando detecta atividade
- Aplica throttling para evitar muitas chamadas (máximo 1 reset por segundo)

### 2. Timeout Automático
- **Duração**: 5 minutos de inatividade
- **Aplicação**: Apenas para usuários com role "admin"
- **Aviso**: 10 segundos de aviso antes do logout
- **Ação**: Logout automático com redirecionamento para tela de login

### 3. Gerenciamento de Sessão
- Limpa automaticamente os timeouts ao fazer logout manual
- Remove listeners de eventos ao sair da sessão
- Reinicia o sistema ao fazer login novamente

## Como Testar

### 1. Login como Admin
```
Email: admin@nexus.com
Senha: 1020
```

### 2. Verificar Logs no Console
Após o login, abra o Console do navegador (F12) e observe as mensagens:
- "Admin timeout iniciado - 5 minutos para logout automático"
- "Admin timeout resetado devido à atividade do usuário" (quando houver atividade)

### 3. Teste de Inatividade
1. Faça login como admin
2. Deixe o sistema sem interação por 5 minutos
3. Observe o aviso de logout iminente
4. Aguarde 10 segundos para o logout automático

### 4. Teste com Timeout Reduzido (Para Desenvolvimento)
No console do navegador, execute:
```javascript
setTestTimeout(0.1); // 0.1 minuto = 6 segundos
```

### 5. Teste com Usuário Não-Admin
1. Faça login com um usuário que não seja admin (ex: douglas@nexus.com)
2. Verifique que o sistema de timeout NÃO é ativado
3. Não deve aparecer mensagens de timeout no console

## Implementação Técnica

### Variáveis Globais
- `adminTimeoutId`: ID do timeout ativo
- `lastActivityTime`: Timestamp da última atividade
- `ADMIN_TIMEOUT_DURATION`: Duração do timeout (5 minutos)
- `activityListenersAdded`: Controle de listeners
- `activityHandler`: Função handler dos eventos

### Funções Principais
- `startAdminTimeout()`: Inicia o timeout para admin
- `clearAdminTimeout()`: Limpa o timeout ativo
- `resetAdminTimeout()`: Reseta o timeout devido à atividade
- `setupActivityListeners()`: Configura os listeners de eventos
- `removeActivityListeners()`: Remove os listeners
- `setTestTimeout(minutes)`: Função para testes com timeout personalizado

### Eventos Monitorados
- `mousedown`: Clique do mouse
- `mousemove`: Movimento do mouse
- `keypress`: Tecla pressionada
- `scroll`: Rolagem da página
- `touchstart`: Toque na tela (dispositivos móveis)
- `click`: Clique em elementos

## Segurança

- Apenas usuários com role "admin" são afetados pelo timeout
- Outros roles (user, manager) não têm timeout automático
- Sistema limpa automaticamente recursos ao fazer logout
- Não interfere com a funcionalidade normal do sistema

## Logs e Debug

O sistema inclui logs no console para facilitar o debug:
- Início do timeout
- Reset por atividade
- Avisos de logout iminente

Para remover os logs em produção, remova as linhas `console.log()` das funções.