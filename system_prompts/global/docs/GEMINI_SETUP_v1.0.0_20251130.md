# Guia de Setup – Gemini 3.0 Pro (CLI/API)

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Visão Geral

Neste ecossistema, o Gemini 3.0 Pro (referido como Gemini) desempenha o papel central de **motor de orquestração, auditoria e automação**. Diferente de outras IAs que atuam primariamente como assistentes de código ou chat, o Gemini é utilizado via CLI e API para executar tarefas complexas sobre a base de código do repositório, como gerar documentação, corrigir scripts e validar a estrutura.

Este guia detalha como configurar o Gemini CLI e prepará-lo para interagir de forma segura e eficaz com o projeto `system_prompts/global`.

---

## 2. Pré-requisitos

1. **Conta Google Cloud / AI Studio:** É necessário ter uma conta Google com acesso à plataforma Vertex AI ou Google AI Studio.
2. **Chave de API:** Uma chave de API (API Key) para o Gemini deve ser gerada.
3. **1Password e CLI:** O 1Password CLI (`op`) é obrigatório para o gerenciamento seguro da chave de API.
4. **Gemini CLI (ou `aistudio`):** A ferramenta de linha de comando para interagir com o Gemini deve estar instalada. A instalação geralmente é feita via `npm` ou outro gerenciador de pacotes. Os scripts de setup do repositório (`scripts/setup/...`) devem cuidar disso.

---

## 3. Configuração de Segurança (Chave de API)

A segurança é primordial. A chave de API do Gemini NUNCA deve ser exposta em texto plano.

1. **Salvar a Chave no 1Password:**
    - Crie um item do tipo "Chave de API" no 1Password.
    - Nomeie-o como `Gemini API Key`.
    - Salve a chave gerada no campo de credencial.
    - Adicione a tag `api-key` para que os scripts de auditoria a encontrem.

2. **Exportação via Variável de Ambiente:**
    - O `~/.zshrc` (no macOS) ou `~/.bashrc` (na VPS) deve ser configurado para exportar a chave para a variável de ambiente padrão que o Gemini CLI espera, geralmente `GOOGLE_API_KEY` ou `GEMINI_API_KEY`.
    - O método preferencial é usar o `op` para carregar a variável dinamicamente:

      ```bash
      export GOOGLE_API_KEY=$(op read "op://Development/Google Gemini API Key/credential")
      export GEMINI_API_KEY="$GOOGLE_API_KEY"
      ```

    - **Script Automatizado:** Use o script `~/Dotfiles/scripts/load_ai_keys.sh` que carrega todas as chaves de IA:

      ```bash
      source ~/Dotfiles/scripts/load_ai_keys.sh
      ```

    - O script `scripts/auditar-1password-secrets_v1.0.0_20251130.sh` automatiza essa verificação e exportação.

3. **Verificar Configuração:**

    ```bash
    # Testar se a chave está acessível
    op read "op://Development/Google Gemini API Key/credential" > /dev/null && echo "✅ Chave acessível"

    # Verificar variável de ambiente
    echo $GOOGLE_API_KEY | grep -q "AIza" && echo "✅ Variável carregada" || echo "❌ Variável não definida"
    ```

---

## 4. Padrões de Chamada do Gemini CLI

O Gemini CLI é invocado no terminal para processar informações e gerar artefatos.

### 4.1. Formas de Passar Contexto (Entrada)

- **Texto direto (Prompting Simples):**

    ```bash
    gemini "Traduza 'hello world' para português."
    ```

- **Pipe (`|`) para Arquivos ou Saídas de Comando:** Esta é a forma mais poderosa e comum neste repositório. O conteúdo de um arquivo ou a saída de outro comando é "pipado" como contexto para o Gemini.

    ```bash
    # Passar o conteúdo de um arquivo como contexto
    cat README.md | gemini "Faça um resumo deste README."

    # Passar a estrutura de diretórios como contexto
    tree -L 2 | gemini "Descreva a arquitetura deste projeto."
    ```

- **Contexto de Múltiplos Arquivos:** Scripts como `exportar-arquitetura...sh` consolidam a informação de múltiplos arquivos em uma única saída, que é então pipada para o Gemini.

### 4.2. Formatos de Saída Recomendados

O Gemini pode ser instruído a gerar saídas em formatos específicos para facilitar a automação.

- **Markdown (`.md`):** O padrão para documentação, relatórios e resumos.

    ```bash
    cat ... | gemini "Gere um relatório de auditoria em formato Markdown com uma tabela." > reports/auditoria.md
    ```

- **JSON (`.json`):** Útil para saídas estruturadas que podem ser consumidas por outros scripts.

    ```bash
    cat ... | gemini "Liste os arquivos e seus problemas em formato JSON." > reports/problemas.json
    ```

---

## 5. Exemplos de Uso no Repositório

- **Auditoria de Repositório:**
    O script `exportar-arquitetura...sh` é executado, e sua saída é pipada para o Gemini com um dos prompts de sistema (`PROMPT_GEMINI_VALIDACAO...`) para que ele analise a estrutura e gere um relatório.

    ```bash
    ./scripts/exportar-arquitetura...sh | gemini -p prompts/system/PROMPT_GEMINI_VALIDACAO...md
    ```

    *(Onde `-p` é um exemplo de flag para passar um arquivo de prompt)*

- **Geração de Scripts:**
    Um prompt detalhando a lógica de um script é passado ao Gemini, que retorna o bloco de código shell completo.

    ```bash
    cat prompts/gerar_script_x.md | gemini > scripts/novo_script.sh
    ```

- **Geração de Documentação (Este Processo):**
    A execução atual, onde o Gemini está lendo prompts para gerar os próprios documentos de setup, é o principal exemplo de seu papel como motor de automação do repositório.

---

## 6. Integração com IDEs

A integração com o Gemini nas IDEs pode ser direta (via extensão) ou indireta (via terminal integrado).

- **Cursor 2.1 e VS Code:**
  - A principal forma de uso é através do **terminal Zsh integrado**.
  - Ao abrir o terminal na IDE, o `~/.zshrc` já deve ter exportado a `GOOGLE_API_KEY`.
  - Isso permite que você execute os comandos `gemini` diretamente no terminal da IDE, aproveitando todo o contexto do projeto aberto.
  - Extensões como "Google Gemini" podem oferecer funcionalidades de chat, mas o foco deste ecossistema é o uso via CLI para automação.
