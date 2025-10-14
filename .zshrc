# shell core environment
eval "$(/opt/homebrew/bin/brew shellenv)"

# PATH configuration
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$HOME/Tools/bin:$HOME/.local/bin:$PATH"

# aliases
alias checksh="shellcheck"
alias ll="ls -lah"

# pyenv initialization
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# pipx applications
if command -v pipx >/dev/null; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
