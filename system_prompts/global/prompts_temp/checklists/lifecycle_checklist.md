# 📋 LIFECYCLE CHECKLIST - Rastreio de Evolução por Prompt

**Versão:** 1.0.0
**Data:** 28 de Novembro de 2025
**Status:** Ativo

---

## 🎯 Objetivo

Rastrear a evolução de cada prompt através dos estágios de desenvolvimento, garantindo qualidade, consistência e rastreabilidade.

---

## 📊 Estágios do Ciclo de Vida

### Stage 00: Coleta (`stage_00_coleta/`)

**Propósito:** Ingestão de dados brutos sem organização

**Checklist:**

- [ ] Dados brutos coletados
- [ ] Origem documentada
- [ ] Timestamp registrado
- [ ] Formato bruto preservado
- [ ] Metadados básicos incluídos

**Critérios de Promoção:**

- Dados coletados e validados
- Origem identificada
- Pronto para interpretação

---

### Stage 01: Interpretação (`stage_01_interpretacao/`)

**Propósito:** Revisão, síntese e contextualização

**Checklist:**

- [ ] Dados brutos revisados
- [ ] Informações chave extraídas
- [ ] Contexto adicionado
- [ ] Redundâncias removidas
- [ ] Estrutura inicial definida
- [ ] Síntese realizada

**Critérios de Promoção:**

- Informações organizadas semanticamente
- Contexto claro e completo
- Pronto para estruturação

---

### Stage 02: Estrutura (`stage_02_estrutura/`)

**Propósito:** Formatação padronizada (md, json, yaml)

**Checklist:**

- [ ] Formato markdown aplicado
- [ ] Estrutura hierárquica definida
- [ ] Metadados estruturados
- [ ] Versão documentada
- [ ] Formato JSON/YAML gerado (se aplicável)
- [ ] Compatibilidade com LLMs validada

**Critérios de Promoção:**

- Formato padronizado
- Estrutura clara e consistente
- Pronto para refinamento

---

### Stage 03: Refinamento (`stage_03_refinamento/`)

**Propósito:** Precisão, ajuste, validação

**Checklist:**

- [ ] Precisão técnica verificada
- [ ] Estilo consistente aplicado
- [ ] Função reduzida ao objetivo
- [ ] Testes básicos realizados
- [ ] Feedback incorporado
- [ ] Validação cruzada realizada

**Critérios de Promoção:**

- Precisão validada
- Estilo finalizado
- Pronto para pré-release

---

### Stage 04: Pré-Release (`stage_04_pre_release/`)

**Propósito:** Versão final antes de migrar para `/prompts`

**Checklist:**

- [ ] Avaliação final realizada
- [ ] Testes completos executados
- [ ] Documentação completa
- [ ] Compatibilidade validada
- [ ] Performance avaliada
- [ ] Aprovação para produção

**Critérios de Promoção:**

- Todos os testes passaram
- Documentação completa
- Aprovado para produção
- Pronto para migração

---

## 🔄 Processo de Promoção

### Regras Gerais

1. **Não pular estágios:** Cada prompt deve passar por todos os estágios
2. **Validação obrigatória:** Cada estágio requer validação antes de avançar
3. **Documentação:** Cada promoção deve ser documentada
4. **Versionamento:** Cada estágio deve ter versão documentada

### Promoção para Produção

**Requisitos:**

- [ ] Passou por todos os 5 estágios
- [ ] Checklist completo validado
- [ ] Avaliação LLM realizada (`llm_eval_matrix.md`)
- [ ] Documentação completa
- [ ] Testes em múltiplos contextos
- [ ] Aprovação final

**Processo:**

1. Validar checklist completo
2. Executar avaliação LLM
3. Revisar documentação
4. Aprovar para produção
5. Migrar para `/prompts` ou `/global`

---

## 📝 Template de Rastreamento

Para cada prompt, criar arquivo de rastreamento:

```markdown
# Rastreamento: [NOME_DO_PROMPT]

## Informações Básicas
- **ID:** [UUID ou identificador único]
- **Criado em:** [data]
- **Autor:** [nome]
- **Versão Atual:** [versão]

## Histórico de Estágios

### Stage 00: Coleta
- **Data:** [data]
- **Status:** ✅ Completo
- **Notas:** [notas]

### Stage 01: Interpretação
- **Data:** [data]
- **Status:** ✅ Completo
- **Notas:** [notas]

### Stage 02: Estrutura
- **Data:** [data]
- **Status:** ✅ Completo
- **Notas:** [notas]

### Stage 03: Refinamento
- **Data:** [data]
- **Status:** ✅ Completo
- **Notas:** [notas]

### Stage 04: Pré-Release
- **Data:** [data]
- **Status:** ✅ Completo
- **Notas:** [notas]

## Promoção para Produção
- **Data:** [data]
- **Aprovado por:** [nome]
- **Localização Final:** [caminho]
```

---

**Versão:** 1.0.0
**Última Atualização:** 28 de Novembro de 2025
**Status:** Ativo

