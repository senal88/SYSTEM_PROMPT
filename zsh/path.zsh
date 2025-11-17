# ~/.dotfiles/zsh/path.zsh
#
# Este arquivo gerencia a variável de ambiente $PATH de forma centralizada.

# Função para adicionar um diretório ao PATH, evitando duplicatas.
add_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

# 1. Caminhos base do sistema
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# 2. Homebrew - A forma correta de inicializar é com brew shellenv
if command -v brew >/dev/null 2>&1; then
    # Verifica se o comando brew shellenv existe e funciona
    brew_env=$(brew shellenv 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$brew_env" ]; then
        eval "$brew_env"
    fi
fi

# 3. Ferramentas de desenvolvimento e de usuário
add_to_path "$HOME/.local/bin" # pipx e outros scripts locais
add_to_path "$HOME/bin"         # Scripts pessoais do usuário

# 4. Gerenciadores de versão (Pyenv, NVM)
# Pyenv
if command -v pyenv >/dev/null 2>&1; then
    pyenv_root=$(pyenv root 2>/dev/null)
    if [ -n "$pyenv_root" ] && [ -d "$pyenv_root/bin" ]; then
        add_to_path "$pyenv_root/bin"
    fi
    # Inicializa pyenv (pode falhar silenciosamente se não estiver completamente configurado)
    eval "$(pyenv init --path)" 2>/dev/null || true
fi

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    # Carrega nvm silenciosamente, capturando erros
    source "$NVM_DIR/nvm.sh" 2>/dev/null || true
fi

# 5. Scripts do próprio Dotfiles
if [ -d "$DOTFILES_HOME/scripts" ]; then
    add_to_path "$DOTFILES_HOME/scripts"
fi

# 6. Aplicações GUI com CLIs
add_to_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
add_to_path "/Applications/Cursor.app/Contents/Resources/app/bin"

# 7. Ferramentas de IA e ML
add_to_path "$HOME/.lmstudio/bin" # LM Studio CLI

# 8. Raycast Scripts (Consolidado)
# Adiciona o diretório principal e o de scripts do Raycast ao PATH
add_to_path "$HOME/Dotfiles/raycast"
if [ -d "$HOME/Dotfiles/raycast/scripts" ]; then
    add_to_path "$HOME/Dotfiles/raycast/scripts"
fi

# Exporta o PATH final
export PATH
