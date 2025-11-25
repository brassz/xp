# ⚡ Quick Fix - Multas Não Aparecem

## 🎯 Problema
Multas cadastradas não aparecem no histórico de pagamentos.

## 🔧 Solução Rápida (2 minutos)

### PASSO 1: Execute este SQL no Supabase

```sql
-- Copie e cole TUDO no SQL Editor do Supabase
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'payments' AND column_name = 'fine_amount'
    ) THEN
        ALTER TABLE payments 
        ADD COLUMN fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);
        
        IF EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'payments' AND column_name = 'fine'
        ) THEN
            UPDATE payments SET fine_amount = COALESCE(fine, 0);
        END IF;
        
        RAISE NOTICE 'Coluna fine_amount criada!';
    ELSE
        RAISE NOTICE 'Coluna fine_amount já existe';
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_payments_fine_amount 
ON payments(fine_amount) WHERE fine_amount > 0;
```

**Como executar:**
1. Acesse: https://supabase.com/dashboard
2. Selecione seu projeto
3. Clique em "SQL Editor"
4. Cole o código acima
5. Clique em "Run"

### PASSO 2: Limpe o Cache do Navegador

**Atalho Rápido:**
- Windows: `Ctrl + Shift + Delete`
- Mac: `Cmd + Shift + Delete`

Selecione "Cache" e clique em "Limpar"

**OU**

Faça um Hard Refresh:
- Windows: `Ctrl + F5`
- Mac: `Cmd + Shift + R`

### PASSO 3: Teste

1. Abra o sistema
2. Vá em um empréstimo
3. Clique em 💰 (Histórico)
4. Adicione um pagamento com multa
5. ✅ A multa deve aparecer em vermelho na coluna "Multa"

## ✅ Pronto!

Se ainda não funcionar, veja: `SOLUCAO-MULTAS-NAO-APARECEM.md`
