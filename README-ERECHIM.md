# Configuração da Empresa ERECHIM - Nexus Gestão Financeira

## 📋 Visão Geral

Este documento contém todas as informações necessárias para configurar e utilizar o banco de dados da empresa **ERECHIM** no sistema Nexus.

## 🔑 Credenciais do Banco de Dados

- **URL do Supabase**: `https://adjrvtupfshdhwjvhmgj.supabase.co`
- **Anon Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFkanJ2dHVwZnNoZGh3anZobWdqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc2MDAyMDUsImV4cCI6MjA3MzE3NjIwNX0.iSl7bECBz8yl5HHcBwL6gp5Pd5Y06nNFWgLTzvLgVSY`
- **Uploadcare Key**: `CONFIGURE_UPLOADCARE_KEY_HERE` ⚠️ *Pendente configuração*

## 🚀 Passo a Passo para Configuração

### 1. Acessar o Painel do Supabase

1. Acesse: https://adjrvtupfshdhwjvhmgj.supabase.co
2. Faça login com as credenciais fornecidas pela equipe ERECHIM
3. No menu lateral, clique em **"SQL Editor"**

### 2. Executar o Script de Configuração

1. Abra o arquivo `setup-erechim-database.sql` (localizado na raiz do projeto)
2. Copie todo o conteúdo do arquivo
3. No SQL Editor do Supabase, cole o script completo
4. Clique no botão **"Run"** ou pressione `Ctrl + Enter`
5. Aguarde a execução completa (pode levar alguns minutos)
6. Verifique se não há erros na execução

### 3. Verificar a Instalação

Após a execução do script, você deve ver mensagens de confirmação indicando:

- ✅ Todas as tabelas foram criadas
- ✅ Índices foram configurados
- ✅ Triggers estão ativos
- ✅ Views foram criadas
- ✅ Usuário administrador foi criado
- ✅ Categorias de despesas padrão foram inseridas

### 4. Configurar Uploadcare (Opcional)

Para habilitar o upload de fotos e documentos:

1. Crie uma conta em https://uploadcare.com
2. Obtenha sua chave pública (Public Key)
3. Atualize o arquivo `app.js` na linha com `CONFIGURE_UPLOADCARE_KEY_HERE`
4. Substitua pelo valor da sua chave Uploadcare

**Ou configure via variáveis de ambiente no Vercel:**

```bash
NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA4=sua_chave_aqui
```

## 👤 Usuário Administrador Padrão

Após a execução do script, o seguinte usuário estará disponível:

- **Email**: `admin@erechim.com`
- **Senha**: `1020`
- **Tipo**: Administrador

⚠️ **IMPORTANTE**: Altere a senha padrão após o primeiro login!

## 📊 Estrutura do Banco de Dados

O banco de dados inclui as seguintes tabelas principais:

### Tabelas de Usuários e Segurança
- `users` - Usuários do sistema
- `clients` - Clientes da empresa

### Tabelas de Operações Financeiras
- `loans` - Empréstimos
- `payments` - Pagamentos
- `installments` - Parcelamentos
- `installment_payments` - Parcelas individuais
- `expenses` - Despesas
- `expense_categories` - Categorias de despesas
- `cash_transactions` - Transações de caixa
- `cash_settings` - Configurações do caixa
- `capital_raising` - Levantamento de capital
- `capital_raising_clients` - Clientes do levantamento

### Tabelas de Status de Empréstimos
- `paid_loans` - Empréstimos quitados
- `overdue_loans` - Empréstimos vencidos
- `partial_paid_loans` - Empréstimos parcialmente pagos
- `cancelled_loans` - Empréstimos cancelados

### Tabelas Auxiliares
- `guarantors` - Avalistas
- `emergency_contacts` - Contatos de emergência
- `client_documents` - Documentos dos clientes
- `client_pix_keys` - Chaves PIX dos clientes

### Views (Visualizações)
- `loans_with_details` - Empréstimos com detalhes completos
- `financial_summary` - Resumo financeiro
- `active_users` - Usuários ativos
- `expenses_with_details` - Despesas com detalhes
- `cash_transactions_summary` - Resumo de transações
- E outras...

## 🔐 Segurança

O banco de dados está configurado com:

- ✅ **Row Level Security (RLS)** habilitado em todas as tabelas
- ✅ Políticas de acesso baseadas em funções (admin, user, manager)
- ✅ Isolamento completo de dados entre empresas
- ✅ Triggers automáticos para auditoria

## 🌐 Como Usar no Sistema

### No Navegador (Produção)

1. Acesse a URL da aplicação
2. Na tela de login, selecione **"ERECHIM"** no dropdown de empresas
3. Digite o email e senha
4. Clique em **"Entrar"**

### Desenvolvimento Local

1. Certifique-se de que o arquivo `app.js` contém as credenciais da ERECHIM
2. A empresa será listada automaticamente no dropdown
3. Selecione ERECHIM e faça login normalmente

## 📝 Categorias de Despesas Padrão

O sistema já vem com as seguintes categorias pré-cadastradas:

1. 🍽️ Alimentação
2. 🚗 Transporte
3. 💼 Escritório
4. 📢 Marketing
5. 💻 Tecnologia
6. ❤️ Saúde
7. 📚 Educação
8. 🧹 Limpeza
9. 🔧 Manutenção
10. 📁 Outros

## 🔄 Sincronização com Vercel

Para deploy em produção, configure as seguintes variáveis de ambiente no Vercel:

```bash
NEXT_PUBLIC_SUPABASE_URL_EMPRESA4=https://adjrvtupfshdhwjvhmgj.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA4=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFkanJ2dHVwZnNoZGh3anZobWdqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc2MDAyMDUsImV4cCI6MjA3MzE3NjIwNX0.iSl7bECBz8yl5HHcBwL6gp5Pd5Y06nNFWgLTzvLgVSY
NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA4=sua_chave_uploadcare
```

### Como Adicionar no Vercel:

1. Acesse o dashboard do Vercel
2. Selecione o projeto
3. Vá em **Settings > Environment Variables**
4. Adicione cada variável acima
5. Selecione os ambientes (Production, Preview, Development)
6. Clique em **Save**
7. Faça um novo deploy

## 📞 Suporte

Para qualquer dúvida ou problema:

1. Verifique os logs no SQL Editor do Supabase
2. Consulte a documentação completa em `README-MULTI-EMPRESAS.md`
3. Entre em contato com a equipe de desenvolvimento

## ⚠️ Observações Importantes

1. **Backup**: Sempre faça backup antes de fazer alterações no banco
2. **Senhas**: Altere as senhas padrão imediatamente
3. **Uploadcare**: Configure uma chave Uploadcare para habilitar uploads
4. **Testes**: Teste todas as funcionalidades em ambiente de desenvolvimento primeiro
5. **Migração**: Se estiver migrando dados de outro sistema, utilize scripts específicos

## 🎯 Próximos Passos

Após a configuração inicial:

1. ✅ Alterar senha do administrador
2. ✅ Criar usuários adicionais
3. ✅ Configurar Uploadcare
4. ✅ Cadastrar os primeiros clientes
5. ✅ Testar todas as funcionalidades
6. ✅ Configurar backups automáticos

## 📅 Data de Criação

**Data**: 30 de Outubro de 2025
**Versão do Sistema**: Multi-Empresas v1.0
**Status**: ✅ Configurado e Pronto para Uso

---

**Desenvolvido para**: ERECHIM
**Sistema**: Nexus Gestão Financeira
**Suporte**: Equipe de Desenvolvimento Nexus
