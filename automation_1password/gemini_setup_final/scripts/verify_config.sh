#!/bin/bash
set -euo pipefail

PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
ACTIVE_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>/dev/null)

print_info() { printf "\n\033[1;34m%s\033[0m\n" "$1"; }
print_success() { printf "\033[1;32m%s\033[0m\n" "$1"; }
print_error() { printf "\033[1;31m%s\033[0m\n" "$1"; }

print_info "--- Verificando Configuração do Gemini ---"

if [[ -z "$ACTIVE_ACCOUNT" ]] || [[ -z "$PROJECT_ID" ]]; then
    print_error "❌ Erro: Conta ou projeto não encontrado. Execute 'setup_auth.sh'."
    exit 1
fi
echo "- Conta Ativa: ${ACTIVE_ACCOUNT}"
echo "- Projeto Ativo: ${PROJECT_ID}"

print_info "--- Verificando Papéis de IAM para ${ACTIVE_ACCOUNT} ---"
MEMBER_TYPE="user"
if [[ "$ACTIVE_ACCOUNT" == *.iam.gserviceaccount.com ]]; then
    MEMBER_TYPE="serviceAccount"
fi

IAM_POLICY=$(gcloud projects get-iam-policy "$PROJECT_ID" --flatten="bindings[].members" --format="json")
MEMBER_ROLES=$(echo "$IAM_POLICY" | jq -r --arg full_member "${MEMBER_TYPE}:${ACTIVE_ACCOUNT}" '.[] | select(.bindings.members == $full_member and (.condition == null or .condition.expression == "true")) | .bindings.role')

if [[ -z "$MEMBER_ROLES" ]]; then
    print_error "❌ Nenhum papel de IAM encontrado. Execute 'setup_auth.sh' novamente."
    exit 1
fi

ALL_ROLES_FOUND=true
for role in "roles/cloudaicompanion.user" "roles/developerconnect.oauthUser"; do
    if echo "$MEMBER_ROLES" | grep -q "^${role}$"; then
        echo "  - ${role} ... ✅"
    else
        echo "  - ${role} ... ❌"
        ALL_ROLES_FOUND=false
    fi
done

if $ALL_ROLES_FOUND; then
    print_success "\n✅ Verificação concluída com sucesso! Sua conta está pronta."
else
    print_error "\n❌ Verificação falhou. Papéis de IAM faltando."
fi
