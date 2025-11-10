# Configuração da Empresa - IMPERATRIZ CRED

## Informações da Empresa

**Nome:** IMPERATRIZ CRED  
**Supabase URL:** `https://eppzphzwwpvpoocospxy.supabase.co`  
**Supabase Anon Key:** `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVwcHpwaHp3d3B2cG9vY29zcHh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0NTc1MDEsImV4cCI6MjA3NTAzMzUwMX0.QwiFlP-h3sk0-pDBmrOMkQmhWZtewD2wDMPYbXAATXI`

## Status da Implementação

✅ **Concluído** - Empresa adicionada ao sistema multi-empresas

### Alterações Realizadas

1. **app.js**: Adicionada configuração da empresa no `COMPANIES_CONFIG`
   - ID da empresa: `imperatriz`
   - Nome: `IMPERATRIZ CRED`
   - Configuração das variáveis de ambiente (EMPRESA5)

2. **index.html**: Adicionada opção no dropdown de seleção de empresa
   - Opção "IMPERATRIZ CRED" disponível no login

3. **README-MULTI-EMPRESAS.md**: Documentação atualizada
   - Empresa listada como 5ª empresa do sistema
   - Variáveis de ambiente documentadas

## Configuração das Variáveis de Ambiente

### Variáveis Necessárias

```bash
# Empresa 5 - IMPERATRIZ CRED
NEXT_PUBLIC_SUPABASE_URL_EMPRESA5=https://eppzphzwwpvpoocospxy.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA5=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVwcHpwaHp3d3B2cG9vY29zcHh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0NTc1MDEsImV4cCI6MjA3NTAzMzUwMX0.QwiFlP-h3sk0-pDBmrOMkQmhWZtewD2wDMPYbXAATXI
NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA5=CONFIGURE_UPLOADCARE_KEY_HERE
```

### Passos para Configuração no Vercel

1. Acesse o painel do projeto no Vercel
2. Navegue para **Settings > Environment Variables**
3. Adicione as três variáveis acima
4. Marque para todos os ambientes (Production, Preview, Development)
5. Salve as variáveis
6. Faça um redeploy da aplicação

### Desenvolvimento Local

1. Crie ou edite o arquivo `.env.local` na raiz do projeto
2. Adicione as variáveis acima
3. Reinicie o servidor de desenvolvimento

## Estrutura do Banco de Dados

O banco de dados da IMPERATRIZ CRED precisa ter a mesma estrutura das outras empresas. Execute os seguintes scripts SQL no Supabase:

### Scripts Necessários (em ordem)

1. **database-setup.sql** - Estrutura básica das tabelas
2. **setup-guarantors-table.sql** - Tabela de avalistas
3. **setup-emergency-contacts-table.sql** - Contatos de emergência
4. **update-emergency-contacts-optional.sql** - Tornar contatos opcionais
5. **setup-client-documents-table.sql** - Documentos dos clientes
6. **setup-expenses-table.sql** - Tabela de despesas
7. **setup-pix-keys-table.sql** - Chaves PIX
8. **add-fine-field-to-payments.sql** - Campo de multa em pagamentos

### Como Executar os Scripts

1. Acesse o painel do Supabase: https://eppzphzwwpvpoocospxy.supabase.co
2. Navegue para **SQL Editor**
3. Execute cada script na ordem listada acima
4. Verifique se não há erros após cada execução

## Como Usar

### Login na Aplicação

1. Acesse a aplicação Nexus
2. No dropdown "Empresa", selecione **IMPERATRIZ CRED**
3. Faça login com suas credenciais
4. Todas as operações serão realizadas no banco de dados da Imperatriz Cred

### Isolamento de Dados

- Cada empresa tem seu próprio banco de dados Supabase
- Os dados da Imperatriz Cred são completamente isolados das outras empresas
- É necessário selecionar a empresa correta no login

## Configuração do Uploadcare (Pendente)

⚠️ **Ação Necessária**: Configurar conta do Uploadcare para upload de documentos

1. Crie uma conta no Uploadcare (https://uploadcare.com)
2. Obtenha a Public Key da conta
3. Atualize a variável de ambiente:
   ```bash
   NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA5=SUA_CHAVE_AQUI
   ```
4. Atualize no Vercel e faça redeploy

## Funcionalidades Disponíveis

Após a configuração completa, a Imperatriz Cred terá acesso a todas as funcionalidades do sistema:

- ✅ Gestão de Clientes
- ✅ Gestão de Empréstimos
- ✅ Parcelamentos
- ✅ Pagamentos
- ✅ Dashboard e Relatórios
- ✅ Gestão de Despesas
- ✅ Controle de Caixa
- ✅ Upload de Documentos
- ✅ Avalistas e Contatos de Emergência
- ✅ Chaves PIX

## Configuração de Comissões

Por padrão, a Imperatriz Cred segue o modelo de comissões padrão:
- **Vinicius**: 66,6% das comissões
- **Douglas**: 33,3% das comissões

Se for necessário um modelo diferente (como o da ERECHIM com 3 pessoas), será necessário ajustar o código.

## Próximos Passos

1. ✅ Empresa adicionada ao sistema
2. ⏳ Configurar variáveis de ambiente no Vercel
3. ⏳ Executar scripts de banco de dados
4. ⏳ Configurar conta do Uploadcare
5. ⏳ Criar primeiro usuário administrador
6. ⏳ Testar funcionalidades principais

## Suporte

Em caso de dúvidas ou problemas:
1. Verifique se todas as variáveis de ambiente estão configuradas
2. Confirme que os scripts SQL foram executados corretamente
3. Verifique os logs do Supabase para erros de banco de dados
4. Teste o login com diferentes navegadores

## Data de Implementação

**Data:** 10/11/2025  
**Implementado por:** Sistema automatizado  
**Status:** ✅ Configuração concluída - Pronta para uso após configuração do ambiente
