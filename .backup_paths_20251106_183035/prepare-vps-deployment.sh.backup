#!/bin/bash
# prepare-vps-deployment.sh
# Prepara arquivos e configurações para deploy na VPS Ubuntu
# Last Updated: 2025-11-01
# Version: 1.0.0

set -euo pipefail

# ============================================================================
# SOURCING LIB
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${SCRIPT_DIR}/../lib/logging.sh"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================
DATA_DIR="${REPO_ROOT}/dados"
PROD_DIR="${REPO_ROOT}/prod"
VPS_HOST="147.79.81.59"
VPS_DOMAIN="senamfo.com.br"
VAULT_MACOS="1p_macos"
VAULT_VPS="1p_vps"

# ============================================================================
# FUNÇÕES
# ============================================================================

create_deployment_plan() {
    log_section "📋 Criando Plano de Deploy"
    
    cat > "${PROD_DIR}/deployment_plan.md" << 'EOF'
# Plano de Implantação: macOS DEV → VPS PROD

**VPS:** 147.79.81.59 (senamfo.com.br)  
**Sistema:** Ubuntu 22.04 LTS  
**Data:** $(date '+%Y-%m-%d')

---

## Fase 1: Preparação (1-2 horas)

- [x] Coletar dados de DEV (scripts executados)
- [x] Analisar inventory
- [ ] Preparar 1Password sincronização
- [ ] Criar docker-compose.yml para PROD
- [ ] Validar todas as dependências

## Fase 2: Configuração VPS (1-2 horas)

- [ ] SSH na VPS
- [ ] Instalar Docker + Docker Compose
- [ ] Instalar 1Password CLI
- [ ] Configurar firewall
- [ ] Clonar repositório Git

## Fase 3: Sincronização Credenciais (30 min)

- [ ] Exportar 1p_macos (se necessário)
- [ ] Criar/validar 1p_vps cofre
- [ ] Sincronizar secrets essenciais
- [ ] Testar acesso 1Password CLI na VPS

## Fase 4: Deploy Stacks (2-3 horas)

- [ ] Docker pull images
- [ ] docker-compose up (staging)
- [ ] Health checks
- [ ] Database migrations (se necessário)
- [ ] Testes E2E básicos

## Fase 5: Go-Live (30 min)

- [ ] Validar serviços
- [ ] Setup SSL/TLS (se necessário)
- [ ] Verificar logs
- [ ] Rollback procedure pronta

## Tempo Total Estimado: 5-8 horas
## Risk Level: MEDIUM

---

## Checklist de Segurança

- [ ] Nenhuma credencial hardcoded
- [ ] Todos os secrets no 1Password
- [ ] .env files no .gitignore
- [ ] Firewall configurado
- [ ] Backup procedure documentada

EOF
    
    log_success "Plano de deploy criado: ${PROD_DIR}/deployment_plan.md"
}

create_vps_checklist() {
    log_section "✅ Criando Checklist VPS"
    
    cat > "${PROD_DIR}/vps_prerequisites_check.sh" << 'EOF'
#!/bin/bash
# vps_prerequisites_check.sh
# Verifica pré-requisitos na VPS Ubuntu antes do deploy

echo "=== VPS PRE-REQUISITES CHECK ==="
echo ""

echo "=== SYSTEM INFO ==="
lsb_release -a
echo ""

echo "=== DOCKER ==="
docker --version || echo "Docker NÃO instalado"
docker-compose --version || echo "Docker Compose NÃO instalado"
echo ""

echo "=== RUNTIMES ==="
python3 --version || echo "Python3 NÃO instalado"
node --version || echo "Node NÃO instalado"
echo ""

echo "=== 1PASSWORD CLI ==="
op --version || echo "1Password CLI NÃO instalado"
echo ""

echo "=== NETWORK ==="
curl -I https://senamfo.com.br 2>&1 | head -3 || echo "Domínio não acessível"
echo ""

echo "=== DISK SPACE ==="
df -h /
echo ""

echo "=== FIREWALL ==="
sudo ufw status || echo "UFW não configurado"
echo ""

echo "=== GIT ==="
git --version || echo "Git NÃO instalado"
echo ""

echo "✅ Checklist completo"
EOF
    
    chmod +x "${PROD_DIR}/vps_prerequisites_check.sh"
    log_success "Checklist VPS criado: ${PROD_DIR}/vps_prerequisites_check.sh"
}

generate_summary() {
    log_section "📊 Resumo da Preparação"
    
    cat > "${PROD_DIR}/README.md" << EOF
# Preparação para Deploy VPS

**Gerado em:** $(date '+%Y-%m-%d %H:%M:%S')  
**Ambiente:** macOS Silicon → VPS Ubuntu 22.04

---

## Arquivos Gerados

### 1. Plano de Deploy
\`\`\`
${PROD_DIR}/deployment_plan.md
\`\`\`
Contém o plano passo a passo para implantação ordenada.

### 2. Checklist de Pré-requisitos VPS
\`\`\`
${PROD_DIR}/vps_prerequisites_check.sh
\`\`\`
Script para verificar se a VPS está pronta para deploy.

---

## Próximos Passos

1. **Revisar dados coletados:**
   \`\`\`bash
   cat ${DATA_DIR}/INVENTORY_REPORT.md
   \`\`\`

2. **Executar checklist na VPS:**
   \`\`\`bash
   ssh ubuntu@${VPS_HOST}
   # Copiar e executar vps_prerequisites_check.sh
   \`\`\`

3. **Seguir plano de deploy:**
   \`\`\`bash
   cat ${PROD_DIR}/deployment_plan.md
   \`\`\`

---

## Dados Coletados

Os dados coletados do ambiente macOS estão em:
\`\`\`
${DATA_DIR}/
\`\`\`

**Relatório completo:** \`${DATA_DIR}/INVENTORY_REPORT.md\`

---

## Ambiente Híbrido

| Ambiente | Sistema | Vault | Status |
|----------|---------|-------|--------|
| **DEV** | macOS Silicon | \`${VAULT_MACOS}\` | ✅ Dados coletados |
| **PROD** | VPS Ubuntu | \`${VAULT_VPS}\` | ⏳ Preparando |

**VPS:** ${VPS_HOST} (${VPS_DOMAIN})

---

✅ **Sistema pronto para preparação de deploy na VPS**

EOF
    
    log_success "README criado: ${PROD_DIR}/README.md"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_section "🚀 Preparando Deployment VPS"
    
    mkdir -p "${PROD_DIR}"
    
    create_deployment_plan
    echo ""
    
    create_vps_checklist
    echo ""
    
    generate_summary
    echo ""
    
    log_section "✅ Preparação Completa"
    log_success "Arquivos gerados em: ${PROD_DIR}/"
    echo ""
    echo "Arquivos criados:"
    ls -lh "${PROD_DIR}"/ 2>/dev/null | awk '{print "  - " $9 " (" $5 ")"}'
    echo ""
    echo "Próximos passos:"
    echo "  1. Revisar: cat ${PROD_DIR}/README.md"
    echo "  2. Executar checklist na VPS"
    echo "  3. Seguir plano de deploy"
    
    return 0
}

main "$@"

