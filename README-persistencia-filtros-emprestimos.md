# Persistência de Filtros na Aba de Empréstimos

## 📋 Descrição

Implementação de persistência de filtros na aba de empréstimos, permitindo que os filtros aplicados pelo administrador permaneçam ativos mesmo após:
- Navegar para outras abas do sistema
- Fechar o navegador
- Sair do sistema
- Abrir outras aplicações (WhatsApp, etc.)

## 🎯 Funcionalidades

### Filtros Persistidos

Os seguintes filtros são salvos automaticamente no localStorage:

1. **Campo de Busca**
   - Busca por nome do cliente, valor, taxa de juros, etc.

2. **Filtros de Data de Criação**
   - Data de criação: De
   - Data de criação: Até

3. **Filtros de Data de Vencimento**
   - Data de vencimento: De
   - Data de vencimento: Até

4. **Ordenação**
   - Ordenar por (Data de criação, Data de vencimento, Valor, Cliente, etc.)
   - Ordem (Crescente/Decrescente)

## 🔧 Implementação Técnica

### Funções Criadas

#### 1. `saveLoanFilters()`
Salva todos os filtros ativos no localStorage sempre que o usuário:
- Digita no campo de busca
- Altera qualquer filtro de data
- Muda a ordenação

```javascript
function saveLoanFilters() {
    const filters = {
        searchTerm: document.getElementById('loanSearchInput')?.value || '',
        creationDateFrom: document.getElementById('creationDateFrom')?.value || '',
        creationDateTo: document.getElementById('creationDateTo')?.value || '',
        dueDateFrom: document.getElementById('dueDateFrom')?.value || '',
        dueDateTo: document.getElementById('dueDateTo')?.value || '',
        sortBy: document.getElementById('sortBy')?.value || 'loan_date',
        sortOrder: document.getElementById('sortOrder')?.value || 'desc'
    };
    
    localStorage.setItem('loanFilters', JSON.stringify(filters));
}
```

#### 2. `restoreLoanFilters()`
Restaura os filtros salvos quando a página é carregada:
- Busca os valores no localStorage
- Aplica os valores aos campos de filtro
- Não recarrega a tabela (isso é feito por `applyFiltersAndSort()`)

```javascript
function restoreLoanFilters() {
    try {
        const savedFilters = localStorage.getItem('loanFilters');
        
        if (savedFilters) {
            const filters = JSON.parse(savedFilters);
            
            // Restaurar valores nos campos
            if (searchInput) searchInput.value = filters.searchTerm || '';
            if (creationDateFrom) creationDateFrom.value = filters.creationDateFrom || '';
            // ... resto dos campos
        }
    } catch (error) {
        console.error('Erro ao restaurar filtros de empréstimos:', error);
    }
}
```

### Fluxo de Execução

1. **Ao Carregar a Página**
   ```
   initializeApp() 
   → setupEventListeners() 
   → restoreLoanFilters() (restaura valores nos campos)
   → loadData() 
   → loadLoans() 
   → applyFiltersAndSort() (aplica filtros restaurados)
   ```

2. **Ao Alterar Filtros**
   ```
   usuário altera filtro 
   → saveLoanFilters() (salva no localStorage)
   → applyFiltersAndSort() (aplica e renderiza)
   ```

3. **Ao Limpar Filtros**
   ```
   clearAllFilters() ou clearLoanSearch()
   → limpa campos
   → localStorage.removeItem('loanFilters') ou saveLoanFilters()
   → applyFiltersAndSort()
   ```

## 💡 Casos de Uso

### Cenário 1: Navegação Entre Abas
```
Admin aplica filtros → Vai para aba Clientes → Retorna para Empréstimos
Resultado: Filtros mantidos ✅
```

### Cenário 2: Fechar e Reabrir Navegador
```
Admin aplica filtros → Fecha navegador → Reabre sistema
Resultado: Filtros mantidos ✅
```

### Cenário 3: Sair do Sistema
```
Admin aplica filtros → Vai para WhatsApp → Retorna ao sistema
Resultado: Filtros mantidos ✅
```

### Cenário 4: Trocar de Empresa
```
Admin aplica filtros em Empresa1 → Troca para Empresa2
Resultado: Filtros da Empresa1 mantidos quando retornar ✅
```

### Cenário 5: Limpar Filtros
```
Admin clica em "Limpar Filtros" ou "Limpar Busca"
Resultado: localStorage atualizado, filtros limpos ✅
```

## 🔐 Segurança

- Os filtros são salvos no localStorage do navegador (client-side)
- Não há risco de segurança, pois são apenas valores de filtro
- Cada navegador/dispositivo mantém seus próprios filtros
- Os filtros não são compartilhados entre usuários

## 📊 Armazenamento

Os dados são salvos no localStorage com a chave:
```javascript
'loanFilters'
```

Formato do JSON salvo:
```json
{
  "searchTerm": "João",
  "creationDateFrom": "2024-01-01",
  "creationDateTo": "2024-12-31",
  "dueDateFrom": "",
  "dueDateTo": "",
  "sortBy": "loan_date",
  "sortOrder": "desc"
}
```

## 🧪 Testando

Para testar a persistência:

1. **Aplicar filtros**
   - Digite algo no campo de busca
   - Selecione datas
   - Altere a ordenação

2. **Verificar localStorage**
   - Abra DevTools (F12)
   - Vá em Application → Local Storage
   - Procure por `loanFilters`
   - Veja o JSON com os valores salvos

3. **Testar persistência**
   - Navegue para outra aba
   - Retorne para Empréstimos → Filtros devem estar lá
   - Feche o navegador
   - Reabra o sistema → Filtros devem estar lá

4. **Testar limpeza**
   - Clique em "Limpar Filtros"
   - Verifique no localStorage que `loanFilters` foi removido

## 🔄 Compatibilidade

- ✅ Chrome/Edge
- ✅ Firefox
- ✅ Safari
- ✅ Opera
- ✅ Brave

## 📝 Notas

- Os filtros são específicos por navegador/dispositivo
- Se o usuário limpar dados do navegador, os filtros serão perdidos
- Não há limite de tempo para a persistência
- Os filtros não afetam outros usuários

## 🐛 Troubleshooting

### Filtros não estão sendo salvos
1. Verificar se localStorage está habilitado no navegador
2. Verificar se não está em modo anônimo/privado
3. Verificar no console se há erros JavaScript

### Filtros não estão sendo restaurados
1. Verificar se `restoreLoanFilters()` está sendo chamada
2. Verificar no console se há erros ao parsear o JSON
3. Verificar se os IDs dos elementos estão corretos

### Filtros estão sendo aplicados duas vezes
1. Certificar que `applyFiltersAndSort()` não está sendo chamada em duplicidade
2. Verificar se não há event listeners duplicados
