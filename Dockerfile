FROM nvidia/opencl:devel-ubuntu16.04


# Detect GPU indexes automatically
ENV DI=detect
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Install various libs and update all packages
RUN apt-get update && apt-get install -y \ 
    curl \
    bzip2 \
    ca-certificates \
    kmod \
    procps \
    libcurl3 \  
    libjansson4 \
    tzdata \  
    wget \
    xmlstarlet \
    htop \
    nano \
&& apt-get upgrade -y\
&& rm -rf /var/lib/apt/lists/*  \
&& apt-get clean

# Install fahclient 7.6.21
RUN curl -fsSL \
      https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.6/fahclient_7.6.21_amd64.deb \
      -o fahclient.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg --install --force-depends fahclient.deb
RUN rm -f fahclient.deb

# Download customized config.xml
RUN wget https://raw.githubusercontent.com/gnomuz/fahclient/master/config.xml -O /etc/fahclient/config.xml
# Download startup script for vast.ai instances
RUN wget https://raw.githubusercontent.com/gnomuz/fahclient/master/fah_autorun.sh -O /root/fah_autorun.sh

#ENTRYPOINT ["/usr/bin/FAHClient"]
#CMD ["--user=Anonymous", "--team=0", "--gpu=true"]
