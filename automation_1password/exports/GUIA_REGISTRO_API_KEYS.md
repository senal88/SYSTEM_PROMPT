# 🔐 Guia: Registro de API Keys no 1Password

**Ambiente:** Híbrido (VPS + macOS Silicon)  
**Foco:** DevOps - sem inventar mudanças desnecessárias

---

## 📋 Processo

### 1. Arquivo Fonte

Arquivo: `add-1password-vps-macos.md`

Contém:
- OPENAI_API_KEY
- ANTHROPIC_API_KEY  
- HF_TOKEN
- PERPLEXITY_API_KEY
- CURSOR_API_KEY

### 2. Script de Registro

**Script:** `scripts/secrets/register-and-validate-api-keys.sh`

**Funcionalidades:**
- ✅ Extrai tokens do arquivo
- ✅ Registra nos vaults `1p_macos` e `1p_vps`
- ✅ Valida registro
- ✅ Remove arquivo fonte após validação

---

## 🔧 Execução (Duas Opções)

### Opção A: Via 1Password Connect (Se funcional)

```bash
# Verificar Connect
docker compose -f connect/docker-compose.yml ps

# Se healthy, executar
./scripts/secrets/register-and-validate-api-keys.sh
```

### Opção B: Via 1Password CLI Direto (Recomendado)

```bash
# Desabilitar Connect temporariamente
unset OP_CONNECT_HOST OP_CONNECT_TOKEN

# Autenticar
op signin --account senamfo

# Executar script
./scripts/secrets/register-and-validate-api-keys.sh

# Reativar Connect após (se necessário)
export OP_CONNECT_HOST="http://localhost:8080"
export OP_CONNECT_TOKEN="seu-token"
```

---

## ✅ Validação

Após execução, o script:
1. ✅ Registra em `1p_macos`
2. ✅ Registra em `1p_vps`
3. ✅ Valida que items foram criados
4. ✅ Remove `add-1password-vps-macos.md`

---

## ⚠️ Notas Importantes

- **Vaults:** Script procura `1p_macos` e `1p_vps`
- **Se Connect não funciona:** Use CLI direto (Opção B)
- **Arquivo removido apenas após validação completa**
- **Mantém foco DevOps híbrido** - não altera estruturas existentes

---

## 🎯 Resultado Esperado

Items criados em ambos vaults:
- `OpenAI-API` (campo: credential)
- `Anthropic-API` (campo: credential)
- `HuggingFace-Token` (campo: credential)
- `Perplexity-API` (campo: credential)
- `Cursor-API` (campo: credential)

Arquivo fonte removido após sucesso.

---

**Status:** Script pronto. Execute conforme ambiente disponível.

