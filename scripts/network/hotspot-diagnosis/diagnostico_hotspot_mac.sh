#!/usr/bin/env bash
################################################################################
# 🔍 DIAGNÓSTICO DE HOTSPOT BASEADO EM MAC
#
# DESCRIÇÃO:
#   Script completo para diagnosticar problemas de Hotspot com controle
#   de acesso por MAC em ambientes macOS (Apple Silicon).
#
# VERSÃO: 1.0.0
# DATA: 2025-01-15
# STATUS: ATIVO
################################################################################

set -euo pipefail

###############################################################################
# PARÂMETROS REFERENTES À MENSAGEM DO HOTSPOT
###############################################################################
# Preencher com os dados recebidos do sistema de Hotspot.
# Dados do caso específico:
#   IP  : 10.255.3.141
#   MAC : 7A:93:43:66:C4:12

HOTSPOT_IP_INFORMADO="10.255.3.141"
HOTSPOT_MAC_INFORMADO="7A:93:43:66:C4:12"

###############################################################################
# PREPARAÇÃO DE DIRETÓRIOS E ARQUIVOS
###############################################################################

TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BASE_DIR="${HOME}/network_hotspot_diag"
mkdir -p "$BASE_DIR"

REPORT_FILE="$BASE_DIR/diag_hotspot_${TIMESTAMP}.md"
RAW_FILE="$BASE_DIR/diag_hotspot_raw_${TIMESTAMP}.log"

# Cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[✅]${NC} $*"
}

log_error() {
    echo -e "${RED}[❌]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[⚠️]${NC} $*"
}

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════════════╗"
    echo "║ $1"
    echo "╚════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

###############################################################################
# IDENTIFICAÇÃO DO SERVIÇO Wi-Fi E INTERFACE
###############################################################################

print_header "🔍 IDENTIFICAÇÃO DO SERVIÇO Wi-Fi"

ALL_SERVICES="$(networksetup -listallnetworkservices 2>/dev/null | tail -n +2 || true)"

# Remove possível asterisco de serviços desativados e captura "Wi-Fi"
WIFI_SERVICE="$(printf '%s\n' "$ALL_SERVICES" \
  | sed 's/^\*//g' \
  | awk '/^Wi[- ]Fi$/I {print; exit}')"

if [[ -z "${WIFI_SERVICE:-}" ]]; then
  log_error "Serviço Wi-Fi não identificado."
  log_info "Saída de networksetup -listallnetworkservices:"
  networksetup -listallnetworkservices 2>&1 | tee -a "$RAW_FILE" || true
  exit 1
fi

log_success "Serviço Wi-Fi identificado: $WIFI_SERVICE"

# Localiza a interface física associada ao Wi-Fi (ex.: en0)
WIFI_DEVICE="$(networksetup -listallhardwareports 2>/dev/null | awk '
/Wi-Fi|AirPort/ {getline; if ($1=="Device:") print $2}' | head -n1)"

if [[ -z "${WIFI_DEVICE:-}" ]]; then
  log_error "Interface física associada ao Wi-Fi não encontrada."
  log_info "Saída de networksetup -listallhardwareports:"
  networksetup -listallhardwareports 2>&1 | tee -a "$RAW_FILE" || true
  exit 1
fi

log_success "Interface física identificada: $WIFI_DEVICE"

###############################################################################
# COLETA DE DADOS BRUTOS
###############################################################################

print_header "📊 COLETA DE DADOS DE REDE"

log_info "Coletando informações de rede..."

{
  echo "===== DATA/HORA ====="
  date

  echo
  echo "===== SERVIÇO Wi-Fi ====="
  echo "Serviço: $WIFI_SERVICE"
  echo "Interface: $WIFI_DEVICE"

  echo
  echo "===== networksetup -getinfo \"$WIFI_SERVICE\" ====="
  networksetup -getinfo "$WIFI_SERVICE" || true

  echo
  echo "===== networksetup -getdnsservers \"$WIFI_SERVICE\" ====="
  networksetup -getdnsservers "$WIFI_SERVICE" || true

  echo
  echo "===== ifconfig $WIFI_DEVICE ====="
  ifconfig "$WIFI_DEVICE" || true

  echo
  echo "===== ipconfig getifaddr $WIFI_DEVICE ====="
  ipconfig getifaddr "$WIFI_DEVICE" || true

  echo
  echo "===== route -n get default ====="
  route -n get default 2>/dev/null || true

  echo
  echo "===== arp -a ====="
  arp -a 2>/dev/null || true

  echo
  echo "===== hostname / scutil ====="
  hostname || true
  scutil --get ComputerName 2>/dev/null || true
  scutil --get LocalHostName 2>/dev/null || true

} > "$RAW_FILE" 2>&1

log_success "Dados brutos coletados em: $RAW_FILE"

###############################################################################
# EXTRAÇÃO DE CAMPOS RELEVANTES
###############################################################################

log_info "Extraindo campos relevantes..."

GETINFO_OUT="$(networksetup -getinfo "$WIFI_SERVICE" 2>/dev/null || true)"

IP_ADDR="$(printf '%s\n' "$GETINFO_OUT" \
  | awk -F': ' '/IP address/ {print $2; exit}' \
  | sed 's/^[[:space:]]*//')"

ROUTER_ADDR="$(printf '%s\n' "$GETINFO_OUT" \
  | awk -F': ' '/Router/ {print $2; exit}' \
  | sed 's/^[[:space:]]*//')"

SUBNET_MASK="$(printf '%s\n' "$GETINFO_OUT" \
  | awk -F': ' '/Subnet mask/ {print $2; exit}' \
  | sed 's/^[[:space:]]*//')"

DNS_LINE="$(networksetup -getdnsservers "$WIFI_SERVICE" 2>/dev/null \
  | tr '\n' ' ' \
  | sed 's/[[:space:]]\+/ /g; s/[[:space:]]$//')"

MAC_IFCONFIG="$(ifconfig "$WIFI_DEVICE" 2>/dev/null \
  | awk '/ether / {print $2; exit}')"

MAC_SERVICE_LINE="$(networksetup -getmacaddress "$WIFI_SERVICE" 2>/dev/null || true)"
MAC_SERVICE="$(printf '%s\n' "$MAC_SERVICE_LINE" \
  | awk '{for (i=1;i<=NF;i++) if ($i ~ /^[0-9a-fA-F][0-9a-fA-F]:/) {print $i; exit}}')"

HOSTNAME_VAL="$(hostname 2>/dev/null || echo '')"
COMPUTER_NAME_VAL="$(scutil --get ComputerName 2>/dev/null || echo '')"

###############################################################################
# ANÁLISE: MAC PRIVADO x MAC FÍSICO
###############################################################################

print_header "🔍 ANÁLISE: MAC PRIVADO vs MAC FÍSICO"

PRIVATE_MAC_STATUS="Indeterminado"

if [[ -n "$MAC_IFCONFIG" && -n "$MAC_SERVICE" ]]; then
  if [[ "$MAC_IFCONFIG" != "$MAC_SERVICE" ]]; then
    PRIVATE_MAC_STATUS="Provável uso de 'Endereço Wi-Fi privado' (MAC aleatório por SSID)."
    log_warning "$PRIVATE_MAC_STATUS"
  else
    PRIVATE_MAC_STATUS="Provável uso do MAC físico da interface."
    log_success "$PRIVATE_MAC_STATUS"
  fi
fi

log_info "MAC atual (ifconfig): ${MAC_IFCONFIG:-desconhecido}"
log_info "MAC do serviço (networksetup): ${MAC_SERVICE:-desconhecido}"

###############################################################################
# COMPARAÇÃO COM DADOS INFORMADOS PELO HOTSPOT
###############################################################################

print_header "🔍 COMPARAÇÃO COM DADOS DO HOTSPOT"

HOTSPOT_COMPAT_STATUS="Não avaliado (dados do Hotspot não preenchidos)."

  if [[ -n "${HOTSPOT_MAC_INFORMADO:-}" && -n "$MAC_IFCONFIG" ]]; then
  # normaliza para minúsculas (compatível com bash 3.x do macOS)
  MAC_IFC_LC=$(echo "$MAC_IFCONFIG" | tr '[:upper:]' '[:lower:]')
  HOTSPOT_MAC_LC=$(echo "$HOTSPOT_MAC_INFORMADO" | tr '[:upper:]' '[:lower:]')

  if [[ "$HOTSPOT_MAC_LC" == "$MAC_IFC_LC" ]]; then
    HOTSPOT_COMPAT_STATUS="MAC atual do dispositivo coincide com o MAC informado pelo Hotspot."
    log_success "$HOTSPOT_COMPAT_STATUS"
  else
    HOTSPOT_COMPAT_STATUS="MAC atual do dispositivo NÃO coincide com o MAC informado pelo Hotspot."
    log_warning "$HOTSPOT_COMPAT_STATUS"
    log_info "MAC atual: ${MAC_IFCONFIG}"
    log_info "MAC Hotspot: ${HOTSPOT_MAC_INFORMADO}"
  fi
fi

# Comparação de IP
if [[ -n "${HOTSPOT_IP_INFORMADO:-}" && -n "$IP_ADDR" ]]; then
  if [[ "$HOTSPOT_IP_INFORMADO" == "$IP_ADDR" ]]; then
    log_success "IP atual coincide com o IP informado pelo Hotspot: $IP_ADDR"
  else
    log_warning "IP atual ($IP_ADDR) difere do IP informado pelo Hotspot ($HOTSPOT_IP_INFORMADO)"
  fi
fi

###############################################################################
# GERAÇÃO DO RELATÓRIO (MARKDOWN)
###############################################################################

print_header "📝 GERANDO RELATÓRIO"

{
  echo "# 🔍 Diagnóstico de Hotspot por MAC"
  echo
  echo "**Gerado em:** $(date '+%Y-%m-%d %H:%M:%S')"
  echo "**Versão do script:** 1.0.0"
  echo
  echo "---"
  echo
  echo "## 1. Identificação do dispositivo"
  echo
  echo "- **Hostname** (hostname): \`${HOSTNAME_VAL:-nao_disponivel}\`"
  echo "- **ComputerName** (scutil): \`${COMPUTER_NAME_VAL:-nao_disponivel}\`"
  echo "- **Serviço Wi-Fi** (networksetup): \`$WIFI_SERVICE\`"
  echo "- **Interface física** (device): \`$WIFI_DEVICE\`"
  echo
  echo "## 2. Dados lidos no macOS"
  echo
  echo "- **IP local via DHCP:** \`${IP_ADDR:-desconhecido}\`"
  echo "- **Máscara de sub-rede:** \`${SUBNET_MASK:-desconhecida}\`"
  echo "- **Gateway/roteador:** \`${ROUTER_ADDR:-desconhecido}\`"
  echo "- **DNS configurado no serviço Wi-Fi:** \`${DNS_LINE:-indefinido/padrao}\`"
  echo "- **MAC atual em uso** (ifconfig): \`${MAC_IFCONFIG:-desconhecido}\`"
  echo "- **MAC associado ao serviço** (networksetup -getmacaddress): \`${MAC_SERVICE:-desconhecido}\`"
  echo "- **Situação quanto a 'Endereço Wi-Fi privado':** $PRIVATE_MAC_STATUS"
  echo
  echo "## 3. Dados informados pelo Hotspot"
  echo
  echo "- **IP recebido na mensagem do Hotspot:** \`${HOTSPOT_IP_INFORMADO:-nao_informado}\`"
  echo "- **MAC recebido na mensagem do Hotspot:** \`${HOTSPOT_MAC_INFORMADO:-nao_informado}\`"
  echo "- **Comparação MAC Hotspot x MAC atual do dispositivo:** $HOTSPOT_COMPAT_STATUS"
  echo
  echo "## 4. Interpretação técnica da mensagem do Hotspot"
  echo
  echo "### Contexto"
  echo
  echo "A mensagem **\"Hotspot não foi encontrado em nosso dashboard\"** indica que:"
  echo
  echo "1. O sistema de Hotspot buscou o MAC \`${HOTSPOT_MAC_INFORMADO:-N/A}\` na base de dispositivos cadastrados."
  echo "2. **Não encontrou** esse MAC na lista de dispositivos autorizados."
  echo "3. Por política de segurança, bloqueou ou não completou a autorização de acesso."
  echo
  echo "### Condição necessária para autorização"
  echo
  echo "Em ambientes com **controle de acesso por MAC (NAC/Hotspot)**, o dispositivo é liberado somente quando:"
  echo
  echo "- O endereço MAC que o cliente está efetivamente usando na rede (naquele SSID) **coincide** com o endereço MAC cadastrado no dashboard."
  echo
  echo "### Uso de Endereço Wi-Fi Privado"
  echo
  echo "Em ambientes Apple modernos, é comum o uso de **\"Endereço Wi-Fi privado\"** (MAC aleatório por SSID). Nesses casos:"
  echo
  echo "- O Hotspot enxerga um MAC diferente do MAC físico da placa."
  echo "- Se o dashboard estiver configurado com o MAC físico, e o cliente estiver usando MAC privado, haverá divergência e o acesso não será reconhecido."
  echo
  echo "## 5. Arquivos gerados para suporte"
  echo
  echo "- **Relatório em Markdown** (este arquivo): \`$REPORT_FILE\`"
  echo "- **Log bruto completo** de comandos de rede: \`$RAW_FILE\`"
  echo
  echo "## 6. Campos para registro no dashboard do Hotspot"
  echo
  echo "### Informações do dispositivo"
  echo
  echo "- **Nome do usuário/conta no Hotspot:** \`{{HOTSPOT_USUARIO_CONTA}}\`"
  echo "- **Identificador interno** (CPF/CNPJ/matrícula/etc.): \`{{HOTSPOT_IDENTIFICADOR_INTERNO}}\`"
  echo "- **Nome do dispositivo no painel:** \`{{HOTSPOT_NOME_DISPOSITIVO}}\`"
  echo
  echo "### MACs para cadastro"
  echo
  echo "- **MAC atual do cliente** (ifconfig): \`${MAC_IFCONFIG:-preencher_manual}\`"
  echo "- **MAC informado pelo sistema Hotspot** (mensagem): \`${HOTSPOT_MAC_INFORMADO:-preencher_manual}\`"
  echo
  echo "⚠️ **IMPORTANTE:** Garantir que o MAC que será cadastrado no dashboard corresponda ao MAC que o cliente realmente utiliza na rede."
  echo
  echo "## 7. Pontos de atenção para o cadastro no Hotspot"
  echo
  echo "1. **MAC em uso vs MAC físico:**"
  echo "   - Se o cadastro for por MAC físico, mas o cliente usar \"Endereço Wi-Fi privado\", haverá divergência."
  echo "   - Em ambientes em que o cadastro é por MAC físico, a coexistência com 'Endereço Wi-Fi privado' precisa ser avaliada."
  echo
  echo "2. **Coincidência de MACs:**"
  echo "   - O MAC que o Hotspot enxerga deve coincidir exatamente com o MAC cadastrado no dashboard."
  echo "   - Diferenças de case (maiúsculas/minúsculas) geralmente não são problema, mas formatos diferentes podem causar falhas."
  echo
  echo "3. **Validação pós-cadastro:**"
  echo "   - Após cadastrar o MAC no dashboard, desconectar e reconectar o Wi-Fi para forçar nova autenticação."
  echo "   - Verificar se o acesso é liberado corretamente."
  echo
  echo "---"
  echo
  echo "**Relatório de diagnóstico de Hotspot concluído.**"
  echo
  echo "*Gerado por: diagnostico_hotspot_mac.sh v1.0.0*"

} > "$REPORT_FILE"

log_success "Relatório gerado em: $REPORT_FILE"

###############################################################################
# SAÍDA FINAL NO TERMINAL
###############################################################################

print_header "✅ DIAGNÓSTICO CONCLUÍDO"

echo "📄 Relatório: $REPORT_FILE"
echo "📋 Log bruto: $RAW_FILE"
echo ""
echo "📡 Serviço Wi-Fi: $WIFI_SERVICE"
echo "🔌 Interface: $WIFI_DEVICE"
echo "🌐 IP Atual: ${IP_ADDR:-desconhecido}"
echo "🔑 MAC Atual: ${MAC_IFCONFIG:-desconhecido}"
echo ""

if [[ -n "$MAC_IFCONFIG" && -n "${HOTSPOT_MAC_INFORMADO:-}" ]]; then
    MAC_IFC_LC=$(echo "$MAC_IFCONFIG" | tr '[:upper:]' '[:lower:]')
    HOTSPOT_MAC_LC=$(echo "$HOTSPOT_MAC_INFORMADO" | tr '[:upper:]' '[:lower:]')

  if [[ "$HOTSPOT_MAC_LC" != "$MAC_IFC_LC" ]]; then
    log_warning "⚠️  MAC atual difere do MAC informado pelo Hotspot!"
    echo ""
    echo "   MAC atual:      $MAC_IFCONFIG"
    echo "   MAC do Hotspot: $HOTSPOT_MAC_INFORMADO"
    echo ""
    echo "   Ação recomendada: Cadastrar o MAC atual no dashboard do Hotspot."
  fi
fi

echo "=============================================================="
echo ""
echo "Próximos passos:"
echo "1. Revisar o relatório gerado: $REPORT_FILE"
echo "2. Usar o template para cadastro: TEMPLATE_HOTSPOT_REGISTRO_MAC.md"
echo "3. Cadastrar o MAC correto no dashboard do Hotspot"
echo ""

exit 0
