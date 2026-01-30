# Jupyter Lab with ISLP

A Docker image based on `jupyter/scipy-notebook` with ISLP (Introduction to Statistical Learning with Python) and related packages pre-installed.

## What's Included

- JupyterLab (from base image)
- Scientific Python stack: NumPy, Pandas, SciPy, scikit-learn (from base image)
- **ISLP**: The companion package for "An Introduction to Statistical Learning"
- statsmodels: Statistical modeling and econometrics
- seaborn: Statistical data visualization

## Quick Start

### Pull from Docker Hub
```bash
docker pull dorsma/docker-jupyter-islp:latest
```

### Run Locally
```bash
docker run -p 8888:8888 \
  -v $(pwd)/notebooks:/home/jovyan/work \
  dorsma/docker-jupyter-islp:latest
```

Then open the URL with token that appears in the terminal output.

### Run with Custom Password
Note this runs as your user id and group id to help prevent permission errors. See [Jupyter Docker Stacks Troubleshooting Common Problems](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/troubleshooting.html#permission-denied-when-mounting-volumes) for more info.

```bash
docker run -it --rm \
    -p ${PORT}:8888 \
    -v $(pwd)/notebooks:/home/jovyan/work \
    --shm-size 8G \
    --user root \
    -e NB_UID=$OUR_UID \
    -e NB_GID=$OUR_GID \
    -e CHOWN_HOME=yes \
    -e CHOWN_HOME_OPTS="-R" \
    dorsma/docker-jupyter-islp:latest
```

Access at: `http://localhost:8888/?token=mysecrettoken`
Your notebooks will be saved in `$(pwd)/notebooks`

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

## Environment Variables

- `JUPYTER_TOKEN`: Set a custom token for authentication (default: auto-generated)
- `JUPYTER_ENABLE_LAB`: Set to `yes` to use JupyterLab (default in base image)

## Volumes

- `/home/jovyan/work`: Mount your notebooks here for persistence

## Development Scripts

This repository includes helper scripts to streamline the build and publish workflow:

| Script | Description | Usage |
|--------|-------------|-------|
| `scripts/build-local.sh` | Build Docker image locally and optionally run it for testing | `./scripts/build-local.sh [--run]` |
| `scripts/publish.sh` | Build and push multi-platform Docker image to Docker Hub | `./scripts/publish.sh [version]` |
| `scripts/run-local.sh` | Run locally built Docker image | `./scripts/run-local.sh` |
| `scripts/run.sh` | Run Docker image | `./scripts/run.sh [tag]` |
| `scripts/test-local.sh` |  Test ISLP lab notebooks to verify all dependencies work | `./scripts/test-local.sh` |

## Resources

- [ISLP Documentation](https://intro-stat-learning.github.io/ISLP/)
- [ISLP on PyPI](https://pypi.org/project/ISLP/)
- [Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/)
