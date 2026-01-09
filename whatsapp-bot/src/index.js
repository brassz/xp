import fs from 'node:fs';
import dotenv from 'dotenv';
import path from 'node:path';
import express from 'express';
import cors from 'cors';
import { BotManager } from './botManager.js';
import { BillingScheduler } from './billingScheduler.js';
import { resolveCompanyId } from './companyConfig.js';

// Carregar env do próprio bot e/ou da raiz do repo
for (const p of [
  path.join(process.cwd(), '.env'),
  path.join(process.cwd(), '..', '.env'),
  path.join(process.cwd(), '..', '.env.local'),
]) {
  if (fs.existsSync(p)) dotenv.config({ path: p, override: false });
}

const app = express();
app.use(cors());
app.use(express.json({ limit: '1mb' }));

const bot = new BotManager({
  authDir: path.join(process.cwd(), '.auth'),
});

const scheduler = new BillingScheduler({ botManager: bot });
scheduler.start();

app.get('/health', (_req, res) => res.json({ ok: true }));

app.get('/api/whatsapp/status', (_req, res) => {
  res.json({
    whatsapp: bot.getStatus(),
    billing: scheduler.getState(),
  });
});

app.get('/api/whatsapp/qr', async (_req, res) => {
  const dataUrl = await bot.getQrDataUrl();
  res.json({
    qrUpdatedAt: bot.qrUpdatedAt,
    qrDataUrl: dataUrl,
  });
});

app.post('/api/whatsapp/connect', async (_req, res) => {
  const status = await bot.connect();
  res.json({ whatsapp: status });
});

app.post('/api/whatsapp/logout', async (_req, res) => {
  await bot.logout();
  res.json({ ok: true });
});

app.post('/api/whatsapp/online', async (req, res) => {
  const online = Boolean(req.body?.online);
  const companyId = resolveCompanyId(req.body?.companyId);
  scheduler.setOnline({ online, companyId });
  res.json({ billing: scheduler.getState() });
});

app.post('/api/whatsapp/template', async (req, res) => {
  const template = req.body?.template;
  scheduler.setTemplate(template);
  res.json({ billing: scheduler.getState() });
});

app.post('/api/whatsapp/send', async (req, res) => {
  const to = String(req.body?.to || '');
  const message = String(req.body?.message || '');
  const result = await bot.sendText(to, message);
  res.json({ ok: true, result });
});

const port = Number(process.env.PORT || 3333);
app.listen(port, () => {
  // eslint-disable-next-line no-console
  console.log(`[whatsapp-bot] listening on http://localhost:${port}`);
});

