#!/bin/bash

# Script to copy API JSON files to the app bundle during build
# This ensures the app has bundled data available on first launch

set -e

echo "🔄 Copying API data to app bundle..."

# Source directory containing JSON files
API_SOURCE_DIR="${SRCROOT}/api"

# Destination directory in the app bundle
API_BUNDLE_DIR="${BUILT_PRODUCTS_DIR}/${CONTENTS_FOLDER_PATH}/api"

# Create the destination directory if it doesn't exist
mkdir -p "${API_BUNDLE_DIR}"

# Copy all JSON files from api directory to bundle
if [ -d "${API_SOURCE_DIR}" ]; then
    # Copy JSON files only
    find "${API_SOURCE_DIR}" -name "*.json" -not -path "*/examples/*" | while read -r file; do
        # Get relative path from api directory
        relative_path="${file#${API_SOURCE_DIR}/}"
        destination="${API_BUNDLE_DIR}/${relative_path}"
        
        # Create subdirectories if needed
        mkdir -p "$(dirname "${destination}")"
        
        # Copy file
        cp "${file}" "${destination}"
        echo "📄 Copied: ${relative_path}"
    done
    
    # Copy image files
    find "${API_SOURCE_DIR}" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.svg" \) | while read -r file; do
        # Get relative path from api directory
        relative_path="${file#${API_SOURCE_DIR}/}"
        destination="${API_BUNDLE_DIR}/${relative_path}"
        
        # Create subdirectories if needed
        mkdir -p "$(dirname "${destination}")"
        
        # Copy file
        cp "${file}" "${destination}"
        echo "🖼️  Copied: ${relative_path}"
    done
    
    echo "✅ Successfully copied API data to app bundle"
else
    echo "⚠️  Warning: API source directory not found at ${API_SOURCE_DIR}"
fi