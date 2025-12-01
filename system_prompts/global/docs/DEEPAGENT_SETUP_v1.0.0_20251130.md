# Guia de Setup – DeepAgent

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Visão Geral

O DeepAgent (ou um orquestrador de agentes de IA similar) representa a camada de **automação de alto nível** no ecossistema. Enquanto ferramentas como Gemini CLI executam tarefas discretas e os assistentes de código auxiliam no desenvolvimento, o DeepAgent é projetado para gerenciar fluxos de trabalho complexos, multi-etapas e que podem envolver múltiplas ferramentas.

Seu papel é atuar como um "gerente de projeto" de IA, capaz de:
- Ler um objetivo de alto nível.
- Quebrar o objetivo em tarefas menores.
- Executar código, interagir com APIs e utilizar outras ferramentas para completar as tarefas.
- Relatar o progresso e os resultados.

---

## 2. Pré-requisitos

1.  **Conta na Plataforma do Agente:** Acesso à plataforma do DeepAgent (ou similar).
2.  **Chave de API:** Uma chave de API para autenticar as interações com o serviço.
3.  **Ambiente de Execução Seguro:** Um local seguro para o agente executar suas tarefas, como um contêiner Docker ou uma VPS dedicada, para isolar suas ações do sistema principal.
4.  **1Password CLI:** Para o fornecimento seguro da chave de API do próprio DeepAgent e de outras chaves que ele possa precisar (ex: GitHub, OpenAI).

---

## 3. Configuração de Segurança

A chave de API do DeepAgent é extremamente sensível, pois concede a capacidade de executar ações em seu nome.

1.  **Salvar a Chave no 1Password:**
    - Crie um novo item "Chave de API" no 1Password.
    - Nomeie-o `DeepAgent API Key`.
    - Salve a chave e adicione a tag `api-key`.

2.  **Fornecimento ao Ambiente de Execução:**
    - A chave **nunca** deve ser passada como um argumento de linha de comando ou embutida em um script não criptografado.
    - Ao iniciar o ambiente do DeepAgent (ex: um contêiner Docker), a chave deve ser injetada como uma **variável de ambiente**.
    - Exemplo de como isso pode ser feito com Docker:
      ```bash
      # Carrega a chave do 1Password para uma variável local
      DEEPAGENT_KEY=$(op read "op://<vault>/DeepAgent API Key/credential")

      # Inicia o contêiner injetando a chave como uma variável de ambiente
      docker run -e DEEPAGENT_API_KEY="$DEEPAGENT_KEY" --rm -it nome_da_imagem_do_agente
      ```

---

## 4. Integração e Fluxos de Trabalho

### 4.1. Alimentando o Agente com Contexto

Para que o DeepAgent funcione de forma eficaz neste repositório, ele precisa do mesmo contexto que as outras IAs.

-   **System Prompt Universal:** O conteúdo do `system_prompt_global.txt` ou do `GEMINI.md` deve ser fornecido como parte da instrução inicial (o "objetivo") para o agente.
-   **Contexto Específico da Tarefa:** Juntamente com o prompt global, forneça os arquivos ou a estrutura de diretórios relevantes para a tarefa em questão. Por exemplo, se a tarefa é "refatorar todos os scripts em `scripts/shared`", forneça o conteúdo desses scripts.

### 4.2. Fluxos de Trabalho Típicos

-   **Auditoria e Relatório Automatizado:**
    - **Objetivo:** "Analise todos os scripts `.sh` no diretório `scripts/` em busca de segredos hardcoded e gere um relatório em `reports/security_audit.md`."
    - **Ações do Agente:** O DeepAgent iria iterar pelos arquivos, analisar seu conteúdo e escrever o arquivo de relatório final.

-   **Integração com GitHub:**
    - **Objetivo:** "Abra uma nova issue no repositório `senal88/SYSTEM_PROMPT` descrevendo as lacunas de documentação encontradas no diretório `docs/`."
    - **Ações do Agente:** Para isso, o agente precisaria de um token do GitHub (também fornecido de forma segura via 1Password) e usaria o `gh` CLI ou a API do GitHub para realizar a tarefa.

-   **Orquestração com n8n:**
    - O DeepAgent pode ser o "cérebro" de um fluxo de trabalho no n8n.
    - **Exemplo:** Um gatilho no n8n (ex: um novo email) inicia um fluxo que invoca o DeepAgent com uma tarefa ("resuma este email e crie um rascunho de resposta"). O DeepAgent processa a tarefa e retorna o resultado para o n8n, que então continua o fluxo (ex: salva o rascunho no Drafts).

---

## 5. Boas Práticas e Limites

-   **Comece com Tarefas de Leitura:** Antes de dar ao DeepAgent permissão para modificar ou excluir arquivos, comece com tarefas que apenas leem dados e geram relatórios.
-   **Use Ambientes Isolados:** Sempre que possível, execute o agente em um contêiner Docker ou em uma VPS para limitar o "raio de explosão" caso ele se comporte de maneira inesperada.
-   **Monitore a Execução:** Acompanhe os logs e as ações do agente durante a execução para garantir que ele está seguindo o plano.
-   **Objetivos Claros e Concisos:** Forneça objetivos muito específicos. Em vez de "melhore o repositório", use "refatore o script `X` para usar a função `Y` e adicione comentários de cabeçalho".
