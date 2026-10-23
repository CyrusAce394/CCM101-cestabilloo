#!/bin/bash
set -Eeuo pipefail
umask 077

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$PROJECT_DIR/backups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

cd "$PROJECT_DIR"

# Read protected database credentials
set -a
source "$PROJECT_DIR/.env"
set +a

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/database_$TIMESTAMP.sql"
TEMP_FILE="$BACKUP_FILE.tmp"

trap 'rm -f "$TEMP_FILE"' EXIT

echo "Starting MariaDB backup..."

docker compose exec -T \
  -e MYSQL_PWD="$DB_ROOT_PASSWORD" \
  db mariadb-dump \
  -u root \
  --single-transaction \
  "$DB_NAME" > "$TEMP_FILE"

test -s "$TEMP_FILE"
mv "$TEMP_FILE" "$BACKUP_FILE"

echo "Backup successful: $BACKUP_FILE"

# Delete SQL backups older than seven days
find "$BACKUP_DIR" -maxdepth 1 \
  -name 'database_*.sql' \
  -type f -mtime +7 -delete

echo "Backup operation completed."
