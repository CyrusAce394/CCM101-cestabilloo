
#!/bin/bash
# CloudNova Enterprise Web Portal
# Automated MySQL Database Backup Script

set -euo pipefail

PROJECT_DIR="/home/cloudnovaadmin/cloudnova-enterprise"
BACKUP_DIR="$PROJECT_DIR/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP_FILE="$BACKUP_DIR/mysql_backup_$TIMESTAMP.sql.gz"
TEMP_FILE="${BACKUP_FILE}.tmp"

cd "$PROJECT_DIR"

mkdir -p "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"

trap 'rm -f "$TEMP_FILE"' EXIT

echo "Starting CloudNova MySQL database backup..."

# Read the private database password
DB_PASSWORD=$(sed -n 's/^DB_PASSWORD=//p' .env)

if [ -z "$DB_PASSWORD" ]; then
    echo "ERROR: Database password not found."
    exit 1
fi

# Export and compress the MySQL database
docker compose exec -T \
    -e MYSQL_PWD="$DB_PASSWORD" \
    database \
    mysqldump --single-transaction --no-tablespaces \
    -u wordpressuser wordpress \
    | gzip > "$TEMP_FILE"

# Verify compressed archive
gzip -t "$TEMP_FILE"

# Verify the archive is not empty
if [ ! -s "$TEMP_FILE" ]; then
    echo "ERROR: Backup file is empty."
    exit 1
fi

# Save only a successful backup
mv "$TEMP_FILE" "$BACKUP_FILE"
chmod 600 "$BACKUP_FILE"

echo "Backup completed successfully!"
echo "Saved to: $BACKUP_FILE"
