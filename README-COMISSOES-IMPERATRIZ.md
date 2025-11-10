# Sistema de Comissões - Imperatriz Cred

## 📊 Nova Configuração de Comissões

Foi implementado um sistema de comissões específico para a empresa **Imperatriz Cred**, com divisão 50/50 entre Vinicius e Alex.

## ✅ Alterações Realizadas

### 1. **HTML - Interface** (`index.html`)

#### Card de Comissão Alex
- Adicionado novo card `alexCommissionCard` (cor amarela)
- Card visível apenas para Imperatriz Cred
- Label: "Comissão Alex (50%)"

#### Tabela de Comissões
- Adicionada coluna `alex-column` para mostrar comissão do Alex
- Adicionada classe `douglas-column` para controlar visibilidade de Douglas
- Douglas fica oculto quando é Imperatriz Cred

### 2. **JavaScript - Lógica** (`app.js`)

#### Cálculo de Comissões (`calculateCommissionsFromPayments`)
- Detecta empresa Imperatriz com `isImperatriz = currentCompany === 'imperatriz'`
- **Imperatriz Cred:**
  - Vinicius: 50% (0.5)
  - Alex: 50% (0.5)
  - Douglas: 0%
  - Bruno: 0%
- Adicionado campo `alexCommission` nos detalhes de pagamento
- Adicionado `totalAlexCommission` no resumo

#### Interface de Comissões (`updateCommissionsSummary`)
- Atualiza valor da comissão de Alex
- Mostra/esconde cards baseado na empresa:
  - **Erechim**: Bruno + Vinicius + Douglas (33,3% cada)
  - **Imperatriz**: Vinicius + Alex (50% cada)
  - **Outras**: Vinicius (66,6%) + Douglas (33,3%)
- Atualiza labels com percentuais corretos

#### Tabela de Comissões (`renderCommissionsTable`)
- Mostra/esconde colunas baseado na empresa
- Renderiza coluna Alex em amarelo quando é Imperatriz
- Esconde coluna Douglas quando é Imperatriz
- Ajusta colspan dinamicamente

#### Inicialização (`initializeCommissionsSection`)
- Configura UI inicial ao carregar aba de comissões
- Define visibilidade de cards e colunas
- Atualiza labels com percentuais corretos

#### Geração de PDF
- **Resumo do PDF**: Mostra Vinicius (50%) e Alex (50%)
- **Tabela do PDF**: Colunas "Vinicius (50%)" e "Alex (50%)"
- **Cabeçalhos em novas páginas**: Atualizado para incluir caso Imperatriz
- **Valores detalhados**: Exibe comissão de Alex em vez de Douglas

## 📋 Divisão de Comissões por Empresa

| Empresa | Pessoa 1 | Pessoa 2 | Pessoa 3 | Total |
|---------|----------|----------|----------|-------|
| **NEXUS** | Vinicius (66,6%) | Douglas (33,3%) | - | 100% |
| **LITORAL CRED** | Vinicius (66,6%) | Douglas (33,3%) | - | 100% |
| **MOGIANA CRED** | Vinicius (66,6%) | Douglas (33,3%) | - | 100% |
| **ERECHIM** | Bruno (33,3%) | Vinicius (33,3%) | Douglas (33,3%) | 100% |
| **IMPERATRIZ CRED** | Vinicius (50%) | Alex (50%) | - | 100% |

## 🎨 Cores dos Cards

- **Total de Juros**: Azul
- **Bruno**: Laranja (apenas Erechim)
- **Alex**: Amarelo (apenas Imperatriz)
- **Vinicius**: Verde (todas as empresas)
- **Douglas**: Roxo (exceto Imperatriz)

## 🔍 Funcionamento

### Ao Carregar Aba de Comissões

1. Sistema detecta empresa atual (`currentCompany`)
2. Se for `'imperatriz'`:
   - Mostra card de Alex (amarelo)
   - Esconde card de Douglas
   - Atualiza label Vinicius para "50%"
   - Configura grid para 3 colunas (Total + Vinicius + Alex)

### Ao Calcular Comissões

1. Para cada pagamento:
   - Calcula base comissionável (juros pagos)
   - Divide 50% para Vinicius
   - Divide 50% para Alex
   - Douglas e Bruno ficam com 0

2. Exibe valores nos cards
3. Preenche tabela detalhada

### Ao Gerar PDF

1. **Resumo**: Mostra 2 linhas de comissão (Vinicius 50%, Alex 50%)
2. **Tabela**: 2 colunas de comissão (Vinicius e Alex)
3. **Layout**: Otimizado para 2 pessoas

## 📊 Exemplo de Cálculo

**Cenário**: Pagamento de R$ 1.000,00 com juros de R$ 200,00

### Base Comissionável
```
Juros pagos: R$ 200,00
```

### Divisão Imperatriz Cred
```
Vinicius (50%): R$ 100,00
Alex (50%):     R$ 100,00
Douglas:        R$ 0,00
Bruno:          R$ 0,00
```

### Divisão Outras Empresas (exceto Erechim)
```
Vinicius (66,6%): R$ 133,20
Douglas (33,3%):  R$ 66,60
Bruno:            R$ 0,00
Alex:             R$ 0,00
```

### Divisão Erechim
```
Bruno (33,3%):    R$ 66,67
Vinicius (33,3%): R$ 66,67
Douglas (33,3%):  R$ 66,67
Alex:             R$ 0,00
```

## ✅ Testes Realizados

- [x] Card Alex aparece apenas para Imperatriz
- [x] Coluna Alex aparece na tabela para Imperatriz
- [x] Coluna Douglas some para Imperatriz
- [x] Cálculo 50/50 funciona corretamente
- [x] Labels atualizam com percentuais corretos
- [x] PDF mostra comissões corretas
- [x] Outras empresas não são afetadas

## 🔧 Arquivos Modificados

1. **index.html**
   - Adicionado card `alexCommissionCard`
   - Adicionada coluna `alex-column` na tabela
   - Adicionada classe `douglas-column`

2. **app.js**
   - Função `calculateCommissionsFromPayments()` - Cálculo 50/50
   - Função `updateCommissionsSummary()` - Atualização de UI
   - Função `renderCommissionsTable()` - Renderização da tabela
   - Função `initializeCommissionsSection()` - Inicialização
   - Geração de PDF - 3 locais atualizados

## 📝 Observações

- O sistema mantém compatibilidade total com outras empresas
- Cada empresa continua com seu modelo de comissão independente
- A lógica é extensível para futuras empresas com modelos diferentes
- Todos os valores são calculados com precisão de 2 casas decimais

## 🚀 Como Usar

1. Faça login selecionando **IMPERATRIZ CRED**
2. Acesse a aba **Comissões**
3. Selecione o período desejado
4. Clique em **Calcular Comissões**
5. Visualize:
   - Card de Total de Juros
   - Card de Vinicius (50%) - Verde
   - Card de Alex (50%) - Amarelo
6. Para gerar PDF, clique em **Gerar PDF de Comissões**

---

**Data de Implementação:** 10/11/2025  
**Empresa:** Imperatriz Cred  
**Comissões:** Vinicius 50% + Alex 50%  
**Status:** ✅ Implementado e Testado
