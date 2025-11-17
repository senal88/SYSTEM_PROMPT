# 🎯 Contexto Cursor 2.0

**Baseado em**: `~/Dotfiles/context/global/CONTEXTO_GLOBAL_COMPLETO.md`

## Configurações Aplicadas

- Settings: `~/Dotfiles/configs/cursor/settings.json`
- Keybindings: `~/Dotfiles/configs/cursor/keybindings.json`
- Extensões: `~/Dotfiles/configs/extensions/recommended.json`

## Projeto GCP

- ID: `gcp-ai-setup-24410`
- Região: `us-central1`

## Credenciais

- Fonte: 1Password (vault: 1p_macos ou Personal)
- Local: `~/Dotfiles/credentials/` (não versionado)
- Sincronização: `~/Dotfiles/scripts/sync/sync-1password-to-dotfiles.sh`

## Comandos Úteis

```bash
# Aplicar configurações
cd ~/Dotfiles && ./scripts/install/cursor.sh

# Sincronizar credenciais
./scripts/sync/sync-1password-to-dotfiles.sh

# Atualizar contexto
./scripts/context/update-global-context.sh
```

## Hostinger API

- **MCP Server**: `hostinger-mcp` (configurado em `~/Dotfiles/configs/mcp-servers.json`)
- **API Token**: `HOSTINGER_API_TOKEN` (1Password: `API-VPS-HOSTINGER`)
- **Documentação**: `~/Dotfiles/docs/HOSTINGER_API_SETUP.md`
- **Scripts Raycast**: `~/Dotfiles/scripts/raycast/hostinger-api.sh`

## Referências

- **System Prompt Cursor**: `~/Dotfiles/prompts/system_prompts/4.3.prompt_cursor_infraestrutura.md`
- **Configurações Cursor**: `~/Dotfiles/configs/cursor/`
- **MCP Configs**: `~/Dotfiles/configs/mcp/`

**Última atualização**: 2025-01-17
