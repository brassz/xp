# ⚠️ NOTA IMPORTANTE: Use o Script v2

## 🔄 O que mudou?

Se você recebeu o erro:
```
ERROR: 42703: column "photo" of relation "guarantors" does not exist
```

Isso significa que a tabela `guarantors` **já existe** no seu banco de dados, mas não tem todas as colunas necessárias.

## ✅ Solução: Use o Script v2

### ❌ NÃO USE: `fix-franca-private-database-complete.sql`
Este script tenta criar a tabela do zero e falha se ela já existe.

### ✅ USE: `fix-franca-private-database-complete-v2.sql`
Este script:
- ✅ Verifica se a tabela existe
- ✅ Adiciona apenas as colunas que faltam
- ✅ Não sobrescreve dados existentes
- ✅ É seguro para bancos com tabelas parcialmente criadas

## 🚀 Como Aplicar

1. **Abra o Supabase SQL Editor**
2. **Copie TODO o conteúdo de:** `fix-franca-private-database-complete-v2.sql`
3. **Cole no SQL Editor**
4. **Clique em RUN**

## 📋 Diferenças entre v1 e v2

| Aspecto | v1 | v2 |
|---------|----|----|
| **Tabela guarantors** | CREATE TABLE | CREATE TABLE + ALTER TABLE |
| **Colunas faltantes** | Erro | Adiciona automaticamente |
| **Dados existentes** | Pode perder | Preserva 100% |
| **Tabelas parciais** | Não suporta | Suporta |
| **Segurança** | Média | Alta |

## 🔍 O que o v2 faz de diferente?

### Para a tabela `guarantors`:

```sql
-- v2 primeiro cria a estrutura básica
CREATE TABLE IF NOT EXISTS guarantors (
    id UUID PRIMARY KEY,
    client_id UUID NOT NULL,
    name TEXT NOT NULL,
    cpf TEXT NOT NULL
);

-- Depois adiciona cada coluna individualmente se não existir
IF NOT EXISTS (coluna 'photo') THEN
    ALTER TABLE guarantors ADD COLUMN photo TEXT;
END IF;
```

Isso permite que o script funcione em qualquer situação:
- ✅ Banco vazio (cria tudo)
- ✅ Tabela parcial (adiciona o que falta)
- ✅ Tabela completa (não faz nada, sem erros)

## ✨ Resultado Esperado

Ao executar o script v2, você deve ver:

```
✓ Constraint de payment_type removida com sucesso
✓ Tabela guarantors criada/atualizada com sucesso
✓ Tabela cash_transactions criada com sucesso
✓ Tabela cash_settings criada com sucesso
✓ Tabela capital_raising criada com sucesso
✓ Tabela capital_raising_clients criada com sucesso
✓ Tabela paid_loans criada com sucesso

INSTALAÇÃO CONCLUÍDA COM SUCESSO!
```

Note: "criada/**atualizada**" em vez de apenas "criada"

## 📝 Resumo

- ❌ Erro com v1? É porque tabelas já existem
- ✅ Use sempre o **v2** para segurança máxima
- ✅ v2 é **idempotente** (pode executar múltiplas vezes)
- ✅ v2 **preserva dados** existentes
- ✅ v2 **adiciona apenas o necessário**

---

**Data:** 10 de Dezembro de 2024  
**Versão Recomendada:** v2  
**Status:** ✅ Pronto para produção
