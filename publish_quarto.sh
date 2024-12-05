#!/bin/bash

# Check if the commit message is provided
if [ -z "$1" ]; then
  echo "Please provide a commit message."
  exit 1
fi

# Define log_message function
log_message() {
    local message="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[${timestamp}] ${message}" >> log.txt
}

# Commit the changes with the provided message
if git add . && git commit -m "$1"; then
  log_message "Git commit successful: $1"
else
  log_message "Git commit failed"
  exit 1
fi

# Push the changes to the main branch
if git push origin main; then
  log_message "Pushed changes to main branch"
else
  log_message "Git push failed"
  exit 1
fi

# Publish to GitHub Pages using quarto
if quarto publish gh-pages --no-render --no-prompt; then
  log_message "GitHub Pages deployment completed successfully."
else
  log_message "GitHub Pages deployment failed"
  exit 1
fi
