# Guia de Configuração

Este guia detalha como configurar o system prompt em cada ferramenta de IA.

## Visão Geral

O sistema suporta configuração em múltiplas ferramentas:

1. **Cursor IDE** - Automático via script
2. **ChatGPT Plus** - Manual via interface web
3. **Perplexity Pro** - Manual via interface web
4. **Claude API** - Via código Python
5. **Gemini API** - Via código Python
6. **OpenAI API** - Via código Python

## Cursor IDE

### Método Automático (Recomendado)

```bash
./scripts/shared/apply_cursor_prompt.sh
```

### Método Manual

1. Copiar system prompt:
   ```bash
   cp system_prompt_global.txt ~/.cursorrules
   ```

2. Editar `settings.json` do Cursor:
   ```json
   {
     "cursor.systemPrompt.enabled": true,
     "cursor.systemPrompt": "/root/SYSTEM_PROMPT/system_prompt_global.txt"
   }
   ```

3. Reiniciar Cursor IDE

Ver [CURSOR_SETUP.md](CURSOR_SETUP.md) para detalhes completos.

## ChatGPT Plus

### Gerar Instruções

```bash
./scripts/shared/apply_chatgpt_prompt.sh
```

Isso gera `configs/chatgpt_custom_instructions.txt`.

### Aplicar Manualmente

1. Acesse https://chat.openai.com/
2. Clique no seu perfil (canto inferior esquerdo)
3. Selecione "Custom instructions"
4. Cole o conteúdo de `configs/chatgpt_custom_instructions.txt`
5. Salve

Ver [CHATGPT_SETUP.md](CHATGPT_SETUP.md) para detalhes.

## Perplexity Pro

### Gerar Instruções

```bash
./scripts/shared/apply_perplexity_prompt.sh
```

Isso gera `configs/perplexity_custom_instructions.txt`.

### Aplicar Manualmente

1. Acesse https://www.perplexity.ai/
2. Faça login na conta Pro
3. Vá em Settings → Custom Instructions
4. Cole o conteúdo de `configs/perplexity_custom_instructions.txt`
5. Salve

Ver [PERPLEXITY_SETUP.md](PERPLEXITY_SETUP.md) para detalhes.

## Claude API

### Gerar Configuração

```bash
./scripts/shared/apply_claude_prompt.sh
```

Isso gera `configs/claude_api_config.py`.

### Usar

```python
from claude_api_config import chat_with_system_prompt

response = chat_with_system_prompt("Sua mensagem aqui")
print(response)
```

**Requisitos:**
- `ANTHROPIC_API_KEY` configurada
- Biblioteca `anthropic` instalada: `pip install anthropic`

Ver [CLAUDE_SETUP.md](CLAUDE_SETUP.md) para detalhes.

## Gemini API

### Gerar Configuração

```bash
./scripts/shared/apply_gemini_prompt.sh
```

Isso gera `configs/gemini_api_config.py`.

### Usar

```python
from gemini_api_config import chat_with_system_instructions

response = chat_with_system_instructions("Sua mensagem aqui")
print(response)
```

**Requisitos:**
- `GEMINI_API_KEY` configurada
- Biblioteca `google-generativeai` instalada: `pip install google-generativeai`

Ver [GEMINI_SETUP.md](GEMINI_SETUP.md) para detalhes.

## OpenAI API

### Gerar Configuração

```bash
./scripts/shared/apply_openai_prompt.sh
```

Isso gera `configs/openai_api_config.py`.

### Usar

```python
from openai_api_config import chat_with_system_prompt

response = chat_with_system_prompt("Sua mensagem aqui")
print(response)
```

**Requisitos:**
- `OPENAI_API_KEY` configurada
- Biblioteca `openai` instalada: `pip install openai`

Ver [OPENAI_SETUP.md](OPENAI_SETUP.md) para detalhes.

## Verificação

Após configurar cada ferramenta, execute:

```bash
# Validação completa
./scripts/shared/validate_ia_system.sh

# Auditoria
./scripts/shared/audit_system_prompts.sh
```

## Sincronização

Para sincronizar entre ambientes (Mac ↔ VPS):

```bash
./scripts/shared/sync_system_prompt.sh
```

## Atualização

Para atualizar o system prompt em todas as ferramentas:

1. Editar `system_prompt_global.txt`
2. Re-executar scripts de aplicação:
   ```bash
   ./scripts/shared/apply_cursor_prompt.sh
   ./scripts/shared/apply_chatgpt_prompt.sh
   # etc...
   ```
3. Validar:
   ```bash
   ./scripts/shared/validate_ia_system.sh
   ```

## Troubleshooting

Se alguma configuração não funcionar:

1. Verifique logs de erro
2. Execute validação: `validate_ia_system.sh`
3. Consulte [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
4. Execute auditoria: `audit_system_prompts.sh`

---

**Versão:** 1.0
**Última atualização:** 2025-11-15

