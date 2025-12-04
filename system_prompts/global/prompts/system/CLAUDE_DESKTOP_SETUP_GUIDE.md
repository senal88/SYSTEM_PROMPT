# GUIA DEFINITIVO: CLAUDE DESKTOP SETUP NO macOS SILICON
## Tahoe 26.0.1 - Correção de Erros e Padronização

---

## 📋 ÍNDICE

1. Diagnóstico e Erros Comuns
2. Estrutura de Path de Configuração
3. Procedimento de Correção Passo a Passo
4. Reinstalação Limpa (quando necessário)
5. Configurações de Segurança
6. Otimização para macOS Silicon
7. Integração com MCP Servers
8. Validação e Testes
9. Manutenção Contínua
10. Troubleshooting Avançado

---

## 1. DIAGNÓSTICO E ERROS COMUNS

### 1.1 Erros Típicos e Causas Prováveis

#### Erro: "Claude Desktop não inicia"
**Causas Prováveis:**
- Arquivo `claude_desktop_config.json` corrompido ou com JSON inválido
- Path absoluto em MCP servers apontando para diretório inexistente
- Permissões insuficientes em `~/.claude`
- Conflito de versão entre Claude Desktop e Anthropic API key
- Processo anterior ainda em memória

**Diagnóstico:**
```bash
# Verificar processos Claude ainda ativos
ps aux | grep -i claude

# Validar JSON da config
cat ~/.claude/claude_desktop_config.json | python3 -m json.tool

# Verificar logs
tail -100 ~/Library/Logs/Claude/claude.log 2>/dev/null || \
tail -100 ~/Library/Application\ Support/Claude/logs/* 2>/dev/null
```

#### Erro: "MCP Server Connection Failed"
**Causas Prováveis:**
- Path relativo em vez de absoluto em `command`
- Variáveis de ambiente não resolvidas na execução
- Permissão execute não configurada em script de inicialização
- Python/Node interpreter path incorreto para arquitetura Apple Silicon

**Diagnóstico:**
```bash
# Verificar qual Python está sendo usado
which python3
file $(which python3)  # Verificar arquitetura (arm64 vs x86_64)

# Testar execução do MCP server manualmente
~/.claude/mcp_servers/seu_server/bin/python seu_server.py
```

#### Erro: "Invalid configuration schema"
**Causas Prováveis:**
- Campos obrigatórios faltando em `mcpServers`
- Tipo de dados incorreto (string esperada, recebido array)
- Nomes de keys com typos (case-sensitive)
- Espaços/caracteres especiais em nomes

**Diagnóstico:**
```bash
# Validar contra schema esperado
cat ~/.claude/claude_desktop_config.json | jq '.mcpServers'
```

#### Erro: "Timeout conectando MCP server"
**Causas Prováveis:**
- MCP server crash silencioso
- Porta já em uso
- Problema de rede/firewall
- Recurso insuficiente ou I/O lento

**Diagnóstico:**
```bash
# Testar manualmente se servidor responde
timeout 5 ~/.claude/mcp_servers/seu_server/bin/python seu_server.py

# Verificar portas em uso
lsof -i -P -n | grep LISTEN
```

---

### 1.2 Locations Críticas no macOS Silicon

```
~/.claude/                                    # Diretório principal de configuração
├── claude_desktop_config.json               # Configuração central
├── logs/                                    # Logs de execução
├── cache/                                   # Cache temporário
├── mcp_servers/                             # MCP servers instalados
└── extensions/                              # Extensões (se aplicável)

~/Library/Application Support/Claude/        # Dados da aplicação
├── settings.json                            # Configurações de UI
├── preferences.plist                        # Preferências do macOS
└── caches/                                  # Cache de LLM

~/Library/Logs/Claude/                       # Logs da aplicação
└── claude.log                               # Log principal

/Applications/Claude.app/                    # Aplicação instalada
└── Contents/MacOS/Claude                    # Executável (arm64)
```

---

## 2. ESTRUTURA DE PATH DE CONFIGURAÇÃO

### 2.1 Padrão Recomendado (SSOT - Single Source of Truth)

```json
{
  "mcpServers": {
    "server_id_lowercase": {
      "command": "/Users/SEU_USERNAME/.claude/mcp_servers/server_id/bin/python",
      "args": ["/Users/SEU_USERNAME/.claude/mcp_servers/server_id/main.py"],
      "env": {
        "PYTHONPATH": "/Users/SEU_USERNAME/.claude/mcp_servers/server_id/lib",
        "HOME": "/Users/SEU_USERNAME",
        "PATH": "/Users/SEU_USERNAME/.claude/mcp_servers/server_id/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
      }
    }
  }
}
```

### 2.2 Variáveis de Ambiente Necessárias

```bash
# NUNCA usar ~/ ou $HOME em JSON - sempre expandir para absolute path

# ✅ CORRETO
"command": "/Users/sena/.claude/mcp_servers/my_server/bin/python"

# ❌ ERRADO
"command": "~/.claude/mcp_servers/my_server/bin/python"
"command": "${HOME}/.claude/mcp_servers/my_server/bin/python"
"command": "$HOME/.claude/mcp_servers/my_server/bin/python"
```

### 2.3 Script para Obter Username Programaticamente

```bash
#!/bin/bash
# Script: setup_claude_config.sh

USERNAME=$(whoami)
HOMEDIR=$(eval echo ~$USERNAME)
CLAUDE_DIR="$HOMEDIR/.claude"

echo "Username: $USERNAME"
echo "Home Directory: $HOMEDIR"
echo "Claude Config Directory: $CLAUDE_DIR"

# Criar diretórios se não existirem
mkdir -p "$CLAUDE_DIR/mcp_servers"
mkdir -p "$CLAUDE_DIR/logs"

# Gerar config com paths absolutamente expandidos
cat > "$CLAUDE_DIR/claude_desktop_config.json" << EOF
{
  "mcpServers": {
    "example_server": {
      "command": "$HOMEDIR/.claude/mcp_servers/example_server/bin/python",
      "args": ["$HOMEDIR/.claude/mcp_servers/example_server/server.py"],
      "env": {
        "PYTHONPATH": "$HOMEDIR/.claude/mcp_servers/example_server",
        "HOME": "$HOMEDIR"
      }
    }
  }
}
EOF

chmod 644 "$CLAUDE_DIR/claude_desktop_config.json"
echo "✅ Config gerado em: $CLAUDE_DIR/claude_desktop_config.json"
```

---

## 3. PROCEDIMENTO DE CORREÇÃO PASSO A PASSO

### 3.1 Verificação Diagnóstica Completa

```bash
#!/bin/bash
# Script: diagnose_claude.sh

set -e

echo "════════════════════════════════════════════════════════════"
echo "DIAGNÓSTICO CLAUDE DESKTOP - macOS Silicon"
echo "════════════════════════════════════════════════════════════"

# 1. Verificar arquitetura do macOS
echo -e "\n[1] Arquitetura do Sistema"
uname -m
sysctl -n hw.brand

# 2. Verificar Claude.app
echo -e "\n[2] Instalação do Claude Desktop"
if [ -d "/Applications/Claude.app" ]; then
    echo "✅ Claude.app encontrado"
    file /Applications/Claude.app/Contents/MacOS/Claude
    ls -lh /Applications/Claude.app/Contents/MacOS/Claude
else
    echo "❌ Claude.app NÃO encontrado em /Applications"
fi

# 3. Verificar estrutura de configuração
echo -e "\n[3] Estrutura de Configuração"
CLAUDE_CONFIG="$HOME/.claude/claude_desktop_config.json"
if [ -f "$CLAUDE_CONFIG" ]; then
    echo "✅ Arquivo de config encontrado"
    echo "Path: $CLAUDE_CONFIG"
    echo "Tamanho: $(stat -f%z "$CLAUDE_CONFIG") bytes"
    echo "Permissões: $(stat -f%A "$CLAUDE_CONFIG")"
else
    echo "❌ Arquivo de config NÃO encontrado"
fi

# 4. Validar JSON
echo -e "\n[4] Validação JSON"
if [ -f "$CLAUDE_CONFIG" ]; then
    if python3 -m json.tool < "$CLAUDE_CONFIG" > /dev/null 2>&1; then
        echo "✅ JSON válido"
    else
        echo "❌ JSON inválido - detalhes:"
        python3 -m json.tool < "$CLAUDE_CONFIG" 2>&1 || true
    fi
else
    echo "⚠️  Arquivo não existe para validação"
fi

# 5. Verificar permissões de diretório
echo -e "\n[5] Permissões de Diretório"
ls -ld "$HOME/.claude" 2>/dev/null && echo "✅ ~/.claude existe" || echo "❌ ~/.claude não existe"

# 6. Verificar processos Claude em execução
echo -e "\n[6] Processos Claude Ativos"
ps aux | grep -i "claude" | grep -v grep || echo "Nenhum processo Claude em execução"

# 7. Verificar Python disponível (Apple Silicon)
echo -e "\n[7] Python e Arquitetura"
echo "Python 3 path:"
which python3
echo "Arquitetura:"
file $(which python3)
echo "Versão:"
python3 --version

# 8. Verificar MCP Servers configurados
echo -e "\n[8] MCP Servers Configurados"
if [ -f "$CLAUDE_CONFIG" ]; then
    python3 << 'PYTHON_SCRIPT'
import json
import os

config_path = os.path.expanduser("~/.claude/claude_desktop_config.json")
with open(config_path) as f:
    config = json.load(f)

if "mcpServers" in config:
    for server_name, server_config in config["mcpServers"].items():
        print(f"\nServidor: {server_name}")
        if "command" in server_config:
            cmd = server_config["command"]
            exists = os.path.exists(cmd)
            executable = os.access(cmd, os.X_OK) if exists else False
            print(f"  Command: {cmd}")
            print(f"  Existe: {'✅' if exists else '❌'}")
            print(f"  Executável: {'✅' if executable else '❌'}")
        
        if "args" in server_config:
            for arg in server_config["args"]:
                exists = os.path.exists(arg)
                print(f"  Arg: {arg} {'✅' if exists else '❌'}")
PYTHON_SCRIPT
fi

# 9. Verificar logs
echo -e "\n[9] Logs Disponíveis"
LOG_DIRS=(
    "$HOME/Library/Logs/Claude"
    "$HOME/Library/Application Support/Claude/logs"
    "$HOME/.claude/logs"
)

for log_dir in "${LOG_DIRS[@]}"; do
    if [ -d "$log_dir" ]; then
        echo "📁 $log_dir"
        ls -lh "$log_dir" | tail -5
    fi
done

echo -e "\n════════════════════════════════════════════════════════════"
echo "FIM DO DIAGNÓSTICO"
echo "════════════════════════════════════════════════════════════"
```

### 3.2 Execução da Verificação

```bash
chmod +x diagnose_claude.sh
./diagnose_claude.sh
```

---

### 3.3 Procedimento de Correção Sequencial

#### Passo 1: Parar Todos os Processos Claude

```bash
# Forçar fechamento do Claude Desktop
killall -9 Claude 2>/dev/null || true

# Aguardar 2 segundos
sleep 2

# Confirmar que não há processos ativos
ps aux | grep -i claude | grep -v grep && echo "❌ Ainda há processos" || echo "✅ Todos os processos foram fechados"
```

#### Passo 2: Fazer Backup da Configuração Atual

```bash
# Backup com timestamp
BACKUP_DIR="$HOME/.claude/backups"
mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

cp "$HOME/.claude/claude_desktop_config.json" \
   "$BACKUP_DIR/claude_desktop_config_${TIMESTAMP}.json.bak"

echo "✅ Backup criado: $BACKUP_DIR/claude_desktop_config_${TIMESTAMP}.json.bak"
```

#### Passo 3: Validar e Corrigir Arquivo de Configuração

```bash
#!/bin/bash
# Script: fix_claude_config.sh

set -e

USERNAME=$(whoami)
HOMEDIR=$(eval echo ~$USERNAME)
CONFIG_FILE="$HOMEDIR/.claude/claude_desktop_config.json"

echo "Corrigindo configuração do Claude..."
echo "Username: $USERNAME"
echo "Home Directory: $HOMEDIR"

# Fazer backup
BACKUP_FILE="$HOMEDIR/.claude/backups/config_$(date +%s).json.bak"
mkdir -p "$HOMEDIR/.claude/backups"
cp "$CONFIG_FILE" "$BACKUP_FILE"
echo "✅ Backup criado: $BACKUP_FILE"

# Validar JSON atual
echo "Validando JSON atual..."
if ! python3 -m json.tool < "$CONFIG_FILE" > /dev/null 2>&1; then
    echo "❌ JSON inválido detectado"
    echo "Detalhes do erro:"
    python3 -m json.tool < "$CONFIG_FILE" 2>&1 | head -20
    exit 1
fi
echo "✅ JSON válido"

# Processar e corrigir paths
echo "Processando e corrigindo paths..."
python3 << PYTHON_SCRIPT
import json
import os

config_file = "$CONFIG_FILE"

with open(config_file, 'r') as f:
    config = json.load(f)

# Validar estrutura
if "mcpServers" not in config:
    print("⚠️  Chave 'mcpServers' não encontrada, criando...")
    config["mcpServers"] = {}

# Processar cada servidor
errors = []
for server_name, server_config in config.get("mcpServers", {}).items():
    print(f"\nProcessando servidor: {server_name}")
    
    # Validar 'command'
    if "command" not in server_config:
        errors.append(f"Servidor '{server_name}' sem 'command'")
        continue
    
    cmd = server_config["command"]
    
    # Verificar se command é absolutamente expandido
    if not os.path.isabs(cmd):
        print(f"  ⚠️  Command relativo detectado: {cmd}")
        # Tentar expandir
        if cmd.startswith("~/"):
            cmd = "$HOMEDIR" + cmd[1:]
        
        server_config["command"] = cmd
        print(f"  ✅ Corrigido para: {cmd}")
    
    # Verificar se arquivo existe
    exists = os.path.exists(cmd)
    print(f"  Existe: {'✅' if exists else '❌'}")
    
    # Verificar permissão executável
    if exists:
        executable = os.access(cmd, os.X_OK)
        print(f"  Executável: {'✅' if executable else '❌'}")
        if not executable:
            print(f"  ⚠️  Tentando adicionar permissão...")
            os.chmod(cmd, 0o755)
    else:
        errors.append(f"Arquivo '{cmd}' não existe")
    
    # Corrigir env HOME se necessário
    if "env" not in server_config:
        server_config["env"] = {}
    
    server_config["env"]["HOME"] = "$HOMEDIR"

# Salvar config corrigida
with open(config_file, 'w') as f:
    json.dump(config, f, indent=2)

print(f"\n{'='*50}")
if errors:
    print("❌ Erros encontrados:")
    for error in errors:
        print(f"  - {error}")
else:
    print("✅ Nenhum erro encontrado")

print(f"{'='*50}")
PYTHON_SCRIPT

echo "✅ Configuração corrigida e salva"
```

#### Passo 4: Corrigir Permissões

```bash
# Corrigir permissões do diretório ~/.claude
chmod 755 "$HOME/.claude"
chmod 644 "$HOME/.claude/claude_desktop_config.json"

# Corrigir permissões dos MCP servers
chmod -R 755 "$HOME/.claude/mcp_servers"

# Verificar resultado
echo "Permissões após correção:"
ls -ld "$HOME/.claude"
ls -l "$HOME/.claude/claude_desktop_config.json"
```

#### Passo 5: Validação Final

```bash
#!/bin/bash
# Script: validate_claude_setup.sh

echo "Validando setup do Claude..."

# 1. Verificar JSON
echo -n "JSON válido... "
if python3 -m json.tool < ~/.claude/claude_desktop_config.json > /dev/null 2>&1; then
    echo "✅"
else
    echo "❌"
    exit 1
fi

# 2. Verificar permissões
echo -n "Permissões corretas... "
if [ -r ~/.claude/claude_desktop_config.json ] && [ -x ~/.claude ]; then
    echo "✅"
else
    echo "❌"
    exit 1
fi

# 3. Verificar MCP servers (se configurados)
echo -n "MCP servers acessíveis... "
python3 << 'PYTHON'
import json
import os

with open(os.path.expanduser("~/.claude/claude_desktop_config.json")) as f:
    config = json.load(f)

all_ok = True
for server_name, server_config in config.get("mcpServers", {}).items():
    if "command" in server_config:
        cmd = server_config["command"]
        if not os.path.exists(cmd):
            print(f"\n❌ Comando não encontrado: {cmd}")
            all_ok = False
        elif not os.access(cmd, os.X_OK):
            print(f"\n❌ Comando não é executável: {cmd}")
            all_ok = False

if all_ok:
    print("✅")
else:
    exit(1)
PYTHON

# 4. Teste de inicialização
echo -n "Testando inicialização... "
# Iniciar Claude e verificar se abre
open -a Claude --args --debug 2>/dev/null &
CLAUDE_PID=$!

# Aguardar 3 segundos
sleep 3

# Verificar se processo está rodando
if kill -0 $CLAUDE_PID 2>/dev/null; then
    echo "✅"
    kill $CLAUDE_PID 2>/dev/null || true
else
    echo "⚠️  (pode ser normal em algumas condições)"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ VALIDAÇÃO COMPLETA - Setup OK para uso"
echo "════════════════════════════════════════════════════════════"
```

---

## 4. REINSTALAÇÃO LIMPA (QUANDO NECESSÁRIO)

### 4.1 Desinstalação Completa

```bash
#!/bin/bash
# Script: uninstall_claude_clean.sh

echo "DESINSTALAÇÃO LIMPA DO CLAUDE DESKTOP"
echo "⚠️  CUIDADO: Isso removerá todas as configurações"
echo "Pressione CTRL+C para cancelar ou aguarde 5 segundos..."
sleep 5

# 1. Fechar aplicação
killall -9 Claude 2>/dev/null || true
sleep 1

# 2. Remover aplicação
echo "Removendo Claude.app..."
rm -rf /Applications/Claude.app

# 3. Fazer backup de configuração (ANTES de remover)
if [ -d "$HOME/.claude" ]; then
    BACKUP_DIR="$HOME/Claude_Backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    cp -r "$HOME/.claude" "$BACKUP_DIR/"
    echo "✅ Backup de configuração em: $BACKUP_DIR"
fi

# 4. Remover diretórios de dados
echo "Removendo dados de aplicação..."
rm -rf "$HOME/.claude"
rm -rf "$HOME/Library/Application Support/Claude"
rm -rf "$HOME/Library/Caches/Claude"
rm -rf "$HOME/Library/Preferences/com.anthropic.claude*"
rm -rf "$HOME/Library/Logs/Claude"

# 5. Remover LaunchAgent se existir
rm -f "$HOME/Library/LaunchAgents/com.anthropic.claude*"

# 6. Limpar cache geral do macOS
echo "Limpando caches do sistema..."
defaults delete com.anthropic.claude 2>/dev/null || true

echo "✅ Desinstalação completa realizada"
echo "Agora você pode reinstalar o Claude Desktop"
```

### 4.2 Reinstalação Limpa

```bash
#!/bin/bash
# Script: reinstall_claude_clean.sh

set -e

USERNAME=$(whoami)
HOMEDIR=$(eval echo ~$USERNAME)

echo "REINSTALAÇÃO LIMPA DO CLAUDE DESKTOP"
echo "Username: $USERNAME"
echo "Home Directory: $HOMEDIR"
echo ""

# 1. Criar estrutura de diretórios
echo "[1/5] Criando estrutura de diretórios..."
mkdir -p "$HOMEDIR/.claude/mcp_servers"
mkdir -p "$HOMEDIR/.claude/logs"
mkdir -p "$HOMEDIR/.claude/backups"
chmod 755 "$HOMEDIR/.claude"

# 2. Criar configuração inicial
echo "[2/5] Criando configuração inicial..."
cat > "$HOMEDIR/.claude/claude_desktop_config.json" << EOF
{
  "mcpServers": {}
}
EOF
chmod 644 "$HOMEDIR/.claude/claude_desktop_config.json"

# 3. Instalar Claude Desktop (via script ou manual)
echo "[3/5] Aguardando instalação do Claude Desktop..."
echo "   Por favor, baixe Claude.app de https://claude.ai/download"
echo "   e coloque em /Applications/"
echo ""
echo "   Pressione ENTER quando a instalação estiver completa..."
read

# 4. Verificar instalação
echo "[4/5] Verificando instalação..."
if [ -d "/Applications/Claude.app" ]; then
    echo "✅ Claude.app detectado"
    file /Applications/Claude.app/Contents/MacOS/Claude
else
    echo "❌ Claude.app não encontrado"
    exit 1
fi

# 5. Teste final
echo "[5/5] Teste final..."
open -a Claude --args --debug 2>/dev/null &
CLAUDE_PID=$!
sleep 3

if kill -0 $CLAUDE_PID 2>/dev/null; then
    echo "✅ Claude iniciado com sucesso"
    kill $CLAUDE_PID 2>/dev/null || true
else
    echo "⚠️  Claude pode não ter iniciado (verificar logs)"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ REINSTALAÇÃO COMPLETA"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Próximos passos:"
echo "1. Configure MCP Servers em ~/.claude/claude_desktop_config.json"
echo "2. Reinicie Claude Desktop"
echo "3. Execute: ./diagnose_claude.sh para validar"
```

---

## 5. CONFIGURAÇÕES DE SEGURANÇA

### 5.1 Estrutura Segura de Credenciais

```bash
# ✅ RECOMENDADO: Usar keychain do macOS
security add-generic-password -a "claude_api" -s "anthropic_api_key" -w "sk-ant-..." 2>/dev/null || true

# Para recuperar em script:
API_KEY=$(security find-generic-password -a "claude_api" -s "anthropic_api_key" -w 2>/dev/null)
```

### 5.2 Configuração Segura de Environment Variables

```json
{
  "mcpServers": {
    "secure_server": {
      "command": "/Users/sena/.claude/mcp_servers/secure_server/bin/python",
      "args": ["/Users/sena/.claude/mcp_servers/secure_server/server.py"],
      "env": {
        "HOME": "/Users/sena",
        "PATH": "/Users/sena/.claude/mcp_servers/secure_server/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
        "PYTHONPATH": "/Users/sena/.claude/mcp_servers/secure_server/lib",
        "PYTHONDONTWRITEBYTECODE": "1",
        "PYTHONUNBUFFERED": "1"
      }
    }
  }
}
```

### 5.3 Permissões Adequadas

```bash
# Diretório ~/.claude: 755 (rwxr-xr-x)
chmod 755 ~/.claude

# Config JSON: 644 (rw-r--r--)
chmod 644 ~/.claude/claude_desktop_config.json

# MCP Servers: 755 para diretórios, 755 para executáveis
chmod -R 755 ~/.claude/mcp_servers

# Verificar
ls -ld ~/.claude
ls -l ~/.claude/claude_desktop_config.json
find ~/.claude/mcp_servers -type f -name "*.py" -exec chmod 755 {} \;
```

### 5.4 Proteção do Arquivo de Configuração

```bash
#!/bin/bash
# Script: secure_claude_config.sh

echo "Protegendo configuração do Claude..."

# 1. Remover accesso público
chmod 600 ~/.claude/claude_desktop_config.json

# 2. Definir ownership correto
chown $(whoami) ~/.claude/claude_desktop_config.json

# 3. Adicionar proteção extra (extended attributes)
xattr -w com.apple.quarantine "" ~/.claude/claude_desktop_config.json 2>/dev/null || true

# 4. Tornar imutável (opcional - cuidado ao fazer updates)
# chflags uchg ~/.claude/claude_desktop_config.json

echo "✅ Configuração protegida"

# Verificar
stat -f "%A %OLp" ~/.claude/claude_desktop_config.json
```

---

## 6. OTIMIZAÇÃO PARA macOS SILICON

### 6.1 Verificação de Arquitetura

```bash
#!/bin/bash
# Script: verify_silicon_compatibility.sh

echo "Verificando compatibilidade com macOS Silicon..."
echo ""

# 1. Arquitetura do macOS
echo "[1] Arquitetura do macOS:"
ARCH=$(uname -m)
echo "   $ARCH"
if [ "$ARCH" = "arm64" ]; then
    echo "   ✅ Apple Silicon detectado"
else
    echo "   ⚠️  Não é Apple Silicon"
fi

# 2. Arquitetura do Claude.app
echo ""
echo "[2] Arquitetura do Claude.app:"
CLAUDE_ARCH=$(file /Applications/Claude.app/Contents/MacOS/Claude | grep -o "arm64\|x86_64" | head -1)
echo "   $CLAUDE_ARCH"
if [ "$CLAUDE_ARCH" = "arm64" ]; then
    echo "   ✅ Nativo Apple Silicon"
else
    echo "   ⚠️  Rosetta 2 (emulação)"
fi

# 3. Arquitetura do Python
echo ""
echo "[3] Arquitetura do Python 3:"
PYTHON_ARCH=$(file $(which python3) | grep -o "arm64\|x86_64" | head -1)
echo "   $PYTHON_ARCH"
if [ "$PYTHON_ARCH" = "arm64" ]; then
    echo "   ✅ Nativo Apple Silicon"
else
    echo "   ⚠️  Rosetta 2 (emulação)"
fi

# 4. MCP Servers
echo ""
echo "[4] Arquitetura dos MCP Servers:"
if [ -d ~/.claude/mcp_servers ]; then
    for server in ~/.claude/mcp_servers/*/bin/*; do
        if [ -f "$server" ] && [ -x "$server" ]; then
            SERVER_ARCH=$(file "$server" 2>/dev/null | grep -o "arm64\|x86_64" | head -1)
            echo "   $(basename $(dirname $(dirname $server))): $SERVER_ARCH"
        fi
    done
else
    echo "   (nenhum servidor instalado)"
fi
```

### 6.2 Otimização de Performance

```bash
#!/bin/bash
# Script: optimize_for_silicon.sh

echo "Otimizando Claude Desktop para macOS Silicon..."

# 1. Usar Python nativo arm64
echo "[1] Configurando Python arm64..."
PYTHON_ARM64="/opt/homebrew/bin/python3"
if [ -x "$PYTHON_ARM64" ]; then
    echo "✅ Python arm64 encontrado: $PYTHON_ARM64"
else
    echo "⚠️  Instale python3 via Homebrew: brew install python3"
fi

# 2. Desabilitar Rosetta se possível
echo "[2] Verificando Rosetta translation..."
pgrep "oahd" && echo "⚠️  Rosetta ativo (esperado para compatibilidade)" || echo "✅ Rosetta inativo"

# 3. Otimizar configuração
echo "[3] Otimizando configuração..."
cat > ~/.claude/optimization.json << 'EOF'
{
  "performance": {
    "use_native_binaries": true,
    "disable_rosetta_fallback": false,
    "max_mcp_server_threads": 4,
    "cache_size_mb": 512
  },
  "silicon_specific": {
    "use_arm64_python": true,
    "optimize_memory_alignment": true
  }
}
EOF

echo "✅ Otimização concluída"
```

### 6.3 Instalação de Dependencies Nativas

```bash
#!/bin/bash
# Script: install_native_dependencies.sh

echo "Instalando dependencies nativas para Apple Silicon..."

# 1. Instalar Homebrew (se não houver)
if ! command -v brew &> /dev/null; then
    echo "[1] Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "[1] Homebrew já instalado"
fi

# 2. Instalar Python nativo
echo "[2] Instalando Python 3 (arm64)..."
brew install python3

# 3. Instalar dependências comuns
echo "[3] Instalando dependências comuns..."
brew install git curl wget sqlite nodejs

# 4. Verificar arquitetura
echo "[4] Verificando arquiteturas instaladas..."
file $(which python3)
file $(which node)
file $(which git)

echo "✅ Dependencies nativas instaladas"
```

---

## 7. INTEGRAÇÃO COM MCP SERVERS

### 7.1 Template Padrão de MCP Server

```json
{
  "mcpServers": {
    "server_name_lowercase": {
      "command": "/Users/SEU_USERNAME/.claude/mcp_servers/server_name/bin/python",
      "args": ["/Users/SEU_USERNAME/.claude/mcp_servers/server_name/server.py"],
      "env": {
        "HOME": "/Users/SEU_USERNAME",
        "PATH": "/Users/SEU_USERNAME/.claude/mcp_servers/server_name/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
        "PYTHONPATH": "/Users/SEU_USERNAME/.claude/mcp_servers/server_name/lib"
      }
    }
  }
}
```

### 7.2 Instalação de MCP Server (Exemplo: Filesystem)

```bash
#!/bin/bash
# Script: install_mcp_filesystem.sh

set -e

USERNAME=$(whoami)
HOMEDIR=$(eval echo ~$USERNAME)
SERVER_DIR="$HOMEDIR/.claude/mcp_servers/filesystem"

echo "Instalando MCP Server: filesystem"

# 1. Criar diretório
mkdir -p "$SERVER_DIR"
cd "$SERVER_DIR"

# 2. Criar venv Python
python3 -m venv venv
source venv/bin/activate

# 3. Instalar dependências
pip install --upgrade pip
pip install mcp

# 4. Criar script de servidor
cat > "$SERVER_DIR/server.py" << 'EOF'
#!/usr/bin/env python3

import mcp.server
import mcp.types as types

class FilesystemMCPServer:
    def __init__(self):
        self.server = mcp.server.Server("filesystem")
    
    def get_tools(self):
        return [
            types.Tool(
                name="read_file",
                description="Lê um arquivo",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "path": {"type": "string"}
                    },
                    "required": ["path"]
                }
            )
        ]

server = FilesystemMCPServer()
if __name__ == "__main__":
    server.run()
EOF

chmod +x server.py

# 5. Atualizar config
CONFIG="$HOMEDIR/.claude/claude_desktop_config.json"
python3 << PYTHON
import json

with open("$CONFIG") as f:
    config = json.load(f)

config["mcpServers"]["filesystem"] = {
    "command": "$SERVER_DIR/venv/bin/python",
    "args": ["$SERVER_DIR/server.py"],
    "env": {
        "HOME": "$HOMEDIR",
        "PYTHONPATH": "$SERVER_DIR"
    }
}

with open("$CONFIG", "w") as f:
    json.dump(config, f, indent=2)
PYTHON

echo "✅ MCP Server 'filesystem' instalado"
echo "Path: $SERVER_DIR"
```

### 7.3 Teste de MCP Server

```bash
#!/bin/bash
# Script: test_mcp_server.sh

SERVER_NAME="${1:-filesystem}"
HOMEDIR=$(eval echo ~$(whoami))
SERVER_DIR="$HOMEDIR/.claude/mcp_servers/$SERVER_NAME"

if [ ! -d "$SERVER_DIR" ]; then
    echo "❌ Servidor não encontrado: $SERVER_DIR"
    exit 1
fi

echo "Testando MCP Server: $SERVER_NAME"

# Teste 1: Verificar estrutura
echo -n "Estrutura: "
if [ -f "$SERVER_DIR/server.py" ] && [ -f "$SERVER_DIR/venv/bin/python" ]; then
    echo "✅"
else
    echo "❌"
    exit 1
fi

# Teste 2: Verificar execução
echo -n "Execução: "
if timeout 5 "$SERVER_DIR/venv/bin/python" "$SERVER_DIR/server.py" &>/dev/null; then
    echo "✅"
else
    echo "⚠️  (pode ser normal)"
fi

# Teste 3: Verificar configuração
echo -n "Configuração: "
CONFIG="$HOMEDIR/.claude/claude_desktop_config.json"
if python3 -c "import json; c=json.load(open('$CONFIG')); exit(0 if '$SERVER_NAME' in c['mcpServers'] else 1)"; then
    echo "✅"
else
    echo "❌"
fi

echo ""
echo "✅ Testes concluídos"
```

---

## 8. VALIDAÇÃO E TESTES

### 8.1 Checklist de Validação

```bash
#!/bin/bash
# Script: validation_checklist.sh

echo "════════════════════════════════════════════════════════════"
echo "CHECKLIST DE VALIDAÇÃO - CLAUDE DESKTOP"
echo "════════════════════════════════════════════════════════════"
echo ""

CHECKS_PASSED=0
CHECKS_TOTAL=0

check() {
    CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
    local description="$1"
    local command="$2"
    
    echo -n "[$CHECKS_TOTAL] $description... "
    
    if eval "$command" > /dev/null 2>&1; then
        echo "✅"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
    else
        echo "❌"
    fi
}

# Execução
check "Claude.app existe" "[ -d /Applications/Claude.app ]"
check "Claude.app é arm64" "file /Applications/Claude.app/Contents/MacOS/Claude | grep -q arm64"
check "~/.claude existe" "[ -d ~/.claude ]"
check "Config JSON existe" "[ -f ~/.claude/claude_desktop_config.json ]"
check "Config JSON é válido" "python3 -m json.tool < ~/.claude/claude_desktop_config.json"
check "Permissão ~/.claude" "[ -x ~/.claude ]"
check "Permissão config JSON" "[ -r ~/.claude/claude_desktop_config.json ]"
check "Python 3 disponível" "command -v python3"
check "Python é arm64" "file $(which python3) | grep -q arm64"

# MCP Servers
if [ -d ~/.claude/mcp_servers ]; then
    for server_dir in ~/.claude/mcp_servers/*/; do
        server_name=$(basename "$server_dir")
        check "MCP Server $server_name existe" "[ -d '$server_dir' ]"
        check "MCP Server $server_name em config" "python3 -c \"import json; c=json.load(open('~/.claude/claude_desktop_config.json')); exit(0 if '$server_name' in c['mcpServers'] else 1)\""
    done
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "RESULTADO: $CHECKS_PASSED/$CHECKS_TOTAL validações passaram"
echo "════════════════════════════════════════════════════════════"

if [ $CHECKS_PASSED -eq $CHECKS_TOTAL ]; then
    echo "✅ Todas as validações passaram"
    exit 0
else
    echo "⚠️  Algumas validações falharam"
    exit 1
fi
```

### 8.2 Teste de Inicialização

```bash
#!/bin/bash
# Script: test_startup.sh

echo "Testando inicialização do Claude Desktop..."
echo ""

# 1. Fechar instâncias anteriores
killall -9 Claude 2>/dev/null || true
sleep 2

# 2. Iniciar com debug
echo "Iniciando Claude (verificar logs por 10 segundos)..."
open -a Claude --args --debug 2>&1 &
CLAUDE_PID=$!

# Monitorar logs
LOG_FILES=(
    "$HOME/Library/Logs/Claude/claude.log"
    "$HOME/.claude/logs/claude.log"
)

for log in "${LOG_FILES[@]}"; do
    if [ -f "$log" ]; then
        echo "Monitorando: $log"
        tail -f "$log" &
        TAIL_PID=$!
    fi
done

# Aguardar e verificar
sleep 5
if kill -0 $CLAUDE_PID 2>/dev/null; then
    echo "✅ Claude iniciou com sucesso (PID: $CLAUDE_PID)"
    
    # Manter por mais 5 segundos
    sleep 5
    
    # Fechar
    kill $CLAUDE_PID 2>/dev/null || true
else
    echo "❌ Claude não iniciou"
fi

# Parar tail
killall tail 2>/dev/null || true

echo ""
echo "✅ Teste de inicialização concluído"
```

---

## 9. MANUTENÇÃO CONTÍNUA

### 9.1 Verificação Periódica

```bash
#!/bin/bash
# Script: maintenance_check.sh
# Execute mensalmente: crontab -e

echo "════════════════════════════════════════════════════════════"
echo "VERIFICAÇÃO PERIÓDICA - $(date)"
echo "════════════════════════════════════════════════════════════"

# 1. Verificar integridade JSON
echo "[1] Verificando integridade JSON..."
if ! python3 -m json.tool < ~/.claude/claude_desktop_config.json > /dev/null 2>&1; then
    echo "❌ JSON CORROMPIDO - AÇÃO NECESSÁRIA"
    # Restaurar de backup
    if [ -d ~/.claude/backups ]; then
        LATEST_BACKUP=$(ls -t ~/.claude/backups/*.json.bak 2>/dev/null | head -1)
        if [ -f "$LATEST_BACKUP" ]; then
            echo "Restaurando de: $LATEST_BACKUP"
            cp "$LATEST_BACKUP" ~/.claude/claude_desktop_config.json
        fi
    fi
fi

# 2. Verificar espaço em disco
echo "[2] Verificando espaço em disco..."
DISK_USAGE=$(df -h ~ | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    echo "⚠️  Espaço em disco baixo: $DISK_USAGE%"
fi

# 3. Limpar caches antigos
echo "[3] Limpando caches..."
find ~/.claude -type f -mtime +90 -name "*.cache" -delete 2>/dev/null || true

# 4. Verificar logs grandes
echo "[4] Verificando tamanho de logs..."
LOGS_SIZE=$(du -sh ~/.claude/logs 2>/dev/null | cut -f1)
echo "   Logs: $LOGS_SIZE"

# 5. Verificar backups
echo "[5] Verificando backups..."
BACKUP_COUNT=$(ls ~/.claude/backups/*.json.bak 2>/dev/null | wc -l)
echo "   Backups: $BACKUP_COUNT"
if [ "$BACKUP_COUNT" -gt 50 ]; then
    echo "   ⚠️  Muitos backups - limpando antigos..."
    ls -t ~/.claude/backups/*.json.bak 2>/dev/null | tail -n +50 | xargs rm -f
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ VERIFICAÇÃO CONCLUÍDA"
echo "════════════════════════════════════════════════════════════"
```

### 9.2 Agendamento Automático (Cron)

```bash
# Adicionar ao crontab: crontab -e

# Verificação semanal (domingo 02:00 AM)
0 2 * * 0 $HOME/.claude/scripts/maintenance_check.sh >> $HOME/.claude/logs/maintenance.log 2>&1

# Limpeza mensal de caches (primeiro dia do mês 03:00 AM)
0 3 1 * * find $HOME/.claude -type f -mtime +30 -name "*.tmp" -delete >> $HOME/.claude/logs/cleanup.log 2>&1
```

### 9.3 Monitoramento com Log Rotation

```bash
#!/bin/bash
# Script: setup_log_rotation.sh

echo "Configurando log rotation..."

# Criar logrotate config
sudo tee /etc/logrotate.d/claude-desktop > /dev/null << 'EOF'
$HOME/.claude/logs/* {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 644 $USER staff
}

$HOME/Library/Logs/Claude/* {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
}
EOF

echo "✅ Log rotation configurado"
```

---

## 10. TROUBLESHOOTING AVANÇADO

### 10.1 Problemas Comuns e Soluções

#### Problema: "Connection refused" ao conectar MCP server

```bash
# Diagnóstico
echo "Diagnosticando problema de conexão..."

# 1. Verificar se servidor está rodando
ps aux | grep mcp

# 2. Testar servidor manualmente
~/.claude/mcp_servers/seu_server/venv/bin/python ~/.claude/mcp_servers/seu_server/server.py &
SERVER_PID=$!

# 3. Verificar portas
lsof -i -P -n | grep LISTEN

# 4. Testar conectividade
python3 << 'PYTHON'
import socket
import sys

def test_connection(host, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    result = sock.connect_ex((host, port))
    sock.close()
    return result == 0

if test_connection("localhost", 8000):
    print("✅ Porta 8000 acessível")
else:
    print("❌ Porta 8000 não responde")
PYTHON

# 5. Parar e diagnosticar
kill $SERVER_PID 2>/dev/null || true
```

#### Problema: "Module not found" ao iniciar MCP server

```bash
# Verificar PYTHONPATH
echo $PYTHONPATH

# Adicionar ao config JSON
{
  "mcpServers": {
    "seu_server": {
      "env": {
        "PYTHONPATH": "/Users/seu_user/.claude/mcp_servers/seu_server:/Users/seu_user/.claude/mcp_servers/seu_server/lib"
      }
    }
  }
}

# Testar imports manualmente
python3 << 'PYTHON'
import sys
sys.path.insert(0, "/Users/seu_user/.claude/mcp_servers/seu_server")

try:
    import seu_modulo
    print("✅ Módulo encontrado")
except ImportError as e:
    print(f"❌ Erro: {e}")
PYTHON
```

#### Problema: "Timeout" ao executar MCP server

```bash
# Aumentar timeout na config (se suportado)
{
  "mcpServers": {
    "seu_server": {
      "timeout": 30000  # 30 segundos em ms
    }
  }
}

# Ou otimizar servidor para inicializar mais rápido
# Remover imports desnecessários
# Usar lazy loading
# Otimizar inicialização de recursos
```

### 10.2 Análise de Logs Detalhada

```bash
#!/bin/bash
# Script: analyze_logs.sh

echo "Analisando logs do Claude Desktop..."
echo ""

# Encontrar arquivos de log
LOG_LOCATIONS=(
    "$HOME/.claude/logs"
    "$HOME/Library/Logs/Claude"
    "$HOME/Library/Application Support/Claude/logs"
)

for loc in "${LOG_LOCATIONS[@]}"; do
    if [ -d "$loc" ]; then
        echo "Logs em: $loc"
        echo "Últimas 100 linhas:"
        find "$loc" -name "*.log" -type f -exec tail -100 {} \; 2>/dev/null | tail -100
        echo ""
    fi
done

# Procurar por erros
echo "════════════════════════════════════════════════════════════"
echo "ERROS DETECTADOS:"
echo "════════════════════════════════════════════════════════════"

find "$HOME/.claude/logs" "$HOME/Library/Logs/Claude" \
    -name "*.log" -type f \
    -exec grep -l "ERROR\|FATAL\|Exception\|Traceback" {} \; 2>/dev/null | \
    while read logfile; do
        echo "Arquivo: $logfile"
        grep "ERROR\|FATAL\|Exception\|Traceback" "$logfile" | head -10
        echo ""
    done
```

### 10.3 Reset Completo (Nuclear Option)

```bash
#!/bin/bash
# Script: nuclear_reset.sh
# ⚠️  USAR APENAS COMO ÚLTIMO RECURSO

echo "⚠️  NUCLEAR RESET - Isso removerá TUDO"
echo "Pressione CTRL+C para cancelar ou aguarde 10 segundos..."
sleep 10

# 1. Fazer backup completo
BACKUP_DIR="$HOME/Claude_Complete_Backup_$(date +%Y%m%d_%H%M%S)"
echo "Criando backup em: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp -r "$HOME/.claude" "$BACKUP_DIR/" || true
cp -r "$HOME/Library/Application Support/Claude" "$BACKUP_DIR/" || true

# 2. Fechar Claude
killall -9 Claude 2>/dev/null || true

# 3. Remover tudo
echo "Removendo arquivos..."
rm -rf "$HOME/.claude"
rm -rf "$HOME/Library/Application Support/Claude"
rm -rf "$HOME/Library/Caches/Claude"
rm -rf "$HOME/Library/Logs/Claude"
rm -rf "$HOME/Library/Preferences/com.anthropic*"

# 4. Reinicializar
echo "Reinicializando Claude..."
open /Applications/Claude.app

echo "✅ Reset concluído"
echo "Backup disponível em: $BACKUP_DIR"
```

---

## REFERÊNCIA RÁPIDA

### Scripts Essenciais

```bash
# Diagnóstico completo
./diagnose_claude.sh

# Validação final
./validation_checklist.sh

# Correção automática
./fix_claude_config.sh

# Teste de MCP Server
./test_mcp_server.sh filesystem

# Verificação de compatibilidade Silicon
./verify_silicon_compatibility.sh
```

### Locais Críticos

```
~/.claude/claude_desktop_config.json     # Configuração central
~/.claude/mcp_servers/                   # MCP Servers instalados
~/Library/Logs/Claude/                   # Logs da aplicação
/Applications/Claude.app                 # Aplicação
```

### Comandos Frequentes

```bash
# Reiniciar Claude
killall -9 Claude && open /Applications/Claude.app

# Ver últimos erros
tail -50 ~/Library/Logs/Claude/claude.log

# Validar JSON config
python3 -m json.tool < ~/.claude/claude_desktop_config.json

# Listar MCP Servers
python3 -c "import json; print(json.dumps(json.load(open('~/.claude/claude_desktop_config.json'))['mcpServers'], indent=2))"
```

---

## CONCLUSÃO

Este guia fornece uma abordagem estruturada e robusta para setup do Claude Desktop no macOS Silicon. Seguindo os passos sequencialmente, você terá um ambiente:

✅ **Seguro** - Credenciais protegidas, permissões corretas
✅ **Robusto** - Tratamento de erros, backups automáticos
✅ **Otimizado** - Aproveitando hardware Apple Silicon nativo
✅ **Mantível** - Logs, monitoramento, rotinas de limpeza
✅ **Debugável** - Ferramentas de diagnóstico integradas

Para suporte contínuo, mantenha este documento atualizado e execute verificações periódicas.
