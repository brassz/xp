# 🟡 Coloração de Datas de Vencimento - Alterações Manuais

## 📋 Descrição

Sistema de destaque visual para datas de vencimento que foram alteradas manualmente nos empréstimos. Quando um usuário edita manualmente a data de vencimento de um empréstimo, essa data será exibida em **AMARELO** (cor destaque) na interface, facilitando a identificação de empréstimos com datas de vencimento customizadas.

## ✨ Funcionalidades

### 🎯 Destaque Visual Automático
- **Cor Amarela**: Datas de vencimento alteradas manualmente aparecem em amarelo brilhante
- **Ícone de Alerta**: Símbolo ⚠️ é exibido ao lado da data alterada
- **Tooltip Informativo**: Ao passar o mouse sobre a data, aparece a mensagem "Data de vencimento alterada manualmente"
- **Negrito**: As datas alteradas são exibidas em negrito para maior destaque

### 📊 Aplicação em Múltiplas Telas
O destaque visual é aplicado em:
- ✅ **Aba Empréstimos Ativos**: Lista principal de empréstimos
- ✅ **Aba Empréstimos Quitados**: Histórico de empréstimos pagos
- ✅ **Relatórios e Exportações**: Mantém o indicador visual

## 🔧 Implementação Técnica

### Banco de Dados
Novo campo adicionado à tabela `loans`:
```sql
due_date_manually_changed BOOLEAN DEFAULT FALSE
```

### Arquivos Modificados

1. **add-due-date-color-tracking.sql**
   - Script SQL para adicionar o campo de rastreamento ao banco de dados
   - Inclui índice para otimização de consultas

2. **app.js**
   - Função `editLoan()`: Armazena a data de vencimento original
   - Função `handleEditLoan()`: Detecta alterações e atualiza o campo
   - Função `renderLoansTable()`: Aplica cor amarela quando apropriado
   - Função `renderPaidLoansTable()`: Aplica cor amarela em empréstimos pagos

### Lógica de Detecção

```javascript
// Ao abrir o modal de edição
document.getElementById('editLoanDueDate')
    .setAttribute('data-original-due-date', loan.due_date);

// Ao salvar as alterações
const dueDateManuallyChanged = originalDueDate !== newDueDate;
```

## 🚀 Como Usar

### Para Usuários

1. **Editar um Empréstimo**
   - Acesse a aba "Empréstimos"
   - Clique no botão ✏️ (Editar) do empréstimo desejado
   - Modifique a data de vencimento
   - Clique em "Atualizar Empréstimo"

2. **Visualizar Datas Alteradas**
   - As datas alteradas aparecem em **AMARELO** com o símbolo ⚠️
   - Passe o mouse sobre a data para ver o tooltip explicativo
   - O destaque permanece mesmo após o empréstimo ser quitado

### Para Desenvolvedores

#### Aplicar o Script SQL
```bash
# Execute o script no Supabase
psql -h [seu-host] -d [seu-banco] -f add-due-date-color-tracking.sql
```

#### Estrutura do Campo
```javascript
loan.due_date_manually_changed  // boolean
// true:  Data foi alterada manualmente (exibir em amarelo)
// false: Data não foi alterada (exibir em cinza normal)
```

## 📝 Exemplos de Uso

### Caso 1: Empréstimo com Data Original
```
Cliente: João Silva
Data de Vencimento: 15/01/2024 (cinza, sem ícone)
```

### Caso 2: Empréstimo com Data Alterada
```
Cliente: Maria Santos
Data de Vencimento: 20/02/2024 ⚠️ (amarelo, negrito)
Tooltip: "Data de vencimento alterada manualmente"
```

## ⚠️ Observações Importantes

1. **Permanência do Destaque**
   - O destaque em amarelo é permanente
   - Persiste mesmo após o empréstimo ser quitado
   - Mantém histórico de alterações manuais

2. **Alterações Automáticas do Sistema**
   - Renovações automáticas NÃO marcam a data como alterada manualmente
   - Apenas alterações feitas pelo usuário no modal de edição são marcadas

3. **Mensagem de Confirmação**
   - Ao alterar a data manualmente, o sistema exibe:
   ```
   ⚠️ A data de vencimento foi alterada manualmente
      e será destacada em AMARELO na lista.
   ```

## 🎨 Estilos Aplicados

### Data Normal
```html
<td class="text-gray-300">15/01/2024</td>
```

### Data Alterada Manualmente
```html
<td class="text-yellow-400 font-bold" 
    title="Data de vencimento alterada manualmente">
    15/01/2024 ⚠️
</td>
```

## 🔍 Troubleshooting

### Problema: Data não aparece em amarelo
**Solução:**
1. Verifique se o script SQL foi executado
2. Confirme que o campo `due_date_manually_changed` existe
3. Recarregue a página (F5)

### Problema: Tooltip não aparece
**Solução:**
- O tooltip é nativo do HTML via atributo `title`
- Funciona automaticamente em navegadores modernos

## 📊 Benefícios

✅ **Transparência**: Fácil identificação de datas customizadas  
✅ **Rastreabilidade**: Histórico de alterações preservado  
✅ **UX Aprimorada**: Destaque visual claro e intuitivo  
✅ **Auditoria**: Facilita revisões e auditorias financeiras  
✅ **Sem Impacto**: Não afeta empréstimos existentes (campo opcional)  

## 📈 Estatísticas

O sistema permite facilmente identificar:
- Quantos empréstimos têm datas alteradas manualmente
- Padrões de alterações de datas
- Empréstimos que precisam atenção especial

## 🔐 Segurança

- ✅ O campo é atualizado apenas via aplicação
- ✅ Não há interface direta para alterar o campo booleano
- ✅ Alterações são rastreáveis via `updated_at`

## 📅 Data de Implementação

**Versão:** 1.0  
**Data:** 02/12/2025  
**Desenvolvedor:** Sistema Nexus Gestão Financeira  

## 🎯 Próximas Melhorias

- [ ] Log de histórico de alterações de data
- [ ] Relatório de empréstimos com datas alteradas
- [ ] Filtro para buscar apenas empréstimos com datas modificadas
- [ ] Dashboard mostrando estatísticas de alterações

---

## 📞 Suporte

Para dúvidas ou problemas, consulte a documentação principal do sistema ou entre em contato com o suporte técnico.
