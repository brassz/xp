# 🏢 Sistema Multi-Empresa - Nexus Gestão Financeira

## 📋 Visão Geral

O sistema Nexus foi expandido para suportar múltiplas empresas com bancos de dados separados. Agora você pode gerenciar três empresas distintas:

- **NEXUS GESTÃO FINANCEIRA** (Matriz)
- **LITORAL CRED**
- **MOGIANA CRED**

Cada empresa possui seu próprio banco de dados Supabase, configurações de upload e tema visual personalizado.

## 🔧 Configuração Inicial

### 1. Configurar Bancos de Dados

Execute os scripts SQL correspondentes em cada instância do Supabase:

#### LITORAL CRED
- **URL**: https://dtifsfzmnjnllzzlndxv.supabase.co
- **Script**: `setup-litoral-cred-database.sql`
- **Usuário Admin**: admin@litoralcred.com
- **Senha**: 1020

#### MOGIANA CRED
- **URL**: https://eemfnpefgojllvzzaimu.supabase.co
- **Script**: `setup-mogiana-cred-database.sql`
- **Usuário Admin**: admin@mogianacred.com
- **Senha**: 1020

### 2. Estrutura de Arquivos

```
/workspace/
├── companies-config.js          # Configurações das empresas
├── multi-company-manager.js     # Gerenciador multi-empresa
├── company-selector.html        # Tela de seleção de empresa
├── setup-litoral-cred-database.sql
├── setup-mogiana-cred-database.sql
└── index.html                   # Sistema principal (atualizado)
```

## 🚀 Como Usar

### Primeira Utilização

1. **Acesse o sistema**: Abra `index.html` no navegador
2. **Seleção automática**: O sistema redirecionará para a tela de seleção de empresa
3. **Escolha a empresa**: Clique na empresa desejada
4. **Conecte**: Clique em "Acessar Sistema"
5. **Faça login**: Use as credenciais da empresa selecionada

### Troca de Empresa

1. **No cabeçalho**: Clique no seletor de empresa (ao lado do Dashboard)
2. **Escolha nova empresa**: Selecione a empresa desejada
3. **Login separado**: Cada empresa mantém sessões de login independentes

### Dados Separados

- ✅ **Clientes**: Cada empresa tem sua própria base de clientes
- ✅ **Empréstimos**: Dados financeiros completamente separados
- ✅ **Usuários**: Sistema de login independente por empresa
- ✅ **Documentos**: Upload de arquivos com chaves separadas

## ⚙️ Configurações por Empresa

### NEXUS (Matriz)
- **Tema**: Azul (#3B82F6)
- **Supabase**: Original (mhtxyxizfnxupwmilith)
- **Uploadcare**: 026feb50f83d7cdfe4ea

### LITORAL CRED
- **Tema**: Verde (#059669)
- **Supabase**: dtifsfzmnjnllzzlndxv
- **Uploadcare**: 026feb50f83d7cdfe4ea

### MOGIANA CRED
- **Tema**: Vermelho (#DC2626)
- **Supabase**: eemfnpefgojllvzzaimu
- **Uploadcare**: 72349b0b9769d2be0d8c

## 🔐 Segurança e Isolamento

### Isolamento de Dados
- Cada empresa possui seu próprio banco de dados Supabase
- Não há comunicação entre as bases de dados
- Usuários de uma empresa não podem acessar dados de outra

### Sessões de Login
- Sessions são armazenadas separadamente por empresa
- Formato: `nexusUser_[companyId]` no localStorage
- Logout de uma empresa não afeta as outras

### Políticas de Segurança
- Row Level Security (RLS) habilitado em todas as tabelas
- Políticas básicas de acesso configuradas
- Cada empresa mantém suas próprias políticas

## 🛠️ Desenvolvimento e Manutenção

### Adicionar Nova Empresa

1. **Edite `companies-config.js`**:
```javascript
novaempresa: {
    id: 'novaempresa',
    name: 'NOVA EMPRESA LTDA',
    logo: 'assets/images/nova-logo.png',
    supabase: {
        url: 'https://sua-url.supabase.co',
        anonKey: 'sua-chave-anonima'
    },
    uploadcare: {
        publicKey: 'sua-chave-uploadcare'
    },
    theme: {
        primaryColor: '#8B5CF6',
        secondaryColor: '#7C3AED',
        accentColor: '#A78BFA'
    }
}
```

2. **Crie script SQL**: `setup-nova-empresa-database.sql`
3. **Configure banco de dados**: Execute o script no Supabase
4. **Teste**: Acesse e verifique funcionamento

### Personalização de Temas

Os temas são aplicados automaticamente via CSS custom properties:
- `--primary-color`
- `--secondary-color`
- `--accent-color`

### Logs e Debug

O sistema inclui logs detalhados:
```javascript
// Ver logs no console do navegador
console.log('✅ Empresa conectada:', companyManager.getCurrentCompany().name);
console.log('🔧 Configuração atual:', companyManager.getCurrentCompany());
```

## 📊 Monitoramento

### Verificar Status das Empresas

1. **Console do navegador**: Verifique logs de inicialização
2. **Tela de seleção**: Indicadores visuais de conexão
3. **Supabase Dashboard**: Monitore cada instância separadamente

### Troubleshooting

#### Erro de Conexão
- Verifique URLs e chaves do Supabase
- Confirme que as tabelas foram criadas
- Teste conexão individual em cada base

#### Dados não Aparecem
- Confirme que está na empresa correta
- Verifique políticas RLS no Supabase
- Examine logs do navegador

#### Problema de Login
- Verifique se o usuário existe na base correta
- Confirme credenciais por empresa
- Limpe localStorage se necessário

## 🔄 Migração de Dados

Se precisar migrar dados entre empresas:

1. **Export**: Use o Supabase Dashboard para exportar
2. **Transform**: Ajuste IDs e referências se necessário
3. **Import**: Importe na empresa de destino
4. **Verify**: Confirme integridade dos dados

## 📞 Suporte

Para suporte técnico:
- Verifique logs do console
- Consulte documentação do Supabase
- Teste conexões individuais
- Verifique configurações em `companies-config.js`

---

## 🎯 Próximos Passos

- [ ] Adicionar relatórios consolidados (opcional)
- [ ] Implementar backup automático
- [ ] Criar dashboard de monitoramento
- [ ] Adicionar logs de auditoria por empresa
- [ ] Implementar sincronização opcional entre empresas