# Correção: Renovação de Empréstimos Semanais

## Problema Identificado

Na aba de empréstimos, no formato semanal, ao chegar na quarta semana e o empréstimo renovar automaticamente (quando o cliente paga apenas os juros), a data de vencimento do cronograma semanal não estava atualizando corretamente. 

**Comportamento anterior:**
- Todas as renovações adicionavam 1 mês à data de vencimento
- Empréstimos semanais ficavam com datas incorretas após renovação

## Solução Implementada

### 1. Adição do Campo `loan_type`

**Arquivo:** `add-weekly-loan-type.sql`
```sql
-- Adicionar coluna para identificar o tipo de empréstimo
ALTER TABLE loans 
ADD COLUMN IF NOT EXISTS loan_type TEXT DEFAULT 'monthly' CHECK (loan_type IN ('weekly', 'monthly'));
```

### 2. Correção da Lógica de Renovação

**Arquivo:** `app.js` (linhas 3262-3270)
```javascript
// Verificar se é empréstimo semanal ou mensal
if (loan.loan_type === 'weekly') {
    // Para empréstimos semanais: adicionar 4 semanas (28 dias)
    newDueDate = new Date(currentDueDate);
    newDueDate.setDate(currentDueDate.getDate() + 28);
} else {
    // Para empréstimos mensais: adicionar 1 mês
    newDueDate = new Date(currentDueDate.getFullYear(), currentDueDate.getMonth() + 1, currentDueDate.getDate());
}
```

### 3. Interface do Usuário

**Formulários atualizados:**
- Formulário de criação de empréstimo: campo "Tipo de Empréstimo" (Mensal/Semanal)
- Formulário de edição de empréstimo: campo "Tipo de Empréstimo"
- Tabela de empréstimos: nova coluna "Tipo" com badges coloridos

### 4. Exemplo de Funcionamento

**Cronograma Semanal ANTES da renovação:**
```
📅 Semana 1 - Pago: R$ 75.00 (04/11/2025)
📅 Semana 2 - Pago: R$ 75.00 (11/11/2025)
📅 Semana 3 - Pago: R$ 75.00 (18/11/2025)
📅 Semana 4 - Pago (Apenas juros): R$ 1075.00 (25/11/2025)
```

**Cronograma Semanal APÓS a renovação:**
```
📅 Semana 1: R$ 75.00 (23/12/2025)  ← +4 semanas de 25/11/2025
📅 Semana 2: R$ 75.00 (30/12/2025)
📅 Semana 3: R$ 75.00 (06/01/2026)
📅 Semana 4: R$ 1075.00 (13/01/2026)
```

## Arquivos Modificados

1. **`add-weekly-loan-type.sql`** - Script para adicionar campo de tipo de empréstimo
2. **`app.js`** - Lógica de renovação corrigida e interface atualizada
3. **`index.html`** - Formulários e tabelas atualizadas
4. **`test-weekly-renewal.js`** - Script de teste (pode ser removido após validação)

## Como Aplicar

1. **Execute o script SQL:**
   ```sql
   -- Executar no banco de dados
   \i add-weekly-loan-type.sql
   ```

2. **Atualize empréstimos existentes:**
   - Empréstimos existentes serão marcados como "mensal" por padrão
   - Para empréstimos que devem ser semanais, edite-os e altere o tipo

3. **Teste a funcionalidade:**
   ```bash
   node test-weekly-renewal.js
   ```

## Validação

✅ **Teste automatizado passou:**
- Empréstimos semanais: +28 dias (4 semanas)
- Empréstimos mensais: +1 mês
- Cronograma semanal: datas corretas após renovação

## Observações

- Empréstimos existentes mantêm comportamento atual (mensal)
- Novos empréstimos podem ser criados como semanais ou mensais
- A interface visual diferencia os tipos com badges coloridos
- A lógica é retrocompatível com empréstimos existentes