# 🚀 Guia Rápido - Problema com Empréstimos Quitados

## ⚠️ Sintoma do Problema

Ao clicar em **"Marcar como Quitado"** em um empréstimo:
- ❌ O empréstimo não é salvo no banco de dados
- ❌ Aparece uma mensagem de erro
- ❌ O empréstimo não aparece na aba "Empréstimos Quitados"

## 🎯 Solução Rápida (3 Passos)

### Passo 1: Diagnóstico

Execute o script de diagnóstico para confirmar o problema:

1. Acesse o Supabase da empresa afetada
2. Abra o **SQL Editor**
3. Execute o arquivo: `diagnose-paid-loans-table.sql`
4. Verifique se aparece: **"❌ Tabela paid_loans não existe"**

### Passo 2: Correção

Se o diagnóstico confirmou o problema, execute o script de correção:

1. No mesmo **SQL Editor** do Supabase
2. Execute o arquivo: `setup-paid-loans-generic.sql`
3. Aguarde até ver: **"🎉 CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!"**

### Passo 3: Teste

Teste a funcionalidade no sistema:

1. Faça login na empresa afetada
2. Vá para **Empréstimos** → Selecione um empréstimo ativo
3. Clique em **"Marcar como Quitado"**
4. Confirme a ação
5. Verifique se:
   - ✅ Mensagem de sucesso aparece
   - ✅ Empréstimo some da lista de ativos
   - ✅ Empréstimo aparece na aba "Quitados"

## 📊 Scripts Disponíveis

### 1. `diagnose-paid-loans-table.sql`
**Uso**: Diagnosticar o problema  
**Quando usar**: Antes de aplicar correção  
**O que faz**:
- Verifica se a tabela `paid_loans` existe
- Mostra estrutura da tabela
- Verifica permissões e RLS
- Identifica problemas de configuração

### 2. `setup-paid-loans-generic.sql`
**Uso**: Criar/corrigir a tabela paid_loans  
**Quando usar**: Quando diagnóstico confirmar problema  
**O que faz**:
- Cria a tabela `paid_loans`
- Cria índices para performance
- Configura permissões
- Cria view `paid_loans_with_details`
- Configura RLS automaticamente

### 3. `fix-litoral-paid-loans.sql`
**Uso**: Específico para LITORAL CRED  
**Quando usar**: Problema na LITORAL CRED  
**O que faz**: Mesma coisa que o genérico, mas otimizado para Litoral

## 🏢 URLs do Supabase por Empresa

| Empresa | URL do Supabase |
|---------|-----------------|
| **NEXUS** | https://mhtxyxizfnxupwmilith.supabase.co |
| **LITORAL CRED** | https://dtifsfzmnjnllzzlndxv.supabase.co |
| **MOGIANA CRED** | https://eemfnpefgojllvzzaimu.supabase.co |
| **ERECHIM** | https://adjrvtupfshdhwjvhmgj.supabase.co |
| **IMPERATRIZ CRED** | https://eppzphzwwpvpoocospxy.supabase.co |

## 🔍 Melhorias no Código

O código foi atualizado para mostrar mensagens de erro mais claras:

### Antes:
```
Erro ao marcar empréstimo como quitado: relation "paid_loans" does not exist
```

### Agora:
```
❌ ERRO: A tabela 'paid_loans' não existe no banco de dados da LITORAL CRED!

Por favor, execute o script 'fix-litoral-paid-loans.sql' no SQL Editor do Supabase.

Consulte o arquivo README-fix-litoral-paid-loans.md para instruções detalhadas.
```

## 📝 Logs Melhorados

O sistema agora exibe logs detalhados no console do navegador:

```
[LITORAL] Iniciando processo de quitação do empréstimo abc-123...
[LITORAL] Total pago: R$ 1.050,00
[LITORAL] Tentando inserir na tabela paid_loans...
[LITORAL] ✅ Empréstimo inserido na tabela paid_loans com sucesso!
[LITORAL] Removendo da tabela loans...
[LITORAL] ✅ Processo de quitação concluído com sucesso!
```

Para ver os logs:
1. Pressione **F12** no navegador
2. Vá para a aba **Console**
3. Tente marcar um empréstimo como quitado

## 🆘 Troubleshooting

### Problema: Script não executa no Supabase

**Possíveis causas**:
- Você não tem permissões de admin no Supabase
- Está no banco de dados errado
- Erro de sintaxe no SQL

**Solução**:
1. Verifique se você está logado como admin
2. Confirme que está no banco correto (veja URLs acima)
3. Copie todo o conteúdo do script novamente

### Problema: Erro "permission denied"

**Causa**: Seu usuário não tem permissões suficientes

**Solução**:
1. Faça login com usuário admin no Supabase
2. Ou peça para alguém com permissões executar o script

### Problema: Tabela criada mas ainda não funciona

**Possíveis causas**:
- RLS (Row Level Security) está bloqueando
- Permissões não foram aplicadas corretamente

**Solução**:
1. Execute o diagnóstico novamente: `diagnose-paid-loans-table.sql`
2. Verifique a seção de RLS e Permissões
3. Execute o script de correção novamente

### Problema: Empréstimo some mas não aparece em "Quitados"

**Causa**: Problema na renderização da interface

**Solução**:
1. Faça um hard refresh: Ctrl+Shift+R (Windows) ou Cmd+Shift+R (Mac)
2. Limpe o cache do navegador
3. Faça logout e login novamente

## 📞 Suporte

Se nenhuma das soluções acima resolver:

1. **Capture informações**:
   - Execute o diagnóstico e salve o resultado
   - Tire print da mensagem de erro
   - Anote qual empresa está afetada
   - Verifique os logs no console (F12)

2. **Entre em contato** com a equipe de desenvolvimento com:
   - Prints dos erros
   - Resultado do diagnóstico
   - Nome da empresa afetada
   - Passos que você já tentou

## ✅ Checklist de Aplicação

Para garantir que tudo foi aplicado corretamente:

- [ ] Diagnóstico executado e problema identificado
- [ ] Script de correção executado com sucesso
- [ ] Mensagem "🎉 CONFIGURAÇÃO CONCLUÍDA" apareceu
- [ ] Diagnóstico executado novamente - tudo OK
- [ ] Teste de quitação realizado
- [ ] Empréstimo aparece em "Quitados"
- [ ] Logs no console mostram sucesso
- [ ] Equipe informada da correção

## 🎯 Empresas Afetadas

Atualmente confirmado:
- ✅ **LITORAL CRED** - Problema confirmado e solução testada

Outras empresas devem ser verificadas:
- ❓ **NEXUS** - Executar diagnóstico
- ❓ **MOGIANA CRED** - Executar diagnóstico
- ❓ **ERECHIM** - Executar diagnóstico
- ❓ **IMPERATRIZ CRED** - Executar diagnóstico

**Recomendação**: Execute o diagnóstico em todas as empresas para garantir que todas estão funcionando.

## 🔄 Manutenção Preventiva

Para evitar esse problema no futuro:

1. **Ao criar novo banco de dados**:
   - Execute sempre o script completo de setup
   - Inclua o `setup-paid-loans-generic.sql`

2. **Ao fazer backup/restore**:
   - Verifique se a tabela `paid_loans` foi incluída
   - Execute diagnóstico após restore

3. **Ao migrar dados**:
   - Migre também a tabela `paid_loans`
   - Teste a funcionalidade após migração

---

**Última atualização**: 25 de Novembro de 2025  
**Versão**: 1.0  
**Status**: Solução testada e funcionando
