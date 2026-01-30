#!/bin/bash
# run-local.sh - Run the locally built image
# Usage: ./run-local.sh

set -e

IMAGE_NAME="dorsma/docker-jupyter-islp"
VERSION="${1:-latest}"
PORT=8888

SCRIPTS="$(dirname "$(realpath "${BASH_SOURCE-$0}")")"
PROJ_HOME="$(dirname "$SCRIPTS")"
LABS_DIR="$PROJ_HOME/tests/ISLP_labs"

OUR_UID=$(id -u)
OUR_GID=$(id -g)

# Check if image exists
echo "Checking ${IMAGE_NAME}:${VERSION}..."
if ! docker image inspect ${IMAGE_NAME}:${VERSION} >/dev/null 2>&1; then
    echo "Error: Image ${IMAGE_NAME}:${VERSION} not found"
    if [ "$VERSION" == "latest" ]; then
        echo "Fetching the most recent build..."
        docker pull "$IMAGE_NAME:$VERSION"
    else
        echo "Run scripts/build-local.sh first"
        exit 1
    fi
fi

# Update submodule if it exists, clone if it doesn't
if git submodule status "$LABS_DIR" | grep -q "^ "; then
    echo "Submodule is initialized. Updating to latest remote head..."
    git submodule update --remote --merge "$LABS_DIR"
else
    echo "Submodule not found or not initialized. Setting it up..."
    git submodule update --init --recursive "$LABS_DIR"
fi

echo "Running ${IMAGE_NAME}:${VERSION} on port ${PORT}..."
docker run -it --rm \
    -p ${PORT}:8888 \
    -v $LABS_DIR:/home/jovyan/work \
    --shm-size 8G \
    --user root \
    -e NB_UID=$OUR_UID \
    -e NB_GID=$OUR_GID \
    -e CHOWN_HOME=yes \
    -e CHOWN_HOME_OPTS="-R" \
    ${IMAGE_NAME}:${VERSION}
