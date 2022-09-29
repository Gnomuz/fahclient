# Folding@home GPU Container

# CUDA 9.2 is chosen for the default tag to be compatible with all drivers v396+ and most decent vast.ai instances
FROM nvidia/cuda:9.2-base-ubuntu20.04
LABEL description="Fork from Official Folding@home GPU Container for vast.ai instances"

# Detect GPU indexes automatically
ENV DI=detect
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Install various libs and useful packages and update all packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ocl-icd-opencl-dev \
      clinfo \
      curl \
      bzip2 \
      ca-certificates \
      kmod \
      procps \
      libjansson4 \
      tzdata \  
      wget \
      xmlstarlet \
      htop \
      nano \
    && apt-get upgrade -y \
    # point at lib mapped in by container runtime
    && mkdir -p /etc/OpenCL/vendors \
    && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd \
    # next line gets past the fahclient.postinst
    && mkdir -p /etc/fahclient && touch /etc/fahclient/config.xml \
    # download and verify checksum
    && curl -fsSL \
      https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.6/fahclient_7.6.21_amd64.deb \
      -o fah.deb \
    && echo "2827f05f1c311ee6c7eca294e4ffb856c81957e8f5bfc3113a0ed27bb463b094 fah.deb" \
      | sha256sum -c --strict - \
    # install fah client
    && DEBIAN_FRONTEND=noninteractive dpkg --install --force-depends fah.deb \
    # cleanup
    && rm -rf fah.deb \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* \
    && apt-get clean

# Download customized config.xml
RUN wget https://raw.githubusercontent.com/gnomuz/fahclient/master/config.xml -O /etc/fahclient/config.xml
# Download startup script for vast.ai instances and make it executable
RUN wget https://raw.githubusercontent.com/gnomuz/fahclient/master/fah_autorun.sh -O /root/fah_autorun.sh \
&& chmod +x /root/fah_autorun.sh

#ENTRYPOINT ["/usr/bin/FAHClient"]
#CMD ["--user=Anonymous", "--team=0", "--gpu=true"]
