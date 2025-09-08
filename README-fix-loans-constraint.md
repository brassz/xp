# Correção do Erro: loans_status_check Constraint

## Problema
Erro ao criar empréstimo: `new row for relation "loans" violates check constraint "loans_status_check"`

## Causa
A constraint de status na tabela `loans` pode estar configurada incorretamente ou com valores diferentes dos esperados pelo código.

## Solução

### 1. Execute o script de correção
Execute o arquivo `fix-loans-status-constraint.sql` no SQL Editor do Supabase para:
- Verificar a constraint atual
- Remover e recriar a constraint se necessário
- Validar os valores de status existentes

### 2. Valores de status permitidos
A constraint deve permitir apenas estes valores:
- `'active'` - Empréstimo ativo
- `'overdue'` - Empréstimo vencido
- `'paid'` - Empréstimo quitado
- `'partial_paid'` - Empréstimo parcialmente pago
- `'cancelled'` - Empréstimo cancelado

### 3. Melhorias implementadas no código
- ✅ Validação de campos obrigatórios no frontend
- ✅ Verificação de usuário logado
- ✅ Tratamento de erro mais específico
- ✅ Log detalhado para debugging

### 4. Como testar
1. Abra o console do navegador (F12)
2. Tente criar um empréstimo
3. Verifique os logs no console para dados detalhados
4. Se o erro persistir, execute o script SQL

### 5. Debug adicional
Se o problema continuar:
1. Verifique se há clientes cadastrados
2. Confirme se o usuário está logado
3. Verifique se todas as datas estão preenchidas
4. Execute o script SQL para verificar a constraint

## Arquivos modificados
- `app.js` - Melhorias na validação e tratamento de erro
- `fix-loans-status-constraint.sql` - Script para corrigir constraint
- `README-fix-loans-constraint.md` - Este arquivo de documentação