#!/bin/bash

# Check for changes in the Git repository
if git status --porcelain | grep -q .; then
    echo "Changes found in the Git repository:"
    git status --short

    read -p "Do you want to commit the changes? (yes/no): " commit_choice

    if [[ "$commit_choice" == "yes" ]]; then
        read -p "Enter commit message: " commit_message
        git add .
        git commit -m "$commit_message"
        git push

        # Copy .sh files to deploy/ folder
        mkdir -p deploy/
        cp src/*.sh deploy/

        # Log deployment
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        changed_files=$(git diff --name-only HEAD~1 HEAD) # Get files changed in the last commit
        echo "$timestamp - Deployed files: $changed_files" >> logs/deploy.log
        echo "Changes committed, pushed, and deployed."
    else
        echo "Commit aborted."
    fi
else
echo "No changes to deploy."
fi

