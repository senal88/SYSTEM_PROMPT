# Guia de Uso - Componente Antigravity
**Versão:** 1.0.0
**Data:** 2025-12-02

## 1. Objetivo

Este guia fornece as instruções necessárias para executar o script de implantação do componente `antigravity` em um ambiente macOS.

## 2. Pré-requisitos

-   **Sistema Operacional:** macOS. O script foi projetado especificamente para este ambiente e não funcionará em outros sistemas.
-   **Terminal:** Acesso a um terminal (como o Terminal padrão ou iTerm2).
-   **Permissões:** O script deve ter permissão de execução.

## 3. Instruções de Execução

1.  **Navegue até o diretório do script:**
    Abra o terminal e navegue até a pasta `scripts` dentro do diretório `antigravity`:
    ```bash
    cd /caminho/para/Dotfiles/system_prompts/antigravity/scripts
    ```

2.  **Conceda permissão de execução (se necessário):**
    Se esta for a primeira vez que você executa o script, você precisará torná-lo executável.
    ```bash
    chmod +x deploy_antigravity_macos.sh
    ```

3.  **Execute o script:**
    Invoque o script diretamente do seu terminal:
    ```bash
    ./deploy_antigravity_macos.sh
    ```

## 4. O que Esperar

Após a execução bem-sucedida, o script fará o seguinte:

-   Imprimirá mensagens de log no terminal, indicando o progresso.
-   Abrirá automaticamente o seu navegador padrão na página da tirinha 353 do XKCD.
-   Criará um arquivo de log detalhado na pasta `antigravity/logs` com um timestamp da execução.

## 5. Solução de Problemas

| Problema                                      | Causa Provável                               | Solução                                                                    |
| --------------------------------------------- | -------------------------------------------- | -------------------------------------------------------------------------- |
| "Comando não encontrado" ou "Permissão negada"  | O script não tem permissão de execução.      | Execute `chmod +x deploy_antigravity_macos.sh` antes de invocar o script.  |
| Mensagem de erro "Este script é apenas para macOS" | Você está tentando executar em um SO diferente. | Execute o script em uma máquina com macOS.                                 |
| O navegador não abre.                         | O comando `open` pode ter falhado.           | Verifique o arquivo de log em `antigravity/logs` para obter mais detalhes. |
