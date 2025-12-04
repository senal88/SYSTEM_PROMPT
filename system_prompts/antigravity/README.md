# Projeto Antigravity

## Visão Geral

Este diretório contém todos os recursos, scripts e documentação para o componente `antigravity`. O projeto `antigravity` é um módulo experimental para demonstrar a automação de processos e a integração contínua dentro do ecossistema de dotfiles.

O nome é uma homenagem ao módulo `antigravity` do Python, que abre uma tirinha do XKCD no navegador.

## Estrutura

A estrutura deste diretório segue as convenções do repositório principal, com as seguintes pastas:

-   `/docs`: Documentação detalhada, guias e arquitetura.
-   `/scripts`: Scripts de automação para deploy, auditoria e manutenção.
-   `/prompts`: Prompts de sistema para interações com IAs.
-   `/governance`: Regras e políticas específicas para este componente.
-   `/audit`: Logs e relatórios de auditorias.
-   `/logs`: Logs de execução de scripts.

## Como Começar

1.  **Explore a documentação:** Comece lendo os arquivos na pasta `docs` para entender a arquitetura e o propósito do projeto.
2.  **Execute o deploy:** Utilize o script principal em `scripts/deploy_antigravity_macos.sh` para implantar o componente em um ambiente macOS.

Este projeto é gerenciado e orquestrado pelos scripts e políticas no diretório `global`.
