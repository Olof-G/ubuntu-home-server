#!/bin/bash

ENV_FILE="/opt/docker/minecraft/backup.env"

if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "ERROR: env file not found at $ENV_FILE"
    exit 1
fi

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Store stdout (FD 1) and stderr (FD 2) in LOG_FILE
exec >> "$LOG_FILE" 2>&1
echo "=== Backup run started: $(date) ==="

# Prevent overlapping runs
exec 200>"$LOCK_FILE"   # LOCK_FILE: FD 200
if ! flock -n 200; then
    echo "Another backup is already running. Exiting."
    exit 1
fi

mkdir -p "$BACKUP_DIR"
cd "$COMPOSE_DIR" || exit 1

SERVER_STOPPED=0

# When script exits, server should be running
restart_server() {
    if [ "$SERVER_STOPPED" -eq 1 ]; then
        echo "Starting Minecraft server..."
        docker compose start mc
        SERVER_STOPPED=0
    fi
}
trap restart_server EXIT

echo "Sending MC-server warning..."
docker compose exec -T mc rcon-cli "say Server restarting for backup, downtime should be less than a minute."
sleep 5

echo "Stopping Minecraft server..."
if ! docker compose stop mc; then
    echo "ERROR: Failed to stop server, aborting backup (server left as-is)."
    exit 1
fi
SERVER_STOPPED=1

echo "Creating backup..."
ARCHIVE="$BACKUP_DIR/minecraft-$DATE.tar.gz"
if tar -czf "$ARCHIVE" -C "$SOURCE" .; then
    echo "Verifying archive integrity..."
    if ! tar -tzf "$ARCHIVE" >/dev/null; then
        echo "ERROR: Backup archive is corrupt! Removing bad file."
        rm -f "$ARCHIVE"
        restart_server
        exit 1
    fi
    echo "Backup created and verified successfully."
else
    echo "ERROR: Backup failed!"
    rm -f "$ARCHIVE"
    restart_server
    exit 1
fi

# Bring the server back up right away — don't make players wait on cleanup
restart_server

echo "Deleting backups older than 1 week..."
find "$BACKUP_DIR" -type f -name "minecraft-*.tar.gz" -mtime +7 -delete

echo "Backup complete: $(date)"