Ambiente e parâmetros considerados

* Host: macOS Tahoe 26.x (Apple Silicon), Zsh, dotfiles em `/Users/luiz.sena88/Dotfiles`.
* Repositório de prompts globais: `/Users/luiz.sena88/Dotfiles/system_prompts/global`.
* Subdiretório alvo: `/Users/luiz.sena88/Dotfiles/system_prompts/global/prompts/system`.

A seguir, comandos completos para criar **3 arquivos de prompt para Gemini CLI 3.0 Pro**, com **nomenclatura versionada e datada**, já no formato pronto para uso.

````bash
cd /Users/luiz.sena88/Dotfiles/system_prompts/global/prompts/system

cat <<'EOF' > PROMPT_GEMINI_SETUP_COMPLETO_IA_E_IDES_v1.0.0_20251130.md
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
  EOF

````

```bash
cat <<'EOF' > PROMPT_GEMINI_COMPLETAR_E_NORMALIZAR_ESTRUTURA_REPOSITORIO_v1.0.0_20251130.md
# PROMPT – Completar e Normalizar Estrutura Global do Repositório (Gemini CLI 3.0 Pro)

- Versão: 1.0.0  
- Última atualização: 2025-11-30  
- Destino: Gemini CLI 3.0 Pro (gemini-cli)  
- Categoria: Governança de Repositório & Estrutura  

## Objetivo

Instruir o Gemini 3.0 Pro a:

1. Encontrar e resolver todos os conflitos de merge Git (`<<<<<<< HEAD`, `=======`, `>>>>>>>`).  
2. Corrigir e completar o documento “System Prompt Universal para IAs Comerciais”.  
3. Normalizar a estrutura de diretórios e arquivos do repositório.  
4. Aplicar convenções de nome + versão + data em arquivos sob governança.

---

## Contexto das Ferramentas e Arquitetura

O repositório de “System Prompt Universal para IAs Comerciais” deve contemplar:

### IAs comerciais / cloud e code

- Claude Code Pro  
- ChatGPT Plus 5.1 Codex  
- Gemini 3.0 Pro  
- Perplexity Pro  
- DeepAgent  
- Codex 2.0  
- OpenAI API  

### Extensões / assistentes de código

- GitHub Copilot  
- Codeium  

### LLMs locais

- Ollama  
- LM Studio  

### IDEs

- Visual Studio Code (VS Code)  
- Cursor 2.1  

---

## Estrutura Esperada do Repositório

A estrutura lógica final desejada é:

```text
SYSTEM_PROMPT/
├── system_prompt_global.txt
├── prompts/
├── scripts/
│   ├── macos/
│   ├── ubuntu/
│   └── shared/
├── templates/
├── configs/
├── reports/
└── docs/
````

---

## Tarefa Principal para o Gemini

### 1. Identificar e Resolver Todos os Conflitos Git

1.1. Localizar todos os blocos de conflito no conteúdo fornecido:

```text
<<<<<<< HEAD
...
=======
...
>>>>>>> branch
```

1.2. Para cada conflito:

* Comparar cuidadosamente os dois lados.
* Escolher a versão que:

  * Preserve o máximo de informação útil.
  * Atualize referências antigas para o estado atual desejado:

    * Substituir “Gemini 2.5 Pro” ou similares por “Gemini 3.0 Pro”.
    * Garantir a inclusão de Perplexity Pro, DeepAgent, LLMs locais etc.
  * Mantenha coerência com a arquitetura e nomenclaturas.

1.3. Gerar como resultado final o conteúdo dos arquivos **sem nenhum marcador de conflito** (`<<<<<<<`, `=======`, `>>>>>>>`).

### 2. Normalizar a Estrutura Global do Repositório

2.1. Verificar se o repositório está alinhado com a estrutura esperada.

2.2. Caso existam divergências (pastas duplicadas, nomes diferentes, arquivos soltos):

* Propor uma **estrutura final consolidada**, explicitando:

  * Quais arquivos devem ser movidos.
  * Quais arquivos devem ser renomeados.
  * Como alinhar subdiretórios customizados à estrutura padrão.

2.3. Garantir compatibilidade com scripts existentes em `scripts/` sempre que possível, evitando quebrar fluxos automáticos.

### 3. Corrigir e Completar o Documento “System Prompt Universal para IAs Comerciais”

3.1. A partir da versão mais rica em conteúdo (após resolução de conflitos), gerar uma nova versão **completa**, contendo:

* Título:
  `# System Prompt Universal para IAs Comerciais`

* Seções mínimas:

  1. **Visão Geral**
  2. **Ferramentas Suportadas**:

     * Claude Code Pro
     * ChatGPT Plus 5.1 Codex
     * Gemini 3.0 Pro
     * Perplexity Pro
     * DeepAgent
     * Codex 2.0
     * OpenAI API
     * GitHub Copilot
     * Codeium
     * Ollama
     * LM Studio
  3. **Integração com IDEs**:

     * VS Code
     * Cursor 2.1
  4. **Estrutura do Projeto** (exibir árvore de diretórios atualizada).
  5. **Início Rápido**:

     * Clonagem / preparação
     * Execução de scripts principais
  6. **Documentação Completa**:

     * Lista de arquivos em `docs/` com breve descrição.
  7. **Scripts Principais**:

     * Lista dos scripts em `scripts/` com descrição (coleta, aplicação, validação, sincronização).
  8. **Automação**:

     * Uso de cron (Ubuntu), launch agents (macOS) e, se aplicável, CI/CD.
  9. **Requisitos**:

     * macOS, Ubuntu, linguagens, ferramentas etc.
  10. **Licença / Uso Interno**
  11. **Suporte** / como diagnosticar problemas.

* Incluir um bloco de versionamento no topo:

```text
Versão: X.Y.Z
Última atualização: AAAA-MM-DD
```

3.2. Garantir que todas as ferramentas citadas neste prompt estejam claramente mencionadas em “Ferramentas Suportadas” e/ou na documentação detalhada.

### 4. Padronizar Nomenclatura, Versões e Datas

4.1. Aplicar governança de nomes aos arquivos sob controle:

* Nome dos arquivos críticos deve seguir o padrão:
  `NOME_DESCRITIVO_vMAJOR.MINOR.PATCH_YYYYMMDD.ext`

Exemplos:

* `SETUP_COMPLETO_IA_E_IDES_v1.0.0_20251130.md`
* `SYSTEM_PROMPT_UNIVERSAL_v1.1.0_20251201.md`

4.2. Dentro de cada arquivo governado, incluir obrigatoriamente:

```text
Versão: X.Y.Z
Última atualização: AAAA-MM-DD
```

4.3. Para cada arquivo crítico que não segue a convenção, retornar:

* Nome atual.
* Nome sugerido dentro do padrão.
* Ajustes de cabeçalho interno necessários.

---

## Saída Esperada do Gemini

Retornar:

1. Um **resumo em Markdown** com:

   * Lista de arquivos com conflitos encontrados e como foram resolvidos.
   * Estrutura final sugerida do repositório.
   * Lista de arquivos a serem renomeados/movidos (com nomes sugeridos).

2. O **conteúdo final e sem conflitos** de:

   * README principal do repositório (se existir).
   * Documento “System Prompt Universal para IAs Comerciais”.
   * Quaisquer outros arquivos que contenham conflitos Git.

Todos os arquivos retornados devem estar prontos para serem salvos diretamente, sem marcas de conflito residuais.

---

## Requisitos de Estilo

* Linguagem técnica, objetiva, em português do Brasil.
* Conteúdo pronto para uso direto em arquivos Markdown do repositório.
* Nenhuma marca de conflito, texto parcialmente comentado ou bloco inconsistente.
  EOF

````

```bash
cat <<'EOF' > PROMPT_GEMINI_VALIDACAO_E_PLANOS_SCRIPTS_v1.0.0_20251130.md
# PROMPT – Validação Final e Plano de Correção Automatizada (Gemini CLI 3.0 Pro)

- Versão: 1.0.0  
- Última atualização: 2025-11-30  
- Destino: Gemini CLI 3.0 Pro (gemini-cli)  
- Categoria: Validação & Automação com Scripts  

## Objetivo

Instruir o Gemini 3.0 Pro a:

1. Validar o estado final do repositório de “System Prompt Universal para IAs Comerciais”.  
2. Confirmar cobertura completa de todas as ferramentas e IDEs.  
3. Gerar um plano detalhado de correção automatizada via scripts.  
4. Produzir os modelos completos dos scripts bash necessários.

---

## Ecossistema Esperado

O estado final do repositório deve contemplar, de forma explícita, as ferramentas e ambientes abaixo.

### IAs comerciais / cloud e code

- Claude Code Pro  
- ChatGPT Plus 5.1 Codex  
- Gemini 3.0 Pro  
- Perplexity Pro  
- DeepAgent  
- Codex 2.0  
- OpenAI API  

### Extensões / assistentes de código

- GitHub Copilot  
- Codeium  

### LLMs locais

- Ollama  
- LM Studio  

### IDEs

- Visual Studio Code (VS Code)  
- Cursor 2.1  

---

## Tarefa Principal para o Gemini

### 1. Validação Estruturada do Estado Final

1.1. Confirmar que:

- Todas as ferramentas listadas estão mencionadas de forma clara:
  - No documento “System Prompt Universal para IAs Comerciais”; e/ou
  - Em arquivos dedicados em `docs/`.  

- Existem (ou foram gerados) os seguintes arquivos em `docs/`:

  - `docs/SETUP_COMPLETO_IA_E_IDES.md`  
  - `docs/CLAUDE_SETUP.md`  
  - `docs/CHATGPT_SETUP.md`  
  - `docs/GEMINI_SETUP.md`  
  - `docs/PERPLEXITY_SETUP.md`  
  - `docs/DEEPAGENT_SETUP.md`  
  - `docs/CODEX2_SETUP.md`  
  - `docs/COPILOT_SETUP.md`  
  - `docs/CODEIUM_SETUP.md`  
  - `docs/OPENAI_API_SETUP.md`  
  - `docs/OFFLINE_LLMS_SETUP.md`  
  - Documento “System Prompt Universal para IAs Comerciais” (nomeado conforme governança).  

1.2. Verificar se todos os arquivos críticos possuem:

- Nome de arquivo seguindo o padrão de governança:

  ```text
  NOME_DESCRITIVO_vMAJOR.MINOR.PATCH_YYYYMMDD.ext
````

* Cabeçalho interno com:

  ```text
  Versão: X.Y.Z
  Última atualização: AAAA-MM-DD
  ```

1.3. Onde esse padrão não for seguido, registrar explicitamente as não conformidades.

---

### 2. Plano de Correção Automática via Scripts

2.1. Gerar um **plano em formato de tabela Markdown** com as colunas:

* `ARQUIVO_ATUAL`
* `ARQUIVO_DESEJADO`
* `AÇÃO` (renomear, mover, atualizar conteúdo, ajustar cabeçalho)
* `PRIORIDADE` (alta, média, baixa)

2.2. A partir desse plano, descrever os scripts bash necessários, distribuídos em:

* `scripts/shared/`
* `scripts/macos/`
* `scripts/ubuntu/`

Para cada script, especificar:

* Nome do script (ex.: `atualizar_nomes_governanca.sh`).
* Objetivo exato (renomear, validar, ajustar cabeçalhos etc.).
* Entradas esperadas (por exemplo, diretório base, data/versão via variável).
* Saídas (arquivos atualizados, logs, relatórios em `reports/` ou `logs/`).

2.3. As funções esperadas dos scripts incluem, no mínimo:

* Renomear arquivos para o padrão de governança.
* Atualizar cabeçalhos de versão/data dentro dos arquivos.
* Validar consistência de estrutura (uso de `find`, `tree`, etc.).
* Gerar relatórios de auditoria (por exemplo, `reports/relatorio_validacao_system_prompt.md`).

---

### 3. Geração de Modelos Completos de Scripts Bash

3.1. Fornecer o **conteúdo completo**, pronto para salvar, de scripts bash como:

1. `scripts/shared/atualizar_nomes_governanca.sh`
2. `scripts/shared/validar_estrutura_system_prompt.sh`
3. `scripts/macos/aplicar_setup_ia_macos.sh`
4. `scripts/ubuntu/aplicar_setup_ia_ubuntu.sh`

3.2. Requisitos para cada script:

* Shell: bash (POSIX compatível sempre que possível).
* Idempotência: o script pode ser executado várias vezes sem quebrar o ambiente.
* Logs:

  * Gerar logs e/ou relatórios claros em diretórios como `reports/` ou `logs/`.
* Parametrização:

  * Utilizar variáveis para diretórios base, versão, data (por exemplo: `BASE_DIR`, `VERSAO_ALVO`, `DATA_REFERENCIA`).
* Segurança:

  * Não embutir segredos diretamente no código.
  * Utilizar apenas variáveis de ambiente ou placeholders claramente indicados para segredos.

3.3. Cada script deve conter:

* Comentário inicial com:

  * Nome
  * Objetivo
  * Versão
  * Data
* Bloco de ajuda (`-h`/`--help`) opcional, explicando uso e parâmetros.

---

## Saída Esperada do Gemini

Retornar:

1. Uma seção de **Validação** em Markdown, contendo:

   * Lista de conformidades e não conformidades encontradas.
   * Confirmação de que todas as ferramentas e IDEs estão cobertas.

2. A **tabela de Plano de Correção Automática** em Markdown.

3. O **conteúdo completo** dos scripts bash propostos, prontos para serem salvos nos caminhos:

* `scripts/shared/atualizar_nomes_governanca.sh`
* `scripts/shared/validar_estrutura_system_prompt.sh`
* `scripts/macos/aplicar_setup_ia_macos.sh`
* `scripts/ubuntu/aplicar_setup_ia_ubuntu.sh`

---

## Requisitos de Estilo

* Linguagem técnica, em português do Brasil.
* Scripts comentados, claros e objetivos.
* Não assumir acesso direto a segredos; trabalhar sempre via variáveis/integrações externas.
  EOF

```

Com esses comandos, os três prompts ficam criados, versionados e prontos para uso direto no Gemini CLI 3.0 Pro dentro do subdiretório `prompts/system`.
```

