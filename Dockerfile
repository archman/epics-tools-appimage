FROM tonyzhang/xenial-appimage:latest
LABEL maintainer="Tong Zhang <zhangt@frib.msu.edu>"

# WORKDIR /appbuilder

ADD func.sh /
ADD entrypoint.sh .
RUN echo ". /func.sh" >> /etc/bash.bashrc
