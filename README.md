# Jupyter Lab with ISLP

A Docker image based on `jupyter/scipy-notebook` optimized for the "An Introduction to Statistical Learning with Python" (ISLP) curriculum. 

This image comes pre-loaded with the [ISLP_labs](https://github.com/intro-stat-learning/ISLP_labs) and matches their **frozen environment** requirements to ensure all book exercises run perfectly.

## What's Included

The image includes the ISLP labs pre-installed in the `/home/jovyan/work/labs` directory and pins the following core dependencies:

* **Data Science:** `numpy==1.26.4`, `scipy==1.11.4`, `pandas==2.2.2`, `scikit-learn==1.5.0`
* **Deep Learning:** `torch==2.3.0`, `torchvision==0.18.0`, `pytorch-lightning==2.2.5`, `torchinfo==1.8.0`, `torchmetrics==1.4.0.post0`
* **Stats & Modeling:** `ISLP==0.4.0`, `statsmodels==0.14.2`, `lifelines==0.28.0`, `pygam==0.9.1`, `l0bnb==1.0.0`

## Project Structure

Inside the container, the workspace is organized as follows:
* `/home/jovyan/work/labs`: **Read-only** lab notebooks included in the image.
* `/home/jovyan/work/my-notebooks`: Your personal workspace (recommended mount point for persistence).

## Quick Start

### Pull from Docker Hub
```bash
docker pull dorsma/docker-jupyter-islp:latest
```

### Run Locally with Custom Password

Set JUPYTER_TOKEN to a password you can use to access your jupyter environment.

```bash
docker run -it --rm \
    -e JUPYTER_TOKEN=mysecrettoken \    
    -p 8888:8888 \
    -v $(pwd)/my-notebooks:/home/jovyan/work/my-notebooks \
    --shm-size 8G \
    --user root \
    -e NB_UID=$OUR_UID \
    -e NB_GID=$OUR_GID \
    -e CHOWN_HOME=yes \
    -e CHOWN_HOME_OPTS="-R" \
    dorsma/docker-jupyter-islp:latest
```

Access at: `http://localhost:8888/?token=mysecrettoken`.
Your notebooks will be saved in `$(pwd)/my-notebooks`

* **NOTE:** This runs as your user id and group id to help prevent permission errors. See [Jupyter Docker Stacks Troubleshooting Common Problems](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/troubleshooting.html#permission-denied-when-mounting-volumes) for more info.
* **NOTE (2):** This also uses ``--shm-size 8G` to avoid RuntimeError: unable to allocate shared memory(shm) errors. See [this thread](https://github.com/pytorch/pytorch/issues/2244#issuecomment-318864552) for more info.

## Running from Source with ISLP_labs notebooks
Clone this repository, which includes the ISLP_labs notebooks as a git submodule. 
```bash
git clone https://github.com/dorsma/docker-jupyter-islp.git
cd docker-jupyter-islp
scripts/run.sh
```

## Building from Source
```bash
git clone https://github.com/dorsma/docker-jupyter-islp.git
cd docker-jupyter-islp
scripts/build-local.sh
```

## Development Scripts

This repository includes helper scripts to streamline the build and publish workflow:

| Script | Description | Usage |
|--------|-------------|-------|
| `scripts/build-local.sh` | Build Docker image locally and optionally run it for testing | `./scripts/build-local.sh [--run]` |
| `scripts/publish.sh` | Build and push multi-platform Docker image to Docker Hub | `./scripts/publish.sh [version]` |
| `scripts/run-local.sh` | Run locally built Docker image | `./scripts/run-local.sh` |
| `scripts/run.sh` | Run Docker image | `./scripts/run.sh [tag]` |
| `scripts/test-local.sh` |  Test ISLP lab notebooks to verify all dependencies work | `./scripts/test-local.sh` |

## Environment Variables

* `JUPYTER_TOKEN`: Set a custom token for authentication.
* `JUPYTER_ENABLE_LAB`: Defaults to `yes`.
* `NUMBA_CACHE_DIR`: Set to `/tmp/numba_cache` to ensure Numba can write cache files in read-only environments.

## Resources

* [Official ISLP Book Site](https://www.statlearning.com/)
* [ISLP Documentation](https://intro-stat-learning.github.io/ISLP/)
* [ISLP_labs Source](https://github.com/intro-stat-learning/ISLP_labs)