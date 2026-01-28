#!/bin/bash
set -e

# Configuration
IMAGE_NAME="yourusername/docker-jupyter-islp"
VERSION=${1:-"latest"}

echo "Building ${IMAGE_NAME}:${VERSION}..."

docker build -t ${IMAGE_NAME}:${VERSION} .

# Also tag as latest if building a version
if [ "$VERSION" != "latest" ]; then
    docker build -t ${IMAGE_NAME}:latest .
fi

echo "Build complete!"
echo "Image: ${IMAGE_NAME}:${VERSION}"
