# 🔧 Configuração Gemini Code Assist - VSCode e Cursor

**Versão**: 2.0.1
**Compatibilidade**: macOS Silicon, Ubuntu 22.04+
**Projeto GCP**: `gcp-ai-setup-24410` (501288307921)

---

## 📋 Visão Geral

Este guia explica como configurar o Gemini Code Assist no VSCode e Cursor, usando 1Password para gerenciar credenciais, tanto no macOS quanto na VPS Ubuntu.

---

## 🎯 Objetivo

Configurar:
- ✅ Extensão Gemini Code Assist no VSCode
- ✅ Extensão Gemini Code Assist no Cursor
- ✅ Gemini CLI
- ✅ Integração com 1Password para credenciais
- ✅ Mesmas configurações no macOS e Ubuntu

---

## 📦 Pré-requisitos

### 1Password

**macOS:**
```bash
brew install --cask 1password-cli
op signin
```

**Ubuntu:**
```bash
curl -sSf https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | \
  sudo tee /etc/apt/sources.list.d/1password.list

sudo apt update && sudo apt install 1password-cli
op signin
```

### 1Password - Configurar Item

Crie um item no 1Password com o seguinte formato:

**Vault**: `Infra`
**Item**: `Gemini_API_Keys`
**Campos**:
- `GEMINI_API_KEY`: [sua API key do Gemini]
- `GOOGLE_API_KEY`: [sua API key do Google]

---

## 🚀 Instalação Automática

### Executar Script de Instalação

```bash
cd ~/Dotfiles
./scripts/install/google-extensions.sh
```

Este script irá:
1. ✅ Detectar sistema operacional (macOS/Linux)
2. ✅ Verificar 1Password CLI
3. ✅ Instalar extensão no VSCode
4. ✅ Instalar extensão no Cursor
5. ✅ Configurar credenciais via 1Password
6. ✅ Instalar Gemini CLI
7. ✅ Configurar Gemini CLI

---

## 📝 Configuração Manual

### VSCode

**Arquivo**: `~/Library/Application Support/Code/User/settings.json` (macOS)
ou `~/.config/Code/User/settings.json` (Linux)

```json
{
  "geminiCodeAssist.project": "gcp-ai-setup-24410",
  "geminiCodeAssist.region": "us-central1",
  "geminiCodeAssist.apiKey": "[sua API key]",
  "geminiCodeAssist.googleApiKey": "[sua Google API key]",
  "geminiCodeAssist.enableAutoComplete": true,
  "geminiCodeAssist.enableCodeActions": true,
  "geminiCodeAssist.enableInlineSuggestions": true
}
```

### Cursor

**Arquivo**: `~/Library/Application Support/Cursor/User/settings.json` (macOS)
ou `~/.config/Cursor/User/settings.json` (Linux)

```json
{
  "geminiCodeAssist.project": "gcp-ai-setup-24410",
  "geminiCodeAssist.region": "us-central1",
  "geminiCodeAssist.apiKey": "[sua API key]",
  "geminiCodeAssist.googleApiKey": "[sua Google API key]",
  "geminiCodeAssist.enableAutoComplete": true,
  "geminiCodeAssist.enableCodeActions": true,
  "geminiCodeAssist.enableInlineSuggestions": true,
  "cursor.ai.gemini.enabled": true,
  "cursor.ai.gemini.project": "gcp-ai-setup-24410"
}
```

### Gemini CLI

**Arquivo**: `~/.config/gemini/config.yaml`

```yaml
gemini:
  apiKey: [sua API key]
  project: gcp-ai-setup-24410
  location: us-central1

google:
  apiKey: [sua Google API key]
  projectId: gcp-ai-setup-24410
  region: us-central1
```

---

## 🔐 Integração com 1Password

### Obter Credenciais via Script

```bash
# Obter API Key do Gemini
op read "op://Infra/Gemini_API_Keys/GEMINI_API_KEY"

# Obter Google API Key
op read "op://Infra/Gemini_API_Keys/GOOGLE_API_KEY"
```

### Script de Configuração Automática

O script `google-extensions.sh` usa automaticamente o 1Password:

```bash
# O script busca automaticamente:
get_1password_credential "Infra" "Gemini_API_Keys" "GEMINI_API_KEY"
get_1password_credential "Infra" "Gemini_API_Keys" "GOOGLE_API_KEY"
```

---

## ✅ Verificação

### Verificar Extensão Instalada

**VSCode:**
```bash
code --list-extensions | grep gemini-code-assist
```

**Cursor:**
```bash
cursor --list-extensions | grep gemini-code-assist
```

### Verificar Configuração

**VSCode:**
```bash
cat ~/Library/Application\ Support/Code/User/settings.json | grep geminiCodeAssist
```

**Cursor:**
```bash
cat ~/Library/Application\ Support/Cursor/User/settings.json | grep geminiCodeAssist
```

### Verificar Gemini CLI

```bash
gemini --version
gemini config list
```

---

## 🔧 Troubleshooting

### Erro: "Project ID invalid"

**Solução**:
1. Verificar projeto configurado:
   ```bash
   gcloud config get-value project
   ```

2. Configurar projeto correto:
   ```bash
   gcloud config set project gcp-ai-setup-24410
   ```

3. Verificar acesso:
   ```bash
   gcloud projects describe gcp-ai-setup-24410
   ```

### Erro: "API Key invalid"

**Solução**:
1. Verificar credenciais no 1Password
2. Verificar se o item está no vault correto (`Infra`)
3. Verificar se os campos estão nomeados corretamente
4. Testar acesso manual:
   ```bash
   op read "op://Infra/Gemini_API_Keys/GEMINI_API_KEY"
   ```

### Extensão não aparece

**Solução**:
1. Reiniciar VSCode/Cursor
2. Verificar se a extensão está instalada:
   ```bash
   code --list-extensions
   cursor --list-extensions
   ```
3. Reinstalar extensão:
   ```bash
   code --install-extension GoogleLLC.gemini-code-assist
   cursor --install-extension GoogleLLC.gemini-code-assist
   ```

---

## 📚 Referências

- [Gemini Code Assist Extension](https://marketplace.visualstudio.com/items?itemName=GoogleLLC.gemini-code-assist)
- [Gemini CLI Documentation](https://github.com/google/gemini-cli)
- [1Password CLI Documentation](https://developer.1password.com/docs/cli)

---

## 📝 Checklist

- [ ] 1Password CLI instalado e autenticado
- [ ] Item `Gemini_API_Keys` criado no vault `Infra`
- [ ] Extensão instalada no VSCode
- [ ] Extensão instalada no Cursor
- [ ] Configurações aplicadas via script
- [ ] Gemini CLI instalado
- [ ] Gemini CLI configurado
- [ ] Projeto GCP verificado: `gcp-ai-setup-24410`
- [ ] Testado em ambos macOS e Ubuntu

---

**Última atualização**: 2025-01-17
**Versão**: 2.0.1
