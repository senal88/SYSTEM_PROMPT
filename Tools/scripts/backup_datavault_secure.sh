#!/bin/bash
# ==============================================================================
# DataVault Secure Backup Script - LS-EDIA Framework
# Creates a timestamped archive of $HOME/DataVault/secure into Backups/documents.
# Rotates archives older than 30 days to control disk usage.
# ==============================================================================

set -euo pipefail

SOURCE_DIR="$HOME/DataVault/secure"
DEST_DIR="$HOME/Backups/documents"
LOG_DIR="$HOME/Documentation/logs"
TIMESTAMP=$(date '+%Y%m%d%H%M%S')
BACKUP_ARCHIVE="$DEST_DIR/DataVault_secure_backup_${TIMESTAMP}.tar.gz"
BACKUP_LOG="$LOG_DIR/backup_datavault_secure_${TIMESTAMP}.log"

mkdir -p "$DEST_DIR"
mkdir -p "$LOG_DIR"

{
    echo "=================================================================="
    echo "Starting DataVault secure backup"
    echo "Date: $(date)"
    echo "Source: ${SOURCE_DIR}"
    echo "Destination archive: ${BACKUP_ARCHIVE}"
    echo "------------------------------------------------------------------"

    if [ ! -d "$SOURCE_DIR" ]; then
        echo "ERROR: source directory ${SOURCE_DIR} not found." >&2
        exit 1
    fi

    tar -czf "$BACKUP_ARCHIVE" -C "$SOURCE_DIR" .
    ARCHIVE_SIZE=$(du -h "$BACKUP_ARCHIVE" | awk '{print $1}')
    echo "Backup archive created successfully (${ARCHIVE_SIZE})."

    echo "Removing archives older than 30 days..."
    find "$DEST_DIR" -type f -name 'DataVault_secure_backup_*.tar.gz' -mtime +30 -print -delete

    echo "Backup run completed."
    echo "=================================================================="
} | tee "$BACKUP_LOG"
