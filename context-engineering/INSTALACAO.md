# Guia de Instalação Completo

## 📋 Pré-requisitos

### macOS
- macOS 12+ (Silicon ou Intel)
- Homebrew instalado
- Zsh como shell padrão
- VSCode ou Cursor instalado
- Raycast instalado (opcional, mas recomendado)

### VPS Ubuntu
- Ubuntu 20.04+
- Bash ou Zsh
- Acesso SSH configurado
- VSCode Remote SSH (opcional)

### Codespaces
- Conta GitHub
- Acesso a Codespaces
- VSCode instalado (para desenvolvimento local)

## 🚀 Instalação Passo a Passo

### macOS Silicon

1. **Clonar ou verificar dotfiles:**
```bash
cd ~
git clone <seu-repo-dotfiles> Dotfiles || cd Dotfiles
```

2. **Executar setup:**
```bash
cd ~/Dotfiles/context-engineering/scripts
./setup-macos.sh
```

3. **Recarregar shell:**
```bash
source ~/.zshrc
```

4. **Recarregar VSCode/Cursor:**
- Feche e reabra o editor completamente

5. **Configurar Raycast (opcional):**
- Abra Raycast
- Vá em Settings → Extensions → Snippets
- Importe snippets de `~/Dotfiles/raycast/snippets/`

### VPS Ubuntu

1. **Conectar via SSH:**
```bash
ssh user@vps-ip
```

2. **Clonar dotfiles:**
```bash
cd ~
git clone <seu-repo-dotfiles> Dotfiles || cd Dotfiles
```

3. **Executar setup:**
```bash
cd ~/Dotfiles/context-engineering/scripts
chmod +x setup-vps.sh
./setup-vps.sh
```

4. **Recarregar shell:**
```bash
source ~/.bashrc  # ou source ~/.zshrc
```

5. **Configurar VSCode Remote (opcional):**
- Instale extensão "Remote - SSH"
- Conecte ao servidor
- Snippets serão instalados automaticamente

### GitHub Codespaces

1. **Criar novo Codespace:**
- Vá para seu repositório no GitHub
- Clique em "Code" → "Codespaces" → "Create codespace"

2. **Configurar dotfiles:**
- O Codespace pode clonar dotfiles automaticamente se configurado
- Ou clone manualmente:
```bash
cd ~
git clone <seu-repo-dotfiles> Dotfiles
```

3. **Executar setup:**
```bash
cd ~/Dotfiles/context-engineering/scripts
./setup-codespace.sh
```

4. **Recarregar VSCode:**
- O Codespace recarrega automaticamente após setup

## ✅ Verificação

### Verificar Snippets

No VSCode/Cursor:
1. Abra qualquer arquivo
2. Digite `1p-get` e pressione Tab
3. Deve expandir para o snippet completo

### Verificar Cursor Rules

1. Abra um projeto no Cursor
2. O Cursor deve ler `.cursorrules` automaticamente
3. Verifique se as regras estão sendo aplicadas nas respostas

### Verificar 1Password

```bash
op-config-check
```

Deve mostrar:
- ✅ Autenticação
- ✅ Configuração CLI
- ✅ Vault padrão
- ✅ Vaults disponíveis

## 🔧 Troubleshooting

### Snippets não aparecem

1. Verifique localização:
```bash
# macOS
ls -la ~/Library/Application\ Support/Code/User/snippets/
ls -la ~/Library/Application\ Support/Cursor/User/snippets/

# VPS
ls -la ~/.vscode-server/data/User/snippets/
```

2. Execute setup novamente:
```bash
./setup-macos.sh  # ou setup-vps.sh
```

3. Recarregue editor completamente

### Cursor Rules não funcionam

1. Verifique se arquivo existe:
```bash
ls -la ~/.cursorrules
# ou no projeto
ls -la .cursorrules
```

2. Copie manualmente se necessário:
```bash
cp ~/Dotfiles/context-engineering/.cursorrules ~/.cursorrules
```

### Raycast não encontra snippets

1. Configure manualmente via UI
2. Use arquivos JSON como referência:
```bash
cat ~/Dotfiles/raycast/snippets/1password.json
```

### Extensões não instaladas

1. Instale manualmente:
```bash
code --install-extension 1password.op-vscode
code --install-extension ms-python.python
# etc...
```

2. Ou importe lista de extensões:
```bash
cat ~/Dotfiles/vscode/extensions.json
```

## 🔄 Atualização

Para atualizar configurações:

```bash
cd ~/Dotfiles
git pull
cd context-engineering/scripts
./setup-macos.sh  # ou setup-vps.sh ou setup-codespace.sh
```

## 📚 Próximos Passos

Após instalação:

1. Leia `README.md` para visão geral
2. Consulte `GUIA_RAPIDO.md` para uso diário
3. Explore snippets disponíveis
4. Personalize conforme necessário

## 🆘 Suporte

Se encontrar problemas:

1. Verifique logs de erro
2. Execute `op-config-check` para 1Password
3. Verifique permissões de arquivos
4. Consulte `README.md` para troubleshooting detalhado



