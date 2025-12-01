# Guia de Setup – Codex 2.0

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Visão Geral

O Codex 2.0, como sucessor de modelos de geração de código da OpenAI, representa uma API especializada para a criação e manipulação de código-fonte. Diferente de assistentes de propósito geral, o Codex é ajustado para entender a sintaxe e a semântica de várias linguagens de programação em profundidade.

Neste ecossistema, o Codex 2.0 é tratado primariamente como um **endpoint de API programático**, utilizado por scripts ou outras ferramentas para tarefas de geração de código em massa ou altamente específicas, em vez de ser usado diretamente em um chat ou IDE.

---

## 2. Pré-requisitos

1.  **Acesso à API:** Acesso à API da OpenAI que hospeda o modelo Codex 2.0.
2.  **Chave de API:** Uma chave de API da OpenAI. Esta é a mesma chave utilizada para outros modelos da OpenAI. Veja o guia `docs/OPENAI_API_SETUP.md` para detalhes sobre a gestão da chave.
3.  **1Password CLI:** Para o gerenciamento seguro da chave de API.
4.  **Ferramentas de Scripting:** Conhecimento de linguagens como Python ou Shell Script para fazer chamadas à API.

---

## 3. Ambientes de Utilização

O Codex 2.0 é invocado programaticamente. Os principais ambientes de onde ele será chamado são:

-   **Scripts Locais (macOS):** Scripts em `scripts/macos` ou `scripts/shared` que precisam gerar ou modificar código como parte de uma automação.
-   **Scripts Remotos (VPS Ubuntu):** Automações rodando no servidor que podem, por exemplo, gerar configurações ou adaptar scripts para o ambiente Linux.
-   **Workflows de CI/CD (GitHub Actions):** Uma action pode chamar a API do Codex para, por exemplo, gerar documentação de código automaticamente durante um pull request.
-   **Orquestradores (DeepAgent, n8n):** Um agente como o DeepAgent pode usar o Codex como uma de suas ferramentas para cumprir um objetivo que envolva a escrita de código.

---

## 4. Estratégias para Alinhamento com o System Prompt Universal

Garantir que o código gerado pelo Codex 2.0 siga as convenções e o estilo definidos no `system_prompt_global` é fundamental. Isso é feito no momento da chamada da API.

### 4.1. Construção do Prompt da API

Cada chamada à API do Codex deve ser cuidadosamente construída para incluir o contexto necessário.

**Exemplo de um prompt para gerar um script shell:**

```python
# Exemplo em Python de como construir o prompt
import os

# Carregar a chave de API de forma segura
api_key = os.getenv("OPENAI_API_KEY")

# Parte do System Prompt Universal relevante para estilo de código
code_style_prompt = """
# REGRAS DE GERAÇÃO DE CÓDIGO SHELL
- Use `#!/usr/bin/env bash`.
- Sempre inicie com `set -euo pipefail`.
- Comente o objetivo do script e os parâmetros.
- Valide os parâmetros de entrada.
- Use variáveis em maiúsculo para constantes.
- Crie funções para lógica reutilizável.
- Não use segredos hardcoded; leia-os de variáveis de ambiente.
"""

# A tarefa específica
task_prompt = "Gere um script bash que aceite um nome de diretório como argumento e crie um arquivo README.md dentro dele com o texto 'TODO: Documentação'."

# Prompt final enviado à API do Codex
final_prompt = f"""
{code_style_prompt}

## TAREFA

{task_prompt}
"""

# ... aqui viria o código para chamar a API da OpenAI com o `final_prompt` ...
```

### 4.2. Refatoração e Análise de Código

O Codex também pode ser usado para analisar e refatorar código existente.

-   **Entrada:** O conteúdo do arquivo de código a ser refatorado é fornecido no prompt.
-   **Instrução:** A instrução deve ser clara sobre o objetivo da refatoração.

**Exemplo de instrução para refatorar:**

> "Dado o seguinte script bash, refatore-o para usar funções separadas para a lógica de validação de entrada e a lógica principal de processamento. Adicione também tratamento de erros se o diretório de entrada não existir."

---

## 5. Cuidados e Boas Práticas de Segurança

-   **Revisão Humana é Obrigatória:** NUNCA execute código gerado pelo Codex 2.0 em um ambiente de produção sem uma revisão humana completa. Use-o como um "par programador" extremamente rápido, mas que ainda pode cometer erros.
-   **Operações Perigosas:** Tenha extremo cuidado com prompts que envolvam operações de sistema de arquivos (`rm`, `mv`), especialmente com variáveis. O risco de um erro gerar um comando como `rm -rf /` não é zero.
-   **Escopo Limitado:** Ao usar o Codex em automações, dê a ele o mínimo de permissões necessárias. Se um script gerado pelo Codex precisa apenas ler arquivos em um diretório, execute-o com um usuário que só tenha permissão de leitura para aquele diretório.
-   **Não Exponha Contexto Sensível:** Ao enviar código para a API para refatoração, certifique-se de que o código não contenha segredos, chaves de API, PII (Informações Pessoais Identificáveis) ou qualquer outra informação sensível.
