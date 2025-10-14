# 🧠 SystemBlueprint

## Role
Repositório central das decisões arquiteturais, prompts mestre e artefatos que definem o funcionamento macro do ecossistema macOS Tahoe.

## Allowed Operations
- Human: atualizar documentos de arquitetura, registrar decisões, versionar workflows.
- GPT Expert: consultar prompts, ler workflows JSON, propor ajustes contextualizados.

## Guardrails
- Não armazenar credenciais ou dados sensíveis aqui.
- Manter `architecture.md` como fonte única da visão global.

## Maintenance Checklist
- Revisar `architecture.md` após mudanças estruturais.
- Validar consistência do `workflow-macos-m4-tahoe.json` com `jq`.
- Atualizar prompts em `ai-awareness-contexts/` sempre que houver alterações no hardware ou stack principal.
