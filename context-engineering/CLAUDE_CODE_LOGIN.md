# Claude Code - Guia de Login e Autenticação

## 🔐 Métodos de Autenticação

O Claude Code suporta três métodos de autenticação:

### 1. Console Anthropic (Recomendado para APIs)

- Conecta-se através do Console Anthropic
- Requer conta com faturamento ativo no [console.anthropic.com](https://console.anthropic.com/)
- Processo OAuth completo
- **Melhor para**: Desenvolvimento com API

### 2. Aplicativo Claude (Plano Pro ou Max)

- Assine o plano Pro ou Max do Claude
- Acesso unificado que inclui Claude Code e interface web
- Login com conta Claude.ai
- **Melhor para**: Uso integrado com Claude Desktop

### 3. Plataformas Empresariais

- Amazon Bedrock
- Google Vertex AI
- Para implantações empresariais com infraestrutura de nuvem existente

## 🚀 Login Rápido com API Key

### Método 1: Variável de Ambiente

```bash
# Obter API key do 1Password e exportar
export ANTHROPIC_API_KEY=$(op item get "ce5jhu6mivh4g63lzfxlj3r2cu" --vault "1p_macos" --fields "credential" --reveal)

# Iniciar Claude Code
claude
```

### Método 2: Arquivo de Configuração

```bash
# Criar diretório de configuração se não existir
mkdir -p ~/.config/claude-code

# Criar arquivo de configuração
cat > ~/.config/claude-code/config.json << EOF
{
  "api_key": "$(op item get "ce5jhu6mivh4g63lzfxlj3r2cu" --vault "1p_macos" --fields "credential" --reveal)"
}
EOF
```

### Método 3: Login Interativo

```bash
# Iniciar Claude Code
claude

# Durante a inicialização, escolha:
# 1. Console Anthropic
# 2. Claude App (Pro/Max)
# 3. Platform (Bedrock/Vertex AI)

# Se escolher Console Anthropic:
# - Será redirecionado para navegador
# - Complete o processo OAuth
# - Retorne ao terminal
```

## ✅ Verificar Autenticação

```bash
# Verificar se está autenticado
claude whoami

# Ou verificar variável de ambiente
echo $ANTHROPIC_API_KEY | head -c 20

# Testar API
claude doctor
```

## 🔧 Configuração Automática

### Adicionar ao Shell Config

O script `claude-code-setup.sh` já configura automaticamente:

```bash
# Executar setup
./scripts/claude-code-setup.sh

# Recarregar shell
source ~/.zshrc  # ou ~/.bashrc
```

### Verificar Configuração

```bash
# Verificar se API key está configurada
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "✅ ANTHROPIC_API_KEY configurada"
    echo "   (${#ANTHROPIC_API_KEY} caracteres)"
else
    echo "❌ ANTHROPIC_API_KEY não configurada"
    echo "   Execute: source ~/.zshrc"
fi
```

## 📝 Próximos Passos após Login

1. **Verificar instalação:**
   ```bash
   claude doctor
   ```

2. **Testar comunicação:**
   ```bash
   claude --help
   ```

3. **Configurar preferências:**
   - O Claude Code salvará suas preferências automaticamente
   - Configurações em: `~/.config/claude-code/`

## 🐛 Troubleshooting

### Problema: "API key not found"

**Solução:**
```bash
# Verificar se está autenticado no 1Password
op whoami

# Tentar obter API key novamente
export ANTHROPIC_API_KEY=$(op item get "ce5jhu6mivh4g63lzfxlj3r2cu" --vault "1p_macos" --fields "credential" --reveal)

# Verificar se obteve a chave
echo "${ANTHROPIC_API_KEY:0:20}..."
```

### Problema: "Authentication failed"

**Solução:**
1. Verificar se a API key está correta
2. Verificar se a conta tem faturamento ativo
3. Tentar login interativo novamente

### Problema: "Command not found: claude"

**Solução:**
```bash
# Verificar se está instalado
npm list -g @anthropic-ai/claude-code

# Verificar PATH
echo $PATH | grep -i node

# Adicionar ao PATH se necessário
export PATH="$(npm config get prefix)/bin:$PATH"
```

## 📚 Referências

- [Claude Code Documentation](https://docs.anthropic.com/claude/docs/claude-code)
- [Getting Started Guide](https://docs.anthropic.com/en/docs/claude-code/getting-started)
- [Console Anthropic](https://console.anthropic.com/)
- [Security Guide](https://docs.claude.com/s/claude-code-security)

---

**Item 1Password**: Anthropic-API (ID: `ce5jhu6mivh4g63lzfxlj3r2cu`)
**Vault**: 1p_macos (ID: `gkpsbgizlks2zknwzqpppnb2ze`)

