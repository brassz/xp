# Aba de Atendimento WhatsApp

## 📱 Sobre

A aba de Atendimento integra o WhatsApp Web ao sistema Nexus, permitindo que o admin conecte seu WhatsApp e responda clientes diretamente pelo sistema.

## ⚙️ Configuração Inicial

### 1. Instalar Dependências

Primeiro, instale as dependências necessárias:

```bash
npm install
```

Isso instalará:
- `whatsapp-web.js` - Biblioteca para integração com WhatsApp Web
- `qrcode` - Gerador de QR codes
- `express` - Servidor web
- `cors` - Middleware para permitir requisições cross-origin
- `socket.io` - Comunicação em tempo real

### 2. Iniciar o Servidor WhatsApp

**Opção A - Início Automático em Background (RECOMENDADO):**

```bash
npm run start-whatsapp-bg
```

O servidor iniciará em background e continuará rodando. Você pode fechar o terminal!

**Opção B - Início Normal (Terminal fica aberto):**

```bash
npm run start-whatsapp
```

**Opção C - Iniciar tudo junto:**

```bash
npm start
```

📝 **Comandos úteis:**
- `npm run status-whatsapp` - Ver status
- `npm run logs-whatsapp` - Ver logs em tempo real
- `npm run stop-whatsapp` - Parar servidor
- `npm run restart-whatsapp` - Reiniciar

O servidor rodará na porta 3001.

### 3. Acessar o Sistema

Abra o sistema Nexus no navegador e navegue até a aba **Atendimento** no menu lateral.

## 🚀 Como Usar

### Conectar WhatsApp

1. Clique no botão **"Conectar WhatsApp"**
2. Um QR Code será exibido na tela
3. Abra o WhatsApp no seu celular
4. Vá em **Configurações > Aparelhos conectados > Conectar um aparelho**
5. Escaneie o QR Code exibido no sistema
6. Aguarde a conexão ser estabelecida

### Responder Mensagens

1. Após conectado, todas as suas conversas do WhatsApp aparecerão na lista à esquerda
2. Clique em uma conversa para visualizar as mensagens
3. Digite sua resposta no campo de texto na parte inferior
4. Pressione Enter ou clique em **"Enviar"**

### Recursos

- ✅ **Visualização de todas as conversas** - Veja todas as suas conversas ativas
- ✅ **Mensagens em tempo real** - Receba notificações de novas mensagens instantaneamente
- ✅ **Busca de conversas** - Pesquise conversas pelo nome do contato
- ✅ **Indicador de mensagens não lidas** - Badge verde mostra quantas mensagens não lidas você tem
- ✅ **Interface moderna** - Design responsivo e elegante integrado ao sistema Nexus

## 🔧 Arquitetura

### Componentes

1. **whatsapp-server.js** - Servidor Node.js que gerencia a conexão com WhatsApp
   - Gerencia autenticação via QR Code
   - Mantém sessão persistente (LocalAuth)
   - Expõe API REST para comunicação
   - Emite eventos via Socket.IO para atualizações em tempo real

2. **index.html** - Interface da aba de Atendimento
   - Layout de 3 colunas
   - Status de conexão
   - Lista de conversas
   - Área de chat

3. **app.js** - Lógica de integração no frontend
   - Conecta ao servidor via Socket.IO
   - Gerencia estado da conexão
   - Manipula envio/recebimento de mensagens
   - Atualiza interface em tempo real

### Fluxo de Dados

```
WhatsApp Web → whatsapp-web.js → Express Server → Socket.IO → Frontend
                                      ↓
                                  API REST ← Frontend
```

## 🛡️ Segurança

- A sessão do WhatsApp é armazenada localmente usando LocalAuth
- Não há armazenamento de mensagens no banco de dados
- A comunicação entre frontend e backend usa HTTP local
- Para produção, recomenda-se usar HTTPS e autenticação adicional

## 🐛 Solução de Problemas

### ❌ QR Code não aparece ao clicar em "Conectar WhatsApp"

**Possíveis causas:**

1. **Servidor não está rodando**
   ```bash
   # Em um terminal separado, execute:
   npm run start-whatsapp
   ```

2. **Testar se o servidor está respondendo**
   ```bash
   npm run test-whatsapp
   ```

3. **Verificar logs do servidor**
   - Olhe o terminal onde está rodando o servidor
   - Deve aparecer "QR Code recebido" quando o QR for gerado
   - Se não aparecer, reinicie o servidor

4. **Limpar sessão anterior**
   ```bash
   # Parar o servidor e deletar a pasta de autenticação
   rm -rf .wwebjs_auth .wwebjs_cache
   # Depois reiniciar o servidor
   npm run start-whatsapp
   ```

5. **Verificar console do navegador**
   - Abra o DevTools (F12)
   - Vá em Console
   - Procure por erros em vermelho
   - Se houver erro de CORS ou conexão, o servidor não está rodando

### Servidor não inicia
- Verifique se a porta 3001 está livre: `lsof -i :3001` (Mac/Linux) ou `netstat -ano | findstr :3001` (Windows)
- Certifique-se de que todas as dependências foram instaladas: `npm install`
- Tente instalar novamente o puppeteer: `npm install puppeteer --force`

### Mensagens não chegam em tempo real
- Verifique a conexão Socket.IO no console do navegador
- Reinicie o servidor WhatsApp
- Limpe a sessão e reconecte o WhatsApp

### Desconexões frequentes
- Certifique-se de que o celular está conectado à internet
- Não feche o WhatsApp no celular
- Considere aumentar o timeout no servidor

### Erro "429 Too Many Requests"
- O WhatsApp detectou muitas requisições
- Aguarde alguns minutos antes de tentar novamente
- Use a API com moderação

## 📝 Notas Importantes

1. **Sessão Persistente**: A sessão do WhatsApp é salva localmente. Você não precisará escanear o QR Code toda vez que reiniciar o servidor.

2. **Limitações do WhatsApp**: O WhatsApp pode limitar ou banir contas que fazem uso excessivo de automação. Use com responsabilidade.

3. **Um Dispositivo por Vez**: Apenas uma instância do servidor pode estar conectada por vez.

4. **Ambiente de Produção**: Para produção, considere:
   - Usar PM2 ou similar para manter o servidor rodando
   - Implementar autenticação no servidor
   - Usar HTTPS
   - Adicionar logs e monitoramento

## 🔄 Atualizações Futuras (Possíveis)

- [ ] Envio de mídia (imagens, documentos)
- [ ] Mensagens automáticas / templates
- [ ] Integração com base de clientes
- [ ] Estatísticas de atendimento
- [ ] Múltiplos operadores
- [ ] Histórico de conversas salvo no banco

## 📞 Suporte

Para problemas ou dúvidas, consulte a documentação do whatsapp-web.js:
https://github.com/pedroslopez/whatsapp-web.js
