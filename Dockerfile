FROM ghcr.io/gan-explore/multitalk-comfyui-base:1.0

EXPOSE 8188

CMD bash -c "\
  echo 'Installing CUDA-compatible torch (runtime)...'; \
  pip install --no-cache-dir torch torchvision torchaudio || true; \
  echo 'Starting ComfyUI...'; \
  python main.py --listen 0.0.0.0 --port 8188 \
"
