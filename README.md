# ls-edia-config: Repositorio de Configuracoes Core do LS-EDIA

[![Repository Link](https://github.com/senal88/ls-edia-config)](https://github.com/senal88/ls-edia-config){target="_blank"}

## 1. Visao Geral

Este repositorio versiona apenas os dotfiles e artefatos de configuracao que definem o comportamento base do ambiente LS-EDIA no macOS Tahoe 26.0.1. Ele nao inclui projetos, dados, backups ou segredos; esses itens vivem em diretorios dedicados diretamente sob `~/` conforme a arquitetura LS-EDIA.

**Objetivos principais**
- Preservar historico de ajustes em shell, Git, VS Code e ferramentas.
- Permitir reproducao rapida das configuracoes em novas maquinas.
- Servir como referencia para agentes de IA sobre o estado das configuracoes.
- Manter o escopo do repositorio focado em dotfiles, mantendo outros dominios modulares.

## 2. Estrutura do Repositorio

```
Dotfiles/
├── .gitconfig
├── .gitignore
├── .gitignore_global
├── .zprofile
├── .zshrc
├── README.md (este arquivo)
├── Tools/            # Scripts e snippets utilitarios versionados
├── SystemBlueprint/  # Documentacao constitucional
├── macOS_AgentKit_Stack/
├── vscode/           # Configuracoes VS Code
├── correct_ls_edia_structure.sh
└── setup_ls-edia.sh
```

**Pastas chave**
- Dotfiles principais (`.zshrc`, `.gitconfig`, `.zprofile`, `.npmrc`, `.editorconfig`).
- `vscode/` com `settings.json` e `extensions.json`.
- `Tools/scripts/` para automacoes manuais (validacao, tagging, instalacao).
- `Tools/snippets/` como biblioteca oficial de snippets e checklists.
- `SystemBlueprint/` contendo architecture.md, gpt-expert-profile.md e classification-guide.yaml.

## 3. Como aplicar as configuracoes em uma nova maquina

1. **Clonar o repositorio:**
   ```bash
   cd ~
   git clone https://github.com/senal88/ls-edia-config Dotfiles
   ```
2. **Criar links simbolicos:**
   ```bash
   cd ~
   ln -sf ~/Dotfiles/.zshrc ~/.zshrc
   ln -sf ~/Dotfiles/.gitconfig ~/.gitconfig
   ln -sf ~/Dotfiles/.npmrc ~/.npmrc
   ln -sf ~/Dotfiles/.editorconfig ~/.editorconfig
   ln -sf ~/Dotfiles/vscode ~/.vscode
   ```
3. **Opcional:** executar `./setup_ls-edia.sh` para montar a estrutura LS-EDIA se ainda nao existir em `~/`.
4. **Recarregar o shell:**
   ```bash
   source ~/.zshrc
   ```

## 4. Scripts utilitarios inclusos

- `correct_ls_edia_structure.sh`: move para `~/` as pastas de alto nivel que por engano estejam dentro deste repositorio.
- `setup_ls-edia.sh`: cria a estrutura base LS-EDIA (SystemBlueprint, Workspaces, Tools, DataVault, Backups, Secrets, Documentation).
- `Tools/scripts/validacao_final.sh`: auditoria completa do ambiente.
- `Tools/scripts/apply_ls_edia_tags.sh`: aplica tags LS-EDIA no Finder, incluindo `Tools/snippets`.

> Conceda permissao de execucao apos o clone: `chmod +x *.sh Tools/scripts/*.sh`.

## 5. Snippets e checklists

A biblioteca foi consolidada em `Tools/snippets/`. Exemplos:
- `COMMANDS.md`: comandos frequentes.
- `SNIPPET_API_CALL.py`: chamada basica para o AgentKit.
- `CHECKLIST.md`: checklist rapido para revisao de dotfiles.

Mantenha os snippets enxutos, sem credenciais, e atualize `Tools/snippets/README.md` quando adicionar novos itens.

## 6. Guardrails

- Nunca versionar segredos; utilize `~/Secrets/`.
- Execute `Tools/scripts/validacao_final.sh` apos ajustes significativos.
- Atualize `SystemBlueprint/` quando houver mudancas de arquitetura ou fluxo.
- Revise `Tools/snippets/` periodicamente para retirar entradas obsoletas.

## 7. Favoritos e tags sugeridos

- Adicione ao Finder: `~/Dotfiles`, `~/SystemBlueprint`, `~/Tools`, `~/Workspaces`, `~/DataVault`, `~/Backups`.
- Rode `Tools/scripts/apply_ls_edia_tags.sh` para aplicar as tags `LS-EDIA-CORE`, `LS-EDIA-WORK`, `LS-EDIA-DATA`, `LS-EDIA-INFO` e `LS-EDIA-SENSITIVE`.

## 8. Fluxo de contribuicao

1. Ajustar arquivos.
2. Rodar `Tools/scripts/validacao_final.sh`.
3. Conferir `git status` e `git diff`.
4. Commitar com mensagem clara (`docs:`, `chore:`, `fix:` etc).
5. `git push` para sincronizar com o remoto.

---

Manter este README alinhado ao estado atual do ambiente garante onboarding rapido para voce e para os agentes LS-EDIA.
