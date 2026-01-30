#!/bin/bash
# test.sh - Test ISLP lab notebooks to verify all dependencies work
# Clones/updates ISLP_labs repo and runs all Python notebooks through pytest
# Generates HTML report in test_reports/
# Usage: ./test-local.sh

set -e

IMAGE_NAME="dorsma/docker-jupyter-islp"
VERSION="local-build"

SCRIPTS="$(dirname "$(realpath "${BASH_SOURCE-$0}")")"
PROJ_HOME="$(dirname "$SCRIPTS")"
LABS_DIR="$PROJ_HOME/tests/ISLP_labs"
REPORTS_DIR="$PROJ_HOME/test_reports"

OUR_UID=$(id -u)
OUR_GID=$(id -g)

# Check if image exists
echo "Checking ${IMAGE_NAME}:${VERSION}..."
if ! docker image inspect ${IMAGE_NAME}:${VERSION} >/dev/null 2>&1; then
    echo "Error: Image ${IMAGE_NAME}:${VERSION} not found"
    echo "Run scripts/build-local.sh first"
    exit 1
fi

# Update submodule if it exists, clone if it doesn't
if git submodule status "$LABS_DIR" | grep -q "^ "; then
    echo "Submodule is initialized. Updating to latest remote head..."
    git submodule update --remote --merge "$LABS_DIR"
else
    echo "Submodule not found or not initialized. Setting it up..."
    git submodule update --init --recursive "$LABS_DIR"
fi

# Create reports directory
mkdir -p $REPORTS_DIR

echo "Running pytest on all .ipynb files in ${IMAGE_NAME}:${VERSION}..."

# Run pytest with nbmake inside the container
# Only test .ipynb files (Python notebooks, not R)
(
    set -x
    docker run --rm \
        -v $LABS_DIR:/home/jovyan/labs \
        -v $REPORTS_DIR:/home/jovyan/reports \
        --shm-size 8G \
        --user root \
        -e NB_UID=$OUR_UID \
        -e NB_GID=$OUR_GID \
        -e CHOWN_HOME=yes \
        -e CHOWN_HOME_OPTS="-R" \
        -e NUMBA_CACHE_DIR=/tmp/numba_cache \
        "${IMAGE_NAME}:${VERSION}" \
        bash -c "cd /home/jovyan/labs && ls -1 *.ipynb && pytest --nbmake *.ipynb --html=/home/jovyan/reports/test_report.html --self-contained-html"
)
echo ""
echo "✓ All notebooks executed successfully!"
echo "Report: $REPORTS_DIR/test_report.html"