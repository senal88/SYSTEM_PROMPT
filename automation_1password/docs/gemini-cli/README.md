# Gemini CLI - Guia Completo

Este guia fornece instruções completas para instalar, configurar e usar o Gemini CLI no projeto de automação 1Password.

## 📋 Visão Geral

O Gemini CLI é uma ferramenta de linha de comando que permite interagir com modelos Gemini através de um ambiente REPL (Read-Eval-Print Loop) interativo. O CLI consiste em:

- **Cliente (`packages/cli`)**: Aplicação cliente que comunica com o servidor local
- **Core (`packages/core`)**: Servidor local que gerencia requisições à API Gemini
- **Ferramentas**: Conjunto de ferramentas para operações de arquivo, shell, web, etc.

## 🚀 Instalação Rápida

### Pré-requisitos

- Node.js 18+ instalado
- npm ou yarn instalado
- 1Password CLI instalado e autenticado
- macOS Silicon (M1/M2/M3) ou Linux

### Instalação Automatizada

Execute o script de instalação:

```bash
cd scripts/gemini-cli
chmod +x install-gemini-cli.sh
./install-gemini-cli.sh
```

O script irá:

1. ✅ Verificar pré-requisitos
2. ✅ Instalar o Gemini CLI globalmente
3. ✅ Configurar autenticação usando 1Password
4. ✅ Criar arquivo de configuração básico

### Instalação Manual

Se preferir instalar manualmente:

```bash
# Instalar globalmente
npm install -g @google/gemini-cli

# Configurar API key via 1Password
export GEMINI_API_KEY=$(op read "op://shared_infra/gemini/api_key")

# Autenticar
gemini auth login --api-key "$GEMINI_API_KEY"
```

## 🔐 Autenticação

### Usando 1Password (Recomendado)

O projeto usa 1Password para gerenciar a API key do Gemini:

```bash
# Obter API key do 1Password
export GEMINI_API_KEY=$(op read "op://shared_infra/gemini/api_key")

# Autenticar
gemini auth login --api-key "$GEMINI_API_KEY"
```

### Configuração Persistente

Para adicionar ao seu shell profile (`~/.zshrc`):

```bash
# Gemini CLI - Configuração via 1Password
export GEMINI_API_KEY=$(op read "op://shared_infra/gemini/api_key" 2>/dev/null)
```

### Verificar Autenticação

```bash
gemini auth status
```

## ⚙️ Configuração

### Arquivo de Configuração

O arquivo de configuração está localizado em `~/.config/gemini-cli/config.json`:

```json
{
  "theme": "default",
  "editor": {
    "vimMode": false
  },
  "telemetry": {
    "enabled": false
  }
}
```

### Variáveis de Ambiente

O projeto usa o template `configs/template.env.op` para gerenciar variáveis de ambiente:

```bash
# Gemini API Key
GEMINI_API_KEY=op://shared_infra/gemini/api_key
```

Para injetar as variáveis:

```bash
op inject -i configs/template.env.op -o .env
source .env
```

## 🎯 Uso Básico

### Iniciar Sessão Interativa

```bash
gemini
```

### Comandos Principais

```bash
# Ver ajuda
gemini --help

# Ver versão
gemini --version

# Listar ferramentas disponíveis
gemini tools list

# Executar comando específico
gemini run "comando aqui"
```

### Exemplos de Uso

#### 1. Análise de Código

```bash
gemini run "analise o arquivo scripts/gemini-cli/install-gemini-cli.sh e sugira melhorias"
```

#### 2. Geração de Código

```bash
gemini run "crie um script bash para validar configuração do Docker"
```

#### 3. Resposta de Perguntas

```bash
gemini run "explique a diferença entre 1Password CLI e Connect"
```

## 🔌 Extensões MCP

O Gemini CLI suporta extensões via MCP (Model Context Protocol) que expandem significativamente suas capacidades.

### Extensões Recomendadas para Seu Ambiente

Com base no seu contexto (macOS Silicon + VPS Ubuntu + Hugging Face + GitHub + Codespaces + LLMs + Stacks Docker + Cursor IDE), recomendamos:

**Essenciais:**
- **GitHub MCP Server** - Integração oficial com GitHub e Codespaces
- **Chrome DevTools MCP** - Ferramentas de desenvolvimento
- **Database Toolbox** - Suporte para Postgres, MongoDB, Redis, etc.

**Altamente Recomendadas:**
- **Terraform MCP** - Infrastructure as Code
- **Grafana MCP** - Monitoramento de stacks
- **MongoDB MCP** - Integração nativa
- **Context7** - Documentação de código atualizada

📖 **Documentação completa:** [EXTENSIONS.md](EXTENSIONS.md)

### Instalação Automatizada

```bash
cd scripts/gemini-cli
./install-mcp-extensions.sh --essential
```

⚠️ **Limite recomendado:** Máximo de 8 servidores MCP simultâneos para melhor performance.

## 🛠️ Ferramentas Disponíveis

O Gemini CLI inclui várias ferramentas integradas:

### File System Tools

- `read_file`: Ler conteúdo de arquivos
- `write_file`: Escrever conteúdo em arquivos
- `read_many_files`: Ler múltiplos arquivos

### Shell Tool

- `run_shell_command`: Executar comandos shell

### Web Tools

- `web_fetch`: Buscar conteúdo de URLs
- `google_web_search`: Buscar na web

### Memory Tool

- `save_memory`: Salvar memórias para uso posterior

### Todo Tool

- `write_todos`: Gerenciar lista de tarefas

### MCP Servers

O CLI suporta servidores MCP (Model Context Protocol) para extensibilidade.

## 📚 Documentação Completa

Para documentação completa do Gemini CLI, consulte:

- [Documentação Oficial](https://github.com/google-gemini/gemini-cli)
- [Guia de Início Rápido](https://github.com/google-gemini/gemini-cli/blob/main/docs/get-started.md)
- [Comandos do CLI](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/commands.md)
- [Ferramentas](https://github.com/google-gemini/gemini-cli/blob/main/docs/tools.md)

## 🔍 Validação

Execute o script de validação para verificar se tudo está configurado corretamente:

```bash
cd scripts/gemini-cli
chmod +x validate-gemini-cli.sh
./validate-gemini-cli.sh
```

O script verifica:

- ✅ Instalação do Gemini CLI
- ✅ Configuração da API key
- ✅ Autenticação
- ✅ Diretório de configuração
- ✅ Ferramentas disponíveis
- ✅ Comandos básicos

## 🔒 Segurança

### Boas Práticas

1. **Nunca commite API keys**: Use sempre 1Password para gerenciar secrets
2. **Use variáveis de ambiente**: Não hardcode credenciais
3. **Rotacione tokens**: Alterne API keys periodicamente
4. **Use Trusted Folders**: Configure pastas confiáveis quando disponível

### Integração com 1Password

O projeto está configurado para usar o vault `shared_infra` com o item `gemini`:

```
Vault: shared_infra
Item: gemini
Campo: api_key
```

Para atualizar a API key:

```bash
op item edit gemini --vault=shared_infra
```

## 🐛 Troubleshooting

### Problema: "Command not found: gemini"

**Solução:**

```bash
# Verificar instalação
npm list -g @google/gemini-cli

# Reinstalar se necessário
npm install -g @google/gemini-cli

# Verificar PATH
echo $PATH
```

### Problema: "Authentication failed"

**Solução:**

```bash
# Verificar API key
echo $GEMINI_API_KEY

# Obter do 1Password
export GEMINI_API_KEY=$(op read "op://shared_infra/gemini/api_key")

# Reautenticar
gemini auth login --api-key "$GEMINI_API_KEY"
```

### Problema: "API key format invalid"

**Solução:**

- Verifique se a API key começa com `AIza`
- Certifique-se de que não há espaços ou caracteres extras
- Obtenha uma nova API key do [Google AI Studio](https://makersuite.google.com/app/apikey)

## 📝 Exemplos Práticos

### Exemplo 1: Análise de Scripts

```bash
gemini run "analise todos os scripts em scripts/gemini-cli/ e sugira melhorias de segurança"
```

### Exemplo 2: Documentação Automática

```bash
gemini run "gere documentação markdown para o script install-gemini-cli.sh"
```

### Exemplo 3: Validação de Configuração

```bash
gemini run "valide a configuração do 1Password Connect e sugira otimizações"
```

## 🔄 Integração com o Projeto

### Estrutura de Arquivos

```
scripts/gemini-cli/
├── install-gemini-cli.sh      # Instalação automatizada
├── validate-gemini-cli.sh      # Validação da instalação
└── README.md                   # Este arquivo

docs/gemini-cli/
└── README.md                   # Documentação completa

configs/
└── template.env.op             # Template com referências 1Password
```

### Workflow Recomendado

1. **Instalação inicial**: Execute `install-gemini-cli.sh`
2. **Validação**: Execute `validate-gemini-cli.sh`
3. **Uso diário**: Execute `gemini` para sessão interativa
4. **Automação**: Use `gemini run` em scripts

## 📞 Suporte

Para problemas ou dúvidas:

1. Verifique a [documentação oficial](https://github.com/google-gemini/gemini-cli)
2. Execute o script de validação
3. Consulte os logs em `~/.config/gemini-cli/logs/`

## 🎉 Próximos Passos

Após a instalação:

1. ✅ Execute `gemini` para iniciar uma sessão interativa
2. ✅ Explore as ferramentas disponíveis com `gemini tools list`
3. ✅ Configure temas personalizados (veja [Themes](/docs/cli/themes))
4. ✅ Integre com seu IDE (veja [IDE Integration](/docs/ide-integration))

---

**Última atualização**: 2025-11-03  
**Versão**: 1.0.0
