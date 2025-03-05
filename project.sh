#!/bin/bash

# Define the base directory
BASE_DIR="jee-main-rag"

# Create the directory structure with debug messages
echo "Creating project structure..."

mkdir -p $BASE_DIR/backend/app/core \
         $BASE_DIR/backend/app/api/endpoints \
         $BASE_DIR/backend/app/models \
         $BASE_DIR/backend/tests \
         $BASE_DIR/frontend/app/pages \
         $BASE_DIR/frontend/tests \
         $BASE_DIR/data

# Check if directories were created
if [ -d "$BASE_DIR" ]; then
    echo "✅ Directories created successfully!"
else
    echo "❌ Failed to create directories!"
    exit 1
fi

# Create files in the backend
touch $BASE_DIR/backend/app/core/config.py \
      $BASE_DIR/backend/app/core/rag_service.py \
      $BASE_DIR/backend/app/api/endpoints/qa.py \
      $BASE_DIR/backend/app/api/endpoints/health.py \
      $BASE_DIR/backend/app/models/schemas.py \
      $BASE_DIR/backend/app/Dockerfile \
      $BASE_DIR/backend/app/main.py \
      $BASE_DIR/backend/app/requirements.txt

# Create files in the frontend
touch $BASE_DIR/frontend/app/pages/.gitkeep \
      $BASE_DIR/frontend/app/main.py \
      $BASE_DIR/frontend/app/requirements.txt \
      $BASE_DIR/frontend/Dockerfile

# Create other project files
touch $BASE_DIR/docker-compose.yml \
      $BASE_DIR/.env \
      $BASE_DIR/README.md

echo "✅ All files created successfully!"
