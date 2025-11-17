# Claude Code - Setup e Configuração

## 📋 Visão Geral

Claude Code é uma ferramenta CLI da Anthropic que permite trabalhar com Claude diretamente do terminal. Este documento descreve como configurar o Claude Code usando a `ANTHROPIC_API_KEY` armazenada no 1Password.

## ✅ Status da Instalação

- ✅ **Claude Code instalado**: `@anthropic-ai/claude-code` via npm
- ✅ **Versão**: v2.0.33
- ✅ **ANTHROPIC_API_KEY**: Configurada via 1Password (ID: `ce5jhu6mivh4g63lzfxlj3r2cu`)
- ✅ **Yolo Mode**: Ativo (auto-aprovação de tool requests)

**📝 Nota**: Yolo Mode aprova automaticamente todas as solicitações de ferramentas.
Consulte `CLAUDE_CODE_YOLO_MODE.md` para detalhes de segurança.

## 🔑 Configuração da ANTHROPIC_API_KEY no 1Password

### Verificar se a chave existe

A chave deve estar armazenada em um dos vaults:
- **1p_macos** (ID: `gkpsbgizlks2zknwzqpppnb2ze`)
- **1p_vps** (ID: `oa3tidekmeu26nxiier2qbi7v4`)

### Nomes possíveis do item no 1Password

O script tenta encontrar o item com estes nomes:
- `ANTHROPIC_API_KEY`
- `Anthropic API Key`
- `anthropic_api_key`

### Como adicionar/verificar no 1Password

1. **Abra o 1Password**
2. **Acesse o vault apropriado** (1p_macos ou 1p_vps)
3. **Procure por um item** com um dos nomes acima
4. **Ou crie um novo item** do tipo "Password" ou "Secure Note"
5. **Certifique-se** que o campo "password" ou "notesPlain" contém a API key

### Obter a chave manualmente

```bash
# Verificar se está autenticado no 1Password
op whoami

# Se não estiver autenticado, fazer login
op signin

# Obter pelo ID conhecido (método recomendado)
op item get "ce5jhu6mivh4g63lzfxlj3r2cu" --vault "1p_macos" --fields "credential" --reveal

# Ou pelo nome do item
op item get "Anthropic-API" --vault "1p_macos" --fields "credential" --reveal

# Tentar obter a chave (teste diferentes nomes)
op item get "ANTHROPIC_API_KEY" --vault "1p_macos" --fields "password" --reveal
op item get "Anthropic API Key" --vault "1p_macos" --fields "password" --reveal
op item get "anthropic_api_key" --vault "1p_macos" --fields "password" --reveal

# Listar todos os items no vault para encontrar o nome correto
op item list --vault "1p_macos" | grep -i anthropic
```

## 🚀 Script de Setup

### Executar o script

```bash
cd ~/Dotfiles/context-engineering
./scripts/claude-code-setup.sh
```

### O que o script faz

1. ✅ Verifica se Claude Code está instalado
2. ✅ Instala se necessário (requer Node.js 18+)
3. 🔑 Tenta obter `ANTHROPIC_API_KEY` do 1Password
4. ✅ Configura variável de ambiente no shell
5. ✅ Adiciona configuração automática ao `.zshrc` ou `.bashrc`
6. ✅ Verifica instalação com `claude doctor`

### Configuração Automática no Shell

O script adiciona ao seu `.zshrc` ou `.bashrc`:

```bash
# Claude Code - ANTHROPIC_API_KEY do 1Password
# Obter automaticamente do 1Password
if command -v op &> /dev/null && [ -f "$HOME/.config/op/op_config.sh" ]; then
    source "$HOME/.config/op/op_config.sh"
    export ANTHROPIC_API_KEY=$(op item get "ANTHROPIC_API_KEY" --vault "1p_macos" --fields "password" 2>/dev/null || \
                     op item get "ANTHROPIC_API_KEY" --vault "1p_vps" --fields "password" 2>/dev/null || \
                     echo "")
fi
```

## 📝 Uso Manual

### Configurar ANTHROPIC_API_KEY manualmente

```bash
# Opção 1: Obter do 1Password pelo ID conhecido (recomendado)
export ANTHROPIC_API_KEY=$(op item get "ce5jhu6mivh4g63lzfxlj3r2cu" --vault "1p_macos" --fields "credential" --reveal)

# Opção 2: Obter pelo nome do item
export ANTHROPIC_API_KEY=$(op item get "Anthropic-API" --vault "1p_macos" --fields "credential" --reveal)

# Opção 3: Definir diretamente (não recomendado, mas útil para testes)
export ANTHROPIC_API_KEY="sua-chave-aqui"

# Opção 4: Adicionar ao .zshrc/.bashrc
echo 'export ANTHROPIC_API_KEY=$(op item get "ce5jhu6mivh4g63lzfxlj3r2cu" --vault "1p_macos" --fields "credential" --reveal)' >> ~/.zshrc
```

### Verificar configuração

```bash
# Verificar se a variável está configurada
echo $ANTHROPIC_API_KEY

# Executar claude doctor
claude doctor

# Iniciar Claude Code
claude
```

## 🔍 Troubleshooting

### Problema: ANTHROPIC_API_KEY não encontrada

**Solução:**
1. Verifique se está autenticado no 1Password: `op whoami`
2. Liste os items no vault: `op item list --vault "1p_macos"`
3. Verifique o nome exato do item
4. Ajuste o script se necessário

### Problema: Claude Code não encontrado

**Solução:**
```bash
# Reinstalar
npm install -g @anthropic-ai/claude-code

# Verificar PATH
echo $PATH | grep -i node
npm config get prefix

# Adicionar ao PATH se necessário
export PATH="$(npm config get prefix)/bin:$PATH"
```

### Problema: Erro de autenticação

**Solução:**
```bash
# Fazer login no 1Password primeiro
op signin

# Depois executar o script novamente
./scripts/claude-code-setup.sh
```

### Problema: Node.js versão antiga

**Solução:**
```bash
# Verificar versão
node --version

# Atualizar Node.js (macOS com Homebrew)
brew upgrade node

# Ou usar nvm
nvm install 18
nvm use 18
```

## 📚 Referências

- [Claude Code Documentation](https://docs.anthropic.com/claude/docs/claude-code)
- [Claude Messages API](CLAUDE_MESSAGES_API.md) - Documentação completa da API
- [Claude Code Yolo Mode](CLAUDE_CODE_YOLO_MODE.md) - Segurança e uso do Yolo Mode
- [Claude Code Login](CLAUDE_CODE_LOGIN.md) - Guia de login
- [Anthropic Console](https://console.anthropic.com/)
- [1Password CLI Documentation](https://developer.1password.com/docs/cli)

## 🔗 Documentação Relacionada

- **API Messages**: Ver `CLAUDE_MESSAGES_API.md` para documentação completa da API
- **Item 1Password**: `Anthropic-API` (ID: `ce5jhu6mivh4g63lzfxlj3r2cu`)
- **Vaults**: `1p_macos` (ID: `gkpsbgizlks2zknwzqpppnb2ze`) ou `1p_vps` (ID: `oa3tidekmeu26nxiier2qbi7v4`)

## ✅ Checklist de Configuração

- [ ] Node.js 18+ instalado
- [ ] Claude Code instalado (`npm install -g @anthropic-ai/claude-code`)
- [ ] 1Password CLI instalado e autenticado
- [ ] `ANTHROPIC_API_KEY` adicionada ao vault 1p_macos ou 1p_vps
- [ ] Script de setup executado com sucesso
- [ ] Variável de ambiente configurada no shell
- [ ] `claude doctor` executado sem erros
- [ ] Claude Code funcionando (`claude`)

---

**Última atualização**: 2025-01-15
**Status**: Claude Code instalado, aguardando configuração da API key no 1Password

