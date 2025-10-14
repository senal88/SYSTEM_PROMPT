#!/bin/bash
set -euo pipefail
BASE="$HOME"
mkdir -p \
  "$BASE/SystemBlueprint/system-integrity-checks" \
  "$BASE/SystemBlueprint/ai-awareness-contexts" \
  "$BASE/SystemBlueprint/workflows" \
  "$BASE/Workspaces/Finance" \
  "$BASE/Workspaces/Legal" \
  "$BASE/Workspaces/Infra" \
  "$BASE/Workspaces/LLMs" \
  "$BASE/Workspaces/Templates" \
  "$BASE/Workspaces/_to_sort" \
  "$BASE/Agents/local/n8n" \
  "$BASE/Agents/local/gptkit" \
  "$BASE/Agents/local/pipelines" \
  "$BASE/Agents/cloud/huggingface" \
  "$BASE/Agents/cloud/langchain" \
  "$BASE/Tools/scripts" \
  "$BASE/Tools/shell" \
  "$BASE/Tools/json_templates" \
  "$BASE/Tools/bin" \
  "$BASE/Containers/compose" \
  "$BASE/Containers/volumes" \
  "$BASE/Containers/logs" \
  "$BASE/Containers/registries" \
  "$BASE/DataVault/raw" \
  "$BASE/DataVault/processed" \
  "$BASE/DataVault/secure" \
  "$BASE/DataVault/temporal" \
  "$BASE/Backups/system" \
  "$BASE/Backups/git_repos" \
  "$BASE/Backups/documents" \
  "$BASE/Backups/dotfiles" \
  "$BASE/Secrets/env" \
  "$BASE/Secrets/api_keys" \
  "$BASE/Secrets/vault_config" \
  "$BASE/Dotfiles/git" \
  "$BASE/Dotfiles/shell" \
  "$BASE/Dotfiles/vscode" \
  "$BASE/Documentation/logs" \
  "$BASE/Documentation/install_guides" \
  "$BASE/Documentation/migration_notes" \
  "$BASE/Documentation/reports"

chmod 700 "$BASE/Secrets" "$BASE/Secrets/env" "$BASE/Secrets/api_keys" "$BASE/Secrets/vault_config"
chmod 750 "$BASE/Agents" "$BASE/Agents/local" "$BASE/Agents/cloud"
