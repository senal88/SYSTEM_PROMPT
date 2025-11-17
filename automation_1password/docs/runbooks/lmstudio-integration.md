Last Updated: 2025-10-31
Version: 1.0.0

# Integração LM Studio com automation_1password

## 1. Visão Geral

Este runbook documenta a integração completa do **LM Studio** com o projeto automation_1password, incluindo configuração de modelos, presets de agentes experts e uso via API.

### 1.1. Configuração Atual

**LM Studio Server:**
- Porta: `1234`
- API: `http://localhost:1234/v1`
- Servir na Rede Local: ✅ Habilitado
- CORS: ✅ Habilitado
- JIT Loading: ✅ Habilitado
- TTL Inatividade: 60 minutos

**Plugins Ativos:**
- `lmstudio/js-code-sandbox` - Tools Provider
- `lmstudio/rag-v1` - Prompt Preprocessor
- `mcp/huggingface` - Tools Provider (HuggingFace)

**Modelos:**
- Diretório: `/Users/luiz.sena88/.lmstudio/models`

---

## 2. Presets de Agentes Experts

### 2.1. Presets Disponíveis

Os presets estão localizados em:
- **Projeto:** `prompts/lmstudio/presets/`
- **LM Studio Hub:** `~/.lmstudio/hub/presets/automation-1password/`

#### Preset: agent-expert-1password

**Uso:** Agente geral especializado no projeto automation_1password

**Características:**
- Contexto completo do projeto
- Estrutura real de diretórios
- Scripts e paths reais
- Integração 1Password (macOS + VPS)
- Referências a runbooks

**Configuração:**
```json
{
  "temperature": 0.7,
  "max_tokens": 4096,
  "model": "auto-detect"
}
```

#### Preset: agent-expert-vps

**Uso:** Especializado em configuração e operação VPS Ubuntu

**Características:**
- Host: 147.79.81.59
- Scripts específicos VPS
- Correção SSH
- Service Account Token

**Configuração:**
```json
{
  "temperature": 0.6,
  "max_tokens": 4096
}
```

#### Preset: agent-expert-memory

**Uso:** Otimização de memória e processamento em massa

**Características:**
- Dados reais (935 projetos, 202KB logs)
- Processamento em lotes
- Scripts de diagnóstico

**Configuração:**
```json
{
  "temperature": 0.65,
  "max_tokens": 4096
}
```

---

## 3. Seleção de Modelos

### 3.1. Modelos Recomendados

Para o projeto automation_1password, recomendamos modelos que suportam:

- **Contexto longo** (32k+ tokens para documentação completa)
- **Raciocínio** (para automação e troubleshooting)
- **Código** (para geração de scripts shell)

**Modelos Sugeridos:**
- `llama-3-8b-instruct-32k` - Bom equilíbrio performance/qualidade
- `llama-3.1-8b-instruct` - Melhor qualidade
- `mistral-7b-instruct` - Rápido e eficiente
- `phi-3-medium` - Compacto e eficiente

### 3.2. Configuração de Modelo

**No LM Studio:**
1. Vá para "Models"
2. Selecione ou baixe modelo apropriado
3. Carregue o modelo
4. Configure preset (automation-1password)

**Via API:**
```bash
# Listar modelos disponíveis
curl http://localhost:1234/v1/models

# Usar em requisição
curl http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama-3-8b-instruct-32k",
    "messages": [...]
  }'
```

---

## 4. Uso dos Presets

### 4.1. Via Interface LM Studio

1. Abra LM Studio
2. Vá para "Chat"
3. Selecione preset: `agent-expert-1password`
4. Selecione modelo carregado
5. Inicie conversa

### 4.2. Via API

```bash
# Carregar preset
PRESET_FILE="$HOME/Dotfiles/automation_1password/prompts/lmstudio/presets/agent_expert_1password.json"

# Extrair system prompt
SYSTEM_PROMPT=$(jq -r '.operation.fields[] | select(.key == "llm.prediction.systemPrompt") | .value' "$PRESET_FILE")

# Fazer requisição
curl http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"local-model\",
    \"messages\": [
      {\"role\": \"system\", \"content\": $(echo "$SYSTEM_PROMPT" | jq -Rs .)},
      {\"role\": \"user\", \"content\": \"Como sincronizar .cursorrules para 100 projetos?\"}
    ],
    \"temperature\": 0.7,
    \"max_tokens\": 4096
  }"
```

### 4.3. Via Script de Automação

```bash
# Usar script manage_presets.sh
bash scripts/lmstudio/manage_presets.sh test agent_expert_1password
```

---

## 5. Integração com 1Password

### 5.1. Variáveis de Ambiente

Configure no `.env.op`:

```ini
# LM Studio
LM_STUDIO_API_KEY=op://macos_silicon_workspace/lm_studio/api_key
LM_STUDIO_BASE_URL=http://localhost:1234/v1
LM_STUDIO_MODEL=llama-3-8b-instruct-32k
```

### 5.2. Uso com op run

```bash
# Carregar secrets e usar LM Studio API
op run --env-file=.env.op -- \
  curl -X POST "${LM_STUDIO_BASE_URL}/chat/completions" \
    -H "Content-Type: application/json" \
    -d @- << EOF
{
  "model": "${LM_STUDIO_MODEL}",
  "messages": [...]
}
EOF
```

---

## 6. Tools e Plugins

### 6.1. Plugins Disponíveis

#### js-code-sandbox
- **Função:** Execução segura de código JavaScript
- **Status:** ✅ Ativo
- **Uso:** Validação de código, testes

#### rag-v1
- **Função:** Retrieval Augmented Generation
- **Status:** ✅ Ativo
- **Uso:** Enriquecimento de prompts com contexto

#### mcp/huggingface
- **Função:** Acesso a modelos HuggingFace
- **Tools:**
  - `hf_whoami`
  - `space_search`
  - `model_search`
  - `paper_search`
  - `dataset_search`
  - `hub_repo_details`
  - `hf_doc_search`
  - `hf_doc_fetch`
- **Status:** ✅ Ativo (com reconexões periódicas)

### 6.2. Configuração de Tools

Os presets já incluem referências aos plugins. Para adicionar tools customizados:

```json
{
  "tools": [
    "1password_cli",
    "ssh_remote",
    "docker_management"
  ],
  "mcp_servers": [
    "mcp/huggingface",
    "lmstudio/rag-v1"
  ]
}
```

---

## 7. Exemplos de Uso

### 7.1. Consulta sobre Projeto

```bash
# Pergunta sobre estrutura do projeto
curl http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "local-model",
    "messages": [
      {"role": "system", "content": "[system prompt do preset]"},
      {"role": "user", "content": "Qual a estrutura do diretório scripts/maintenance/?"}
    ]
  }'
```

### 7.2. Geração de Script

```bash
# Pedir script otimizado
curl http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "local-model",
    "messages": [
      {"role": "system", "content": "[system prompt]"},
      {"role": "user", "content": "Crie script para validar configuração SSH no VPS"}
    ],
    "temperature": 0.7
  }'
```

---

## 8. Troubleshooting

### 8.1. Plugin não Conecta

**Sintoma:** Logs mostram "Client disconnected"

**Solução:**
```bash
# Verificar se plugins estão instalados
ls ~/.lmstudio/extensions/

# Reiniciar LM Studio
# Os plugins devem reconectar automaticamente
```

### 8.2. Modelo não Carrega

**Sintoma:** Erro ao carregar modelo

**Solução:**
1. Verificar espaço em disco
2. Verificar RAM disponível (modelos grandes precisam)
3. Tentar modelo menor (7B ao invés de 13B+)

### 8.3. API não Responde

**Sintoma:** Timeout ou erro de conexão

**Solução:**
```bash
# Verificar se servidor está rodando
curl http://localhost:1234/v1/models

# Verificar porta
lsof -i :1234

# Verificar logs do LM Studio
tail -f ~/.lmstudio/server-logs/*.log
```

---

## 9. Deploy e Manutenção

### 9.1. Deploy de Presets

```bash
# Deploy automático
bash scripts/lmstudio/deploy_presets.sh

# Ou manual
make prompt.sync NAME=agent_expert_1password
```

### 9.2. Atualização de Presets

```bash
# Editar preset
nano prompts/lmstudio/presets/agent_expert_1password/preset.json

# Redeploy
bash scripts/lmstudio/deploy_presets.sh

# Validar
bash scripts/lmstudio/manage_presets.sh validate
```

### 9.3. Backup

```bash
# Backup presets
cp -r ~/.lmstudio/hub/presets/automation-1password \
      ~/.lmstudio/hub/presets/automation-1password.backup.$(date +%Y%m%d)

# Backup modelos (opcional)
# Modelos são grandes, considerar backup seletivo
```

---

## 10. Referências

- **LM Studio Docs:** https://lmstudio.ai/docs
- **API OpenAI-compatible:** http://localhost:1234/v1
- **Presets do Projeto:** `prompts/lmstudio/presets/`
- **Scripts:** `scripts/lmstudio/`

---

**Última atualização**: 2025-10-31  
**Versão**: 1.0.0  
**Autor**: Sistema de Automação 1Password

