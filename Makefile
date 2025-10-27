# 🚀 Dotfiles Makefile
# Automação baseada nas melhores práticas dos repositórios awesome-dotfiles

.PHONY: help install install-minimal install-dev install-ai update backup clean test setup-shell setup-git setup-apps setup-dev setup-ai setup-security

# Cores para output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
NC := \033[0m

# Configurações
DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(HOME)/.dotfiles_backup_$(shell date +%Y%m%d_%H%M%S)
LOG_FILE := $(DOTFILES_DIR)/make.log

# Funções de log
define log
	@echo "$(BLUE)[$(shell date '+%Y-%m-%d %H:%M:%S')]$(NC) $1" | tee -a $(LOG_FILE)
endef

define success
	@echo "$(GREEN)[SUCESSO]$(NC) $1" | tee -a $(LOG_FILE)
endef

define error
	@echo "$(RED)[ERRO]$(NC) $1" | tee -a $(LOG_FILE)
	@exit 1
endef

define warning
	@echo "$(YELLOW)[AVISO]$(NC) $1" | tee -a $(LOG_FILE)
endef

# Banner
define show_banner
	@echo "$(PURPLE)"
	@echo "╔══════════════════════════════════════════════════════════════╗"
	@echo "║                    🚀 DOTFILES MAKEFILE                       ║"
	@echo "║                                                              ║"
	@echo "║  Automação e gerenciamento de configurações                 ║"
	@echo "║  para desenvolvimento produtivo                              ║"
	@echo "╚══════════════════════════════════════════════════════════════╝"
	@echo "$(NC)"
endef

# Ajuda
help: show_banner
	@echo "$(CYAN)Comandos disponíveis:$(NC)"
	@echo ""
	@echo "$(YELLOW)Instalação:$(NC)"
	@echo "  install          Instalação completa"
	@echo "  install-minimal  Instalação mínima"
	@echo "  install-dev      Instalação para desenvolvimento"
	@echo "  install-ai       Instalação com foco em IA"
	@echo ""
	@echo "$(YELLOW)Configuração:$(NC)"
	@echo "  setup-shell      Configurar shell (Zsh)"
	@echo "  setup-git        Configurar Git"
	@echo "  setup-apps       Configurar aplicações"
	@echo "  setup-dev        Configurar desenvolvimento"
	@echo "  setup-ai         Configurar ferramentas de IA"
	@echo "  setup-security   Configurar segurança"
	@echo ""
	@echo "$(YELLOW)Manutenção:$(NC)"
	@echo "  update           Atualizar configurações"
	@echo "  backup           Backup das configurações"
	@echo "  clean            Limpeza de arquivos temporários"
	@echo "  test             Testar configurações"
	@echo ""
	@echo "$(YELLOW)Informação:$(NC)"
	@echo "  status           Status das configurações"
	@echo "  info             Informações do sistema"
	@echo "  help             Mostrar esta ajuda"
	@echo ""

# Instalação completa
install: show_banner
	$(call log,"Iniciando instalação completa...")
	@chmod +x $(DOTFILES_DIR)/install.sh
	@$(DOTFILES_DIR)/install.sh
	$(call success,"Instalação completa finalizada!")

# Instalação mínima
install-minimal: show_banner
	$(call log,"Iniciando instalação mínima...")
	@chmod +x $(DOTFILES_DIR)/install.sh
	@$(DOTFILES_DIR)/install.sh --minimal
	$(call success,"Instalação mínima finalizada!")

# Instalação para desenvolvimento
install-dev: show_banner
	$(call log,"Iniciando instalação para desenvolvimento...")
	@chmod +x $(DOTFILES_DIR)/install.sh
	@$(DOTFILES_DIR)/install.sh --dev
	$(call success,"Instalação para desenvolvimento finalizada!")

# Instalação com foco em IA
install-ai: show_banner
	$(call log,"Iniciando instalação com foco em IA...")
	@chmod +x $(DOTFILES_DIR)/install.sh
	@$(DOTFILES_DIR)/install.sh --ai
	$(call success,"Instalação com foco em IA finalizada!")

# Configurar shell
setup-shell:
	$(call log,"Configurando shell...")
	@if [ -f $(DOTFILES_DIR)/modules/shell/zshrc ]; then \
		cp $(DOTFILES_DIR)/modules/shell/zshrc $(HOME)/.zshrc; \
		$(call success,"Zsh configurado"); \
	else \
		$(call warning,"Arquivo zshrc não encontrado"); \
	fi
	@if [ -f $(DOTFILES_DIR)/modules/shell/aliases ]; then \
		cp $(DOTFILES_DIR)/modules/shell/aliases $(HOME)/.aliases; \
		$(call success,"Aliases configurados"); \
	else \
		$(call warning,"Arquivo aliases não encontrado"); \
	fi
	@if [ -f $(DOTFILES_DIR)/modules/shell/functions ]; then \
		cp $(DOTFILES_DIR)/modules/shell/functions $(HOME)/.functions; \
		$(call success,"Funções configuradas"); \
	else \
		$(call warning,"Arquivo functions não encontrado"); \
	fi

# Configurar Git
setup-git:
	$(call log,"Configurando Git...")
	@if [ -f $(DOTFILES_DIR)/modules/git/gitconfig ]; then \
		cp $(DOTFILES_DIR)/modules/git/gitconfig $(HOME)/.gitconfig; \
		$(call success,"Git configurado"); \
	else \
		$(call warning,"Arquivo gitconfig não encontrado"); \
	fi
	@if [ -d $(DOTFILES_DIR)/modules/git/hooks ]; then \
		mkdir -p $(HOME)/.git_template/hooks; \
		cp -r $(DOTFILES_DIR)/modules/git/hooks/* $(HOME)/.git_template/hooks/; \
		chmod +x $(HOME)/.git_template/hooks/*; \
		$(call success,"Git hooks configurados"); \
	else \
		$(call warning,"Diretório hooks não encontrado"); \
	fi

# Configurar aplicações
setup-apps:
	$(call log,"Configurando aplicações...")
	@if [ -d $(DOTFILES_DIR)/modules/apps/vscode ]; then \
		mkdir -p $(HOME)/.vscode; \
		cp -r $(DOTFILES_DIR)/modules/apps/vscode/* $(HOME)/.vscode/; \
		$(call success,"VSCode configurado"); \
	else \
		$(call warning,"Diretório vscode não encontrado"); \
	fi
	@if [ -d $(DOTFILES_DIR)/modules/apps/nvim ]; then \
		mkdir -p $(HOME)/.config/nvim; \
		cp -r $(DOTFILES_DIR)/modules/apps/nvim/* $(HOME)/.config/nvim/; \
		$(call success,"Neovim configurado"); \
	else \
		$(call warning,"Diretório nvim não encontrado"); \
	fi

# Configurar desenvolvimento
setup-dev:
	$(call log,"Configurando ambiente de desenvolvimento...")
	@if command -v node >/dev/null 2>&1; then \
		$(call success,"Node.js já instalado"); \
	else \
		$(call warning,"Node.js não encontrado. Instale manualmente."); \
	fi
	@if command -v python3 >/dev/null 2>&1; then \
		$(call success,"Python3 já instalado"); \
	else \
		$(call warning,"Python3 não encontrado. Instale manualmente."); \
	fi
	@if command -v rustc >/dev/null 2>&1; then \
		$(call success,"Rust já instalado"); \
	else \
		$(call warning,"Rust não encontrado. Instale manualmente."); \
	fi

# Configurar ferramentas de IA
setup-ai:
	$(call log,"Configurando ferramentas de IA...")
	@if command -v gemini >/dev/null 2>&1; then \
		$(call success,"Gemini CLI já instalado"); \
	else \
		$(call warning,"Gemini CLI não encontrado. Instale manualmente."); \
	fi
	@if command -v cursor >/dev/null 2>&1; then \
		$(call success,"Cursor CLI já instalado"); \
	else \
		$(call warning,"Cursor CLI não encontrado. Instale manualmente."); \
	fi

# Configurar segurança
setup-security:
	$(call log,"Configurando segurança...")
	@if command -v op >/dev/null 2>&1; then \
		$(call success,"1Password CLI já instalado"); \
	else \
		$(call warning,"1Password CLI não encontrado. Instale manualmente."); \
	fi

# Atualizar configurações
update:
	$(call log,"Atualizando configurações...")
	@git pull origin main
	$(call success,"Configurações atualizadas!")

# Backup das configurações
backup:
	$(call log,"Criando backup das configurações...")
	@mkdir -p $(BACKUP_DIR)
	@cp -r $(HOME)/.zshrc $(HOME)/.gitconfig $(HOME)/.vscode $(HOME)/.config/nvim $(BACKUP_DIR)/ 2>/dev/null || true
	$(call success,"Backup criado em: $(BACKUP_DIR)")

# Limpeza de arquivos temporários
clean:
	$(call log,"Limpando arquivos temporários...")
	@find $(DOTFILES_DIR) -name "*.tmp" -delete
	@find $(DOTFILES_DIR) -name "*.log" -delete
	@find $(DOTFILES_DIR) -name ".DS_Store" -delete
	$(call success,"Limpeza concluída!")

# Testar configurações
test:
	$(call log,"Testando configurações...")
	@if [ -f $(HOME)/.zshrc ]; then \
		$(call success,"✅ .zshrc encontrado"); \
	else \
		$(call error,"❌ .zshrc não encontrado"); \
	fi
	@if [ -f $(HOME)/.gitconfig ]; then \
		$(call success,"✅ .gitconfig encontrado"); \
	else \
		$(call error,"❌ .gitconfig não encontrado"); \
	fi
	@if command -v git >/dev/null 2>&1; then \
		$(call success,"✅ Git disponível"); \
	else \
		$(call error,"❌ Git não encontrado"); \
	fi
	@if command -v zsh >/dev/null 2>&1; then \
		$(call success,"✅ Zsh disponível"); \
	else \
		$(call error,"❌ Zsh não encontrado"); \
	fi

# Status das configurações
status:
	$(call log,"Verificando status das configurações...")
	@echo "$(CYAN)📁 Diretório Dotfiles:$(NC) $(DOTFILES_DIR)"
	@echo "$(CYAN)📄 Arquivos de configuração:$(NC)"
	@ls -la $(HOME)/.zshrc $(HOME)/.gitconfig 2>/dev/null || echo "Arquivos não encontrados"
	@echo "$(CYAN)🔧 Comandos disponíveis:$(NC)"
	@command -v git >/dev/null 2>&1 && echo "✅ Git" || echo "❌ Git"
	@command -v zsh >/dev/null 2>&1 && echo "✅ Zsh" || echo "❌ Zsh"
	@command -v node >/dev/null 2>&1 && echo "✅ Node.js" || echo "❌ Node.js"
	@command -v python3 >/dev/null 2>&1 && echo "✅ Python3" || echo "❌ Python3"

# Informações do sistema
info:
	$(call log,"Coletando informações do sistema...")
	@echo "$(CYAN)🖥️ Sistema:$(NC) $(shell uname -a)"
	@echo "$(CYAN)🐚 Shell:$(NC) $(SHELL)"
	@echo "$(CYAN)👤 Usuário:$(NC) $(USER)"
	@echo "$(CYAN)🏠 Home:$(NC) $(HOME)"
	@echo "$(CYAN)📁 Dotfiles:$(NC) $(DOTFILES_DIR)"
	@echo "$(CYAN)🔧 Git:$(NC) $(shell git --version 2>/dev/null || echo 'Não instalado')"
	@echo "$(CYAN)🐍 Python:$(NC) $(shell python3 --version 2>/dev/null || echo 'Não instalado')"
	@echo "$(CYAN)📦 Node:$(NC) $(shell node --version 2>/dev/null || echo 'Não instalado')"

# Comando padrão
.DEFAULT_GOAL := help
