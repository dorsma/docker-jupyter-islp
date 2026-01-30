FROM quay.io/jupyter/pytorch-notebook:latest

# Switch to root to install system packages if needed
USER root

# Install any system dependencies here if required
# RUN apt-get update && apt-get install -y <package> && rm -rf /var/lib/apt/lists/*

# Switch back to the notebook user
USER ${NB_UID}

# Copy requirements file
COPY requirements.txt /tmp/requirements.txt

# We're going to need setuptools
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
USER ${NB_UID}

# Install Python packages
RUN pip install --no-cache-dir -r /tmp/requirements.txt --default-timeout=1000

# Set working directory
WORKDIR /home/jovyan/work

# Expose Jupyter port
EXPOSE 8888

# Default command (inherited from base image, but explicit here)
CMD ["start-notebook.py"]
