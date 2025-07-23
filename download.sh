#!/bin/bash

# --- Configuration ---

# The URL of the GitHub repository to clone.
REPO_URL="https://github.com/andrinoff/wallpapers.git"

# The local directory where the wallpapers will be saved.
# The '~' will be expanded to your home directory.
WALLPAPERS_DIR="$HOME/wallpapers"

# A temporary directory to clone the repository into.
# This will be created in the current directory and removed after the script finishes.
TEMP_DIR="wallpapers_temp"


# --- Script Logic ---

# Function to print a message with a prefix.
log() {
  echo "[INFO] $1"
}

# 1. Check if git is installed.
if ! command -v git &> /dev/null
then
    echo "[ERROR] Git is not installed. Please install Git to continue."
    exit 1
fi

log "Starting the wallpaper download process..."

# 2. Create the wallpapers directory if it doesn't exist.
log "Checking if '$WALLPAPERS_DIR' exists..."
if [ ! -d "$WALLPAPERS_DIR" ]; then
    log "Directory not found. Creating '$WALLPAPERS_DIR'..."
    mkdir -p "$WALLPAPERS_DIR"
    log "Directory created successfully."
else
    log "Directory already exists."
fi

# 3. Clean up any previous temporary directory.
if [ -d "$TEMP_DIR" ]; then
    log "Removing previous temporary directory..."
    rm -rf "$TEMP_DIR"
fi

# 4. Clone the repository into the temporary directory.
log "Cloning the repository from $REPO_URL..."
git clone --depth 1 "$REPO_URL" "$TEMP_DIR"
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to clone the repository. Please check the URL and your internet connection."
    exit 1
fi
log "Repository cloned successfully."

# 5. Find and move the image files.
log "Searching for .png, .jpeg, and .jpg files..."
# The `find` command searches for files.
# -type f: only finds files (not directories).
# \( -iname "*.png" -o -iname "*.jpeg" -o -iname "*.jpg" \): finds files with these extensions (case-insensitive).
# -exec sh -c '...': executes a shell command for the found files. This is a portable way to move files to a directory.
find "$TEMP_DIR" -type f \( -iname "*.png" -o -iname "*.jpeg" -o -iname "*.jpg" \) -exec sh -c 'mv -v "$@" "$0"' "$WALLPAPERS_DIR" {} +

log "Files have been moved to '$WALLPAPERS_DIR'."

# 6. Clean up by removing the temporary directory.
log "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"
log "Cleanup complete."

echo -e "\n[SUCCESS] All wallpapers have been downloaded to '$WALLPAPERS_DIR'."
