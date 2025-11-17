# Exemplo: Adicionar Servidor MCP HTTP

## 📋 Dados do Servidor

- **Nome**: `my-server`
- **Tipo**: HTTP
- **URL**: `https://example.com/mcp`
- **Headers**:
  - `Authorization=Bearer token`
  - `X-API-Key=key`

## 🚀 Comando para Adicionar

```bash
cd ~/Dotfiles/context-engineering
./scripts/add-mcp-server.sh "my-server" "https://example.com/mcp" "Bearer token" "key"
```

## 🔐 Usando 1Password (Recomendado)

Se você quiser armazenar os tokens no 1Password:

```bash
# 1. Obter tokens do 1Password
TOKEN=$(op item get "mcp-auth-token" --vault "1p_macos" --fields "credential" --reveal)
API_KEY=$(op item get "mcp-api-key" --vault "1p_macos" --fields "credential" --reveal)

# 2. Adicionar servidor
./scripts/add-mcp-server.sh "my-server" "https://example.com/mcp" "Bearer $TOKEN" "$API_KEY"
```

## ✅ Resultado Esperado

O arquivo `~/Library/Application Support/Claude/claude_desktop_config.json` será atualizado com:

```json
{
  "preferences": {
    "quickEntryShortcut": "double-tap-option"
  },
  "mcpServers": {
    "my-server": {
      "type": "http",
      "url": "https://example.com/mcp",
      "headers": {
        "Authorization": "Bearer token",
        "X-API-Key": "key"
      }
    }
  }
}
```

## 🔄 Próximos Passos

1. Execute o script com seus dados reais
2. Reinicie o Claude Desktop
3. Verifique se o servidor aparece nas configurações
4. Teste usando o servidor MCP no Claude

## 📚 Documentação Completa

Consulte `MCP_HTTP_SERVER_CONFIG.md` para documentação completa.

