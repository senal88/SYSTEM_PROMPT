#!/bin/bash
# Script de Inicialização Automática do 1Password
# Verifica e configura automaticamente o ambiente 1Password

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Diretórios
OP_CONFIG_DIR="$HOME/.config/op"
OP_VAULT_DATA_DIR="$OP_CONFIG_DIR/vault_data"
OP_VAULT_CONFIG="$OP_CONFIG_DIR/vault_config.json"
OP_CONFIG_SCRIPT="$OP_CONFIG_DIR/op_config.sh"

# Função para verificar se está logado
check_signin() {
    if op whoami &>/dev/null; then
        echo -e "${GREEN}✅ Autenticado no 1Password${NC}"
        op whoami
        return 0
    else
        echo -e "${YELLOW}⚠️  Não está logado no 1Password${NC}"
        return 1
    fi
}

# Função para fazer login automático
auto_signin() {
    echo -e "${BLUE}🔐 Fazendo login automático...${NC}"
    if eval "$(op signin)"; then
        echo -e "${GREEN}✅ Login realizado com sucesso${NC}"
        op whoami
        return 0
    else
        echo -e "${RED}❌ Erro ao fazer login${NC}" >&2
        return 1
    fi
}

# Função para verificar configuração de Connect
check_connect() {
    if [ -n "${OP_CONNECT_HOST:-}" ] || [ -n "${OP_CONNECT_TOKEN:-}" ]; then
        echo -e "${YELLOW}⚠️  Connect está ativo${NC}"
        echo -e "${BLUE}   Host: ${OP_CONNECT_HOST:-N/A}${NC}"
        echo -e "${BLUE}   Use 'op-connect-disable' para usar CLI${NC}"
        return 1
    else
        echo -e "${GREEN}✅ CLI configurado corretamente (sem Connect)${NC}"
        return 0
    fi
}

# Função para verificar vault padrão
check_default_vault() {
    if [ -f "$OP_CONFIG_SCRIPT" ]; then
        source "$OP_CONFIG_SCRIPT" 2>/dev/null || true

        if [ -n "${OP_DEFAULT_VAULT:-}" ]; then
            local vault_name
            if command -v op-vault-name &>/dev/null; then
                vault_name=$(op-vault-name "$OP_DEFAULT_VAULT")
            else
                vault_name="$OP_DEFAULT_VAULT"
            fi

            echo -e "${GREEN}✅ Vault padrão: $vault_name ($OP_DEFAULT_VAULT)${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠️  Vault padrão não configurado${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️  Arquivo de configuração não encontrado: $OP_CONFIG_SCRIPT${NC}"
        return 1
    fi
}

# Função para listar vaults disponíveis
list_vaults() {
    echo -e "${BLUE}📦 Vaults disponíveis:${NC}"
    if op vault list &>/dev/null; then
        op vault list
        return 0
    else
        echo -e "${RED}❌ Erro ao listar vaults${NC}" >&2
        return 1
    fi
}

# Função para verificar estrutura de diretórios
check_directories() {
    local missing=0

    if [ ! -d "$OP_CONFIG_DIR" ]; then
        echo -e "${YELLOW}⚠️  Criando diretório: $OP_CONFIG_DIR${NC}"
        mkdir -p "$OP_CONFIG_DIR"
    fi

    if [ ! -d "$OP_VAULT_DATA_DIR" ]; then
        echo -e "${YELLOW}⚠️  Criando diretório: $OP_VAULT_DATA_DIR${NC}"
        mkdir -p "$OP_VAULT_DATA_DIR"
    fi

    if [ ! -f "$OP_VAULT_CONFIG" ]; then
        echo -e "${YELLOW}⚠️  Arquivo de configuração não encontrado: $OP_VAULT_CONFIG${NC}"
        missing=1
    fi

    if [ ! -f "$OP_CONFIG_SCRIPT" ]; then
        echo -e "${YELLOW}⚠️  Script de configuração não encontrado: $OP_CONFIG_SCRIPT${NC}"
        missing=1
    fi

    if [ $missing -eq 0 ]; then
        echo -e "${GREEN}✅ Estrutura de diretórios OK${NC}"
        return 0
    else
        echo -e "${RED}❌ Estrutura de diretórios incompleta${NC}" >&2
        return 1
    fi
}

# Função principal
main() {
    echo -e "${BLUE}🚀 Inicializando ambiente 1Password...${NC}"
    echo ""

    local errors=0

    # 1. Verifica estrutura de diretórios
    echo -e "${BLUE}1. Verificando estrutura de diretórios...${NC}"
    if ! check_directories; then
        ((errors++))
    fi
    echo ""

    # 2. Verifica se está logado
    echo -e "${BLUE}2. Verificando autenticação...${NC}"
    if ! check_signin; then
        echo -e "${BLUE}   Tentando login automático...${NC}"
        if ! auto_signin; then
            ((errors++))
        fi
    fi
    echo ""

    # 3. Verifica configuração de Connect
    echo -e "${BLUE}3. Verificando configuração CLI/Connect...${NC}"
    if ! check_connect; then
        echo -e "${BLUE}   Desativando Connect para usar CLI...${NC}"
        unset OP_CONNECT_HOST OP_CONNECT_TOKEN
        echo -e "${GREEN}✅ Connect desativado${NC}"
    fi
    echo ""

    # 4. Verifica vault padrão
    echo -e "${BLUE}4. Verificando vault padrão...${NC}"
    if ! check_default_vault; then
        ((errors++))
    fi
    echo ""

    # 5. Lista vaults disponíveis
    echo -e "${BLUE}5. Listando vaults disponíveis...${NC}"
    list_vaults
    echo ""

    # Resumo
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}✅ Inicialização concluída com sucesso!${NC}"
        echo ""
        echo -e "${BLUE}📋 Comandos úteis:${NC}"
        echo -e "   ${BLUE}op-config-check${NC}     - Verificar configuração"
        echo -e "   ${BLUE}op-signin-auto${NC}      - Login automático"
        echo -e "   ${BLUE}op-vault-switch${NC}     - Trocar vault padrão"
        echo -e "   ${BLUE}op-connect-enable${NC}   - Ativar Connect"
        echo -e "   ${BLUE}op-connect-disable${NC}   - Desativar Connect"
        echo -e "   ${BLUE}op-export-vault.sh${NC}   - Exportar dados das vaults"
        return 0
    else
        echo -e "${YELLOW}⚠️  Inicialização concluída com $errors erro(s)${NC}"
        echo -e "${YELLOW}   Revise os avisos acima${NC}"
        return 1
    fi
}

# Executa função principal
main

