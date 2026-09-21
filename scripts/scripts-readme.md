# Automated script setup
Notes realted to the contents of the script and setting it up

## minecraft-backup
- Uses variables from opt/docker/minecraft/backup.env 
- Make sure the user executing the script has ownership of, or permission to create, the backup directory (i.e. BACKUP_DIR)
- Script is run by cron daily (0 0 * * * /path-to-script/backup-minecraft.sh)