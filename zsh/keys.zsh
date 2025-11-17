# ~/.dotfiles/zsh/keys.zsh
#
# Este arquivo gerencia o carregamento de chaves de API e segredos.

if [[ -f "$HOME/.zsh_secrets" ]]; then
    source "$HOME/.zsh_secrets"
fi
