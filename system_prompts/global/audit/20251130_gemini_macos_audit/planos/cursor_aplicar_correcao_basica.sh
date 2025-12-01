#!/usr/bin/env bash
set -euo pipefail

# Script de correção base – a ser refinado pelo Cursor 2.1
# Responsabilidades mínimas:
# 1. Backup seguro do ~/.zshrc
# 2. Ajustes de PATH e plugins conforme plano
# 3. Integração com 1Password (op) quando necessário

BACKUP_DIR="${HOME}/.zsh_backups"
mkdir -p "${BACKUP_DIR}"

if [ -f "${HOME}/.zshrc" ]; then
  cp "${HOME}/.zshrc" "${BACKUP_DIR}/zshrc_$(date +%Y%m%d_%H%M%S).bak"
fi

# PONTO DE ANCORAGEM PARA CURSOR 2.1:
# Comandos de correção inseridos automaticamente.

echo "--- Iniciando Correções ---"

# 1. Instalar linguagens ausentes
echo "Instalando Go e Rust..."
brew install go rust

# 2. Instalar dependências CLI ausentes
echo "Instalando dependências CLI: bat, eza, zoxide, lazygit..."
brew install bat eza zoxide lazygit

# 3. Instalar Nerd Font
echo "Instalando Nerd Font (JetBrains Mono)..."
brew install --cask font-jetbrains-mono-nerd-font

# 4. Lembretes manuais
echo
echo "--- Ações Manuais Necessárias ---"
echo "Lembrete: A sessão do 1Password CLI ('op') não está autenticada."
echo "Execute 'op signin' e siga as instruções para habilitar a integração."
echo
echo "Lembrete: O plano de correção sugere a revisão do seu arquivo ~/.zshrc."
echo "Verifique a ordem de carregamento do PATH e dos plugins para garantir que as novas ferramentas funcionem corretamente."
echo
echo "--- Correções Concluídas ---"
