# Guia Completo - ChatLLM AI Super Assistant

- **Versão:** 1.0.0
- **Última atualização:** 2025-12-02
- **Componente:** ChatLLM AI Super Assistant (Abacus AI)

## 1. Visão Geral

O **ChatLLM AI Super Assistant** é a plataforma agregadora do Abacus AI, funcionando como uma **"caixa preta das inteligências artificiais"** que unifica o acesso a múltiplos Modelos de Linguagem Grande (LLMs) em uma única interface.

### 1.1. Características Principais

- **Acesso Multi-LLM**: Até 22 LLMs diferentes disponíveis
- **Roteamento Inteligente**: Sistema Houter seleciona automaticamente o melhor LLM
- **Créditos Mensais**: 2.000.000 pontos de computação por mês
- **Custo**: USD $10/mês
- **Interface Unificada**: Uma única API para todos os LLMs

---

## 2. LLMs Disponíveis

### 2.1. LLMs Principais

| LLM | Versão | Melhor Para |
|-----|--------|-------------|
| **GPT-4.1** | Latest | Tarefas gerais, código, análise |
| **Grok 4** | Latest | Pesquisa, análise de dados |
| **Gemini 2.5 Pro** | Latest | Multimodal, análise de imagens |
| **Claude Pro** | Latest | Análise profunda, ética |
| **Perplexity Pro** | Latest | Pesquisa web, fatos atualizados |
| **Deepseek** | Latest | Código, matemática |

### 2.2. Lista Completa (22 LLMs)

Além dos principais, o ChatLLM oferece acesso a mais 16 LLMs adicionais, incluindo modelos especializados para diferentes tarefas.

---

## 3. Roteamento Inteligente (Houter)

### 3.1. Como Funciona

O sistema **Houter (LLM Router)** analisa cada solicitação e seleciona automaticamente o LLM mais adequado baseado em:

- **Tipo de tarefa**: Código, pesquisa, análise, etc.
- **Complexidade**: Tarefas simples vs. complexas
- **Contexto**: Tipo de dados e requisitos
- **Performance**: Tempo de resposta e qualidade esperada

### 3.2. Uso do Roteamento Automático

**Opção 1: Roteamento Automático (Recomendado)**

```bash
curl -X POST "https://api.abacus.ai/v1/chatllm/chat" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Analise este código Python e sugira melhorias",
    "model": "auto"
  }'
```

**Opção 2: Seleção Manual**

```bash
curl -X POST "https://api.abacus.ai/v1/chatllm/chat" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Analise este código Python e sugira melhorias",
    "model": "gpt-4.1"
  }'
```

---

## 4. Casos de Uso

### 4.1. Geração de Código

```bash
curl -X POST "https://api.abacus.ai/v1/chatllm/chat" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Crie uma função Python que calcula o fibonacci até n termos",
    "model": "auto",
    "format": "code"
  }'
```

### 4.2. Análise de Documentos

```bash
curl -X POST "https://api.abacus.ai/v1/chatllm/chat" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Resuma este documento e extraia os pontos principais",
    "context": "<conteúdo do documento>",
    "model": "claude-pro"
  }'
```

### 4.3. Tradução

```bash
curl -X POST "https://api.abacus.ai/v1/chatllm/chat" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Traduza para português: Hello, how are you?",
    "model": "auto"
  }'
```

### 4.4. Pesquisa e Análise

```bash
curl -X POST "https://api.abacus.ai/v1/chatllm/chat" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Pesquise sobre as últimas tendências de IA em 2025",
    "model": "perplexity-pro",
    "web_search": true
  }'
```

---

## 5. Gerenciamento de Créditos

### 5.1. Consumo de Créditos

Diferentes tipos de tarefas consomem diferentes quantidades de créditos:

| Tipo de Tarefa | Créditos Aproximados |
|----------------|---------------------|
| Chat simples | 1.000 - 5.000 |
| Geração de código | 5.000 - 20.000 |
| Análise profunda | 10.000 - 50.000 |
| Geração de imagens | 50.000 - 200.000 |
| Geração de vídeos | 200.000 - 1.000.000 |

### 5.2. Monitoramento

```bash
# Verificar créditos disponíveis
curl -X GET "https://api.abacus.ai/v1/account/credits" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}"

# Ver histórico de uso
curl -X GET "https://api.abacus.ai/v1/account/usage" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}"
```

### 5.3. Alertas

Configure alertas quando os créditos estiverem baixos:

```bash
# Script de monitoramento (já criado no setup)
~/Dotfiles/scripts/abacus/monitor-credits.sh 100000
```

---

## 6. Boas Práticas

### 6.1. Prompting Eficiente

✅ **Bom:**
```
"Analise este código Python e sugira melhorias de performance,
focando em otimização de loops e uso de memória.
Código: [código aqui]"
```

❌ **Ruim:**
```
"melhore isso"
```

### 6.2. Escolha de Modelo

- **Use "auto"** para a maioria das tarefas (deixe o sistema escolher)
- **Especifique manualmente** apenas quando souber exatamente qual modelo precisa
- **Teste diferentes modelos** para encontrar o melhor para sua tarefa específica

### 6.3. Otimização de Créditos

- **Seja específico** nos prompts para evitar múltiplas tentativas
- **Use contexto** para reduzir necessidade de explicações
- **Cache resultados** quando possível
- **Monitore uso** regularmente

---

## 7. Integração com Scripts

### 7.1. Função Helper para Bash

```bash
abacus_chat() {
    local prompt="$1"
    local model="${2:-auto}"

    curl -s -X POST "https://api.abacus.ai/v1/chatllm/chat" \
      -H "Authorization: Bearer ${ABACUS_API_KEY}" \
      -H "Content-Type: application/json" \
      -d "{
        \"prompt\": \"$prompt\",
        \"model\": \"$model\"
      }" | jq -r '.response // .content // .text'
}

# Uso
result=$(abacus_chat "Traduza 'hello' para português")
echo "$result"
```

### 7.2. Integração com Pipelines

```bash
# Processar arquivo e enviar para ChatLLM
cat document.txt | while read line; do
    abacus_chat "Analise esta linha: $line"
done
```

---

## 8. Troubleshooting

### 8.1. Erro de Autenticação

```bash
# Verificar se a API Key está definida
echo "${ABACUS_API_KEY:0:20}..."

# Testar autenticação
curl -X GET "https://api.abacus.ai/v1/account/info" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}"
```

### 8.2. Erro de Créditos Insuficientes

- Verificar créditos disponíveis
- Considerar upgrade de plano
- Otimizar uso de créditos

### 8.3. Respostas Lentas

- Verificar qual LLM está sendo usado
- Considerar usar um modelo mais rápido
- Verificar conectividade de rede

---

## 9. Recursos Adicionais

- **Documentação Oficial**: https://docs.abacus.ai/chatllm
- **API Reference**: https://docs.abacus.ai/api/chatllm
- **Prompting Tips**: https://docs.abacus.ai/prompting-tips
- **FAQ**: https://docs.abacus.ai/faq

---

**Última atualização:** 2025-12-02
**Versão:** 1.0.0











