# 💬 Contexto ChatGPT

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

# Atualizar contexto
./scripts/context/update-global-context.sh
```

## Ambientes Suportados

- macOS Silicon
- Ubuntu VPS (147.79.81.59)
- DevContainers
- GitHub Codespaces

**Última atualização**: $(date +%Y-%m-%d)
