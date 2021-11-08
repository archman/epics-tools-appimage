FROM tonyzhang/xenial-appimage:latest
LABEL maintainer="Tong Zhang <zhangt@frib.msu.edu>"

# WORKDIR /appbuilder

ADD func.sh /
ADD entrypoint.sh /
ADD entrypoint.desktop /
ADD EPICS_Logo-192x192.png /
RUN echo ". /func.sh" >> /etc/bash.bashrc
