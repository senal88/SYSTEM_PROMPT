# 1Password Connect Server - Makefile
# Common operations for macOS Silicon

.PHONY: help validate setup start stop restart logs test clean pull health status

# Default target
help:
	@echo "1Password Connect Server - Available Commands"
	@echo ""
	@echo "Setup & Deployment:"
	@echo "  make validate    - Run complete validation checks"
	@echo "  make setup       - Setup and deploy Connect server"
	@echo "  make start       - Start the Connect server"
	@echo "  make stop        - Stop the Connect server"
	@echo "  make restart     - Restart the Connect server"
	@echo ""
	@echo "Testing & Monitoring:"
	@echo "  make test        - Run API tests"
	@echo "  make health      - Check service health"
	@echo "  make logs        - View container logs"
	@echo "  make status      - Show container status"
	@echo ""
	@echo "Maintenance:"
	@echo "  make pull        - Pull latest Docker images"
	@echo "  make clean       - Remove containers and volumes"
	@echo "  make reset       - Complete reset (clean + pull)"
	@echo ""
	@echo "Security:"
	@echo "  make permissions - Fix file permissions"
	@echo "  make cert        - Generate self-signed TLS certificate"
	@echo ""

# Validation
validate:
	@echo "Running validation checks..."
	@chmod +x validate-and-deploy.sh
	@./validate-and-deploy.sh

# Setup
setup:
	@echo "Setting up 1Password Connect Server..."
	@chmod +x setup-connect.sh
	@./setup-connect.sh

# Start services
start:
	@echo "Starting 1Password Connect Server..."
	@docker compose up -d
	@echo "Waiting for services..."
	@sleep 5
	@make health

# Stop services
stop:
	@echo "Stopping 1Password Connect Server..."
	@docker compose down

# Restart services
restart: stop start

# View logs
logs:
	@docker compose logs -f

# Test API
test:
	@echo "Running API tests..."
	@chmod +x test-connect.sh
	@./test-connect.sh

# Health check
health:
	@echo "Checking service health..."
	@curl -s http://localhost:8080/health || echo "Service not responding"
	@docker compose ps

# Container status
status:
	@docker compose ps

# Pull images
pull:
	@echo "Pulling latest Docker images..."
	@docker compose pull

# Clean up
clean:
	@echo "Removing containers and volumes..."
	@docker compose down -v
	@echo "Cleaning up logs..."
	@rm -f validation.log

# Complete reset
reset: clean pull
	@echo "Complete reset finished"

# Fix permissions
permissions:
	@echo "Setting secure file permissions..."
	@chmod 600 credentials.json 2>/dev/null || echo "credentials.json not found"
	@chmod 600 .env 2>/dev/null || echo ".env not found"
	@chmod 600 certs/*.key 2>/dev/null || echo "No certificate keys found"
	@chmod 644 certs/*.crt 2>/dev/null || echo "No certificates found"
	@echo "Permissions updated"

# Generate TLS certificate
cert:
	@echo "Generating self-signed TLS certificate..."
	@mkdir -p certs
	@openssl genrsa -out certs/tls.key 2048
	@openssl req -new -x509 -key certs/tls.key \
		-out certs/tls.crt -days 365 \
		-subj "/C=BR/ST=State/L=City/O=Organization/CN=localhost"
	@chmod 600 certs/tls.key
	@chmod 644 certs/tls.crt
	@echo "Certificate generated in certs/"

# Quick deployment
deploy: validate start test

# Full setup from scratch
init: permissions setup test
