# Guia de Setup – OpenAI API

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Visão Geral

A API da OpenAI fornece acesso programático a uma vasta gama de modelos, incluindo as famílias GPT (ex: GPT-4, GPT-5) e modelos especializados como o Codex. Enquanto o ChatGPT é a interface de chat, a API é o gateway para integrar o poder desses modelos em scripts, automações e aplicações personalizadas.

Neste ecossistema, a OpenAI API é utilizada para:

- Tarefas de geração de texto em scripts.
- Alimentar agentes de IA como o DeepAgent.
- Executar análises de código ou refatorações programáticas através do modelo Codex 2.0.

---

## 2. Pré-requisitos

1. **Conta OpenAI:** Uma conta ativa na plataforma da OpenAI.
2. **Créditos ou Assinatura:** Créditos pré-pagos ou uma assinatura que permita o uso da API.
3. **Chave de API:** Uma chave de API (secret key) gerada na seção "API keys" do seu painel da OpenAI.
4. **1Password CLI:** O `op` CLI é o único método aprovado para armazenar e acessar a chave de API.

---

## 3. Configuração de Segurança (Chave de API)

A chave da API da OpenAI concede acesso total aos modelos associados à sua conta e pode incorrer em custos. Sua proteção é crítica.

1. **Salvar a Chave no 1Password:**
    - Crie um novo item do tipo "Chave de API" no 1Password.
    - Dê um nome claro, como `OpenAI API Key`.
    - Cole sua chave secreta no campo de credencial.
    - Adicione a tag `api-key` para ser descoberta pelos scripts de auditoria.

2. **Exportação como Variável de Ambiente:**
    - Scripts e aplicações que usam a API da OpenAI geralmente procuram a chave na variável de ambiente `OPENAI_API_KEY`.
    - O `~/.zshrc` (macOS) ou `~/.bashrc` (VPS) deve ser configurado para carregar esta variável usando o 1Password CLI, garantindo que a chave nunca seja escrita em texto plano no disco.

      ```bash
      # Adicionar ao seu .zshrc ou script de ambiente
      export OPENAI_API_KEY=$(op read "op://Development/OpenAI API Key/credential")
      ```

    - **Método Recomendado:** Use o script centralizado `~/Dotfiles/scripts/load_ai_keys.sh`:

      ```bash
      # Adicionar ao ~/.zshrc
      source ~/Dotfiles/scripts/load_ai_keys.sh
      ```

    - Este script carrega automaticamente:
      - `OPENAI_API_KEY`
      - `ANTHROPIC_API_KEY` (Claude)
      - `GOOGLE_API_KEY` / `GEMINI_API_KEY`
      - `PERPLEXITY_API_KEY`
      - `GITHUB_TOKEN`
    - A execução do script `scripts/auditar-1password-secrets_v1.0.0_20251130.sh` deve validar se esta variável está sendo carregada corretamente no seu ambiente de shell.

3. **Verificar Instalação do 1Password CLI:**

    ```bash
    # Instalar se necessário
    brew install --cask 1password-cli

    # Verificar
    op --version

    # Autenticar (primeira vez)
    eval $(op signin)
    ```

---

## 4. Uso em Scripts e Aplicações

Uma vez que a variável `OPENAI_API_KEY` está disponível no seu shell, qualquer script (Python, Node.js, Shell) ou ferramenta que use as bibliotecas oficiais da OpenAI funcionará automaticamente sem precisar de configuração adicional.

### Exemplo de Chamada da API em Python

```python
import os
from openai import OpenAI

# A biblioteca da OpenAI lê automaticamente a variável de ambiente OPENAI_API_KEY.
# Nenhuma chave precisa ser passada aqui.
client = OpenAI()

# Carregar o System Prompt Universal ou uma parte dele
# (Idealmente, isso viria de um arquivo para não ser hardcoded)
system_prompt_content = """
Você é um assistente de programação. Suas respostas devem ser técnicas, precisas e em Português do Brasil.
Gere apenas o código solicitado, sem comentários ou explicações adicionais.
"""

try:
    response = client.chat.completions.create(
        model="gpt-4-turbo",  # ou outro modelo desejado
        messages=[
            {"role": "system", "content": system_prompt_content},
            {"role": "user", "content": "Escreva uma função em Python que calcula o fatorial de um número."}
        ]
    )
    generated_code = response.choices[0].message.content
    print(generated_code)

except Exception as e:
    print(f"Ocorreu um erro ao chamar a API da OpenAI: {e}")

```

### Exemplo de Chamada da API em Shell (com `curl`)

```bash
#!/usr/bin/env bash
set -euo pipefail

# A variável OPENAI_API_KEY já deve estar exportada no ambiente

SYSTEM_PROMPT="Você é um assistente de tradução. Responda apenas com o texto traduzido."
USER_PROMPT="Traduza a frase 'Hello, world!' para o português."

# Corpo da requisição em JSON
JSON_BODY=$(jq -n \
  --arg sp "$SYSTEM_PROMPT" \
  --arg up "$USER_PROMPT" \
  '{
    "model": "gpt-4",
    "messages": [
      {"role": "system", "content": $sp},
      {"role": "user", "content": $up}
    ]
  }')

curl https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "$JSON_BODY"
```

---

## 5. Boas Práticas e Recomendações

- **Modelos Específicos:** Sempre especifique o modelo que deseja usar na chamada da API (ex: `gpt-4-turbo`, `text-davinci-003`). Não confie no modelo padrão da API, pois ele pode mudar.
- **Logging e Observabilidade:** Para automações críticas, implemente um sistema de logging para registrar as requisições e respostas. Isso é crucial para depuração e monitoramento de custos.
- **Tratamento de Erros:** Sempre envolva as chamadas de API em blocos de tratamento de erros (`try...except` em Python, verificação de código de status em shell) para lidar com falhas de rede, erros de API (ex: cota excedida) ou respostas malformadas.
- **Controle de Custos:** Monitore seu uso e custos no painel da OpenAI regularmente. Considere configurar alertas de orçamento para evitar surpresas.
- **Uso do System Prompt:** Para garantir consistência, a parte do prompt do sistema (`"role": "system"`) deve ser carregada a partir dos arquivos de prompt governados no repositório, em vez de ser escrita diretamente no código.
