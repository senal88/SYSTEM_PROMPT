# 🔧 Fix Setup Gemini - VPS Ubuntu e macOS Silicon

**Data:** 2025-12-01  
**Versão:** 1.0.0  
**Status:** ✅ **ATIVO**

---

## 📋 Visão Geral

Script automatizado para corrigir e configurar Google Gemini API em ambos os ambientes:

- ✅ **VPS Ubuntu:** Configura variáveis de ambiente e valida acesso
- ✅ **macOS Silicon:** Configura CLI, SDK Python e valida credenciais

---

## 🚀 Uso Rápido

### Execução Completa

```bash
cd ~/Dotfiles/system_prompts/global/scripts
./fix-setup-gemini-vps-macos_v1.0.0_20251201.sh --all
```

### Apenas VPS

```bash
./fix-setup-gemini-vps-macos_v1.0.0_20251201.sh --vps
```

### Apenas macOS

```bash
./fix-setup-gemini-vps-macos_v1.0.0_20251201.sh --macos
```

---

## 🔐 O que o Script Faz

### VPS Ubuntu

1. ✅ Obtém Gemini API Key do vault `1p_vps` via 1Password CLI
2. ✅ Cria `~/.config/gemini/api_key` com permissões 600
3. ✅ Adiciona variáveis de ambiente ao `~/.bashrc`:
   - `GEMINI_API_KEY`
   - `GOOGLE_API_KEY`
4. ✅ Testa a API Key via curl

### macOS Silicon

1. ✅ Obtém Gemini API Key do vault `1p_macos` via 1Password CLI
2. ✅ Cria `~/.config/gemini/api_key` com permissões 600
3. ✅ Adiciona variáveis de ambiente ao `~/.zshrc`:
   - `GEMINI_API_KEY`
   - `GOOGLE_API_KEY`
4. ✅ Instala `google-generativeai` SDK (Python) se necessário
5. ✅ Instala Gemini CLI via Homebrew se necessário
6. ✅ Testa a API Key via curl

---

## 📦 Dependências

### Pré-requisitos

- ✅ 1Password CLI instalado e autenticado
- ✅ Acesso aos vaults `1p_vps` e/ou `1p_macos`
- ✅ Gemini API Key cadastrada no 1Password
- ✅ SSH configurado para VPS (se usar `--vps`)
- ✅ Homebrew instalado no macOS (para CLI)

### Itens 1Password Esperados

#### VPS (`1p_vps`)

- `Gemini-API` (ID: `knknnlaetdh6tqetsjyxh23kle`)
- `GCP - Gemini Code Assist` (ID: `6zhhvw43e4cprsqgtzmqxuqysa`)
- Qualquer item com campo `API_KEY` ou `password` contendo a chave

#### macOS (`1p_macos`)

- `Gemini_API_Key_macos` (ID: `27ateuu2y37dblvo3lkb4szt6y`)
- `GOOGLE_API_KEY` (ID: `6xbzl566sj62zphes4b6kodt5e` ou `jnu4r2zp23tvpsnmeeh5dwvgia`)
- Qualquer item com campo `API_KEY` ou `password` contendo a chave

---

## 🔍 Validação

### Verificar Configuração VPS

```bash
ssh admin-vps
source ~/.bashrc
echo $GEMINI_API_KEY
curl -s "https://generativelanguage.googleapis.com/v1/models?key=${GEMINI_API_KEY}" | head -20
```

### Verificar Configuração macOS

```bash
source ~/.zshrc
echo $GEMINI_API_KEY
curl -s "https://generativelanguage.googleapis.com/v1/models?key=${GEMINI_API_KEY}" | head -20
```

### Testar Python SDK

```python
import google.generativeai as genai
import os

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
models = genai.list_models()
for model in models:
    print(model.name)
```

---

## 📁 Estrutura de Arquivos Criados

### VPS Ubuntu

```
~/.config/gemini/
└── api_key          # API Key (permissões 600)

~/.bashrc            # Variáveis de ambiente adicionadas
```

### macOS Silicon

```
~/.config/gemini/
└── api_key          # API Key (permissões 600)

~/.zshrc             # Variáveis de ambiente adicionadas
```

---

## 🔄 Integração com Sistema de Automação

Este script pode ser integrado ao sistema de automação completa:

```bash
# No script de automação completa
if [[ "${SETUP_GEMINI}" == "true" ]]; then
    "${SCRIPT_DIR}/fix-setup-gemini-vps-macos_v1.0.0_20251201.sh" --all
fi
```

---

## ⚠️ Troubleshooting

### Erro: "1Password CLI não encontrado"

```bash
# macOS
brew install --cask 1password-cli

# VPS Ubuntu
curl -sSf https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
sudo apt update && sudo apt install 1password-cli
```

### Erro: "Não foi possível obter API Key"

1. Verificar se o item existe no vault:
   ```bash
   op item list --vault 1p_vps | grep -i gemini
   op item list --vault 1p_macos | grep -i gemini
   ```

2. Verificar campos do item:
   ```bash
   op item get ITEM_ID --vault VAULT_NAME
   ```

3. Criar item manualmente se necessário:
   ```bash
   op item create --vault VAULT_NAME \
     --category "API Credential" \
     --title "Gemini-API" \
     API_KEY="sua-api-key-aqui"
   ```

### Erro: "API Key inválida"

1. Verificar se a API Key está correta no 1Password
2. Verificar se a API Key não expirou
3. Gerar nova API Key em: https://aistudio.google.com/app/apikey

---

## 📚 Documentação Relacionada

- [Google Gemini API Documentation](https://ai.google.dev/docs)
- [Google Generative AI Python SDK](https://github.com/google/generative-ai-python)
- [1Password CLI Documentation](https://developer.1password.com/docs/cli)

---

## ✅ Checklist de Validação

- [ ] 1Password CLI instalado e autenticado
- [ ] Gemini API Key cadastrada no 1Password
- [ ] Script executado com sucesso
- [ ] Variáveis de ambiente carregadas (`source ~/.zshrc` ou `source ~/.bashrc`)
- [ ] API Key testada e funcionando
- [ ] Python SDK instalado (macOS)
- [ ] Gemini CLI instalado (macOS, opcional)

---

**Última Atualização:** 2025-12-01  
**Versão:** 1.0.0  
**Status:** ✅ **SCRIPT PRONTO PARA USO**
