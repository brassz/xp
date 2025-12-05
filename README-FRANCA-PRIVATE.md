# FRANCA PRIVATE - Sistema Especial

## Visão Geral

Foi implementado um sistema especial **FRANCA PRIVATE** que pode ser acessado através de um botão secreto de 3 cliques no nome "Bruno Assoni" na tela de login.

## Configuração do Sistema

### Credenciais Supabase
- **URL**: `https://pebwoerzslfzhjptyjwh.supabase.co`
- **Anon Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBlYndvZXJ6c2xmemhqcHR5andoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ5NjgyODQsImV4cCI6MjA4MDU0NDI4NH0.WaQQtJzhvV9rIiosiQ9kftYRa24jVSxCgPWAy3ZMzvY`

### Usuários Admin Pré-configurados
1. **Email**: `admin@francaprivate.com` | **Senha**: `1020`
2. **Email**: `contato@francaprivate.com` | **Senha**: `1020`

## Como Acessar o Sistema

### Método 1: Botão Secreto de 3 Cliques
1. Abra a tela de login da aplicação Nexus
2. Localize o texto "Desenvolvido por **Bruno Assoni**" no rodapé
3. Clique **3 vezes** no nome "Bruno Assoni" (dentro de 2 segundos)
4. Uma confirmação aparecerá: "Ativar sistema Franca Private?"
5. Clique em "OK"
6. O sistema será ativado e a página recarregará
7. Faça login com um dos usuários admin acima

### Método 2: Seleção Direta no Dropdown
1. Abra a tela de login
2. No campo "Empresa", selecione **FRANCA PRIVATE**
3. Faça login com um dos usuários admin

## Configuração do Banco de Dados

### Arquivo SQL
O arquivo `setup-bruno-assoni-system.sql` contém toda a estrutura do banco de dados.

### Passos para Configurar
1. Acesse o Supabase: https://pebwoerzslfzhjptyjwh.supabase.co
2. Vá para **SQL Editor**
3. Abra o arquivo `setup-bruno-assoni-system.sql`
4. Copie todo o conteúdo
5. Cole no SQL Editor do Supabase
6. Clique em **Run** para executar
7. Verifique se não há erros
8. Confirme que todas as tabelas foram criadas

## Estrutura do Banco de Dados

O sistema possui as mesmas tabelas dos outros sistemas Nexus:

### Tabelas Principais
- ✅ `users` - Usuários do sistema
- ✅ `clients` - Clientes
- ✅ `emergency_contacts` - Contatos de emergência
- ✅ `client_documents` - Documentos dos clientes
- ✅ `pix_keys` - Chaves PIX da empresa
- ✅ `guarantors` - Avalistas
- ✅ `loans` - Empréstimos
- ✅ `payments` - Pagamentos
- ✅ `installments` - Parcelamentos
- ✅ `installment_items` - Parcelas individuais
- ✅ `installment_payments` - Pagamentos de parcelas
- ✅ `expenses` - Despesas
- ✅ `expense_categories` - Categorias de despesas
- ✅ `commissions` - Comissões
- ✅ `capital_raising` - Captação de capital
- ✅ `investor_payments` - Pagamentos de investidores
- ✅ `cash_management` - Gestão de caixa

### Funcionalidades Incluídas
- ✅ Sistema completo de gestão de clientes
- ✅ Gestão de empréstimos com juros
- ✅ Sistema de parcelamentos
- ✅ Histórico de pagamentos
- ✅ Gestão de despesas com categorias
- ✅ Sistema de comissões
- ✅ Captação de capital (investidores)
- ✅ Gestão de caixa (entradas e saídas)
- ✅ Documentos e fotos de clientes
- ✅ Avalistas
- ✅ Chaves PIX para cobranças
- ✅ Relatórios e dashboards

## Recursos Técnicos

### Índices Otimizados
Todos os índices necessários para performance foram criados automaticamente.

### Triggers Automáticos
- Atualização automática de `updated_at` em todas as tabelas
- Timestamps automáticos em todas as inserções

### Views Pré-configuradas
- `loans_with_details` - Empréstimos com informações completas
- `overdue_loans` - Empréstimos vencidos
- `financial_summary` - Resumo financeiro
- `installments_with_details` - Parcelamentos com detalhes
- `cash_summary` - Resumo de caixa

### Segurança
- ⚠️ **RLS Desabilitado** - Row Level Security foi desabilitado para facilitar o uso
- A segurança é gerenciada pela aplicação
- Senhas são armazenadas como texto simples (considere implementar hash em produção)

## Dados de Exemplo

O script SQL inclui:
- 2 usuários admin pré-configurados
- 2 clientes de exemplo
- 1 chave PIX de exemplo
- 8 categorias de despesas padrão

## Variáveis de Ambiente (Vercel)

Para deploy em produção, configure as seguintes variáveis no Vercel:

```bash
NEXT_PUBLIC_SUPABASE_URL_EMPRESA6=https://pebwoerzslfzhjptyjwh.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA6=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBlYndvZXJ6c2xmemhqcHR5andoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ5NjgyODQsImV4cCI6MjA4MDU0NDI4NH0.WaQQtJzhvV9rIiosiQ9kftYRa24jVSxCgPWAy3ZMzvY
NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA6=CONFIGURE_UPLOADCARE_KEY_HERE
```

## Isolamento de Dados

- ✅ **Banco de dados separado** - Completamente isolado dos outros sistemas
- ✅ **Credenciais únicas** - Chaves de API exclusivas
- ✅ **Uploadcare separado** - Requer configuração de chave própria
- ✅ **Sem compartilhamento** - Nenhum dado é compartilhado entre sistemas

## Próximos Passos

1. ✅ Executar o script SQL no Supabase
2. ⚠️ Configurar chave do Uploadcare para upload de arquivos
3. ⚠️ Testar o acesso com o botão de 3 cliques
4. ⚠️ Criar usuários adicionais conforme necessário
5. ⚠️ Configurar chaves PIX reais para cobranças

## Suporte

Sistema desenvolvido seguindo o padrão dos outros sistemas Nexus com todas as funcionalidades disponíveis.

Para dúvidas ou problemas, consulte os outros arquivos README do projeto:
- `README-MULTI-EMPRESAS.md` - Sistema multi-empresas
- `README.md` - Documentação geral do Nexus
