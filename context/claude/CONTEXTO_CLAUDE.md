# 🤖 Contexto Claude

**Baseado em**: `~/Dotfiles/context/global/CONTEXTO_GLOBAL_COMPLETO.md`

## Ambiente de Desenvolvimento

- **Base**: `~/Dotfiles` (governança centralizada)
- **Sistema**: macOS Silicon ou Ubuntu VPS
- **Stack**: Node.js 20, Python 3.11, Docker

## Estrutura de Diretórios

```
~/Dotfiles/
├── configs/          # Configurações padronizadas
├── credentials/       # Credenciais locais (não versionado)
├── scripts/          # Scripts de automação
├── templates/        # Templates
└── context/          # Contexto para IAs
```

## Credenciais

- **Fonte**: 1Password (vault: 1p_macos ou Personal)
- **Sincronização**: `~/Dotfiles/scripts/sync/sync-1password-to-dotfiles.sh`
- **Local**: `~/Dotfiles/credentials/` (chmod 600)

## Projeto GCP

- ID: `gcp-ai-setup-24410`
- Service Account: `~/Dotfiles/credentials/service-accounts/gcp-ai-setup-24410.json`

## Comandos Importantes

```bash
# Setup completo
cd ~/Dotfiles && ./scripts/setup/master.sh

# Sincronizar credenciais
./scripts/sync/sync-1password-to-dotfiles.sh

# Configurar OAuth local
./scripts/governance/setup-oauth-local.sh
```

## Hostinger API

- **MCP Server**: Configurado em `~/Dotfiles/configs/mcp/claude-mcp-servers.json`
- **API Token**: `HOSTINGER_API_TOKEN` (1Password: `API-VPS-HOSTINGER`)
- **Documentação**: `~/Dotfiles/docs/HOSTINGER_API_SETUP.md`
- **Configuração MCP**: Usar formato com `inputs` e `servers` conforme `claude-mcp-servers.json`

## Referências

- **System Prompt Claude**: `~/Dotfiles/prompts/system_prompts/4.0.prompt_claude_infraestrutura.md`
- **Documentação**: `~/Dotfiles/docs/`
- **MCP Configs**: `~/Dotfiles/configs/mcp/claude-mcp-servers.json`

**Última atualização**: 2025-01-17
