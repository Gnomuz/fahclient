FROM nvidia/opencl:devel-ubuntu16.04


# Detect GPU indexes automatically
ENV DI=detect
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Install various libs
RUN apt-get update && apt-get install -y \ 
    bzip2 \
    ca-certificates \
    kmod \
    procps \
    libcurl3 \  
    libjansson4 \
    tzdata \  
    wget \
    htop \
    nano \
&& apt-get upgrade \
&& rm -rf /var/lib/apt/lists/*  \
&& apt-get clean

# Support for the latest NVIDA GPUS RTX3080/90s
RUN wget https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.6/fahclient_7.6.21_amd64.deb
RUN dpkg -i fahclient_7.6.21_amd64.deb
RUN rm -f fahclient_7.6.21_amd64.deb

RUN wget https://raw.githubusercontent.com/gnomuz/fahclient/master/config.xml -O /etc/fahclient/config.xml


ENTRYPOINT ["/usr/bin/FAHClient"]
CMD ["--user=Anonymous", "--team=0", "--gpu=true", "--smp=true"]
