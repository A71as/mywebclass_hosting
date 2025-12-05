#!/bin/bash

# Backup Script
# Run this regularly to backup important data

set -e

# Configuration
BACKUP_DIR="$HOME/backups"
PROJECT_DIR="$HOME/mywebclass_hosting"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_${DATE}.tar.gz"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "🗂️  Starting backup..."
echo "Date: $(date)"
echo "Backup location: $BACKUP_DIR/$BACKUP_NAME"
echo ""

# Backup static site
echo "📦 Backing up static site..."
cd "$PROJECT_DIR"
tar -czf "$BACKUP_DIR/$BACKUP_NAME" \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='*.log' \
    static-site/

echo "✅ Backup created: $BACKUP_NAME"
echo "Size: $(du -h $BACKUP_DIR/$BACKUP_NAME | cut -f1)"
echo ""

# Keep only last 7 backups
echo "🧹 Cleaning old backups (keeping last 7)..."
cd "$BACKUP_DIR"
ls -t backup_*.tar.gz | tail -n +8 | xargs -r rm
echo "Old backups removed"
echo ""

echo "📊 Current backups:"
ls -lh "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null || echo "No backups found"
echo ""

echo "✅ Backup completed successfully!"
