# 🔧 Instruções para Corrigir Erro original_amount

## ❌ Problema
```
Erro ao criar empréstimo: null value in column "original_amount" of relation "loans" violates not-null constraint
```

## 🎯 Solução Rápida

### Opção 1: Executar SQL no Supabase (RECOMENDADO)

1. **Acesse o Supabase Dashboard**
   - Vá para [supabase.com](https://supabase.com)
   - Entre no seu projeto
   - Clique em "SQL Editor" no menu lateral

2. **Execute o Script de Correção**
   - Copie todo o conteúdo do arquivo `supabase-fix-original-amount.sql`
   - Cole no SQL Editor do Supabase
   - Clique em "Run" para executar

3. **Verifique se funcionou**
   - Tente criar um novo empréstimo
   - O erro deve ter desaparecido

### Opção 2: O JavaScript já está preparado (AUTOMÁTICO)

O código JavaScript foi atualizado para lidar com ambos os cenários:
- ✅ Se a coluna `original_amount` existir, ela será preenchida
- ✅ Se não existir, tentará criar sem ela e depois atualizar
- ✅ Exibe mensagens de erro mais claras

## 📋 Scripts Disponíveis

| Arquivo | Descrição | Uso |
|---------|-----------|-----|
| `supabase-fix-original-amount.sql` | Script otimizado para Supabase | Execute no SQL Editor |
| `fix-loan-creation-null-amount-error.sql` | Script completo com verificações | Para PostgreSQL local |
| `app.js` | Código JavaScript atualizado | Já aplicado automaticamente |

## 🔍 Como Verificar se Está Funcionando

### 1. Teste no Sistema
- Acesse a aba "Empréstimos"
- Clique em "Novo Empréstimo"
- Preencha os dados e tente salvar
- ✅ Deve funcionar sem erro

### 2. Verificar no Banco (Opcional)
```sql
-- Ver estrutura da tabela loans
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'loans' 
ORDER BY ordinal_position;

-- Ver empréstimos recentes
SELECT id, amount, original_amount, created_at 
FROM loans 
ORDER BY created_at DESC 
LIMIT 5;
```

## 🚨 Se Ainda Não Funcionar

### Cenário A: Erro persiste após executar SQL
```bash
# Verifique se o script foi executado corretamente
# No SQL Editor do Supabase, execute:
SELECT column_name FROM information_schema.columns 
WHERE table_name = 'loans' AND column_name = 'original_amount';

# Se retornar vazio, a coluna não foi criada
# Execute novamente o script supabase-fix-original-amount.sql
```

### Cenário B: Erro diferente aparece
- Copie a mensagem de erro completa
- Verifique se há problemas de permissão no Supabase
- Confirme se está usando o projeto correto no Supabase

### Cenário C: Código JavaScript não funciona
```javascript
// Abra o Console do navegador (F12) e verifique se há erros
// Procure por mensagens relacionadas a 'original_amount'
```

## 📞 Suporte

Se o problema persistir:
1. Anote a mensagem de erro exata
2. Verifique qual empresa/projeto Supabase está sendo usado
3. Confirme se tem permissões de administrador no banco

## ✅ Checklist de Verificação

- [ ] Script SQL executado no Supabase
- [ ] Coluna `original_amount` existe na tabela `loans`
- [ ] Teste de criação de empréstimo realizado
- [ ] Erro não aparece mais
- [ ] Empréstimos são criados normalmente

---

**🎉 Após seguir estas instruções, o sistema deve funcionar perfeitamente!**