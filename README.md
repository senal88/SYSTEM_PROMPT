# ls-edia-config - Dotfiles oficiais LS-EDIA

[Repositorio GitHub](https://github.com/senal88/ls-edia-config)

## Visao Geral

Este repositorio versiona **apenas os dotfiles** que configuram o ambiente LS-EDIA no macOS Tahoe (Apple Silicon). Toda a arquitetura operacional vive diretamente em `~/` (`~/SystemBlueprint`, `~/Tools`, `~/Workspaces`, etc.) e nao e rastreada aqui; os scripts `setup_ls-edia.sh` e `correct_ls_edia_structure.sh` cuidaram da migracao.

### Objetivos
- Sincronizar shell, Git e VS Code entre maquinas.
- Servir de fonte da verdade para ajustes rapidos e para agentes de IA.
- Manter o repositorio enxuto, sem dados, projetos ou segredos.

## Layout Atual

```
Dotfiles/
|-- .editorconfig
|-- .gitconfig
|-- .gitignore
|-- .gitignore_global
|-- .npmrc
|-- .zprofile
|-- .zshrc
|-- README.md
`-- vscode/
    |-- extensions.json
    `-- settings.json
```

> As pastas `SystemBlueprint/`, `Tools/`, `Backups/`, etc. continuam existindo no sistema, mas agora residem em `~/` e sao sincronizadas fora deste repositorio.

## Aplicando os Dotfiles em uma maquina nova

1. Clonar:
   ```bash
   cd ~
   git clone https://github.com/senal88/ls-edia-config Dotfiles
   ```
2. Criar links simbolicos:
   ```bash
   ln -sf ~/Dotfiles/.zshrc ~/.zshrc
   ln -sf ~/Dotfiles/.zprofile ~/.zprofile
   ln -sf ~/Dotfiles/.gitconfig ~/.gitconfig
   ln -sf ~/Dotfiles/.gitignore_global ~/.gitignore_global
   ln -sf ~/Dotfiles/.npmrc ~/.npmrc
   ln -sf ~/Dotfiles/.editorconfig ~/.editorconfig
   ln -sfn ~/Dotfiles/vscode ~/.vscode
   ```
3. Recarregar o shell:
   ```bash
   source ~/.zshrc
   ```

## Diretorios LS-EDIA (fora do repo)

| Pasta              | Papel                                                                | Observacoes                                           |
|--------------------|----------------------------------------------------------------------|-------------------------------------------------------|
| `~/SystemBlueprint`| Constituicao do ambiente (arquitetura, guias, perfis)                | Atualizar manualmente apos cada mudanca relevante.    |
| `~/Tools`          | Scripts operacionais, snippets, binarios auxiliares                  | Scripts auditados (`apply_ls_edia_tags.sh`, `validacao_final.sh`) vivem aqui. |
| `~/Workspaces`     | Projetos ativos                                                       | Subpastas por dominio (`Finance`, `Legal`, `Infra`...).|
| `~/DataVault`      | Dados brutos/processados/seguros                                     | Respeitar classificacao do blueprint.                 |
| `~/Backups`        | Snapshots e copias versionadas                                       | Registrar atividades em `~/Documentation/logs/`.      |
| `~/Documentation`  | Logs, notas de migracao, relatorios                                  | Garantir registros apos rodar validacoes e migracoes. |

## Guardrails
- Nunca versionar conteudo de `~/Secrets/`.
- Rodar `~/Tools/scripts/validacao_final.sh` apos alteracoes estruturais.
- Registrar migracoes relevantes em `~/Documentation/migration_notes/`.
- Evitar sobrescrever arquivos existentes sem backup previo.

## Fluxo de Contribuicao
1. Ajustar o dotfile necessario.
2. Executar `~/Tools/scripts/validacao_final.sh` para garantir consistencia.
3. Revisar `git status` e `git diff`.
4. Commitar com mensagem clara (`feat:`, `chore:`, `docs:` etc).
5. `git push` para atualizar o repositorio remoto.

---

Em caso de duvidas sobre a arquitetura global, consulte `~/SystemBlueprint/architecture.md` e o perfil LS-EDIA Architect Gem configurado no Gemini/GPT.
