#!/bin/bash

LOG_DIR="$HOME/log_pipeline/logs"
ARCHIVE_DIR="$HOME/log_pipeline/archive"
GIT_REPO="$HOME/log_pipeline/git-repo"
DATE=$(date +"%Y-%m-%d")
ARCHIVE_FILE="logs_$DATE.tar.gz"

mkdir -p "$LOG_DIR" "$ARCHIVE_DIR"
mkdir -p /home/ec2-user/log_pipeline
cd /home/ec2-user/log_pipeline
git clone https://github.com/rakshithmj21/c-project.git 

echo "[INFO] Archiving logs older than 1 day..."
find "$LOG_DIR" -type f -mtime +0 -print0 | tar -czvf "$ARCHIVE_DIR/$ARCHIVE_FILE" --null -T -

# Only delete if archive was successful
if [ -f "$ARCHIVE_DIR/$ARCHIVE_FILE" ]; then
    find "$LOG_DIR" -type f -mtime +0 -delete
    cp "$ARCHIVE_DIR/$ARCHIVE_FILE" "$GIT_REPO/"
    cd "$GIT_REPO" || exit 1
    git add "$ARCHIVE_FILE"
    git commit -m "Archived logs for $DATE"
    git push origin main  # change if your branch is 'master'
    echo "[INFO] Log pipeline executed successfully."
else
    echo "[ERROR] Archive failed. Skipping deletion and Git push."
fi

