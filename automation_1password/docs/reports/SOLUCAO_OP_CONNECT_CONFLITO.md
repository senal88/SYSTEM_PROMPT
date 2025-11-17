# 🔧 Solução: Conflito 1Password Connect + CLI

**Data**: 2025-10-31  
**Problema**: `[ERROR] "op item create" doesn't work with Connect`

---

## 🎯 CAUSA RAIZ

O comando `op item create` e outros comandos de escrita **NÃO funcionam com 1Password Connect**.

1Password Connect é um serviço **read-only** via REST API.  
1Password CLI normal precisa de autenticação biométrica/Touch ID.

---

## ✅ SOLUÇÃO DEFINITIVA

### Opção 1: Desabilitar Connect Temporariamente (Recomendado)

```bash
# Verificar se Connect está ativo
env | grep OP_CONNECT

# Se estiver ativo, desabilitar temporariamente
unset OP_CONNECT_HOST
unset OP_CONNECT_TOKEN

# Agora funcionará!
op signin
op item create --vault 1p_macos --category password --title Traefik email=luizfernandomoreirasena@gmail.com
```

### Opção 2: Criar Alias Permanente

Adicionar ao `~/.zshrc`:

```bash
# Desabilitar Connect quando usar CLI
alias op-cli='unset OP_CONNECT_HOST OP_CONNECT_TOKEN; op'
```

Uso:
```bash
op-cli signin
op-cli item create ...
```

### Opção 3: Dois Ambientes Separados

```bash
# Para Connect (read-only via API)
alias op-connect='op'

# Para CLI (read-write com Touch ID)
alias op-cli='unset OP_CONNECT_HOST OP_CONNECT_TOKEN; op'
```

---

## 🚀 USAR NOS SCRIPTS

### Modificar `op_login.sh`:

```bash
#!/bin/bash
set -euo pipefail

# Desabilitar Connect antes de usar CLI
unset OP_CONNECT_HOST OP_CONNECT_TOKEN

# Agora funciona
op signin
op whoami
```

### Modificar Makefile targets:

```makefile
op.login:
	@echo "Autenticando no 1Password CLI..."
	@unset OP_CONNECT_HOST OP_CONNECT_TOKEN; $(REPO)/scripts/secrets/op_login.sh
	@echo "✅ Autenticação concluída"

op.item.create:
	@if [ -z "$(VAULT)" ] || [ -z "$(TITLE)" ]; then \
		echo "❌ Erro: VAULT e TITLE são obrigatórios"; \
		exit 1; \
	fi
	@unset OP_CONNECT_HOST OP_CONNECT_TOKEN; op item create --vault $(VAULT) --title $(TITLE)
```

---

## 📋 GUIA RÁPIDO

### Para Criar Items Agora:

```bash
# 1. Desabilitar Connect
unset OP_CONNECT_HOST OP_CONNECT_TOKEN

# 2. Autenticar
op signin

# 3. Criar items
op item create --vault 1p_macos --category password --title Traefik email=luizfernandomoreirasena@gmail.com

# 4. Verificar
op item list --vault 1p_macos
```

---

## 🔐 PERMANÊNCIA DA SOLUÇÃO

### Adicionar ao ~/.zshrc:

```bash
# Fix 1Password CLI/Connect Conflict
function op-cli() {
  unset OP_CONNECT_HOST OP_CONNECT_TOKEN
  op "$@"
}

# Criar alias para conveniência
alias opc='op-cli'
```

Depois:
```bash
source ~/.zshrc
opc signin
opc item create ...
```

---

## ⚠️ IMPORTANTE

- **Connect**: Use para **READ-ONLY** (apps, scripts de leitura)
- **CLI**: Use para **READ-WRITE** (criar, editar, deletar items)
- **Nunca** use os dois ao mesmo tempo

---

## ✅ TESTE AGORA

Execute no terminal Cursor:

```bash
# Desabilitar Connect
unset OP_CONNECT_HOST OP_CONNECT_TOKEN

# Testar
op whoami

# Criar item
op item create --vault 1p_macos --category password --title Traefik email=luizfernandomoreirasena@gmail.com
```

**Deve funcionar perfeitamente!** ✅

---

**Status**: ✅ Solução definitiva  
**Última atualização**: 2025-10-31

