# Configuração da Gemini API

Guia para configurar e usar system instructions com a Gemini API (Google).

## Pré-requisitos

1. Conta Google com API key do Gemini
2. Python 3.8+
3. Biblioteca `google-generativeai` instalada

## Instalação

### 1. Instalar Biblioteca

```bash
pip3 install google-generativeai
```

### 2. Configurar API Key

```bash
export GEMINI_API_KEY="sua-chave-aqui"
# ou
export GOOGLE_AI_API_KEY="sua-chave-aqui"

# Ou adicionar ao ~/.bashrc ou ~/.zshrc
echo 'export GEMINI_API_KEY="sua-chave-aqui"' >> ~/.bashrc
source ~/.bashrc
```

### 3. Gerar Configuração

```bash
cd /root/SYSTEM_PROMPT
./scripts/shared/apply_gemini_prompt.sh
```

Isso gera `configs/gemini_api_config.py`.

## Uso Básico

### Importar e Usar

```python
from configs.gemini_api_config import chat_with_system_instructions

response = chat_with_system_instructions("Sua mensagem aqui")
print(response)
```

### Uso Direto

```python
python3 configs/gemini_api_config.py
```

## Uso Avançado

### Cliente Customizado

```python
from configs.gemini_api_config import get_gemini_client, SYSTEM_INSTRUCTIONS
import google.generativeai as genai

client = get_gemini_client()

model = genai.GenerativeModel(
    model_name="gemini-2.0-flash-exp",
    system_instruction=SYSTEM_INSTRUCTIONS
)

response = model.generate_content("Sua mensagem")
print(response.text)
```

### Diferentes Modelos

```python
# Gemini 2.0 Flash (recomendado)
response = chat_with_system_instructions(
    "Mensagem",
    model="gemini-2.0-flash-exp"
)

# Gemini 1.5 Pro
response = chat_with_system_instructions(
    "Mensagem",
    model="gemini-1.5-pro"
)

# Gemini 1.5 Flash
response = chat_with_system_instructions(
    "Mensagem",
    model="gemini-1.5-flash"
)
```

## Modelos Disponíveis

- `gemini-2.0-flash-exp` - Mais recente (recomendado)
- `gemini-1.5-pro` - Alta qualidade
- `gemini-1.5-flash` - Mais rápido
- `gemini-pro` - Versão anterior

## Exemplo Completo

```python
#!/usr/bin/env python3
from configs.gemini_api_config import chat_with_system_instructions

# Pergunta técnica
response = chat_with_system_instructions(
    "Como configurar um servidor Ubuntu para produção?",
    model="gemini-2.0-flash-exp"
)

print("Resposta:")
print(response)
```

## Verificação

### Testar Conexão

```python
from configs.gemini_api_config import get_gemini_client

try:
    client = get_gemini_client()
    print("✅ Cliente Gemini configurado com sucesso")
except Exception as e:
    print(f"❌ Erro: {e}")
```

### Testar System Instructions

```python
response = chat_with_system_instructions(
    "Teste: responda de forma técnica e completa, sem perguntas ao final."
)

# Verificar se segue o padrão
assert "?" not in response[-50:]  # Não termina com pergunta
print("✅ System instructions funcionando")
```

## Troubleshooting

### Erro de Autenticação

```bash
# Verificar API key
echo $GEMINI_API_KEY | head -c 10

# Testar
python3 -c "from configs.gemini_api_config import get_gemini_client; get_gemini_client()"
```

### Erro de Importação

```bash
# Verificar instalação
pip3 show google-generativeai

# Reinstalar se necessário
pip3 install --upgrade google-generativeai
```

### Rate Limits

- Implementar retry com backoff
- Aguardar entre requisições
- Verificar quotas no Google Cloud Console

## Atualização

Para atualizar o system prompt:

1. Editar `system_prompt_global.txt`
2. Re-gerar configuração:
   ```bash
   ./scripts/shared/apply_gemini_prompt.sh
   ```
3. Reiniciar aplicações Python que usam a configuração

## Documentação Oficial

- API Reference: https://ai.google.dev/api
- Python SDK: https://github.com/google/generative-ai-python

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

