# Guia de Setup – GitHub Copilot

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Visão Geral

O GitHub Copilot é o assistente de código "inline" por excelência. Sua principal força é o autocompletar inteligente, que sugere linhas ou blocos inteiros de código diretamente no editor enquanto você digita. Ele funciona como um "par programador" onipresente, acelerando o desenvolvimento de rotina.

Neste ecossistema, o Copilot é uma ferramenta fundamental e integrada diretamente nas IDEs (Cursor e VS Code). Este guia explica como configurá-lo e, mais importante, como orientar seu comportamento para que ele se alinhe com os padrões do projeto.

---

## 2. Pré-requisitos

1.  **Assinatura GitHub Copilot:** Uma assinatura ativa do GitHub Copilot (geralmente inclusa no GitHub Pro ou disponível como um add-on).
2.  **Conta GitHub Autenticada:** A IDE deve estar autenticada com a conta GitHub que possui a assinatura do Copilot. A autenticação do `gh` CLI no terminal geralmente é suficiente para que as IDEs reconheçam a sessão.
3.  **IDEs Instaladas:** Cursor 2.1 e/ou VS Code.

---

## 3. Integração com IDEs

A integração do Copilot é feita através de extensões.

### 3.1. Cursor 2.1

O Cursor vem com suporte nativo ao Copilot, tratando-o como um de seus assistentes de código padrão.

1.  **Autenticação:** Ao iniciar o Cursor pela primeira vez, ele pode pedir para você autenticar com o GitHub. Faça isso para ativar a licença do Copilot. Se o `gh` CLI já estiver autenticado no sistema, o Cursor pode detectar isso automaticamente.
2.  **Habilitação:** As funcionalidades do Copilot (como autocomplete) geralmente já vêm habilitadas por padrão. Você pode verificar as configurações do Cursor para garantir que ele está ativo.
3.  **Convivência:** O Cursor é projetado para orquestrar múltiplos assistentes. Ele pode usar o Copilot para autocomplete e o Claude para tarefas mais complexas via "Cmd+K", permitindo que cada um atue onde brilha mais.

### 3.2. VS Code

No VS Code, a integração é feita pela extensão oficial do GitHub.

1.  **Instalar a Extensão:**
    - No Marketplace de Extensões, procure por `GitHub Copilot` da `GitHub`.
    - Instale a extensão.

2.  **Autenticação:**
    - Após a instalação, o VS Code solicitará que você faça login no GitHub. Um ícone do Copilot na barra de status indicará o estado da autenticação.
    - Siga o fluxo de autenticação no navegador.

---

## 4. Orientando o Comportamento do Copilot

O Copilot aprende com o contexto do seu projeto. Para que ele gere código alinhado aos padrões deste repositório, as seguintes estratégias são utilizadas:

### 4.1. Comentários Guia (Guiding Comments)

Esta é a forma mais direta de influenciar o Copilot. Antes de pedir para ele gerar uma função ou um bloco de código, escreva um comentário detalhado descrevendo o que você precisa, incluindo os parâmetros e o tipo de retorno esperado.

**Exemplo:**
```bash
# Script para encontrar diretórios vazios e, opcionalmente, criar um arquivo .gitkeep neles.
#
# @param {string} base_dir - O diretório base para iniciar a busca.
# @param {boolean} create_gitkeep - Se true, cria um .gitkeep em cada diretório vazio.
# @return {void} - Apenas imprime as ações na tela.
#
function find_empty_dirs() {
    # Aqui, o Copilot provavelmente sugerirá o código para a função.
    
}
```

### 4.2. Snippets e Código Existente

O Copilot analisa os arquivos abertos e o código ao redor para entender o estilo do projeto.

-   **Estilo de Código:** Se o resto do arquivo usa um determinado padrão de nomenclatura para variáveis (ex: `snake_case`), o Copilot tenderá a seguir esse padrão.
-   **Estrutura de Funções:** Se você tem outras funções que começam com `set -euo pipefail` e têm blocos de comentários, o Copilot aprenderá a sugerir isso para novas funções.

### 4.3. Arquivos Auxiliares de Contexto

Para tarefas mais complexas, você pode abrir arquivos relevantes em outras abas do editor.

-   **Exemplo:** Se você está escrevendo um script que precisa usar funções de um arquivo `utils.sh`, abra o `utils.sh` em uma aba ao lado. O Copilot irá "ler" as funções disponíveis nesse arquivo e poderá sugerir o uso correto delas no seu novo script.

### 4.4. Uso do `.cursorrules`

No Cursor, o arquivo `.cursorrules` pode ser usado para definir contextos específicos que também influenciarão o Copilot. Por exemplo, uma regra pode especificar que, para todos os arquivos no diretório `scripts/`, um prompt auxiliar com "regras de bom scripting" seja incluído no contexto, guiando indiretamente as sugestões do Copilot.

---

## 5. Estratégia de Convivência

Neste ecossistema, o Copilot não é a única ferramenta. A estratégia de uso é:

-   **Para Autocomplete Rápido:** Deixe o Copilot fazer o trabalho pesado de preencher código repetitivo, laços `for`, e estruturas condicionais `if`.
-   **Para Geração Complexa:** Quando precisar de uma função ou classe inteira, com lógica complexa, invoque o Claude ou Gemini (via "Cmd+K" no Cursor ou chat) com um prompt detalhado.
-   **Para Pesquisa:** Quando encontrar um problema ou precisar de referências, mude para o Perplexity.
-   **Para Refatoração:** Use as funcionalidades de refatoração do Cursor, que podem ser potencializadas pelo Claude ou outros modelos mais avançados.

O Copilot é o assistente que está sempre presente, enquanto os outros são especialistas que você invoca quando necessário.
