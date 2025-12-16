# Instruções Rápidas - Controle Financeiro (Franca Private)

## ⚡ Instalação Rápida

### 1. Executar SQL no Supabase

```bash
1. Acesse: https://pebwoerzslfzhjptyjwh.supabase.co
2. Vá em: SQL Editor
3. Abra: setup-financial-control.sql
4. Execute o script completo
5. Verifique se não há erros
```

### 2. Acessar o Sistema

```bash
1. Acesse Franca Private (3 cliques em "Bruno Assoni")
2. Login: admin@francaprivate.com / 1020
3. No menu lateral, clique em "Controle Financeiro"
```

## 🎯 Uso Rápido

### Atualizar Dados
```
1. Clique em "Atualizar Dados"
2. Sistema busca comissões de todas as empresas
3. Se passaram 7 dias, adiciona automaticamente ao caixa
```

### Adicionar Despesa
```
1. Clique em "Adicionar Despesa"
2. Preencha descrição e valor
3. Salvar
```

### Adicionar Reinvestimento
```
1. Clique em "Adicionar Reinvestimento"
2. Preencha descrição e valor
3. Salvar
```

## 📊 O que o Sistema Faz

### Automático (A cada 7 dias)
- ✅ Busca comissões do Vinicius de **todas as 6 empresas**
- ✅ Soma total das comissões do último mês
- ✅ Adiciona automaticamente ao caixa
- ✅ Registra transação no histórico
- ✅ Define próxima data de adição

### Manual (Você controla)
- ➕ Adicionar despesas (subtrai do caixa)
- ➕ Adicionar reinvestimentos (subtrai do caixa)
- 🔄 Atualizar dados manualmente

## 💰 Porcentagens de Comissão

| Empresa | Vinicius |
|---------|----------|
| FRANCA CRED | 66,6% |
| LITORAL CRED | 66,6% |
| MOGIANA CRED | 66,6% |
| ERECHIM | 33,3% |
| IMPERATRIZ CRED | 50% |
| **FRANCA PRIVATE** | **100%** |

## 🔍 Verificação da Instalação

Execute no SQL Editor:

```sql
-- Verificar tabelas criadas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('financial_control', 'financial_transactions', 'commission_cache');

-- Deve retornar 3 tabelas
```

## ❓ Problemas Comuns

### Aba não aparece
**Causa**: Não está na empresa Franca Private  
**Solução**: 3 cliques em "Bruno Assoni" no login

### Erro ao buscar comissões
**Causa**: Tabelas não existem em alguma empresa  
**Solução**: Verificar se todas as empresas têm tabela `payments`

### Caixa não atualiza
**Causa**: Não passaram 7 dias ainda  
**Solução**: Normal! Aguardar ou testar mudando a data no banco

## 📁 Arquivos Importantes

```
/workspace/
├── setup-financial-control.sql          # ⭐ Execute este!
├── README-controle-financeiro.md        # 📖 Documentação completa
├── INSTRUCOES-CONTROLE-FINANCEIRO.md    # ⚡ Este arquivo
├── app.js                                # JavaScript (modificado)
└── index.html                            # Interface (modificada)
```

## 🎯 Resumo Visual

```
┌─────────────────────────────────────────────┐
│         CONTROLE FINANCEIRO                  │
│      (Exclusivo Franca Private)              │
└─────────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
    ┌───▼────┐          ┌──────▼───────┐
    │ CAIXA  │          │ COMISSÕES    │
    │ ATUAL  │          │ DO MÊS       │
    └───┬────┘          └──────┬───────┘
        │                      │
        │      ┌───────────────┘
        │      │
    ┌───▼──────▼───┐
    │ A CADA 7 DIAS│
    │ ADICIONA     │
    │ COMISSÕES    │
    └───┬──────────┘
        │
    ┌───▼───────────────────┐
    │  VOCÊ PODE:           │
    │  • Adicionar Despesas │
    │  • Reinvestimentos    │
    │  • Ver Histórico      │
    └───────────────────────┘
```

## ✅ Checklist de Instalação

- [ ] Script SQL executado no Supabase
- [ ] 3 tabelas criadas (financial_control, financial_transactions, commission_cache)
- [ ] Login no Franca Private funcionando
- [ ] Aba "Controle Financeiro" aparece no menu
- [ ] Botão "Atualizar Dados" funciona
- [ ] Cards de resumo carregam
- [ ] Tabela de transações aparece
- [ ] Modal de despesa abre
- [ ] Modal de reinvestimento abre

## 🚀 Pronto para Usar!

Após seguir estes passos, o sistema está 100% funcional e pronto para uso.

---

**Para mais detalhes, consulte**: `README-controle-financeiro.md`
