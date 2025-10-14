# 🧩 Dotfiles

## Role
Reúne configurações replicáveis do ambiente (`.zshrc`, `.gitconfig`, VS Code settings) de forma organizada e pronta para versionamento privado.

## Allowed Operations
- Human: editar dotfiles, armazenar templates de configuração e exportar para novos ambientes.
- GPT Expert: propor snippets ou ajustes documentados, gerar comparativos entre versões.

## Guardrails
- Manter backups incrementais em `Backups/dotfiles`.
- Evitar credenciais hardcoded.

## Maintenance Checklist
- Consolidar mudanças após ajustes no shell ou editor.
- Rodar `git diff` (repo privado) para auditar alterações sensíveis.
- Sincronizar com novos dispositivos após validação manual.
