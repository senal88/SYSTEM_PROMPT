# Guia de Setup – Abacus AI (ChatLLM & Deep Agent)

- **Versão:** 1.0.0
- **Última atualização:** 2025-12-02
- **Autor:** Sistema de Automação Completa

## 1. Visão Geral

O **Abacus AI** é uma plataforma completa de inteligência artificial que oferece duas funcionalidades principais:

1. **ChatLLM AI Super Assistant**: Plataforma agregadora que unifica acesso a múltiplos Modelos de Linguagem Grande (LLMs) com roteamento inteligente
2. **Deep Agent**: Agente autônomo avançado capaz de executar tarefas complexas, gerar sistemas completos e automatizar fluxos de trabalho

Este guia detalha como configurar o Abacus AI no ecossistema `system_prompts/global`, integrando-o de forma segura com 1Password e preparando-o para uso em desenvolvimento e automação.

---

## 2. Arquitetura da Plataforma

### 2.1. ChatLLM AI Super Assistant

O ChatLLM é a **"caixa preta das inteligências artificiais"**, funcionando como uma plataforma agregadora que:

- **Acesso Multi-LLM**: Oferece acesso a até **22 LLMs diferentes**, incluindo:
  - GPT-4.1
  - Grok 4
  - Gemini 2.5 Pro
  - Claude Pro
  - Perplexity Pro
  - Deepseek
  - E mais 16 outros modelos

- **Roteamento Inteligente**: Utiliza um sistema **Houter (LLM Router)** que seleciona automaticamente o LLM mais adequado para cada tarefa específica

- **Créditos de Computação**:
  - **2.000.000 (2M) pontos** de computação por mês
  - Monitoramento de consumo em tempo real
  - Tarefas intensivas (vídeo, imagens) consomem créditos rapidamente

- **Custo**: USD $10 por mês

### 2.2. Deep Agent

O Deep Agent é o **"ouro"** do Abacus AI, um agente autônomo que:

- **Fraciona tarefas complexas** em subtarefas menores
- **Executa automaticamente** cada subtarefa
- **Integra múltiplas ferramentas** e APIs
- **Gera sistemas completos** a partir de prompts únicos

#### Funcionalidades Principais:

| Funcionalidade | Descrição | Tecnologias |
|----------------|-----------|-------------|
| **Geração de Websites e Software** | Cria sites e aplicativos completos, incluindo SaaS com backend funcional | Prisma, Connect GS, PostgreSQL |
| **Fluxos de Trabalho Automatizados** | Automatiza processos de negócios, previsões, chatbots personalizados | n8n, APIs customizadas |
| **Pesquisa Aprofundada** | Navegação web ao vivo, scraping, análise de dados e vídeos | Web scraping, análise de mídia |
| **Criação de Mídia** | Geração de vídeos, imagens (Dalle, Flux), apresentações, relatórios | Dalle, Flux, PowerPoint |
| **Codificação** | Geração de código e sistemas completos | CodeLLM (substituição para Cursor) |

---

## 3. Pré-requisitos

1. **Conta Abacus AI**: Acesso à plataforma Abacus AI (https://abacus.ai)
2. **Chave de API**: Uma chave de API para autenticar interações com a plataforma
3. **1Password CLI**: O 1Password CLI (`op`) é obrigatório para gerenciamento seguro das credenciais
4. **Python SDK (Opcional)**: Para desenvolvedores que desejam usar o SDK Python
5. **Node.js (Opcional)**: Para integrações via API REST

---

## 4. Configuração de Segurança (Credenciais)

A segurança é primordial. As credenciais do Abacus AI **NUNCA** devem ser expostas em texto plano.

### 4.1. Salvar Credenciais no 1Password

1. **Criar Item para API Key:**
   - Abra o 1Password
   - Crie um novo item do tipo "Chave de API"
   - Nomeie-o como `Abacus-AI-API-Key`
   - Salve a chave de API no campo `credential`
   - Adicione a tag `api-key` e `abacus`
   - Selecione o vault `1p_macos` (ou o vault apropriado)

2. **Criar Item para Conta:**
   - Crie um novo item do tipo "Conta"
   - Nomeie-o como `Abacus-AI-Account`
   - Adicione o email da conta no campo `email`
   - Adicione a senha se necessário
   - Adicione a tag `abacus` e `account`
   - Selecione o vault `1p_macos`

### 4.2. Exportação via Variável de Ambiente

O `~/.zshrc` (no macOS) ou `~/.bashrc` (na VPS) deve ser configurado para exportar a chave de API.

**Método Preferencial (1Password):**

```bash
# Carregar API Key do 1Password
export ABACUS_API_KEY=$(op read "op://1p_macos/Abacus-AI-API-Key/credential")

# Carregar email da conta (se necessário)
export ABACUS_ACCOUNT_EMAIL=$(op read "op://1p_macos/Abacus-AI-Account/email")
```

**Script Automatizado:**

Crie ou atualize o script `~/Dotfiles/scripts/load_ai_keys.sh`:

```bash
#!/bin/bash
# Carregar credenciais do Abacus AI do 1Password

if command -v op >/dev/null 2>&1; then
    # Verificar se está autenticado
    if op whoami >/dev/null 2>&1; then
        export ABACUS_API_KEY=$(op read "op://1p_macos/Abacus-AI-API-Key/credential" 2>/dev/null)
        export ABACUS_ACCOUNT_EMAIL=$(op read "op://1p_macos/Abacus-AI-Account/email" 2>/dev/null)

        if [ -n "$ABACUS_API_KEY" ]; then
            echo "✅ Abacus AI API Key carregada"
        else
            echo "⚠️  Abacus AI API Key não encontrada no 1Password"
        fi
    else
        echo "⚠️  1Password não autenticado. Execute: op signin"
    fi
else
    echo "⚠️  1Password CLI não instalado"
fi
```

### 4.3. Verificar Configuração

```bash
# Testar se a chave está acessível
op read "op://1p_macos/Abacus-AI-API-Key/credential" > /dev/null && echo "✅ Chave acessível"

# Verificar variável de ambiente
if [ -n "$ABACUS_API_KEY" ]; then
    echo "✅ Variável ABACUS_API_KEY carregada"
else
    echo "❌ Variável não definida"
fi
```

---

## 5. Instalação e Configuração

### 5.1. Python SDK (Opcional)

Para desenvolvedores que desejam usar o SDK Python:

```bash
# Instalar via pip
pip install abacus-ai-sdk

# Ou via pipx (recomendado para isolamento)
pipx install abacus-ai-sdk
```

**Exemplo de Uso:**

```python
from abacus_ai import AbacusClient

# Inicializar cliente
client = AbacusClient(api_key=os.getenv("ABACUS_API_KEY"))

# Usar ChatLLM
response = client.chatllm.chat(
    prompt="Explique o que é machine learning",
    model="auto"  # Roteamento automático
)

# Usar Deep Agent
task = client.deep_agent.create_task(
    objective="Criar um SaaS completo para gerenciamento de tarefas",
    context="Stack: React, Node.js, PostgreSQL"
)
```

### 5.2. API REST (Alternativa)

Para integrações via API REST:

```bash
# Exemplo de requisição via curl
curl -X POST "https://api.abacus.ai/v1/chatllm/chat" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Explique o que é machine learning",
    "model": "auto"
  }'
```

### 5.3. Configuração no Cursor/VSCode

Para usar o Abacus AI diretamente nas IDEs:

1. **Cursor 2.1:**
   - Adicione a configuração no `.cursorrules` ou `settings.json`
   - Configure a extensão se disponível

2. **VS Code:**
   - Instale extensão do Abacus AI (se disponível)
   - Configure variáveis de ambiente no workspace

---

## 6. Padrões de Uso

### 6.1. ChatLLM - Uso Básico

**Prompting Simples:**

```bash
# Via API REST
curl -X POST "https://api.abacus.ai/v1/chatllm/chat" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Traduza 'hello world' para português",
    "model": "gpt-4.1"
  }'
```

**Roteamento Automático:**

```bash
# Deixar o sistema escolher o melhor LLM
curl -X POST "https://api.abacus.ai/v1/chatllm/chat" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Analise este código e sugira melhorias",
    "model": "auto"
  }'
```

### 6.2. Deep Agent - Tarefas Complexas

**Geração de Website Completo:**

```bash
curl -X POST "https://api.abacus.ai/v1/deep-agent/create" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "objective": "Criar um site de portfólio pessoal com blog",
    "requirements": {
      "stack": ["Next.js", "TypeScript", "Tailwind CSS"],
      "features": ["Blog", "Portfolio", "Contact Form"],
      "database": "PostgreSQL"
    }
  }'
```

**Automação de Workflow:**

```bash
curl -X POST "https://api.abacus.ai/v1/deep-agent/workflow" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "workflow_name": "Daily News Summary",
    "schedule": "daily",
    "tasks": [
      "Buscar notícias sobre IA",
      "Resumir principais tópicos",
      "Enviar email com resumo"
    ]
  }'
```

**Pesquisa Aprofundada:**

```bash
curl -X POST "https://api.abacus.ai/v1/deep-agent/research" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "topic": "Tendências de IA em 2025",
    "depth": "deep",
    "sources": ["web", "academic", "news"],
    "output_format": "markdown"
  }'
```

### 6.3. Geração de Mídia

**Geração de Imagens:**

```bash
curl -X POST "https://api.abacus.ai/v1/deep-agent/generate-image" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Um robô futurista em uma cidade cyberpunk",
    "model": "dalle",
    "size": "1024x1024"
  }'
```

**Geração de Vídeos:**

```bash
curl -X POST "https://api.abacus.ai/v1/deep-agent/generate-video" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Um tutorial de 2 minutos sobre machine learning",
    "duration": 120,
    "style": "educational"
  }'
```

---

## 7. Integração com o Ecossistema

### 7.1. Integração com 1Password

O Abacus AI está totalmente integrado com o 1Password para gerenciamento seguro de credenciais:

- ✅ API Key armazenada no 1Password
- ✅ Carregamento automático via scripts
- ✅ Nenhuma credencial em texto plano

### 7.2. Integração com GitHub Actions

Para usar o Abacus AI em workflows do GitHub Actions:

```yaml
name: Abacus AI Workflow

on:
  workflow_dispatch:

jobs:
  abacus-task:
    runs-on: ubuntu-latest
    steps:
      - name: Setup 1Password CLI
        uses: 1password/load-secrets-action@v1
        with:
          op-credentials: ${{ secrets.OP_SERVICE_ACCOUNT_TOKEN }}

      - name: Run Deep Agent Task
        env:
          ABACUS_API_KEY: ${{ secrets.ABACUS_API_KEY }}
        run: |
          # Executar tarefa do Deep Agent
          curl -X POST "https://api.abacus.ai/v1/deep-agent/create" \
            -H "Authorization: Bearer ${ABACUS_API_KEY}" \
            -H "Content-Type: application/json" \
            -d '{"objective": "Analisar código e gerar documentação"}'
```

### 7.3. Integração com n8n

O Deep Agent pode ser integrado com n8n para automações complexas:

1. **Criar nó HTTP Request** no n8n
2. **Configurar endpoint** da API do Abacus AI
3. **Usar credenciais** do 1Password Connect
4. **Automatizar tarefas** recorrentes

---

## 8. Monitoramento de Créditos

### 8.1. Verificar Créditos Disponíveis

```bash
curl -X GET "https://api.abacus.ai/v1/account/credits" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}"
```

### 8.2. Script de Monitoramento

Crie um script para monitorar créditos:

```bash
#!/bin/bash
# ~/Dotfiles/scripts/monitor-abacus-credits.sh

source ~/Dotfiles/scripts/load_ai_keys.sh

CREDITS=$(curl -s -X GET "https://api.abacus.ai/v1/account/credits" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}" | jq -r '.credits')

THRESHOLD=100000

if [ "$CREDITS" -lt "$THRESHOLD" ]; then
    echo "⚠️  Créditos Abacus AI abaixo do threshold: $CREDITS"
    # Enviar notificação (email, Slack, etc.)
else
    echo "✅ Créditos Abacus AI: $CREDITS"
fi
```

---

## 9. Boas Práticas

### 9.1. Prompting Eficiente

- **Seja Específico**: Prompts vagos geram resultados ruins
- **Use Contexto**: Forneça contexto suficiente para o Deep Agent
- **Estruture Tarefas**: Para tarefas complexas, quebre em subtarefas menores
- **Monitore Créditos**: Tarefas intensivas consomem muitos créditos

### 9.2. Segurança

- ✅ **NUNCA** commitar credenciais
- ✅ **SEMPRE** usar 1Password para credenciais
- ✅ **VALIDAR** variáveis de ambiente antes de usar
- ✅ **LIMITAR** permissões de API quando possível

### 9.3. Performance

- **Use Roteamento Automático**: Deixe o sistema escolher o melhor LLM
- **Cache Resultados**: Para tarefas repetitivas, cache os resultados
- **Otimize Prompts**: Prompts mais eficientes = menos créditos consumidos

---

## 10. Troubleshooting

### 10.1. Problemas de Autenticação

```bash
# Verificar se a API Key está carregada
echo $ABACUS_API_KEY | head -c 20

# Testar autenticação
curl -X GET "https://api.abacus.ai/v1/account/info" \
  -H "Authorization: Bearer ${ABACUS_API_KEY}"
```

### 10.2. Problemas com Créditos

- Verificar créditos disponíveis
- Verificar histórico de uso
- Considerar upgrade de plano se necessário

### 10.3. Problemas com Deep Agent

- Verificar se o objetivo está claro
- Fornecer contexto suficiente
- Verificar logs de execução
- Testar com tarefas menores primeiro

---

## 11. Recursos Adicionais

- **Documentação Oficial**: https://docs.abacus.ai
- **Developer Platform**: https://docs.abacus.ai/developer-platform
- **Prompting Tips**: https://docs.abacus.ai/prompting-tips
- **FAQ**: https://docs.abacus.ai/faq
- **API Reference**: https://docs.abacus.ai/api

---

## 12. Próximos Passos

1. ✅ Configurar credenciais no 1Password
2. ✅ Carregar variáveis de ambiente
3. ✅ Testar API básica
4. ✅ Explorar Deep Agent com tarefas simples
5. ✅ Integrar com workflows existentes
6. ✅ Monitorar uso de créditos

---

**Última atualização:** 2025-12-02
**Versão:** 1.0.0











