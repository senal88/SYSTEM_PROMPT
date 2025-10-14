#!/bin/bash
set -euo pipefail

PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH

LOG_DIR="$HOME/Documentation/logs"
LOG_FILE="$LOG_DIR/install_shellcheck.log"
mkdir -p "$LOG_DIR"

log() {
    printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"
}

log "Starting ShellCheck installation workflow."

if command -v shellcheck >/dev/null 2>&1; then
    log "ShellCheck already installed: $(shellcheck --version | tr '\n' ' ')"
    exit 0
fi

brew_available=true
if ! command -v brew >/dev/null 2>&1; then
    log "Homebrew not found in PATH; skipping brew-based installation."
    brew_available=false
fi

if [ "$brew_available" = true ]; then
    if brew list --formula shellcheck >/dev/null 2>&1; then
        log "ShellCheck already managed by Homebrew but command not in PATH; check brew shellenv."
    else
        log "Attempting 'brew install shellcheck'."
        if brew install shellcheck >>"$LOG_FILE" 2>&1; then
            log "ShellCheck installed via Homebrew."
        else
            log "Primary Homebrew install failed; attempting '--build-from-source'."
            if brew install --build-from-source shellcheck >>"$LOG_FILE" 2>&1; then
                log "ShellCheck compiled from source via Homebrew."
            else
                log "Homebrew installation paths failed; will use manual fallback."
            fi
        fi
    fi

    if command -v shellcheck >/dev/null 2>&1; then
        if ! grep -q "alias checksh=" "$HOME/.zshrc" 2>/dev/null; then
            echo "alias checksh='shellcheck'" >> "$HOME/.zshrc"
            log "Alias 'checksh' appended to ~/.zshrc."
        fi
        log "Installation completed using Homebrew."
        exit 0
    fi
fi

log "Initiating manual installation fallback."
TMP_DIR="$(mktemp -d)"
VERSION="v0.9.0"
ARCHIVE_ARM64="shellcheck-${VERSION}.darwin.aarch64.tar.xz"
ARCHIVE_X86="shellcheck-${VERSION}.darwin.x86_64.tar.xz"
BASE_URL="https://github.com/koalaman/shellcheck/releases/download/${VERSION}"

UNAME_ARCH="$(uname -m)"
if [ "$UNAME_ARCH" = "arm64" ]; then
    ARCHIVE="$ARCHIVE_ARM64"
else
    ARCHIVE="$ARCHIVE_X86"
fi

log "Downloading ${ARCHIVE} from upstream."
cd "$TMP_DIR"
if ! curl -fSLO "$BASE_URL/$ARCHIVE" >>"$LOG_FILE" 2>&1; then
    log "Download failed. Verify network connectivity or release availability."
    exit 1
fi

log "Extracting archive ${ARCHIVE}."
if ! tar -xf "$ARCHIVE" >>"$LOG_FILE" 2>&1; then
    log "Extraction failed for ${ARCHIVE}."
    exit 1
fi

EXTRACTED_DIR="shellcheck-${VERSION}"
if [ ! -x "$EXTRACTED_DIR/shellcheck" ]; then
    log "ShellCheck binary missing after extraction."
    exit 1
fi

if [ "$UNAME_ARCH" = "arm64" ] && [ ! -f "$EXTRACTED_DIR/shellcheck" ]; then
    log "ARM64 archive unavailable; attempting x86_64 binary via Rosetta."
    ARCHIVE="$ARCHIVE_X86"
    rm -rf "${TMP_DIR:?}"/*
    curl -fSLO "$BASE_URL/$ARCHIVE" >>"$LOG_FILE" 2>&1
    tar -xf "$ARCHIVE" >>"$LOG_FILE" 2>&1
fi

DEST_DIR="/opt/homebrew/bin"
if [ ! -d "$DEST_DIR" ]; then
    DEST_DIR="/usr/local/bin"
fi

log "Copying binary to ${DEST_DIR}."
install -m 755 "$EXTRACTED_DIR/shellcheck" "$DEST_DIR/shellcheck"

if ! command -v shellcheck >/dev/null 2>&1; then
    log "ShellCheck not accessible after manual install; adjust PATH or permissions."
    exit 1
fi

if ! grep -q "alias checksh=" "$HOME/.zshrc" 2>/dev/null; then
    echo "alias checksh='shellcheck'" >> "$HOME/.zshrc"
    log "Alias 'checksh' appended to ~/.zshrc."
fi

log "ShellCheck installation successful via manual fallback."
log "Please run 'source ~/.zshrc' or restart the terminal before using the alias."

rm -rf "$TMP_DIR"
exit 0
