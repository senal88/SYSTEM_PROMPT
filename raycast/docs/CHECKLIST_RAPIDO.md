# ✅ CHECKLIST RÁPIDO - Raycast + 1Password

## 🔐 **1PASSWORD CLI (5 minutos)**

### Passo 1: Abrir 1Password App
```bash
open -a "1Password"
```

### Passo 2: Habilitar Integração CLI
1. **1Password app** → `Settings` → `Developer`
2. **Marcar:** `Integrate with 1Password CLI`
3. **Confirmar** integração

### Passo 3: Signin no Terminal
```bash
op signin
# Seguir instruções na tela
```

### Passo 4: Testar
```bash
op item list
# Deve mostrar lista de itens
```

## 🚀 **RAYCAST (3 minutos)**

### Passo 1: Abrir Raycast
```bash
open -a "Raycast"
# Ou pressionar ⌘ Space
```

### Passo 2: Conceder Permissões
**System Preferences** → `Security & Privacy` → `Privacy`:
- **Accessibility:** Adicionar Raycast ✅
- **Automation:** Adicionar Raycast ✅  
- **Full Disk Access:** Adicionar Raycast ✅

### Passo 3: Verificar Atalho
**Raycast** → `Preferences` → `General`:
- **Hotkey:** `⌘ Space` ✅

## 🧪 **TESTAR SCRIPTS (2 minutos)**

### No Raycast (⌘ Space):
1. **Digite:** `git status` → Execute script
2. **Digite:** `docker ps` → Execute script  
3. **Digite:** `test 1password` → Execute script
4. **Digite:** `ghi` → Teste GitHub Issues
5. **Digite:** `tr` → Teste Google Translate
6. **Digite:** `sig` → Teste Email Signature

## 🧪 **TESTAR SISTEMA (1 minuto)**

```bash
cd ~/Dotfiles/raycast-automation

# Testar status
./raycast-manager.sh status

# Testar instalação
./test-installation.sh

# Fazer backup
./raycast-manager.sh backup
```

## ✅ **RESULTADO ESPERADO**

**Todos os testes devem passar:**
- ✅ 1Password CLI: `op item list` funciona
- ✅ Raycast: ⌘ Space abre Raycast
- ✅ Scripts: Aparecem na busca do Raycast
- ✅ Quicklinks: `ghi` e `tr` funcionam
- ✅ Snippets: `sig` expande texto
- ✅ Backup: Sistema funciona

## 🚨 **SE ALGO FALHAR**

### 1Password CLI não funciona:
```bash
# Reconfigurar
./setup-1password.sh
```

### Raycast não funciona:
```bash
# Reinstalar
./install.sh
```

### Scripts não aparecem:
```bash
# Recriar scripts
mkdir -p ~/Library/Application\ Support/com.raycast.macos/script-commands/{development,security}
# Copiar scripts do backup
```

## 🎯 **COMANDO FINAL**

```bash
cd ~/Dotfiles/raycast-automation && ./raycast-manager.sh status
```

**Deve mostrar tudo verde! 🚀**
