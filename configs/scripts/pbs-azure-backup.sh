#!/bin/bash
# Syncs a Proxmox Backup Server datastore to Azure Blob storage.
# Deploy to /usr/local/bin/ on your PBS host and run via cron.
# The SAS token file should be scoped to Read/Add/Create/Write/List only --
# deliberately NOT Delete, so this script can add new backups offsite but
# can never destroy what's already there, even if compromised or buggy.
set -euo pipefail

DATASTORE="/path/to/your/pbs/datastore"
SAS_FILE="/root/.azure_sas_token"
LOG="/var/log/pbs-azure-backup.log"

if [ ! -f "$SAS_FILE" ]; then
  echo "$(date -Is) ERROR: $SAS_FILE not found. Generate a SAS token (Read/Add/Create/Write/List, no Delete) for your target container and save it there first." >> "$LOG"
  exit 1
fi

SAS=$(cat "$SAS_FILE")
DEST="https://YOUR_STORAGE_ACCOUNT.blob.core.windows.net/YOUR_CONTAINER/pbs?${SAS}"

echo "$(date -Is) starting PBS to Azure copy" >> "$LOG"
azcopy copy "$DATASTORE" "$DEST" \
  --recursive \
  --overwrite=ifSourceNewer \
  --block-blob-tier=Cool \
  >> "$LOG" 2>&1
echo "$(date -Is) done, exit $?" >> "$LOG"
