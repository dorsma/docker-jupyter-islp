#!/bin/bash
# build-local.sh - Build Docker image locally and optionally run it for testing
# Builds for your current platform only (arm64 on M2, amd64 on x86)
# Usage: ./build-local.sh

set -e

SCRIPTS="$(dirname "$(realpath "${BASH_SOURCE-$0}")")"

IMAGE_NAME="dorsma/docker-jupyter-islp"
VERSION="local-build"

echo "Building ${IMAGE_NAME}:${VERSION} locally..."

docker build -t ${IMAGE_NAME}:${VERSION} .

echo "Build complete!"
echo "Image: ${IMAGE_NAME}:${VERSION}"
echo ""

# run if --run flag is passed
if [ "$1" == "--run" ]; then
    echo "Running ${IMAGE_NAME}:${VERSION} on port ${PORT}..."
    $SCRIPTS/run-local.sh
fi