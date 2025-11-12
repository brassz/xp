# ⚡ Quick Start - WhatsApp Atendimento

## 🚀 Início Rápido (3 passos)

### 1️⃣ Instalar (apenas primeira vez)

```bash
npm install
```

### 2️⃣ Iniciar Servidor

```bash
npm run start-whatsapp-bg
```

✅ Pronto! O servidor está rodando em background.

### 3️⃣ Usar no Sistema

1. Abra o sistema Nexus no navegador
2. Vá na aba **Atendimento**
3. Clique em **"Conectar WhatsApp"**
4. Escaneie o QR Code com seu celular
5. ✅ Comece a atender clientes!

---

## 📱 Passo a Passo Detalhado

### Escaneando o QR Code

1. **No celular:**
   - Abra o WhatsApp
   - Toque em ⋮ (3 pontos) ou Configurações
   - Toque em **"Aparelhos conectados"**
   - Toque em **"Conectar um aparelho"**

2. **No sistema:**
   - O QR Code aparecerá automaticamente
   - Aponte a câmera do celular para a tela

3. **Aguarde:**
   - Status mudará para "Conectado"
   - Suas conversas aparecerão na lista

---

## 🔍 Verificar se está Funcionando

```bash
npm run status-whatsapp
```

**Deve mostrar:**
```
✅ Processo: Rodando
✅ Servidor: Respondendo
✅ Conectado: Sim
```

---

## ⚙️ Comandos Essenciais

```bash
# INICIAR
npm run start-whatsapp-bg    # Iniciar em background
npm start                    # Iniciar tudo junto

# PARAR
npm run stop-whatsapp        # Parar servidor

# REINICIAR
npm run restart-whatsapp     # Reiniciar servidor

# MONITORAR
npm run status-whatsapp      # Ver status
npm run logs-whatsapp        # Ver logs em tempo real
npm run test-whatsapp        # Testar conexão
```

---

## 🐛 Problemas?

### ❌ QR Code não aparece

```bash
# 1. Verificar se o servidor está rodando
npm run status-whatsapp

# 2. Se não estiver, iniciar
npm run start-whatsapp-bg

# 3. Recarregar a página (Ctrl+F5)
```

### ❌ Servidor não inicia

```bash
# 1. Parar qualquer processo antigo
npm run stop-whatsapp

# 2. Limpar sessão
rm -rf .wwebjs_auth .wwebjs_cache

# 3. Iniciar novamente
npm run start-whatsapp-bg
```

### ❌ Erro: Porta já em uso

```bash
# Parar o servidor
npm run stop-whatsapp

# Iniciar novamente
npm run start-whatsapp-bg
```

---

## 📚 Mais Informações

- **Inicio Automático:** `INICIO-AUTOMATICO.md`
- **Debug Completo:** `DEBUG-BOTAO-WHATSAPP.md`
- **Documentação Completa:** `README-ATENDIMENTO-WHATSAPP.md`

---

## 💡 Dicas

✅ **Use background:** Servidor continua rodando mesmo se fechar o terminal

✅ **Verifique status:** `npm run status-whatsapp` sempre que tiver dúvida

✅ **Veja os logs:** `npm run logs-whatsapp` para debug em tempo real

✅ **Primeira conexão:** Demora ~10-30 segundos para gerar o QR Code

✅ **Próximas conexões:** Mais rápidas, sessão é salva!

---

## 🎉 Pronto para Usar!

Agora você pode:
- ✅ Ver todas as conversas do WhatsApp
- ✅ Responder mensagens em tempo real
- ✅ Buscar conversas
- ✅ Atender múltiplos clientes

**Bom atendimento!** 🚀
