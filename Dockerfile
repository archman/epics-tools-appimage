FROM ubuntu:16.04
LABEL maintainer="Tong Zhang <zhangt@frib.msu.edu>"

WORKDIR /appbuilder

ADD https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage .
COPY tux.png /tmp
RUN chmod +x linuxdeploy-x86_64.AppImage && \
    ./linuxdeploy-x86_64.AppImage --appimage-extract && \
    mv squashfs-root /opt && \
    rm linuxdeploy-x86_64.AppImage && \
    ln -s /opt/squashfs-root/AppRun /usr/local/bin/linuxdeploy

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        wget build-essential file && \
    rm -rf /var/lib/apt/lists/*
