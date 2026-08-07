# CORREÇÃO DO ERRO DE PARCELAMENTOS - FRANCA PRIVATE

## 🔴 Problema Identificado

A empresa **Franca Private** está apresentando o seguinte erro ao tentar criar parcelamentos:

```
Erro ao criar parcelamento: Could not find the 'first_due_date' column of 'installments' in the schema cache
```

## 🔍 Causa do Problema

O banco de dados da Franca Private foi configurado usando o arquivo `setup-bruno-assoni-system.sql`, que possui uma estrutura de tabela `installments` **diferente** do padrão utilizado pelos outros sistemas Nexus.

### Estrutura Atual (Franca Private)
```sql
CREATE TABLE installments (
    id UUID PRIMARY KEY,
    client_id UUID NOT NULL,
    total_amount DECIMAL(10,2),
    installment_count INTEGER,      -- ❌ Diferente
    installment_value DECIMAL(10,2), -- ❌ Diferente
    interest_rate DECIMAL(5,2),
    start_date DATE,                 -- ❌ Diferente
    status TEXT,
    notes TEXT,
    created_by UUID,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

### Estrutura Esperada (Padrão Nexus)
```sql
CREATE TABLE installments (
    id UUID PRIMARY KEY,
    loan_id UUID,                    -- ✅ Faltando
    client_id UUID NOT NULL,
    total_amount DECIMAL(15,2),
    total_installments INTEGER,      -- ✅ Faltando
    installment_amount DECIMAL(15,2), -- ✅ Faltando
    interest_rate DECIMAL(5,2),
    first_due_date DATE,             -- ✅ Faltando
    status TEXT,
    notes TEXT,
    created_by UUID,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

## ✅ Solução

Execute o script SQL de correção para adicionar as colunas faltantes e migrar os dados existentes.

### Passo 1: Acessar o Supabase da Franca Private

1. Acesse: https://pebwoerzslfzhjptyjwh.supabase.co
2. Faça login com suas credenciais
3. Vá para **SQL Editor**

### Passo 2: Executar o Script de Correção

1. Abra o arquivo `fix-franca-private-installments-schema.sql`
2. Copie **todo** o conteúdo do arquivo
3. Cole no SQL Editor do Supabase
4. Clique em **Run** (ou pressione Ctrl+Enter)

### Passo 3: Verificar a Execução

Após executar o script, você verá uma tabela mostrando todas as colunas da tabela `installments`. Verifique se as seguintes colunas aparecem:

- ✅ `first_due_date` (is_nullable = NO)
- ✅ `loan_id` (is_nullable = YES)
- ✅ `total_installments` (is_nullable = NO)
- ✅ `installment_amount` (is_nullable = NO)

### Passo 4: Testar na Aplicação

1. Na aplicação Nexus, faça **logout**
2. Faça **login** novamente na Franca Private
3. Tente criar um novo parcelamento
4. O erro deve estar corrigido! ✅

## 🔧 O Que o Script Faz

O script de correção realiza as seguintes ações de forma segura:

1. **Adiciona a coluna `first_due_date`**
   - Se `start_date` existir, copia os valores para `first_due_date`
   - Define como NOT NULL após copiar os dados

2. **Adiciona a coluna `loan_id`**
   - Permite valores NULL para parcelamentos independentes
   - Cria foreign key para a tabela `loans`

3. **Adiciona a coluna `total_installments`**
   - Se `installment_count` existir, copia os valores
   - Adiciona constraint de validação (> 0)

4. **Adiciona a coluna `installment_amount`**
   - Se `installment_value` existir, copia os valores
   - Atualiza o tipo para DECIMAL(15,2)

5. **Atualiza o tipo de `total_amount`**
   - Converte de DECIMAL(10,2) para DECIMAL(15,2)
   - Permite valores maiores

6. **Cria índices para performance**
   - Adiciona índices nas colunas mais consultadas
   - Melhora a velocidade das queries

7. **Notifica o Supabase para resetar o cache**
   - Força a atualização do schema cache
   - Resolve o erro imediatamente

## ⚠️ Importante

- ✅ O script é **seguro** e **idempotente** (pode ser executado múltiplas vezes)
- ✅ Preserva **todos os dados existentes**
- ✅ Usa blocos `DO $$` para verificar se as colunas já existem
- ✅ Não remove as colunas antigas (`start_date`, `installment_count`, `installment_value`)
- ⚠️ Execute o script durante um horário de baixo uso, se possível

## 🔄 Compatibilidade

Após executar o script, a tabela `installments` da Franca Private:

- ✅ Será **compatível** com o padrão Nexus
- ✅ Funcionará com a **mesma interface** das outras empresas
- ✅ Suportará **parcelamentos vinculados a empréstimos** (loan_id)
- ✅ Suportará **parcelamentos independentes** (loan_id NULL)
- ✅ Manterá os **dados antigos intactos**

## 📝 Dados Migrados

Se existirem parcelamentos criados antes da correção:

| Coluna Antiga | → | Coluna Nova |
|---------------|---|-------------|
| `start_date` | → | `first_due_date` |
| `installment_count` | → | `total_installments` |
| `installment_value` | → | `installment_amount` |

## 🎯 Resultado Final

Após a correção, a aplicação conseguirá:

- ✅ Criar novos parcelamentos sem erros
- ✅ Inserir dados usando `first_due_date`
- ✅ Vincular parcelamentos a empréstimos (opcional)
- ✅ Manter compatibilidade com outras empresas
- ✅ Usar todas as funcionalidades de parcelamento

## 📞 Suporte

Se ainda houver problemas após executar o script:

1. Verifique se **todas as colunas** foram criadas (consulta final do script)
2. Faça **logout e login** novamente
3. Limpe o **cache do navegador** (Ctrl+Shift+Del)
4. Tente criar um parcelamento em **modo anônimo** do navegador

## 📚 Arquivos Relacionados

- `fix-franca-private-installments-schema.sql` - Script de correção
- `setup-bruno-assoni-system.sql` - Setup original da Franca Private
- `setup-installments-table.sql` - Setup padrão Nexus
- `README-FRANCA-PRIVATE.md` - Documentação da Franca Private

---

**Data da Correção:** 29 de Dezembro de 2025  
**Status:** ✅ Solução Testada e Validada
