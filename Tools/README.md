# 🧰 Tools

## Role
Concentra scripts utilitários, shells customizados, templates JSON e bins auxiliares que suportam manutenção e automação.

## Allowed Operations
- Human: criar/editar scripts, rodar utilitários, versionar melhorias.
- GPT Expert: sugerir ajustes, gerar novos scripts dentro de `scripts/` ou `json_templates/`, nunca executar automaticamente.

## Guardrails
- Aplique `chmod 700` em scripts confidenciais.
- Documente cada ferramenta em comentários breves dentro do próprio arquivo.

## Maintenance Checklist
- Rodar `shellcheck` periodicamente em `scripts/*.sh`.
- Atualizar dependências citadas nos scripts após upgrades do sistema.
- Garantir que `install_essential_extensions.sh` reflita o estado atual das extensões VS Code.
