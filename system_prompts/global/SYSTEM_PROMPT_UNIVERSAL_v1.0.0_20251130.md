# System Prompt Universal para IAs Comerciais

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30

## 1. Visão Geral

Este documento é a "constituição" do repositório `system_prompts/global`. Ele serve como o principal ponto de entrada de contexto para qualquer assistente de IA (Gemini, Claude, ChatGPT) que opere neste ambiente.

O objetivo é garantir que a IA compreenda a estrutura do projeto, as ferramentas utilizadas, as regras de governança e seu próprio papel dentro deste ecossistema, resultando em interações mais precisas, seguras e eficientes.

## 2. Ferramentas Suportadas

O ecossistema é composto pelas seguintes ferramentas:

| Ferramenta                 | Categoria                   | Local de Uso Primário                     |
| -------------------------- | --------------------------- | ----------------------------------------- |
| **Cursor 2.1**             | IDE Principal               | macOS                                     |
| **VS Code**                | IDE Secundário              | macOS, VPS (via Remote SSH)               |
| **Gemini 3.0 Pro**         | IA (Cloud / CLI)            | CLI (macOS / VPS), API                    |
| **Claude Code Pro**        | IA (Assistente de Código)   | Cursor, Extensão VS Code                  |
| **ChatGPT Plus 5.1 Codex** | IA (Chat / Code)            | Interface Web, API                        |
| **GitHub Copilot**         | IA (Assistente de Código)   | Cursor, Extensão VS Code                  |
| **Perplexity Pro**         | IA (Pesquisa)               | Interface Web                             |
| **Codeium**                | IA (Assistente de Código)   | Extensão VS Code                          |
| **Ollama**                 | LLM (Local / Offline)       | CLI (macOS)                               |
| **LM Studio**              | LLM (Local / Offline)       | Aplicação Desktop (macOS)                 |
| **DeepAgent**              | IA (Orquestrador)           | API / Plataforma                          |
| **Codex 2.0**              | IA (Code Generation)        | API                                       |
| **Abacus AI**              | IA (Plataforma Multi-LLM)  | Web / API                                 |
| **ChatLLM**                | IA (Super Assistant)       | Web / API (Abacus AI)                     |
| **Deep Agent**             | IA (Agente Autônomo)       | API (Abacus AI)                           |
| **1Password CLI (`op`)**   | Segurança                   | CLI (macOS / VPS)                         |


## 3. Integração com IDEs

-   **Cursor 2.1:** É a IDE principal. Utiliza `.cursorrules` para injeção de contexto e integra nativamente Claude e Copilot.
-   **VS Code:** Usado como IDE secundária, principalmente para acesso remoto à VPS.

## 4. Estrutura do Projeto

A estrutura de diretórios governada e atualizada está detalhada no arquivo `consolidated/arquitetura-estrutura_v1.0.0_20251130.txt`. A visão geral é:

```text
/
├── audit/
├── consolidated/
├── docs/
├── governance/
├── logs/
├── prompts/
├── scripts/
└── templates/
```

## 5. Início Rápido (Quick Start)

1.  **Clone o Repositório:**
    ```bash
    git clone https://github.com/senal88/SYSTEM_PROMPT.git ~/Dotfiles
    ```
2.  **Execute o Script de Setup:**
    ```bash
    # O nome e localização exata pode variar, consulte a documentação em /docs
    cd ~/Dotfiles/scripts/setup
    ./master.sh
    ```
3.  **Autentique o 1Password:**
    ```bash
    op signin
    ```
4.  **Verifique o Ambiente:**
    - Teste a conexão SSH com o GitHub: `ssh -T git@github.com`
    - Execute a auditoria master: `cd ~/Dotfiles/system_prompts/global && ./scripts/master-auditoria...sh`

## 6. Documentação Completa

Toda a documentação detalhada sobre o setup de cada ferramenta, arquitetura e governança está localizada no diretório `docs/`. Os principais documentos incluem:

-   `SETUP_COMPLETO_IA_E_IDES...md`: Guia mestre do ecossistema.
-   `CLAUDE_SETUP...md`: Guia específico para o Claude.
-   `CHATGPT_SETUP...md`: Guia específico para o ChatGPT.
-   `GEMINI_SETUP...md`: Guia específico para o Gemini.
-   `ABACUS_SETUP...md`: Guia específico para o Abacus AI (ChatLLM & Deep Agent).
-   `ABACUS_CHATLLM_GUIDE...md`: Guia detalhado do ChatLLM AI Super Assistant.
-   `ABACUS_DEEP_AGENT_GUIDE...md`: Guia detalhado do Deep Agent.
-   `(etc para todas as outras ferramentas)`

## 7. Scripts Principais

O diretório `scripts/` contém toda a automação. Os scripts mais importantes são:

-   **`atualizar-nomes-governanca...sh`**: Aplica a política de nomenclatura de arquivos em todo o projeto.
-   **`exportar-arquitetura...sh`**: Gera um documento de texto com a árvore de diretórios e análise do projeto.
-   **`encontrar-pastas-vazias.sh`**: Lista diretórios vazios para limpeza.
-   **`master-update.sh`**: Script orquestrador que executa outras tarefas de manutenção.
-   **`auditar-*.sh`**: Conjunto de scripts para auditorias específicas (SSH, Docker, 1Password, etc.).

## 8. Automação

-   **macOS:** Automações podem ser agendadas via `launchd`.
-   **VPS (Ubuntu):** `cron` é usado para agendar tarefas recorrentes (ex: backups, sincronizações).
-   **CI/CD:** O repositório está preparado para integração com GitHub Actions para validação contínua (linting, testes de scripts).

## 9. Requisitos

-   **macOS:** Versão Tahoe (26.x) ou superior, com Apple Silicon.
-   **VPS:** Ubuntu 22.04 LTS ou superior.
-   **Linguagens:** `bash`, `zsh`, `python`, `node`.
-   **Ferramentas CLI:** `git`, `op` (1Password CLI), `gh` (GitHub CLI), `ollama`, `gemini-cli`.

## 10. Licença / Uso Interno

Este repositório e seu conteúdo são para uso interno e gerenciamento do ambiente de desenvolvimento pessoal de `luiz.sena88`.

## 11. Suporte e Diagnóstico

-   **Problemas de Autenticação:** Verifique o status do `op signin` e do `gh auth status`. Teste a conexão SSH com `ssh -T git@github.com`.
-   **Problemas com Scripts:** Todos os scripts devem ser executáveis (`chmod +x`). Execute-os com `bash -x ./nome_do_script.sh` para depurar.
-   **Relatórios de Auditoria:** Consulte o diretório `audit/` para encontrar logs detalhados de execuções anteriores.


## ANTIGRAVITT - Setup Completo Settings

[rtifact
Review Policy
Specifies Agent's behavior when asking for review on artifacts, which are documents it creates to enable a richer conversation experience.
• Always Proceed - Agent never asks for review
• Agent Decides - Agent will decide when to ask for review
• Request Review - Agent always asks for review

**Agent Decides**
Terminal
Terminal Command Auto Execution
• Off - Never auto-execute terminal commands (except those in the Allow list)
• Auto - Agent decides whether to auto-execute any given terminal command
• Turbo - Always auto-execute terminal commands (except those in the Deny list)

Note: a change to this setting will only apply to new messages sent to Agent. In-progress responses will use the previous setting value.

**Turbo**
Allow List Terminal Commands
Agent auto-executes commands matched by an allow list entry. For Unix shells, an allow list entry matches a command if its space-separated tokens form a prefix of the command's tokens. For PowerShell, the entry tokens may match any contiguous subsequence of the command tokens.
Deny List Terminal Commands
Agent asks for permission before executing commands matched by a deny list entry. The deny list follows the same matching rules as the allow list and takes precedence over the allow list.
File Access
Agent Gitignore Access
Allow Agent to view and edit the files in .gitignore.

**Agent Non-Workspace File Access**
Allow Agent to view and edit files outside of the current workspace. Use with caution.

**Auto-Open Edited Files**
Open files in the background if Agent creates or edits them

**Automation**
Agent Auto-Fix Lints
When enabled, Agent is given awareness of lint errors created by its edits and may fix them without explicit user prompting.

**Auto-Continue**
When enabled, Agent will automatically continue its response when it reaches its per-response invocation limit. If this setting is off, Agent will instead prompt you to continue upon reaching the limit.

**General**
Enable Agent Web Tools
When enabled, Agent can search the web for relevant information and read URLs you paste in.

Open Agent on Reload
Open Agent panel on window reload

**Advanced Settings**
Enable Demo Mode (Beta)
When enabled, your UI will be slightly modified to ensure more consistent demos. This is only recommended for demo purposes. In most cases, you can run "Antigravity: Start Demo Mode" and "Antigravity: Stop Demo Mode" to control this switch and update your ~/.gemini/antigravity data directory.]

[**General**
Enable Browser Tools
When enabled, Agent can use browser tools to open URLs, read web pages, and interact with browser content.

Browser Javascript Execution Policy
• Disabled - Agent will never run javascript code in the browser.
• Always Ask - Agent will always stop to ask for permission to run javascript code in the browser.
• Model Decides - Agent will decide when to ask for permission to run javascript code in the browser.
• Turbo - Agent will not stop to ask for permission to run javascript in the browser.

Model Decides
Allowlist
Browser URL Allowlist
Control which URLs the browser can access by adding domains to the allowlist file.
Advanced
Chrome Binary Path
Path to the Chrome/Chromium executable. Leave empty for auto-detection.
Absolute path to the Chrome/Chromium executable
Browser User Profile Path
Custom path for the browser user profile directory. Leave empty for default (~/.gemini/antigravity-browser-profile).
~/.gemini/antigravity-browser-profile
Browser CDP Port
Port number for Chrome DevTools Protocol remote debugging. Leave empty for default (9222).
]

[Marketplace
Marketplace Item URL
Changes the base URL on each extension page. You must restart Antigravity to use the new marketplace after changing this value.
https://open-vsx.org/vscode/item
Marketplace Gallery URL
Changes the base URL for marketplace search results. You must restart Antigravity to use the new marketplace after changing this value.
https://open-vsx.org/vscode/gallery
General
Editor Settings
To modify editor settings, open Settings within the editor window. ]

[General
Notification Settings
To modify notification settings, open your operating system's system preferences.]

[Suggestions
Suggestions in Editor
Show suggestions when typing in the editor

Tab Speed
Set the speed of tab suggestions

Fast
Highlight After Accept
Highlight newly inserted text after accepting a Tab completion.

Tab to Import
Quickly add and update imports with a tab keypress.

Navigation
Tab to Jump
Predict the location of your next edit and navigates you there with a tab keypress.

Context
Clipboard Context
When enabled, Antigravity will use the clipboard as context for completions.

Tab Gitignore Access
Allow Tab to view and edit the files in .gitignore.]

]
