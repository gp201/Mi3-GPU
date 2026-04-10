FROM docker.io/nvidia/cuda:12.8.0-base-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV XDG_CACHE_HOME=/app/cache
ENV MPLCONFIGDIR=/app/

RUN mkdir -p $XDG_CACHE_HOME && chmod a+rwx $XDG_CACHE_HOME

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 \
    python3.10-dev \
    python3-pip \
    gcc \
    git \
    ocl-icd-opencl-dev \
    clinfo \
    opencl-headers \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 \
    && mkdir -p /etc/OpenCL/vendors \
    && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .
RUN pip3 install --no-cache-dir setuptools==69.5.1 wheel setuptools-git-versioning \
    "numpy>=2.0" "scipy>=1.0.0" pyopencl configargparse biopython

RUN pip3 install --no-cache-dir --no-build-isolation .

RUN Mi3.py infer -h

ENTRYPOINT ["Mi3.py"]
