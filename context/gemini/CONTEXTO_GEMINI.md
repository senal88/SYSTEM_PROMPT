# 🌟 Contexto Gemini

**Baseado em**: `~/Dotfiles/context/global/CONTEXTO_GLOBAL_COMPLETO.md`

## Configuração Gemini

- **Projeto GCP**: `gcp-ai-setup-24410` (501288307921)
- **Região**: `us-central1`
- **Service Account**: `gemini-vps-agent@gcp-ai-setup-24410.iam.gserviceaccount.com`

## Credenciais

- **API Key**: Sincronizada via 1Password → `~/Dotfiles/credentials/api-keys/GEMINI_API_KEY.local`
- **Google API Key**: Sincronizada via 1Password → `~/Dotfiles/credentials/api-keys/GOOGLE_API_KEY.local`
- **Service Account**: `~/Dotfiles/credentials/service-accounts/gcp-ai-setup-24410.json`

## Configurações Aplicadas

- **VSCode**: Gemini Code Assist configurado
- **Cursor**: Gemini Code Assist configurado
- **CLI**: `~/.config/gemini/config.yaml`

## Sincronização

```bash
# Sincronizar credenciais do 1Password
cd ~/Dotfiles && ./scripts/sync/sync-1password-to-dotfiles.sh

# Instalar extensões e configurar
./scripts/install/google-extensions.sh
```

**Última atualização**: $(date +%Y-%m-%d)
