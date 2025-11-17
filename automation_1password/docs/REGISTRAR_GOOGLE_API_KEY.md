# Registrar GOOGLE_API_KEY no 1Password

**Data:** 2025-11-17
**Padrão:** SERVICE_TYPE_ENV

---

## 📋 Informações do Item

- **Nome:** `GOOGLE_API_KEY`
- **Categoria:** API Credential
- **Vault:** 1p_macos
- **Tags:**
  - `environment:macos`
  - `service:google`
  - `type:credentials`
  - `status:active`
  - `project:gemini`

---

## 🚀 Como Registrar

### Opção 1: Script Automatizado (Recomendado)

```bash
# 1. Autenticar no 1Password
op signin

# 2. Executar script (lê automaticamente do arquivo)
./vaults-1password/scripts/registrar-google-api-key.sh

# Ou testar primeiro (dry-run)
./vaults-1password/scripts/registrar-google-api-key.sh --dry-run
```

### Opção 2: Manual via CLI

```bash
# 1. Autenticar
op signin

# 2. Criar item
op item create \
  --category "API Credential" \
  --title "GOOGLE_API_KEY" \
  --vault "1p_macos" \
  "credential[concealed]=AIzaSyDiRpx1Mv1yiXGoPPT5EE4xWC-5enUdGYg" \
  --tag "environment:macos" \
  --tag "service:google" \
  --tag "type:credentials" \
  --tag "status:active" \
  --tag "project:gemini"
```

---

## 📝 Usar a Chave Após Registrar

### No Terminal (Sessão Atual)

```bash
export GOOGLE_API_KEY=$(op read "op://1p_macos/GOOGLE_API_KEY/credential")
```

### No .zshrc (Carregamento Automático)

```bash
# Adicionar ao final do ~/.zshrc
echo '' >> ~/.zshrc
echo '# Carrega GOOGLE_API_KEY do 1Password' >> ~/.zshrc
echo 'export GOOGLE_API_KEY=$(op read "op://1p_macos/GOOGLE_API_KEY/credential" 2>/dev/null || echo "")' >> ~/.zshrc

# Recarregar
source ~/.zshrc
```

### Verificar

```bash
echo $GOOGLE_API_KEY
```

---

## ✅ Validação

### Verificar Item Criado

```bash
# Listar item
op item get "GOOGLE_API_KEY" --vault "1p_macos"

# Verificar tags
op item get "GOOGLE_API_KEY" --vault "1p_macos" --fields tags
```

### Testar Chave

```bash
# Carregar chave
export GOOGLE_API_KEY=$(op read "op://1p_macos/GOOGLE_API_KEY/credential")

# Testar com curl (exemplo)
curl -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"Hello"}]}]}' \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${GOOGLE_API_KEY}"
```

---

## 🔒 Segurança

- ✅ Chave armazenada de forma segura no 1Password
- ✅ Não commitar chave em repositórios
- ✅ Usar variável de ambiente ao invés de hardcode
- ✅ Rotacionar chave periodicamente
- ✅ Usar tags para organização

---

## 📚 Referências

- [Padrões de Nomenclatura](../standards/nomenclature.md)
- [Mapeamento de Categorias](../standards/categories.md)
- [Sistema de Tags](../standards/tags.md)

---

**Última atualização:** 2025-11-17
