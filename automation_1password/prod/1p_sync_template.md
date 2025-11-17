# Template: Sincronização 1Password 1p_macos → 1p_vps

## Items para Sincronizar

### API Keys
- [ ] OpenAI-API
- [ ] Anthropic-API
- [ ] HuggingFace-Token
- [ ] Perplexity-API
- [ ] Cursor-API

### Databases
- [ ] PostgreSQL (se necessário)
- [ ] MongoDB (se necessário)
- [ ] Redis (se necessário)

### Application Secrets
- [ ] n8n Encryption Key
- [ ] n8n JWT Secret
- [ ] Traefik Email (se usar SSL)

---

## Método de Sincronização

### Opção 1: Manual (Recomendado para primeira vez)
1. Abrir 1Password app no macOS
2. Copiar items de `1p_macos`
3. Criar items em `1p_vps` manualmente
4. Validar na VPS

### Opção 2: Via CLI (Se tiver acesso aos dois vaults)
```bash
# Exportar item
op item get "Item-Name" --vault 1p_macos --format json > item.json

# Importar em outro vault
op item create --vault 1p_vps < item.json
```

---

## Validação na VPS

Após sincronizar, validar na VPS:
```bash
ssh vps
op vault get 1p_vps
op item list --vault 1p_vps
```

