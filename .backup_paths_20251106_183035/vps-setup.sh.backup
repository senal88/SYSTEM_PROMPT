#!/bin/bash
#
# VPS Setup Script for 1Password Connect Server
# Transfers and configures the complete setup on Ubuntu VPS
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
VPS_HOST="luiz.sena88@147.79.81.59"
VPS_PATH="/home/luiz.sena88/Dotfiles/automation_1password"
LOCAL_PATH="/Users/luiz.sena88/Dotfiles/automation_1password"

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Check if SSH connection works
check_ssh() {
    print_header "Checking SSH Connection"
    
    if ssh -o ConnectTimeout=10 "$VPS_HOST" "echo 'SSH connection successful'" 2>/dev/null; then
        print_success "SSH connection to VPS working"
    else
        print_error "Cannot connect to VPS via SSH"
        print_info "Make sure your SSH key is configured and VPS is accessible"
        exit 1
    fi
}

# Install prerequisites on VPS
install_prerequisites() {
    print_header "Installing Prerequisites on VPS"
    
    ssh "$VPS_HOST" << 'EOF'
        echo "Updating package list..."
        sudo apt update -y
        
        echo "Installing Docker..."
        if ! command -v docker >/dev/null 2>&1; then
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo usermod -aG docker $USER
            rm get-docker.sh
        else
            echo "Docker already installed"
        fi
        
        echo "Installing Docker Compose..."
        if ! command -v docker-compose >/dev/null 2>&1; then
            sudo apt install -y docker-compose-plugin
        else
            echo "Docker Compose already installed"
        fi
        
        echo "Installing essential tools..."
        sudo apt install -y curl jq openssl git
        
        echo "Installing 1Password CLI..."
        if ! command -v op >/dev/null 2>&1; then
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
            echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
            sudo apt update
            sudo apt install -y 1password-cli
        else
            echo "1Password CLI already installed"
        fi
        
        echo "Prerequisites installation complete"
EOF
    
    print_success "Prerequisites installed on VPS"
}

# Transfer files to VPS
transfer_files() {
    print_header "Transferring Files to VPS"
    
    # Create directory structure
    ssh "$VPS_HOST" "mkdir -p $VPS_PATH/{connect,scripts,env,tokens,logs}"
    
    # Transfer main files
    print_info "Transferring docker-compose.yml..."
    scp "$LOCAL_PATH/connect/docker-compose.yml" "$VPS_HOST:$VPS_PATH/connect/"
    
    print_info "Transferring validate-and-deploy.sh..."
    scp "$LOCAL_PATH/connect/validate-and-deploy.sh" "$VPS_HOST:$VPS_PATH/connect/"
    ssh "$VPS_HOST" "chmod +x $VPS_PATH/connect/validate-and-deploy.sh"
    
    print_info "Transferring Makefile..."
    scp "$LOCAL_PATH/connect/Makefile" "$VPS_HOST:$VPS_PATH/connect/"
    
    print_info "Transferring .cursorrules..."
    scp "$LOCAL_PATH/connect/.cursorrules" "$VPS_HOST:$VPS_PATH/connect/"
    
    print_info "Transferring .gitignore..."
    scp "$LOCAL_PATH/connect/.gitignore" "$VPS_HOST:$VPS_PATH/connect/"
    
    # Transfer environment files
    print_info "Transferring environment files..."
    scp "$LOCAL_PATH/env/vps.env" "$VPS_HOST:$VPS_PATH/env/"
    scp "$LOCAL_PATH/env/shared.env" "$VPS_HOST:$VPS_PATH/env/"
    
    # Transfer scripts
    print_info "Transferring scripts..."
    scp "$LOCAL_PATH/scripts/setup-vps.sh" "$VPS_HOST:$VPS_PATH/scripts/" 2>/dev/null || true
    scp "$LOCAL_PATH/scripts/start-connect.sh" "$VPS_HOST:$VPS_PATH/scripts/" 2>/dev/null || true
    scp "$LOCAL_PATH/scripts/validate-setup.sh" "$VPS_HOST:$VPS_PATH/scripts/" 2>/dev/null || true
    
    # Make scripts executable
    ssh "$VPS_HOST" "chmod +x $VPS_PATH/scripts/*.sh 2>/dev/null || true"
    
    print_success "Files transferred successfully"
}

# Create VPS-specific environment file
create_vps_env() {
    print_header "Creating VPS Environment Configuration"
    
    ssh "$VPS_HOST" << 'EOF'
        cat > ~/Dotfiles/automation_1password/connect/.env << 'ENVEOF'
# 1Password Connect – VPS Ubuntu
OP_CONNECT_TOKEN=${OP_CONNECT_TOKEN_VPS}
OP_CONNECT_HOST=http://localhost:8080
OP_VAULT=1p_vps
ENVEOF
        
        chmod 600 ~/Dotfiles/automation_1password/connect/.env
        echo "VPS environment file created"
EOF
    
    print_success "VPS environment file created"
}

# Create VPS-specific docker-compose
create_vps_docker_compose() {
    print_header "Creating VPS Docker Compose Configuration"
    
    ssh "$VPS_HOST" << 'EOF'
        cat > ~/Dotfiles/automation_1password/connect/docker-compose.yml << 'COMPOSEEOF'
services:
  connect-api:
    image: 1password/connect-api:latest
    platform: linux/amd64
    container_name: op-connect-api
    restart: unless-stopped
    ports:
      - "8080:8080"
    environment:
      OP_CONNECT_TOKEN: ${OP_CONNECT_TOKEN}
    volumes:
      - ./data:/home/op/data
    networks: [connect_net]

  connect-sync:
    image: 1password/connect-sync:latest
    platform: linux/amd64
    container_name: op-connect-sync
    restart: unless-stopped
    environment:
      OP_CONNECT_TOKEN: ${OP_CONNECT_TOKEN}
    volumes:
      - ./data:/home/op/data
    networks: [connect_net]

networks:
  connect_net:
    driver: bridge
COMPOSEEOF
        
        echo "VPS docker-compose.yml created"
EOF
    
    print_success "VPS Docker Compose configuration created"
}

# Setup 1Password authentication on VPS
setup_1password_auth() {
    print_header "Setting up 1Password Authentication on VPS"
    
    print_info "You need to authenticate with 1Password on the VPS"
    print_info "Run the following command on the VPS:"
    echo ""
    echo "  ssh $VPS_HOST"
    echo "  eval \$(op signin)"
    echo "  op connect token create --name vps_connect_token --expiry 90d > ~/Dotfiles/automation_1password/tokens/vps_token.txt"
    echo "  chmod 600 ~/Dotfiles/automation_1password/tokens/vps_token.txt"
    echo ""
    
    read -p "Press Enter when you've completed the 1Password authentication..."
}

# Test the setup
test_setup() {
    print_header "Testing VPS Setup"
    
    ssh "$VPS_HOST" << 'EOF'
        cd ~/Dotfiles/automation_1password/connect
        
        echo "Testing Docker..."
        docker --version
        docker compose version
        
        echo "Testing 1Password CLI..."
        op --version
        
        echo "Testing file structure..."
        ls -la
        
        echo "Testing environment file..."
        if [ -f .env ]; then
            echo "Environment file exists"
        else
            echo "Environment file missing"
        fi
        
        echo "Testing docker-compose syntax..."
        docker compose config >/dev/null && echo "Docker Compose syntax OK" || echo "Docker Compose syntax error"
EOF
    
    print_success "VPS setup test completed"
}

# Main execution
main() {
    print_header "1Password Connect VPS Setup"
    
    check_ssh
    install_prerequisites
    transfer_files
    create_vps_env
    create_vps_docker_compose
    setup_1password_auth
    test_setup
    
    print_header "Setup Complete!"
    print_success "VPS setup completed successfully"
    print_info "Next steps:"
    echo "  1. SSH to VPS: ssh $VPS_HOST"
    echo "  2. Navigate to: cd ~/Dotfiles/automation_1password/connect"
    echo "  3. Run validation: ./validate-and-deploy.sh"
    echo "  4. Or use Makefile: make validate"
    echo ""
}

# Run main function
main "$@"
