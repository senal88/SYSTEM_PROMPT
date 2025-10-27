#!/bin/bash
# Create compressed backup on external SSD
BASE_DIR="/Users/luiz.sena88/Dotfiles"
NOW=$(date +"%Y-%m-%d-%H%M")
BACKUP_DEST="/Volumes/SSD_Externo/dotfiles_backups/backup_$NOW"
mkdir -p "$BACKUP_DEST"
tar -czf "$BACKUP_DEST/dotfiles_backup_$NOW.tar.gz" -C "$BASE_DIR" .

echo "Backup created on $(date)" >> "$BASE_DIR/organizer.log"
