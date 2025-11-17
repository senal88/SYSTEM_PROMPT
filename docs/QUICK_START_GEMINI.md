# 🚀 Quick Start - Gemini Code Assist

**Versão**: 2.0.1
**Tempo estimado**: 5-10 minutos

---

## ⚡ Instalação Rápida

### Passo 1: Configurar 1Password

```bash
cd ~/Dotfiles
./scripts/install/setup-1password-gemini.sh
```

Este script irá:
- ✅ Verificar se 1Password CLI está instalado
- ✅ Verificar se o item `Gemini_API_Keys` existe
- ✅ Criar o item se não existir

### Passo 2: Instalar Extensões e Configurar

```bash
cd ~/Dotfiles
./scripts/install/google-extensions.sh
```

Este script irá:
- ✅ Instalar extensão Gemini Code Assist no VSCode
- ✅ Instalar extensão Gemini Code Assist no Cursor
- ✅ Configurar credenciais via 1Password
- ✅ Instalar e configurar Gemini CLI

### Passo 3: Reiniciar Editores

Reinicie o VSCode e Cursor para aplicar as configurações.

---

## ✅ Verificação Rápida

```bash
# Verificar extensão instalada
code --list-extensions | grep gemini-code-assist
cursor --list-extensions | grep gemini-code-assist

# Verificar Gemini CLI
gemini --version

# Verificar projeto GCP
gcloud config get-value project
# Deve retornar: gcp-ai-setup-24410
```

---

## 🔧 Configuração Manual (se necessário)

Se o script automático não funcionar, configure manualmente:

### 1Password - Criar Item Manualmente

1. Abra 1Password
2. Vault: `Infra`
3. Criar novo item:
   - Tipo: Secure Note
   - Título: `Gemini_API_Keys`
   - Campos customizados:
     - `GEMINI_API_KEY`: [sua API key]
     - `GOOGLE_API_KEY`: [sua Google API key]

### VSCode - Configuração Manual

Adicione ao `settings.json`:

```json
{
  "geminiCodeAssist.project": "gcp-ai-setup-24410",
  "geminiCodeAssist.region": "us-central1",
  "geminiCodeAssist.apiKey": "[sua API key]",
  "geminiCodeAssist.googleApiKey": "[sua Google API key]"
}
```

### Cursor - Configuração Manual

Adicione ao `settings.json`:

```json
{
  "geminiCodeAssist.project": "gcp-ai-setup-24410",
  "geminiCodeAssist.region": "us-central1",
  "geminiCodeAssist.apiKey": "[sua API key]",
  "geminiCodeAssist.googleApiKey": "[sua Google API key]"
}
```

---

## 📚 Documentação Completa

Para mais detalhes, consulte:
- [Guia Completo](GEMINI_CODE_ASSIST_SETUP.md)
- [Configuração GCP](GCP_PROJECT_CONFIG.md)

---

**Última atualização**: 2025-01-17
