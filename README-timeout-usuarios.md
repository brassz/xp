# Sistema de Timeout Automático para Todos os Usuários

## Descrição

Implementação de um sistema de logout automático para **todos os usuários** (admin, user, manager) após 5 minutos de inatividade no sistema.

## Funcionalidades

### 1. Monitoramento de Atividade
- Monitora eventos de atividade do usuário: cliques, movimentos do mouse, teclas, scroll e touch
- Reseta o timer automaticamente quando detecta atividade
- Aplica throttling para evitar muitas chamadas (máximo 1 reset por segundo)

### 2. Timeout Automático
- **Duração**: 5 minutos de inatividade
- **Aplicação**: Todos os usuários logados (admin, user, manager)
- **Aviso**: 10 segundos de aviso antes do logout
- **Ação**: Logout automático com redirecionamento para tela de login

### 3. Gerenciamento de Sessão
- Limpa automaticamente os timeouts ao fazer logout manual
- Remove listeners de eventos ao sair da sessão
- Reinicia o sistema ao fazer login novamente

## Como Testar

### 1. Usuários Disponíveis para Teste
```
Admin: admin@nexus.com / 1020
Usuário: douglas@nexus.com / 1020
```

### 2. Verificar Logs no Console
Após o login com **qualquer usuário**, abra o Console do navegador (F12) e observe as mensagens:
- "Timeout de usuário iniciado - 5 minutos para logout automático"
- "Timeout de usuário resetado devido à atividade" (quando houver atividade)

### 3. Teste de Inatividade
1. Faça login com qualquer usuário (admin ou normal)
2. Deixe o sistema sem interação por 5 minutos
3. Observe o aviso de logout iminente
4. Aguarde 10 segundos para o logout automático

### 4. Teste com Timeout Reduzido (Para Desenvolvimento)
No console do navegador, execute:
```javascript
setTestTimeout(0.1); // 0.1 minuto = 6 segundos
```

### 5. Teste com Diferentes Tipos de Usuário
1. Faça login como admin (admin@nexus.com)
2. Verifique que o timeout é ativado
3. Faça logout e login como usuário normal (douglas@nexus.com)
4. Verifique que o timeout também é ativado para usuários normais

### 6. Página de Teste
Abra o arquivo `test-timeout.html` para uma interface de teste dedicada.

## Implementação Técnica

### Variáveis Globais
- `userTimeoutId`: ID do timeout ativo
- `lastActivityTime`: Timestamp da última atividade
- `USER_TIMEOUT_DURATION`: Duração do timeout (5 minutos)
- `activityListenersAdded`: Controle de listeners
- `activityHandler`: Função handler dos eventos

### Funções Principais
- `startUserTimeout()`: Inicia o timeout para qualquer usuário logado
- `clearUserTimeout()`: Limpa o timeout ativo
- `resetUserTimeout()`: Reseta o timeout devido à atividade
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

- **TODOS os usuários logados** são afetados pelo timeout (admin, user, manager)
- Timeout aplicado universalmente para maior segurança
- Sistema limpa automaticamente recursos ao fazer logout
- Não interfere com a funcionalidade normal do sistema
- Protege contra sessões abandonadas independente do tipo de usuário

## Logs e Debug

O sistema inclui logs no console para facilitar o debug:
- "Timeout de usuário iniciado - 5 minutos para logout automático"
- "Timeout de usuário resetado devido à atividade"
- Avisos de logout iminente via notificações

Para remover os logs em produção, remova as linhas `console.log()` das funções.

## Mudanças Implementadas

### ✅ Modificações Realizadas
1. **Escopo Expandido**: Sistema agora aplica timeout a todos os usuários
2. **Variáveis Renomeadas**: `admin*` → `user*` para refletir o novo escopo
3. **Verificações Removidas**: Removidas verificações de `role === 'admin'`
4. **Documentação Atualizada**: README e arquivos de teste atualizados
5. **Página de Teste**: Criada `test-timeout.html` para facilitar testes

### 🔄 Antes vs Depois
| Aspecto | Antes | Depois |
|---------|-------|--------|
| **Usuários Afetados** | Apenas admin | Todos (admin, user, manager) |
| **Verificação de Role** | `currentUser.role === 'admin'` | `currentUser` (qualquer usuário) |
| **Variáveis** | `adminTimeoutId`, `startAdminTimeout()` | `userTimeoutId`, `startUserTimeout()` |
| **Segurança** | Parcial | Completa |