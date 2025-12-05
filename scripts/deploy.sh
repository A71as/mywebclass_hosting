#!/bin/bash

# Deployment Script
# Use this for manual deployments or troubleshooting

set -e

echo "🚀 Starting deployment..."
echo ""

# Configuration
PROJECT_DIR="$HOME/mywebclass_hosting"
STATIC_SITE_DIR="$PROJECT_DIR/static-site"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Functions
print_step() {
    echo -e "${BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if running on server
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory not found at $PROJECT_DIR"
    echo "Please run this script on the server or update PROJECT_DIR variable"
    exit 1
fi

# Navigate to project directory
print_step "Navigating to project directory..."
cd "$PROJECT_DIR"
print_success "In $PROJECT_DIR"
echo ""

# Pull latest code
print_step "Pulling latest code from GitHub..."
git fetch origin
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch: $CURRENT_BRANCH"
git pull origin "$CURRENT_BRANCH"
print_success "Code updated"
echo ""

# Deploy static site
print_step "Deploying static site..."
cd "$STATIC_SITE_DIR"

if [ -f "docker-compose.yml" ]; then
    # Stop old containers
    print_step "Stopping old containers..."
    docker compose down
    
    # Pull latest images
    print_step "Pulling latest Docker images..."
    docker compose pull
    
    # Start containers
    print_step "Starting containers..."
    docker compose up -d
    
    print_success "Static site deployed"
else
    print_warning "No docker-compose.yml found in $STATIC_SITE_DIR"
fi
echo ""

# Wait for services to start
print_step "Waiting for services to start..."
sleep 5
print_success "Services started"
echo ""

# Health check
print_step "Running health checks..."
cd "$PROJECT_DIR/static-site"
if docker compose ps | grep -q "Up"; then
    print_success "Containers are running"
else
    echo "Warning: Some containers may not be running"
    docker compose ps
fi
echo ""

# Test static site
print_step "Testing static site..."
if curl -f http://localhost > /dev/null 2>&1; then
    print_success "Static site is responding"
else
    print_warning "Static site may not be accessible"
fi
echo ""

# Show running containers
print_step "Running containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Cleanup old images
print_step "Cleaning up old Docker images..."
docker image prune -f > /dev/null
print_success "Cleanup complete"
echo ""

# Set permissions
print_step "Setting correct permissions..."
if [ -d "$STATIC_SITE_DIR/html" ]; then
    sudo chown -R www-data:www-data "$STATIC_SITE_DIR/html" 2>/dev/null || true
    sudo chmod -R 755 "$STATIC_SITE_DIR/html" 2>/dev/null || true
    print_success "Permissions set"
fi
echo ""

echo "========================================="
echo "✅ Deployment completed successfully!"
echo "========================================="
echo ""
echo "Next steps:"
echo "  - Visit http://your-server-ip to verify"
echo "  - Check logs: docker compose logs -f"
echo "  - Monitor: docker stats"
echo ""
