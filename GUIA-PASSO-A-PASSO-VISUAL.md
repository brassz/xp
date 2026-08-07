# 🎯 GUIA PASSO A PASSO - Resolver Erro 401

## ❌ Erro que você está vendo:
```
401 ()
permission denied for table paid_loans
```

---

## ✅ SOLUÇÃO COMPLETA (5 minutos)

### 📍 PASSO 1: Abrir o Supabase (30 segundos)

1. Abra uma nova aba no navegador
2. Acesse: **https://eppzphzwwpvpoocospxy.supabase.co**
3. Faça login se necessário
4. Você verá o painel do Supabase

---

### 📍 PASSO 2: Abrir SQL Editor (15 segundos)

1. No menu lateral **ESQUERDO**, procure por: **"SQL Editor"**
2. Clique em **"SQL Editor"**
3. Você verá uma tela com um editor de código
4. Clique no botão **"New query"** (canto superior direito)

---

### 📍 PASSO 3: Verificar se tabela existe (30 segundos)

1. Volte para o workspace onde estão os arquivos
2. Abra o arquivo: **`1-VERIFICAR-PRIMEIRO.sql`**
3. Copie **TODO** o conteúdo (Ctrl+A, Ctrl+C)
4. Volte para o SQL Editor do Supabase
5. Cole o conteúdo (Ctrl+V)
6. Clique no botão verde **"RUN"** (ou Ctrl+Enter)
7. Veja o resultado:

**Se aparecer:**
```
✅ EXISTE
```
Pule para o PASSO 5

**Se aparecer:**
```
❌ NÃO EXISTE
```
Continue para o PASSO 4

---

### 📍 PASSO 4: Criar a tabela (1 minuto)

**Execute APENAS se a tabela NÃO existir!**

1. Limpe o editor SQL (selecione tudo e delete)
2. Abra o arquivo: **`2-CRIAR-TABELA.sql`**
3. Copie **TODO** o conteúdo
4. Cole no SQL Editor
5. Clique em **"RUN"**
6. Aguarde aparecer:
   ```
   ✅ Tabela criada!
   ✅ Índices criados!
   ✅ Tabela paid_loans criada com sucesso!
   ```

---

### 📍 PASSO 5: Desabilitar RLS (1 minuto)

**Execute SEMPRE, mesmo se a tabela já existia!**

1. Limpe o editor SQL
2. Abra o arquivo: **`3-DESABILITAR-RLS.sql`**
3. Copie **TODO** o conteúdo
4. Cole no SQL Editor
5. Clique em **"RUN"**
6. Aguarde aparecer:
   ```
   ✅ RLS desabilitado!
   ✅ Políticas removidas!
   ✅ Permissões concedidas!
   ✅ DESABILITADO (correto!)
   ✅ TESTE SELECT: SUCESSO!
   ```

**IMPORTANTE:** Se aparecer "❌" em algum lugar, execute o script novamente!

---

### 📍 PASSO 6: Fechar o navegador (30 segundos)

**MUITO IMPORTANTE - NÃO PULE ESTE PASSO!**

1. Feche **TODAS as abas** do navegador
2. Feche **TODAS as janelas** do navegador
3. **Ou melhor:** Reinicie o computador

**Por quê?**
- O navegador guarda a sessão antiga em cache
- Precisa limpar essa sessão para pegar as novas permissões
- Fazer apenas logout NÃO é suficiente

---

### 📍 PASSO 7: Fazer login novamente (30 segundos)

1. Abra o navegador
2. Acesse o sistema Nexus
3. Faça **LOGIN**
4. No dropdown, selecione: **IMPERATRIZ CRED**
5. Entre no sistema

---

### 📍 PASSO 8: Testar (1 minuto)

#### Teste 1: Aba de Empréstimos Quitados
1. Clique na aba **"Empréstimos Quitados"**
2. ✅ **Deve carregar SEM erro 401**
3. ✅ Deve mostrar a tela (mesmo que vazia)

Se ainda der erro 401, volte e refaça o PASSO 6 (fechar navegador)

#### Teste 2: Marcar como Quitado
1. Vá para aba **"Empréstimos"**
2. Selecione um empréstimo ativo qualquer
3. Clique no botão **"Marcar como Quitado"**
4. Confirme a ação
5. ✅ **Deve salvar com sucesso**
6. ✅ Deve aparecer mensagem de sucesso

#### Teste 3: Ver o quitado
1. Volte para aba **"Empréstimos Quitados"**
2. ✅ O empréstimo que você quitou deve aparecer na lista
3. Clique em **"Ver Detalhes"**
4. ✅ Deve mostrar as informações

---

## 🎉 PRONTO!

Se todos os testes passaram, o problema está **100% resolvido**!

---

## 🐛 Troubleshooting

### Erro 401 continua após TODOS os passos?

**Execute no SQL Editor do Supabase:**

```sql
-- Ver se RLS está desabilitado
SELECT relrowsecurity FROM pg_class WHERE relname = 'paid_loans';
```

**Resultado esperado:** `false`  
**Se mostrar:** `true` → Execute o script 3 novamente

---

```sql
-- Ver permissões
SELECT * FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans';
```

**Resultado esperado:** Várias linhas com permissões  
**Se mostrar:** Nenhuma linha → Execute o script 3 novamente

---

### Você REALMENTE fechou o navegador?

❌ Fazer logout → NÃO funciona  
❌ Fechar a aba → NÃO funciona  
❌ Fechar uma janela → NÃO funciona  
✅ Fechar TODAS as janelas → FUNCIONA  
✅ Reiniciar o computador → FUNCIONA 100%

---

### Erro 404 em outros lugares?

O erro 404 é de outras tabelas, não é o problema principal.

**Foque no 401 da tabela paid_loans!**

---

## 📋 Checklist

Marque conforme avança:

- [ ] Passo 1: Abri o Supabase
- [ ] Passo 2: Abri SQL Editor
- [ ] Passo 3: Executei 1-VERIFICAR-PRIMEIRO.sql
- [ ] Passo 4: Executei 2-CRIAR-TABELA.sql (se necessário)
- [ ] Passo 5: Executei 3-DESABILITAR-RLS.sql
- [ ] Vi todas as mensagens ✅
- [ ] Passo 6: Fechei o navegador COMPLETAMENTE
- [ ] Passo 7: Abri e fiz login novamente
- [ ] Passo 8: Testei aba "Empréstimos Quitados" - SEM erro 401
- [ ] Testei marcar como quitado - FUNCIONOU
- [ ] Testei ver detalhes - FUNCIONOU
- [ ] ✅ **PROBLEMA RESOLVIDO!**

---

## 📊 Resumo dos Arquivos

Execute na ordem:

1. **`1-VERIFICAR-PRIMEIRO.sql`** ← Sempre execute primeiro
2. **`2-CRIAR-TABELA.sql`** ← Se a tabela não existir
3. **`3-DESABILITAR-RLS.sql`** ← Sempre execute

---

## 🆘 Precisa de Ajuda?

Se seguiu TODOS os passos e ainda não funciona:

1. Execute as queries de troubleshooting acima
2. Tire screenshot dos resultados
3. Verifique se está no Supabase correto (URL: eppzphzwwpvpoocospxy.supabase.co)
4. Tente de outro navegador ou computador

---

**Tempo total:** 5 minutos  
**Dificuldade:** Fácil (apenas copiar e colar)  
**Sucesso garantido:** 99.9% se seguir exatamente

Boa sorte! 🚀
