# Guia Rápido - Context Engineering

## 🚀 Setup em 1 Minuto

### macOS
```bash
cd ~/Dotfiles/context-engineering/scripts && ./setup-macos.sh
```

### VPS Ubuntu
```bash
cd ~/Dotfiles/context-engineering/scripts && ./setup-vps.sh
```

### Codespace
Setup automático via `.devcontainer/` ou manualmente:
```bash
cd ~/Dotfiles/context-engineering/scripts && ./setup-codespace.sh
```

## 💡 Snippets Mais Usados

### 1Password
- `1p-get` → Obter item do 1Password
- `1p-pass` → Obter senha
- `1p-signin` → Login automático
- `1p-check` → Verificar configuração

### Python
- `py-template` → Template completo de script
- `py-func` → Função com docstring
- `py-class` → Classe Python

### Shell
- `sh-template` → Template completo de script
- `sh-colors` → Definir cores
- `sh-log` → Funções de logging

## 📝 Como Usar

1. **Digite o prefixo** do snippet (ex: `1p-get`)
2. **Pressione Tab** ou Enter
3. **Preencha os placeholders** (${1}, ${2}, etc.)

## 🎯 Cursor Rules

O arquivo `.cursorrules` é lido automaticamente pelo Cursor no diretório do projeto ou em `~/.cursorrules` para configuração global.

## 🔧 Troubleshooting Rápido

**Snippets não aparecem?**
→ Execute o script de setup novamente e recarregue o editor

**Cursor Rules não funcionam?**
→ Verifique se `.cursorrules` está no diretório raiz do projeto

**Raycast snippets?**
→ Configure manualmente via UI usando os arquivos JSON como referência

## 📚 Mais Informações

Veja `README.md` para documentação completa.

