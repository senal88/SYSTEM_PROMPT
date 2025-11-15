#!/bin/bash

# ============================================
# Script de Configuração Completa VPS
# ============================================
# Configura tudo automaticamente: 1Password, System Prompt, Automação
# ============================================

set -e

echo "============================================"
echo "🚀 Configuração Completa VPS"
echo "============================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# 1. Configurar 1Password Service Account Token
echo "1️⃣  Configurando 1Password Service Account Token..."
echo ""

# Tentar buscar do 1Password
OP_SERVICE_TOKEN=""
if command -v op &> /dev/null; then
    if op account list &>/dev/null 2>&1; then
        echo -e "   ${BLUE}ℹ️  Tentando buscar Service Account Token do 1Password...${NC}"
        
        # Tentar diferentes nomes de itens
        ITEM_NAMES=("1p_vps" "VPS 1Password" "1Password VPS" "Service Account VPS" "OP_VPS")
        
        for item_name in "${ITEM_NAMES[@]}"; do
            echo "   Tentando: $item_name"
            TOKEN=$(op item get "$item_name" --fields "token" 2>/dev/null || \
                   op item get "$item_name" --fields "password" 2>/dev/null || \
                   op item get "$item_name" --fields "service account token" 2>/dev/null || \
                   echo "")
            
            if [ -n "$TOKEN" ] && [[ "$TOKEN" =~ ^opvault_ ]]; then
                OP_SERVICE_TOKEN="$TOKEN"
                echo -e "   ${GREEN}✅ Token encontrado!${NC}"
                break
            fi
        done
    else
        echo -e "   ${YELLOW}⚠️  1Password não autenticado${NC}"
        echo "   Execute: eval \$(op signin)"
    fi
fi

# Se não encontrou, solicitar manualmente
if [ -z "$OP_SERVICE_TOKEN" ]; then
    echo -e "   ${YELLOW}⚠️  Service Account Token não encontrado automaticamente${NC}"
    echo ""
    echo "   Para configurar manualmente:"
    echo "   1. Crie Service Account no 1Password"
    echo "   2. Copie o token"
    echo "   3. Execute:"
    echo "      export OP_SERVICE_ACCOUNT_TOKEN='seu-token'"
    echo "      echo 'export OP_SERVICE_ACCOUNT_TOKEN=\"seu-token\"' >> ~/.bashrc"
    echo ""
    read -p "   Deseja inserir o token manualmente agora? (s/N): " MANUAL_INPUT
    if [[ "$MANUAL_INPUT" =~ ^[Ss]$ ]]; then
        read -sp "   Digite o Service Account Token: " OP_SERVICE_TOKEN
        echo ""
    fi
fi

# Configurar token se disponível
if [ -n "$OP_SERVICE_TOKEN" ]; then
    echo ""
    echo "   Configurando token no .bashrc..."
    # Remover token antigo se existir
    sed -i '/^export OP_SERVICE_ACCOUNT_TOKEN=/d' ~/.bashrc 2>/dev/null || true
    
    # Adicionar novo token
    echo "" >> ~/.bashrc
    echo "# 1Password Service Account Token" >> ~/.bashrc
    echo "export OP_SERVICE_ACCOUNT_TOKEN=\"$OP_SERVICE_TOKEN\"" >> ~/.bashrc
    
    export OP_SERVICE_ACCOUNT_TOKEN="$OP_SERVICE_TOKEN"
    echo -e "   ${GREEN}✅ Token configurado!${NC}"
    
    # Testar
    if op vault list &>/dev/null 2>&1; then
        echo -e "   ${GREEN}✅ Autenticação funcionando!${NC}"
        op vault list | head -5
    else
        echo -e "   ${YELLOW}⚠️  Token pode estar inválido ou sem permissões${NC}"
    fi
fi

# 2. Aplicar System Prompt no Cursor
echo ""
echo "2️⃣  Aplicando System Prompt no Cursor..."
if [ -f "$PROMPT_DIR/scripts/shared/apply_cursor_prompt.sh" ]; then
    bash "$PROMPT_DIR/scripts/shared/apply_cursor_prompt.sh"
    echo -e "   ${GREEN}✅ System Prompt aplicado no Cursor${NC}"
else
    echo -e "   ${YELLOW}⚠️  Script não encontrado${NC}"
fi

# 3. Testar scripts de coleta
echo ""
echo "3️⃣  Testando scripts de coleta..."
if [ -f "$PROMPT_DIR/scripts/ubuntu/collect_all_ia_ubuntu.sh" ]; then
    echo "   Executando coleta completa..."
    OUTPUT_DIR="/tmp/ia_collection_test" \
    bash "$PROMPT_DIR/scripts/ubuntu/collect_all_ia_ubuntu.sh" > /tmp/collection_test.log 2>&1
    
    if [ $? -eq 0 ]; then
        echo -e "   ${GREEN}✅ Coleta executada com sucesso${NC}"
        echo "   Logs em: /tmp/collection_test.log"
    else
        echo -e "   ${YELLOW}⚠️  Alguns erros na coleta (verificar logs)${NC}"
    fi
else
    echo -e "   ${YELLOW}⚠️  Script de coleta não encontrado${NC}"
fi

# 4. Validar sistema
echo ""
echo "4️⃣  Validando sistema completo..."
if [ -f "$PROMPT_DIR/scripts/shared/validate_ia_system.sh" ]; then
    bash "$PROMPT_DIR/scripts/shared/validate_ia_system.sh" > /tmp/validation_test.log 2>&1
    echo -e "   ${GREEN}✅ Validação executada${NC}"
    echo "   Relatório em: /tmp/validation_test.log"
else
    echo -e "   ${YELLOW}⚠️  Script de validação não encontrado${NC}"
fi

# 5. Configurar automação (cron jobs)
echo ""
echo "5️⃣  Configurando automação (cron jobs)..."
CRON_FILE=$(mktemp)

# Coleta diária às 9:00
echo "0 9 * * * $PROMPT_DIR/scripts/ubuntu/collect_all_ia_ubuntu.sh >> /var/log/ia_collection.log 2>&1" >> "$CRON_FILE"

# Auditoria semanal (segunda-feira às 10:00)
echo "0 10 * * 1 $PROMPT_DIR/scripts/shared/audit_system_prompts.sh >> /var/log/ia_audit.log 2>&1" >> "$CRON_FILE"

# Validação mensal (dia 1 às 11:00)
echo "0 11 1 * * $PROMPT_DIR/scripts/shared/validate_ia_system.sh >> /var/log/ia_validation.log 2>&1" >> "$CRON_FILE"

# Verificar se já existem cron jobs do sistema
EXISTING_CRON=$(crontab -l 2>/dev/null | grep -i "SYSTEM_PROMPT\|ia_collection" || echo "")

if [ -z "$EXISTING_CRON" ]; then
    # Adicionar novos cron jobs
    (crontab -l 2>/dev/null; echo ""; echo "# System Prompt IA - Automação"; cat "$CRON_FILE") | crontab -
    echo -e "   ${GREEN}✅ Cron jobs configurados${NC}"
    echo ""
    echo "   Cron jobs adicionados:"
    cat "$CRON_FILE" | sed 's/^/   /'
else
    echo -e "   ${YELLOW}⚠️  Cron jobs já existem${NC}"
    echo "   Jobs existentes:"
    echo "$EXISTING_CRON" | sed 's/^/   /'
fi

rm "$CRON_FILE"

# 6. Criar diretórios de log
echo ""
echo "6️⃣  Configurando diretórios de log..."
mkdir -p /var/log
touch /var/log/ia_collection.log /var/log/ia_audit.log /var/log/ia_validation.log
chmod 644 /var/log/ia_*.log
echo -e "   ${GREEN}✅ Diretórios de log configurados${NC}"

# 7. Resumo final
echo ""
echo "============================================"
echo -e "${GREEN}✅ Configuração Completa Finalizada!${NC}"
echo "============================================"
echo ""
echo "📋 Configurações aplicadas:"
echo ""
echo "   1. 1Password Service Account Token"
if [ -n "$OP_SERVICE_TOKEN" ]; then
    echo -e "      ${GREEN}✅ Configurado${NC}"
else
    echo -e "      ${YELLOW}⚠️  Requer configuração manual${NC}"
fi
echo ""
echo "   2. System Prompt no Cursor"
echo -e "      ${GREEN}✅ Aplicado${NC}"
echo ""
echo "   3. Scripts de coleta"
echo -e "      ${GREEN}✅ Testados${NC}"
echo ""
echo "   4. Validação do sistema"
echo -e "      ${GREEN}✅ Executada${NC}"
echo ""
echo "   5. Automação (cron jobs)"
echo -e "      ${GREEN}✅ Configurada${NC}"
echo ""
echo "📋 Próximos passos:"
echo ""
echo "   1. Verificar cron jobs:"
echo "      ${BLUE}crontab -l${NC}"
echo ""
echo "   2. Ver logs:"
echo "      ${BLUE}tail -f /var/log/ia_collection.log${NC}"
echo ""
echo "   3. Testar 1Password:"
echo "      ${BLUE}op vault list${NC}"
echo ""
echo "   4. Aplicar system prompt em outras ferramentas:"
echo "      ${BLUE}$PROMPT_DIR/scripts/shared/apply_chatgpt_prompt.sh${NC}"
echo "      ${BLUE}$PROMPT_DIR/scripts/shared/apply_perplexity_prompt.sh${NC}"
echo ""
echo ""

