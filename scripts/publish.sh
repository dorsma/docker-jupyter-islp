#!/bin/bash
# publish.sh - Build and push multi-platform Docker image to Docker Hub
# Builds for both arm64 (Apple Silicon) and amd64 (x86) platforms
# Automatically pushes to Docker Hub (required for multi-platform builds)
# Usage: ./publish.sh [version]
#   ./publish.sh          # publishes latest
#   ./publish.sh v1.2.3   # publishes v1.2.3 and latest

set -e

IMAGE_NAME="dorsma/docker-jupyter-islp"
VERSION=${1:-"latest"}

echo "Building and pushing ${IMAGE_NAME}:${VERSION} for multiple platforms..."

# Login check
if ! docker info | grep -q "Username"; then
    echo "Not logged in to Docker Hub. Attempting to login..."
    if ! docker login; then
        echo "Login failed. Cannot proceed with push."
        exit 1
    fi
fi

if [ "$VERSION" != "latest" ]; then
    TAGS="-t ${IMAGE_NAME}:${VERSION} -t ${IMAGE_NAME}:latest"
else
    TAGS="-t ${IMAGE_NAME}:latest"
fi

docker buildx build \
    --platform linux/amd64,linux/arm64 \
    ${TAGS} \
    --push \
    .

echo "Published successfully!"
echo "View at: https://hub.docker.com/r/${IMAGE_NAME}"
echo "Platforms: linux/amd64, l