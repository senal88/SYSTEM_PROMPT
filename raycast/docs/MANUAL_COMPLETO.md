# 📋 MANUAL COMPLETO - Raycast + 1Password

## 🎯 **O QUE VOCÊ DEVE FAZER MANUALMENTE**

### 🔐 **1. CONFIGURAÇÃO 1PASSWORD CLI**

#### Passo 1: Abrir 1Password App
```bash
# Abrir o 1Password app
open -a "1Password"
```

#### Passo 2: Habilitar Integração CLI
1. **No 1Password app:**
   - Vá em `1Password` → `Settings` (ou `Preferences`)
   - Clique em `Developer`
   - Marque `Integrate with 1Password CLI`
   - Confirme a integração

#### Passo 3: Fazer Signin no Terminal
```bash
# Executar signin
op signin

# Seguir as instruções na tela:
# 1. Escolher sua conta
# 2. Inserir senha mestra
# 3. Confirmar autenticação
```

#### Passo 4: Testar 1Password CLI
```bash
# Testar se funcionou
op item list

# Deve mostrar lista de itens
# Se funcionar, você verá algo como:
# [UUID] Item Name
# [UUID] Another Item
```

### 🚀 **2. CONFIGURAÇÃO RAYCAST**

#### Passo 1: Abrir Raycast
```bash
# Abrir Raycast
open -a "Raycast"

# Ou pressionar ⌘ Space
```

#### Passo 2: Conceder Permissões
**Quando o Raycast abrir, ele pedirá permissões:**

1. **Acessibilidade:**
   - Vá em `System Preferences` → `Security & Privacy` → `Privacy`
   - Selecione `Accessibility`
   - Clique no `+` e adicione `Raycast`
   - Marque a caixa ao lado do Raycast

2. **Automação:**
   - Na mesma tela, selecione `Automation`
   - Adicione `Raycast` se necessário
   - Marque as permissões necessárias

3. **Full Disk Access:**
   - Selecione `Full Disk Access`
   - Adicione `Raycast`
   - Marque a caixa

#### Passo 3: Configurar Atalho
**O atalho ⌘ Space já deve estar configurado, mas verifique:**

1. **No Raycast:**
   - Vá em `Raycast` → `Preferences`
   - Clique em `General`
   - Verifique se `Hotkey` está como `⌘ Space`

2. **Se não estiver:**
   - Clique em `Hotkey`
   - Pressione `⌘ Space`
   - Confirme

### 🔧 **3. TESTAR SCRIPTS DO RAYCAST**

#### Passo 1: Verificar Scripts
```bash
# Verificar se os scripts foram criados
ls -la ~/Library/Application\ Support/com.raycast.macos/script-commands/

# Deve mostrar:
# development/
# security/
```

#### Passo 2: Testar Scripts
**No Raycast (⌘ Space):**

1. **Digite:** `git status`
   - Deve aparecer o script "Git Status"
   - Execute para ver status do Git

2. **Digite:** `docker ps`
   - Deve aparecer o script "Docker PS"
   - Execute para ver containers Docker

3. **Digite:** `test 1password`
   - Deve aparecer o script "Test 1Password"
   - Execute para testar 1Password CLI

### 🔗 **4. CONFIGURAR QUICKLINKS**

#### Passo 1: Testar Quicklinks
**No Raycast (⌘ Space):**

1. **Digite:** `ghi`
   - Deve aparecer "GitHub Issues"
   - Execute e digite uma busca

2. **Digite:** `tr`
   - Deve aparecer "Google Translate"
   - Execute e digite texto para traduzir

### 📝 **5. CONFIGURAR SNIPPETS**

#### Passo 1: Testar Snippets
**No Raycast (⌘ Space):**

1. **Digite:** `sig`
   - Deve expandir para:
   ```
   Atenciosamente,
   Luiz Sena
   Desenvolvedor Full Stack
   ```

### 🆕 **6. SUBSTITUIR SPOTLIGHT (OPCIONAL)**

#### Passo 1: Executar Substituição
```bash
# Navegar para o diretório
cd ~/Dotfiles/raycast-automation

# Executar substituição
./replace-spotlight.sh
```

#### Passo 2: Verificar Substituição
```bash
# Verificar se funcionou
./verify-spotlight-replacement.sh
```

#### Passo 3: Testar Atalho
- **Pressione ⌘ Space**
- **Deve abrir Raycast (não Spotlight)**

### 🧪 **7. TESTAR INSTALAÇÃO COMPLETA**

#### Passo 1: Executar Teste
```bash
# Navegar para o diretório
cd ~/Dotfiles/raycast-automation

# Executar teste completo
./test-installation.sh
```

#### Passo 2: Verificar Status
```bash
# Ver status geral
./raycast-manager.sh status
```

### 💾 **8. TESTAR SISTEMA DE BACKUP**

#### Passo 1: Fazer Backup
```bash
# Fazer backup completo
./raycast-manager.sh backup
```

#### Passo 2: Testar Restore
```bash
# Testar restore (cuidado!)
./raycast-manager.sh restore
```

#### Passo 3: Testar Sincronização
```bash
# Testar sincronização
./raycast-manager.sh sync
```

## 🚨 **PROBLEMAS COMUNS E SOLUÇÕES**

### ❌ **1Password CLI não funciona**

**Problema:** `No accounts configured for use with 1Password CLI`

**Solução:**
1. Abra o 1Password app
2. Vá em `1Password` → `Settings` → `Developer`
3. Marque `Integrate with 1Password CLI`
4. Execute `op signin` no terminal
5. Siga as instruções

### ❌ **Raycast não abre com ⌘ Space**

**Problema:** Atalho não funciona

**Solução:**
1. Abra Raycast manualmente
2. Vá em `Raycast` → `Preferences` → `General`
3. Configure `Hotkey` como `⌘ Space`
4. Reinicie o Raycast

### ❌ **Scripts não aparecem no Raycast**

**Problema:** Scripts não são reconhecidos

**Solução:**
1. Verifique se os scripts existem:
   ```bash
   ls -la ~/Library/Application\ Support/com.raycast.macos/script-commands/
   ```
2. Verifique permissões:
   ```bash
   chmod +x ~/Library/Application\ Support/com.raycast.macos/script-commands/*/*.sh
   ```
3. Reinicie o Raycast

### ❌ **Permissões negadas**

**Problema:** Raycast não tem permissões

**Solução:**
1. Vá em `System Preferences` → `Security & Privacy` → `Privacy`
2. Adicione Raycast em:
   - `Accessibility`
   - `Automation`
   - `Full Disk Access`
3. Marque todas as caixas
4. Reinicie o Raycast

## ✅ **CHECKLIST FINAL**

### 🔐 **1Password CLI**
- [ ] 1Password app aberto
- [ ] Integração CLI habilitada
- [ ] `op signin` executado
- [ ] `op item list` funciona
- [ ] Script "Test 1Password" funciona

### 🚀 **Raycast**
- [ ] Raycast instalado
- [ ] Atalho ⌘ Space configurado
- [ ] Permissões concedidas
- [ ] Scripts aparecem na busca
- [ ] Quicklinks funcionam
- [ ] Snippets funcionam

### 💾 **Sistema de Backup**
- [ ] Backup funciona
- [ ] Restore funciona
- [ ] Sincronização funciona
- [ ] Metadados criados

### 🧪 **Testes**
- [ ] `./test-installation.sh` passa
- [ ] `./raycast-manager.sh status` mostra tudo verde
- [ ] Todos os scripts executam sem erro

## 🎯 **COMANDOS FINAIS**

```bash
# Navegar para o diretório
cd ~/Dotfiles/raycast-automation

# Ver status geral
./raycast-manager.sh status

# Testar instalação
./test-installation.sh

# Fazer backup
./raycast-manager.sh backup

# Ver ajuda
./raycast-manager.sh help
```

## 🎉 **RESULTADO ESPERADO**

**Após seguir este manual:**
- ✅ 1Password CLI funcionando
- ✅ Raycast configurado e funcionando
- ✅ Scripts, Quicklinks e Snippets funcionando
- ✅ Sistema de backup funcionando
- ✅ Todos os testes passando

**SISTEMA COMPLETO E FUNCIONAL! 🚀**
