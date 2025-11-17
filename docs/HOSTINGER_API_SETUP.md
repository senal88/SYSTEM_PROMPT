# 🚀 Hostinger API - Configuração Completa

**Versão**: 1.0.0
**Última Atualização**: 2025-01-17
**API Key**: `jkBoNklZ2vnWHquuZRjbR09CxmqPfXNOqabkEnJvc06e0665`

---

## 📋 Visão Geral

Este documento descreve a configuração completa da integração com a Hostinger API para gerenciamento de VPS, incluindo:

- Configuração de credenciais no 1Password
- Configuração de MCP Servers (Claude e Cursor)
- Scripts de shell padronizados
- Comandos Raycast CLI
- Documentação da API

---

## 🔐 Credenciais

### 1Password

**Item**: `API-VPS-HOSTINGER`
**Vault**: `1p_macos` ou `Personal`
**Campo**: `credential` (concealed)

**Atualizar credencial**:

```bash
cd ~/10_INFRAESTRUTURA_VPS
./scripts/update-1password-hostinger-api.sh
```

**Ler credencial**:

```bash
op read "op://1p_macos/API-VPS-HOSTINGER/credential"
# ou
op read "op://Personal/API-VPS-HOSTINGER/credential"
```

### Variável de Ambiente

```bash
export HOSTINGER_API_TOKEN=$(op read "op://1p_macos/API-VPS-HOSTINGER/credential")
```

---

## 🤖 MCP Servers

### Cursor

**Arquivo**: `~/Dotfiles/configs/mcp-servers.json`

```json
{
  "mcpServers": {
    "hostinger-mcp": {
      "command": "npx",
      "args": ["-y", "hostinger-api-mcp@latest"],
      "env": {
        "API_TOKEN": "${HOSTINGER_API_TOKEN}"
      }
    }
  }
}
```

**Arquivo específico**: `~/Dotfiles/configs/mcp/cursor-mcp-servers.json`

### Claude

**Arquivo**: `~/Dotfiles/configs/mcp/claude-mcp-servers.json`

```json
{
  "inputs": [
    {
      "id": "api_token",
      "type": "promptString",
      "description": "Insira seu token de API da Hostinger (obrigatório)"
    }
  ],
  "servers": {
    "hostinger-mcp": {
      "type": "stdio",
      "command": "npx",
      "args": ["hostinger-api-mcp@latest"],
      "env": {
        "API_TOKEN": "jkBoNklZ2vnWHquuZRjbR09CxmqPfXNOqabkEnJvc06e0665"
      }
    }
  }
}
```

---

## 🐚 Configuração de Shell

### macOS (Zsh)

**Arquivo**: `~/Dotfiles/scripts/shell/zshrc-macos.sh`

**Carregar no `.zshrc`**:

```bash
source ~/Dotfiles/scripts/shell/zshrc-macos.sh
```

**Funções disponíveis**:

- `sync_credentials` - Sincronizar credenciais do 1Password
- `test_hostinger_api` - Testar conexão com a API

### Ubuntu VPS (Bash)

**Arquivo**: `~/Dotfiles/scripts/shell/bashrc-ubuntu.sh`

**Carregar no `.bashrc`**:

```bash
source ~/Dotfiles/scripts/shell/bashrc-ubuntu.sh
```

**Funções disponíveis**:

- `sync_credentials` - Sincronizar credenciais (se 1Password disponível)
- `test_hostinger_api` - Testar conexão com a API

---

## ⌨️ Raycast CLI

**Script**: `~/Dotfiles/scripts/raycast/hostinger-api.sh`

### Comandos Disponíveis

```bash
# Listar VMs
~/Dotfiles/scripts/raycast/hostinger-api.sh list

# Detalhes de uma VM
~/Dotfiles/scripts/raycast/hostinger-api.sh details <vm_id>

# Iniciar VM
~/Dotfiles/scripts/raycast/hostinger-api.sh start <vm_id>

# Parar VM
~/Dotfiles/scripts/raycast/hostinger-api.sh stop <vm_id>

# Reiniciar VM
~/Dotfiles/scripts/raycast/hostinger-api.sh restart <vm_id>

# Listar backups
~/Dotfiles/scripts/raycast/hostinger-api.sh backups <vm_id>

# Listar snapshots
~/Dotfiles/scripts/raycast/hostinger-api.sh snapshots <vm_id>

# Obter métricas
~/Dotfiles/scripts/raycast/hostinger-api.sh metrics <vm_id> [date_from] [date_to]

# Listar firewalls
~/Dotfiles/scripts/raycast/hostinger-api.sh firewalls

# Listar chaves SSH
~/Dotfiles/scripts/raycast/hostinger-api.sh ssh-keys

# Testar conexão
~/Dotfiles/scripts/raycast/hostinger-api.sh test
```

### Configurar no Raycast

1. Abrir Raycast
2. Criar novo Script Command
3. Configurar:
   - **Script**: `~/Dotfiles/scripts/raycast/hostinger-api.sh`
   - **Arguments**: `list` (ou outro comando)
   - **Title**: `Hostinger: List VMs`

---

## 🌐 API Reference

### Base URL

```
https://developers.hostinger.com/api
```

### Autenticação

```bash
curl -X GET "https://developers.hostinger.com/api/vps/v1/virtual-machines" \
  -H "Authorization: Bearer ${HOSTINGER_API_TOKEN}" \
  -H "Content-Type: application/json"
```

### Endpoints Principais

#### Virtual Machines

- `GET /vps/v1/virtual-machines` - Listar VMs
- `GET /vps/v1/virtual-machines/{vm_id}` - Detalhes de uma VM
- `POST /vps/v1/virtual-machines/{vm_id}/start` - Iniciar VM
- `POST /vps/v1/virtual-machines/{vm_id}/stop` - Parar VM
- `POST /vps/v1/virtual-machines/{vm_id}/restart` - Reiniciar VM

#### Backups

- `GET /vps/v1/virtual-machines/{vm_id}/backups` - Listar backups
- `POST /vps/v1/virtual-machines/{vm_id}/backups/{backup_id}/restore` - Restaurar backup

#### Snapshots

- `GET /vps/v1/virtual-machines/{vm_id}/snapshot` - Listar snapshots
- `POST /vps/v1/virtual-machines/{vm_id}/snapshot` - Criar snapshot
- `POST /vps/v1/virtual-machines/{vm_id}/snapshot/restore` - Restaurar snapshot

#### Firewalls

- `GET /vps/v1/firewall` - Listar firewalls
- `POST /vps/v1/firewall` - Criar firewall
- `POST /vps/v1/firewall/{firewall_id}/activate/{vm_id}` - Ativar firewall

#### SSH Keys

- `GET /vps/v1/public-keys` - Listar chaves SSH
- `POST /vps/v1/public-keys` - Criar chave SSH
- `POST /vps/v1/public-keys/attach/{vm_id}` - Anexar chave a VM

### Documentação Completa

- **API Reference**: https://developers.hostinger.com/
- **GitHub MCP Server**: https://github.com/hostinger/api-mcp-server
- **Postman Collection**: https://www.postman.com/hostinger-api

---

## 🔄 Sincronização

### macOS → VPS

```bash
# No macOS
cd ~/Dotfiles
./scripts/sync/sync-global-configs.sh vps
```

### VPS → macOS

```bash
# No VPS
cd ~/Dotfiles
./scripts/sync/sync-global-configs.sh macos
```

---

## ✅ Verificação

### Testar API

```bash
# Usando função do shell
test_hostinger_api

# Usando script Raycast
~/Dotfiles/scripts/raycast/hostinger-api.sh test

# Usando curl diretamente
curl -X GET "https://developers.hostinger.com/api/vps/v1/virtual-machines" \
  -H "Authorization: Bearer ${HOSTINGER_API_TOKEN}" \
  -H "Content-Type: application/json"
```

### Verificar Configurações

```bash
# Verificar MCP configs
cat ~/Dotfiles/configs/mcp-servers.json | jq '.mcpServers.hostinger-mcp'

# Verificar credencial no 1Password
op read "op://1p_macos/API-VPS-HOSTINGER/credential"

# Verificar variável de ambiente
echo $HOSTINGER_API_TOKEN
```

---

## 📚 Referências

- **Hostinger API Docs**: `/Users/luiz.sena88/VAULT_OBSIDIAN/Clippings/Hostinger API Reference.md`
- **API JSON Spec**: `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/framework/api-1.json`
- **API YAML Spec**: `/Users/luiz.sena88/10_INFRAESTRUTURA_VPS/framework/api-1.yaml`

---

## 🔧 Troubleshooting

### Erro: "API_TOKEN não configurado"

**Solução**:

1. Verificar se 1Password está autenticado: `op whoami`
2. Verificar se o item existe: `op item list --vault 1p_macos | grep API-VPS-HOSTINGER`
3. Sincronizar credenciais: `sync_credentials`

### Erro: "401 Unauthorized"

**Solução**:

1. Verificar se a API key está correta
2. Atualizar no 1Password: `./scripts/update-1password-hostinger-api.sh`
3. Recarregar variável de ambiente: `source ~/.zshrc` ou `source ~/.bashrc`

### Erro: "429 Too Many Requests"

**Solução**:

- Aguardar alguns minutos antes de fazer novas requisições
- Implementar rate limiting nos scripts

---

**Última atualização**: 2025-01-17
