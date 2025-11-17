#!/usr/bin/env bash

# Raycast bootstrap helper
# ------------------------
# Automates package installs, Raycast hotkey configuration, and profile sync.
# All behaviour can be tuned via environment variables or configs/raycast.env.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${CONFIG_FILE:-"$SCRIPT_DIR/configs/raycast.env"}"

BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

log() {
  local level="$1"; shift
  printf "%b[%s] %s%b\n" "$BLUE" "$level" "$*" "$RESET"
}

success() {
  printf "%b[OK]%b %s\n" "$GREEN" "$RESET" "$*"
}

warn() {
  printf "%b[WARN]%b %s\n" "$YELLOW" "$RESET" "$*"
}

fail() {
  printf "%b[ERR]%b %s\n" "$RED" "$RESET" "$*"
  exit 1
}

# shellcheck disable=SC1090
if [[ -f "$CONFIG_FILE" ]]; then
  log INFO "Carregando configuração de $CONFIG_FILE"
  set -a
  source "$CONFIG_FILE"
  set +a
else
  warn "Arquivo de configuração não encontrado em $CONFIG_FILE, usando valores padrão."
fi

PROFILE_SRC="${PROFILE_SRC:-${RAYCAST_PROFILE_SRC:-"$SCRIPT_DIR/raycast-profile"}}"
PROFILE_DST="${PROFILE_DST:-${RAYCAST_PROFILE_DST:-"$HOME/Library/Application Support/com.raycast.macos"}}"
BREW_CASKS="${BREW_CASKS:-${RAYCAST_BREW_CASKS:-"raycast 1password visual-studio-code docker google-chrome karabiner-elements"}}"
BREW_FORMULAE="${BREW_FORMULAE:-${RAYCAST_BREW_FORMULAE:-"1password-cli rsync jq"}}"
DISABLE_SPOTLIGHT="${DISABLE_SPOTLIGHT:-${RAYCAST_DISABLE_SPOTLIGHT:-true}}"
SET_RAYCAST_HOTKEY="${SET_RAYCAST_HOTKEY:-${RAYCAST_SET_HOTKEY:-true}}"

ACTION="full"

print_usage() {
  cat <<EOF
Uso: $(basename "$0") [opções]

Opções:
  --profile-src <caminho>   Define diretório fonte do backup (default: $PROFILE_SRC)
  --profile-dst <caminho>   Define diretório destino do Raycast (default: $PROFILE_DST)
  --backup                  Exporta configurações atuais para o diretório fonte
  --restore                 Restaura configurações do diretório fonte
  --install-only            Apenas instala dependências e ajusta atalhos
  --skip-install            Pula instalação de dependências (usado com --restore)
  --help                    Mostra esta ajuda

Também é possível definir variáveis de ambiente:
  PROFILE_SRC, PROFILE_DST, BREW_CASKS, BREW_FORMULAE,
  DISABLE_SPOTLIGHT, SET_RAYCAST_HOTKEY.
EOF
}

SKIP_INSTALL=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile-src)
      PROFILE_SRC="$2"
      shift 2
      ;;
    --profile-dst)
      PROFILE_DST="$2"
      shift 2
      ;;
    --backup)
      ACTION="backup"
      shift
      ;;
    --restore)
      ACTION="restore"
      shift
      ;;
    --install-only)
      ACTION="install"
      shift
      ;;
    --skip-install)
      SKIP_INSTALL=true
      shift
      ;;
    --help|-h)
      print_usage
      exit 0
      ;;
    *)
      print_usage
      fail "Opção desconhecida: $1"
      ;;
  esac
done

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    success "Homebrew já disponível."
    return
  fi

  log INFO "Homebrew não encontrado, instalando..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    success "Homebrew instalado com sucesso."
  else
    fail "Instalação do Homebrew falhou."
  fi
}

install_formulae() {
  [[ -z "$BREW_FORMULAE" ]] && return

  for formula in $BREW_FORMULAE; do
    if brew list "$formula" >/dev/null 2>&1; then
      success "$formula já instalado."
    else
      log INFO "Instalando $formula..."
      brew install "$formula"
    fi
  done
}

install_casks() {
  [[ -z "$BREW_CASKS" ]] && return

  for cask in $BREW_CASKS; do
    if brew list --cask "$cask" >/dev/null 2>&1; then
      success "$cask já instalado."
    else
      log INFO "Instalando $cask..."
      brew install --cask "$cask"
    fi
  done
}

disable_spotlight_hotkey() {
  [[ "$DISABLE_SPOTLIGHT" != "true" ]] && return
  local plist="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"

  if [[ ! -f "$plist" ]]; then
    warn "Não encontrei $plist; Spotlight pode já estar desativado."
    return
  fi

  /usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:64:enabled false" "$plist" 2>/dev/null || warn "Falha ao desativar Spotlight (64)."
  /usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:65:enabled false" "$plist" 2>/dev/null || warn "Falha ao desativar Spotlight (65)."
  killall Dock >/dev/null 2>&1 || true
  success "Atalho padrão do Spotlight desativado."
}

configure_raycast_hotkey() {
  [[ "$SET_RAYCAST_HOTKEY" != "true" ]] && return

  local hotkey_hex
  hotkey_hex="$(printf '%s' '{ "key": 49, "modifiers": 1048576 }' | iconv -f utf-8 -t utf-16 | xxd -p | tr -d '\n')"
  defaults write com.raycast.macos hotkey -data "$hotkey_hex"
  killall "Raycast" >/dev/null 2>&1 || true
  success "Atalho do Raycast configurado para ⌘ Espaço."
}

restore_profile() {
  if [[ ! -d "$PROFILE_SRC" ]]; then
    fail "Diretório de origem não encontrado: $PROFILE_SRC"
  fi

  mkdir -p "$PROFILE_DST"
  rsync -avh --delete "$PROFILE_SRC"/ "$PROFILE_DST"/
  success "Perfil do Raycast restaurado de $PROFILE_SRC para $PROFILE_DST."
}

backup_profile() {
  if [[ ! -d "$PROFILE_DST" ]]; then
    fail "Diretório de destino não encontrado: $PROFILE_DST"
  fi

  mkdir -p "$PROFILE_SRC"
  rsync -avh --delete "$PROFILE_DST"/ "$PROFILE_SRC"/
  success "Backup do Raycast salvo em $PROFILE_SRC."
}

full_run() {
  if [[ "$SKIP_INSTALL" == "false" ]]; then
    ensure_homebrew
    brew update
    install_formulae
    install_casks
    disable_spotlight_hotkey
    configure_raycast_hotkey
  else
    log INFO "Instalação pulada (--skip-install)."
  fi

  restore_profile

  warn "Abra o Raycast para conceder permissões de Acessibilidade/Automação quando solicitado."
  warn "Lembre-se de ativar a Hyper Key no Karabiner Elements caso esteja instalada."
}

case "$ACTION" in
  full)
    full_run
    ;;
  restore)
    "$SKIP_INSTALL" || warn "Somente restauração solicitada; instalações não serão executadas."
    restore_profile
    ;;
  install)
    ensure_homebrew
    brew update
    install_formulae
    install_casks
    disable_spotlight_hotkey
    configure_raycast_hotkey
    warn "Instalação concluída. Use --restore ou --backup conforme necessário."
    ;;
  backup)
    backup_profile
    ;;
  *)
    fail "Ação desconhecida: $ACTION"
    ;;
esac
