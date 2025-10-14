#!/bin/bash

# === macOS Local + VPS Dev Setup - CLI Seguro (sem mkcert, sem perfis, sem certificados locais) ===
# Autor: Luiz Sena
# Objetivo: Rodar ambientes locais e remotos em Safari e IA com mínima intervenção manual

# ========================
# 1. Instalações essenciais via Homebrew
# ========================
brew install http-server
brew install ngrok
brew install nss

# ========================
# 2. Criar servidor local HTTP em porta padrão
# ========================
mkdir -p ~/Dev/preview
cd ~/Dev/preview
echo "<h1>Servidor local ativo</h1>" > index.html
http-server -p 3000 &

# ========================
# 3. Abrir ambiente local no Safari (localhost sem certificado)
# ========================
open "http://localhost:3000"

# ========================
# 4. Comando para servidor HTTP na VPS Ubuntu (executar no VPS)
# ========================
echo "No VPS, execute:"
echo "python3 -m http.server 8000"

# ========================
# 5. Acessar servidor remoto HTTP pelo Safari
# ========================
open "http://147.79.81.59:8000"

# ========================
# 6. Tunnel HTTPS seguro com NGROK (executar no VPS)
# ========================
echo "No VPS, execute após login no NGROK:"
echo "ngrok config add-authtoken SEU_TOKEN_AQUI"
echo "ngrok http 8000"

# ========================
# 7. Menu Desenvolvedor no Safari (habilitar recursos avançados)
# ========================
defaults write com.apple.Safari IncludeDevelopMenu -bool true

# ========================
# 8. Desativar cache do Safari para debugging local (opcional)
# ========================
echo "No Safari, vá em: Desenvolvedor > Desativar cache"

# ========================
# 9. Encerrar servidores locais (limpeza)
# ========================
# killall http-server
# killall ngrok

# ========================
# 10. Final
# ========================
echo "✅ Ambiente de desenvolvimento local e remoto iniciado com segurança e compatibilidade com Safari."

