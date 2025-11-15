# Configuração da OpenAI API

Guia para configurar e usar o system prompt com a OpenAI API.

## Pré-requisitos

1. Conta OpenAI com API key
2. Python 3.8+
3. Biblioteca `openai` instalada

## Instalação

### 1. Instalar Biblioteca

```bash
pip3 install openai
```

### 2. Configurar API Key

```bash
export OPENAI_API_KEY="sua-chave-aqui"

# Ou adicionar ao ~/.bashrc ou ~/.zshrc
echo 'export OPENAI_API_KEY="sua-chave-aqui"' >> ~/.bashrc
source ~/.bashrc
```

### 3. Gerar Configuração

```bash
cd /root/SYSTEM_PROMPT
./scripts/shared/apply_openai_prompt.sh
```

Isso gera `configs/openai_api_config.py`.

## Uso Básico

### Importar e Usar

```python
from configs.openai_api_config import chat_with_system_prompt

response = chat_with_system_prompt("Sua mensagem aqui")
print(response)
```

### Uso Direto

```python
python3 configs/openai_api_config.py
```

## Uso Avançado

### Cliente Customizado

```python
from configs.openai_api_config import get_openai_client, SYSTEM_PROMPT
from openai import OpenAI

client = get_openai_client()

response = client.chat.completions.create(
    model="gpt-4-turbo-preview",
    messages=[
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": "Sua mensagem"}
    ],
    temperature=0.7,
    max_tokens=4096
)

print(response.choices[0].message.content)
```

### Diferentes Modelos

```python
# GPT-4 Turbo (recomendado)
response = chat_with_system_prompt(
    "Mensagem",
    model="gpt-4-turbo-preview"
)

# GPT-4
response = chat_with_system_prompt(
    "Mensagem",
    model="gpt-4"
)

# GPT-3.5 Turbo (mais rápido)
response = chat_with_system_prompt(
    "Mensagem",
    model="gpt-3.5-turbo"
)
```

## Modelos Disponíveis

- `gpt-4-turbo-preview` - Mais recente (recomendado)
- `gpt-4` - Alta qualidade
- `gpt-3.5-turbo` - Mais rápido e econômico
- `gpt-4o` - Otimizado (quando disponível)

## Exemplo Completo

```python
#!/usr/bin/env python3
from configs.openai_api_config import chat_with_system_prompt

# Pergunta técnica
response = chat_with_system_prompt(
    "Como configurar um servidor Ubuntu para produção?",
    model="gpt-4-turbo-preview"
)

print("Resposta:")
print(response)
```

## Verificação

### Testar Conexão

```python
from configs.openai_api_config import get_openai_client

try:
    client = get_openai_client()
    print("✅ Cliente OpenAI configurado com sucesso")
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
echo $OPENAI_API_KEY | head -c 10

# Testar
python3 -c "from configs.openai_api_config import get_openai_client; get_openai_client()"
```

### Erro de Importação

```bash
# Verificar instalação
pip3 show openai

# Reinstalar se necessário
pip3 install --upgrade openai
```

### Rate Limits

- Implementar retry com backoff
- Aguardar entre requisições
- Verificar quotas no dashboard OpenAI
- Usar GPT-3.5-turbo para requisições frequentes

## Atualização

Para atualizar o system prompt:

1. Editar `system_prompt_global.txt`
2. Re-gerar configuração:
   ```bash
   ./scripts/shared/apply_openai_prompt.sh
   ```
3. Reiniciar aplicações Python que usam a configuração

## Documentação Oficial

- API Reference: https://platform.openai.com/docs/api-reference
- Python SDK: https://github.com/openai/openai-python

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

