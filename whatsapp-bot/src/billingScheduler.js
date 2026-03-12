import path from 'node:path';
import { createClient } from '@supabase/supabase-js';
import { getSupabaseConfig } from './companyConfig.js';
import { SentStore } from './sentStore.js';

function formatBRL(value) {
  try {
    return Number(value).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
  } catch {
    return `R$ ${value}`;
  }
}

function formatDateBR(isoDate) {
  // isoDate esperado: YYYY-MM-DD
  if (!isoDate) return '';
  const [y, m, d] = String(isoDate).split('-');
  if (!y || !m || !d) return String(isoDate);
  return `${d}/${m}/${y}`;
}

function buildMessage(template, vars) {
  return template
    .replaceAll('{NOME}', vars.NOME ?? '')
    .replaceAll('{VALOR}', vars.VALOR ?? '')
    .replaceAll('{VENCIMENTO}', vars.VENCIMENTO ?? '')
    .replaceAll('{PARCELA}', vars.PARCELA ?? '')
    .replaceAll('{TOTAL_PARCELAS}', vars.TOTAL_PARCELAS ?? '');
}

export class BillingScheduler {
  constructor({ botManager }) {
    this.bot = botManager;
    this.online = false;
    this.companyId = 'nexus';
    this.interval = null;
    this.template =
      process.env.BILLING_TEMPLATE ||
      'Olá {NOME}, tudo bem?\n\nIdentificamos uma parcela em aberto no valor de {VALOR} com vencimento em {VENCIMENTO} (parcela {PARCELA}/{TOTAL_PARCELAS}).\n\nSe já pagou, por favor desconsidere. Caso precise de segunda via, me avise.';

    this.sentStore = new SentStore({
      filePath: path.join(process.cwd(), 'data', 'sent-log.json'),
    });
  }

  getState() {
    return {
      online: this.online,
      companyId: this.companyId,
      intervalMs: Number(process.env.BILLING_POLL_INTERVAL_MS || 60_000),
      template: this.template,
    };
  }

  setTemplate(template) {
    if (typeof template === 'string' && template.trim()) {
      this.template = template;
    }
  }

  setOnline({ online, companyId }) {
    this.online = Boolean(online);
    if (companyId) this.companyId = companyId;
  }

  start() {
    if (this.interval) return;
    const intervalMs = Number(process.env.BILLING_POLL_INTERVAL_MS || 60_000);
    this.interval = setInterval(() => {
      this.tick().catch(() => {});
    }, intervalMs);
  }

  stop() {
    if (!this.interval) return;
    clearInterval(this.interval);
    this.interval = null;
  }

  async tick() {
    if (!this.online) return;
    if (!this.bot.connected) return;

    const { url, key, keyType, companyId } = getSupabaseConfig(this.companyId);
    if (!url || !key) return;

    const supabase = createClient(url, key, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    const today = new Date().toISOString().slice(0, 10);

    // 1) Buscar parcelas pendentes/vencidas até hoje
    const { data: payments, error: paymentsError } = await supabase
      .from('installment_payments')
      .select('id, installment_id, installment_number, amount, due_date, status')
      .lte('due_date', today)
      .in('status', ['pending', 'overdue', 'partial'])
      .order('due_date', { ascending: true })
      .limit(Number(process.env.BILLING_BATCH_LIMIT || 50));

    if (paymentsError) return;
    if (!payments?.length) return;

    // 2) Buscar installments relacionados
    const installmentIds = Array.from(new Set(payments.map((p) => p.installment_id).filter(Boolean)));
    const { data: installments, error: installmentsError } = await supabase
      .from('installments')
      .select('id, client_id, total_installments')
      .in('id', installmentIds);
    if (installmentsError) return;

    const installmentsById = new Map((installments || []).map((i) => [i.id, i]));

    // 3) Buscar clients relacionados
    const clientIds = Array.from(
      new Set((installments || []).map((i) => i.client_id).filter(Boolean)),
    );
    const { data: clients, error: clientsError } = await supabase
      .from('clients')
      .select('id, name, phone')
      .in('id', clientIds);
    if (clientsError) return;

    const clientsById = new Map((clients || []).map((c) => [c.id, c]));

    // 4) Enviar mensagens (com dedupe diário)
    for (const p of payments) {
      const messageKey = `${companyId}:${keyType}:installment_payment:${p.id}`;
      if (this.sentStore.hasSentToday(messageKey)) continue;

      const inst = installmentsById.get(p.installment_id);
      if (!inst) continue;

      const client = clientsById.get(inst.client_id);
      if (!client?.phone) continue;

      const msg = buildMessage(this.template, {
        NOME: client.name || 'cliente',
        VALOR: formatBRL(p.amount),
        VENCIMENTO: formatDateBR(p.due_date),
        PARCELA: String(p.installment_number ?? ''),
        TOTAL_PARCELAS: String(inst.total_installments ?? ''),
      });

      await this.bot.sendText(client.phone, msg);
      this.sentStore.markSent(messageKey);
    }
  }
}

