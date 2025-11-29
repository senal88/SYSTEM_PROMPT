# 📊 LLM EVAL MATRIX - Avaliação de Resposta Cross-Model

**Versão:** 1.0.0
**Data:** 28 de Novembro de 2025
**Status:** Ativo

---

## 🎯 Objetivo

Avaliar a qualidade e consistência de prompts através de múltiplos modelos LLM, garantindo interpretação universal e resultados consistentes.

---

## 📋 Matriz de Avaliação

### Critérios de Avaliação

| Critério | Descrição | Peso |
|----------|-----------|------|
| **Precisão** | Resposta correta e técnica | 25% |
| **Completude** | Todas as informações solicitadas | 20% |
| **Clareza** | Linguagem clara e compreensível | 15% |
| **Consistência** | Mesmo prompt produz resultados similares | 20% |
| **Relevância** | Resposta relevante ao contexto | 10% |
| **Formato** | Segue formato solicitado | 10% |

### Escala de Pontuação

- **5 - Excelente:** Atende completamente o critério
- **4 - Muito Bom:** Atende bem o critério com pequenas ressalvas
- **3 - Bom:** Atende o critério de forma satisfatória
- **2 - Regular:** Atende parcialmente o critério
- **1 - Insuficiente:** Não atende o critério adequadamente

---

## 🔍 Modelos para Teste

### CLI / Terminal
- [ ] Shell scripts (bash/zsh)
- [ ] MCP agents
- [ ] Terminal automation

### IDE Extensions
- [ ] Cursor 2.x
- [ ] VSCode Copilot
- [ ] JetBrains AI
- [ ] Raycast AI

### Offline LLMs
- [ ] Ollama (modelos locais)
- [ ] LM Studio
- [ ] llama.cpp
- [ ] GPTQ models

### Web Platforms
- [ ] ChatGPT Plus 5.1
- [ ] Claude Code (Sonnet/Opus)
- [ ] Gemini Pro
- [ ] Perplexity Pro

### Desktop LLMs
- [ ] Aplicativos macOS
- [ ] Aplicativos Windows
- [ ] Aplicativos Linux

### Multi-Agent
- [ ] Coordenação entre modelos
- [ ] Pipeline de agentes
- [ ] Orquestração

---

## 📊 Template de Avaliação

```markdown
# Avaliação: [NOME_DO_PROMPT]

## Informações
- **Prompt ID:** [ID]
- **Versão:** [versão]
- **Data:** [data]
- **Avaliador:** [nome]

## Testes por Modelo

### [MODELO_1]
- **Precisão:** [1-5] - [comentários]
- **Completude:** [1-5] - [comentários]
- **Clareza:** [1-5] - [comentários]
- **Consistência:** [1-5] - [comentários]
- **Relevância:** [1-5] - [comentários]
- **Formato:** [1-5] - [comentários]
- **Pontuação Total:** [X/30]
- **Notas:** [observações]

### [MODELO_2]
[...]

## Análise Comparativa

### Pontos Fortes
- [lista de pontos fortes]

### Pontos de Melhoria
- [lista de pontos de melhoria]

### Inconsistências Identificadas
- [lista de inconsistências]

## Recomendações
- [recomendações específicas]

## Decisão
- [ ] Aprovado para produção
- [ ] Requer refinamento
- [ ] Requer revisão completa
```

---

## 🔄 Processo de Avaliação

### 1. Preparação

- [ ] Prompt no estágio 04 (pré-release)
- [ ] Checklist de lifecycle completo
- [ ] Ambiente de teste configurado
- [ ] Modelos selecionados

### 2. Execução

- [ ] Testar em cada modelo selecionado
- [ ] Documentar resultados
- [ ] Comparar respostas
- [ ] Identificar padrões

### 3. Análise

- [ ] Calcular pontuações
- [ ] Identificar inconsistências
- [ ] Analisar pontos fortes/fracos
- [ ] Gerar recomendações

### 4. Decisão

- [ ] Aprovar para produção
- [ ] Solicitar refinamento
- [ ] Documentar decisão

---

## 📈 Métricas de Sucesso

### Critérios de Aprovação

- **Pontuação Média:** ≥ 4.0 (Muito Bom)
- **Consistência:** Desvio padrão ≤ 0.5
- **Cobertura:** Testado em ≥ 3 categorias diferentes
- **Sem Falhas Críticas:** Nenhum critério com pontuação < 2

### Níveis de Qualidade

- **Excelente:** Média ≥ 4.5, consistência alta
- **Muito Bom:** Média ≥ 4.0, consistência boa
- **Bom:** Média ≥ 3.5, consistência aceitável
- **Requer Melhoria:** Média < 3.5 ou inconsistências significativas

---

## 🔗 Integração com Lifecycle

Esta avaliação deve ser realizada:

1. **Antes da promoção para produção**
2. **Após refinamentos significativos**
3. **Periodicamente para prompts em produção**

---

**Versão:** 1.0.0
**Última Atualização:** 28 de Novembro de 2025
**Status:** Ativo

