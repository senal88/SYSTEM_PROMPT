# ~/.bashrc - Configuração do Bash
# Gerado automaticamente - 2025-10-28

# Se não estiver rodando interativamente, não fazer nada
case $- in
    *i*) ;;
      *) return;;
esac

# Histórico
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Verificar tamanho da janela após cada comando
shopt -s checkwinsize

# Habilitar completação
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Aliases úteis
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Aliases para desenvolvimento
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Aliases para Docker
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'

# Aliases para Python
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Aliases para Node.js
alias ni='npm install'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nd='npm run dev'

# Aliases para auditoria
alias audit='cd /Users/luiz.sena88/auditoria'
alias projects='cd /Users/luiz.sena88/Projetos'
alias infra='cd /Users/luiz.sena88/infra'

# Cores para ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
fi

# Prompt personalizado
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Variáveis de ambiente
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# Path personalizado
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Configurações específicas do macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Homebrew
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    # Aliases específicos do macOS
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
    alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
fi

# Configurações específicas do Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Aliases específicos do Linux
    alias open='xdg-open'
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

# Funções úteis
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Função para criar projeto com template
create_project() {
    if [ -z "$1" ]; then
        echo "Uso: create_project <nome_do_projeto>"
        return 1
    fi
    
    local project_name="$1"
    local project_dir="/Users/luiz.sena88/Projetos/$project_name"
    
    if [ -d "$project_dir" ]; then
        echo "Projeto $project_name já existe!"
        return 1
    fi
    
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    # Copiar templates
    cp /Users/luiz.sena88/Dotfiles/templates/README.md .
    cp /Users/luiz.sena88/Dotfiles/templates/.editorconfig .
    cp /Users/luiz.sena88/Dotfiles/templates/.gitignore .
    cp /Users/luiz.sena88/Dotfiles/templates/Makefile .
    
    # Inicializar git
    git init
    git add .
    git commit -m "Initial commit"
    
    echo "Projeto $project_name criado com sucesso!"
}

# Função para auditoria rápida
quick_audit() {
    cd /Users/luiz.sena88/auditoria
    bash scripts/executar_auditoria_completa.sh
}

# Função para limpeza do sistema
clean_system() {
    echo "Limpando sistema..."
    
    # Remover arquivos .DS_Store
    find /Users/luiz.sena88 -name ".DS_Store" -delete 2>/dev/null
    
    # Limpar cache NPM
    npm cache clean --force 2>/dev/null
    
    # Limpar cache Python
    pyenv cache clear 2>/dev/null
    
    echo "Limpeza concluída!"
}

# Carregar configurações específicas do sistema
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

# Mensagem de boas-vindas
echo "Bash configurado! Use 'help' para ver comandos disponíveis."
