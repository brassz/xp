import fs from 'node:fs';
import path from 'node:path';
import qrcode from 'qrcode';
import pino from 'pino';
import {
  DisconnectReason,
  fetchLatestBaileysVersion,
  makeWASocket,
  useMultiFileAuthState,
} from '@whiskeysockets/baileys';

function normalizePhoneToJid(rawPhone) {
  if (!rawPhone) return null;
  let digits = String(rawPhone).replace(/\D/g, '');

  // Heurística BR: se vier sem DDI e tiver 10/11 dígitos, prefixa 55.
  if (digits.length === 10 || digits.length === 11) digits = `55${digits}`;

  // Remove 00 no começo se vier como 0055...
  if (digits.startsWith('00')) digits = digits.slice(2);

  if (digits.length < 10) return null;
  return `${digits}@s.whatsapp.net`;
}

export class BotManager {
  constructor({ authDir }) {
    this.authDir = authDir;
    this.sock = null;
    this.connected = false;
    this.me = null;
    this.lastError = null;
    this.qr = null;
    this.qrUpdatedAt = null;
    this.logger = pino({ level: process.env.LOG_LEVEL || 'info' });
  }

  getStatus() {
    return {
      connected: this.connected,
      me: this.me,
      qrUpdatedAt: this.qrUpdatedAt,
      lastError: this.lastError ? String(this.lastError?.message || this.lastError) : null,
    };
  }

  async getQrDataUrl() {
    if (!this.qr) return null;
    return qrcode.toDataURL(this.qr, { margin: 1, scale: 8 });
  }

  async connect() {
    if (this.sock) return this.getStatus();

    fs.mkdirSync(this.authDir, { recursive: true });
    const { state, saveCreds } = await useMultiFileAuthState(this.authDir);
    const { version } = await fetchLatestBaileysVersion();

    this.sock = makeWASocket({
      version,
      auth: state,
      logger: this.logger,
      printQRInTerminal: true,
      generateHighQualityLinkPreview: false,
    });

    this.sock.ev.on('creds.update', saveCreds);

    this.sock.ev.on('connection.update', (update) => {
      const { connection, lastDisconnect, qr } = update;

      if (qr) {
        this.qr = qr;
        this.qrUpdatedAt = new Date().toISOString();
      }

      if (connection === 'open') {
        this.connected = true;
        this.me = this.sock?.user || null;
        this.qr = null;
        this.qrUpdatedAt = null;
        this.lastError = null;
        this.logger.info({ me: this.me }, 'WhatsApp conectado');
      }

      if (connection === 'close') {
        this.connected = false;
        this.me = null;

        const statusCode = lastDisconnect?.error?.output?.statusCode;
        const shouldReconnect = statusCode !== DisconnectReason.loggedOut;

        this.lastError = lastDisconnect?.error || null;
        this.logger.warn({ statusCode, shouldReconnect }, 'WhatsApp desconectou');

        // Se foi "logout", não tenta reconectar.
        if (!shouldReconnect) {
          this.sock = null;
          return;
        }

        // Reconecta com pequeno backoff.
        const reconnectDelayMs = Number(process.env.RECONNECT_DELAY_MS || 1500);
        setTimeout(() => {
          this.sock = null;
          this.connect().catch((err) => {
            this.lastError = err;
            this.logger.error({ err }, 'Falha ao reconectar');
          });
        }, reconnectDelayMs);
      }
    });

    return this.getStatus();
  }

  async logout() {
    try {
      if (this.sock) await this.sock.logout();
    } finally {
      this.sock = null;
      this.connected = false;
      this.me = null;
      this.qr = null;
      this.qrUpdatedAt = null;
    }
  }

  async sendText(rawPhoneOrJid, text) {
    if (!this.sock || !this.connected) {
      throw new Error('WhatsApp não está conectado');
    }
    const jid = rawPhoneOrJid.includes('@s.whatsapp.net')
      ? rawPhoneOrJid
      : normalizePhoneToJid(rawPhoneOrJid);
    if (!jid) throw new Error('Telefone inválido para envio');

    await this.sock.sendMessage(jid, { text });
    return { jid };
  }
}

