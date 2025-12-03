#!/usr/bin/env bash
################################################################################
# Script: setup-segundo-cerebro.sh
# Versão: 1.0.1
# Data: 2025-12-02
# Descrição: Setup completo do projeto Segundo Cérebro IA
#            Claude MCP + Obsidian + n8n + YouTube Transcription
# Autor: Luiz Sena
#
# Uso:
#   bash setup-segundo-cerebro.sh [--skip-dependencies]
#
# Opções:
#   --skip-dependencies    Pula instalação de dependências (Homebrew, Node, etc)
#
# ⚠️  IMPORTANTE: Este script deve ser EXECUTADO, não "sourced"
#     Correto:   bash setup-segundo-cerebro.sh
#     Incorreto: source setup-segundo-cerebro.sh
################################################################################

# Verificar se está sendo sourced (proteção contra erro comum)
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo "❌ ERRO: Este script deve ser executado, não sourced!"
    echo "   Use: bash ${BASH_SOURCE[0]}"
    return 1 2>/dev/null || exit 1
fi

set -euo pipefail

# Cores
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly NC='\033[0m'

# Configurações
readonly PROJECT_ROOT="$HOME/Dotfiles/system_prompts/segundo-cerebro-ia"
readonly VAULT_PATH="$PROJECT_ROOT/obsidian-vault"
readonly CLAUDE_CONFIG_PATH="$PROJECT_ROOT/claude-config"
readonly SCRIPTS_PATH="$PROJECT_ROOT/scripts"

SKIP_DEPS=false

# Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-dependencies) SKIP_DEPS=true; shift ;;
        *) echo "Opção desconhecida: $1"; exit 1 ;;
    esac
done

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[✓]${NC} $*"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $*"; }
log_error() { echo -e "${RED}[✗]${NC} $*" >&2; }
log_section() { echo -e "\n${PURPLE}▶ $*${NC}"; }

################################################################################
# FASE 1: Verificar Pré-requisitos
################################################################################
log_section "FASE 1: Verificando Pré-requisitos"

check_command() {
    if command -v "$1" &>/dev/null; then
        log_success "$1 instalado: $(command -v "$1")"
        return 0
    else
        log_warning "$1 não encontrado"
        return 1
    fi
}

# Verificar comandos essenciais
MISSING_DEPS=()

if ! check_command "brew"; then MISSING_DEPS+=("Homebrew"); fi
if ! check_command "node"; then MISSING_DEPS+=("Node.js"); fi
if ! check_command "bun"; then MISSING_DEPS+=("Bun"); fi
if ! check_command "jq"; then MISSING_DEPS+=("jq"); fi
if ! check_command "op"; then MISSING_DEPS+=("1Password CLI"); fi

if [[ ${#MISSING_DEPS[@]} -gt 0 ]] && [[ "$SKIP_DEPS" == "false" ]]; then
    log_error "Dependências faltando: ${MISSING_DEPS[*]}"
    log_info "Instalando dependências..."

    if [[ ! $(command -v brew) ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew install node jq
    brew tap oven-sh/bun
    brew install bun
    brew install --cask 1password-cli

    log_success "Dependências instaladas"
elif [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
    log_error "Dependências faltando: ${MISSING_DEPS[*]}"
    log_info "Execute sem --skip-dependencies ou instale manualmente"
    exit 1
fi

################################################################################
# FASE 2: Criar Estrutura de Diretórios
################################################################################
log_section "FASE 2: Criando Estrutura de Diretórios"

DIRS=(
    "$PROJECT_ROOT"
    "$VAULT_PATH"
    "$VAULT_PATH/.obsidian"
    "$VAULT_PATH/mapas-mentais"
    "$VAULT_PATH/transcricoes"
    "$VAULT_PATH/conceitos"
    "$VAULT_PATH/projetos"
    "$VAULT_PATH/recursos"
    "$VAULT_PATH/areas"
    "$CLAUDE_CONFIG_PATH"
    "$CLAUDE_CONFIG_PATH/mcp-servers"
    "$PROJECT_ROOT/n8n-workflows"
    "$SCRIPTS_PATH"
    "$SCRIPTS_PATH/examples"
    "$PROJECT_ROOT/templates"
    "$PROJECT_ROOT/docs"
    "$PROJECT_ROOT/config"
    "$PROJECT_ROOT/backups"
)

for dir in "${DIRS[@]}"; do
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        log_success "Criado: $dir"
    else
        log_info "Já existe: $dir"
    fi
done

################################################################################
# FASE 3: Instalar MCP Servers
################################################################################
log_section "FASE 3: Instalando MCP Servers"

log_info "Instalando @fazer-ai/mcp-obsidian..."
# if bunx @fazer-ai/mcp-obsidian@latest --version &>/dev/null; then
#     log_success "MCP Obsidian instalado"
# else
#     log_warning "MCP Obsidian pode não estar instalado corretamente"
# fi

log_info "Instalando youtube-transcript MCP..."
# if bunx @kimtaeyoon83/mcp-server-youtube-transcript --version &>/dev/null; then
#     log_success "YouTube Transcript MCP instalado"
# else
#     log_warning "YouTube Transcript MCP pode não estar instalado corretamente"
# fi

################################################################################
# FASE 4: Configurar 1Password Credentials
################################################################################
log_section "FASE 4: Configurando Credenciais (1Password)"

log_info "Verificando 1Password CLI..."
if ! op account list &>/dev/null; then
    log_error "1Password CLI não está autenticado"
    log_info "Execute: eval \$(op signin)"
    exit 1
fi

log_success "1Password CLI autenticado"

# Verificar/Criar Obsidian API Key
log_info "Verificando Obsidian MCP API Key..."
if op item get "Obsidian MCP API Key" --vault 1p_macos &>/dev/null; then
    log_success "Obsidian API Key já existe no 1Password"
    OBSIDIAN_KEY=$(op read "op://1p_macos/Obsidian MCP API Key/credential")
else
    log_warning "Obsidian API Key não encontrada"
    # read -p "Digite a Obsidian API Key (ou Enter para gerar): " input_key
    input_key=""

    if [[ -z "$input_key" ]]; then
        # Gerar key aleatória
        OBSIDIAN_KEY=$(openssl rand -hex 32)
        log_info "Chave gerada: $OBSIDIAN_KEY"
    else
        OBSIDIAN_KEY="$input_key"
    fi

    op item create \
        --category="API Credential" \
        --title="Obsidian MCP API Key" \
        --vault="1p_macos" \
        --tags="obsidian,mcp,segundo-cerebro" \
        credential[password]="$OBSIDIAN_KEY"

    log_success "Obsidian API Key salva no 1Password"
fi

# Verificar Cloudinary Credentials
log_info "Verificando Cloudinary Credentials..."
if op item get "Cloudinary API Credentials" --vault 1p_macos &>/dev/null; then
    log_success "Cloudinary credentials já existem"
else
    log_warning "Cloudinary credentials não encontradas"
    log_info "Configure manualmente via: op item create ..."
    log_info "Ou acesse: https://cloudinary.com/console"
fi

################################################################################
# FASE 5: Criar Claude Desktop Config
################################################################################
log_section "FASE 5: Configurando Claude Desktop"

CLAUDE_CONFIG="$CLAUDE_CONFIG_PATH/claude_desktop_config.json"

cat > "$CLAUDE_CONFIG" <<EOF
{
  "mcpServers": {
    "@fazer-ai/mcp-obsidian": {
      "command": "bunx",
      "args": [
        "@fazer-ai/mcp-obsidian@latest"
      ],
      "env": {
        "OBSIDIAN_API_KEY": "$OBSIDIAN_KEY",
        "OBSIDIAN_VAULT_PATH": "$VAULT_PATH"
      }
    },
    "youtube-transcript": {
      "command": "bunx",
      "args": [
        "-y",
        "@kimtaeyoon83/mcp-server-youtube-transcript"
      ]
    }
  }
}
EOF

log_success "Claude Desktop config criado: $CLAUDE_CONFIG"
log_info "Copie este arquivo para: ~/Library/Application Support/Claude/claude_desktop_config.json"

################################################################################
# FASE 6: Criar Scripts Auxiliares
################################################################################
log_section "FASE 6: Criando Scripts Auxiliares"

# Script: load-obsidian-keys.sh
cat > "$SCRIPTS_PATH/load-obsidian-keys.sh" <<'EOF'
#!/usr/bin/env bash
# Carrega credenciais do Segundo Cérebro IA via 1Password

if ! command -v op &>/dev/null; then
    echo "[ERROR] 1Password CLI não instalado"
    return 1
fi

if ! op account list &>/dev/null; then
    echo "[ERROR] 1Password CLI não autenticado. Execute: eval $(op signin)"
    return 1
fi

# Obsidian
export OBSIDIAN_API_KEY=$(op read "op://1p_macos/Obsidian MCP API Key/credential" 2>/dev/null || echo "")

# Cloudinary
export CLOUDINARY_CLOUD_NAME=$(op read "op://1p_macos/Cloudinary API Credentials/cloud_name" 2>/dev/null || echo "")
export CLOUDINARY_API_KEY=$(op read "op://1p_macos/Cloudinary API Credentials/api_key" 2>/dev/null || echo "")
export CLOUDINARY_API_SECRET=$(op read "op://1p_macos/Cloudinary API Credentials/api_secret" 2>/dev/null || echo "")

# OpenAI (Whisper)
export OPENAI_API_KEY=$(op read "op://1p_macos/OpenAI API Key/credential" 2>/dev/null || echo "")

echo "[✓] Credenciais carregadas:"
[[ -n "$OBSIDIAN_API_KEY" ]] && echo "  ✓ OBSIDIAN_API_KEY"
[[ -n "$CLOUDINARY_CLOUD_NAME" ]] && echo "  ✓ CLOUDINARY_*"
[[ -n "$OPENAI_API_KEY" ]] && echo "  ✓ OPENAI_API_KEY"

return 0
EOF

chmod +x "$SCRIPTS_PATH/load-obsidian-keys.sh"
log_success "Script criado: load-obsidian-keys.sh"

# Script: backup-vault.sh
cat > "$SCRIPTS_PATH/backup-vault.sh" <<EOF
#!/usr/bin/env bash
# Backup do vault Obsidian

BACKUP_DIR="$PROJECT_ROOT/backups/\$(date +%Y%m%d_%H%M%S)"
mkdir -p "\$BACKUP_DIR"

tar -czf "\$BACKUP_DIR/obsidian-vault.tar.gz" -C "$VAULT_PATH" .

echo "[✓] Backup criado: \$BACKUP_DIR/obsidian-vault.tar.gz"
EOF

chmod +x "$SCRIPTS_PATH/backup-vault.sh"
log_success "Script criado: backup-vault.sh"

# Script: sync-claude-obsidian.sh
cat > "$SCRIPTS_PATH/sync-claude-obsidian.sh" <<EOF
#!/usr/bin/env bash
# Sincroniza config Claude Desktop com vault Obsidian

CLAUDE_USER_CONFIG="\$HOME/Library/Application Support/Claude/claude_desktop_config.json"
CLAUDE_PROJECT_CONFIG="$CLAUDE_CONFIG"

if [[ -f "\$CLAUDE_USER_CONFIG" ]]; then
    echo "[INFO] Backup config existente..."
    cp "\$CLAUDE_USER_CONFIG" "\$CLAUDE_USER_CONFIG.bak"
fi

echo "[INFO] Copiando nova config..."
cp "\$CLAUDE_PROJECT_CONFIG" "\$CLAUDE_USER_CONFIG"

echo "[✓] Claude Desktop configurado"
echo "[!] Reinicie o Claude Desktop para aplicar mudanças"
EOF

chmod +x "$SCRIPTS_PATH/sync-claude-obsidian.sh"
log_success "Script criado: sync-claude-obsidian.sh"

################################################################################
# FASE 7: Criar Templates Obsidian
################################################################################
log_section "FASE 7: Criando Templates Obsidian"

# Template: Mapa Mental
cat > "$PROJECT_ROOT/templates/mapa-mental.md" <<'EOF'
# [[Mapa Mental]]: {{title}}

**Criado:** {{date}}
**Fonte:** {{source}}
**Tags:** #mapa-mental #segundo-cerebro

---

## [[Conceito Central]]
- [[Ideia principal]]

## [[Conceitos Principais]]
### [[Conceito 1]]
- [[Detalhe 1]]
- [[Detalhe 2]]

### [[Conceito 2]]
- [[Detalhe 1]]
- [[Detalhe 2]]

## [[Ações]]
- [ ] Tarefa 1
- [ ] Tarefa 2

## [[Conexões]]
- Link para: [[Nota Relacionada 1]]
- Link para: [[Nota Relacionada 2]]
EOF

log_success "Template criado: mapa-mental.md"

# Template: Nota Atômica
cat > "$PROJECT_ROOT/templates/nota-atomica.md" <<'EOF'
# [[{{title}}]]

**Tipo:** Conceito
**Criado:** {{date}}
**Tags:** #conceito #atomico

---

## Definição
[Explicação clara e concisa do conceito]

## Contexto
[Onde este conceito se aplica]

## Exemplos
- Exemplo 1
- Exemplo 2

## Conexões
- [[Conceito Relacionado 1]]
- [[Conceito Relacionado 2]]

## Referências
- Fonte 1
- Fonte 2
EOF

log_success "Template criado: nota-atomica.md"

################################################################################
# FASE 8: Copiar Workflows n8n
################################################################################
log_section "FASE 8: Copiando Workflows n8n"

SOURCE_WORKFLOW="$HOME/Dotfiles/system_prompts/global/docs/obsidian-mcp/N8N - Transcrever áudio.json"
if [[ -f "$SOURCE_WORKFLOW" ]]; then
    cp "$SOURCE_WORKFLOW" "$PROJECT_ROOT/n8n-workflows/transcricao-audio.json"
    log_success "Workflow copiado: transcricao-audio.json"
else
    log_warning "Workflow source não encontrado: $SOURCE_WORKFLOW"
fi

################################################################################
# FASE 9: Criar .obsidian config
################################################################################
log_section "FASE 9: Configurando Obsidian Vault"

cat > "$VAULT_PATH/.obsidian/app.json" <<'EOF'
{
  "vimMode": false,
  "showLineNumber": true,
  "showFrontmatter": true,
  "defaultViewMode": "source",
  "strictLineBreaks": false,
  "readableLineLength": true,
  "newLinkFormat": "relative"
}
EOF

cat > "$VAULT_PATH/.obsidian/core-plugins.json" <<'EOF'
[
  "file-explorer",
  "global-search",
  "switcher",
  "graph",
  "backlink",
  "outgoing-link",
  "tag-pane",
  "page-preview",
  "daily-notes",
  "templates",
  "note-composer",
  "command-palette",
  "markdown-importer",
  "word-count",
  "open-with-default-app",
  "file-recovery"
]
EOF

log_success "Configuração básica do Obsidian criada"

################################################################################
# FINALIZAÇÃO
################################################################################
log_section "✅ Setup Completo!"

echo ""
echo "════════════════════════════════════════════════════════"
echo "  Segundo Cérebro IA - Setup Concluído"
echo "════════════════════════════════════════════════════════"
echo ""
echo "📁 Estrutura criada em: $PROJECT_ROOT"
echo ""
echo "🚀 Próximos Passos:"
echo ""
echo "1. Sincronizar config do Claude:"
echo "   bash $SCRIPTS_PATH/sync-claude-obsidian.sh"
echo ""
echo "2. Carregar credenciais:"
echo "   source $SCRIPTS_PATH/load-obsidian-keys.sh"
echo ""
echo "3. Abrir Obsidian:"
echo "   open -a Obsidian '$VAULT_PATH'"
echo ""
echo "4. Instalar plugin Mind Maps NextGen no Obsidian:"
echo "   Settings → Community Plugins → Browse → 'Mind Maps NextGen'"
echo ""
echo "5. Importar workflow no n8n:"
echo "   https://n8n.senamfo.com → Import → $PROJECT_ROOT/n8n-workflows/transcricao-audio.json"
echo ""
echo "6. Testar Claude MCP:"
echo "   Abra Claude Desktop e execute:"
echo "   'Crie um arquivo de teste no Obsidian vault'"
echo ""
echo "════════════════════════════════════════════════════════"
echo ""
echo "📚 Documentação completa:"
echo "   $PROJECT_ROOT/README.md"
echo ""
echo "🔐 Credenciais:"
echo "   Gerenciadas via 1Password (vault: Development)"
echo ""
echo "🆘 Suporte:"
echo "   $PROJECT_ROOT/docs/TROUBLESHOOTING.md"
echo ""
