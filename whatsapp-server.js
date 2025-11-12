const express = require('express');
const cors = require('cors');
const { Client, LocalAuth } = require('whatsapp-web.js');
const QRCode = require('qrcode');
const { Server } = require('socket.io');
const http = require('http');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});

app.use(cors());
app.use(express.json());

let whatsappClient = null;
let isReady = false;
let qrCodeData = null;
let qrCodeImage = null;

// Inicializa o cliente WhatsApp
const initializeWhatsApp = () => {
    whatsappClient = new Client({
        authStrategy: new LocalAuth({
            clientId: 'nexus-whatsapp'
        }),
        puppeteer: {
            headless: true,
            args: [
                '--no-sandbox',
                '--disable-setuid-sandbox',
                '--disable-dev-shm-usage',
                '--disable-accelerated-2d-canvas',
                '--no-first-run',
                '--no-zygote',
                '--single-process',
                '--disable-gpu'
            ]
        }
    });

    // QR Code gerado
    whatsappClient.on('qr', async (qr) => {
        console.log('\n📱 QR Code gerado!');
        console.log('   ✅ QR Code está disponível para escaneamento');
        console.log('   ℹ️  Abra a aba Atendimento e clique em "Conectar WhatsApp"\n');
        qrCodeData = qr;
        try {
            qrCodeImage = await QRCode.toDataURL(qr);
            console.log('   ✅ QR Code convertido para imagem Base64');
            io.emit('qr', { qr: qrCodeImage });
        } catch (err) {
            console.error('❌ Erro ao gerar QR Code:', err);
        }
    });

    // Cliente pronto
    whatsappClient.on('ready', () => {
        console.log('\n🎉 WhatsApp conectado com sucesso!');
        console.log('   ✅ Pronto para enviar e receber mensagens\n');
        isReady = true;
        qrCodeData = null;
        qrCodeImage = null;
        io.emit('ready', { status: 'connected' });
    });

    // Cliente autenticado
    whatsappClient.on('authenticated', () => {
        console.log('\n✅ WhatsApp autenticado!');
        console.log('   ⏳ Carregando conversas...\n');
        io.emit('authenticated', { status: 'authenticated' });
    });

    // Falha na autenticação
    whatsappClient.on('auth_failure', (msg) => {
        console.error('\n❌ Falha na autenticação:', msg);
        console.error('   💡 Tente deletar a pasta .wwebjs_auth e reconectar\n');
        isReady = false;
        io.emit('auth_failure', { error: msg });
    });

    // Desconectado
    whatsappClient.on('disconnected', (reason) => {
        console.log('\n⚠️  WhatsApp desconectado:', reason);
        console.log('   💡 Reinicie o servidor para reconectar\n');
        isReady = false;
        io.emit('disconnected', { reason });
    });

    // Mensagem recebida
    whatsappClient.on('message', async (message) => {
        console.log(`📨 Nova mensagem de ${message.from}`);
        
        const contact = await message.getContact();
        const chat = await message.getChat();
        
        io.emit('message', {
            id: message.id._serialized,
            from: message.from,
            fromName: contact.pushname || contact.name || message.from,
            body: message.body,
            timestamp: message.timestamp,
            isGroup: chat.isGroup,
            hasMedia: message.hasMedia
        });
    });

    whatsappClient.initialize();
};

// Rotas da API
app.get('/status', (req, res) => {
    res.json({
        ready: isReady,
        hasQR: qrCodeData !== null,
        qrCode: qrCodeImage
    });
});

app.get('/chats', async (req, res) => {
    if (!isReady) {
        return res.status(400).json({ error: 'WhatsApp não está conectado' });
    }

    try {
        const chats = await whatsappClient.getChats();
        const chatList = await Promise.all(chats.map(async (chat) => {
            const contact = await chat.getContact();
            const lastMessage = chat.lastMessage;
            
            return {
                id: chat.id._serialized,
                name: chat.name || contact.pushname || contact.name || chat.id.user,
                isGroup: chat.isGroup,
                unreadCount: chat.unreadCount,
                timestamp: chat.timestamp,
                lastMessage: lastMessage ? {
                    body: lastMessage.body,
                    timestamp: lastMessage.timestamp
                } : null
            };
        }));

        // Ordena por timestamp (mais recente primeiro)
        chatList.sort((a, b) => b.timestamp - a.timestamp);
        
        res.json({ chats: chatList });
    } catch (error) {
        console.error('Erro ao buscar chats:', error);
        res.status(500).json({ error: 'Erro ao buscar chats' });
    }
});

app.get('/messages/:chatId', async (req, res) => {
    if (!isReady) {
        return res.status(400).json({ error: 'WhatsApp não está conectado' });
    }

    try {
        const { chatId } = req.params;
        const limit = parseInt(req.query.limit) || 50;
        
        const chat = await whatsappClient.getChatById(chatId);
        const messages = await chat.fetchMessages({ limit });
        
        const messageList = messages.map(msg => ({
            id: msg.id._serialized,
            body: msg.body,
            timestamp: msg.timestamp,
            fromMe: msg.fromMe,
            hasMedia: msg.hasMedia,
            type: msg.type
        }));
        
        res.json({ messages: messageList });
    } catch (error) {
        console.error('Erro ao buscar mensagens:', error);
        res.status(500).json({ error: 'Erro ao buscar mensagens' });
    }
});

app.post('/send-message', async (req, res) => {
    if (!isReady) {
        return res.status(400).json({ error: 'WhatsApp não está conectado' });
    }

    try {
        const { chatId, message } = req.body;
        
        if (!chatId || !message) {
            return res.status(400).json({ error: 'chatId e message são obrigatórios' });
        }

        const chat = await whatsappClient.getChatById(chatId);
        await chat.sendMessage(message);
        
        res.json({ success: true });
    } catch (error) {
        console.error('Erro ao enviar mensagem:', error);
        res.status(500).json({ error: 'Erro ao enviar mensagem' });
    }
});

app.post('/logout', async (req, res) => {
    if (!isReady) {
        return res.status(400).json({ error: 'WhatsApp não está conectado' });
    }

    try {
        await whatsappClient.logout();
        isReady = false;
        res.json({ success: true });
    } catch (error) {
        console.error('Erro ao fazer logout:', error);
        res.status(500).json({ error: 'Erro ao fazer logout' });
    }
});

// Socket.IO para eventos em tempo real
io.on('connection', (socket) => {
    console.log('🔌 Frontend conectado via Socket.IO');
    
    // Envia o status atual quando o cliente conecta
    socket.emit('status', { ready: isReady, hasQR: qrCodeData !== null });
    
    // Se já tiver QR Code, enviar novamente
    if (qrCodeImage) {
        console.log('   📤 Enviando QR Code existente para o frontend');
        socket.emit('qr', { qr: qrCodeImage });
    }
    
    socket.on('disconnect', () => {
        console.log('🔌 Frontend desconectado do Socket.IO');
    });
});

const PORT = process.env.PORT || 3001;

server.listen(PORT, () => {
    console.log('\n========================================');
    console.log('🚀 Servidor WhatsApp iniciado!');
    console.log(`📡 Rodando na porta ${PORT}`);
    console.log('========================================\n');
    console.log('📋 Próximos passos:');
    console.log('   1. Abra o sistema Nexus no navegador');
    console.log('   2. Vá na aba "Atendimento"');
    console.log('   3. Clique em "Conectar WhatsApp"');
    console.log('   4. Escaneie o QR Code que aparecer\n');
    console.log('⏳ Inicializando WhatsApp Web...\n');
    
    initializeWhatsApp();
});
