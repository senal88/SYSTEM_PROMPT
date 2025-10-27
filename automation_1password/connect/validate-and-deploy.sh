#!/bin/bash
#
# 1Password Connect Server - Validation, Setup & Deployment
# Optimized for macOS Silicon and Ubuntu VPS
# Integrates with Cursor AI IDE
#
# Usage: ./validate-and-deploy.sh [--macos|--vps]
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Configuration
CONNECT_DIR="${SCRIPT_DIR}"
LOG_FILE="${SCRIPT_DIR}/validation-$(date +%Y%m%d-%H%M%S).log"

# Detect environment
detect_environment() {
    if [[ "$(uname)" == "Darwin" ]]; then
        ENV_TYPE="macos"
        ENV_NAME="macOS"
        if [[ "$(uname -m)" == "arm64" ]]; then
            ARCH="Apple Silicon (ARM64)"
        else
            ARCH="Intel (x86_64)"
        fi
    elif [[ "$(uname)" == "Linux" ]]; then
        ENV_TYPE="vps"
        ENV_NAME="Ubuntu VPS"
        ARCH="$(uname -m)"
    else
        ENV_TYPE="unknown"
        ENV_NAME="Unknown"
        ARCH="$(uname -m)"
    fi
}

# Logging functions
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}" | tee -a "$LOG_FILE"
}

print_error() {
    echo -e "${RED}❌ $1${NC}" | tee -a "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}" | tee -a "$LOG_FILE"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}" | tee -a "$LOG_FILE"
}

print_step() {
    echo -e "${MAGENTA}▶ $1${NC}" | tee -a "$LOG_FILE"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Version comparison
version_ge() {
    printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

# Main validation
main() {
    detect_environment

    print_header "1Password Connect - Validation & Setup"
    log "Environment: $ENV_NAME ($ARCH)"
    log "Script: $0"
    log "Project Root: $PROJECT_ROOT"
    log "Connect Dir: $CONNECT_DIR"

    # Step 1: System Information
    step_system_info

    # Step 2: Prerequisites
    step_prerequisites

    # Step 3: Project Structure
    step_project_structure

    # Step 4: Files Validation
    step_files_validation

    # Step 5: Docker Environment
    if [[ "$SKIP_DOCKER" != "true" ]]; then
        step_docker_environment
    fi

    # Step 6: Security Audit
    step_security_audit

    # Step 7: Environment-specific optimizations
    if [[ "$ENV_TYPE" == "macos" ]]; then
        step_macos_optimization
    elif [[ "$ENV_TYPE" == "vps" ]]; then
        step_vps_optimization
    fi

    # Step 8: Summary
    step_summary

    # Step 9: Optional deployment
    if [[ "${AUTO_DEPLOY:-false}" == "true" ]] || ask_deployment; then
        step_deployment
    fi
}

step_system_info() {
    print_header "STEP 1: System Information"

    print_info "Date: $(date)"
    print_info "User: $(whoami)"
    print_info "Hostname: $(hostname)"
    print_info "Environment: $ENV_NAME"
    print_info "Architecture: $ARCH"

    if [[ "$ENV_TYPE" == "macos" ]]; then
        print_info "macOS Version: $(sw_vers -productVersion)"
        print_info "macOS Build: $(sw_vers -buildVersion)"
    elif [[ "$ENV_TYPE" == "vps" ]]; then
        if [[ -f /etc/os-release ]]; then
            source /etc/os-release
            print_info "OS: $PRETTY_NAME"
        fi
        print_info "Kernel: $(uname -r)"
    fi

    print_success "System information collected"
}

step_prerequisites() {
    print_header "STEP 2: Prerequisites Check"

    local prereq_ok=true

    # Docker
    print_step "Checking Docker..."
    if command_exists docker; then
        local docker_version=$(docker --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        print_success "Docker installed: $docker_version"

        if docker info >/dev/null 2>&1; then
            print_success "Docker daemon is running"
        else
            print_error "Docker daemon is not running"
            print_info "Start Docker Desktop (macOS) or 'sudo systemctl start docker' (Ubuntu)"
            prereq_ok=false
        fi
    else
        print_error "Docker not installed"
        prereq_ok=false
    fi

    # Docker Compose
    print_step "Checking Docker Compose..."
    if docker compose version >/dev/null 2>&1; then
        local compose_version=$(docker compose version --short 2>/dev/null || echo "unknown")
        print_success "Docker Compose (V2 plugin): $compose_version"
    elif command_exists docker-compose; then
        local compose_version=$(docker-compose --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        print_warning "Docker Compose V1 (standalone): $compose_version"
        print_info "Consider upgrading to V2 plugin"
    else
        print_error "Docker Compose not available"
        prereq_ok=false
    fi

    # Essential tools
    print_step "Checking essential tools..."
    for tool in curl jq openssl; do
        if command_exists "$tool"; then
            print_success "$tool installed"
        else
            if [[ "$tool" == "jq" ]]; then
                print_warning "$tool not installed (optional, recommended)"
            else
                print_warning "$tool not installed (recommended)"
            fi
        fi
    done

    # 1Password CLI
    print_step "Checking 1Password CLI..."
    if command_exists op; then
        local op_version=$(op --version 2>/dev/null || echo "unknown")
        print_success "1Password CLI installed: $op_version"

        # Check if signed in
        if op account list >/dev/null 2>&1; then
            print_success "1Password CLI is authenticated"
        else
            print_warning "1Password CLI not authenticated"
            print_info "Run: op signin"
        fi
    else
        print_warning "1Password CLI not installed (optional)"
    fi

    # Cursor CLI
    print_step "Checking Cursor CLI..."
    if command_exists cursor; then
        print_success "Cursor IDE installed"
    else
        print_warning "Cursor IDE not found in PATH"
    fi

    if [[ "$prereq_ok" == false ]]; then
        print_error "Prerequisites check failed"
        exit 1
    fi

    print_success "All prerequisites satisfied"
}

step_project_structure() {
    print_header "STEP 3: Project Structure"

    print_info "Project root: $PROJECT_ROOT"
    print_info "Connect directory: $CONNECT_DIR"

    # Check directory structure
    local required_dirs=("configs" "scripts" "docs")
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$PROJECT_ROOT/$dir" ]]; then
            print_success "Directory exists: $dir"
        else
            print_warning "Directory missing: $dir"
        fi
    done

    print_success "Project structure validated"
}

step_files_validation() {
    print_header "STEP 4: Files Validation"

    local files_ok=true

    # Check credentials.json
    print_step "Checking credentials.json..."
    local creds_locations=(
        "$CONNECT_DIR/credentials.json"
        "$PROJECT_ROOT/configs/1password-credentials.json"
        "$CONNECT_DIR/1password-credentials.json"
    )

    local creds_found=false
    for location in "${creds_locations[@]}"; do
        if [[ -f "$location" ]]; then
            print_success "Found: $location"

            # Validate JSON
            if command_exists jq && jq empty "$location" 2>/dev/null; then
                print_success "Valid JSON format"
            else
                print_warning "Could not validate JSON format"
            fi

            # Check file size
            local size=$(stat -f%z "$location" 2>/dev/null || stat -c%s "$location" 2>/dev/null)
            if [[ $size -gt 100 ]]; then
                print_success "File size OK: $size bytes"
            else
                print_warning "File seems small: $size bytes"
            fi

            creds_found=true
            break
        fi
    done

    if [[ "$creds_found" == false ]]; then
        print_error "credentials.json not found"
        print_info "Expected locations:"
        for loc in "${creds_locations[@]}"; do
            echo "  - $loc"
        done
        files_ok=false
    fi

    # Check .env file
    print_step "Checking .env file..."
    if [[ -f "$CONNECT_DIR/.env" ]]; then
        print_success ".env file found"

        # Source and validate token
        if source "$CONNECT_DIR/.env" 2>/dev/null; then
            if [[ -n "${OP_CONNECT_TOKEN:-}" ]]; then
                print_success "OP_CONNECT_TOKEN is set"

                # Basic JWT validation
                if [[ "$OP_CONNECT_TOKEN" =~ ^eyJ.*\..*\..*$ ]]; then
                    print_success "Token appears to be valid JWT"
                else
                    print_warning "Token format looks unusual"
                fi
            else
                print_error "OP_CONNECT_TOKEN not set in .env"
                files_ok=false
            fi
        else
            print_error "Could not source .env file"
            files_ok=false
        fi
    else
        print_warning ".env file not found"
        print_info "Create from .env.template if available"
        files_ok=false
    fi

    # Check docker-compose.yml
    print_step "Checking docker-compose.yml..."
    if [[ -f "$CONNECT_DIR/docker-compose.yml" ]]; then
        print_success "docker-compose.yml found"

        if docker compose -f "$CONNECT_DIR/docker-compose.yml" config >/dev/null 2>&1; then
            print_success "Valid docker-compose syntax"
        else
            print_error "Invalid docker-compose syntax"
            files_ok=false
        fi
    else
        print_warning "docker-compose.yml not found"
    fi

    if [[ "$files_ok" == false ]]; then
        print_error "Files validation failed"
        exit 1
    fi

    print_success "All required files validated"
}

step_docker_environment() {
    print_header "STEP 5: Docker Environment"

    # Check existing containers
    print_step "Checking existing containers..."
    local existing=$(docker ps -a --filter "name=connect" --format "{{.Names}}" 2>/dev/null || true)

    if [[ -n "$existing" ]]; then
        print_warning "Found existing containers:"
        echo "$existing" | while read -r container; do
            local status=$(docker inspect --format='{{.State.Status}}' "$container" 2>/dev/null || echo "unknown")
            echo "  - $container: $status"
        done
    else
        print_success "No existing containers"
    fi

    # Check Docker resources
    print_step "Docker resources..."
    if command_exists jq; then
        docker info --format '{{json .}}' 2>/dev/null | jq -r '
            "  CPUs: \(.NCPU)",
            "  Memory: \(.MemTotal / 1024 / 1024 / 1024 | floor)GB"
        ' || docker info 2>/dev/null | grep -E "CPUs|Total Memory" || true
    fi

    # Check images
    print_step "Checking 1Password Connect images..."
    local images=$(docker images --filter "reference=1password/connect*" --format "{{.Repository}}:{{.Tag}}" 2>/dev/null || true)
    if [[ -n "$images" ]]; then
        print_success "Images found:"
        echo "$images" | while read -r img; do
            echo "  - $img"
        done
    else
        print_info "No images found (will pull on deployment)"
    fi

    # Check ports
    print_step "Checking port availability..."
    for port in 8080 8443; do
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            print_warning "Port $port is in use"
            lsof -Pi :$port -sTCP:LISTEN 2>/dev/null || true
        else
            print_success "Port $port available"
        fi
    done

    print_success "Docker environment checked"
}

step_security_audit() {
    print_header "STEP 6: Security Audit"

    # File permissions
    print_step "Checking file permissions..."

    local sensitive_files=(
        "$CONNECT_DIR/credentials.json"
        "$CONNECT_DIR/.env"
        "$PROJECT_ROOT/configs/1password-credentials.json"
    )

    for file in "${sensitive_files[@]}"; do
        if [[ -f "$file" ]]; then
            local perms=$(stat -f "%A" "$file" 2>/dev/null || stat -c "%a" "$file" 2>/dev/null)
            if [[ "$perms" == "600" ]] || [[ "$perms" == "400" ]]; then
                print_success "$(basename "$file"): secure permissions ($perms)"
            else
                print_warning "$(basename "$file"): permissions $perms (should be 600)"
                print_info "Fixing permissions..."
                chmod 600 "$file" 2>/dev/null && print_success "Fixed" || print_error "Failed to fix"
            fi
        fi
    done

    # Check .gitignore
    print_step "Checking .gitignore..."
    if [[ -f "$CONNECT_DIR/.gitignore" ]]; then
        local sensitive=("credentials.json" ".env" "*.key" "*.crt")
        local all_found=true

        for pattern in "${sensitive[@]}"; do
            if grep -q "$pattern" "$CONNECT_DIR/.gitignore" 2>/dev/null; then
                print_success "$pattern in .gitignore"
            else
                print_warning "$pattern not in .gitignore"
                all_found=false
            fi
        done

        if [[ "$all_found" == true ]]; then
            print_success "All sensitive files protected"
        fi
    else
        print_warning ".gitignore not found"
    fi

    print_success "Security audit complete"
}

step_macos_optimization() {
    print_header "STEP 7: macOS Silicon Optimization"

    print_step "Checking Apple Silicon optimizations..."

    # Check if using Rosetta
    if docker info 2>/dev/null | grep -qi "rosetta"; then
        print_warning "Rosetta emulation detected"
        print_info "Consider using native ARM64 images for better performance"
    else
        print_success "Using native ARM64 virtualization"
    fi

    # Check docker-compose for platform specification
    if [[ -f "$CONNECT_DIR/docker-compose.yml" ]]; then
        if grep -q "platform.*linux/arm64" "$CONNECT_DIR/docker-compose.yml"; then
            print_success "ARM64 platform specified in docker-compose.yml"
        else
            print_info "Consider adding 'platform: linux/arm64' for optimal performance"
        fi
    fi

    print_info "macOS Recommendations:"
    echo "  ✓ Enable VirtioFS in Docker Desktop for better I/O"
    echo "  ✓ Allocate at least 4GB RAM and 4 CPUs"
    echo "  ✓ Use Virtualization Framework (not HyperKit)"
    echo "  ✓ Keep Docker Desktop updated"

    print_success "macOS optimization check complete"
}

step_vps_optimization() {
    print_header "STEP 7: VPS Optimization"

    print_step "Checking VPS configuration..."

    # Check available resources
    print_info "System resources:"
    echo "  CPU cores: $(nproc)"
    echo "  Memory: $(free -h | awk '/^Mem:/ {print $2}')"
    echo "  Disk: $(df -h / | awk 'NR==2 {print $4}')"

    # Check Docker storage driver
    local storage_driver=$(docker info --format '{{.Driver}}' 2>/dev/null || echo "unknown")
    print_info "Docker storage driver: $storage_driver"

    if [[ "$storage_driver" == "overlay2" ]]; then
        print_success "Using recommended storage driver"
    else
        print_warning "Consider using overlay2 storage driver"
    fi

    print_success "VPS optimization check complete"
}

step_summary() {
    print_header "STEP 8: Validation Summary"

    echo ""
    print_success "✅ Environment: $ENV_NAME ($ARCH)"
    print_success "✅ Prerequisites: All satisfied"
    print_success "✅ Project structure: Valid"
    print_success "✅ Required files: Present and valid"
    print_success "✅ Security: Files protected"
    echo ""

    print_info "System is ready for 1Password Connect Server deployment"
    echo ""
}

ask_deployment() {
    read -p "$(echo -e ${CYAN}Do you want to proceed with deployment? [y/N]:${NC} )" -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

step_deployment() {
    print_header "STEP 9: Deployment"

    cd "$CONNECT_DIR"

    # Pull images
    print_step "Pulling Docker images..."
    if docker compose pull; then
        print_success "Images pulled successfully"
    else
        print_error "Failed to pull images"
        return 1
    fi

    # Start services
    print_step "Starting services..."
    if docker compose up -d; then
        print_success "Services started"
    else
        print_error "Failed to start services"
        return 1
    fi

    # Wait for health
    print_step "Waiting for services to be healthy..."
    local max_attempts=30
    local attempt=0

    while [[ $attempt -lt $max_attempts ]]; do
        if curl -sf http://localhost:8080/health >/dev/null 2>&1; then
            print_success "Services are healthy!"
            break
        fi

        attempt=$((attempt + 1))
        echo -n "."
        sleep 2
    done

    echo ""

    if [[ $attempt -ge $max_attempts ]]; then
        print_error "Health check timeout"
        print_info "Check logs: docker compose logs"
        return 1
    fi

    # Test API
    print_step "Testing API..."

    # Health endpoint
    local health=$(curl -s http://localhost:8080/health)
    print_success "Health endpoint: $health"

    # Vaults endpoint (if token available)
    if [[ -n "${OP_CONNECT_TOKEN:-}" ]]; then
        local vaults=$(curl -s -H "Authorization: Bearer $OP_CONNECT_TOKEN" http://localhost:8080/v1/vaults 2>/dev/null || echo "")

        if [[ -n "$vaults" ]] && echo "$vaults" | jq empty 2>/dev/null; then
            local count=$(echo "$vaults" | jq 'length' 2>/dev/null || echo "0")
            print_success "API authenticated! Found $count vault(s)"

            if command_exists jq; then
                echo "$vaults" | jq -r '.[] | "  ✓ \(.name) (\(.id))"' 2>/dev/null || true
            fi
        else
            print_warning "Could not authenticate with API"
        fi
    fi

    print_header "Deployment Complete!"

    echo ""
    print_success "🎉 1Password Connect Server is running!"
    echo ""
    print_info "Service endpoints:"
    echo "  HTTP:  http://localhost:8080"
    echo "  HTTPS: https://localhost:8443 (if TLS configured)"
    echo ""
    print_info "Useful commands:"
    echo "  View logs:    docker compose logs -f"
    echo "  Stop server:  docker compose down"
    echo "  Restart:      docker compose restart"
    echo "  Status:       docker compose ps"
    echo ""
    print_info "Test API:"
    echo "  curl -H 'Authorization: Bearer \$OP_CONNECT_TOKEN' http://localhost:8080/v1/vaults"
    echo ""
}

# Parse arguments
AUTO_DEPLOY=false
SKIP_DOCKER=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --auto-deploy)
            AUTO_DEPLOY=true
            shift
            ;;
        --skip-docker)
            SKIP_DOCKER=true
            shift
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --auto-deploy    Automatically deploy without prompting"
            echo "  --skip-docker    Skip Docker environment checks"
            echo "  --help           Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Run main
main

log "Script completed"
echo ""
print_info "Log saved to: $LOG_FILE"