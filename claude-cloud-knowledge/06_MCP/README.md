# 🚀 Configuração Profissional MCP - Claude Desktop

## 📋 Visão Geral

Este diretório contém a configuração profissional completa para maximizar o uso do Model Context Protocol (MCP) no Claude Desktop, otimizada para:

- ✅ **macOS Silicon** (Apple M1/M2/M3)
- ✅ **VPS Ubuntu** com Coolify
- ✅ **Produção e Desenvolvimento**

## 📁 Estrutura

```
06_MCP/
├── CONFIGURACAO_PROFISSIONAL_COMPLETA.md  # Documentação completa
├── configuracoes/
│   ├── claude_desktop_config.production.json  # Config produção
│   └── backups/                              # Backups automáticos
├── scripts/
│   ├── install-mcp-servers.sh               # Instalação automática
│   ├── verify-mcp-servers.sh                # Verificação de saúde
│   └── setup-vps-coolify.sh                 # Setup VPS/Coolify
├── env/
│   └── .env.example                         # Template de variáveis
└── README.md                                 # Este arquivo
```

## 🚀 Início Rápido

### 1. Instalação no macOS

```bash
cd ~/Dotfiles/claude-cloud-knowledge/06_MCP
./scripts/install-mcp-servers.sh
```

### 2. Configurar Variáveis de Ambiente

```bash
# Copiar template
cp env/.env.example ~/.env.local

# Editar com seus valores
nano ~/.env.local

# Ou adicionar ao ~/.zshrc
source ~/.env.local
```

### 3. Verificar Configuração

```bash
./scripts/verify-mcp-servers.sh
```

### 4. Reiniciar Claude Desktop

```bash
killall Claude
open -a Claude
```

## 🐧 Setup VPS Ubuntu com Coolify

```bash
# No VPS
cd /data/coolify/applications
./setup-vps-coolify.sh

# Ou via SSH
ssh usuario@vps "bash -s" < scripts/setup-vps-coolify.sh
```

## 📚 Documentação

- **[Configuração Profissional Completa](./CONFIGURACAO_PROFISSIONAL_COMPLETA.md)** - Guia completo com todas as opções
- **[Servidores Disponíveis](./CONFIGURACAO_PROFISSIONAL_COMPLETA.md#-servidores-mcp-por-categoria)** - Lista completa de servidores MCP

## 🔒 Segurança

⚠️ **IMPORTANTE**: Nunca commite secrets no arquivo de configuração!

- Use variáveis de ambiente
- Armazene secrets no 1Password
- Use `.env.local` (já está no .gitignore)

## 🛠️ Troubleshooting

### Servidor não inicia

```bash
# Verificar logs
tail -f ~/Library/Logs/Claude/mcp*.log

# Testar manualmente
npx -y @modelcontextprotocol/server-filesystem /tmp
```

### Variáveis de ambiente não carregadas

```bash
# Verificar se estão definidas
env | grep GITHUB_TOKEN

# Recarregar shell
source ~/.zshrc
```

## 📊 Servidores Configurados

### Desenvolvimento
- ✅ Filesystem
- ✅ Git
- ✅ GitHub
- ✅ Docker
- ✅ Kubernetes
- ✅ Python Exec
- ✅ Puppeteer/Playwright

### Bancos de Dados
- ✅ PostgreSQL
- ✅ SQLite
- ✅ MySQL (via VPS)
- ✅ MongoDB (via VPS)
- ✅ Redis (via VPS)

### Cloud Services
- ✅ AWS
- ✅ Notion
- ✅ Slack

### AI & Memória
- ✅ Memory (persistente)
- ✅ Sequential Thinking
- ✅ Fetch (web)

### Remoto
- ✅ VPS Ubuntu (Coolify)

## 🎯 Próximos Passos

1. ✅ Instalar servidores básicos
2. ✅ Configurar variáveis de ambiente
3. ✅ Testar cada servidor individualmente
4. ✅ Configurar VPS remoto (opcional)
5. ✅ Otimizar para seu workflow específico

## 📝 Manutenção

### Atualizar Servidores

```bash
# Node.js servers
npm update -g @modelcontextprotocol/server-*

# Python servers
uvx install --upgrade mcp-server-*
```

### Backup de Configuração

Os backups são criados automaticamente em:
```
configuracoes/backups/claude_desktop_config.json.backup.YYYYMMDD_HHMMSS
```

## 🤝 Contribuindo

Para adicionar novos servidores ou melhorar a configuração:

1. Edite `claude_desktop_config.production.json`
2. Atualize a documentação
3. Teste localmente
4. Commit com mensagem descritiva

## 📞 Suporte

- **Documentação Oficial MCP**: https://modelcontextprotocol.io
- **Repositório Servidores**: https://github.com/modelcontextprotocol/servers
- **Issues**: Abra uma issue no repositório do projeto

---

**Versão**: 2.0 Professional
**Última Atualização**: Janeiro 2025
**Autor**: Configuração Profissional MCP
