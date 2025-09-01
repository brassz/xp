# Contratos com Avalista - Nexus Gestão Financeira

## Visão Geral

Foi implementada a funcionalidade para incluir automaticamente os dados do avalista nos contratos de empréstimo quando o cliente possuir um avalista cadastrado no sistema.

## Funcionalidades Implementadas

### 1. Verificação Automática de Avalistas
- Ao gerar um contrato, o sistema verifica automaticamente se o cliente possui avalistas cadastrados
- Utiliza a função `loadClientGuarantors(clientId)` para buscar os avalistas do cliente

### 2. Inclusão dos Dados do Avalista no Contrato

#### Seção de Qualificação das Partes
- **AVALISTA**: Adicionada nova seção após os dados do mutuário
- Inclui informações completas:
  - Nome completo
  - CPF
  - RG (quando disponível)
  - Endereço (quando disponível)
  - Declaração de responsabilidade solidária

#### Exemplo de texto gerado:
```
AVALISTA: João Silva Santos, brasileiro, portador do CPF nº 123.456.789-10, 
RG nº 12.345.678-9, residente e domiciliado à Rua das Flores, 123, Centro, 
Franca/SP, que neste ato assume a responsabilidade solidária pelo pagamento da dívida.
```

### 3. Cláusula Específica sobre Avalista

#### Cláusula Quinta - Subitem 5.2
- Adicionada automaticamente quando há avalista
- Define a responsabilidade solidária do avalista
- Especifica que pode ser executado diretamente

#### Texto da cláusula:
```
5.2. O AVALISTA assume responsabilidade solidária pelo pagamento integral da dívida, 
juros, multa e demais encargos, podendo ser executado diretamente pelo MUTUANTE em 
caso de inadimplemento do MUTUÁRIO, independentemente de ordem de preferência ou 
benefício de ordem.
```

### 4. Seção de Assinaturas

#### Espaço para Assinatura do Avalista
- Adicionado automaticamente após a assinatura do mutuário
- Inclui linha para assinatura
- Nome completo do avalista
- Identificação como "Avalista"

#### Layout das assinaturas:
```
_____________________        _____________________
VALORUM                      [Nome do Cliente]
Mutuante                     Mutuário

_____________________
[Nome do Avalista]
Avalista
```

### 5. Melhorias no Nome do Arquivo
- Contratos com avalista recebem sufixo `_com_avalista` no nome do arquivo
- Exemplo: `Contrato_Maria_Silva_com_avalista_2024-01-15.pdf`

### 6. Mensagens Informativas
- Mensagem de sucesso diferenciada quando o contrato inclui avalista
- "Contrato gerado com sucesso! Inclui dados e assinatura do avalista."

## Como Funciona

### Processo Automático
1. **Geração do Contrato**: Usuário clica em "Gerar Contrato" para um empréstimo
2. **Verificação**: Sistema busca automaticamente avalistas do cliente
3. **Inclusão Condicional**: Se há avalistas, inclui:
   - Dados na qualificação das partes
   - Cláusula específica sobre responsabilidade
   - Espaço para assinatura
4. **Arquivo Diferenciado**: Nome do arquivo indica presença de avalista

### Suporte a Múltiplos Avalistas
- Sistema preparado para múltiplos avalistas
- Atualmente utiliza o primeiro avalista cadastrado
- Estrutura permite expansão futura para incluir todos os avalistas

## Aspectos Técnicos

### Modificações no Código
- **Arquivo**: `app.js`
- **Função**: `generateContract(loanId)`
- **Linhas modificadas**: ~4988-5186

### Dependências
- Função `loadClientGuarantors(clientId)` (já existente)
- Variável global `guarantors` (já existente)
- Sistema de geração PDF (jsPDF)

### Compatibilidade
- **Retrocompatível**: Contratos sem avalista continuam funcionando normalmente
- **Sem configuração adicional**: Funcionalidade ativa automaticamente
- **Baseado em dados existentes**: Utiliza tabela `guarantors` já implementada

## Validações e Segurança

### Verificações Implementadas
- Verifica se cliente possui avalistas antes de incluir dados
- Trata casos onde avalista não tem RG ou endereço cadastrados
- Verifica espaço disponível na página para assinaturas

### Tratamento de Erros
- Continua funcionando mesmo se houver erro ao carregar avalistas
- Mantém funcionalidade original para contratos sem avalista
- Log de erros para debug

## Casos de Uso

### 1. Cliente com Avalista
- ✅ Dados do avalista incluídos automaticamente
- ✅ Cláusula de responsabilidade solidária
- ✅ Espaço para assinatura do avalista
- ✅ Nome do arquivo indicativo

### 2. Cliente sem Avalista
- ✅ Contrato gerado normalmente
- ✅ Sem alterações no layout
- ✅ Funcionalidade mantida

### 3. Múltiplos Avalistas
- ✅ Utiliza o primeiro avalista cadastrado
- ⏳ Expansão futura para incluir todos os avalistas

## Benefícios

### 1. Automação Completa
- Elimina necessidade de edição manual dos contratos
- Reduz erros de digitação ou esquecimento

### 2. Conformidade Legal
- Inclui cláusulas apropriadas sobre responsabilidade solidária
- Garante que avalista assine o contrato

### 3. Organização
- Arquivos nomeados adequadamente
- Fácil identificação de contratos com avalista

### 4. Integração Perfeita
- Utiliza dados já cadastrados no sistema
- Não requer configuração adicional

## Melhorias Futuras

1. **Múltiplos Avalistas**: Incluir todos os avalistas cadastrados
2. **Configuração de Cláusulas**: Permitir personalização das cláusulas
3. **Relatório de Avalistas**: Relatório de contratos por avalista
4. **Validação de Dados**: Verificar completude dos dados antes de gerar contrato

## Suporte

### Verificação de Funcionamento
1. Cadastre um cliente com avalista
2. Crie um empréstimo para este cliente
3. Gere o contrato
4. Verifique se inclui dados e assinatura do avalista

### Troubleshooting
- **Avalista não aparece**: Verificar se está cadastrado corretamente
- **Erro na geração**: Verificar console do navegador
- **Layout quebrado**: Verificar se dados do avalista estão completos

### Arquivos Relacionados
- `app.js`: Código principal
- `setup-guarantors-table.sql`: Estrutura da tabela
- `README-avalistas.md`: Documentação do sistema de avalistas
- `index.html`: Interface do usuário

## Conclusão

A implementação garante que todos os contratos de empréstimo incluam automaticamente os dados do avalista quando aplicável, proporcionando maior segurança jurídica e automação completa do processo.