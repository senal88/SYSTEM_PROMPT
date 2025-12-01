# Configuração da Claude API

Guia para configurar e usar o system prompt com a Claude API (Anthropic).

## Pré-requisitos

1. Conta Anthropic com API key
2. Python 3.8+
3. Biblioteca `anthropic` instalada

## Instalação

### 1. Instalar Biblioteca

```bash
pip3 install anthropic
```

### 2. Configurar API Key

```bash
export ANTHROPIC_API_KEY="sua-chave-aqui"

# Ou adicionar ao ~/.bashrc ou ~/.zshrc
echo 'export ANTHROPIC_API_KEY="sua-chave-aqui"' >> ~/.bashrc
source ~/.bashrc
```

### 3. Gerar Configuração

```bash
cd /root/SYSTEM_PROMPT
./scripts/shared/apply_claude_prompt.sh
```

Isso gera `configs/claude_api_config.py`.

## Uso Básico

### Importar e Usar

```python
from configs.claude_api_config import chat_with_system_prompt

response = chat_with_system_prompt("Sua mensagem aqui")
print(response)
```

### Uso Direto

```python
python3 configs/claude_api_config.py
```

## Uso Avançado

### Cliente Customizado

```python
from configs.claude_api_config import get_claude_client, SYSTEM_PROMPT
from anthropic import Anthropic

client = get_claude_client()

response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=4096,
    system=SYSTEM_PROMPT,
    messages=[
        {"role": "user", "content": "Sua mensagem"}
    ]
)

print(response.content[0].text)
```

### Diferentes Modelos

```python
# Claude 3.5 Sonnet (recomendado)
response = chat_with_system_prompt(
    "Mensagem",
    model="claude-3-5-sonnet-20241022"
)

# Claude 3 Opus
response = chat_with_system_prompt(
    "Mensagem",
    model="claude-3-opus-20240229"
)

# Claude 3 Haiku (mais rápido)
response = chat_with_system_prompt(
    "Mensagem",
    model="claude-3-haiku-20240307"
)
```

## Modelos Disponíveis

- `claude-3-5-sonnet-20241022` - Melhor qualidade (recomendado)
- `claude-3-opus-20240229` - Máxima qualidade
- `claude-3-sonnet-20240229` - Balanceado
- `claude-3-haiku-20240307` - Mais rápido

## Exemplo Completo

```python
#!/usr/bin/env python3
from configs.claude_api_config import chat_with_system_prompt

# Pergunta técnica
response = chat_with_system_prompt(
    "Como configurar um servidor Ubuntu para produção?",
    model="claude-3-5-sonnet-20241022"
)

print("Resposta:")
print(response)
```

## Verificação

### Testar Conexão

```python
from configs.claude_api_config import get_claude_client

try:
    client = get_claude_client()
    print("✅ Cliente Claude configurado com sucesso")
except Exception as e:
    print(f"❌ Erro: {e}")
```

### Testar System Prompt

```python
response = chat_with_system_prompt(
    "Teste: responda de forma técnica e completa, sem perguntas ao final."
)

# Verificar se segue o padrão
assert "?" not in response[-50:]  # Não termina com pergunta
print("✅ System prompt funcionando")
```

## Troubleshooting

### Erro de Autenticação

```bash
# Verificar API key
echo $ANTHROPIC_API_KEY | head -c 10

# Testar
python3 -c "from configs.claude_api_config import get_claude_client; get_claude_client()"
```

### Erro de Importação

```bash
# Verificar instalação
pip3 show anthropic

# Reinstalar se necessário
pip3 install --upgrade anthropic
```

### Rate Limits

- Implementar retry com backoff
- Aguardar entre requisições
- Verificar quotas na dashboard Anthropic

## Atualização

Para atualizar o system prompt:

1. Editar `system_prompt_global.txt`
2. Re-gerar configuração:
   ```bash
   ./scripts/shared/apply_claude_prompt.sh
   ```
3. Reiniciar aplicações Python que usam a configuração

## Documentação Oficial

- API Reference: https://docs.anthropic.com/claude/reference
- Python SDK: https://github.com/anthropics/anthropic-sdk-python

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

