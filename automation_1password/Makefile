# Makefile for the automation_1password project

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  setup-macos         - Setup the complete macOS Silicon environment"
	@echo "  setup-connect       - Setup the 1Password Connect server"
	@echo "  inject-secrets      - Inject secrets into the environment"
	@echo "  validate-arch       - Validate the project architecture"
	@echo "  build-context-index - Build the context index for LLMs"
	@echo "  clean               - Remove temporary files"

.PHONY: setup-macos
setup-macos:
	@scripts/bootstrap/setup-macos-complete.sh

.PHONY: setup-connect
setup-connect:
	@scripts/connect/setup-1password-connect-secure.sh

.PHONY: inject-secrets
inject-secrets:
	@scripts/secrets/inject_secrets_macos.sh

.PHONY: validate-arch
validate-arch:
	@scripts/validation/validate_architecture.sh

.PHONY: build-context-index
build-context-index:
	@scripts/context/build_index.sh

.PHONY: clean
clean:
	@find . -name "*.tmp" -delete
	@find . -name "*.log" -delete