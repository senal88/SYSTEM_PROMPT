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
