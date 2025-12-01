Início — ambiente e parâmetros considerados

* Sistema: macOS Tahoe 26.x (Apple Silicon), usuário `luiz.sena88`, Zsh como shell padrão.
* Terminal alvo: iTerm2 como terminal principal, substituindo o Terminal.app, integrado ao ecossistema de Dotfiles, SSH, 1Password CLI e IDEs (VSCode / Cursor).
* Referência técnica: documentação oficial do iTerm2 (features, preferences, shell integration, tmux integration, status bar, triggers, scripting, AI chat, dynamic profiles e scripting API).

A seguir está o **workflow profissional e técnico** para implantação do setup completo do iTerm2, estruturado em fases, alinhado a boas práticas e pronto para ser operacionalizado.

---

## Fase 0 — Premissas, variáveis e objetivos

Definições de variáveis (não fixar caminhos nem nomes diretamente):

* `{{ITERM2_APP_SOURCE}}`

  * Origem da instalação (`homebrew` ou download manual `.dmg`).
* `{{ITERM2_PREFS_DIR}}`

  * Diretório dedicado para preferências versionadas do iTerm2 (ex.: dentro de `~/Dotfiles`, mas mantido parametrizado).
* `{{DOTFILES_DIR}}`

  * Diretório raiz dos seus Dotfiles (já existente).
* `{{ZSHRC_PATH}}`

  * Caminho efetivo do `.zshrc` de produção (provavelmente symlink ou arquivo gerado a partir do `{{DOTFILES_DIR}}`).
* `{{GIT_REPO_DOTFILES}}`

  * Repositório Git onde `{{ITERM2_PREFS_DIR}}` será versionado.

Objetivos do setup iTerm2:

1. iTerm2 como terminal padrão, com perfis bem delineados (local, VPS, containers, etc.).
2. Preferências externas, versionadas e reprodutíveis (governança via Git).
3. Integração profunda com:

   * Zsh + Dotfiles
   * 1Password CLI (agente SSH)
   * SSH config e hosts (`~/.ssh/config`)
   * TMUX (quando necessário)
4. Ativação e parametrização dos recursos avançados:

   * Shell Integration
   * Status bar
   * Triggers
   * Automatic Profile Switching
   * tmux integration
   * AI Chat / Scripting (quando aplicável)

---

## Fase 1 — Instalação controlada do iTerm2

### 1.1. Instalação via Homebrew (recomendado)

* Ponto de controle: Homebrew já presente e saudável.
* Comando padrão (parametrizado):

```bash
{{BREW_BIN}} install --cask iterm2
```

* `{{BREW_BIN}}`: normalmente `/opt/homebrew/bin/brew` em Apple Silicon.

### 1.2. Fixar iTerm2 como terminal padrão

* Dentro do iTerm2:

  * `iTerm2 > Make iTerm2 Default Term` (opção própria do app).
* O objetivo é garantir que qualquer ação de “abrir terminal” no macOS utilize iTerm2.

---

## Fase 2 — Isolamento e versionamento das preferências

### 2.1. Definir diretório de preferências

* Criar diretório versionável:

```bash
mkdir -p "{{ITERM2_PREFS_DIR}}"
```

* `{{ITERM2_PREFS_DIR}}` será referenciado nas Preferências do iTerm2.

### 2.2. Configurar uso de “prefs customizados” no iTerm2

No iTerm2:

1. `iTerm2 > Settings… > General > Preferences`
2. Ativar:

   * “Load preferences from a custom folder or URL”
3. Apontar para `{{ITERM2_PREFS_DIR}}`
4. Marcar:

   * “Save changes to folder when iTerm2 quits”.

Isso faz com que o arquivo de prefs (`com.googlecode.iterm2.plist`) fique dentro de `{{ITERM2_PREFS_DIR}}`, pronto para ser versionado em Git.

### 2.3. Acoplamento às governanças existentes

* Adicionar `{{ITERM2_PREFS_DIR}}` ao repositório `{{GIT_REPO_DOTFILES}}`:

  * Padrão: um subdiretório `iterm2/` ou equivalente, sem inventar nome fixo, apenas parametrizar.
* Garantir que qualquer pipeline de bootstrap (scripts de instalação de Dotfiles) contemple:

  * Clonagem do repo
  * Criação de symlink ou cópia do `{{ITERM2_PREFS_DIR}}` para o local esperado pelo iTerm2.

---

## Fase 3 — Desenho de perfis e mapeamento de ambientes

### 3.1. Definir perfis lógicos

Criar no iTerm2 perfis com papéis claros:

* `{{PROFILE_LOCAL_DEV}}`

  * Host: máquina local (macOS).
  * Título: indicar host + branch git (via shell integration / prompt).
* `{{PROFILE_VPS_ADMIN}}`

  * Comando de login automático: `ssh admin-vps`.
  * Cor de background e badge diferenciados para evitar comandos destrutivos involuntários.
* `{{PROFILE_VPS_ROOT}}`

  * Comando: `ssh vps`.
  * Forte diferenciação visual (cor, badge de “ROOT”).
* `{{PROFILE_DOCKER_SWARM}}`

  * Se necessário, perfil com comando inicial apontando para scripts Swarm/Kubernetes específicos.
* `{{PROFILE_OFFLINE_LLM}}`

  * Dedicado a comandos `ollama`, `lmstudio`, etc. (quando aplicável).

### 3.2. Naming e badges

* Configurar `Badges` para indicar:

  * Ambiente (`LOCAL`, `VPS-ADMIN`, `VPS-ROOT`)
  * Projecto (quando usar Automatic Profile Switching).
* Uso recomendado de badges conforme documentação do iTerm2.

### 3.3. Automatic Profile Switching

* Utilizar “Automatic Profile Switching” para mapear:

  * Diretórios (`~/projetos/{{NOME_PROJETO}}`)
  * Hosts remotos (`admin-vps`, `vps`)
    para perfis específicos, reforçando segurança contextual.

---

## Fase 4 — Integração com Zsh, Dotfiles, 1Password e SSH

### 4.1. Shell Integration do iTerm2 com Zsh

* Usar feature oficial “Shell Integration” para Zsh.

* Ponto crítico: **não** deixar o iTerm2 editar o `.zshrc` “solto”; em vez disso:

  * Executar a instalação da shell integration (via menu do iTerm2).
  * Localizar o bloco de código inserido.
  * Mover esse bloco para um arquivo dedicado no `{{DOTFILES_DIR}}`, por exemplo:

    * `{{DOTFILES_DIR}}/zsh/iterm2_integration.zsh`
  * No `{{ZSHRC_PATH}}`, incluir apenas:

    ```bash
    source "{{DOTFILES_DIR}}/zsh/iterm2_integration.zsh"
    ```

* Objetivo: manter o `.zshrc` governado pelos Dotfiles, sem fragmentação.

### 4.2. PATH, aliases e funções

* Confirmar que iTerm2 está apenas consumindo o ambiente Zsh padrão:

  * Nada de PATH custom dentro do iTerm2; todo PATH governado em Dotfiles.
* Estrutura sugerida:

  * `{{DOTFILES_DIR}}/zsh/exports.zsh`
  * `{{DOTFILES_DIR}}/zsh/aliases.zsh`
  * `{{DOTFILES_DIR}}/zsh/functions.zsh`
  * `{{DOTFILES_DIR}}/zsh/iterm2_integration.zsh`
* O iTerm2 apenas executa o shell configurado (`/bin/zsh`) com esses arquivos já acoplados.

### 4.3. Integração com 1Password (SSH Agent)

* Confirmar no `~/.ssh/config`:

  * `IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"`
* Garantir que os perfis iTerm2 não sobrepõem esta configuração (nenhum `SSH_AUTH_SOCK` custom no nível de perfil).
* Utilizar iTerm2 apenas como interface visual; toda lógica de agente e chaves permanece centralizada em:

  * `~/.ssh/config`
  * 1Password CLI (agente).

### 4.4. Integração com SSH + Títulos de janela

* Considerar uso de triggers ou escape codes para ajustar título de janela e badge conforme host.
* Exemplo de lógica (implementada via shell ou triggers do iTerm2):

  * Ao conectar em `admin-vps`, título: `[VPS-ADMIN] senamfo.com.br`.
  * Ao conectar em `vps`, título: `[ROOT] senamfo.com.br`.

---

## Fase 5 — Funcionalidades avançadas do iTerm2

### 5.1. Status Bar

* Usar o “Status Bar” do iTerm2 para exibir:

  * Host (local/VPS).
  * Branch git atual.
  * Hora e data.
  * Uso de CPU/RAM (quando necessário).
* A configuração de status bar é feita por perfil, permitindo granularidade.

### 5.2. Hotkey Window

* Configurar um Perfil “Quick” com:

  * Uma Hotkey dedicada (por exemplo, `Ctrl+Option+Space`).
  * Janela flutuante, sem borda, sempre no topo.
* Esse perfil pode ser usado como console rápido para tarefas pontuais, sem misturar com sessões de trabalho longo.

### 5.3. Triggers

* Usar “Triggers” para:

  * Colorir linhas de log com determinados padrões (ex.: `ERROR`, `WARN`).
  * Registrar alertas (beep/notify) em casos críticos.
* Evitar triggers que executem comandos perigosos automaticamente; priorizar monitoramento e formatação.

### 5.4. Integração com tmux

* Avaliar necessidade de tmux integration do iTerm2:

  * Para sessões persistentes (workflows longos, deploys, tail de logs).
* Configurar:

  * Prefixos tmux sem conflito com atalhos do iTerm2.
  * Mapeamento de splits (pane vs. iTerm2 splits) para evitar duplicidade conceitual.

### 5.5. AI Chat e Scripting

* iTerm2 possui recursos de AI chat e scripting orientados a terminal.
* Definir política:

  * Quando usar AI do iTerm2 (assistência local de linha de comando).
  * Quando usar ChatGPT/Claude/Gemini/Cursor como camada de análise superior.
* Manter scripts de automação em repositório próprio, integrando com:

  * Scripting API do iTerm2 (Python) quando houver uso justificado.

---

## Fase 6 — Scripting, automação e backup

### 6.1. Script de bootstrap do iTerm2

* No `{{DOTFILES_DIR}}/scripts/`, incluir um script de bootstrap, por exemplo:

  * `setup_iterm2.sh` (nome apenas conceitual, a ser definido segundo sua governança).
* Responsabilidades do script:

  * Garantir instalação do iTerm2 (via Homebrew se `{{ITERM2_APP_SOURCE}}=homebrew`).
  * Criar `{{ITERM2_PREFS_DIR}}` se não existir.
  * Configurar symlinks / cópia de `com.googlecode.iterm2.plist`.
  * Validar se a opção de “Load preferences from custom folder” está ativa (via documentação / user defaults, quando aplicável).
  * Registrar log da execução em diretório de logs do Dotfiles.

### 6.2. Backup e restore

* Padronizar comando para snapshot das prefs:

  ```bash
  # Snapshot manual
  rsync -avh "{{ITERM2_PREFS_DIR}}/" "{{ITERM2_PREFS_DIR}}_backup_{{YYYYMMDD}}/"
  ```

* Versionamento via Git:

  * Commits sempre com mensagem padronizada (`iterm2: update prefs {{YYYY-MM-DD}}`).
  * Tag opcional para marcos relevantes (ex.: `iterm2-setup-v1.0.0`).

### 6.3. Auditoria periódica

* Checklists periódicos (por exemplo, mensal):

  * Confirmar se novas features do iTerm2 foram ativadas de forma consistente (AI, scripting, novos widgets da status bar, etc.).
  * Garantir que qualquer ajuste manual de prefs seja refletido no repositório versionado.

---

## Fase 7 — Checklist final de implantação

Checklist consolidado para considerar o setup iTerm2 como “completo”:

1. [ ] iTerm2 instalado via `{{ITERM2_APP_SOURCE}}`, em versão atual.
2. [ ] Preferências externas configuradas em `{{ITERM2_PREFS_DIR}}` e sob Git.
3. [ ] Perfis criados:

   * [ ] `{{PROFILE_LOCAL_DEV}}`
   * [ ] `{{PROFILE_VPS_ADMIN}}`
   * [ ] `{{PROFILE_VPS_ROOT}}`
   * [ ] Demais perfis contextuais (containers, LLM offline etc.), se aplicáveis.
4. [ ] Automatic Profile Switching configurado para diretórios e hosts críticos.
5. [ ] Shell Integration habilitada e centralizada em arquivo do `{{DOTFILES_DIR}}`, referenciado por `{{ZSHRC_PATH}}`.
6. [ ] Integração com 1Password (SSH Agent) ativa e não sobrescrita.
7. [ ] Status bar configurada por perfil com informações relevantes de contexto.
8. [ ] Hotkey Window funcional com perfil rápido dedicado.
9. [ ] Triggers configurados apenas para monitoramento/realce, sem ações destrutivas automáticas.
10. [ ] tmux integration avaliada e, se utilizada, configurada sem conflito de atalhos.
11. [ ] Scripts de bootstrap/backup (`setup_iterm2.sh` e equivalentes) criados e versionados.
12. [ ] Processo de backup + restore testado (clonagem do repo em máquina nova e reprodução do setup iTerm2).

---

Conclusão

O workflow apresentado define, de forma completa e alinhada a boas práticas, o processo de implantação, governança e operação do setup iTerm2 em ambiente macOS integrado a Dotfiles, SSH/1Password e ecossistema de IAs/IDEs, considerando recursos avançados de shell integration, status bar, triggers, tmux e scripting/AI.

Workflow profissional para setup completo do iTerm2 definido e pronto para implantação.
