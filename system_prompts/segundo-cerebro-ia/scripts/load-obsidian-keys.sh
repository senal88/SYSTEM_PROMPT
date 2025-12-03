#!/usr/bin/env bash
# Carrega credenciais do Segundo Cérebro IA via 1Password

if ! command -v op &>/dev/null; then
    echo "[ERROR] 1Password CLI não instalado"
    return 1
fi

if ! op account list &>/dev/null; then
    echo "[ERROR] 1Password CLI não autenticado. Execute: eval $(op signin)"
    return 1
fi

# Obsidian
export OBSIDIAN_API_KEY=$(op read "op://1p_macos/Obsidian MCP API Key/credential" 2>/dev/null || echo "")

# Cloudinary
export CLOUDINARY_CLOUD_NAME=$(op read "op://1p_macos/Cloudinary API Credentials/cloud_name" 2>/dev/null || echo "")
export CLOUDINARY_API_KEY=$(op read "op://1p_macos/Cloudinary API Credentials/api_key" 2>/dev/null || echo "")
export CLOUDINARY_API_SECRET=$(op read "op://1p_macos/Cloudinary API Credentials/api_secret" 2>/dev/null || echo "")

# OpenAI (Whisper)
export OPENAI_API_KEY=$(op read "op://1p_macos/OpenAI API Key/credential" 2>/dev/null || echo "")

echo "[✓] Credenciais carregadas:"
[[ -n "$OBSIDIAN_API_KEY" ]] && echo "  ✓ OBSIDIAN_API_KEY"
[[ -n "$CLOUDINARY_CLOUD_NAME" ]] && echo "  ✓ CLOUDINARY_*"
[[ -n "$OPENAI_API_KEY" ]] && echo "  ✓ OPENAI_API_KEY"

return 0
