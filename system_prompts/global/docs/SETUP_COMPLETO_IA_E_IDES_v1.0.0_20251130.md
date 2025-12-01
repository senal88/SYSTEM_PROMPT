# Setup Completo – Ecossistema de IAs e IDEs

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Visão Geral do Ecossistema

Este documento é o guia mestre para a configuração e integração do ecossistema de ferramentas de Inteligência Artificial e Ambientes de Desenvolvimento (IDEs) do repositório `system_prompts/global`.

O objetivo é manter um ambiente de desenvolvimento coeso, seguro e altamente produtivo, onde diferentes ferramentas de IA e assistentes de código coexistem e se complementam, com configurações e prompts centralizados e governados.

A filosofia do projeto é:
- **Automação Primeiro:** Utilizar scripts para auditoria, configuração e manutenção.
- **Governança Centralizada:** Manter uma única fonte de verdade para prompts e configurações.
- **Segurança:** Gerenciar segredos e chaves de API exclusivamente através do 1Password CLI.
- **Flexibilidade:** Permitir o uso da melhor ferramenta para cada tarefa, seja um LLM na nuvem, um modelo local offline ou um assistente de código integrado à IDE.

---

## 2. Tabela de Ferramentas, Finalidades e Locais de Uso

| Ferramenta                 | Categoria                   | Finalidade Principal                                      | Local de Uso Primário                     |
| -------------------------- | --------------------------- | --------------------------------------------------------- | ----------------------------------------- |
| **Cursor 2.1**             | IDE Principal               | Desenvolvimento, refatoração e Interação com IAs          | macOS                                     |
| **VS Code**                | IDE Secundário              | Edição leve, acesso remoto (VPS)                          | macOS, VPS (via Remote SSH)               |
| **Gemini 3.0 Pro**         | IA (Cloud / CLI)            | Orquestração, auditoria, geração de código e documentação | CLI (macOS / VPS), API                    |
| **Claude Code Pro**        | IA (Assistente de Código)   | Geração e refatoração de código de alta complexidade      | Cursor, Extensão VS Code                  |
| **ChatGPT Plus 5.1 Codex** | IA (Chat / Code)            | Geração de texto, brainstorming, prototipagem de código   | Interface Web, API                        |
| **GitHub Copilot**         | IA (Assistente de Código)   | Autocompletar código, sugestões rápidas "inline"         | Cursor, Extensão VS Code                  |
| **Perplexity Pro**         | IA (Pesquisa)               | Pesquisa contextualizada com fontes, verificação de fatos | Interface Web                             |
| **Codeium**                | IA (Assistente de Código)   | Alternativa/complemento ao Copilot, autocomplete rápido | Extensão VS Code                          |
| **Ollama**                 | LLM (Local / Offline)       | Execução de modelos de IA offline para privacidade/velocidade | CLI (macOS)                               |
| **LM Studio**              | LLM (Local / Offline)       | Interface gráfica para gerenciar e executar modelos locais | Aplicação Desktop (macOS)                 |
| **DeepAgent**              | IA (Orquestrador)           | Execução de fluxos de trabalho complexos e multiagentes   | API / Plataforma                          |
| **Codex 2.0**              | IA (Code Generation)        | Geração de código em contextos específicos via API        | API                                       |
| **1Password CLI (`op`)**   | Segurança                   | Gestão centralizada de todos os segredos e chaves de API  | CLI (macOS / VPS)                         |

---

## 3. Diagrama de Integrações

Este diagrama textual ilustra como as ferramentas se conectam.

```text
                               +-----------------------------+
                               |      1Password CLI (op)     |
                               | (Fonte da Verdade/Segredos) |
                               +---------------+-------------+
                                               |
+----------------------------------------------+----------------------------------------------+
|                                              |                                              |
v                                              v                                              v
+--------------------------+     +---------------------------+     +--------------------------+
|   macOS (Ambiente Local)   |     |      VPS (Ambiente Remoto)    |     | Plataformas Web/APIs     |
+==========================+     +===========================+     +==========================+
|                          |     |                           |     |                          |
|  +--------------------+  |     |  +---------------------+  |     |  - ChatGPT (Web)         |
|  |     Cursor 2.1     |  |     |  |       VS Code       |  |     |  - Perplexity (Web)      |
|  | (IDE Principal)    |  |     |  |   (Remote SSH)      |  |     |  - DeepAgent (API)       |
|  |--------------------|  |     |  +---------------------+  |     |  - Codex 2.0 (API)         |
|  | - Claude           |  |     |                           |     |                          |
|  | - Copilot          |  |     |  +---------------------+  |     |                          |
|  | - Gemini (via CLI) |  |     |  |     Gemini CLI      |  |     |                          |
|  +--------------------+  |     |  +---------------------+  |     |                          |
|                          |     |                           |     |                          |
|  +--------------------+  |     |                           |     |                          |
|  |      VS Code       |  |     |                           |     |                          |
|  | (IDE Secundário)   |  |     |                           |     |                          |
|  |--------------------|  |     |                           |     |                          |
|  | - Codeium          |  |     |                           |     |                          |
|  | - Extensões        |  |     |                           |     |                          |
|  +--------------------+  |     |                           |     |                          |
|                          |     |                           |     |                          |
|  +--------------------+  |     |                           |     |                          |
|  |   Modelos Locais   |  |     |                           |     |                          |
|  |--------------------|  |     |                           |     |                          |
|  | - Ollama (CLI)     |  |     |                           |     |                          |
|  | - LM Studio (GUI)  |  |     |                           |     |                          |
|  +--------------------+  |     |                           |     |                          |
|                          |     |                           |     |                          |
+--------------------------+     +---------------------------+     +--------------------------+

```

---

## 4. Passo a Passo da Configuração

### 4.1. Configuração em um novo macOS

A configuração em um novo ambiente macOS é projetada para ser o mais automatizada possível.

1.  **Clone o Repositório:**
    ```bash
    git clone https://github.com/senal88/SYSTEM_PROMPT.git ~/Dotfiles
    ```

2.  **Execute o Script Master de Instalação:**
    Navegue até o diretório de scripts e execute o script principal de setup (o nome pode variar, verifique a documentação de scripts).
    ```bash
    cd ~/Dotfiles/scripts/setup
    ./master.sh # ou setup-master.sh
    ```
    Este script deve:
    - Instalar o Homebrew.
    - Instalar todas as dependências via `Brewfile` (incluindo `op`, `ollama`, `gh`, etc.).
    - Instalar as IDEs (Cursor, VS Code).
    - Configurar o Zsh (`~/.zshrc`) para carregar as configurações do repositório.

3.  **Configure o 1Password:**
    - Faça login no 1Password CLI: `op signin`.
    - Habilite a integração com o SSH Agent nas configurações do 1Password.

4.  **Configure as IDEs:**
    - Abra o Cursor e o VS Code. Eles devem carregar automaticamente as configurações (`settings.json`, `keybindings.json`) do repositório.
    - Instale as extensões recomendadas (geralmente sugeridas pela IDE ao abrir o projeto).

5.  **Verifique a Integração:**
    - Teste a autenticação com o GitHub: `ssh -T git@github.com`.
    - Teste a autenticação do `gh` CLI: `gh auth status`.
    - Execute um modelo local com Ollama: `ollama run nome-do-modelo`.

### 4.2. Replicação do Setup na VPS Ubuntu

O ambiente na VPS é uma versão simplificada, focada em execução de scripts e acesso via VS Code Remote.

1.  **Clone o Repositório:**
    ```bash
    git clone https://github.com/senal88/SYSTEM_PROMPT.git ~/Dotfiles
    ```

2.  **Execute o Script de Setup para Ubuntu:**
    ```bash
    cd ~/Dotfiles/scripts/setup
    ./ubuntu.sh # ou setup-ubuntu.sh
    ```
    Este script deve:
    - Instalar dependências essenciais (`build-essential`, `git`, etc.).
    - Configurar o `.bashrc` para carregar aliases e funções do repositório.
    - Instalar o 1Password CLI e o Gemini CLI.

3.  **Configure o Acesso Remoto:**
    - No seu macOS local, conecte-se à VPS usando a extensão Remote-SSH do VS Code. O ambiente estará pronto para uso.

---

## 5. Referências aos Guias de Setup Detalhados

Para instruções específicas de cada ferramenta, consulte os seguintes documentos neste mesmo diretório (`docs/`):

- **[Guia do Claude](CLAUDE_SETUP.md)**
- **[Guia do ChatGPT](CHATGPT_SETUP.md)**
- **[Guia do Gemini](GEMINI_SETUP.md)**
- **[Guia do Perplexity](PERPLEXITY_SETUP.md)**
- **[Guia do DeepAgent](DEEPAGENT_SETUP.md)**
- **[Guia do Codex 2.0](CODEX2_SETUP.md)**
- **[Guia do GitHub Copilot](COPILOT_SETUP.md)**
- **[Guia do Codeium](CODEIUM_SETUP.md)**
- **[Guia da OpenAI API](OPENAI_API_SETUP.md)**
- **[Guia de LLMs Offline](OFFLINE_LLMS_SETUP.md)**
