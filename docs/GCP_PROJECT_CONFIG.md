# 🔧 Configuração do Projeto GCP

**Projeto Válido**: `gcp-ai-setup-24410`
**Número do Projeto**: `501288307921`
**Região**: `us-central1`

---

## ✅ Informações do Projeto

- **ID do Projeto**: `gcp-ai-setup-24410`
- **Número do Projeto**: `501288307921`
- **Região Padrão**: `us-central1`

---

## 📁 Arquivos de Configuração

### 1. Gemini CLI Config

**Arquivo**: `~/Dotfiles/gemini/.gemini/config.yaml`

```yaml
gemini:
  apiKey: AIzaSyBlk5paegtx4M0cVmP88UWBVSjqmQlRPDY
  project: gcp-ai-setup-24410  # ✅ CORRETO
  location: us-central1
```

### 2. Gemini Config JSON

**Arquivo**: `~/Dotfiles/configs/gemini_config.json`

```json
{
  "gemini": {
    "gcp_project_id": "gcp-ai-setup-24410",
    "gcp_region": "us-central1"
  }
}
```

### 3. Cursor Google AI Config

**Arquivo**: `~/Dotfiles/cursor/config/google-ai/google-ai.config.example.json`

```json
{
  "google_cloud": {
    "project_id": "gcp-ai-setup-24410",
    "region": "us-central1"
  }
}
```

---

## 🔍 Verificação

### Verificar Projeto Atual no gcloud

```bash
# Verificar projeto configurado
gcloud config get-value project

# Deve retornar: gcp-ai-setup-24410

# Verificar número do projeto
gcloud projects describe gcp-ai-setup-24410 --format="value(projectNumber)"

# Deve retornar: 501288307921
```

### Configurar Projeto no gcloud

```bash
# Definir projeto padrão
gcloud config set project gcp-ai-setup-24410

# Verificar configuração
gcloud config list
```

---

## ⚠️ Erros Comuns

### Erro: "The set project ID was invalid"

**Causa**: Projeto não configurado ou sem permissões

**Solução**:
1. Verificar se está autenticado:
   ```bash
   gcloud auth list
   ```

2. Autenticar novamente se necessário:
   ```bash
   gcloud auth login
   ```

3. Configurar projeto:
   ```bash
   gcloud config set project gcp-ai-setup-24410
   ```

4. Verificar permissões:
   ```bash
   gcloud projects get-iam-policy gcp-ai-setup-24410
   ```

### Erro: "Current account lacks permission"

**Causa**: Conta não tem permissões no projeto

**Solução**:
1. Verificar se a conta tem acesso ao projeto
2. Solicitar permissões ao administrador do projeto
3. Verificar IAM policies:
   ```bash
   gcloud projects get-iam-policy gcp-ai-setup-24410 --flatten="bindings[].members" --format="table(bindings.role)"
   ```

---

## 🔧 Script de Verificação

Crie um script para verificar a configuração:

```bash
#!/bin/bash
# ~/Dotfiles/scripts/verify-gcp-config.sh

PROJECT_ID="gcp-ai-setup-24410"
PROJECT_NUMBER="501288307921"

echo "🔍 Verificando configuração GCP..."

# Verificar projeto atual
CURRENT_PROJECT=$(gcloud config get-value project 2>/dev/null)
if [ "$CURRENT_PROJECT" = "$PROJECT_ID" ]; then
    echo "✅ Projeto configurado corretamente: $PROJECT_ID"
else
    echo "❌ Projeto incorreto: $CURRENT_PROJECT"
    echo "   Configurando para: $PROJECT_ID"
    gcloud config set project "$PROJECT_ID"
fi

# Verificar autenticação
AUTH_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" | head -1)
if [ -n "$AUTH_ACCOUNT" ]; then
    echo "✅ Autenticado como: $AUTH_ACCOUNT"
else
    echo "❌ Nenhuma conta autenticada"
    echo "   Execute: gcloud auth login"
fi

# Verificar acesso ao projeto
if gcloud projects describe "$PROJECT_ID" &>/dev/null; then
    echo "✅ Acesso ao projeto confirmado"
else
    echo "❌ Sem acesso ao projeto"
    echo "   Verifique permissões ou execute: gcloud auth login"
fi
```

---

## 📝 Variáveis de Ambiente

Para usar em scripts, configure:

```bash
export GCP_PROJECT_ID="gcp-ai-setup-24410"
export GCP_PROJECT_NUMBER="501288307921"
export GCP_REGION="us-central1"
```

Adicione ao `~/.zshrc` ou `~/.bashrc`:

```bash
# GCP Configuration
export GCP_PROJECT_ID="gcp-ai-setup-24410"
export GCP_PROJECT_NUMBER="501288307921"
export GCP_REGION="us-central1"
```

---

## ✅ Checklist de Configuração

- [ ] Projeto configurado no gcloud: `gcloud config set project gcp-ai-setup-24410`
- [ ] Autenticação ativa: `gcloud auth list`
- [ ] Acesso ao projeto verificado: `gcloud projects describe gcp-ai-setup-24410`
- [ ] Arquivos de configuração atualizados com `gcp-ai-setup-24410`
- [ ] Variáveis de ambiente configuradas (opcional)

---

**Última atualização**: 2025-01-17
**Projeto**: gcp-ai-setup-24410 (501288307921)
