# Guia de Setup – Perplexity Pro

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Visão Geral

O Perplexity Pro ocupa um nicho específico e crucial neste ecossistema: o de **mecanismo de pesquisa e verificação de fatos**. Enquanto outras IAs geram conteúdo, o Perplexity se destaca por fornecer respostas baseadas em fontes da web, com citações e referências diretas.

Seu papel não é o de um assistente de código primário, mas sim o de uma ferramenta de apoio para pesquisa técnica, validação de informações e descoberta de novas tecnologias. O uso é predominantemente através da sua interface web.

---

## 2. Pré-requisitos

1.  **Conta Perplexity:** Uma conta ativa, preferencialmente com a assinatura "Pro" para acesso a modelos mais avançados (como Claude 3 e GPT-4) e limites de uso mais altos.
2.  **Navegador Web:** Um navegador moderno para acessar a interface do Perplexity.

---

## 3. Configuração de Perfil e "Custom Instructions"

Assim como o ChatGPT, o Perplexity permite a configuração de um perfil para guiar suas respostas.

1.  **Acesse as Configurações de Perfil:**
    - Na interface web do Perplexity, clique em seu avatar ou nome de perfil.
    - Navegue até a seção "Profile" ou "AI Profile".

2.  **Preencha o "AI Profile":**
    - O campo de perfil é um único bloco de texto. Use-o para fornecer um resumo conciso do seu contexto e do formato de resposta esperado. A estratégia é similar à do ChatGPT.
    - Combine o contexto do usuário e as regras de resposta em um único prompt.

    **Exemplo de conteúdo para o "AI Profile":**
    ```text
    # MEU CONTEXTO E PREFERÊNCIAS DE RESPOSTA

    ## Sobre Mim e Meu Ambiente:
    - Sou um desenvolvedor trabalhando em um macOS (Apple Silicon) com Zsh.
    - Meu foco é a automação de infraestrutura e a integração de sistemas de IA.
    - Utilizo um ecossistema com Gemini 3.0 Pro, Claude Code Pro, ChatGPT e LLMs locais via Ollama.
    - A segurança é crítica; todos os segredos são gerenciados pelo 1Password CLI.

    ## Como Você Deve Responder:
    1.  **Linguagem:** Responda sempre em Português do Brasil.
    2.  **Foco em Fontes:** Sua principal função para mim é pesquisa. SEMPRE priorize respostas baseadas em fontes e inclua as citações de forma clara.
    3.  **Respostas Técnicas:** Forneça respostas diretas e técnicas. Para perguntas sobre código, inclua exemplos práticos e links para documentação oficial.
    4.  **Seja Conciso:** Vá direto ao ponto, mas sem sacrificar a precisão ou as fontes.
    5.  **Reconheça seu Papel:** Entenda que você atua como um mecanismo de pesquisa e validação, complementando outras IAs que eu uso para geração de conteúdo.
    ```

3.  **Salvar o Perfil:**
    - Salve as alterações. Todas as suas futuras pesquisas ("threads") usarão este perfil como contexto base.

---

## 4. Casos de Uso Ideais no Ecossistema

-   **Validação de Informação:** Quando o ChatGPT ou Claude gera uma informação técnica (ex: uma flag de um comando CLI, o nome de um pacote, uma configuração de API), use o Perplexity para verificar a veracidade e encontrar a documentação oficial.
-   **Pesquisa de Novas Ferramentas:** Para explorar novas tecnologias mencionadas em discussões (ex: "o que é DeepAgent?"), o Perplexity é ideal para obter um resumo rápido com links para os projetos e artigos relevantes.
-   **Resolução de Erros:** Copiar e colar mensagens de erro no Perplexity pode rapidamente levar a threads em fóruns (Stack Overflow, GitHub Issues) ou posts de blog que discutem o mesmo problema e suas soluções.
-   **Busca de "Boas Práticas":** Perguntas como "melhores práticas para gerenciar o PATH no Zsh" ou "como configurar o `gpg-agent` no macOS" são perfeitas para o Perplexity, pois ele pode sintetizar informações de múltiplos guias e artigos.

---

## 5. Limites e Convivência com Outras Ferramentas

-   **Não é um Gerador de Código Primário:** Evite usar o Perplexity para gerar grandes blocos de código ou refatorar arquivos inteiros. Ferramentas como Claude Code Pro e Copilot são mais adequadas para isso. O Perplexity brilha ao *encontrar* exemplos de código, não ao *criá-los* do zero.
-   **Conflito de Contexto:** Lembre-se de que o contexto do Perplexity é gerenciado separadamente do contexto das suas IDEs (Cursor, VS Code). Informações de um não são automaticamente transferidas para o outro. O fluxo de trabalho é: **Pesquisar no Perplexity → Validar a informação → Aplicar o conhecimento na IDE.**
-   **Foco no "Pro":** A assinatura Pro permite que você troque o modelo de busca subjacente (ex: usar Claude 3 para respostas mais elaboradas). Use essa funcionalidade para ajustar a profundidade da resposta conforme sua necessidade.
