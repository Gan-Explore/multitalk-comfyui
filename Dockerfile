FROM ghcr.io/gan-explore/multitalk-comfyui-base:1.0

# ============================================================
# Install JupyterLab (ONLY allowed runtime addition)
# ============================================================
RUN pip install --no-cache-dir \
    jupyterlab==4.1.6 \
    ipykernel==6.29.3

# ============================================================
# Ports
# ============================================================
EXPOSE 8188 8888

# ============================================================
# Appliance startup
# - No installs
# - No upgrades
# - No mutation
# ============================================================
CMD bash -c "\
  echo '=== InfiniteTalk-MultiTalk Appliance v1.0 ==='; \
  echo 'Starting JupyterLab on :8888 (no auth)'; \
  jupyter lab \
    --notebook-dir=/workspace \
    --ip=0.0.0.0 \
    --port=8888 \
    --no-browser \
    --allow-root \
    --ServerApp.token='' \
    --ServerApp.password='' \
    --ServerApp.disable_check_xsrf=True \
    --ServerApp.allow_origin='*' & \
  \
  echo 'Starting ComfyUI on :8188'; \
  python main.py --listen 0.0.0.0 --port 8188 \
"
