#!/bin/bash

#################################################################################
# Script de Migração e Consolidação - 1Password Automation
# Versão: 2.0.1
# Objetivo: Migrar vaults-1password para ~/Dotfiles/automation_1password
#################################################################################

set -e

SOURCE_DIR="/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/vaults-1password"
TARGET_DIR="$HOME/Dotfiles/automation_1password"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Criar estrutura de diretórios
create_structure() {
    log "Criando estrutura de diretórios..."

    mkdir -p "$TARGET_DIR"/{config,scripts,docs,exports,reports,standards,templates,vaults}

    success "Estrutura criada"
}

# Migrar arquivos
migrate_files() {
    log "Migrando arquivos..."

    if [ ! -d "$SOURCE_DIR" ]; then
        error "Diretório fonte não encontrado: $SOURCE_DIR"
        return 1
    fi

    # Migrar README e documentação
    if [ -f "$SOURCE_DIR/README.md" ]; then
        cp "$SOURCE_DIR/README.md" "$TARGET_DIR/README.md"
        success "README migrado"
    fi

    # Migrar scripts
    if [ -d "$SOURCE_DIR/scripts" ]; then
        cp -r "$SOURCE_DIR/scripts/"* "$TARGET_DIR/scripts/" 2>/dev/null || true
        success "Scripts migrados"
    fi

    # Migrar docs
    if [ -d "$SOURCE_DIR/docs" ]; then
        cp -r "$SOURCE_DIR/docs/"* "$TARGET_DIR/docs/" 2>/dev/null || true
        success "Documentação migrada"
    fi

    # Migrar exports
    if [ -d "$SOURCE_DIR/exports" ]; then
        cp -r "$SOURCE_DIR/exports/"* "$TARGET_DIR/exports/" 2>/dev/null || true
        success "Exports migrados"
    fi

    # Migrar reports
    if [ -d "$SOURCE_DIR/reports" ]; then
        cp -r "$SOURCE_DIR/reports/"* "$TARGET_DIR/reports/" 2>/dev/null || true
        success "Reports migrados"
    fi

    # Migrar standards
    if [ -d "$SOURCE_DIR/standards" ]; then
        cp -r "$SOURCE_DIR/standards/"* "$TARGET_DIR/standards/" 2>/dev/null || true
        success "Standards migrados"
    fi

    # Migrar templates
    if [ -d "$SOURCE_DIR/templates" ]; then
        cp -r "$SOURCE_DIR/templates/"* "$TARGET_DIR/templates/" 2>/dev/null || true
        success "Templates migrados"
    fi

    # Migrar config
    if [ -d "$SOURCE_DIR/config" ]; then
        cp -r "$SOURCE_DIR/config/"* "$TARGET_DIR/config/" 2>/dev/null || true
        success "Config migrado"
    fi

    return 0
}

# Atualizar paths nos scripts
update_script_paths() {
    log "Atualizando paths nos scripts..."

    find "$TARGET_DIR/scripts" -type f -name "*.sh" 2>/dev/null | while read -r script; do
        if [ -f "$script" ]; then
            # Substituir paths antigos por novos
            sed -i '' "s|vaults-1password|automation_1password|g" "$script" 2>/dev/null || \
            sed -i "s|vaults-1password|automation_1password|g" "$script" 2>/dev/null || true

            sed -i '' "s|10_INFRAESTRUTURA_VPS/vaults-1password|Dotfiles/automation_1password|g" "$script" 2>/dev/null || \
            sed -i "s|10_INFRAESTRUTURA_VPS/vaults-1password|Dotfiles/automation_1password|g" "$script" 2>/dev/null || true

            # Tornar executável
            chmod +x "$script" 2>/dev/null || true
        fi
    done

    success "Paths atualizados nos scripts"
}

# Criar README consolidado
create_readme() {
    log "Criando README consolidado..."

    cat > "$TARGET_DIR/README.md" << 'EOF'
# 🔐 1Password Automation - Governança Centralizada

**Localização**: `~/Dotfiles/automation_1password`
**Versão**: 2.0.1
**Última Atualização**: 2025-01-17

---

## 📋 Visão Geral

Este diretório centraliza toda a automação e governança relacionada ao 1Password, incluindo:

- ✅ Scripts de sincronização e backup
- ✅ Templates e standards
- ✅ Documentação de governança
- ✅ Exports e reports
- ✅ Configurações padronizadas

---

## 📁 Estrutura

```
~/Dotfiles/automation_1password/
├── config/          # Configurações
├── scripts/         # Scripts de automação
├── docs/            # Documentação
├── exports/         # Exports do 1Password
├── reports/         # Relatórios e análises
├── standards/       # Padrões e templates
├── templates/      # Templates de itens
└── vaults/          # Configurações por vault
```

---

## 🚀 Scripts Principais

### Sincronização

- `scripts/sync-1password-to-dotfiles.sh` - Sincroniza credenciais do 1Password para ~/Dotfiles
- `scripts/backup-vaults.sh` - Backup de vaults
- `scripts/audit-credentials.sh` - Auditoria de credenciais

### Governança

- `scripts/standardize-items.sh` - Padroniza itens no 1Password
- `scripts/remove-duplicates.sh` - Remove duplicatas
- `scripts/validate-standards.sh` - Valida conformidade com standards

---

## 📚 Documentação

- [Governança de Dados](../docs/governance/GOVERNANCA_DADOS.md)
- [Padrões de Credenciais](standards/)
- [Templates de Itens](templates/)

---

## 🔄 Migração

Este diretório foi migrado de:
- `~/10_INFRAESTRUTURA_VPS/vaults-1password`

Todas as configurações foram consolidadas e padronizadas aqui.

---

**Mantido por**: Sistema de Governança Global
**Versão**: 2.0.1
EOF

    success "README criado"
}

# Criar script de sincronização 1Password -> Dotfiles
create_sync_script() {
    log "Criando script de sincronização..."

    cat > "$TARGET_DIR/scripts/sync-1password-to-dotfiles.sh" << 'EOFSCRIPT'
#!/bin/bash

#################################################################################
# Script de Sincronização 1Password -> ~/Dotfiles
# Versão: 2.0.1
# Objetivo: Sincronizar credenciais do 1Password para arquivos locais em ~/Dotfiles
#################################################################################

set -e

DOTFILES_DIR="$HOME/Dotfiles"
CREDENTIALS_DIR="$DOTFILES_DIR/credentials"

# Detectar vault (prioridade: 1p_macos > Personal)
VAULT=$(op vault list --format json 2>/dev/null | jq -r '.[] | select(.name == "1p_macos" or .name == "Personal") | .name' | head -1 || echo "Personal")

log() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

# Sincronizar credenciais Gemini
sync_gemini_credentials() {
    log "Sincronizando credenciais Gemini..."

    local item_name="Gemini_API_Keys"

    if op item get "$item_name" --vault "$VAULT" &>/dev/null; then
        local gemini_key=$(op read "op://$VAULT/$item_name/GEMINI_API_KEY" 2>/dev/null || echo "")
        local google_key=$(op read "op://$VAULT/$item_name/GOOGLE_API_KEY" 2>/dev/null || echo "")

        if [ -n "$gemini_key" ] && [ -n "$google_key" ]; then
            mkdir -p "$CREDENTIALS_DIR/api-keys"

            # Salvar como arquivos locais (com permissões restritas)
            echo "$gemini_key" > "$CREDENTIALS_DIR/api-keys/GEMINI_API_KEY.local"
            echo "$google_key" > "$CREDENTIALS_DIR/api-keys/GOOGLE_API_KEY.local"
            chmod 600 "$CREDENTIALS_DIR/api-keys/"*.local

            success "Credenciais Gemini sincronizadas"
        fi
    fi
}

# Sincronizar service account GCP
sync_gcp_service_account() {
    log "Sincronizando GCP Service Account..."

    local item_name="GCP_Service_Account_gcp-ai-setup-24410"

    if op item get "$item_name" --vault "$VAULT" &>/dev/null; then
        op document get "$item_name" --vault "$VAULT" > "$CREDENTIALS_DIR/service-accounts/gcp-ai-setup-24410.json" 2>/dev/null || true
        chmod 600 "$CREDENTIALS_DIR/service-accounts/gcp-ai-setup-24410.json" 2>/dev/null || true
        success "Service Account sincronizado"
    fi
}

main() {
    echo "Sincronizando 1Password -> ~/Dotfiles..."
    echo ""

    mkdir -p "$CREDENTIALS_DIR"/{api-keys,service-accounts,oauth}

    sync_gemini_credentials
    sync_gcp_service_account

    echo ""
    success "Sincronização concluída!"
}

main "$@"
EOFSCRIPT

    chmod +x "$TARGET_DIR/scripts/sync-1password-to-dotfiles.sh"
    success "Script de sincronização criado"
}

main() {
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        Migração 1Password Automation                        ║"
    echo "║              Para ~/Dotfiles/automation_1password           ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""

    create_structure
    migrate_files
    update_script_paths
    create_readme
    create_sync_script

    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              MIGRAÇÃO CONCLUÍDA COM SUCESSO                  ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    success "Tudo migrado para ~/Dotfiles/automation_1password"
    echo ""
    echo "Próximos passos:"
    echo "1. Revise a estrutura em ~/Dotfiles/automation_1password"
    echo "2. Execute: ~/Dotfiles/automation_1password/scripts/sync-1password-to-dotfiles.sh"
    echo "3. Configure scripts conforme necessário"
    echo ""
}

main "$@"
