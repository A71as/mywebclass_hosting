#!/bin/bash

# Server Health Check Script
# Run this regularly to monitor server health

set -e

echo "========================================="
echo "Server Health Check - $(date)"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# System Information
echo "📊 System Information:"
echo "-------------------"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"
echo "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
echo ""

# Disk Usage
echo "💾 Disk Usage:"
echo "-------------------"
df -h / | tail -1 | awk '{
    if ($5+0 > 90)
        printf "\033[0;31m%s\033[0m\n", $0
    else if ($5+0 > 75)
        printf "\033[1;33m%s\033[0m\n", $0
    else
        printf "\033[0;32m%s\033[0m\n", $0
}'
echo ""

# Memory Usage
echo "🧠 Memory Usage:"
echo "-------------------"
free -h | grep "Mem:" | awk '{
    used = $3
    total = $2
    percent = ($3/$2) * 100
    if (percent > 90)
        printf "\033[0;31m"
    else if (percent > 75)
        printf "\033[1;33m"
    else
        printf "\033[0;32m"
    printf "Used: %s / %s (%.1f%%)\033[0m\n", used, total, percent
}'
echo ""

# Docker Status
echo "🐳 Docker Containers:"
echo "-------------------"
if command -v docker &> /dev/null; then
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | head -n 10
    echo ""
    echo "Total containers running: $(docker ps -q | wc -l)"
else
    echo "Docker not installed"
fi
echo ""

# Network Status
echo "🌐 Network Connectivity:"
echo "-------------------"
if ping -c 1 google.com &> /dev/null; then
    echo -e "${GREEN}✓${NC} Internet connection: OK"
else
    echo -e "${RED}✗${NC} Internet connection: FAILED"
fi
echo ""

# Firewall Status
echo "🔥 Firewall Status:"
echo "-------------------"
if command -v ufw &> /dev/null; then
    sudo ufw status | head -3
else
    echo "UFW not installed"
fi
echo ""

# Failed Login Attempts
echo "🔒 Security - Recent Failed Logins:"
echo "-------------------"
if [ -f /var/log/auth.log ]; then
    sudo grep "Failed password" /var/log/auth.log | tail -5 || echo "No failed login attempts"
else
    echo "Auth log not found"
fi
echo ""

# Docker Resource Usage
echo "📈 Docker Resource Usage:"
echo "-------------------"
if command -v docker &> /dev/null; then
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" | head -n 10
fi
echo ""

# SSL Certificate Status (if using Caddy)
echo "🔐 SSL Certificate:"
echo "-------------------"
if docker ps | grep -q caddy; then
    echo "Caddy is running (SSL auto-managed)"
else
    echo "Caddy not running"
fi
echo ""

# System Updates
echo "📦 System Updates:"
echo "-------------------"
if command -v apt &> /dev/null; then
    updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable || echo "0")
    if [ "$updates" -gt 0 ]; then
        echo -e "${YELLOW}$updates${NC} updates available"
    else
        echo -e "${GREEN}✓${NC} System up to date"
    fi
fi
echo ""

echo "========================================="
echo "Health check completed at $(date)"
echo "========================================="
