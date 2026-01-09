# WhatsApp Bot (Node.js + Baileys)

Este serviço expõe uma API HTTP para conectar no **WhatsApp Web (QR Code)** e executar **cobranças automáticas** (parcelas pendentes/vencidas) usando os dados do Supabase.

## Rodar localmente

1. Configure as variáveis no `.env` (na raiz do projeto ou exporte no shell):
   - `NEXT_PUBLIC_SUPABASE_URL_EMPRESA*`
   - `SUPABASE_SERVICE_ROLE_KEY_EMPRESA*` (recomendado)

   O bot tenta carregar automaticamente: `whatsapp-bot/.env`, `/.env` e `/.env.local`.

2. Instale e rode:

```bash
cd whatsapp-bot
npm install
npm run dev
```

O bot sobe em `http://localhost:3333`.

## Endpoints usados pela aba Atendimento

- `GET /api/whatsapp/status`
- `POST /api/whatsapp/connect`
- `GET /api/whatsapp/qr`
- `POST /api/whatsapp/logout`
- `POST /api/whatsapp/online` `{ online, companyId }`
- `POST /api/whatsapp/template` `{ template }`
- `POST /api/whatsapp/send` `{ to, message }`

## Como funciona a cobrança automática

- Quando **Online** está ligado e o WhatsApp está conectado, o bot busca em `installment_payments`:
  - `due_date <= hoje`
  - `status in ('pending', 'overdue', 'partial')`
- Faz dedupe diário por `installment_payments.id` em `whatsapp-bot/data/sent-log.json` (ignorado no git).

