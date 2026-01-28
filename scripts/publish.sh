#!/bin/bash
set -e

# Configuration
IMAGE_NAME="yourusername/docker-jupyter-islp"
VERSION=${1:-"latest"}

echo "Publishing ${IMAGE_NAME}:${VERSION}..."

# Login check
if ! docker info | grep -q "Username"; then
    echo "Not logged in to Docker Hub. Please run: docker login"
    exit 1
fi

# Push the version
docker push ${IMAGE_NAME}:${VERSION}

# If pushing a version tag, also push latest
if [ "$VERSION" != "latest" ]; then
    docker push ${IMAGE_NAME}:latest
fi

echo "Published successfully!"
echo "View at: https://hub.docker.com/r/${IMAGE_NAME}"
