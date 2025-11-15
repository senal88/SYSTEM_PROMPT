# Referência de API

Este documento descreve as APIs e configurações disponíveis no sistema.

## Estrutura de APIs

### Claude API (Anthropic)

**Configuração:**
```bash
export ANTHROPIC_API_KEY="sua-chave-aqui"
```

**Uso:**
```python
from configs.claude_api_config import chat_with_system_prompt

response = chat_with_system_prompt(
    message="Sua mensagem",
    model="claude-3-5-sonnet-20241022"
)
```

**Modelos disponíveis:**
- `claude-3-5-sonnet-20241022` (recomendado)
- `claude-3-opus-20240229`
- `claude-3-sonnet-20240229`
- `claude-3-haiku-20240307`

**Documentação:** https://docs.anthropic.com/

### Gemini API (Google)

**Configuração:**
```bash
export GEMINI_API_KEY="sua-chave-aqui"
# ou
export GOOGLE_AI_API_KEY="sua-chave-aqui"
```

**Uso:**
```python
from configs.gemini_api_config import chat_with_system_instructions

response = chat_with_system_instructions(
    message="Sua mensagem",
    model="gemini-2.0-flash-exp"
)
```

**Modelos disponíveis:**
- `gemini-2.0-flash-exp` (recomendado)
- `gemini-1.5-pro`
- `gemini-1.5-flash`

**Documentação:** https://ai.google.dev/docs

### OpenAI API

**Configuração:**
```bash
export OPENAI_API_KEY="sua-chave-aqui"
```

**Uso:**
```python
from configs.openai_api_config import chat_with_system_prompt

response = chat_with_system_prompt(
    message="Sua mensagem",
    model="gpt-4-turbo-preview"
)
```

**Modelos disponíveis:**
- `gpt-4-turbo-preview` (recomendado)
- `gpt-4`
- `gpt-3.5-turbo`

**Documentação:** https://platform.openai.com/docs

## Estrutura de Dados

### JSON de Coleta

```json
{
  "metadata": {
    "timestamp": "2025-11-15T12:00:00Z",
    "hostname": "hostname",
    "platform": "macOS|Ubuntu",
    "architecture": "arm64|x86_64",
    "collection_version": "1.0"
  },
  "system_prompt": {
    "global_file": {
      "exists": true,
      "path": "/path/to/file",
      "checksum": "sha256...",
      "size": 1234,
      "version": "1.0"
    }
  }
}
```

### Resposta de API

**Claude:**
```python
{
  "content": "Resposta da IA",
  "model": "claude-3-5-sonnet-20241022",
  "usage": {
    "input_tokens": 100,
    "output_tokens": 200
  }
}
```

**Gemini:**
```python
{
  "text": "Resposta da IA",
  "model": "gemini-2.0-flash-exp"
}
```

**OpenAI:**
```python
{
  "content": "Resposta da IA",
  "model": "gpt-4-turbo-preview",
  "usage": {
    "prompt_tokens": 100,
    "completion_tokens": 200,
    "total_tokens": 300
  }
}
```

## Variáveis de Ambiente

### Obrigatórias (por API)

- `ANTHROPIC_API_KEY` - Para Claude API
- `GEMINI_API_KEY` ou `GOOGLE_AI_API_KEY` - Para Gemini API
- `OPENAI_API_KEY` - Para OpenAI API

### Opcionais

- `OUTPUT_DIR` - Diretório para relatórios (padrão: `/tmp/ia_collection`)
- `EDITOR` - Editor padrão para arquivos de configuração

## Scripts de API

### Gerar Configurações

```bash
# Claude
./scripts/shared/apply_claude_prompt.sh

# Gemini
./scripts/shared/apply_gemini_prompt.sh

# OpenAI
./scripts/shared/apply_openai_prompt.sh
```

Isso gera arquivos Python em `configs/` que podem ser importados.

## Exemplos de Uso

### Uso Básico

```python
# Claude
from configs.claude_api_config import chat_with_system_prompt
response = chat_with_system_prompt("Olá!")
print(response)

# Gemini
from configs.gemini_api_config import chat_with_system_instructions
response = chat_with_system_instructions("Olá!")
print(response)

# OpenAI
from configs.openai_api_config import chat_with_system_prompt
response = chat_with_system_prompt("Olá!")
print(response)
```

### Uso Avançado

```python
# Claude com cliente customizado
from configs.claude_api_config import get_claude_client
from anthropic import Anthropic

client = get_claude_client()
response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=4096,
    system=SYSTEM_PROMPT,
    messages=[{"role": "user", "content": "Mensagem"}]
)
```

## Limites e Quotas

### Claude API

- Rate limits: Verificar na documentação oficial
- Tokens: Até 200K tokens de contexto

### Gemini API

- Rate limits: Verificar na documentação oficial
- Tokens: Até 1M tokens de contexto (modelos mais recentes)

### OpenAI API

- Rate limits: Dependem do plano
- Tokens: Até 128K tokens de contexto (GPT-4 Turbo)

## Segurança

### Proteção de API Keys

- Nunca commite chaves em código
- Use variáveis de ambiente
- Use arquivos `.env` (não commitados)
- Rotacione chaves regularmente

### Sanitização

Os scripts de coleta nunca exibem valores completos de API keys:
- Apenas prefixo (primeiros 10 caracteres)
- Tamanho da chave
- Status (configurada/não configurada)

## Troubleshooting de API

### Erro de Autenticação

```bash
# Verificar chave configurada
echo $ANTHROPIC_API_KEY | head -c 10

# Testar conexão
python3 -c "from configs.claude_api_config import get_claude_client; get_claude_client()"
```

### Erro de Rate Limit

- Aguardar antes de novas requisições
- Implementar retry com backoff
- Verificar quotas na documentação oficial

### Erro de Modelo

- Verificar se o modelo está disponível
- Usar modelo alternativo
- Verificar documentação para modelos atualizados

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

