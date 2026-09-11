#!/bin/bash

SOURCE="/srv/minecraft"
BACKUP_DIR="/srv/minecraft-backups"
COMPOSE_DIR="/opt/docker/minecraft"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$BACKUP_DIR"

cd "$COMPOSE_DIR" || exit 1

echo "Sending MC-server warning..."
sudo docker compose exec -T mc rcon-cli "say Server restarting for backup in 5 seconds..."

sleep 5

echo "Stopping Minecraft server..."
sudo docker compose stop mc

# protected by the restart handler.
restart_server() {
    echo "Starting Minecraft server..."
    sudo docker compose start mc
}

trap restart_server EXIT

echo "Creating backup..."
if tar -czf "$BACKUP_DIR/minecraft-$DATE.tar.gz" \
    -C "$SOURCE" .; then

    echo "Backup created successfully."

else

    echo "ERROR: Backup failed!"
    exit 1

fi

echo "Deleting backups older than 1 week..."
find "$BACKUP_DIR" \
    -type f \
    -name "minecraft-*.tar.gz" \
    -mtime +7 \
    -delete

echo "Backup complete."