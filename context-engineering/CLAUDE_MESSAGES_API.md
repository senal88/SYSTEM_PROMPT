# Claude Messages API - Documentação de Referência

## 📋 Visão Geral

A Messages API permite enviar mensagens estruturadas com texto e/ou conteúdo de imagem para o Claude, e o modelo gerará a próxima mensagem na conversa. Pode ser usada para consultas únicas ou conversas multi-turn sem estado.

## 🔗 Endpoint

```
POST https://api.anthropic.com/v1/messages
```

## 🔑 Autenticação

### Headers Obrigatórios

- **x-api-key**: `ANTHROPIC_API_KEY` (obrigatório)
  - Obtido do 1Password: Item `Anthropic-API` (ID: `ce5jhu6mivh4g63lzfxlj3r2cu`)
  - Vault: `1p_macos` ou `1p_vps`

- **anthropic-version**: Versão da API (obrigatório)
  - Exemplo: `2023-06-01`

- **anthropic-beta**: Versões beta opcionais (opcional)
  - Para múltiplas betas: `beta1,beta2` ou múltiplos headers

### Exemplo de Headers

```bash
curl https://api.anthropic.com/v1/messages \
     --header "x-api-key: $ANTHROPIC_API_KEY" \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json"
```

## 📤 Request Body

### Parâmetros Obrigatórios

- **model**: Modelo Claude a usar
  - Exemplo: `claude-sonnet-4-5-20250929`
  - Recomendado: `claude-sonnet-4-5-20250929`

- **messages**: Array de mensagens de entrada
  - Role: `user` ou `assistant`
  - Content: string ou array de blocos de conteúdo
  - Limite: 100,000 mensagens por request

- **max_tokens**: Número máximo de tokens a gerar
  - Mínimo: 1
  - Valores máximos variam por modelo

### Parâmetros Opcionais

- **system**: System prompt (string ou array de blocos de texto)
- **temperature**: 0.0 a 1.0 (padrão: 1.0)
- **top_p**: Nucleus sampling (0.0 a 1.0)
- **top_k**: Amostragem apenas dos top K tokens
- **stream**: Se deve fazer streaming da resposta (boolean)
- **stop_sequences**: Sequências customizadas para parar
- **tools**: Definições de ferramentas disponíveis
- **tool_choice**: Como o modelo deve usar ferramentas
- **thinking**: Configuração para extended thinking
- **mcp_servers**: Servidores MCP para usar na requisição
- **container**: Identificador de container para reutilização
- **context_management**: Configuração de gerenciamento de contexto
- **metadata**: Metadados sobre a requisição
- **service_tier**: `auto` ou `standard_only`

## 📝 Exemplos de Uso

### Exemplo Básico (Single Turn)

```bash
curl https://api.anthropic.com/v1/messages \
     --header "x-api-key: $ANTHROPIC_API_KEY" \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --data '{
         "model": "claude-sonnet-4-5-20250929",
         "max_tokens": 1024,
         "messages": [
             {"role": "user", "content": "Hello, world"}
         ]
     }'
```

### Exemplo Multi-Turn

```bash
curl https://api.anthropic.com/v1/messages \
     --header "x-api-key: $ANTHROPIC_API_KEY" \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --data '{
         "model": "claude-sonnet-4-5-20250929",
         "max_tokens": 1024,
         "messages": [
             {"role": "user", "content": "Hello there."},
             {"role": "assistant", "content": "Hi, I'\''m Claude. How can I help you?"},
             {"role": "user", "content": "Can you explain LLMs in plain English?"}
         ]
     }'
```

### Exemplo Python

```python
import anthropic

client = anthropic.Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))

message = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Hello, world"}
    ]
)

print(message.content)
```

### Exemplo JavaScript/TypeScript

```javascript
import { Anthropic } from '@anthropic-ai/sdk';

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY
});

const message = await anthropic.messages.create({
  model: "claude-sonnet-4-5-20250929",
  max_tokens: 1024,
  messages: [
    { role: "user", content: "Hello, world" }
  ]
});

console.log(message.content);
```

## 📥 Response

### Estrutura da Resposta

```json
{
  "id": "msg_013Zva2CMHLNnXjNJJKqJ2EF",
  "type": "message",
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "Hi! My name is Claude."
    }
  ],
  "model": "claude-sonnet-4-5-20250929",
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "usage": {
    "input_tokens": 2095,
    "output_tokens": 503
  }
}
```

### Campos da Resposta

- **id**: Identificador único da mensagem
- **type**: Sempre `"message"`
- **role**: Sempre `"assistant"`
- **content**: Array de blocos de conteúdo
- **model**: Modelo que processou a requisição
- **stop_reason**: Razão da parada (`end_turn`, `max_tokens`, `stop_sequence`, `tool_use`, etc.)
- **stop_sequence**: Sequência de parada customizada (se aplicável)
- **usage**: Informações de uso de tokens
  - `input_tokens`: Tokens de entrada
  - `output_tokens`: Tokens de saída
  - `cache_creation_input_tokens`: Tokens usados para criar cache
  - `cache_read_input_tokens`: Tokens lidos do cache
- **context_management**: Informações sobre gerenciamento de contexto
- **container**: Informações sobre container usado (se aplicável)

## 🛠️ Tipos de Conteúdo

### Text Block

```json
{
  "type": "text",
  "text": "Conteúdo do texto"
}
```

### Image Block

```json
{
  "type": "image",
  "source": {
    "type": "url",
    "url": "https://example.com/image.jpg"
  }
}
```

### Document Block

```json
{
  "type": "document",
  "source": {
    "type": "file",
    "file_id": "file_id_aqui"
  }
}
```

### Tool Use Block

```json
{
  "type": "tool_use",
  "id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
  "name": "nome_da_ferramenta",
  "input": {
    "parametro": "valor"
  }
}
```

### Tool Result Block

```json
{
  "type": "tool_result",
  "tool_use_id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
  "content": "Resultado da ferramenta"
}
```

## 🔧 Ferramentas (Tools)

### Tipos de Ferramentas Disponíveis

- **Client Tools**: Ferramentas customizadas definidas pelo usuário
- **Server Tools**: Ferramentas gerenciadas pela Anthropic
  - `web_search`: Busca na web
  - `web_fetch`: Buscar conteúdo de URLs
  - `code_execution`: Execução de código Python
  - `bash_code_execution`: Execução de comandos bash
  - `text_editor_code_execution`: Edição de arquivos e execução

### Exemplo com Ferramentas

```json
{
  "model": "claude-sonnet-4-5-20250929",
  "max_tokens": 1024,
  "messages": [
    {"role": "user", "content": "What's the weather in San Francisco?"}
  ],
  "tools": [
    {
      "name": "get_weather",
      "description": "Get the current weather in a given location",
      "input_schema": {
        "type": "object",
        "properties": {
          "location": {
            "type": "string",
            "description": "The city and state"
          }
        },
        "required": ["location"]
      }
    }
  ],
  "tool_choice": "auto"
}
```

## 🎯 MCP Servers

### Configuração MCP na Requisição

```json
{
  "mcp_servers": [
    {
      "type": "url",
      "name": "nome_do_servidor",
      "url": "http://localhost:8080",
      "authorization_token": "token_opcional",
      "tool_configuration": {
        "enabled": true,
        "allowed_tools": ["tool1", "tool2"]
      }
    }
  ]
}
```

## 📊 Gerenciamento de Contexto

### Context Management

```json
{
  "context_management": {
    "edits": [
      {
        "type": "clear_tool_uses_20250919",
        "trigger": {
          "type": "input_tokens",
          "value": 50000
        },
        "keep": {
          "type": "tool_uses",
          "value": 10
        }
      }
    ]
  }
}
```

## 🚨 Erros Comuns

### Códigos de Erro

- **400**: `invalid_request_error` - Requisição inválida
- **401**: `authentication_error` - Erro de autenticação
- **402**: `billing_error` - Erro de cobrança
- **403**: `permission_error` - Permissão negada
- **404**: `not_found_error` - Não encontrado
- **429**: `rate_limit_error` - Limite de taxa excedido
- **500**: `api_error` - Erro interno da API
- **503**: `overloaded_error` - Servidor sobrecarregado
- **504**: `timeout_error` - Timeout

### Exemplo de Resposta de Erro

```json
{
  "error": {
    "type": "invalid_request_error",
    "message": "Invalid request"
  },
  "request_id": "req_123",
  "type": "error"
}
```

## 🔐 Segurança

### Boas Práticas

1. **Nunca commitar API keys** no código
2. **Usar variáveis de ambiente** ou 1Password
3. **Validar entrada** antes de enviar
4. **Rate limiting** apropriado
5. **Monitorar uso** de tokens

### Obter API Key do 1Password

```bash
# Obter do vault macOS
export ANTHROPIC_API_KEY=$(op item get "ce5jhu6mivh4g63lzfxlj3r2cu" --vault "1p_macos" --fields "credential")

# Ou pelo nome
export ANTHROPIC_API_KEY=$(op item get "Anthropic-API" --vault "1p_macos" --fields "credential")
```

## 📚 Referências

- [Documentação Oficial](https://docs.anthropic.com/claude/docs)
- [Guia de Inicialização](https://docs.anthropic.com/claude/docs/initial-setup)
- [Exemplos de Mensagens](https://docs.claude.com/en/api/messages-examples)
- [System Prompts](https://docs.claude.com/en/docs/system-prompts)
- [Tool Use Guide](https://docs.claude.com/en/docs/tool-use)
- [Streaming](https://docs.claude.com/en/api/messages-streaming)
- [Versioning](https://docs.claude.com/en/api/versioning)
- [Errors](https://docs.claude.com/en/api/errors)

## 🔗 Integração com Projeto

### Script de Setup

O script `claude-code-setup.sh` configura automaticamente:
- `ANTHROPIC_API_KEY` do 1Password
- Variável de ambiente no shell
- Configuração persistente

### Uso no Projeto

```bash
# Carregar API key do 1Password
source ~/.zshrc  # ou ~/.bashrc

# Usar em scripts Python
python3 script.py

# Usar em scripts Node.js
node script.js

# Usar via curl
curl https://api.anthropic.com/v1/messages \
     --header "x-api-key: $ANTHROPIC_API_KEY" \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --data @request.json
```

---

**Última atualização**: 2025-01-15
**Versão da API**: 2023-06-01
**Item 1Password**: Anthropic-API (ID: `ce5jhu6mivh4g63lzfxlj3r2cu`)

