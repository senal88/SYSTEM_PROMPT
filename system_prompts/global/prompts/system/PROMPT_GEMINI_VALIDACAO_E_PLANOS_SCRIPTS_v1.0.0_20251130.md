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
