# 🚀 Dotfiles Profissionais - Luiz Sena

> Configurações centralizadas e automatizadas para desenvolvimento produtivo

[![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Zsh](https://img.shields.io/badge/Zsh-000000?style=for-the-badge&logo=zsh&logoColor=white)](https://www.zsh.org/)
[![Homebrew](https://img.shields.io/badge/Homebrew-000000?style=for-the-badge&logo=homebrew&logoColor=white)](https://brew.sh/)
[![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)](https://git-scm.com/)

## 📋 Visão Geral

Este repositório contém configurações centralizadas e automatizadas para um ambiente de desenvolvimento produtivo, inspirado nas melhores práticas dos repositórios [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles), [Lissy93/dotfiles](https://github.com/Lissy93/dotfiles) e [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles).

### 🎯 Características

- ✅ **Estrutura Modular**: Organização clara e escalável
- ✅ **Automação Completa**: Scripts de instalação e configuração
- ✅ **Multiplataforma**: Suporte para macOS e Linux
- ✅ **Frameworks Integrados**: Gemini, Cursor, Codex, 1Password
- ✅ **Desenvolvimento AI**: Configurações otimizadas para IA
- ✅ **Segurança**: Gerenciamento centralizado de secrets

## 🏗️ Estrutura do Repositório

```
~/Dotfiles/
├── .config/                    # Configurações centralizadas
│   ├── nvim/                  # Neovim configuration
│   ├── git/                   # Git configurations
│   ├── shell/                 # Shell configurations
│   ├── scripts/               # Custom scripts
│   └── apps/                  # App-specific configs
├── .local/                    # Local binaries and data
│   ├── bin/                   # Local executables
│   └── share/                 # Shared data
├── modules/                   # Modular configurations
│   ├── shell/                 # Shell modules (zsh, bash)
│   ├── git/                   # Git modules
│   ├── apps/                  # Application modules
│   ├── dev/                   # Development tools
│   └── ai/                    # AI/ML tools
├── scripts/                   # Automation scripts
│   ├── install/               # Installation scripts
│   ├── setup/                 # Setup scripts
│   └── maintenance/           # Maintenance scripts
├── docs/                      # Documentation
│   ├── guides/                # User guides
│   ├── examples/              # Usage examples
│   └── reference/             # Reference docs
├── install.sh                 # Main installation script
├── Makefile                   # Build automation
└── README.md                  # This file
```

## 🚀 Instalação Rápida

### Pré-requisitos

- macOS (testado) ou Linux
- Git
- Zsh (padrão no macOS)
- Homebrew (macOS) ou gerenciador de pacotes equivalente

### Instalação Automática

```bash
# Clonar o repositório
git clone https://github.com/yourusername/dotfiles.git ~/Dotfiles

# Executar instalação
cd ~/Dotfiles
./install.sh
```

### Instalação Manual

```bash
# 1. Instalar dependências
make install-deps

# 2. Configurar shell
make setup-shell

# 3. Configurar aplicações
make setup-apps

# 4. Configurar desenvolvimento
make setup-dev

# 5. Configurar AI tools
make setup-ai
```

## 🛠️ Módulos Disponíveis

### 🐚 Shell (Zsh)
- **Oh My Zsh**: Framework para Zsh
- **Plugins**: Autosuggestions, syntax highlighting, git
- **Aliases**: Produtividade e navegação
- **Functions**: Funções customizadas

### 🔧 Git
- **Configurações**: User, email, aliases
- **Hooks**: Pre-commit, commit-msg
- **Templates**: Commit templates
- **LFS**: Git Large File Storage

### 🎨 Aplicações
- **Cursor**: Editor com IA
- **VSCode**: Configurações e extensões
- **Neovim**: Editor modal
- **Terminal**: iTerm2, configurações
- **Raycast**: Automação via `./raycast-setup.sh` com perfis sincronizados

#### ⚙️ Workflow do Raycast

- Ajuste parâmetros em `configs/raycast.env` (casks, fórmulas, caminhos de perfil) ou exporte variáveis direto na chamada.
- Execute `./raycast-setup.sh` para instalar dependências, configurar o atalho `⌘ Space` e restaurar o backup salvo em `raycast-profile/`.
- Utilize `./raycast-setup.sh --backup` para atualizar o snapshot local com as preferências atuais do Raycast.
- Combine `--skip-install` com `--restore` quando quiser apenas sincronizar o perfil sem reinstalar apps.
- A primeira abertura do Raycast após a execução ainda pedirá permissões de Acessibilidade/Automação — confirme manualmente conforme solicitado.

### 🤖 AI/ML Tools
- **Gemini CLI**: Google Gemini integration
- **Codex**: AI code assistant
- **Cursor Agent**: AI-powered development
- **1Password**: Secret management

### 💻 Desenvolvimento
- **Node.js**: NVM, npm, yarn
- **Python**: Pyenv, pip, poetry
- **Rust**: Cargo, rustup
- **Docker**: Configurações e aliases

## 📚 Documentação

### Guias Rápidos
- [Configuração Inicial](docs/guides/initial-setup.md)
- [Personalização](docs/guides/customization.md)
- [Troubleshooting](docs/guides/troubleshooting.md)

### Exemplos
- [Adicionando Novo Módulo](docs/examples/new-module.md)
- [Configurando Nova Aplicação](docs/examples/new-app.md)
- [Scripts Customizados](docs/examples/custom-scripts.md)

### Referência
- [API dos Scripts](docs/reference/scripts-api.md)
- [Estrutura de Módulos](docs/reference/module-structure.md)
- [Variáveis de Ambiente](docs/reference/environment-variables.md)

## 🔧 Scripts Disponíveis

### Instalação
```bash
./install.sh              # Instalação completa
./install.sh --minimal    # Instalação mínima
./install.sh --dev        # Instalação para desenvolvimento
```

### Manutenção
```bash
make update               # Atualizar configurações
make backup              # Backup das configurações
make clean               # Limpeza de arquivos temporários
make test                # Testar configurações
```

### Desenvolvimento
```bash
make setup-dev           # Configurar ambiente de desenvolvimento
make setup-ai            # Configurar ferramentas de IA
make setup-security      # Configurar segurança
```

## 🎨 Personalização

### Adicionando Novo Módulo

1. Criar diretório em `modules/`
2. Adicionar arquivos de configuração
3. Criar script de instalação
4. Atualizar `install.sh`

### Configurações Específicas

- **Shell**: Editar `modules/shell/`
- **Git**: Editar `modules/git/`
- **Apps**: Editar `modules/apps/`
- **AI**: Editar `modules/ai/`

## 🔒 Segurança

### Gerenciamento de Secrets
- **1Password CLI**: Integração completa
- **Variáveis de Ambiente**: Configuração segura
- **API Keys**: Gerenciamento centralizado

### Backup e Sincronização
- **Git**: Versionamento das configurações
- **Backup**: Scripts automáticos
- **Sincronização**: Multi-dispositivo

## 🤝 Contribuição

1. Fork o repositório
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

## 🙏 Agradecimentos

- [Mathias Bynens](https://github.com/mathiasbynens/dotfiles) - Inspiração inicial
- [Lissy93](https://github.com/Lissy93/dotfiles) - Estrutura modular
- [webpro](https://github.com/webpro/awesome-dotfiles) - Curadoria de exemplos
- [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles) - Lista de referências

## 📞 Suporte

- **Issues**: [GitHub Issues](https://github.com/yourusername/dotfiles/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/dotfiles/discussions)
- **Email**: luizfernandomoreirasena@gmail.com

---

**Última atualização**: $(date)
**Versão**: 1.0.0
**Status**: ✅ Ativo e Mantido
