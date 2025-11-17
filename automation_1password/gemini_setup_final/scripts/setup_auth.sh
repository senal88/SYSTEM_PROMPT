#!/bin/bash
set -euo pipefail

PROJECT_ID="gcp-ai-setup-24410"
APIS_TO_ENABLE=(
    "cloudaicompanion.googleapis.com"
    "serviceusage.googleapis.com"
    "cloudresourcemanager.googleapis.com"
    "iam.googleapis.com"
    "people.googleapis.com"
)
ROLES_TO_GRANT=(
    "roles/cloudaicompanion.user"
    "roles/cloudaicompanion.settingsUser"
    "roles/developerconnect.oauthUser"
    "roles/serviceusage.serviceUsageConsumer"
)

print_info() { printf "\n\033[1;34m%s\033[0m\n" "$1"; }
print_success() { printf "\033[1;32m%s\033[0m\n" "$1"; }
print_warning() { printf "\033[1;33m%s\033[0m\n" "$1"; }

print_info "--- Iniciando Configuração de Autenticação Gemini para o Projeto ${PROJECT_ID} ---"

print_info "[1/4] Configurando gcloud para usar o projeto: ${PROJECT_ID}"
gcloud config set project ${PROJECT_ID}
print_success "✅ Projeto definido."

print_info "[2/4] Habilitando APIs necessárias..."
gcloud services enable "${APIS_TO_ENABLE[@]}" --project=${PROJECT_ID}
print_success "✅ APIs habilitadas."

print_info "[3/4] Identificando a identidade gcloud ativa..."
ACTIVE_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
if [[ -z "$ACTIVE_ACCOUNT" ]]; then
    print_warning "Nenhuma conta ativa. Por favor, autentique-se primeiro."
    exit 1
fi
MEMBER_TYPE="user"
if [[ "$ACTIVE_ACCOUNT" == *.iam.gserviceaccount.com ]]; then
    MEMBER_TYPE="serviceAccount"
fi
print_success "✅ Identidade ativa: ${ACTIVE_ACCOUNT} (Tipo: ${MEMBER_TYPE})"

print_info "[4/4] Concedendo papéis de IAM para ${ACTIVE_ACCOUNT}..."
for role in "${ROLES_TO_GRANT[@]}"; do
    echo "   - Aplicando papel: ${role}"
    gcloud projects add-iam-policy-binding ${PROJECT_ID} \
        --member="${MEMBER_TYPE}:${ACTIVE_ACCOUNT}" \
        --role="${role}" \
        --condition=None > /dev/null
done
print_success "✅ Papéis de IAM concedidos com sucesso."

print_info "--- 🎉 Configuração Concluída! ---"
print_success "A identidade '${ACTIVE_ACCOUNT}' está pronta para usar o Gemini."
echo "Para confirmar, execute o script './verify_config.sh'."
