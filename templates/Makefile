# Makefile para {{PROJECT_NAME}}
# Gerado automaticamente - {{DATE}}

.PHONY: help install dev test build clean lint format docker-build docker-run

# Variáveis
NODE_VERSION ?= 18
PYTHON_VERSION ?= 3.11
DOCKER_IMAGE ?= {{PROJECT_NAME}}
DOCKER_TAG ?= latest
PORT ?= {{DEFAULT_PORT}}

# Cores para output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

help: ## Mostra esta mensagem de ajuda
	@echo "$(BLUE)Comandos disponíveis para {{PROJECT_NAME}}:$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

install: ## Instala dependências do projeto
	@echo "$(BLUE)Instalando dependências...$(NC)"
{{INSTALL_COMMANDS}}

dev: ## Executa o projeto em modo desenvolvimento
	@echo "$(BLUE)Iniciando modo desenvolvimento...$(NC)"
{{DEV_COMMANDS}}

test: ## Executa os testes
	@echo "$(BLUE)Executando testes...$(NC)"
{{TEST_COMMANDS}}

test-coverage: ## Executa testes com cobertura
	@echo "$(BLUE)Executando testes com cobertura...$(NC)"
{{TEST_COVERAGE_COMMANDS}}

test-watch: ## Executa testes em modo watch
	@echo "$(BLUE)Executando testes em modo watch...$(NC)"
{{TEST_WATCH_COMMANDS}}

build: ## Constrói o projeto para produção
	@echo "$(BLUE)Construindo para produção...$(NC)"
{{BUILD_COMMANDS}}

start: ## Inicia o projeto em produção
	@echo "$(BLUE)Iniciando em produção...$(NC)"
{{START_COMMANDS}}

clean: ## Limpa arquivos temporários e cache
	@echo "$(BLUE)Limpando arquivos temporários...$(NC)"
{{CLEAN_COMMANDS}}

lint: ## Executa linter no código
	@echo "$(BLUE)Executando linter...$(NC)"
{{LINT_COMMANDS}}

format: ## Formata o código
	@echo "$(BLUE)Formatando código...$(NC)"
{{FORMAT_COMMANDS}}

docker-build: ## Constrói imagem Docker
	@echo "$(BLUE)Construindo imagem Docker...$(NC)"
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker-run: ## Executa container Docker
	@echo "$(BLUE)Executando container Docker...$(NC)"
	docker run -p $(PORT):$(PORT) --env-file .env $(DOCKER_IMAGE):$(DOCKER_TAG)

docker-stop: ## Para containers Docker
	@echo "$(BLUE)Parando containers Docker...$(NC)"
	docker stop $(DOCKER_IMAGE) || true

docker-rm: ## Remove containers Docker
	@echo "$(BLUE)Removendo containers Docker...$(NC)"
	docker rm $(DOCKER_IMAGE) || true

docker-clean: docker-stop docker-rm ## Limpa containers Docker
	@echo "$(BLUE)Containers Docker limpos$(NC)"

setup: install ## Configura o ambiente de desenvolvimento
	@echo "$(BLUE)Configurando ambiente de desenvolvimento...$(NC)"
{{SETUP_COMMANDS}}

check: lint test ## Verifica código e executa testes
	@echo "$(GREEN)Verificação concluída!$(NC)"

ci: clean install check build ## Pipeline CI completo
	@echo "$(GREEN)Pipeline CI concluído!$(NC)"

# Comandos específicos por tipo de projeto
{{PROJECT_SPECIFIC_COMMANDS}}

# Comandos de desenvolvimento
dev-db: ## Inicia banco de dados para desenvolvimento
	@echo "$(BLUE)Iniciando banco de dados...$(NC)"
{{DEV_DB_COMMANDS}}

dev-redis: ## Inicia Redis para desenvolvimento
	@echo "$(BLUE)Iniciando Redis...$(NC)"
{{DEV_REDIS_COMMANDS}}

dev-full: dev-db dev-redis dev ## Inicia ambiente completo de desenvolvimento
	@echo "$(GREEN)Ambiente de desenvolvimento completo iniciado!$(NC)"

# Comandos de deploy
deploy-dev: ## Deploy para ambiente de desenvolvimento
	@echo "$(BLUE)Fazendo deploy para desenvolvimento...$(NC)"
{{DEPLOY_DEV_COMMANDS}}

deploy-prod: ## Deploy para ambiente de produção
	@echo "$(BLUE)Fazendo deploy para produção...$(NC)"
{{DEPLOY_PROD_COMMANDS}}

# Comandos de backup
backup: ## Cria backup do projeto
	@echo "$(BLUE)Criando backup...$(NC)"
{{BACKUP_COMMANDS}}

restore: ## Restaura backup do projeto
	@echo "$(BLUE)Restaurando backup...$(NC)"
{{RESTORE_COMMANDS}}

# Comandos de monitoramento
logs: ## Mostra logs do projeto
	@echo "$(BLUE)Mostrando logs...$(NC)"
{{LOGS_COMMANDS}}

status: ## Mostra status do projeto
	@echo "$(BLUE)Status do projeto:$(NC)"
{{STATUS_COMMANDS}}

# Comandos de documentação
docs: ## Gera documentação
	@echo "$(BLUE)Gerando documentação...$(NC)"
{{DOCS_COMMANDS}}

docs-serve: ## Serve documentação localmente
	@echo "$(BLUE)Servindo documentação...$(NC)"
{{DOCS_SERVE_COMMANDS}}

# Comandos de segurança
security: ## Executa verificação de segurança
	@echo "$(BLUE)Verificando segurança...$(NC)"
{{SECURITY_COMMANDS}}

# Comandos de performance
perf: ## Executa testes de performance
	@echo "$(BLUE)Executando testes de performance...$(NC)"
{{PERF_COMMANDS}}

# Comandos de migração
migrate: ## Executa migrações
	@echo "$(BLUE)Executando migrações...$(NC)"
{{MIGRATE_COMMANDS}}

migrate-rollback: ## Reverte migrações
	@echo "$(BLUE)Revertendo migrações...$(NC)"
{{MIGRATE_ROLLBACK_COMMANDS}}

# Comandos de seed
seed: ## Executa seed do banco de dados
	@echo "$(BLUE)Executando seed...$(NC)"
{{SEED_COMMANDS}}

# Comandos de validação
validate: ## Valida configuração do projeto
	@echo "$(BLUE)Validando configuração...$(NC)"
{{VALIDATE_COMMANDS}}

# Comandos de atualização
update: ## Atualiza dependências
	@echo "$(BLUE)Atualizando dependências...$(NC)"
{{UPDATE_COMMANDS}}

# Comandos de limpeza avançada
clean-all: clean docker-clean ## Limpeza completa
	@echo "$(GREEN)Limpeza completa concluída!$(NC)"

# Comandos de reset
reset: clean-all install ## Reset completo do projeto
	@echo "$(GREEN)Reset completo concluído!$(NC)"

# Comandos de info
info: ## Mostra informações do projeto
	@echo "$(BLUE)Informações do projeto:$(NC)"
	@echo "  Nome: {{PROJECT_NAME}}"
	@echo "  Versão: {{PROJECT_VERSION}}"
	@echo "  Node.js: $(shell node --version 2>/dev/null || echo 'Não instalado')"
	@echo "  Python: $(shell python --version 2>/dev/null || echo 'Não instalado')"
	@echo "  Docker: $(shell docker --version 2>/dev/null || echo 'Não instalado')"
	@echo "  Porta: $(PORT)"
	@echo "  Imagem Docker: $(DOCKER_IMAGE):$(DOCKER_TAG)"
