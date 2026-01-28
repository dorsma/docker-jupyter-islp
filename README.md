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
docker pull yourusername/jupyter-islp:latest
```

### Run Locally
```bash
docker run -p 8888:8888 \
  -v $(pwd)/notebooks:/home/jovyan/work \
  yourusername/jupyter-islp:latest
```

Then open the URL with token that appears in the terminal output.

### Run with Custom Password
```bash
docker run -p 8888:8888 \
  -e JUPYTER_TOKEN=mysecrettoken \
  -v $(pwd)/notebooks:/home/jovyan/work \
  yourusername/jupyter-islp:latest
```

Access at: `http://localhost:8888/?token=mysecrettoken`

## Building from Source
```bash
git clone https://github.com/yourusername/jupyter-islp.git
cd jupyter-islp
docker build -t yourusername/jupyter-islp:latest .
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
| `scripts/build.sh` | Build the Docker image with proper tagging | `./scripts/build.sh [version]` |
| `scripts/run.sh` | Run the container locally for testing | `./scripts/run.sh [version] [port]` |
| `scripts/publish.sh` | Push the image to Docker Hub | `./scripts/publish.sh [version]` |

## Resources

- [ISLP Documentation](https://intro-stat-learning.github.io/ISLP/)
- [ISLP on PyPI](https://pypi.org/project/ISLP/)
- [Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/)
