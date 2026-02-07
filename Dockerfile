FROM ghcr.io/gan-explore/multitalk-comfyui-base:v1.4.8

# --------------------------------------------------
# Jupyter (auth disabled)
# --------------------------------------------------
RUN /opt/app/.venv/bin/pip install --no-cache-dir \
    jupyterlab==4.1.6 \
    ipykernel==6.29.3

# --------------------------------------------------
# Prepare persistent workspace directories
# --------------------------------------------------
RUN mkdir -p \
    /workspace/models \
    /workspace/output \
    /workspace/custom_nodes \
    /workspace/user

EXPOSE 8188 8888

# --------------------------------------------------
# Startup (appliance-grade, idempotent)
# --------------------------------------------------
CMD ["/bin/bash", "-c", "\
  set -e && \
  echo 'Initializing ComfyUI persistent directories...' && \
  \
  mkdir -p /workspace/user /workspace/models /workspace/output /workspace/custom_nodes && \
  \
  if [ ! -L /opt/app/ComfyUI/user ]; then \
    if [ -d /opt/app/ComfyUI/user ]; then \
      mv /opt/app/ComfyUI/user/* /workspace/user/ 2>/dev/null || true; \
      rm -rf /opt/app/ComfyUI/user; \
    fi; \
    ln -s /workspace/user /opt/app/ComfyUI/user; \
  fi && \
  \
  if [ ! -L /opt/app/ComfyUI/models ]; then \
    rm -rf /opt/app/ComfyUI/models; \
    ln -s /workspace/models /opt/app/ComfyUI/models; \
  fi && \
  \
  if [ ! -L /opt/app/ComfyUI/output ]; then \
    rm -rf /opt/app/ComfyUI/output; \
    ln -s /workspace/output /opt/app/ComfyUI/output; \
  fi && \
  \
  if [ ! -L /opt/app/ComfyUI/custom_nodes ]; then \
    rm -rf /opt/app/ComfyUI/custom_nodes; \
    ln -s /workspace/custom_nodes /opt/app/ComfyUI/custom_nodes; \
  fi && \
  \
  echo 'Persistent directories ready.' && \
  echo 'Python:' && /opt/app/.venv/bin/python --version && \
  \
  echo 'Starting JupyterLab (no auth) on :8888' && \
  /opt/app/.venv/bin/jupyter lab \
    --ip=0.0.0.0 \
    --port=8888 \
    --no-browser \
    --allow-root \
    --NotebookApp.token='' \
    --NotebookApp.password='' & \
  \
  echo 'Starting ComfyUI on :8188' && \
  cd /opt/app/ComfyUI && \
  exec /opt/app/.venv/bin/python main.py --listen 0.0.0.0 --port 8188 \
"]
