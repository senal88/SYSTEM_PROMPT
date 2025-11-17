# Atualização de Datasets e GitHub

## 📋 Scripts Disponíveis

### GitHub

**Script:** `gh-setup.sh`

**Funcionalidades:**
- ✅ Configura GitHub CLI com autenticação via 1Password
- ✅ Configura Git (user.name, user.email, branch padrão)
- ✅ Configura SSH para GitHub
- ✅ Configura repositório dotfiles

**Uso:**
```bash
cd ~/Dotfiles/automation_1password/scripts
./gh-setup.sh
```

**Pré-requisitos:**
- 1Password CLI configurado e logado
- Token do GitHub armazenado no 1Password (criado automaticamente se não existir)
- GitHub CLI instalado (opcional, mas recomendado)

### Hugging Face

**Script:** `hf-setup.sh`

**Funcionalidades:**
- ✅ Configura Hugging Face CLI com autenticação via 1Password
- ✅ Configura variáveis de ambiente
- ✅ Cria funções helper para gerenciamento
- ✅ Integra com shell config

**Uso:**
```bash
cd ~/Dotfiles/automation_1password/scripts
./hf-setup.sh
```

**Pré-requisitos:**
- 1Password CLI configurado e logado
- Token do Hugging Face armazenado no 1Password (criado automaticamente se não existir)
- Hugging Face CLI instalado (instalado automaticamente se pip disponível)

## 🔧 Funções Disponíveis (Hugging Face)

Após executar `hf-setup.sh`, as seguintes funções estarão disponíveis:

### `hf-login [vault]`
Login no Hugging Face usando token do 1Password
```bash
hf-login 1p_macos
```

### `hf-deploy-model <model_path> [repo_name]`
Deploy de modelo para Hugging Face
```bash
hf-deploy-model ./my-model senal88/my-model
```

### `hf-upload-dataset <dataset_path> [repo_name]`
Upload de dataset para Hugging Face
```bash
hf-upload-dataset ./my-dataset senal88/my-dataset
```

### `hf-query-endpoint <prompt>`
Query no endpoint de inferência
```bash
hf-query-endpoint "Hello, world!"
```

### `hf-list-models`
Lista todos os modelos do usuário
```bash
hf-list-models
```

### `hf-list-datasets`
Lista todos os datasets do usuário
```bash
hf-list-datasets
```

### `hf-status`
Mostra status do Hugging Face
```bash
hf-status
```

## 📊 Configuração de Tokens

### Criar Token no 1Password

#### GitHub Token
```bash
op item create \
  --category=password \
  --title="GitHub Token" \
  --vault=1p_macos \
  --field="username=luiz.sena88" \
  --field="password=<seu_token>" \
  --field="url=https://github.com/settings/tokens"
```

#### Hugging Face Token
```bash
op item create \
  --category=password \
  --title="Hugging Face Token" \
  --vault=1p_macos \
  --field="username=senal88" \
  --field="password=<seu_token>" \
  --field="url=https://huggingface.co/settings/tokens"
```

## 🔄 Fluxo de Trabalho

### Setup Inicial
1. Execute `gh-setup.sh` para configurar GitHub
2. Execute `hf-setup.sh` para configurar Hugging Face
3. Recarregue o shell: `source ~/.zshrc`

### Uso Diário

#### GitHub
```bash
# Verificar status
gh auth status

# Listar repositórios
gh repo list

# Criar novo repositório
gh repo create meu-repo --public

# Sincronizar dotfiles
cd ~/Dotfiles
git add .
git commit -m "Update"
git push
```

#### Hugging Face
```bash
# Verificar status
hf-status

# Listar modelos
hf-list-models

# Deploy de modelo
hf-deploy-model ./modelo senal88/meu-modelo

# Upload de dataset
hf-upload-dataset ./dataset senal88/meu-dataset
```

## 🔗 Links Úteis

### GitHub
- Settings: https://github.com/settings
- Tokens: https://github.com/settings/tokens
- SSH Keys: https://github.com/settings/keys
- Codespaces: https://github.com/codespaces

### Hugging Face
- Perfil: https://huggingface.co/senal88
- Settings: https://huggingface.co/settings
- Tokens: https://huggingface.co/settings/tokens
- Endpoint: https://endpoints.huggingface.co/senal88/endpoints/all-minilm-l6-v2-bks
- Spaces: https://huggingface.co/spaces/senal88/Qwen3-Coder-WebDev

## ✅ Checklist de Setup

- [ ] 1Password CLI configurado e funcionando
- [ ] Executar `gh-setup.sh`
- [ ] Executar `hf-setup.sh`
- [ ] Recarregar shell: `source ~/.zshrc`
- [ ] Testar: `gh auth status`
- [ ] Testar: `hf-status`
- [ ] Testar: `hf-list-models`

---

**Última atualização:** 2025-11-04
**Status:** Scripts criados e prontos para uso

