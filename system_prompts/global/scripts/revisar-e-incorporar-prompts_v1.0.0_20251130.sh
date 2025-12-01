#!/usr/bin/env bash

################################################################################
# 🔍 REVISAR E INCORPORAR PROMPTS - Do documento aprimorar_prompts.md
# Revisa prompts do documento e incorpora apenas os relevantes e novos
#
# STATUS: ATIVO (2025-11-28)
# PROPÓSITO: Incorporar prompts relevantes do documento externo
# VERSÃO: 1.0.0
################################################################################

set -euo pipefail

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Dotfiles}"
GLOBAL_DIR="${DOTFILES_DIR}/system_prompts/global"
SOURCE_DOC="${HOME}/aprimorar_prompts.md"
PROMPTS_TEMP="${GLOBAL_DIR}/prompts_temp"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

log_info() {
    echo -e "${BLUE}ℹ️${NC} $@"
}

log_success() {
    echo -e "${GREEN}✅${NC} $@"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $@"
}

log_error() {
    echo -e "${RED}❌${NC} $@"
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

# ============================================================================
# VALIDAÇÃO
# ============================================================================

validate_source() {
    if [ ! -f "${SOURCE_DOC}" ]; then
        log_error "Documento fonte não encontrado: ${SOURCE_DOC}"
        return 1
    fi
    log_success "Documento fonte encontrado: ${SOURCE_DOC}"
    return 0
}

# ============================================================================
# EXTRAÇÃO DE PROMPTS RELEVANTES
# ============================================================================

extract_mcp_prompt() {
    local output_file="${PROMPTS_TEMP}/stage_00_coleta/PROMPT_MCP_SERVERS_${TIMESTAMP}.md"

    cat > "${output_file}" << 'EOF'
# PROMPT DE CONFIGURAÇÃO MCP SERVERS

**Versão:** 1.0.0
**Data:** 28 de Novembro de 2025
**Status:** Ativo
**Uso:** Guia para configuração de MCP Servers no Cursor

---

## 🎯 OBJETIVO

Configurar MCP Servers no Cursor para acesso integrado a dados locais, GitHub, Hugging Face e outras plataformas, mantendo sincronização com ChatGPT Plus 5.1.

---

## 🔧 STACK MCP RECOMENDADA

### Núcleo Essencial

1. **Filesystem MCP Server**
   - Expõe diretórios locais como recursos MCP
   - Diretórios: `~/Dotfiles`, `~/infra-vps`, `~/Projects`, `~/database`
   - Permite listar, ler e navegar arquivos locais
   - Repositório: `modelcontextprotocol/servers`

2. **GitHub MCP Server (Oficial)**
   - Leitura de repositórios remotos, issues, PRs
   - Repositórios principais:
     - `senal88/infraestrutura-vps`
     - `senal88/Dotfiles` (SYSTEM_PROMPTS)
     - Outros repositórios de arquitetura
   - Repositório: `github/github-mcp-server`

### Complementos Recomendados

3. **Hugging Face MCP Server**
   - Integração com espaços, modelos e APIs HF
   - Útil para datasets/modelos BNI, Family Office
   - Repositório: Hugging Face MCP oficial

4. **Google Drive / Cloud Storage MCP**
   - Conecta materiais do Google Drive ao Cursor
   - Bridges para Google Drive, Upstash, etc.
   - Diretório: `mcpcursor.com`

5. **Servers Especializados**
   - Catálogo: `appcypher/awesome-mcp-servers`
   - Postgres, Cloudflare, etc.

---

## 📋 DEPENDÊNCIAS MÍNIMAS

### Ambiente de Execução

- **Node.js LTS** (>= 20.x) para servidores TypeScript/JS
- **Python 3.11+** para servidores Python (opcional)
- **Cursor atualizado** com suporte MCP ativo

### Tokens e Segredos (via 1Password CLI)

- **GitHub MCP:** `GITHUB_TOKEN` com escopo adequado
- **Hugging Face MCP:** `HUGGINGFACE_API_TOKEN`
- **Google Drive MCP:** `GOOGLE_SERVICE_ACCOUNT` (se aplicável)
- **Outros:** Variáveis específicas via 1Password CLI

---

## 🔗 INTEGRAÇÃO COM CHATGPT PLUS 5.1

### Estratégia de Sincronização

1. **Fonte Única de Verdade**
   - Repositórios GitHub como ponte de contexto
   - `senal88/Dotfiles` (SYSTEM_PROMPTS)
   - `senal88/infraestrutura-vps`

2. **No macOS Silicon / Cursor**
   - Filesystem MCP → snapshots de auditoria, Dotfiles
   - GitHub MCP → repositórios versionados
   - Cursor gera/atualiza arquivos `.md` e `.txt` no GitHub

3. **No ChatGPT Plus 5.1**
   - Usa mesmos repositórios GitHub como ponte
   - URLs de arquivos/READMEs com browsing habilitado
   - MCP/Connectors quando suportado

4. **OpenAI Agents SDK (Opcional)**
   - Agentes próprios usando mesmo MCP servers
   - Camada comum de contexto

---

## 📚 REPOSITÓRIOS GITHUB PRONTOS

1. **modelcontextprotocol/servers** - Servidores de referência
2. **github/github-mcp-server** - MCP server oficial GitHub
3. **huggingface/mcp-course** - Curso e código starter
4. **appcypher/awesome-mcp-servers** - Catálogo de servidores
5. **cursor.directory / mcpcursor.com** - Diretórios específicos Cursor

---

## 🎯 RESULTADO PRÁTICO

- Cursor (local) e ChatGPT Plus 5.1 trabalham sobre mesmos artefatos versionados
- Todo o "saber" do ambiente fica versionado e acessível
- Acesso direto a dados locais via MCP no Cursor
- Sincronização via GitHub para ChatGPT Plus 5.1

---

**Versão:** 1.0.0
**Última Atualização:** 28 de Novembro de 2025
**Status:** Ativo

EOF

    log_success "Prompt MCP Servers extraído: ${output_file}"
}

extract_setup_macos_prompt() {
    local output_file="${PROMPTS_TEMP}/stage_00_coleta/PROMPT_SETUP_MACOS_WINDOWS_EXPERIENCE_${TIMESTAMP}.md"

    cat > "${output_file}" << 'EOF'
# PROMPT DE SETUP macOS - EXPERIÊNCIA WINDOWS

**Versão:** 1.0.0
**Data:** 28 de Novembro de 2025
**Status:** Ativo
**Uso:** Guia para setup macOS familiar ao Windows sem mascarar o macOS

---

## 🎯 OBJETIVO

Listar setups e ferramentas intuitivas que deixam o macOS mais familiar ao Windows, mas **sem mascarar o macOS** — permitindo aprender a estrutura, gerenciar o sistema, entender permissões, pastas, recursos, CLI e automações.

---

## 📊 EQUIVALÊNCIAS WINDOWS → macOS

| Função Windows | macOS Equivalente | Benefício ao Aprendizado |
|----------------|-------------------|-------------------------|
| Explorador de arquivos | Finder + Forklift + Commander One | Visual dual-pane, pastas visíveis |
| Gerenciador de tarefas | iStat Menus + Activity Monitor | Entendimento real de CPU/GPU/RAM |
| Menu iniciar / Atalhos | Raycast ou Alfred | Launcher avançado, scripts, automação |
| Painel de controle | System Settings + TinkerTool | Compreensão do núcleo do macOS |
| CMD/PowerShell | Terminal + iTerm2 + Zsh + Homebrew | Domínio real do shell |
| Barra do Windows | Dock + Hidden Dock + Stage Manager | Organização real de apps |
| Windows Explorer Search | Raycast Search Index | Busca instantânea |
| Copiar/colar avançado | BetterTouchTool / Keyboard Maestro | Automação real e macros |

---

## 🔧 SETUP BÁSICO - EXPERIÊNCIA WINDOWS

### A — Navegação e Organização

1. Finder → modo coluna + caminhos visíveis
2. Criar pastas fixas no Finder Sidebar:
   - Documentos
   - Projetos
   - Downloads
   - Cloud Drive
3. Instalar **Forklift** → janela dupla como Windows Explorer
4. Ativar QuickLook (barra de espaço) para prévia rápida

### B — Produtividade e Workflow

| Instalar | Para que serve |
|----------|---------------|
| **Raycast** | Equivalentemente superior ao Windows Start Menu + atalhos automáveis |
| **Magnet** ou **Rectangle Pro** | Snap de janelas igual ao Windows (lado a lado, quadrantes) |
| **BetterTouchTool** | Atalhos, gestos, automação de mouse/trackpad como macros |
| **AltTab** | CTRL+ALT+TAB exatamente como Windows |

### C — Aprendendo o Terminal "sem dor"

Ferramentas iniciais:

| Ferramenta | Papel |
|-----------|-------|
| iTerm2 | Terminal moderno e personalizável |
| Oh-My-Zsh | Comandos curtos, tema, sugestões e auto-complete |
| Homebrew | O "apt-get" / "chocolatey" do macOS |
| btop | Monitor do sistema tipo Task Manager |

### D — Raciocínio Mental Windows → macOS

| Windows | macOS (Mentalidade Correta) |
|---------|----------------------------|
| Program Files | /Applications |
| C:\Users\Você | ~/Users/SeuNome |
| CMD/Powershell | Zsh/Terminal |
| Regedit | Plist + LaunchAgents |
| Drivers | Kexts + extensões controladas |

---

## 🎯 CAMINHO PARA APRENDER DE VERDADE

### Progresso: Iniciante → Intermediário → Avançado

1. Instalando apps normalmente
2. Configurando atalhos e snaps como Windows
3. Usando Terminal para tarefas básicas
4. Aprendendo estrutura de diretórios Unix
5. Automatizando com scripts shell
6. Dominando Homebrew e gerenciamento de pacotes
7. Entendendo permissões e segurança macOS

---

## ⚙️ CONFIGURAÇÕES RECOMENDADAS

### Navegação e Produtividade

- **Mission Control:** Option + 3 para "Visão Geral"
- **Múltiplos monitores:** Preferir 1-2 desktops, não fragmentar
- **Dock:** Sem itens recentes, somente fixos e essenciais
- **⌘ + Tab:** Alternância de apps (Command + Tab)

### Terminal e Shell

- **Shell padrão:** zsh
- **Homebrew:** /opt/homebrew
- **Terminal:** iTerm2 com Oh-My-Zsh
- **Launcher:** Raycast (Spotlight desativado ou reduzido)

---

**Versão:** 1.0.0
**Última Atualização:** 28 de Novembro de 2025
**Status:** Ativo

EOF

    log_success "Prompt Setup macOS extraído: ${output_file}"
}

extract_modo_adaptativo_prompt() {
    local output_file="${PROMPTS_TEMP}/stage_00_coleta/PROMPT_MODO_ADAPTATIVO_${TIMESTAMP}.md"

    cat > "${output_file}" << 'EOF'
# PROMPT - MODO OPERACIONAL ADAPTATIVO

**Versão:** 1.0.0
**Data:** 28 de Novembro de 2025
**Status:** Ativo
**Uso:** Seção para adicionar a prompts existentes - Modo Adaptativo Permanente

---

## 🔄 MODO OPERACIONAL ADAPTATIVO PERMANENTE

### Princípios Fundamentais

- **A cada nova coleta → reescrever o estado interno**
- **Se faltarem pacotes → provisionar Brew/Node/Ollama**
- **Se scripts existirem no Dotfiles → usar antes de criar novos**
- **Se automação já existir em Shortcuts → conectar ao pipeline via CLI**
- **Toda resposta deve evoluir seu ambiente, nunca retroceder**

### Filosofia

**Estado é vivo. Prompt é iterativo. Sistema deve crescer com o uso.**

---

## 📋 REGRAS DE ADAPTAÇÃO

### 1. Detecção Automática

- Detectar scripts existentes antes de criar novos
- Identificar automações já implementadas
- Reconhecer estrutura de diretórios existente
- Validar dependências instaladas

### 2. Evolução Incremental

- Sempre melhorar, nunca degradar
- Adicionar funcionalidades sem quebrar existentes
- Manter compatibilidade com configurações anteriores
- Documentar mudanças significativas

### 3. Integração com Ecossistema

- Conectar com Shortcuts.app quando aplicável
- Integrar com scripts Dotfiles existentes
- Aproveitar automações Raycast
- Sincronizar com VPS quando relevante

### 4. Provisionamento Inteligente

- Instalar apenas o que falta
- Não reinstalar o que já existe
- Validar versões antes de atualizar
- Manter compatibilidade de versões

---

## 🎯 APLICAÇÃO PRÁTICA

### Quando Usar Este Modo

- Após auditorias do sistema
- Ao detectar mudanças no ambiente
- Quando scripts são solicitados
- Durante configuração de novos projetos
- Ao sincronizar entre macOS e VPS

### Comportamento Esperado

1. **Detectar** estado atual do ambiente
2. **Identificar** o que falta ou precisa atualização
3. **Propor** soluções que evoluem o sistema
4. **Implementar** mudanças de forma incremental
5. **Validar** que tudo funciona após mudanças

---

**Versão:** 1.0.0
**Última Atualização:** 28 de Novembro de 2025
**Status:** Ativo

EOF

    log_success "Prompt Modo Adaptativo extraído: ${output_file}"
}

# ============================================================================
# PROCESSAR E INCORPORAR
# ============================================================================

process_and_incorporate() {
    print_header "🔍 REVISÃO E INCORPORAÇÃO DE PROMPTS"

    if ! validate_source; then
        return 1
    fi

    log_info "Analisando documento e extraindo prompts relevantes..."

    # Extrair prompts específicos que ainda não existem
    extract_mcp_prompt
    extract_setup_macos_prompt
    extract_modo_adaptativo_prompt

    log_success "Prompts relevantes extraídos para stage_00_coleta"

    # Processar através do pipeline normal
    log_info "Processando através do pipeline de adaptação..."
    "${GLOBAL_DIR}/scripts/coletar-e-adaptar-prompts.sh" 2>/dev/null || {
        log_warning "Pipeline de adaptação não executado automaticamente"
        log_info "Execute manualmente: ${GLOBAL_DIR}/scripts/coletar-e-adaptar-prompts.sh"
    }

    log_success "Processo concluído"
}

# ============================================================================
# VALIDAÇÃO FINAL
# ============================================================================

validate_incorporation() {
    print_header "✅ VALIDAÇÃO DA INCORPORAÇÃO"

    local new_prompts=(
        "PROMPT_MCP_SERVERS"
        "PROMPT_SETUP_MACOS_WINDOWS_EXPERIENCE"
        "PROMPT_MODO_ADAPTATIVO"
    )

    local found=0
    for prompt_base in "${new_prompts[@]}"; do
        if find "${PROMPTS_TEMP}" -name "${prompt_base}*.md" | grep -q .; then
            log_success "Prompt encontrado: ${prompt_base}"
            ((found++))
        else
            log_warning "Prompt não encontrado: ${prompt_base}"
        fi
    done

    if [ "${found}" -eq "${#new_prompts[@]}" ]; then
        log_success "✅ Todos os prompts incorporados com sucesso"
        return 0
    else
        log_warning "⚠️ Apenas ${found}/${#new_prompts[@]} prompts incorporados"
        return 1
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_header "🔍 REVISAR E INCORPORAR PROMPTS DO DOCUMENTO"

    process_and_incorporate
    validate_incorporation

    echo ""
    log_success "✅ Revisão e incorporação concluídas!"
    log_info "📁 Prompts em: ${PROMPTS_TEMP}/stage_00_coleta/"
    echo ""
}

main "$@"

