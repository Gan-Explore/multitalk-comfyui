FROM ghcr.io/gan-explore/multitalk-comfyui-base:v1.4.2

# --------------------------------------------------
# Jupyter (auth disabled)
# --------------------------------------------------
RUN /opt/app/.venv/bin/pip install --no-cache-dir \
    jupyterlab==4.1.6 \
    ipykernel==6.29.3

# --------------------------------------------------
# RunPod-safe workspace
# --------------------------------------------------
RUN mkdir -p /workspace/models /workspace/output && \
    ln -s /workspace/models /opt/app/ComfyUI/models && \
    ln -s /workspace/output /opt/app/ComfyUI/output

EXPOSE 8188 8888

# --------------------------------------------------
# Start services (NO JUPYTER TOKEN / PASSWORD)
# --------------------------------------------------
CMD ["/bin/bash", "-c", "\
  echo 'Python:' && /opt/app/.venv/bin/python --version && \
  echo 'Starting JupyterLab (no auth) :8888' && \
  /opt/app/.venv/bin/jupyter lab \
    --ip=0.0.0.0 \
    --port=8888 \
    --no-browser \
    --allow-root \
    --NotebookApp.token='' \
    --NotebookApp.password='' & \
  echo 'Starting ComfyUI :8188' && \
  cd /opt/app/ComfyUI && \
  /opt/app/.venv/bin/python main.py --listen 0.0.0.0 --port 8188 \
"]
