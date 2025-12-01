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
