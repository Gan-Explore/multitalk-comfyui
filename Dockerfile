FROM ghcr.io/gan-explore/multitalk-comfyui-base:1.1.8

# --------------------------------------------------
# Install Jupyter into venv
# --------------------------------------------------
RUN /opt/app/.venv/bin/pip install --no-cache-dir \
    jupyterlab==4.1.6 \
    ipykernel==6.29.3

# --------------------------------------------------
# Prepare workspace mounts
# --------------------------------------------------
RUN mkdir -p /workspace/models /workspace/output && \
    ln -s /workspace/models /opt/app/ComfyUI/models && \
    ln -s /workspace/output /opt/app/ComfyUI/output

EXPOSE 8188 8888

# --------------------------------------------------
# Start services
# --------------------------------------------------
CMD ["/bin/bash", "-c", "\
  echo 'Using Python:' && \
  /opt/app/.venv/bin/python --version && \
  echo 'Starting JupyterLab on :8888' && \
  /opt/app/.venv/bin/jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root & \
  echo 'Starting ComfyUI on :8188' && \
  cd /opt/app/ComfyUI && \
  /opt/app/.venv/bin/python main.py --listen 0.0.0.0 --port 8188 \
"]
