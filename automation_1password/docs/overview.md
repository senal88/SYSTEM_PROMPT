_MD_# Arquitetura de Automação 1Password para macOS Silicon

## 1. Visão Geral

Esta arquitetura descreve uma solução de automação completa para o gerenciamento de segredos no macOS Silicon, utilizando o 1Password como a fonte central de verdade. O design prioriza a **fluidez para o desenvolvedor**, a **segurança robusta** e a **automação inteligente**, com integração nativa ao ecossistema macOS e ferramentas de desenvolvimento modernas.

O objetivo é eliminar a necessidade de arquivos `.env` estáticos e a exposição de segredos no código-fonte, substituindo-os por um fluxo de trabalho dinâmico, seguro e auditável.

## 2. Componentes Principais

| Componente | Função | Integração no macOS | Justificativa |
| :--- | :--- | :--- | :--- |
| **1Password Desktop App** | Agente principal, UI e provedor de biometria | Nativa, via `Settings > Security` | Fornece a interface para o usuário e o backend para a autenticação biométrica (Touch ID/Apple Watch), garantindo uma experiência de usuário fluida e segura. |
| **1Password CLI (`op`)** | Ferramenta de linha de comando para automação | Instalado via **Homebrew** (`brew install 1password-cli`) | O coração da automação. Permite que scripts e ferramentas de terminal acessem segredos de forma programática. |
| **Autenticação Biométrica** | Desbloqueio da CLI sem senha | Integração automática entre a CLI e o Desktop App | Elimina a necessidade de digitar a senha mestre repetidamente, proporcionando um fluxo de trabalho "zero burocracia" sem comprometer a segurança. |
| **Shell (Zsh)** | Ambiente de execução para scripts e aliases | Shell padrão no macOS | Ponto de entrada para todos os comandos e scripts de automação. A configuração do `.zshrc` é crucial. |
| **Scripts de Automação** | Lógica para injeção de segredos e orquestração | Scripts `.sh` ou `.py` armazenados em `~/Dotfiles` ou no projeto | Encapsulam a lógica de negócios, como carregar ambientes, iniciar serviços e executar tarefas de CI/CD locais. |
| **Ferramentas de Desenvolvedor** | Docker, `jq`, `micromamba`, Raycast, etc. | Instaladas via Homebrew | Ferramentas que consomem os segredos injetados pelo 1Password para executar suas funções. |

## 3. Fluxo de Autenticação e Acesso a Segredos

O fluxo foi desenhado para ser o mais transparente possível para o desenvolvedor:

1.  **Primeira Autenticação do Dia:**
    *   O desenvolvedor executa o primeiro comando `op` no terminal (ex: `op vault list`).
    *   O 1Password CLI detecta que está bloqueado e se comunica com o 1Password Desktop App.
    *   O Desktop App solicita a autenticação via **Touch ID** ou **Apple Watch**.
    *   Uma vez autenticado, a sessão da CLI permanece ativa (desbloqueada) por um período configurável no Desktop App (ex: 8 horas).

2.  **Acessos Subsequentes:**
    *   Qualquer comando `op` subsequente (executado por scripts, aliases ou manualmente) utiliza a sessão já autenticada, sem exigir nova interação do usuário.
    *   Isso garante a fluidez desejada: os segredos são acessados de forma segura e instantânea.

![Fluxo de Automação 1Password no macOS](https://i.imgur.com/example.png)  *<-- Placeholder para um diagrama de fluxo a ser gerado.*

## 4. Estrutura de Vaults e Governança

Para garantir organização e segurança, a seguinte estrutura de vaults é proposta, alinhada com as melhores práticas de governança:

### 4.1. Vault Exclusivo para macOS Silicon

*   **Nome do Vault:** `macos_silicon_workspace`
*   **Propósito:** Armazenar segredos e configurações que são **exclusivos e específicos** para o ambiente de desenvolvimento local no macOS. Isso cria uma camada de isolamento, garantindo que segredos de produção ou de outros ambientes nunca sejam expostos localmente por engano.
*   **Conteúdo:**
    *   **Tokens de API para ferramentas locais:** Chaves para LLMs locais (Ollama, LM Studio), ferramentas de debug, etc.
    *   **Licenças de Software:** Chaves de licença para aplicativos de desenvolvimento instalados no Mac.
    *   **Configurações de Ambiente Local:** Endereços de banco de dados local, portas de serviços locais, etc.
    *   **Scripts de automação do macOS:** Scripts do Automator ou AppleScript que contenham dados sensíveis.

### 4.2. Outros Vaults

*   `shared_infra`: Segredos de infraestrutura compartilhados (ex: credenciais de provedores de nuvem, chaves de API de serviços de DNS).
*   `project_specific_secrets`: Vaults dedicados por projeto, contendo segredos de `dev`, `staging` e `prod` para aquele projeto específico.

## 5. Injeção de Segredos e Automação

O método principal para usar os segredos será através de **Secret References** e do comando `op run`.

### 5.1. O Comando `op run`

Este comando é a base da automação. Ele cria um ambiente de execução temporário, injeta os segredos como variáveis de ambiente e, em seguida, executa o comando desejado. O segredo nunca toca o disco ou o histórico do shell.

**Exemplo de uso:**

```zsh
# Executa um script python que precisa de uma chave de API
op run -- python my_script.py
```

### 5.2. Arquivo de Ambiente Dinâmico (`.env.op`)

Em vez de um `.env` com valores fixos, usaremos um arquivo de template com referências do 1Password.

**Exemplo de `.env.op`:**

```
# Chaves para LLMs locais
OLLAMA_API_KEY=op://macos_silicon_workspace/ollama/api_key
LM_STUDIO_URL=op://macos_silicon_workspace/lm_studio/local_server_url

# Chave da API do Github para a CLI
GITHUB_TOKEN=op://shared_infra/github/cli_token
```

**Uso no `op run`:**

```zsh
# Inicia um container Docker Compose, injetando os segredos do arquivo .env.op
op run --env-file=.env.op -- docker-compose up
```

## 6. Integração com LLMs e CLI

Para a integração com LLMs, a automação irá gerar prompts e contextos dinâmicos.

*   **Script de Coleta de Contexto:** Um script (como o `generate_ai_context.sh` discutido) será acionado via Raycast.
*   **Interação com LLM:** A saída do script (um JSON de contexto) será enviada para um LLM (local via Ollama ou remoto) para análise ou para gerar comandos.

**Exemplo de Alias no `.zshrc`:**

```zsh
alias ask-ai="generate_ai_context.sh | ollama run llama3:8b"
```

## 7. Documentação e Governança

A governança será implementada através de:

*   **Documentação como Código:** A arquitetura, os scripts e os procedimentos serão documentados em Markdown e versionados no repositório `Dotfiles`.
*   **Auditoria:** O 1Password fornece um log de auditoria de todos os acessos a segredos, permitindo rastrear quem acessou o quê e quando.
*   **Políticas de Acesso:** O acesso aos vaults será gerenciado por grupos no 1Password, seguindo o princípio do menor privilégio.

Este planejamento estabelece uma base sólida para a implementação da automação no macOS Silicon, focando em uma experiência de desenvolvedor fluida, segura e altamente produtiva.

