# Guia de Setup – LLMs Locais (Offline) com Ollama e LM Studio

- **Versão:** 1.0.0
- **Última atualização:** 2025-11-30
- **Autor:** Gemini 3.0 Pro (Orquestrador)

## 1. Visão Geral

Modelos de Linguagem Grandes (LLMs) locais, ou "offline", são um componente vital deste ecossistema por várias razões:
- **Privacidade:** Os dados processados nunca saem da máquina local. Isso é ideal para trabalhar com código-fonte sensível ou informações confidenciais.
- **Velocidade:** Para modelos menores, a latência pode ser significativamente menor do que a de uma chamada de API pela rede.
- **Disponibilidade:** Funcionam sem conexão com a internet.
- **Custo:** Após o download do modelo, a execução é gratuita.

As duas ferramentas padrão para gerenciar e executar LLMs locais neste ambiente são o **Ollama** (para uso via linha de comando) e o **LM Studio** (para uso via interface gráfica).

---

## 2. Pré-requisitos

1.  **Hardware Adequado:** Um Mac com chip Apple Silicon (M1, M2, M3, M4) com memória RAM suficiente (16GB no mínimo, 24GB ou mais recomendado) para executar os modelos desejados.
2.  **Espaço em Disco:** Vários gigabytes de espaço livre para baixar os modelos.
3.  **Homebrew:** Para a instalação do Ollama.

---

## 3. Ollama (Linha de Comando)

O Ollama é a forma preferencial de interagir com modelos locais em scripts e no terminal.

### 3.1. Instalação

A instalação é gerenciada pelo Homebrew. O script de setup geral do repositório (`scripts/setup/...`) deve cuidar disso.
```bash
brew install ollama
```
Após a instalação, o Ollama roda como um serviço em segundo plano no macOS.

### 3.2. Baixando Modelos

Você pode baixar modelos do registro do Ollama diretamente pelo terminal.

```bash
# Baixar o modelo Llama 3 (versão de 8 bilhões de parâmetros)
ollama pull llama3

# Baixar um modelo focado em programação como o Code Llama
ollama pull codellama:7b
```
Para ver todos os modelos que você já baixou, use `ollama list`.

### 3.3. Executando um Modelo

-   **Modo Interativo (Chat):**
    ```bash
    ollama run llama3
    ```
    Isso iniciará um chat no seu terminal onde você pode interagir com o modelo.

-   **Uso em Scripts (Não-interativo):**
    Você pode passar um prompt para o `ollama run` e obter a resposta diretamente, o que é útil para scripts.
    ```bash
    ollama run llama3 "Resuma o seguinte texto em uma frase: [seu texto aqui]"
    ```

### 3.4. Sincronizando com o System Prompt Universal

Para usar o prompt universal com o Ollama, você pode criar um "Modelfile" ou passá-lo diretamente.

-   **Via Pipe:**
    ```bash
    # Concatena o prompt do sistema e a sua pergunta, e passa tudo para o modelo
    (cat system_prompt_global.txt && echo "\n\nMinha pergunta: qual o comando para listar arquivos no linux?") | ollama run llama3
    ```
-   **Criando um Modelo Personalizado (Avançado):**
    Você pode criar um `Modelfile` para embutir o system prompt diretamente em um novo modelo.
    ```Modelfile
    FROM llama3
    SYSTEM """
    Você é um assistente de programação rodando localmente. Suas respostas devem ser em Português do Brasil.
    Seu foco é segurança e privacidade.
    """
    ```
    E então criar seu modelo personalizado: `ollama create meu-assistente -f ./Modelfile`.

---

## 4. LM Studio (Interface Gráfica)

O LM Studio oferece uma interface gráfica completa para descobrir, baixar e conversar com modelos locais. É ideal para quem prefere uma experiência menos focada no terminal.

### 4.1. Instalação

-   Baixe o aplicativo LM Studio para macOS (Apple Silicon) do [site oficial](https://lmstudio.ai/).
-   Arraste o aplicativo para a sua pasta `/Applications`.

### 4.2. Usando o LM Studio

1.  **Descobrir e Baixar Modelos:**
    - Na tela principal (aba de pesquisa), você pode procurar por modelos do Hugging Face.
    - Procure por modelos populares como "Llama-3-8B-Instruct-GGUF" ou "CodeLlama-7B-GGUF".
    - Escolha uma versão (quantização) que se ajuste à sua RAM (ex: Q4_K_M para um bom balanço) e clique em "Download".

2.  **Iniciar um Chat:**
    - Vá para a aba de chat (ícone de balão de fala).
    - No topo, selecione o modelo que você baixou.
    - Você pode começar a conversar com o modelo diretamente.

3.  **Sincronizar o System Prompt:**
    - Na interface de chat, há uma área para "System Prompt" no painel de configurações à direita.
    - Copie e cole o conteúdo do seu `system_prompt_global.txt` ou de um prompt específico para essa área.
    - O LM Studio manterá esse prompt para a sessão de chat atual.

### 4.3. Servidor Local

Uma das funcionalidades mais poderosas do LM Studio é a capacidade de iniciar um servidor local compatível com a API da OpenAI.

-   Vá para a aba "Local Server" (ícone `<>`).
-   Selecione um modelo para carregar e clique em "Start Server".
-   O LM Studio fornecerá um endereço local (ex: `http://localhost:1234/v1`).
-   Agora, você pode usar qualquer script ou ferramenta que saiba como falar com a API da OpenAI para interagir com seu modelo local, simplesmente apontando para este endereço. Isso é extremamente útil para testar automações sem gastar créditos de API.

---

## 5. Conclusão

-   Use o **Ollama** para integrações com scripts e automação no terminal.
-   Use o **LM Studio** para uma experiência de chat mais visual, para descobrir novos modelos e para criar um endpoint de API local para testes.

Ambas as ferramentas são essenciais para um fluxo de trabalho que valoriza a privacidade e a flexibilidade.
