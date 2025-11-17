# Makefile para Atlas CLI
# Gerenciamento automatizado do Atlas CLI

.PHONY: help install configure pin-extensions status clean backup restore test

# Configurações
ATLAS_DIR := $(HOME)/Dotfiles/atlas-cli
CONFIG_DIR := $(HOME)/.config/atlas-cli
LOG_FILE := $(CONFIG_DIR)/atlas.log

# Cores
GREEN := \033[0;32m
BLUE := \033[0;34m
RED := \033[0;31m
YELLOW := \033[1;33m
NC := \033[0m

# Ajuda
help: ## Mostrar ajuda
	@echo "$(BLUE)Atlas CLI - Gerenciamento Automatizado$(NC)"
	@echo "=========================================="
	@echo ""
	@echo "Comandos disponíveis:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""

# Instalação
install: ## Instalar Atlas CLI
	@echo "$(BLUE)Instalando Atlas CLI...$(NC)"
	@bash $(ATLAS_DIR)/install-atlas-cli.sh

# Configuração
configure: ## Configurar Atlas CLI
	@echo "$(BLUE)Configurando Atlas CLI...$(NC)"
	@bash $(ATLAS_DIR)/configure-atlas-cli.sh

# Pinagem de extensões
pin-extensions: ## Fixar extensões na barra
	@echo "$(BLUE)Fixando extensões...$(NC)"
	@bash $(ATLAS_DIR)/pin-extensoes-macos.sh

# Status
status: ## Verificar status do Atlas CLI
	@echo "$(BLUE)Status do Atlas CLI:$(NC)"
	@if command -v atlas-cli >/dev/null 2>&1; then \
		echo "$(GREEN)✅ Atlas CLI instalado: $$(atlas-cli --version 2>/dev/null || echo 'unknown')$(NC)"; \
		if atlas-cli status >/dev/null 2>&1; then \
			echo "$(GREEN)✅ Atlas CLI autenticado$(NC)"; \
		else \
			echo "$(YELLOW)⚠️ Atlas CLI não autenticado$(NC)"; \
		fi; \
		echo ""; \
		echo "$(BLUE)Extensões instaladas:$(NC)"; \
		atlas-cli extensions list 2>/dev/null || echo "Erro ao listar extensões"; \
		echo ""; \
		echo "$(BLUE)Extensões fixadas:$(NC)"; \
		atlas-cli extensions pinned 2>/dev/null || echo "Erro ao listar extensões fixadas"; \
	else \
		echo "$(RED)❌ Atlas CLI não instalado$(NC)"; \
	fi

# Limpeza
clean: ## Limpar arquivos temporários
	@echo "$(BLUE)Limpando arquivos temporários...$(NC)"
	@rm -rf $(CONFIG_DIR)/*.tmp 2>/dev/null || true
	@rm -rf $(HOME)/.cache/atlas-cli 2>/dev/null || true
	@find $(CONFIG_DIR) -name "*.log" -mtime +7 -delete 2>/dev/null || true
	@echo "$(GREEN)✅ Limpeza concluída$(NC)"

# Backup
backup: ## Fazer backup das configurações
	@echo "$(BLUE)Fazendo backup das configurações...$(NC)"
	@mkdir -p $(HOME)/Backups/atlas-cli
	@timestamp=$$(date +"%Y%m%d_%H%M%S"); \
	cp -r $(CONFIG_DIR) $(HOME)/Backups/atlas-cli/atlas-cli_$$timestamp; \
	echo "$(GREEN)✅ Backup criado em: $(HOME)/Backups/atlas-cli/atlas-cli_$$timestamp$(NC)"

# Restaurar
restore: ## Restaurar configurações do backup
	@echo "$(BLUE)Backups disponíveis:$(NC)"
	@ls -la $(HOME)/Backups/atlas-cli/ 2>/dev/null || echo "Nenhum backup encontrado"
	@echo ""
	@read -p "Digite o nome do backup para restaurar: " backup_name; \
	if [ -d "$(HOME)/Backups/atlas-cli/$$backup_name" ]; then \
		cp -r "$(HOME)/Backups/atlas-cli/$$backup_name"/* $(CONFIG_DIR)/; \
		echo "$(GREEN)✅ Configurações restauradas de: $$backup_name$(NC)"; \
	else \
		echo "$(RED)❌ Backup não encontrado: $$backup_name$(NC)"; \
	fi

# Teste
test: ## Testar configuração
	@echo "$(BLUE)Testando configuração...$(NC)"
	@bash $(ATLAS_DIR)/configure-atlas-cli.sh test

# Setup completo
setup: install configure pin-extensions ## Setup completo (instalar + configurar + fixar)
	@echo "$(GREEN)🎉 Setup completo do Atlas CLI concluído!$(NC)"

# Atualizar
update: ## Atualizar Atlas CLI
	@echo "$(BLUE)Atualizando Atlas CLI...$(NC)"
	@if command -v brew >/dev/null 2>&1; then \
		brew upgrade atlas-cli; \
	else \
		echo "$(YELLOW)⚠️ Homebrew não encontrado. Atualização manual necessária.$(NC)"; \
	fi

# Monitor
monitor-start: ## Iniciar monitoramento
	@echo "$(BLUE)Iniciando monitoramento...$(NC)"
	@bash $(ATLAS_DIR)/configure-atlas-cli.sh monitor start

monitor-stop: ## Parar monitoramento
	@echo "$(BLUE)Parando monitoramento...$(NC)"
	@bash $(ATLAS_DIR)/configure-atlas-cli.sh monitor stop

monitor-status: ## Status do monitoramento
	@echo "$(BLUE)Status do monitoramento:$(NC)"
	@bash $(ATLAS_DIR)/configure-atlas-cli.sh monitor status

# Raycast
raycast-setup: ## Configurar integração com Raycast
	@echo "$(BLUE)Configurando integração com Raycast...$(NC)"
	@mkdir -p "$(HOME)/Library/Application Support/Raycast/Scripts/Atlas-CLI"
	@cp $(ATLAS_DIR)/raycast-atlas.sh "$(HOME)/Library/Application Support/Raycast/Scripts/Atlas-CLI/"
	@chmod +x "$(HOME)/Library/Application Support/Raycast/Scripts/Atlas-CLI/raycast-atlas.sh"
	@echo "$(GREEN)✅ Integração com Raycast configurada$(NC)"

# Logs
logs: ## Mostrar logs
	@echo "$(BLUE)Logs do Atlas CLI:$(NC)"
	@if [ -f $(LOG_FILE) ]; then \
		tail -50 $(LOG_FILE); \
	else \
		echo "Nenhum log encontrado"; \
	fi

# Diagnóstico
diagnose: ## Diagnóstico completo
	@echo "$(BLUE)Diagnóstico do Atlas CLI:$(NC)"
	@bash $(ATLAS_DIR)/configure-atlas-cli.sh diagnose

# Padrão
.DEFAULT_GOAL := help
