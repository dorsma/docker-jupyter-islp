#!/bin/bash
# build-local.sh - Build Docker image locally and optionally run it for testing
# Builds for your current platform only (arm64 on M2, amd64 on x86)
# Usage: ./build-local.sh

set -e

SCRIPTS="$(dirname "$(realpath "${BASH_SOURCE-$0}")")"
PROJ_HOME="$(dirname "$SCRIPTS")"
LABS_DIR="$PROJ_HOME/tests/ISLP_labs"

IMAGE_NAME="dorsma/docker-jupyter-islp"
VERSION="local-build"

# Update submodule if it exists, clone if it doesn't
if git submodule status "$LABS_DIR" | grep -q "^ "; then
    echo "Submodule is initialized. Updating to latest remote head..."
    git submodule update --remote --merge "$LABS_DIR"
else
    echo "Submodule not found or not initialized. Setting it up..."
    git submodule update --init --recursive "$LABS_DIR"
fi

cd $PROJ_HOME

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