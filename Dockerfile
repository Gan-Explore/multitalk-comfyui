FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-venv \
    python3-pip \
    git \
    wget \
    ffmpeg \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

RUN python3.10 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --upgrade pip

# Torch 2.6 + CUDA 12.1
RUN pip install \
    torch==2.6.0 \
    torchvision==0.21.0 \
    torchaudio==2.6.0 \
    --index-url https://download.pytorch.org/whl/cu121

RUN pip install \
    numpy==1.26.4 \
    transformers==4.47.1 \
    huggingface_hub==0.25.2 \
    safetensors \
    sentencepiece \
    accelerate \
    einops \
    pyyaml \
    tqdm

# ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

WORKDIR /workspace/ComfyUI/custom_nodes

# WanVideoWrapper (pinned, MultiTalk-stable)
RUN git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git && \
    cd ComfyUI-WanVideoWrapper && \
    git checkout 7ebdcd4

RUN git clone https://github.com/rgthree/rgthree-comfy.git
RUN git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git

WORKDIR /workspace/ComfyUI

EXPOSE 8188

CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]

