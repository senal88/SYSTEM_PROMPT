# Raycast + 1Password - Integração Completa

**Last Updated**: 2025-10-31  
**Versão**: 2.1.0

---

## 🎯 Visão Geral

Integração completa do **Raycast** com **1Password CLI** para produtividade máxima no macOS Silicon.

**Benefícios**:
- ✅ CMD+Space substitui Spotlight
- ✅ Busca rápida de senhas do 1Password
- ✅ Geração de senhas seguras instantaneamente
- ✅ Workflows personalizados
- ✅ Extensões de produtividade

---

## 🚀 Instalação Completa

### Setup Automatizado (Recomendado)

```bash
cd ~/Dotfiles/automation_1password
make raycast.setup
```

Este comando:
1. Instala Raycast
2. Configura 1Password CLI
3. Desabilita Spotlight CMD+Space
4. Instala extensão 1Password
5. Cria scripts personalizados
6. Configura aliases úteis

---

## ⌨️ Comandos Disponíveis

### Aliases Principais

```bash
ray                 # Abrir Raycast
ray-pass           # Buscar senhas
ray-gen            # Gerar senha segura

# Funções
ray-get <item>     # Copiar senha específica
ray-new <item>     # Criar novo item 1Password
```

### Atalhos Globais

| Atalho | Ação |
|--------|------|
| `CMD+Space` | Abrir Raycast |
| `CMD+P` (no Raycast) | Buscar senhas 1Password |
| `CMD+G` (no Raycast) | Gerar senha |

---

## 🔌 Extensões Instaladas

1. **1Password** - Busca e geração de senhas
2. **Clipboard History** - Histórico de clipboard
3. **Calculator** - Calculadora rápida
4. **Color Picker** - Seleção de cores
5. **GitHub** - Gestão repositórios (se configurado)
6. **Docker** - Gestão containers (se configurado)

---

## 📝 Scripts Personalizados

### Get Password
```bash
# Busca e copia senha de um item
ray-get "database-production"

# Via Raycast UI:
# CMD+Space → digite "1password" → selecione item
```

### Generate Secure Password
```bash
# Gera senha de 32 caracteres
ray-gen

# Via Raycast UI:
# CMD+Space → digite "generate password"
```

### List Items by Category
```bash
# Lista todos os logins
raycast://extensions/khasbilegt/1password/search-items?category=Login

# No Raycast UI:
# CMD+P → digite → filtre por categoria
```

---

## 🔐 Configuração 1Password

### Vaults Configurados

```json
{
  "cliPath": "/opt/homebrew/bin/op",
  "vaults": [
    "1p_macos",
    "1p_vps", 
    "default importado",
    "Personal"
  ]
}
```

### Adicionar Novos Vaults

Edite: `~/.config/raycast/1password/config.json`

---

## 🎨 Personalização

### Tema

```bash
# Aplicar tema escuro
defaults write com.raycast.macos "theme" -string "dark"

# Reiniciar Raycast
killall Raycast && open -a Raycast
```

### Atalhos Customizados

Edite: `~/.config/raycast/shortcuts.json`

---

## 🔧 Troubleshooting

### Raycast não abre com CMD+Space

```bash
# Verificar configuração
defaults read com.apple.symbolichotkeys AppleSymbolicHotKeys

# Re-configurar
make raycast.setup
```

### 1Password extension não aparece

```bash
# Reinstalar extensão
open "raycast://extensions/khasbilegt/1password"

# Verificar CLI
op --version

# Verificar autenticação
op whoami
```

### Aliases não funcionam

```bash
# Recarregar shell
source ~/.zshrc

# Verificar aliases
which ray
alias ray
```

---

## 📊 Estatísticas de Uso

Visualizar estatísticas:

```bash
raycast://extensions/khasbilegt/1password
# No Raycast → Analytics
```

---

## 🎯 Próximos Passos

### Otimizações Avançadas

1. **Workflows Personalizados**
   - Criar scripts em `~/.config/raycast/scripts/`
   - Documentação: [Raycast API Docs](https://developers.raycast.com)

2. **Extensões Adicionais**
   - Window Management
   - Port Manager
   - System Preferences
   - Emoji & Symbols

3. **Integração com Projetos**
   - Deploy com secrets automáticos
   - Backup rotativo de vaults
   - Sincronização cross-device

---

## 📚 Referências

- [Raycast Docs](https://manual.raycast.com)
- [1Password CLI](https://developer.1password.com/docs/cli)
- [Raycast Extensions](https://raycast.com/store)
- [Community Scripts](https://github.com/raycast/script-commands)

---

**Última atualização**: 2025-10-31  
**Versão**: 2.1.0

