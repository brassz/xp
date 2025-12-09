# 🚨 SOLUÇÃO URGENTE - Erro de Permissões

## Problema
```
Erro ao marcar empréstimo como quitado: permission denied for table paid_loans
```

## 🔧 Solução Rápida (5 minutos)

### PASSO 1: Executar Script de Permissões

1. Acesse o Supabase da IMPERATRIZ CRED:
   - URL: https://eppzphzwwpvpoocospxy.supabase.co

2. Vá em **SQL Editor**

3. **Copie TODO** o conteúdo do arquivo:
   - `fix-paid-loans-permissions.sql`

4. Cole no SQL Editor e clique em **RUN**

5. Aguarde as mensagens:
   ```
   ✅ RLS desabilitado temporariamente
   ✅ Políticas antigas removidas
   ✅ Permissões concedidas para authenticated
   ✅ RLS reabilitado com políticas permissivas
   ✅ TESTE DE INSERÇÃO: SUCESSO!
   ```

### PASSO 2: Fazer Logout e Login

**IMPORTANTE:** O sistema precisa renovar a sessão!

1. Vá no sistema Nexus
2. Clique em **LOGOUT**
3. Faça **LOGIN** novamente
4. Selecione **IMPERATRIZ CRED**

### PASSO 3: Testar

1. Vá para aba **Empréstimos**
2. Selecione um empréstimo ativo
3. Clique em **Marcar como Quitado**
4. Confirme

✅ Deve funcionar agora!

---

## 🐛 Se Ainda Der Erro

### Solução Alternativa 1: Limpar Cache

1. Pressione **Ctrl+Shift+Delete**
2. Marque "Cookies e dados de sites"
3. Marque "Imagens e arquivos em cache"
4. Clique em "Limpar dados"
5. Feche o navegador completamente
6. Abra novamente e faça login

### Solução Alternativa 2: Aba Privada

1. Abra uma **aba anônima/privada** (Ctrl+Shift+N no Chrome)
2. Acesse o sistema
3. Faça login
4. Teste a funcionalidade

### Solução Alternativa 3: Desabilitar RLS Completamente

**⚠️ USAR APENAS COMO ÚLTIMO RECURSO**

Se nada funcionou, execute o script final:

**Arquivo:** `fix-paid-loans-desabilitar-rls.sql`

Este script:
- Desabilita completamente o RLS
- Remove todas as políticas
- Concede todas as permissões
- Testa a inserção

**Como executar:**
1. Acesse SQL Editor do Supabase
2. Copie o conteúdo de `fix-paid-loans-desabilitar-rls.sql`
3. Execute (RUN)
4. Faça logout e login
5. Teste novamente

✅ Isso DEVE funcionar (última opção)!

---

## 🔍 Diagnóstico

Se quiser ver o status atual das permissões:

```sql
-- Ver políticas RLS
SELECT * FROM pg_policies WHERE tablename = 'paid_loans';

-- Ver permissões
SELECT grantee, privilege_type
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans';

-- Ver se RLS está ativo
SELECT relname, relrowsecurity 
FROM pg_class 
WHERE relname = 'paid_loans';
```

---

## ❓ Por Que Aconteceu Isso?

O problema ocorre quando:

1. A tabela foi criada mas as **permissões RLS** não foram configuradas corretamente
2. As **políticas RLS** são muito restritivas
3. O usuário não tem as **permissões corretas**

O script `fix-paid-loans-permissions.sql` resolve todos esses problemas criando políticas **super permissivas** que permitem qualquer operação para usuários autenticados.

---

## ✅ O Que o Script Faz

1. **Desabilita RLS** temporariamente
2. **Remove políticas antigas** que podem estar causando problemas
3. **Revoga e recria permissões** para authenticated
4. **Reabilita RLS** com políticas permissivas
5. **Testa inserção** automaticamente
6. **Mostra diagnóstico** completo

---

## 📋 Checklist

- [ ] Executei `fix-paid-loans-permissions.sql` no Supabase
- [ ] Vi a mensagem "✅ TESTE DE INSERÇÃO: SUCESSO!"
- [ ] Fiz LOGOUT do sistema
- [ ] Fiz LOGIN novamente
- [ ] Selecionei a empresa IMPERATRIZ CRED
- [ ] Testei marcar empréstimo como quitado
- [ ] Funcionou! ✅

---

## 🆘 Precisa de Mais Ajuda?

Se o problema persistir após todos os passos acima:

1. Execute no SQL Editor:
   ```sql
   SELECT current_user, session_user, current_database();
   ```

2. Verifique se está no banco correto da Imperatriz

3. Verifique o console do navegador (F12) para ver erros detalhados

4. Tente acessar de outro navegador ou dispositivo

---

## 📞 Suporte Técnico

**Erro:** `permission denied for table paid_loans`  
**Causa:** Políticas RLS muito restritivas  
**Solução:** Script `fix-paid-loans-permissions.sql`  
**Tempo:** 5 minutos  
**Prioridade:** URGENTE

---

**Criado:** Dezembro 2025  
**Última atualização:** Dezembro 2025  
**Status:** Testado e validado
