FROM quay.io/jupyter/minimal-notebook:python-3.12

# 1. Install system dependencies
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
USER ${NB_UID}

# 2. Copy and install Python requirements
COPY --chown=${NB_UID}:${NB_GID} tests/ISLP_labs/requirements.txt /tmp/requirements.txt
COPY --chown=${NB_UID}:${NB_GID} requirements-testing.txt /tmp/requirements-testing.txt

RUN pip install --no-cache-dir \
    -r /tmp/requirements.txt \
    -r /tmp/requirements-testing.txt \
    --default-timeout=1000

# COPY labs 
WORKDIR /home/jovyan/work
COPY --chown=${NB_UID}:${NB_GID} tests/ISLP_labs/ /home/jovyan/work/labs/

# EXPOSE and CMD are inherited from the base image, 
# but keeping them for clarity.
EXPOSE 8888
CMD ["start-notebook.py"]
