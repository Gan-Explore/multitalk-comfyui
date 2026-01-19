FROM ghcr.io/gan-explore/multitalk-comfyui-base:1.0

EXPOSE 8188

CMD bash -c "\
  set -e; \
  echo 'Installing CUDA-compatible torch (runtime)...'; \
  pip install --no-cache-dir torch torchvision torchaudio; \
  \
  echo 'Reasserting pinned HF / diffusion stack...'; \
  pip install --no-cache-dir \
    diffusers==0.27.2 \
    huggingface_hub==0.23.5 \
    transformers==4.39.3; \
  \
  echo 'Sanity-checking ComfyUI core...'; \
  python -c \"import comfy.sd, comfy.supported_models; print('ComfyUI core OK')\"; \
  \
  echo 'Starting ComfyUI...'; \
  python main.py --listen 0.0.0.0 --port 8188 \
"
