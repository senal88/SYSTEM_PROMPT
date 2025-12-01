# Guia de Setup – ChatGPT Plus 5.1 Codex

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Visão Geral

ChatGPT, especialmente com os modelos avançados como o GPT-4/Codex (referenciado aqui como 5.1), é uma ferramenta central para brainstorming, geração de texto, e prototipagem rápida de código. Diferente de IAs integradas à IDE, seu uso principal é através da interface web, o que exige uma estratégia diferente para a aplicação de prompts de sistema.

Este guia detalha como configurar e sincronizar o "System Prompt Universal" com o ChatGPT em diferentes plataformas.

---

## 2. Pré-requisitos

1.  **Conta OpenAI:** Uma conta ativa com assinatura ChatGPT Plus é necessária para acessar os modelos mais avançados e funcionalidades como "Custom Instructions".
2.  **Chave de API (Opcional):** Para uso programático via `OpenAI API`, uma chave de API é necessária. Consulte o guia `docs/OPENAI_API_SETUP.md` para detalhes. Este guia foca no uso da interface web.

---

## 3. Configuração via "Custom Instructions"

A funcionalidade "Custom Instructions" (Instruções Personalizadas) é o método primário para garantir que o ChatGPT responda de forma consistente e alinhada à governança do repositório.

1.  **Acesse as Configurações:**
    - Na interface web do ChatGPT, clique no seu nome de perfil (canto inferior esquerdo).
    - Selecione "Custom Instructions".

2.  **Preencha os Campos:**
    A tela é dividida em dois campos. A estratégia é usar o primeiro para o contexto do usuário e o segundo para o formato de resposta desejado.

    -   **Campo 1: "What would you like ChatGPT to know about you to provide better responses?"**
        (O que você gostaria que o ChatGPT soubesse sobre você para fornecer respostas melhores?)

        Aqui, você deve colar uma versão concisa do contexto do seu ambiente. Use como base o `system_prompt_global.txt`, mas foque nos pontos-chave:
        ```text
        # CONTEXTO DO MEU AMBIENTE
        - **Sistema:** macOS (Apple Silicon) com Zsh como shell padrão.
        - **Repositório Principal:** Gerencio um repositório de dotfiles em ~/Dotfiles.
        - **Ecossistema de Ferramentas:** Meu ambiente inclui:
          - **IDEs:** Cursor 2.1 (principal), VS Code (secundário).
          - **IAs:** Gemini 3.0 Pro, Claude Code Pro, GitHub Copilot, Perplexity Pro, LLMs locais (Ollama).
          - **Segurança:** 1Password CLI (`op`) é a única fonte para segredos e chaves de API.
        - **Governança:** Sigo uma política rigorosa de nomenclatura de arquivos (versão + data) e automação via scripts.
        - **Objetivo:** Busco respostas técnicas, precisas e alinhadas com as melhores práticas de automação e segurança.
        ```

    -   **Campo 2: "How would you like ChatGPT to respond?"**
        (Como você gostaria que o ChatGPT respondesse?)

        Aqui, você define o comportamento e o estilo de saída do assistente.
        ```text
        # FORMATO E REGRAS DE RESPOSTA
        1.  **Linguagem:** Responda sempre em Português do Brasil.
        2.  **Foco em Evidências:** Baseie suas respostas em fatos e, quando aplicável, peça por contexto adicional em vez de supor.
        3.  **Código e Scripts:** Ao gerar scripts, prefira `bash` ou `zsh` e siga as melhores práticas (ex: `set -euo pipefail`). Para scripts complexos, use o formato `cat <<'EOF' > nome_do_script.sh`.
        4.  **Segurança:** Nunca peça ou manipule segredos (chaves de API, senhas). Em vez disso, refira-se ao uso do 1Password CLI (`op read ...`).
        5.  **Estrutura:** Use Markdown (listas, títulos, blocos de código) para estruturar suas respostas de forma clara.
        6.  **Versionamento:** Ao criar conteúdo para arquivos, inclua um cabeçalho com Versão e Data da Última Atualização.
        ```

3.  **Ative para Novos Chats:** Certifique-se de que a opção "Enable for new chats" esteja ativada e salve as alterações.

---

## 4. Estratégia de Sincronização e Versionamento

Manter as "Custom Instructions" atualizadas em múltiplos dispositivos (navegador do desktop, app móvel) pode ser um desafio.

-   **Fonte da Verdade:** O arquivo `system_prompt_global.txt` (ou um derivado dele) no repositório `system_prompts/global` deve ser a fonte da verdade.
-   **Atualização Manual:** Atualmente, o processo é manual. Sempre que houver uma mudança significativa no seu ambiente ou nas regras de governança, você deve copiar e colar o conteúdo atualizado do arquivo de prompt para os campos de "Custom Instructions" no ChatGPT.
-   **Bloco de Versionamento:** Incluir um bloco de versionamento no início do seu prompt personalizado (no campo 1) é uma boa prática para saber qual versão do seu prompt está ativa. Exemplo:
    ```
    # PROMPT v1.1.0 (2025-11-30)
    ... resto do prompt ...
    ```
    Isso ajuda a garantir consistência e a lembrar quando uma atualização é necessária.

---

## 5. Limitações

-   **Limite de Caracteres:** As "Custom Instructions" do ChatGPT têm um limite de caracteres (atualmente 1500 por campo). Por isso, é crucial usar uma versão concisa e bem resumida do seu System Prompt Universal.
-   **Falta de Automação:** A sincronização não é automática. É uma disciplina que precisa ser mantida manualmente para garantir a consistência do assistente.
