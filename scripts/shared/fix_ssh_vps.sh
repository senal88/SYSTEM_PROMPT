#!/bin/bash

# ============================================
# Script de Correção: SSH VPS
# ============================================
# Corrige problemas comuns de SSH no VPS
# ============================================

set -e

echo "============================================"
echo "🔧 Correção SSH VPS"
echo "============================================"
echo ""

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 1. Verificar e corrigir .profile
echo "1️⃣  Verificando /root/.profile..."
if [ -f /root/.profile ]; then
    # Verificar se há "er" na primeira linha
    FIRST_LINE=$(head -1 /root/.profile | tr -d '\n\r')
    if [ "$FIRST_LINE" = "er" ]; then
        echo -e "   ${YELLOW}⚠️  Problema detectado: 'er' na primeira linha${NC}"
        echo "   💾 Criando backup..."
        cp /root/.profile /root/.profile.backup.$(date +%Y%m%d_%H%M%S)

        # Criar .profile correto
        cat > /root/.profile << 'PROFILE_EOF'
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private local bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# disable message of the day
mesg n 2> /dev/null || true
PROFILE_EOF

        echo -e "   ${GREEN}✅ .profile corrigido${NC}"
    else
        echo -e "   ${GREEN}✅ .profile parece estar correto${NC}"
    fi
else
    echo -e "   ${YELLOW}⚠️  .profile não existe, criando...${NC}"
    # Criar .profile padrão
    cat > /root/.profile << 'PROFILE_EOF'
# ~/.profile: executed by the command interpreter for login shells.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# disable message of the day
mesg n 2> /dev/null || true
PROFILE_EOF
    echo -e "   ${GREEN}✅ .profile criado${NC}"
fi

# 2. Verificar .bashrc
echo ""
echo "2️⃣  Verificando /root/.bashrc..."
if [ -f /root/.bashrc ]; then
    echo -e "   ${GREEN}✅ .bashrc existe${NC}"
else
    echo -e "   ${YELLOW}⚠️  .bashrc não existe${NC}"
    # Criar .bashrc básico
    cat > /root/.bashrc << 'BASHRC_EOF'
# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Append to history file, don't overwrite it
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
BASHRC_EOF
    echo -e "   ${GREEN}✅ .bashrc criado${NC}"
fi

# 3. Verificar permissões SSH
echo ""
echo "3️⃣  Verificando permissões SSH..."
SSH_DIR="/root/.ssh"
if [ -d "$SSH_DIR" ]; then
    chmod 700 "$SSH_DIR"
    echo -e "   ${GREEN}✅ Permissões do diretório .ssh: 700${NC}"

    # Verificar authorized_keys
    if [ -f "$SSH_DIR/authorized_keys" ]; then
        chmod 600 "$SSH_DIR/authorized_keys"
        echo -e "   ${GREEN}✅ Permissões de authorized_keys: 600${NC}"
    fi

    # Verificar config
    if [ -f "$SSH_DIR/config" ]; then
        chmod 600 "$SSH_DIR/config"
        echo -e "   ${GREEN}✅ Permissões de config: 600${NC}"
    fi
else
    echo -e "   ${YELLOW}⚠️  Diretório .ssh não existe${NC}"
fi

# 4. Verificar configuração SSH do servidor
echo ""
echo "4️⃣  Verificando configuração SSH do servidor..."
if [ -f /etc/ssh/sshd_config ]; then
    echo -e "   ${GREEN}✅ sshd_config existe${NC}"

    # Verificar se PermitRootLogin está configurado
    if grep -q "^PermitRootLogin" /etc/ssh/sshd_config; then
        PERMIT_ROOT=$(grep "^PermitRootLogin" /etc/ssh/sshd_config | awk '{print $2}')
        echo "   PermitRootLogin: $PERMIT_ROOT"
    else
        echo -e "   ${YELLOW}⚠️  PermitRootLogin não configurado${NC}"
    fi
else
    echo -e "   ${RED}❌ sshd_config não encontrado${NC}"
fi

# 5. Testar sintaxe do .profile
echo ""
echo "5️⃣  Testando sintaxe do .profile..."
if bash -n /root/.profile 2>/dev/null; then
    echo -e "   ${GREEN}✅ Sintaxe do .profile está correta${NC}"
else
    echo -e "   ${RED}❌ Erro de sintaxe no .profile${NC}"
    bash -n /root/.profile
fi

echo ""
echo "============================================"
echo -e "${GREEN}✅ Correção concluída!${NC}"
echo "============================================"
echo ""
echo "📋 Próximos passos:"
echo "   1. Teste a conexão SSH: ssh vps"
echo "   2. O erro 'er: command not found' não deve mais aparecer"
echo "   3. Se necessário, reinicie o serviço SSH: systemctl restart sshd"
echo ""

