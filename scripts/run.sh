#!/bin/bash
set -e

# Configuration
IMAGE_NAME="yourusername/docker-jupyter-islp"
VERSION=${1:-"latest"}
PORT=${2:-8888}

echo "Running ${IMAGE_NAME}:${VERSION} on port ${PORT}..."

docker run -it --rm \
    -p ${PORT}:8888 \
    -v $(pwd)/notebooks:/home/jovyan/work \
    ${IMAGE_NAME}:${VERSION}
