# 🔧 Correção: Empréstimos Quitados - Imperatriz Cred

## 📋 Problema Identificado

**Empresa:** IMPERATRIZ CRED  
**Sintoma:** Ao marcar um empréstimo como quitado, ele não salva no banco de dados  
**Causa:** Tabela `paid_loans` não existe ou está mal configurada no banco da Imperatriz

---

## 🎯 Solução

Execute o script SQL `fix-imperatriz-paid-loans.sql` no Supabase da empresa Imperatriz Cred.

Este script irá:
- ✅ Criar a tabela `paid_loans` se não existir
- ✅ Configurar índices para performance
- ✅ Configurar RLS (Row Level Security) com políticas permissivas
- ✅ Conceder todas as permissões necessárias
- ✅ Criar triggers automáticos
- ✅ Criar view para consultas facilitadas
- ✅ Executar testes de inserção
- ✅ Mostrar diagnóstico completo

---

## 📝 Instruções de Aplicação

### Passo 1: Acessar Supabase da Imperatriz Cred

1. Acesse [https://supabase.com](https://supabase.com)
2. Faça login com suas credenciais
3. Selecione o projeto da **IMPERATRIZ CRED**:
   - URL: `https://eppzphzwwpvpoocospxy.supabase.co`

### Passo 2: Abrir SQL Editor

1. No menu lateral esquerdo, clique em **"SQL Editor"**
2. Clique em **"New query"** para criar uma nova consulta

### Passo 3: Executar o Script

1. Abra o arquivo `fix-imperatriz-paid-loans.sql`
2. **Copie TODO o conteúdo** do arquivo
3. **Cole** no SQL Editor do Supabase
4. Clique no botão **"Run"** (ou pressione Ctrl+Enter)
5. Aguarde a execução (pode levar alguns segundos)

### Passo 4: Verificar Resultados

O script mostrará várias mensagens de verificação:

```
✅ Tabela paid_loans: EXISTE
✅ RLS ativado: SIM ✅
✅ Políticas RLS: 4 políticas
✅ Permissões: authenticated com INSERT, SELECT, UPDATE, DELETE
✅ Índices criados: 5 índices
✅ Triggers: 1 trigger
✅ Teste de inserção: SUCESSO
```

Se todas as verificações mostrarem ✅, a correção foi aplicada com sucesso!

---

## 🧪 Como Testar

### Teste 1: Marcar Empréstimo como Quitado

1. Acesse o sistema
2. Faça login selecionando **IMPERATRIZ CRED**
3. Vá para a aba **"Empréstimos"**
4. Selecione um empréstimo ativo
5. Clique no botão **"Marcar como Quitado"**
6. Confirme a ação
7. Verifique se aparece mensagem: **"Empréstimo quitado com sucesso"**

### Teste 2: Visualizar Empréstimos Quitados

1. Vá para a aba **"Empréstimos Quitados"**
2. Verifique se o empréstimo quitado aparece na lista
3. Clique em **"Ver Detalhes"** para ver informações completas

### Teste 3: Verificar no Dashboard

1. Vá para o **Dashboard**
2. Verifique o card **"Empréstimos Quitados"**
3. Confirme que a contagem está correta

---

## 🔍 Diagnóstico Manual (Se Necessário)

Se ainda houver problemas, execute estas consultas no SQL Editor:

### Verificar se a tabela existe
```sql
SELECT * FROM information_schema.tables 
WHERE table_name = 'paid_loans';
```

### Verificar permissões
```sql
SELECT grantee, privilege_type
FROM information_schema.role_table_grants 
WHERE table_name = 'paid_loans';
```

### Verificar políticas RLS
```sql
SELECT * FROM pg_policies 
WHERE tablename = 'paid_loans';
```

### Verificar se há registros
```sql
SELECT COUNT(*) FROM paid_loans;
```

---

## 🐛 Troubleshooting

### Erro: "permission denied for table paid_loans"
**Solução:** Execute novamente o script, especialmente a seção de permissões (PASSO 7)

### Erro: "relation paid_loans does not exist"
**Solução:** A tabela não foi criada. Execute o script completo novamente

### Erro ao inserir: "new row violates row-level security policy"
**Solução:** As políticas RLS estão muito restritivas. O script já configura políticas permissivas

### Empréstimo não aparece na aba "Quitados"
**Solução:** 
1. Faça logout e login novamente
2. Limpe o cache do navegador (Ctrl+Shift+Delete)
3. Verifique se está na empresa correta (IMPERATRIZ CRED)

---

## 📊 Estrutura da Tabela paid_loans

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | ID único do registro de quitação |
| `loan_id` | UUID | ID original do empréstimo |
| `client_id` | UUID | ID do cliente |
| `original_amount` | DECIMAL | Valor original emprestado |
| `interest_rate` | DECIMAL | Taxa de juros (%) |
| `total_with_interest` | DECIMAL | Total com juros |
| `loan_date` | DATE | Data do empréstimo |
| `due_date` | DATE | Data de vencimento |
| `paid_date` | DATE | Data da quitação |
| `total_paid` | DECIMAL | Total efetivamente pago |
| `payment_method` | VARCHAR | Método de pagamento |
| `notes` | TEXT | Observações |
| `created_by` | UUID | ID do usuário que criou |
| `created_at` | TIMESTAMP | Data de criação |
| `updated_at` | TIMESTAMP | Data de atualização |

---

## 📦 Arquivos Relacionados

- **Script de correção:** `fix-imperatriz-paid-loans.sql`
- **Documentação:** `README-fix-imperatriz-quitacao.md` (este arquivo)
- **Script genérico:** `setup-paid-loans.sql` (para outras empresas)
- **Código da aplicação:** `app.js` (função `markLoanAsPaid()` na linha 8521)

---

## ✅ Checklist de Validação

Após aplicar o script, verifique:

- [ ] Script executado sem erros
- [ ] Todas as verificações mostram ✅
- [ ] Teste de inserção foi bem-sucedido
- [ ] Consegue marcar empréstimo como quitado
- [ ] Empréstimo aparece na aba "Quitados"
- [ ] Dashboard mostra contagem correta
- [ ] Pode visualizar detalhes do empréstimo quitado

---

## 🎉 Resultado Esperado

Após aplicar a correção:

1. ✅ Usuários conseguem marcar empréstimos como quitados
2. ✅ Dados são salvos corretamente no banco
3. ✅ Empréstimos quitados aparecem na aba dedicada
4. ✅ Dashboard mostra estatísticas corretas
5. ✅ Histórico de pagamentos é preservado
6. ✅ Relatórios incluem empréstimos quitados

---

## 📞 Suporte

Se o problema persistir após seguir todos os passos:

1. Verifique os logs do console do navegador (F12)
2. Verifique os logs do Supabase
3. Confirme que está usando a empresa IMPERATRIZ CRED
4. Confirme que o usuário tem permissões adequadas

---

## 📚 Referências

- [Documentação de Cancelamento](./README-cancelamento-emprestimos.md)
- [Configuração Multi-Empresas](./README-MULTI-EMPRESAS.md)
- [Configuração Imperatriz](./README-IMPERATRIZ-CRED.md)
- [Setup Paid Loans](./setup-paid-loans.sql)

---

**Empresa:** Imperatriz Cred  
**Script:** fix-imperatriz-paid-loans.sql  
**Data:** Dezembro 2025  
**Status:** ✅ Pronto para aplicar
