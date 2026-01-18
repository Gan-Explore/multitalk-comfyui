FROM ghcr.io/gan-explore/multitalk-comfyui-base:1.0

EXPOSE 8188

CMD bash -c "\
  if command -v nvidia-smi >/dev/null 2>&1; then \
    pip install --no-cache-dir \
      torch==2.6.0 \
      torchvision==0.21.0 \
      torchaudio==2.6.0 \
      --index-url https://download.pytorch.org/whl/cu121; \
  fi && \
  python main.py --listen 0.0.0.0 --port 8188 \
"
