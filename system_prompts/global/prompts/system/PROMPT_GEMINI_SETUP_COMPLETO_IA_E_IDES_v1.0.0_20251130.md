# PROMPT – Setup Completo de IAs Comerciais, LLMs Locais e IDEs (Gemini CLI 3.0 Pro)

- Versão: 1.0.0  
- Última atualização: 2025-11-30  
- Destino: Gemini CLI 3.0 Pro (gemini-cli)  
- Categoria: Setup & Integração Global de Ferramentas de IA e IDEs  

## Objetivo

Instruir o Gemini 3.0 Pro (via CLI/API) a:

1. Auditar o repositório de “System Prompt Universal para IAs Comerciais”.
2. Levantar lacunas de documentação e configuração.
3. Gerar/atualizar documentação de setup para:
   - IAs comerciais
   - Assistentes de código
   - LLMs locais (offline)
   - IDEs (VS Code, Cursor 2.1)
4. Produzir arquivos de documentação prontos para salvar em `docs/`.

---

## Escopo de Ferramentas a Considerar

### IAs comerciais / cloud e code

1. Claude Code Pro  
2. ChatGPT Plus 5.1 Codex  
3. Gemini 3.0 Pro (CLI/API)  
4. Perplexity Pro  
5. DeepAgent  
6. Codex 2.0  
7. OpenAI API (modelos e endpoints próprios)

### Extensões / assistentes de código

8. GitHub Copilot  
9. Codeium  

### LLMs locais (offline)

10. Ollama  
11. LM Studio  

### IDEs e ambientes

- Visual Studio Code (VS Code)  
- Cursor 2.1  

---

## Contexto do Repositório (Estrutura Esperada)

Considere que o repositório possui (ou deve possuir) uma estrutura equivalente a:

```text
SYSTEM_PROMPT/
├── system_prompt_global.txt        # Prompt universal consolidado
├── prompts/                        # Prompts específicos por ferramenta/uso
├── scripts/
│   ├── macos/                      # Scripts para macOS Silicon
│   ├── ubuntu/                     # Scripts para VPS Ubuntu
│   └── shared/                     # Scripts compartilhados
├── templates/                      # Templates de saída
├── configs/                        # Configurações geradas
├── reports/                        # Relatórios gerados
└── docs/                           # Documentação completa
````

Existe (ou deve existir) um documento central chamado:

> “System Prompt Universal para IAs Comerciais”

responsável por:

* Explicar o propósito do sistema de prompts universais.
* Listar as ferramentas suportadas (todas as citadas neste prompt).
* Descrever a estrutura padrão do projeto (pastas, arquivos, convenções).
* Referenciar scripts de coleta, aplicação, validação e sincronização.
* Apontar para a documentação específica por ferramenta e por IDE.

---

## Tarefa Principal para o Gemini

**Instrução geral:**
A partir de TODO o conteúdo real do repositório fornecido como contexto (árvore de diretórios, READMEs, arquivos em `docs/`, scripts em `scripts/`, conteúdos de `prompts/` e `system_prompt_global.txt`), execute as etapas abaixo.

### 1. Auditoria Completa de Setup de IAs e IDEs

1.1. Identificar todos os arquivos e diretórios que tratam explicitamente de:

* Claude Code Pro
* ChatGPT Plus 5.1 Codex
* Gemini 3.0 Pro
* Perplexity Pro
* DeepAgent
* Codex 2.0
* GitHub Copilot
* Codeium
* OpenAI API
* Ollama
* LM Studio
* VS Code
* Cursor 2.1

1.2. Produzir um diagnóstico em formato Markdown, listando:

* Pontos já bem documentados.
* Lacunas / assuntos não cobertos.
* Inconsistências (por exemplo, referências a “Gemini 2.5” em vez de “Gemini 3.0 Pro”, ausência de Perplexity Pro, falta de menção a LLMs offline etc.).

### 2. Desenhar o Setup Completo por Ferramenta

Para cada ferramenta listada abaixo, gerar um bloco de documentação em Markdown, pronto para ser salvo em `docs/` com o nome indicado:

#### 2.1. Claude Code Pro → `docs/CLAUDE_SETUP.md`

* Pré-requisitos (conta, API, permissões).
* Integração com:

  * VS Code
  * Cursor 2.1
* Como aplicar o “System Prompt Universal” ou subprompts relevantes no contexto do Claude Code Pro.
* Boas práticas de segurança (segredos em cofre, variáveis de ambiente, tokens etc.).

#### 2.2. ChatGPT Plus 5.1 Codex → `docs/CHATGPT_SETUP.md`

* Uso de “Custom Instructions / Instruções Personalizadas” para carregar o System Prompt Universal.
* Estratégia para espelhar o mesmo contexto em diferentes dispositivos (macOS, navegador etc.).
* Estrutura mínima recomendada do system prompt:

  * Identidade do assistente
  * Ambiente (macOS + VPS)
  * Governança e regras de segurança
  * Lista de ferramentas/LLMs utilizadas
  * Estratégia de versionamento:
  * Como registrar versão e data em um bloco padrão.

#### 2.3. Gemini 3.0 Pro (CLI/API) → `docs/GEMINI_SETUP.md`

* Como instalar/configurar o Gemini CLI 3.0 Pro para atuar como “motor de auditoria/correção” do repositório.
* Padrões de chamada:

  * Formas de passar entrada (texto, arquivos, JSON).
  * Formatos de saída recomendados (Markdown, JSON).
* Exemplos de uso:

  * Auditoria de repo
  * Correção de README
  * Geração de scripts
* Boas práticas de segurança (tokens via variáveis de ambiente, cofres etc.).

#### 2.4. Perplexity Pro → `docs/PERPLEXITY_SETUP.md`

* Como configurar perfis / “Custom Instructions” no Perplexity Pro (quando aplicável).
* Como alinhar as respostas ao System Prompt Universal (ex.: estilo, foco em evidências, citações).
* Casos de uso ideais:

  * Pesquisa contextual
  * Verificação cruzada de fatos
  * Complemento a outras IAs (ChatGPT, Gemini etc.).
* Limites e boas práticas para evitar conflitos de contexto com outras ferramentas.

#### 2.5. DeepAgent → `docs/DEEPAGENT_SETUP.md`

* Papel do DeepAgent na arquitetura (ou orquestrador multiagente, automações etc.).
* Fluxos de trabalho típicos:

  * Integração com GitHub
  * Execução de código
  * Integração com n8n/outros orquestradores
* Como alimentá-lo com o System Prompt Universal e subprompts específicos.

#### 2.6. Codex 2.0 → `docs/CODEX2_SETUP.md`

* Ambientes onde o Codex 2.0 é utilizado (APIs, IDEs).
* Estratégias para alinhar o estilo de código ao definido pelo System Prompt Universal.
* Cuidados em refactors automáticos e operações perigosas (remoção de arquivos, alterações em massa).

#### 2.7. GitHub Copilot → `docs/COPILOT_SETUP.md`

* Integração com VS Code (e outras IDEs relevantes).
* Como orientar o Copilot por meio de:

  * Comentários guia
  * Snippets
  * Arquivos auxiliares de contexto
* Estratégia de convivência com Claude, Gemini, Perplexity e outros assistentes de código.

#### 2.8. Codeium → `docs/CODEIUM_SETUP.md`

* Integração em IDEs suportadas.
* Ajuste do comportamento para não conflitar com Copilot/Claude.
* Casos de uso preferenciais em relação aos demais assistentes.

#### 2.9. OpenAI API → `docs/OPENAI_API_SETUP.md`

* Configuração de chaves, endpoints e modelos.
* Como aplicar o System Prompt Universal em chamadas de API (código de exemplo).
* Padrões recomendados de logging, retries e observabilidade.

#### 2.10. LLMs Locais (Ollama / LM Studio) → `docs/OFFLINE_LLMS_SETUP.md`

* Conceito de ambiente offline: quando e por que utilizar.
* Como configurar:

  * Ollama (modelos locais e comando de execução)
  * LM Studio (interface, modelos, servidor local)
* Como sincronizar o System Prompt Universal:

  * Arquivos de prompt
  * Perfis locais de chat
* Boas práticas:

  * Privacidade
  * Latência
  * Tuning básico.

### 3. Detalhar Setup por IDE (VS Code e Cursor 2.1)

#### 3.1. VS Code

* Lista de extensões obrigatórias e recomendadas:

  * Claude
  * GitHub Copilot
  * Codeium
  * Integrações com Gemini/Perplexity/OpenAI, se existirem
* Arquivos de configuração:

  * `settings.json`
  * `keybindings.json`
  * Snippets (se utilizados)
* Estratégia de carregamento dos prompts globais:

  * Snippets
  * Extensões
  * Arquivos auxiliares no workspace

#### 3.2. Cursor 2.1

* Uso de `.cursorrules` e arquivos de sistema.
* Como incorporar:

  * System Prompt Universal
  * Prompts auxiliares por stack/projeto
* Estratégia de múltiplos modelos dentro do Cursor (Claude, Gemini etc.).
* Regras para garantir consistência de contexto com VS Code e demais ferramentas.

### 4. Produzir Visão Global Unificada de Setup

4.1. Gerar um arquivo em Markdown com o título:

> `SETUP_COMPLETO_IA_E_IDES`

4.2. Estrutura obrigatória do documento:

* Visão geral do ecossistema de IAs e IDEs.
* Tabela relacionando **Ferramenta x Finalidade x Local de Uso**.
* Diagrama textual de integrações (quem conversa com quem, e como).
* Passo a passo para:

  * Configurar tudo do zero em um macOS novo.
  * Replicar parte do setup relevante na VPS Ubuntu.
* Referências cruzadas para cada arquivo de `docs/` gerado na etapa 2.

### 5. Saída Esperada do Gemini

Retornar:

5.1. Um **Resumo Executivo** em Markdown com:

* Principais decisões de arquitetura.
* Diferença entre estado atual x estado desejado.
* Lista de arquivos a criar/atualizar em `docs/`.

5.2. O **conteúdo completo**, pronto para salvar, dos arquivos:

* `docs/SETUP_COMPLETO_IA_E_IDES.md`
* `docs/CLAUDE_SETUP.md`
* `docs/CHATGPT_SETUP.md`
* `docs/GEMINI_SETUP.md`
* `docs/PERPLEXITY_SETUP.md`
* `docs/DEEPAGENT_SETUP.md`
* `docs/CODEX2_SETUP.md`
* `docs/COPILOT_SETUP.md`
* `docs/CODEIUM_SETUP.md`
* `docs/OPENAI_API_SETUP.md`
* `docs/OFFLINE_LLMS_SETUP.md`

---

## Requisitos de Estilo e Governança

* Linguagem: técnica, clara, em português do Brasil.
* Estrutura: usar títulos, subtítulos, listas e tabelas conforme necessário.
* Versionamento:

  * Incluir em cada arquivo gerado:

    * “Versão: X.Y.Z”
    * “Última atualização: AAAA-MM-DD”
* Documentação deve permitir que outra pessoa replique todo o setup apenas seguindo os arquivos gerados.
