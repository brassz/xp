# Instruções de Deploy no Vercel - Nexus Multi-Empresas

## Configuração das Variáveis de Ambiente

Para fazer o deploy do sistema Nexus com suporte a múltiplas empresas no Vercel, você precisa configurar as seguintes variáveis de ambiente:

### 1. Acessar o Painel do Vercel

1. Faça login no [Vercel](https://vercel.com)
2. Selecione seu projeto Nexus
3. Vá para **Settings** > **Environment Variables**

### 2. Adicionar as Variáveis de Ambiente

Adicione cada uma das variáveis abaixo:

#### Empresa 1 - NEXUS (Principal)

| Variable Name | Value |
|---------------|-------|
| `NEXT_PUBLIC_SUPABASE_URL_EMPRESA1` | `https://mhtxyxizfnxupwmilith.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA1` | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1odHh5eGl6Zm54dXB3bWlsaXRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYxMzIzMDYsImV4cCI6MjA3MTcwODMwNn0.s1Y9kk2Va5EMcwAEGQmhTxo70Zv0o9oR6vrJixwEkWI` |
| `NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA1` | `5bb6bf6b98f6d36060dc` |

#### Empresa 2 - LITORAL CRED

| Variable Name | Value |
|---------------|-------|
| `NEXT_PUBLIC_SUPABASE_URL_EMPRESA2` | `https://dtifsfzmnjnllzzlndxv.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA2` | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR0aWZzZnptbmpubGx6emxuZHh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxNjQ5NzUsImV4cCI6MjA3Mjc0MDk3NX0.V40szmRzuvni2J4GK5-qZUR7nBWeUy7ikYy9B7iHxkA` |
| `NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA2` | `026feb50f83d7cdfe4ea` |

#### Empresa 3 - MOGIANA CRED

| Variable Name | Value |
|---------------|-------|
| `NEXT_PUBLIC_SUPABASE_URL_EMPRESA3` | `https://eemfnpefgojllvzzaimu.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA3` | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVlbWZucGVmZ29qbGx2enphaW11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxNjUyNjIsImV4cCI6MjA3Mjc0MTI2Mn0.PKJJ-scljbF3CFrFtMz6Rq03lVt36NQxooEH3kOcr5Y` |
| `NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA3` | `72349b0b9769d2be0d8c` |

### 3. Configuração dos Ambientes

Para cada variável adicionada:

1. Clique em **Add New**
2. Digite o **Name** da variável (ex: `NEXT_PUBLIC_SUPABASE_URL_EMPRESA2`)
3. Digite o **Value** correspondente
4. Selecione todos os ambientes:
   - ✅ **Production**
   - ✅ **Preview** 
   - ✅ **Development**
5. Clique em **Save**

### 4. Redeploy da Aplicação

Após adicionar todas as variáveis:

1. Vá para a aba **Deployments**
2. Clique nos **3 pontos** do último deployment
3. Selecione **Redeploy**
4. Aguarde o processo de build e deploy

### 5. Verificação

Após o deploy:

1. Acesse sua aplicação
2. Tente fazer login selecionando cada empresa
3. Verifique se os dados estão sendo carregados corretamente
4. Teste as funcionalidades principais

## Troubleshooting

### Problema: Variáveis não estão sendo carregadas

**Solução:**
- Verifique se todas as variáveis foram adicionadas corretamente
- Certifique-se de que estão marcadas para o ambiente correto
- Faça um novo redeploy

### Problema: Erro de conexão com Supabase

**Solução:**
- Verifique se as URLs e chaves do Supabase estão corretas
- Teste as credenciais diretamente no painel do Supabase
- Verifique se não há espaços extras nas variáveis

### Problema: Upload de arquivos não funciona

**Solução:**
- Verifique se as chaves do Uploadcare estão corretas
- Teste as chaves no painel do Uploadcare
- Certifique-se de que as chaves são públicas (não secretas)

## Comandos para Cópia Rápida

Para facilitar, aqui estão os comandos que você pode usar no terminal do Vercel CLI:

```bash
# Empresa 1 - NEXUS (Principal)
vercel env add NEXT_PUBLIC_SUPABASE_URL_EMPRESA1
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA1  
vercel env add NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA1

# Empresa 2 - LITORAL CRED
vercel env add NEXT_PUBLIC_SUPABASE_URL_EMPRESA2
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA2  
vercel env add NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA2

# Empresa 3 - MOGIANA CRED
vercel env add NEXT_PUBLIC_SUPABASE_URL_EMPRESA3
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA3
vercel env add NEXT_PUBLIC_UPLOADCARE_PUBLIC_KEY_EMPRESA3
```

## Backup das Configurações

Mantenha um backup seguro dessas configurações em um local privado, caso precise reconfigurar o projeto no futuro.