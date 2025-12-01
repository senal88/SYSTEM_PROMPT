# Guia de Setup – Claude Code Pro

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Visão Geral

Claude Code Pro é uma das principais IAs assistentes de código neste ecossistema, focada em geração, refatoração e análise de código de alta complexidade. Sua integração é crucial para tarefas que exigem um profundo entendimento do contexto do código.

Este guia detalha como configurar e integrar o Claude Code Pro com as IDEs padrão (Cursor e VS Code) e como garantir que ele utilize os prompts e segredos governados pelo repositório.

---

## 2. Pré-requisitos

1.  **Conta Anthropic:** É necessário ter uma conta ativa na plataforma da Anthropic com acesso ao Claude Code Pro.
2.  **Chave de API:** Uma chave de API (API Key) válida deve ser gerada no dashboard da Anthropic.
3.  **1Password e CLI:** O 1Password deve ser o cofre de senhas principal, e o 1Password CLI (`op`) deve estar instalado e configurado no ambiente local (macOS).

---

## 3. Armazenamento Seguro da Chave de API

**Nunca armazene a chave de API diretamente em arquivos de configuração ou no código-fonte.** A política deste repositório é utilizar o 1Password como a única fonte da verdade para segredos.

1.  **Salvar a Chave no 1Password:**
    - Crie um novo item no 1Password do tipo "Chave de API" (API Key).
    - Nomeie o item de forma clara, por exemplo: `Anthropic API Key (Claude)`.
    - Salve a chave de API no campo apropriado.
    - Adicione uma tag, como `api-key` ou `claude`, para facilitar a busca via CLI.

2.  **Configurar Referência para o `op` CLI:**
    - O script `scripts/auditar-1password-secrets...sh` já está configurado para buscar chaves com nomes e tags específicas. Garanta que o nome do seu item no 1Password seja compatível com o que o script espera encontrar. O script normalmente busca por um título ou tag que contenha "Anthropic" ou "Claude".

---

## 4. Integração com IDEs

A interação com o Claude Code Pro ocorre principalmente através de extensões nas IDEs.

### 4.1. Integração com Cursor 2.1 (IDE Principal)

O Cursor possui integração nativa com modelos da Anthropic. A configuração é feita para que o Cursor utilize a chave de API gerenciada pelo 1Password.

1.  **Configuração de Modelo no Cursor:**
    - No Cursor, a configuração de modelos (`.cursor-settings` ou `config.json`) deve apontar para um modelo Claude (ex: `claude-3-opus-20240229`).
    - A chave de API **não** deve ser inserida diretamente na interface do Cursor.

2.  **Carregamento da Chave via Shell:**
    - O Cursor deve ser iniciado a partir de um terminal Zsh onde a variável de ambiente `ANTHROPIC_API_KEY` já foi exportada.
    - O `~/.zshrc` (ou um script invocado por ele) deve conter uma linha para carregar a chave, como:
      ```bash
      export ANTHROPIC_API_KEY=$(op read "op://<vault>/<item_name>/credential")
      ```
      *Nota: O script `auditar-1password-secrets...sh` geralmente gerencia a criação de um arquivo de ambiente (ex: `.env`) que é "sourceado" pelo shell, automatizando este processo.*

3.  **Uso do System Prompt Universal:**
    - Para interações de chat ou edições via "Cmd+K", o conteúdo do `system_prompt_global.txt` ou prompts específicos (como o `PROMPT_GEMINI_...` que você está executando) deve ser usado para contextualizar o Claude.
    - O `.cursorrules` no repositório pode ser configurado para injetar automaticamente contextos específicos em arquivos ou diretórios.

### 4.2. Integração com VS Code (IDE Secundário)

A integração no VS Code depende de extensões de terceiros ou da extensão oficial da Anthropic, se disponível.

1.  **Instalar a Extensão:**
    - Procure por "Claude" ou "Anthropic" no Marketplace de Extensões do VS Code e instale a extensão mais adequada e segura.

2.  **Configurar a Extensão:**
    - Nas configurações da extensão (`settings.json`), localize o campo para a chave de API.
    - **Não cole a chave diretamente.** Em vez disso, a extensão deve ser capaz de ler a partir de uma variável de ambiente.
    - Se a extensão suportar, ela usará automaticamente a variável `ANTHROPIC_API_KEY` que já foi exportada no seu shell. Se não, verifique a documentação da extensão para saber qual variável ela espera (ex: `CLAUDE_API_KEY`).

---

## 5. Boas Práticas e Fluxo de Trabalho

-   **Use o `auditar-1password-secrets...sh`:** Antes de iniciar uma sessão de desenvolvimento, execute este script para garantir que todas as chaves de API, incluindo a do Claude, estão corretamente exportadas como variáveis de ambiente.
-   **Contexto é Rei:** Ao usar o Claude para tarefas complexas, sempre forneça o máximo de contexto relevante. Utilize os prompts do repositório como base.
-   **Verificação de Segurança:** Periodicamente, verifique se a chave da API não foi vazada para arquivos de log, configurações de IDE não versionadas ou outros locais inseguros. O ambiente configurado neste repositório minimiza esse risco ao centralizar tudo no 1Password.
